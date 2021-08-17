#lang racket
(require
 "a7-graph-lib.rkt"
 "a7-compiler-lib.rkt"
 "util.rkt")

(provide
  localize-assignment
  merge-conflicts
  merge-locals
  undead-analysis)

(module+ test
  (require rackunit))

;; Undead-set is (listof aloc)
;; interp. a set of undead alocs at a particular instruction

;; Any -> Boolean
;; produce true if the given object is an Undead-set, false otherwise.
(define (undead-set? x)
  (and (list? x)
       (andmap loc? x)
       (= (set-count x) (length x))))
 
; (module+ test
;   (check-true (undead-set? '(a.1 b.2 c.3)))
;   (check-false (undead-set? '(L.abel.1 a.2)))
;   (check-false (undead-set? '(a.1 b.2 a.1))))

;; Undead-set-tree is one of:
;; - Undead-set
;; - (list Undead-set Undead-set-tree Undead-set-tree)
;; - (listof Undead-set)
;; WARNING: datatype is non-canonical since Undead-set-tree can be an
;;          Undead-set, so second and third case can overlap.
;;          An Undead-set-tree is meant to be traversed simultaneously with an
;;          Undead-block-lang/tail, so this ambiguity is not a problem.
;; interp. a tree of Undead-sets.  The structure of the tree mirrors the
;;   structure of a Block-locals-lang tail. There are three kinds of sub-trees:
;; 1) an instruction node is simply an undead sets;
;; 2) an if node has an undead-set for the condition and two branch sub-trees.
;; 3) a begin node is a list of undead sets, culminating in a sub-tree;
;;
;; E.g. the following tree corresponds to the subsequent pseudo-tail,
;; where cmp's and s's are replaced with corresponding undead alloc annotations.
(module+ test
  (define UST1
    `((x.1 y.2)
      (z.2 a.4)
      ((b.5 c.6)
       (c.6 d.7)
       ((e.8 f.9 g.10)
        (f.9)
        ((f.9)
         (g.10)))))))

;; (begin
;;    (undead x y)
;;    (undead z a)
;;    (begin
;;       (undead b c)
;;       (undead c d)
;;       (if (undead e f g)
;;           (undead f)
;;           (begin
;;              (undead f)
;;              (undead g)))))

;; Any -> Boolean
;; produce true if the given object is an Undead-set-tree, false otherwise.
(define (undead-set-tree? ust)
  (match ust
    ; for an instruction
    [(? undead-set?) #t]
    ; for a return point
    [(list (? undead-set?) (? undead-set-tree?)) #t]
    ; for an if
    [(list (? undead-set?) (? undead-set-tree?) (? undead-set-tree?)) #t]
    ; for a begin
    [`(,(? undead-set-tree?) ...) #t]
    [else #f]))

; (module+ test
;   (check-true (undead-set-tree? UST1))
;   (let ([ust1 '((e.8 f.9 g.10)
;                 (f.9)
;                 ((f.9)
;                  (g.10)))]
;         [ust2 '((f.9)
;                 (g.10))])
;     (check-false (undead-set-tree? (list ust1 ust1)))
;     (check-false (undead-set-tree? (list ust1 ust1 ust1)))
;     (check-false (undead-set-tree? (list ust2 ust2)))
;     (check-false (undead-set-tree? (list ust2 ust2 ust2)))))

;; Template for Undead-set-tree
#;(define (fn-for-undead-set-tree ust)
  (local [(define (fn-for-undead-set us)
            (... us))
          (define (fn-for-undead-set-list us*)
            (cond
              [(empty? us*) (...)]
              [else (... (first us*)
                         (fn-for-undead-set-list (rest us*)))]))
          (define (fn-for-undead-set-tree ust)
            (match ust
              [us
               #:when (undead-set? us)
               (... (fn-for-undead-set us))]
              [(list us ust1 ust2)
               #:when (and (undead-set? us)
                           (undead-set-tree? ust1)
                           (undead-set-tree? ust2))
               (... (fn-for-undead-set us)
                    (fn-for-undead-set-tree ust1)
                    (fn-for-undead-set-tree ust2))]
              [`(,us* ...)
               #:when (andmap undead-set? us*)
               (... (fn-for-undead-set-list us*))]))]
    (fn-for-undead-set-tree ust)))

;; Instruction is one of:
;; - Block-locals-lang/s
;; - (if cmp tail tail)
;; interp. the Block-locals-lang expressions referred to by instruction-nodes.

;; Instruction-node is an eq?-able node in a graph containing def and use
;; information for undead analysis.
;;
;; Assumption: the instruction-node-instruction is eq?-able to the instruction
;; in the Block-locals-lang program from which the instruction-node is
;; generated.
(struct instruction-node (instruction defs uses)
  #:transparent)

;; Control-Flow-Graph is a directed graph whose vertexes are Instruction-node.
;; The graph represents per-instruction successor (explicitly) and predecessor
;; (implicitly) information.

; Sanity check
; (module+ test
;   (let* ([x (instruction-node `(halt 5) '() '())]
;          [ls (list x x)])
;     (check-eq? (first ls) (second ls)
;                "Instructions are identified using eq?")))


;; Check that pointer equality on instructions is preserved.
;; This is important for traversing graphs and associating information back to
;; instructions.
; (module+ test
;   (let* ([x '(module (define L.jump () (jump L.jump)))]
;          [y (block-locals-lang->cfg x)])
;     (check-eq?
;      (car (second (car y)))
;      (car (car y)))
;     (check-eq?
;      (instruction-node-instruction (car (second (car y))))
;      (fourth (second x)))))

;; (listof (listof Aloc)) -> (listof Aloc)
;; Given a list of locals declarations, merge them into a single set of the all
;; abstract locations.
(define (merge-locals ls)
  (for/fold ([globals '()])
            ([l ls])
    (set-union globals l)))

;; (listof Conflict-graph) -> Conflict-graph
;; Given a set of all abstract locations in the program, and a list of conflict
;; graphs, merge the conflict graphs into one global conflict graph.
(define (merge-conflicts lsg)
  (for/fold ([g (new-graph)])
            ([conflictg lsg])
    (for/fold ([g g])
              ([(vertex edges) (in-dict conflictg)])
      (add-edges^ g vertex (car edges)))))

;; (setof Aloc) Assignment -> Assignment
;; Given a set of locals from a block and a global assignment, return a local
;; assignment for the block.
(define (localize-assignment locals assignment)
  (for/fold ([asn '()])
            ([var locals])
    (info-set asn var (info-ref assignment var))))

;; Graph Vertex -> (Listof Vertex)
;; Adds a vertex between v1 and each of the vs, but first ensures that the
;; vertexes exist in the graph.
(define (add-edges^ g v1 vs)
  (define all-vs (dict-keys g))
  (let ([g (for/fold ([g g])
                     ([v (cons v1 vs)])
             (if (member v all-vs)
                 g
                 (add-vertex g v)))])
    (add-edges g v1 vs)))
  
  
; Exercise 4
;; Block-locals-lang/p -> (values Env Control-Flow-Graph)
;; produce a control-flow graph and corresponding label map for a given program

(define (indexed-blk->cfg b)
    (define cfg (new-graph))

    (define (index->uses index)
      (match index
        [(? integer?) '()]
        [_ (list index)]))

    (define (opand->uses opand)
      (match opand
        [(? integer?) '()]
        [_ (list opand)]))
    
    ;; trg -> (listof aloc)
    ;; collect any aloc uses from trg
    (define (trg->uses trg)
      (match trg
        [(? label?) '()]
        [_ (list trg)]))

    ;; triv -> (listof aloc)
    ;; collect any aloc uses from triv
    (define (triv->uses triv)
      (match triv
        [(? label?) '()]
        [_ (opand->uses triv)]))

    ;; s -> node entries
    ;; Create an Instruction node corresponding to given statement
    (define (stmt->inst-node s)
      (match s
        [`(,i (set! ,loc1 (mref ,loc2 ,index)))
         (let ([node (instruction-node s (list loc1) 
                                      (remove-duplicates (cons loc2 (index->uses index))))])
          (begin (set! cfg (add-vertex cfg node))
                 (values node (list node))))]
        [`(,i (set! ,loc1 (,binop ,loc2 ,opand)))
         (let ([node (instruction-node s (list loc1) 
                                      (remove-duplicates (cons loc2 (opand->uses opand))))])
          (begin (set! cfg (add-vertex cfg node))
                 (values node (list node))))]
        [`(,i (set! ,loc ,triv))
        (let ([node (instruction-node s (list loc) (triv->uses triv))])
          (begin (set! cfg (add-vertex cfg node))
                 (values node (list node))))]
        [`(,i (mset! ,loc ,index ,triv))
         (let ([node (instruction-node s empty 
                                      (remove-duplicates (append (list loc) 
                                                                 (index->uses index)
                                                                 (triv->uses triv))))])
          (begin (set! cfg (add-vertex cfg node))
                 (values node (list node))))]
        [`(,i (return-point ,label ,tail))
          (let ([node (instruction-node s (list (current-return-value-register)) empty)]
                [tail-entries (tail->cfg tail)])
            (begin (set! cfg (add-vertex cfg node))
                   (values node (cons node tail-entries))))]))

    ;; Control-flow-graph Env tail
    ;;   -> entries
    ;; produce a cfg for the given tail, as well as its entry node.
    (define (tail->cfg tail)
      (match tail
        [`(begin ,ss ... ,t)
         (let ([tail-entries (tail->cfg t)])
            (for/fold ([succs tail-entries])
                      ([s (reverse ss)])
                (let-values ([(node entries) (stmt->inst-node s)])
                  (begin (for ([succ succs]) (set! cfg (add-directed-edge cfg node succ)))
                         entries))))]
        [`(,i (if (,cmp ,aloc ,opand) ,tail1 ,tail2))
        (let ([entries^1 (tail->cfg tail1)]
              [entries^2 (tail->cfg tail2)]
              [node (instruction-node tail '() (set-union (list aloc) (opand->uses opand)))])
            (begin (set! cfg (add-vertex cfg node))
                   (for ([entry entries^1]) (set! cfg (add-directed-edge cfg node entry)))
                   (for ([entry entries^2]) (set! cfg (add-directed-edge cfg node entry)))
                   (list node)))]
        [`(,i (jump ,trg ,alocs ...))
        (let ([node (instruction-node tail '() (set-union (trg->uses trg) alocs))])
            (begin (set! cfg (add-vertex cfg node))
                   (list node)))]))

    (match b
      [`(define ,label ,info ,indexed-tail)
       (begin (tail->cfg indexed-tail) cfg)]))

(module+ test
   (check-equal? 
    (indexed-blk->cfg
      '(define L.tmp.8.31
            ((new-frames ())
            (locals (tmp.122 |+.49| x.5 c.115 ra.363)))
            (begin
                (0 (set! ra.363 r15))
                (1 (set! c.115 rdi))
                (2 (set! x.5 rsi))
                (3 (set! |+.49| (mref c.115 14)))
                (4 (set! tmp.122 |+.49|))
                (5 (set! rdx 8))
                (6 (set! rsi x.5))
                (7 (set! rdi |+.49|))
                (8 (set! r15 ra.363))
                (9 (jump L.+.49.29 rbp r15 rdx rsi rdi)))))
    (list
      (list
        (instruction-node '(0 (set! ra.363 r15)) '(ra.363) '(r15))
        (list (instruction-node '(1 (set! c.115 rdi)) '(c.115) '(rdi))))
      (list
        (instruction-node '(1 (set! c.115 rdi)) '(c.115) '(rdi))
        (list (instruction-node '(2 (set! x.5 rsi)) '(x.5) '(rsi))))
      (list
        (instruction-node '(2 (set! x.5 rsi)) '(x.5) '(rsi))
        (list
        (instruction-node '(3 (set! |+.49| (mref c.115 14))) '(|+.49|) '(c.115))))
      (list
        (instruction-node '(3 (set! |+.49| (mref c.115 14))) '(|+.49|) '(c.115))
        (list (instruction-node '(4 (set! tmp.122 |+.49|)) '(tmp.122) '(|+.49|))))
      (list
        (instruction-node '(4 (set! tmp.122 |+.49|)) '(tmp.122) '(|+.49|))
        (list (instruction-node '(5 (set! rdx 8)) '(rdx) '())))
      (list
        (instruction-node '(5 (set! rdx 8)) '(rdx) '())
        (list (instruction-node '(6 (set! rsi x.5)) '(rsi) '(x.5))))
      (list
        (instruction-node '(6 (set! rsi x.5)) '(rsi) '(x.5))
        (list (instruction-node '(7 (set! rdi |+.49|)) '(rdi) '(|+.49|))))
      (list
        (instruction-node '(7 (set! rdi |+.49|)) '(rdi) '(|+.49|))
        (list (instruction-node '(8 (set! r15 ra.363)) '(r15) '(ra.363))))
      (list
        (instruction-node '(8 (set! r15 ra.363)) '(r15) '(ra.363))
        (list
        (instruction-node
          '(9 (jump L.+.49.29 rbp r15 rdx rsi rdi))
          '()
          '(rdi rsi rdx r15 rbp))))
      (list
        (instruction-node
        '(9 (jump L.+.49.29 rbp r15 rdx rsi rdi))
        '()
        '(rdi rsi rdx r15 rbp))
        '())))
            
   (check-equal? 
    (indexed-blk->cfg
      '(define L.cons.72.6
                ((new-frames ())
                (locals (tmp.126 tmp.412 tmp.253 tmp.45 tmp.44 c.90 ra.411)))
                (begin
                    (0 (set! ra.411 r15))
                    (1 (set! c.90 rdi))
                    (2 (set! tmp.44 rsi))
                    (3 (set! tmp.45 rdx))
                    (4 (set! tmp.253 r12))
                    (5 (set! r12 (+ r12 16)))
                    (6 (set! tmp.412 (+ tmp.253 1)))
                    (7 (set! tmp.126 tmp.412))
                    (8 (mset! tmp.126 -1 tmp.44))
                    (9 (mset! tmp.126 7 tmp.45))
                    (10 (set! rax tmp.126))
                    (11 (jump ra.411 rbp rax)))))
    (list
      (list
        (instruction-node '(0 (set! ra.411 r15)) '(ra.411) '(r15))
        (list (instruction-node '(1 (set! c.90 rdi)) '(c.90) '(rdi))))
      (list
        (instruction-node '(1 (set! c.90 rdi)) '(c.90) '(rdi))
        (list (instruction-node '(2 (set! tmp.44 rsi)) '(tmp.44) '(rsi))))
      (list
        (instruction-node '(2 (set! tmp.44 rsi)) '(tmp.44) '(rsi))
        (list (instruction-node '(3 (set! tmp.45 rdx)) '(tmp.45) '(rdx))))
      (list
        (instruction-node '(3 (set! tmp.45 rdx)) '(tmp.45) '(rdx))
        (list (instruction-node '(4 (set! tmp.253 r12)) '(tmp.253) '(r12))))
      (list
        (instruction-node '(4 (set! tmp.253 r12)) '(tmp.253) '(r12))
        (list (instruction-node '(5 (set! r12 (+ r12 16))) '(r12) '(r12))))
      (list
        (instruction-node '(5 (set! r12 (+ r12 16))) '(r12) '(r12))
        (list
        (instruction-node '(6 (set! tmp.412 (+ tmp.253 1))) '(tmp.412) '(tmp.253))))
      (list
        (instruction-node '(6 (set! tmp.412 (+ tmp.253 1))) '(tmp.412) '(tmp.253))
        (list (instruction-node '(7 (set! tmp.126 tmp.412)) '(tmp.126) '(tmp.412))))
      (list
        (instruction-node '(7 (set! tmp.126 tmp.412)) '(tmp.126) '(tmp.412))
        (list
        (instruction-node '(8 (mset! tmp.126 -1 tmp.44)) '() '(tmp.126 tmp.44))))
      (list
        (instruction-node '(8 (mset! tmp.126 -1 tmp.44)) '() '(tmp.126 tmp.44))
        (list
        (instruction-node '(9 (mset! tmp.126 7 tmp.45)) '() '(tmp.126 tmp.45))))
      (list
        (instruction-node '(9 (mset! tmp.126 7 tmp.45)) '() '(tmp.126 tmp.45))
        (list (instruction-node '(10 (set! rax tmp.126)) '(rax) '(tmp.126))))
      (list
        (instruction-node '(10 (set! rax tmp.126)) '(rax) '(tmp.126))
        (list (instruction-node '(11 (jump ra.411 rbp rax)) '() '(rax rbp ra.411))))
      (list
        (instruction-node '(11 (jump ra.411 rbp rax)) '() '(rax rbp ra.411))
        '())))

   (check-equal? 
    (indexed-blk->cfg
      '(define L.jp.108
                ((new-frames ())
                (locals (tmp.317 tmp.321 ra.427 sub1.6 tmp.323 add1.4 tmp.322 tmp.125)))
                (begin
                    (0 (set! ra.427 r15))
                    (1 (set! tmp.321 rdi))
                    (2 (set! tmp.125 rsi))
                    (3 (set! tmp.317 rdx))
                    (4 (set! sub1.6 rcx))
                    (5 (set! add1.4 r8))
                    (6 (if (neq? tmp.321 6)
                        (begin
                            (7 (set! tmp.322 (mref tmp.125 -2)))
                            (8 (return-point L.rp.113
                              (begin
                                  (9 (set! rsi 16))
                                  (10 (set! rdi add1.4))
                                  (11 (set! r15 L.rp.113))
                                  (12 (jump tmp.322 rbp r15 rsi rdi)))))
                            (13 (set! tmp.323 rax))
                            (14 (set! rsi tmp.323))
                            (15 (set! rdi sub1.6))
                            (16 (set! r15 ra.427))
                            (17 (jump tmp.317 rbp r15 rsi rdi)))
                        (begin
                            (18 (set! rsi 10814))
                            (19 (set! rdi sub1.6))
                            (20 (set! r15 ra.427))
                            (21 (jump tmp.317 rbp r15 rsi rdi))))))))
    (list
      (list
        (instruction-node '(0 (set! ra.427 r15)) '(ra.427) '(r15))
        (list (instruction-node '(1 (set! tmp.321 rdi)) '(tmp.321) '(rdi))))
      (list
        (instruction-node '(1 (set! tmp.321 rdi)) '(tmp.321) '(rdi))
        (list (instruction-node '(2 (set! tmp.125 rsi)) '(tmp.125) '(rsi))))
      (list
        (instruction-node '(2 (set! tmp.125 rsi)) '(tmp.125) '(rsi))
        (list (instruction-node '(3 (set! tmp.317 rdx)) '(tmp.317) '(rdx))))
      (list
        (instruction-node '(3 (set! tmp.317 rdx)) '(tmp.317) '(rdx))
        (list (instruction-node '(4 (set! sub1.6 rcx)) '(sub1.6) '(rcx))))
      (list
        (instruction-node '(4 (set! sub1.6 rcx)) '(sub1.6) '(rcx))
        (list (instruction-node '(5 (set! add1.4 r8)) '(add1.4) '(r8))))
      (list
        (instruction-node '(5 (set! add1.4 r8)) '(add1.4) '(r8))
        (list
        (instruction-node
          '(6
            (if (neq? tmp.321 6)
                (begin
                  (7 (set! tmp.322 (mref tmp.125 -2)))
                  (8
                  (return-point L.rp.113
                                (begin
                                  (9 (set! rsi 16))
                                  (10 (set! rdi add1.4))
                                  (11 (set! r15 L.rp.113))
                                  (12 (jump tmp.322 rbp r15 rsi rdi)))))
                  (13 (set! tmp.323 rax))
                  (14 (set! rsi tmp.323))
                  (15 (set! rdi sub1.6))
                  (16 (set! r15 ra.427))
                  (17 (jump tmp.317 rbp r15 rsi rdi)))
                (begin
                  (18 (set! rsi 10814))
                  (19 (set! rdi sub1.6))
                  (20 (set! r15 ra.427))
                  (21 (jump tmp.317 rbp r15 rsi rdi)))))
          '()
          '(tmp.321))))
      (list
        (instruction-node
        '(6
          (if (neq? tmp.321 6)
              (begin
                (7 (set! tmp.322 (mref tmp.125 -2)))
                (8
                  (return-point L.rp.113
                                (begin
                                  (9 (set! rsi 16))
                                  (10 (set! rdi add1.4))
                                  (11 (set! r15 L.rp.113))
                                  (12 (jump tmp.322 rbp r15 rsi rdi)))))
                (13 (set! tmp.323 rax))
                (14 (set! rsi tmp.323))
                (15 (set! rdi sub1.6))
                (16 (set! r15 ra.427))
                (17 (jump tmp.317 rbp r15 rsi rdi)))
              (begin
                (18 (set! rsi 10814))
                (19 (set! rdi sub1.6))
                (20 (set! r15 ra.427))
                (21 (jump tmp.317 rbp r15 rsi rdi)))))
        '()
        '(tmp.321))
        (list
        (instruction-node '(18 (set! rsi 10814)) '(rsi) '())
        (instruction-node
          '(7 (set! tmp.322 (mref tmp.125 -2)))
          '(tmp.322)
          '(tmp.125))))
      (list
        (instruction-node '(18 (set! rsi 10814)) '(rsi) '())
        (list (instruction-node '(19 (set! rdi sub1.6)) '(rdi) '(sub1.6))))
      (list
        (instruction-node '(19 (set! rdi sub1.6)) '(rdi) '(sub1.6))
        (list (instruction-node '(20 (set! r15 ra.427)) '(r15) '(ra.427))))
      (list
        (instruction-node '(20 (set! r15 ra.427)) '(r15) '(ra.427))
        (list
        (instruction-node
          '(21 (jump tmp.317 rbp r15 rsi rdi))
          '()
          '(rdi rsi r15 rbp tmp.317))))
      (list
        (instruction-node
        '(21 (jump tmp.317 rbp r15 rsi rdi))
        '()
        '(rdi rsi r15 rbp tmp.317))
        '())
      (list
        (instruction-node
        '(7 (set! tmp.322 (mref tmp.125 -2)))
        '(tmp.322)
        '(tmp.125))
        (list
        (instruction-node '(9 (set! rsi 16)) '(rsi) '())
        (instruction-node
          '(8
            (return-point L.rp.113
                          (begin
                            (9 (set! rsi 16))
                            (10 (set! rdi add1.4))
                            (11 (set! r15 L.rp.113))
                            (12 (jump tmp.322 rbp r15 rsi rdi)))))
          '(rax)
          '())))
      (list
        (instruction-node
        '(8
          (return-point L.rp.113
                        (begin
                          (9 (set! rsi 16))
                          (10 (set! rdi add1.4))
                          (11 (set! r15 L.rp.113))
                          (12 (jump tmp.322 rbp r15 rsi rdi)))))
        '(rax)
        '())
        (list (instruction-node '(13 (set! tmp.323 rax)) '(tmp.323) '(rax))))
      (list
        (instruction-node '(9 (set! rsi 16)) '(rsi) '())
        (list (instruction-node '(10 (set! rdi add1.4)) '(rdi) '(add1.4))))
      (list
        (instruction-node '(10 (set! rdi add1.4)) '(rdi) '(add1.4))
        (list (instruction-node '(11 (set! r15 L.rp.113)) '(r15) '())))
      (list
        (instruction-node '(11 (set! r15 L.rp.113)) '(r15) '())
        (list
        (instruction-node
          '(12 (jump tmp.322 rbp r15 rsi rdi))
          '()
          '(rdi rsi r15 rbp tmp.322))))
      (list
        (instruction-node
        '(12 (jump tmp.322 rbp r15 rsi rdi))
        '()
        '(rdi rsi r15 rbp tmp.322))
        '())
      (list
        (instruction-node '(13 (set! tmp.323 rax)) '(tmp.323) '(rax))
        (list (instruction-node '(14 (set! rsi tmp.323)) '(rsi) '(tmp.323))))
      (list
        (instruction-node '(14 (set! rsi tmp.323)) '(rsi) '(tmp.323))
        (list (instruction-node '(15 (set! rdi sub1.6)) '(rdi) '(sub1.6))))
      (list
        (instruction-node '(15 (set! rdi sub1.6)) '(rdi) '(sub1.6))
        (list (instruction-node '(16 (set! r15 ra.427)) '(r15) '(ra.427))))
      (list
        (instruction-node '(16 (set! r15 ra.427)) '(r15) '(ra.427))
        (list
        (instruction-node
          '(17 (jump tmp.317 rbp r15 rsi rdi))
          '()
          '(rdi rsi r15 rbp tmp.317))))
      (list
        (instruction-node
        '(17 (jump tmp.317 rbp r15 rsi rdi))
        '()
        '(rdi rsi r15 rbp tmp.317))
        '())))
    )

(define (index-blk b)
  (define counter -1)
  (define (get-count) (begin (set! counter (add1 counter)) counter))
  (define (reset-counter) (set! counter -1))

  (define (index-s s)
    (match s
      [`(set! ,any ...)
       `(,(get-count) ,s)]
      [`(mset! ,any ...)
       `(,(get-count) ,s)]
      [`(return-point ,label ,tail) 
       `(,(get-count) (return-point ,label ,(index-tail tail)))]))

  ;; Control-flow-graph Env tail
  ;;   -> (values Instruction-node Control-flow-graph)
  ;; produce a cfg for the given tail, as well as its entry node.
  (define (index-tail tail)
    (match tail
      [`(begin ,ss ... ,t)
       (append (list 'begin)
               (map index-s ss)
               (list (index-tail t)))]
      [`(if ,cmp ,t1 ,t2)
       `(,(get-count) (if ,cmp ,(index-tail t1) ,(index-tail t2)))]
      [`(jump ,any ...)
       `(,(get-count) ,tail)]))
    
  (match b
    [`(define ,label ,info ,tail)
      (let ([indexed-tail (index-tail tail)])
        (begin (reset-counter)
                `(define ,label ,info ,indexed-tail)))]))


(module+ test
  (define (index-pgm p)
    (match p
      [`(module ,bs ...)
       (cons 'module (map index-blk bs))]))

   (check-equal? (index-pgm
  '(module
        (define L.tmp.8.31
            ((new-frames ())
            (locals (tmp.122 |+.49| x.5 c.115 ra.363)))
            (begin
                (set! ra.363 r15)
                (set! c.115 rdi)
                (set! x.5 rsi)
                (set! |+.49| (mref c.115 14))
                (set! tmp.122 |+.49|)
                (set! rdx 8)
                (set! rsi x.5)
                (set! rdi |+.49|)
                (set! r15 ra.363)
                (jump L.+.49.29 rbp r15 rdx rsi rdi)))
            (define L.cons.72.6
                ((new-frames ())
                (locals (tmp.126 tmp.412 tmp.253 tmp.45 tmp.44 c.90 ra.411)))
                (begin
                    (set! ra.411 r15)
                    (set! c.90 rdi)
                    (set! tmp.44 rsi)
                    (set! tmp.45 rdx)
                    (set! tmp.253 r12)
                    (set! r12 (+ r12 16))
                    (set! tmp.412 (+ tmp.253 1))
                    (set! tmp.126 tmp.412)
                    (mset! tmp.126 -1 tmp.44)
                    (mset! tmp.126 7 tmp.45)
                    (set! rax tmp.126)
                    (jump ra.411 rbp rax)))
            (define L.jp.108
                ((new-frames ())
                (locals (tmp.317 tmp.321 ra.427 sub1.6 tmp.323 add1.4 tmp.322 tmp.125)))
                (begin
                    (set! ra.427 r15)
                    (set! tmp.321 rdi)
                    (set! tmp.125 rsi)
                    (set! tmp.317 rdx)
                    (set! sub1.6 rcx)
                    (set! add1.4 r8)
                    (if (neq? tmp.321 6)
                        (begin
                            (set! tmp.322 (mref tmp.125 -2))
                            (return-point L.rp.113
                            (begin
                                (set! rsi 16)
                                (set! rdi add1.4)
                                (set! r15 L.rp.113)
                                (jump tmp.322 rbp r15 rsi rdi)))
                            (set! tmp.323 rax)
                            (set! rsi tmp.323)
                            (set! rdi sub1.6)
                            (set! r15 ra.427)
                            (jump tmp.317 rbp r15 rsi rdi))
                        (begin
                            (set! rsi 10814)
                            (set! rdi sub1.6)
                            (set! r15 ra.427)
                            (jump tmp.317 rbp r15 rsi rdi)))))))
            
  '(module
        (define L.tmp.8.31
            ((new-frames ())
            (locals (tmp.122 |+.49| x.5 c.115 ra.363)))
            (begin
                (0 (set! ra.363 r15))
                (1 (set! c.115 rdi))
                (2 (set! x.5 rsi))
                (3 (set! |+.49| (mref c.115 14)))
                (4 (set! tmp.122 |+.49|))
                (5 (set! rdx 8))
                (6 (set! rsi x.5))
                (7 (set! rdi |+.49|))
                (8 (set! r15 ra.363))
                (9 (jump L.+.49.29 rbp r15 rdx rsi rdi))))
            (define L.cons.72.6
                ((new-frames ())
                (locals (tmp.126 tmp.412 tmp.253 tmp.45 tmp.44 c.90 ra.411)))
                (begin
                    (0 (set! ra.411 r15))
                    (1 (set! c.90 rdi))
                    (2 (set! tmp.44 rsi))
                    (3 (set! tmp.45 rdx))
                    (4 (set! tmp.253 r12))
                    (5 (set! r12 (+ r12 16)))
                    (6 (set! tmp.412 (+ tmp.253 1)))
                    (7 (set! tmp.126 tmp.412))
                    (8 (mset! tmp.126 -1 tmp.44))
                    (9 (mset! tmp.126 7 tmp.45))
                    (10 (set! rax tmp.126))
                    (11 (jump ra.411 rbp rax))))
            (define L.jp.108
                ((new-frames ())
                (locals (tmp.317 tmp.321 ra.427 sub1.6 tmp.323 add1.4 tmp.322 tmp.125)))
                (begin
                    (0 (set! ra.427 r15))
                    (1 (set! tmp.321 rdi))
                    (2 (set! tmp.125 rsi))
                    (3 (set! tmp.317 rdx))
                    (4 (set! sub1.6 rcx))
                    (5 (set! add1.4 r8))
                    (6 (if (neq? tmp.321 6)
                        (begin
                            (7 (set! tmp.322 (mref tmp.125 -2)))
                            (8 (return-point L.rp.113
                              (begin
                                  (9 (set! rsi 16))
                                  (10 (set! rdi add1.4))
                                  (11 (set! r15 L.rp.113))
                                  (12 (jump tmp.322 rbp r15 rsi rdi)))))
                            (13 (set! tmp.323 rax))
                            (14 (set! rsi tmp.323))
                            (15 (set! rdi sub1.6))
                            (16 (set! r15 ra.427))
                            (17 (jump tmp.317 rbp r15 rsi rdi)))
                        (begin
                            (18 (set! rsi 10814))
                            (19 (set! rdi sub1.6))
                            (20 (set! r15 ra.427))
                            (21 (jump tmp.317 rbp r15 rsi rdi))))))))))




(define (undead-analysis p)
    (displayln (format "undead ~a" p))
  (match p
    [`(module ,bs ...)
     (cons 'module (map undead-analysis-b bs))]))

(define (undead-analysis-b b)
  (define (construct-undead-sets ins outs indexed-b)
      ;; call-undead is the set of all locations that are live after any non-tail call in a block. 
    (define live-after-return empty)

    (define (add-to-live l)
      (if (empty? l)
          live-after-return
          (if (register? (first l))
              (add-to-live (rest l))
              (if (member (first l) live-after-return)
                  (add-to-live (rest l))
                  (begin (set! live-after-return (cons (first l) live-after-return))
                        (add-to-live (rest l)))))))

    (define (construct-s ins s)
      (match s
        [`(,i (return-point ,label ,tail))
          (set! live-after-return (add-to-live (hash-ref ins s)))
        `(,(hash-ref ins s) ,(construct-tail ins tail))]
        [_ (hash-ref ins s)]))

    ;; Undead-set-map tail -> Undead-set-tree??
    (define (construct-tail ins tail)
      (match tail
        [`(begin ,ss ... ,tail)
          `(,@(map (curry construct-s ins) ss)
            ,(construct-tail ins tail))]
        [`(,i (if ,_ ,tail1 ,tail2))
          `(,(hash-ref ins tail)
            ,(construct-tail ins tail1)
            ,(construct-tail ins tail2))]
        [_ (hash-ref ins tail)]))

      (match indexed-b
        [`(define ,label ,info ,indexed-t)
         (let* (;; [info^1 (info-set info 'undead-in (construct-tail ins indexed-t))]
                [info^2
                (info-set info 'undead-out (construct-tail outs indexed-t))]
                [info^3 (info-set info^2 'call-undead live-after-return)])
          (match b
           [`(define ,label ,_ ,tail)
            `(define ,label ,info^3 ,tail)]))]))

  ;; Undead-set-node-map -> Undead-set-instr-map
  ;; Convert a dictionary that maps Instruction-node to Undead-sets, into a
  ;; dictionary that maps Instruction to an Undead-sets.
  (define (node-dict->instr-dict d)
    (for/fold ([newd (make-immutable-hasheq)])
              ([(key val) (in-dict d)])
      (match key
        [(instruction-node s _ _)
         (hash-set newd s val)])))

  ;; Undead-set-node-map (listof Instruction-node) Undead-set Undead-set
  ;;   -> Instruction-node
  ;; Update the given node's undead sets based on its neighbors
  (define (update-node ins succs undead-in undead-out node)
    (match node
      [(instruction-node rnode defs uses)
          (let ([new-undead-in (set-union uses (set-subtract undead-out defs))]
                [new-undead-out
                    (match rnode 
                      [`(,i (jump ,trg ,locs ...)) locs]
                      [_ (apply set-union (cons '() 
                                                (for/list ([s succs])
                                                          (dict-ref ins s))))])])
         (values new-undead-in new-undead-out
                 (or (not (set=? undead-in new-undead-in))
                     (not (set=? undead-out new-undead-out)))))]))

  (define indexed-b (index-blk b))

  ;; Perform undead analysis on a CFG generated from the Block-locals-lang p
  (define cfg (indexed-blk->cfg indexed-b))

  ;; Get a complete list of instruction nodes from the CFG
  ;; "get-vertexes" graph function isn't implemented: exploiting representation
  (define vs (dict-keys cfg))
  ; (displayln (format "vs ~a" vs))

  ;; Instruction-node -> Undead-set: archetypal undead-ins/undead-outs maps
  (define initial-map (make-immutable-hasheq (for/list ([v vs]) (cons v '()))))

  ; (displayln (format "indexed-b ~a" indexed-b))
  ; (displayln (format ""))
  ; (displayln (format "cfg ~a" cfg))
  ; (displayln (format ""))
  ; (displayln (format "vs ~a" vs))
  ; (displayln (format ""))

 ;; Outer loop repeats full instruction-node traversal until nothing changes
  (let loop ([ins initial-map]
             [outs initial-map])
    (define-values (in out any-changed?)
      ;; Iterate over each instruction-node, updating its ins and outs
      (for/fold ([ins ins]
                 [outs outs]
                 [any-changes-yet? #f])
                ([v vs])
        (let-values ([(undead-in undead-out changed?)
                      (update-node
                       ins
                       (get-neighbors cfg v)
                       (dict-ref ins v)
                       (dict-ref outs v)
                       v)])
          (values (dict-set ins v undead-in)
                  (dict-set outs v undead-out)
                  (or changed? any-changes-yet?)))))
    (if any-changed?
        (loop in out)
        (construct-undead-sets (node-dict->instr-dict in) (node-dict->instr-dict out) indexed-b))))


; (define (undead-analysis p)
;   ; (displayln (format "undead ~a" p))
;   (define (construct-undead-sets ins outs p)
;     (local
;       [

;        ;; Undead-set-map Undead-set-map Block-locals-lang/b
;        ;;   -> Undead-block-lang/b
;        ; The pass should also record in the info field call-undead every abstract 
;        ; location or frame variable that is in the undead-out set of a return point. 
;        ; These must be allocated to the frame in the next pass, and it will save us a
;        ;  traversal if we stash them in the info field.
;        (define (construct-b ins outs b)
;         ;; call-undead is the set of all locations that are live after any non-tail call in a block. 
;         (define live-after-return empty)

;         (define (add-to-live l)
;           (if (empty? l)
;               live-after-return
;               (if (register? (first l))
;                   (add-to-live (rest l))
;                   (if (member (first l) live-after-return)
;                       (add-to-live (rest l))
;                       (begin (set! live-after-return (cons (first l) live-after-return))
;                             (add-to-live (rest l)))))))

;         (define (construct-s ins s)
;          (match s
;            [`(return-point ,label ,tail)
;               (set! live-after-return (add-to-live (hash-ref ins s)))
;             `(,(hash-ref ins s) ,(construct-tail ins tail))]
;            [_ (hash-ref ins s)]))

;         ;; Undead-set-map tail -> Undead-set-tree??
;         (define (construct-tail ins tail)
;           (match tail
;             [`(begin ,ss ... ,tail)
;               `(,@(map (curry construct-s ins) ss)
;                 ,(construct-tail ins tail))]
;             [`(if ,_ ,tail1 ,tail2)
;               `(,(hash-ref ins tail)
;                 ,(construct-tail ins tail1)
;                 ,(construct-tail ins tail2))]
;             [_ (hash-ref ins tail)]))

;          (match b
;            [`(define ,name ,info ,tail)
;             (let* ([info^1 (info-set info 'undead-in (construct-tail ins tail))]
;                    [info^2
;                     (info-set info 'undead-out (construct-tail outs tail))]
;                    [info^3 (info-set info^2 'call-undead live-after-return)])
;             `(define ,name ,info^3 ,tail))]))

;        ;; Undead-set-map Undead-set-map Block-locals-lang/p
;        ;;   -> Undead-block-lang/p
;        (define (construct-p ins outs p)
;          (match p
;            [`(module ,bs ...)
;             (let ([in-dict (node-dict->instr-dict ins)]
;                   [out-dict (node-dict->instr-dict outs)])
;             `(module ,@(for/list ([b bs])
;                          (construct-b in-dict out-dict b))))]))]
;       (construct-p ins outs p)))

;   ;; Undead-set-node-map -> Undead-set-instr-map
;   ;; Convert a dictionary that maps Instruction-node to Undead-sets, into a
;   ;; dictionary that maps Instruction to an Undead-sets.
;   (define (node-dict->instr-dict d)
;     (for/fold ([newd (make-immutable-hasheq)])
;               ([(key val) (in-dict d)])
;       (match key
;         [(instruction-node s _ _)
;          (hash-set newd s val)])))

;   ;; Undead-set-node-map (listof Instruction-node) Undead-set Undead-set
;   ;;   -> Instruction-node
;   ;; Update the given node's undead sets based on its neighbors
;   (define (update-node ins succs undead-in undead-out node)
;     ; (displayln (format "node ~a" node))
;     (match node
;       [(instruction-node rnode defs uses)
;         (match rnode 
;           [`(jump ,trg ,locs ...)
;             (let ([new-undead-in (if (label? trg)
;                                       locs
;                                       (cons trg locs))]
;                   [new-undead-out
;                     locs])
;               (values new-undead-in new-undead-out
;                       (or (not (set=? undead-in new-undead-in))
;                           (not (set=? undead-out new-undead-out)))))]
;           [else (let ([new-undead-in (set-union uses (set-subtract undead-out defs))]
;              [new-undead-out
;               (apply set-union
;                      (cons '() (for/list ([s succs]) 
;                         (begin ;(displayln (format "s is ~a ins is ~a haskey? ~a" s ins (dict-has-key? ins s)))
;                                  (dict-ref ins s)))))])
;          (values new-undead-in new-undead-out
;                  (or (not (set=? undead-in new-undead-in))
;                      (not (set=? undead-out new-undead-out)))))])
;        ]))

;   ;; Perform undead analysis on a CFG generated from the Block-locals-lang p
;   (define cfg (indexed-blk->cfg p))

;   ;; Get a complete list of instruction nodes from the CFG
;   ;; "get-vertexes" graph function isn't implemented: exploiting representation
;   (define vs (dict-keys cfg))
;   ; (displayln (format "vs ~a" vs))

;   ;; Instruction-node -> Undead-set: archetypal undead-ins/undead-outs maps
;   (define initial-map (make-immutable-hasheq (for/list ([v vs]) (cons v '()))))

;  ;; Outer loop repeats full instruction-node traversal until nothing changes
;   (let loop ([ins initial-map]
;              [outs initial-map])
;     (define-values (in out any-changed?)
;       ;; Iterate over each instruction-node, updating its ins and outs
;       (for/fold ([ins ins]
;                  [outs outs]
;                  [any-changes-yet? #f])
;                 ([v vs])
;         (let-values ([(undead-in undead-out changed?)
;                       (update-node
;                        ins
;                        (get-neighbors cfg v)
;                        (dict-ref ins v)
;                        (dict-ref outs v)
;                        v)])
;           (values (dict-set ins v undead-in)
;                   (dict-set outs v undead-out)
;                   (or changed? any-changes-yet?)))))
;     (if any-changed?
;         (loop in out)
;         (construct-undead-sets in out p))))

(module+ test
   (check-match (undead-analysis
  '(module
     (define L.main.3
       ((new-frames ()) (locals (x.3.6 ra.7)))
       (begin
         (set! ra.7 r15)
         (set! x.3.6 L.L.f1.1.2)
         (set! rsi 2)
         (set! rdi 1)
         (set! r15 ra.7)
         (jump x.3.6 rbp r15 rsi rdi)))
     (define L.L.f1.1.2
       ((new-frames ()) (locals (tmp.9 y.2.5 x.1.4 ra.8)))
       (begin
         (set! ra.8 r15)
         (set! x.1.4 rdi)
         (set! y.2.5 rsi)
         (set! tmp.9 (+ x.1.4 y.2.5))
         (set! rax tmp.9)
         (jump ra.8 rbp rax)))))
 `(module
    (define L.main.3
      ((new-frames ())
       (locals (x.3.6 ra.7))
       (undead-out
        ( ,(list-no-order  'ra.7 'rbp)
         ,(list-no-order  'ra.7 'x.3.6 'rbp)
         ,(list-no-order  'ra.7 'x.3.6 'rsi 'rbp)
         ,(list-no-order  'ra.7 'x.3.6 'rdi 'rsi 'rbp)
         ,(list-no-order  'x.3.6 'rdi 'rsi 'r15 'rbp)
         ,(list-no-order  'rdi 'rsi 'r15 'rbp)))
       (call-undead ()))
      (begin
        (set! ra.7 r15)
        (set! x.3.6 L.L.f1.1.2)
        (set! rsi 2)
        (set! rdi 1)
        (set! r15 ra.7)
        (jump x.3.6 rbp r15 rsi rdi)))
    (define L.L.f1.1.2
      ((new-frames ())
       (locals (tmp.9 y.2.5 x.1.4 ra.8))
       (undead-out
        ( ,(list-no-order  'rdi 'rsi 'ra.8 'rbp)
         ,(list-no-order  'rsi 'x.1.4 'ra.8 'rbp)
         ,(list-no-order  'y.2.5 'x.1.4 'ra.8 'rbp)
         ,(list-no-order  'tmp.9 'ra.8 'rbp)
         ,(list-no-order  'ra.8 'rax 'rbp)
         ,(list-no-order  'rax 'rbp)))
       (call-undead ()))
      (begin
        (set! ra.8 r15)
        (set! x.1.4 rdi)
        (set! y.2.5 rsi)
        (set! tmp.9 (+ x.1.4 y.2.5))
        (set! rax tmp.9)
        (jump ra.8 rbp rax)))))


   (check-match (undead-analysis
  '(module
        (define L.tmp.8.31
            ((new-frames ())
            (locals (tmp.122 |+.49| x.5 c.115 ra.363)))
            (begin
                (set! ra.363 r15)
                (set! c.115 rdi)
                (set! x.5 rsi)
                (set! |+.49| (mref c.115 14))
                (set! tmp.122 |+.49|)
                (set! rdx 8)
                (set! rsi x.5)
                (set! rdi |+.49|)
                (set! r15 ra.363)
                (jump L.+.49.29 rbp r15 rdx rsi rdi)))
            (define L.cons.72.6
                ((new-frames ())
                (locals (tmp.126 tmp.412 tmp.253 tmp.45 tmp.44 c.90 ra.411)))
                (begin
                    (set! ra.411 r15)
                    (set! c.90 rdi)
                    (set! tmp.44 rsi)
                    (set! tmp.45 rdx)
                    (set! tmp.253 r12)
                    (set! r12 (+ r12 16))
                    (set! tmp.412 (+ tmp.253 1))
                    (set! tmp.126 tmp.412)
                    (mset! tmp.126 -1 tmp.44)
                    (mset! tmp.126 7 tmp.45)
                    (set! rax tmp.126)
                    (jump ra.411 rbp rax)))
            (define L.jp.108
                ((new-frames ())
                (locals (tmp.317 tmp.321 ra.427 sub1.6 tmp.323 add1.4 tmp.322 tmp.125)))
                (begin
                    (set! ra.427 r15)
                    (set! tmp.321 rdi)
                    (set! tmp.125 rsi)
                    (set! tmp.317 rdx)
                    (set! sub1.6 rcx)
                    (set! add1.4 r8)
                    (if (neq? tmp.321 6)
                        (begin
                            (set! tmp.322 (mref tmp.125 -2))
                            (return-point L.rp.113
                            (begin
                                (set! rsi 16)
                                (set! rdi add1.4)
                                (set! r15 L.rp.113)
                                (jump tmp.322 rbp r15 rsi rdi)))
                            (set! tmp.323 rax)
                            (set! rsi tmp.323)
                            (set! rdi sub1.6)
                            (set! r15 ra.427)
                            (jump tmp.317 rbp r15 rsi rdi))
                        (begin
                            (set! rsi 10814)
                            (set! rdi sub1.6)
                            (set! r15 ra.427)
                            (jump tmp.317 rbp r15 rsi rdi)))))))
 `(module
        (define L.tmp.8.31
            ((new-frames ())
            (locals (tmp.122 |+.49| x.5 c.115 ra.363))
            (undead-out
                (,(list-no-order 'rdi 'rsi 'ra.363 'rbp)
                ,(list-no-order 'rsi 'c.115 'ra.363 'rbp)
                ,(list-no-order 'c.115 'x.5 'ra.363 'rbp)
                ,(list-no-order 'x.5 '|+.49| 'ra.363 'rbp)
                ,(list-no-order 'x.5 '|+.49| 'ra.363 'rbp)
                ,(list-no-order 'x.5 '|+.49| 'ra.363 'rdx 'rbp)
                ,(list-no-order '|+.49| 'ra.363 'rsi 'rdx 'rbp)
                ,(list-no-order 'ra.363 'rdi 'rsi 'rdx 'rbp)
                ,(list-no-order 'rdi 'rsi 'rdx 'r15 'rbp)
                ,(list-no-order 'rdi 'rsi 'rdx 'r15 'rbp)))
            (call-undead ()))
            (begin
                (set! ra.363 r15)
                (set! c.115 rdi)
                (set! x.5 rsi)
                (set! |+.49| (mref c.115 14))
                (set! tmp.122 |+.49|)
                (set! rdx 8)
                (set! rsi x.5)
                (set! rdi |+.49|)
                (set! r15 ra.363)
                (jump L.+.49.29 rbp r15 rdx rsi rdi)))
            (define L.cons.72.6
                ((new-frames ())
                (locals (tmp.126 tmp.412 tmp.253 tmp.45 tmp.44 c.90 ra.411))
                (undead-out
                    (,(list-no-order 'rdi 'rsi 'rdx 'r12 'ra.411 'rbp)
                    ,(list-no-order 'rsi 'rdx 'r12 'ra.411 'rbp)
                    ,(list-no-order 'rdx 'r12 'ra.411 'rbp 'tmp.44)
                    ,(list-no-order 'r12 'tmp.45 'ra.411 'rbp 'tmp.44)
                    ,(list-no-order 'r12 'tmp.253 'tmp.45 'ra.411 'rbp 'tmp.44)
                    ,(list-no-order 'tmp.253 'tmp.45 'ra.411 'rbp 'tmp.44)
                    ,(list-no-order 'tmp.412 'tmp.45 'ra.411 'rbp 'tmp.44)
                    ,(list-no-order 'tmp.45 'ra.411 'rbp 'tmp.44 'tmp.126)
                    ,(list-no-order 'rbp 'ra.411 'tmp.45 'tmp.126)
                    ,(list-no-order 'tmp.126 'ra.411 'rbp)
                    ,(list-no-order 'ra.411 'rax 'rbp)
                    ,(list-no-order 'rax 'rbp)))
                (call-undead ()))
                (begin
                    (set! ra.411 r15)
                    (set! c.90 rdi)
                    (set! tmp.44 rsi)
                    (set! tmp.45 rdx)
                    (set! tmp.253 r12)
                    (set! r12 (+ r12 16))
                    (set! tmp.412 (+ tmp.253 1))
                    (set! tmp.126 tmp.412)
                    (mset! tmp.126 -1 tmp.44)
                    (mset! tmp.126 7 tmp.45)
                    (set! rax tmp.126)
                    (jump ra.411 rbp rax)))
            (define L.jp.108
                ((new-frames ())
                (locals (tmp.317 tmp.321 ra.427 sub1.6 tmp.323 add1.4 tmp.322 tmp.125))
                (undead-out
                    (,(list-no-order 'rdi 'rsi 'rdx 'rcx 'r8 'ra.427 'rbp)
                    ,(list-no-order 'rsi 'rdx 'rcx 'r8 'tmp.321 'ra.427 'rbp)
                    ,(list-no-order 'rdx 'rcx 'r8 'tmp.321 'tmp.125 'ra.427 'rbp)
                    ,(list-no-order 'rcx 'r8 'tmp.321 'tmp.125 'ra.427 'tmp.317 'rbp)
                    ,(list-no-order 'r8 'tmp.321 'tmp.125 'sub1.6 'ra.427 'tmp.317 'rbp)
                    ,(list-no-order 'tmp.321 'tmp.125 'add1.4 'sub1.6 'ra.427 'tmp.317 'rbp)
                    (,(list-no-order 'tmp.125 'add1.4 'sub1.6 'ra.427 'tmp.317 'rbp)
                    (,(list-no-order 'tmp.322 'add1.4 'sub1.6 'ra.427 'tmp.317 'rbp)
                    (,(list-no-order rax 'sub1.6 'ra.427 'tmp.317 'rbp)
                        (,(list-no-order 'add1.4 'tmp.322 'rsi 'rbp)
                        ,(list-no-order 'tmp.322 'rdi 'rsi 'rbp)
                        ,(list-no-order 'tmp.322 'rdi 'rsi 'r15 'rbp)
                        ,(list-no-order 'rdi 'rsi 'r15 'rbp)))
                    ,(list-no-order 'tmp.323 'sub1.6 'ra.427 'tmp.317 'rbp)
                    ,(list-no-order 'sub1.6 'ra.427 'tmp.317 'rsi 'rbp)
                    ,(list-no-order 'ra.427 'tmp.317 'rdi 'rsi 'rbp)
                    ,(list-no-order 'tmp.317 'rdi 'rsi 'r15 'rbp)
                    ,(list-no-order 'rdi 'rsi 'r15 'rbp))
                    (,(list-no-order 'sub1.6 'ra.427 'tmp.317 'rsi 'rbp)
                    ,(list-no-order 'ra.427 'tmp.317 'rdi 'rsi 'rbp)
                    ,(list-no-order 'tmp.317 'rdi 'rsi 'r15 'rbp)
                    ,(list-no-order 'rdi 'rsi 'r15 'rbp)))))
                (call-undead ,(list-no-order 'sub1.6 'ra.427 'tmp.317)))
                (begin
                    (set! ra.427 r15)
                    (set! tmp.321 rdi)
                    (set! tmp.125 rsi)
                    (set! tmp.317 rdx)
                    (set! sub1.6 rcx)
                    (set! add1.4 r8)
                    (if (neq? tmp.321 6)
                        (begin
                            (set! tmp.322 (mref tmp.125 -2))
                            (return-point L.rp.113
                            (begin
                                (set! rsi 16)
                                (set! rdi add1.4)
                                (set! r15 L.rp.113)
                                (jump tmp.322 rbp r15 rsi rdi)))
                            (set! tmp.323 rax)
                            (set! rsi tmp.323)
                            (set! rdi sub1.6)
                            (set! r15 ra.427)
                            (jump tmp.317 rbp r15 rsi rdi))
                        (begin
                            (set! rsi 10814)
                            (set! rdi sub1.6)
                            (set! r15 ra.427)
                            (jump tmp.317 rbp r15 rsi rdi))))))
                              ))

