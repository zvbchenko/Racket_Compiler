#lang racket

(require
 "util.rkt"
 "a8-graph-lib.rkt"
 "a8-compiler-lib.rkt"
 "undead-support.rkt"
 )
 (module+ test
  (require rackunit))


(provide 
  ; a-normalize
  expose-allocation-pointer
  uncover-locals
  conflict-analysis
  pre-assign-frame-variables
  assign-frames
  assign-registers
  undead-analysis
  )

; Exercise 7
(define (a-normalize p) 
    (displayln (format "a-norm ~a" p))
    (define (binop? b)
        (member b '(* + - bitwise-and bitwise-ior bitwise-xor arithmetic-shift-right)))

    (define (a-normalize-b b) 
        (match b
            [`(define ,f (lambda ,vs ,e))
             `(define ,f (lambda ,vs ,(a-normalize-e e)))]))

    (define (a-normalize-e e)
        (define basic-k (λ (v) v))
        
        (define (helper-c c k)
            (match c
                [`(mset! ,e1 ,e2 ,e3)
                 (helper-e
                    e1
                    (λ (v1)
                      (helper-e
                          e2
                          (λ (v2)
                            (helper-e
                                e3
                                (λ (v3)
                                  (cond
                                    [(and (not (list? v1)) (not (list? v2)) (not (list? v3)))
                                     `(begin (mset! ,v1 ,v2 ,v3) ,(k))]
                                    [(and (list? v1) (not (list? v2)) (not (list? v3)))
                                     (let ([x1 (fresh)])
                                        `(let ([,x1 ,v1])
                                            (begin (mset! ,x1 ,v2 ,v3)
                                                   ,(k))))]
                                    [(and (not (list? v1)) (list? v2) (not (list? v3)))
                                     (let ([x2 (fresh)])
                                        `(let ([,x2 ,v2])
                                            (begin (mset! ,v1 ,x2 ,v3)
                                                   ,(k))))]
                                    [(and (not (list? v1)) (not (list? v2)) (list? v3))
                                     (let ([x3 (fresh)])
                                        `(let ([,x3 ,v3])
                                            (begin (mset! ,v1 ,v2 ,x3)
                                                   ,(k))))]
                                    [(and (list? v1) (list? v2) (not (list? v3)))
                                     (let ([x1 (fresh)]
                                           [x2 (fresh)])
                                        `(let ([,x1 ,v1])
                                            (let ([,x2 ,v2])
                                              (begin (mset! ,x1 ,x2 ,v3)
                                                     ,(k)))))]
                                    [(and (list? v1) (not (list? v2)) (list? v3))
                                     (let ([x1 (fresh)]
                                           [x3 (fresh)])
                                        `(let ([,x1 ,v1])
                                            (let ([,x3 ,v3])
                                              (begin (mset! ,x1 ,v2 ,x3)
                                                     ,(k)))))]
                                    [(and (not (list? v1)) (list? v2) (list? v3))
                                     (let ([x2 (fresh)]
                                           [x3 (fresh)])
                                        `(let ([,x2 ,v2])
                                            (let ([,x3 ,v3])
                                              (begin (mset! ,v1 ,x2 ,x3)
                                                     ,(k)))))]
                                    [(and (list? v1) (list? v2) (list? v3))
                                     (let ([x1 (fresh)]
                                           [x2 (fresh)]
                                           [x3 (fresh)])
                                        `(let ([,x1 ,v1])
                                            (let ([,x2 ,v2])
                                              (let ([,x3 ,v3])
                                               (begin (mset! ,v1 ,x2 ,x3)
                                                      ,(k))))))]
                                     )))))))]))

        (define (flatten-cs cs)
          (for/fold ([cs^ empty])
                    ([c cs])
            (match c
              [`(begin ,cs^2 ...)
               (append cs^ cs^2)]
              [`(mset! ,_ ,_ ,_) 
               (append cs^ (list c))]
              [_ c])))

        (define (helper-e e k)
            (match e
                [`(apply ,es ...)
                (let* ([env (make-hash)]
                       [acc-k (for/fold ([acc-k (λ (first-k) first-k)]) ([e^ es])
                                        (λ (k^)
                                           (acc-k (λ () 
                                                     (helper-e e^ 
                                                            (λ (v^)
                                                               (if (list? v^)
                                                                   (let ([x (fresh)])
                                                                      (begin (dict-set! env e^ x)
                                                                             `(let ([,x ,v^]) ,(k^))))
                                                                   (begin (dict-set! env e^ v^)
                                                                          (k^)))))))))]
                        [end-k (λ ()
                                (define end-apply (cons 'apply 
                                                        (for/list ([e^ es]) 
                                                                    (dict-ref env e^))))
                                (k end-apply))])
                    ((acc-k end-k)))]
                [`(let ([,x ,e1]) ,e2)
                (helper-e e1
                        (λ (v1)
                            `(let ([,x ,v1])
                                ,(helper-e e2 k))))]
                [`(if (,cmp ,e1 ,e2) ,e3 ,e4)
                (helper-e e1
                        (λ (v1)
                           (helper-e e2
                                    (λ (v2)
                                       (cond
                                        [(and (list? v1) (list? v2))
                                         (define x1 (fresh))
                                         (define x2 (fresh))
                                         `(let ([,x1 ,v1])
                                            (let ([,x2 ,v2])
                                                (if (,cmp ,x1 ,x2) 
                                                    ,(helper-e e3 k)
                                                    ,(helper-e e4 k))))]
                                        [(and (list? v1) (not (list? v2)))
                                         (define x1 (fresh))
                                         `(let ([,x1 ,v1])
                                            (if (,cmp ,x1 ,v2) 
                                                ,(helper-e e3 k)
                                                ,(helper-e e4 k)))]
                                        [(and (not (list? v1)) (list? v2))
                                         (define x2 (fresh))
                                         `(let ([,x2 ,v2])
                                            (if (,cmp ,v1 ,x2) 
                                                ,(helper-e e3 k)
                                                ,(helper-e e4 k)))]
                                        [(and (not (list? v1)) (not (list? v2)))
                                            `(if (,cmp ,v1 ,v2) 
                                                ,(helper-e e3 k)
                                                ,(helper-e e4 k))])))))]
                [`(,binop ,e1 ,e2)
                 #:when (binop? binop)
                (helper-e e1
                        (λ (v1)
                           (helper-e e2
                                    (λ (v2)
                                       (cond
                                        [(and (list? v1) (list? v2))
                                         (define x1 (fresh))
                                         (define x2 (fresh))
                                         `(let ([,x1 ,v1])
                                            (let ([,x2 ,v2])
                                              ,(k `(,binop ,x1 ,x2))))]
                                        [(and (list? v1) (not (list? v2)))
                                         (define x1 (fresh))
                                         `(let ([,x1 ,v1])
                                            ,(k `(,binop ,x1 ,v2)))]
                                        [(and (not (list? v1)) (list? v2))
                                         (define x2 (fresh))
                                         `(let ([,x2 ,v2])
                                            ,(k `(,binop ,v1 ,x2)))]
                                        [(and (not (list? v1)) (not (list? v2)))
                                         (k `(,binop ,v1 ,v2))])))))]
                [`(begin ,cs ... ,e1)
                (let* ([cs^ (flatten-cs cs)]
                       [acc-k (for/fold ([acc-k (λ (first-k) first-k)]) ([c^ cs^])
                                        (λ (k^)
                                           (acc-k (λ () 
                                                     (helper-c c^
                                                            (λ () (k^)))))))]
                        [end-k (λ () (helper-e e1 (λ (v) (k v))))])
                    ((acc-k end-k)))]
                [`(alloc ,e1)
                 (helper-e e1
                         (λ (v1)
                            (cond
                              [(list? v1)
                               (define x (fresh))
                                `(let ([,x ,v1])
                                  ,(k `(alloc ,x)))]
                              [(not (list? v1))
                               (k `(alloc ,v1))])))]
                                
                [`(mref ,e1 ,e2)
                (helper-e e1
                        (λ (v1)
                           (helper-e e2
                                    (λ (v2)
                                       (cond
                                        [(and (list? v1) (list? v2))
                                         (define x1 (fresh))
                                         (define x2 (fresh))
                                         `(let ([,x1 ,v1])
                                            (let ([,x2 ,v2])
                                              ,(k `(mref ,x1 ,x2))))]
                                        [(and (list? v1) (not (list? v2)))
                                         (define x1 (fresh))
                                         `(let ([,x1 ,v1])
                                            ,(k `(mref ,x1 ,v2)))]
                                        [(and (not (list? v1)) (list? v2))
                                         (define x2 (fresh))
                                         `(let ([,x2 ,v2])
                                            ,(k `(mref ,v1 ,x2)))]
                                        [(and (not (list? v1)) (not (list? v2)))
                                         (k `(mref ,v1 ,v2))])))))]
                [_ (k e)]))
        (helper-e e basic-k))

    (match p
        [`(module ,bs ... ,e)
         (append (list 'module)
                 (map a-normalize-b bs) 
                 (list (a-normalize-e e)))]))

; Exercise 5
(define (expose-allocation-pointer p)
    (displayln (format "expose allocation pointer ~a" p))
  (define (expose-allocation-pointer-st st)
    (match st
      [`(set! ,loc (alloc ,index))
       (list `(set! ,loc ,(current-heap-base-pointer-register))
             `(set! ,(current-heap-base-pointer-register) 
                    (+ ,(current-heap-base-pointer-register) ,index)))]
      [`(return-point ,label ,tail)
       (list (append (list 'return-point)
                     (list label)
                     (expose-allocation-pointer-st tail)))]
      [`(begin ,sts ...)
       (list (append (list 'begin)
                     (for/fold ([sts^ empty])
                               ([st (map expose-allocation-pointer-st sts)])
                        (append sts^ st))))]
      [`(if ,cmp ,tail1 ,tail2)
       (list (append (list 'if)
                     (list cmp)
                     (expose-allocation-pointer-st tail1)
                     (expose-allocation-pointer-st tail2)))]
      [_ (list st)]))
  
  (define (expose-allocation-pointer-block b)
    (match b
      [`(define ,label ,info ,tail)
       (append (list 'define)
               (list label)
               (list info)
               (expose-allocation-pointer-st tail))]))
  
  (match p
    [`(module ,b ...)
     (append (list 'module)
             (map expose-allocation-pointer-block b))]))

; Exercise 4
; Block-lang-v6 -> Block-locals-lang-v6
(define (uncover-locals p)
  (displayln (format "uncover-local ~a" p))

  (define (to-tail-list tail)
    (match tail 
      [`(begin ,s ... ,t) tail] 
      [_ (list tail)]))

  ; Statement/Tail Locals -> Locals
  ; Uncover locals in a given statement
  (define (uncover-locals-statement s locals)
    (match s
      [`(set! ,aloc ,triv)
       (add-local aloc (add-local triv locals))]
      [`(set! ,aloc1 (,binop ,aloc2 ,opand))
       (add-local aloc1 (add-local aloc2 (add-local opand locals)))]
      [`(jump ,trg ,aloc ...)
       (foldl add-local (add-local trg locals) aloc)]
      [`(if (,cmp ,aloc ,opand) ,tail1 ,tail2)
       (let*
           ([new-locals (add-local aloc (add-local opand locals))]
            [new-locals-tail1 (foldl uncover-locals-statement new-locals (to-tail-list tail1))]
            [new-locals-tail2 (foldl uncover-locals-statement new-locals-tail1 (to-tail-list tail2))])
         new-locals-tail2)
       ]
      [`(return-point ,label ,tail)
       (uncover-locals-statement tail locals)]
      [`(begin ,s ...)
       (foldl uncover-locals-statement locals s)]
      [`(mset! ,loc ,index ,triv)
       (add-local loc (add-local index (add-local triv locals)))]
      [`(set! ,loc1 (mset! ,loc2 ,index ,triv))
       (add-local loc1 (add-local loc2 (add-local index (add-local triv locals))))]
      [_ locals]))
  
  ; Aloc Locals -> Locals
  ; Add an aloc to given locals
  (define (add-local aloc locals)
    (if (and (not (label? aloc))
             (not (rloc? aloc))
             (aloc? aloc) 
             (not (member aloc locals)))
        (cons aloc locals)
        locals))
  

  ; Block -> Block
  ; Update block with locals info
  (define (uncover-locals-block b)
    (match b
      [`(define ,label ,info ,tail)
       (append (list 'define)
               (list label)
               (list (info-set info 'locals (foldl uncover-locals-statement empty (to-tail-list tail))))
               (list tail))
       ]))
  
  (match p
    [`(module ,b ...)
     (append (list 'module)
             (map uncover-locals-block b))]))

; Exercise 4
(define (conflict-analysis p)

  (displayln (format "conflict-analysis ~a" p))

  ; Vertex Vertex Graph -> Graph
  ; Return a new graph with an edge from from to to if to is not a neighbor of from
  (define (add-directed-conflict from to conflict-graph)
    (let ([conflict-graph^ (safe-add-vertex (safe-add-vertex conflict-graph from) to)])
      (if (or (eq? from to) 
              (member to (get-neighbors conflict-graph^ from)))
          conflict-graph^
          (add-directed-edge conflict-graph^ from to))))

  ; Vertex Vertex Graph -> Graph
  ; Return a new graph with edges from a to b and from b to a if they do not already exist
  (define (add-conflict a b conflict-graph)
    (add-directed-conflict b a (add-directed-conflict a b conflict-graph)))

  (define mset-conflicts empty)

  ; Undead-set-tree Statement Conflict-graph -> Conflict-graph
  ; Update given conflict graph for the given statement and its undead-set-tree
  (define (conflict-analysis-stmt ust s conflict-graph) 
    (match s
      [`(set! ,loc (mref ,_ ,_))
       (set! mset-conflicts (cons loc mset-conflicts))
       (for/fold ([conflict-graph^ conflict-graph])
                 ([u-loc ust])
          (add-conflict loc u-loc conflict-graph^))]
      [`(set! ,loc ,_)
       (when (or (fvar? loc) (register? loc))
             (set! mset-conflicts (cons loc mset-conflicts)))
       (for/fold ([conflict-graph^ conflict-graph])
                 ([u-loc ust])
          (add-conflict loc u-loc conflict-graph^))]
      [`(mset! ,loc ,index ,triv) conflict-graph]
      [`(return-point ,_ ,tail)
       (conflict-analysis-tail (second ust) tail conflict-graph)]))

  ; Undead-set-tree Tail Conflict-graph -> Conflict-graph
  ; Update given conflict graph for the given tail and its undead-set-tree
  (define (conflict-analysis-tail ust t conflict-graph)
    (match t
        [`(begin ,ss ... ,tail)
         (let* ([usts (reverse (rest (reverse ust)))]
                [tail-ust (last ust)]
                [conflict-graph^ 
                  (for/fold ([conflict-graph^ conflict-graph])
                            ([ust^ usts] [s ss])
                    (conflict-analysis-stmt ust^ s conflict-graph^))])
            (conflict-analysis-tail tail-ust tail conflict-graph^))]
        [`(if (,cmp ,loc ,opand) ,tail1 ,tail2)
         (conflict-analysis-tail 
            (third ust) 
            tail2 
            (conflict-analysis-tail (second ust) tail1 conflict-graph))]
        [_ conflict-graph]))

  ; Block -> Block
  ; Return a block with new Info
  (define (conflict-analysis-block b)
    (match b
      [`(define ,label ,info ,tail)
       (set! mset-conflicts empty)
       (let ([conflicts (conflict-analysis-tail (info-ref info 'undead-out) 
                                                tail
                                                (new-graph))])
         (append (list 'define)
                 (list label)
                 (list (info-set info 'conflicts conflicts))
                 (list tail)))]))
    
  (match p
    [`(module ,b ...)
     (append (list 'module)
             (map conflict-analysis-block b))]))

; Exercise 3
(define (pre-assign-frame-variables p)
  (displayln (format "pre-assign-frame-variables ~a" p))

  ; Block -> Block
  ; Return a block with new Info
  (define (pre-assign-frame-variables-block b)
    (match b
      [`(define ,label ,info ,tail)
       (let* ([assignment (produce-call-undead-assignment (info-ref info 'conflicts) 
                                                          (info-ref info 'call-undead))]
              [locals (set-subtract (info-ref info 'locals) (dict-keys assignment))]
              [info^ (info-set (info-set info 'locals locals) 'assignment assignment)])
          `(define ,label ,info^ ,tail))]))

    (define (safe-dict-ref dict key)
      (if (member key (dict-keys dict))
          (dict-ref dict key)
          empty))

    ;; (listof fvar) -> fvar
    (define (produce-non-conflict-fvar conflict-fvars) 
        ; (displayln (format "coflict-fvars ~a" conflict-fvars))
      (define (helper indices n)
        (cond
          [(empty? indices) n]
          [(= (first indices) n) (helper (rest indices) (+ n 1))]
          [else n]))
      (define (find-a-num l)
        (let ([res 0])
          (for ([i l])
            (unless (member (+ i 1) l)
              (set! res (+ i 1))))
          res))
      (let ([indices (set->list (list->set (map fvar->index conflict-fvars)))])
          ; (displayln (format "indices: ~a" indices))
        ; (make-fvar (helper indices 0))
          (make-fvar (find-a-num (sort indices >))) ))

    ; Conflict-graph Call-undead -> Assignment
    (define (produce-call-undead-assignment conflicts call-undeads) 
      (for/fold ([assignment '()]) ([cu call-undeads])
        (let* ([conflict-alocs (filter aloc? (info-ref conflicts cu))]
               [conflict-fvars
                  (for/fold ([conflict-fvars '()]) ([aloc conflict-alocs])
                    (append conflict-fvars (safe-dict-ref assignment aloc)))]
               [conflict-fvars^ (append (filter fvar? (info-ref conflicts cu)) conflict-fvars)]
               [fvar (produce-non-conflict-fvar conflict-fvars^)])
            ; (displayln (format "cu: ~a fvar: ~a conflict-fvars ~a info-ref ~a" cu fvar conflict-fvars (info-ref conflicts cu)))
          (cons (list cu fvar) assignment))))

  (match p
    [`(module ,bs ...)
     (cons 'module (map pre-assign-frame-variables-block bs))]))

; Exercise 6
(module+ test
  (check-equal? (pre-assign-frame-variables
                 '(module
                      (define L.main.1
                        ((new-frames ())
                         (locals (ra.1))
                         (undead-out
                          ((ra.1 rbp)
                           (ra.1 fv1 rbp)
                           (ra.1 fv0 fv1 rbp)
                           (fv0 fv1 r15 rbp)
                           (fv0 fv1 r15 rbp)))
                         (call-undead ())
                         (conflicts
                          ((ra.1 (fv0 fv1 rbp))
                           (rbp (r15 fv0 fv1 ra.1))
                           (fv1 (r15 fv0 ra.1 rbp))
                           (fv0 (r15 ra.1 fv1 rbp))
                           (r15 (fv0 fv1 rbp)))))
                        (begin
                          (set! ra.1 r15)
                          (set! fv1 2)
                          (set! fv0 1)
                          (set! r15 ra.1)
                          (jump L.swap.1 rbp r15 fv1 fv0)))
                    (define L.swap.1
                      ((new-frames ((nfv.4 nfv.3)))
                       (locals (x.1 z.3 nfv.4 nfv.3 y.2))
                       (undead-out
                        ((fv0 fv1 ra.2 rbp)
                         (fv1 x.1 ra.2 rbp)
                         (y.2 x.1 ra.2 rbp)
                         ((y.2 x.1 ra.2 rbp)
                          ((ra.2 rax rbp) (rax rbp))
                          (((rax ra.2 rbp)
                            ((y.2 nfv.4 rbp)
                             (nfv.3 nfv.4 rbp)
                             (nfv.3 nfv.4 r15 rbp)
                             (nfv.3 nfv.4 r15 rbp)))
                           (z.3 ra.2 rbp)
                           (ra.2 rax rbp)
                           (rax rbp)))))
                       (call-undead (ra.2))
                       (conflicts
                        ((nfv.4 (r15 nfv.3 y.2 rbp))
                         (rbp (y.2 x.1 ra.2 rax z.3 r15 nfv.3 nfv.4))
                         (y.2 (x.1 ra.2 rbp nfv.4))
                         (nfv.3 (r15 nfv.4 rbp))
                         (r15 (nfv.3 nfv.4 rbp))
                         (z.3 (ra.2 rbp))
                         (ra.2 (y.2 x.1 fv0 fv1 rbp rax z.3))
                         (rax (ra.2 rbp))
                         (fv1 (x.1 ra.2))
                         (fv0 (ra.2))
                         (x.1 (y.2 fv1 ra.2 rbp)))))
                      (begin
                        (set! ra.2 r15)
                        (set! x.1 fv0)
                        (set! y.2 fv1)
                        (if (< y.2 x.1)
                            (begin (set! rax x.1) (jump ra.2 rbp rax))
                            (begin
                              (return-point L.rp.2
                                            (begin
                                              (set! nfv.4 x.1)
                                              (set! nfv.3 y.2)
                                              (set! r15 L.rp.2)
                                              (jump L.swap.1 rbp r15 nfv.4 nfv.3)))
                              (set! z.3 rax)
                              (set! rax z.3)
                              (jump ra.2 rbp rax)))))))
                '(module
                     (define L.main.1
                       ((new-frames ())
                        (locals (ra.1))
                        (undead-out
                         ((ra.1 rbp)
                          (ra.1 fv1 rbp)
                          (ra.1 fv0 fv1 rbp)
                          (fv0 fv1 r15 rbp)
                          (fv0 fv1 r15 rbp)))
                        (call-undead ())
                        (conflicts
                         ((ra.1 (fv0 fv1 rbp))
                          (rbp (r15 fv0 fv1 ra.1))
                          (fv1 (r15 fv0 ra.1 rbp))
                          (fv0 (r15 ra.1 fv1 rbp))
                          (r15 (fv0 fv1 rbp))))
                        (assignment ()))
                       (begin
                         (set! ra.1 r15)
                         (set! fv1 2)
                         (set! fv0 1)
                         (set! r15 ra.1)
                         (jump L.swap.1 rbp r15 fv1 fv0)))
                   (define L.swap.1
                     ((new-frames ((nfv.4 nfv.3)))
                      (locals (x.1 z.3 nfv.4 nfv.3 y.2))
                      (undead-out
                       ((fv0 fv1 ra.2 rbp)
                        (fv1 x.1 ra.2 rbp)
                        (y.2 x.1 ra.2 rbp)
                        ((y.2 x.1 ra.2 rbp)
                         ((ra.2 rax rbp) (rax rbp))
                         (((rax ra.2 rbp)
                           ((y.2 nfv.4 rbp)
                            (nfv.3 nfv.4 rbp)
                            (nfv.3 nfv.4 r15 rbp)
                            (nfv.3 nfv.4 r15 rbp)))
                          (z.3 ra.2 rbp)
                          (ra.2 rax rbp)
                          (rax rbp)))))
                      (call-undead (ra.2))
                      (conflicts
                       ((nfv.4 (r15 nfv.3 y.2 rbp))
                        (rbp (y.2 x.1 ra.2 rax z.3 r15 nfv.3 nfv.4))
                        (y.2 (x.1 ra.2 rbp nfv.4))
                        (nfv.3 (r15 nfv.4 rbp))
                        (r15 (nfv.3 nfv.4 rbp))
                        (z.3 (ra.2 rbp))
                        (ra.2 (y.2 x.1 fv0 fv1 rbp rax z.3))
                        (rax (ra.2 rbp))
                        (fv1 (x.1 ra.2))
                        (fv0 (ra.2))
                        (x.1 (y.2 fv1 ra.2 rbp))))
                      (assignment ((ra.2 fv2))))
                     (begin
                       (set! ra.2 r15)
                       (set! x.1 fv0)
                       (set! y.2 fv1)
                       (if (< y.2 x.1)
                           (begin (set! rax x.1) (jump ra.2 rbp rax))
                           (begin
                             (return-point L.rp.2
                                           (begin
                                             (set! nfv.4 x.1)
                                             (set! nfv.3 y.2)
                                             (set! r15 L.rp.2)
                                             (jump L.swap.1 rbp r15 nfv.4 nfv.3)))
                             (set! z.3 rax)
                             (set! rax z.3)
                             (jump ra.2 rbp rax)))))))
  (check-equal? (pre-assign-frame-variables
                 '(module
                      (define L.main.1
                        ((new-frames ())
                         (locals (y.2))
                         (undead-out
                          ((ra.1 rbp)
                           ((rax ra.1 rbp) ((rdi rbp) (rdi r15 rbp) (rdi r15 rbp)))
                           (x.2 ra.1 rbp)
                           ((rax x.2 ra.1 rbp) ((rdi rbp) (rdi r15 rbp) (rdi r15 rbp)))
                           (y.2 x.2 ra.1 rbp)
                           (x.2 ra.1 rsi rbp)
                           (ra.1 rdi rsi rbp)
                           (rdi rsi r15 rbp)
                           (rdi rsi r15 rbp)))
                         (call-undead (x.2 ra.1))
                         (conflicts
                          ((ra.1 (rdi rsi y.2 x.2 rbp))
                           (rbp (rsi y.2 x.2 r15 rdi ra.1))
                           (rdi (ra.1 rsi r15 rbp))
                           (r15 (rsi rdi rbp))
                           (x.2 (rsi y.2 ra.1 rbp))
                           (y.2 (x.2 ra.1 rbp))
                           (rsi (r15 rdi x.2 ra.1 rbp)))))
                        (begin
                          (set! ra.1 r15)
                          (return-point L.rp.2
                                        (begin
                                          (set! rdi 2)
                                          (set! r15 L.rp.2)
                                          (jump L.increment.1 rbp r15 rdi)))
                          (set! x.2 rax)
                          (return-point L.rp.3
                                        (begin
                                          (set! rdi 3)
                                          (set! r15 L.rp.3)
                                          (jump L.increment.1 rbp r15 rdi)))
                          (set! y.2 rax)
                          (set! rsi y.2)
                          (set! rdi x.2)
                          (set! r15 ra.1)
                          (jump L.add.2 rbp r15 rsi rdi)))
                    (define L.increment.1
                      ((new-frames ())
                       (locals (ra.2 x.1 tmp.3 tmp.4))
                       (undead-out
                        ((rdi ra.2 rbp)
                         (x.1 ra.2 rbp)
                         (tmp.3 x.1 ra.2 rbp)
                         (tmp.4 ra.2 rbp)
                         (ra.2 rax rbp)
                         (rax rbp)))
                       (call-undead ())
                       (conflicts
                        ((ra.2 (rax tmp.4 tmp.3 x.1 rdi rbp))
                         (rbp (rax tmp.4 tmp.3 x.1 ra.2))
                         (rdi (ra.2))
                         (x.1 (tmp.3 ra.2 rbp))
                         (tmp.3 (x.1 ra.2 rbp))
                         (tmp.4 (rbp ra.2))
                         (rax (ra.2 rbp)))))
                      (begin
                        (set! ra.2 r15)
                        (set! x.1 rdi)
                        (set! tmp.3 1)
                        (set! tmp.4 (+ x.1 tmp.3))
                        (set! rax tmp.4)
                        (jump ra.2 rbp rax)))
                    (define L.add.2
                      ((new-frames ())
                       (locals (y.2 b.2 tmp.7 tmp.6 z.3))
                       (undead-out
                        ((rdi rsi ra.5 rbp)
                         (rsi y.2 ra.5 rbp)
                         (z.3 y.2 ra.5 rbp)
                         ((z.3 y.2 ra.5 rbp)
                          ((ra.5 rax rbp) (rax rbp))
                          ((tmp.6 z.3 y.2 ra.5 rbp)
                           (tmp.7 y.2 ra.5 rbp)
                           (y.2 a.1 ra.5 rbp)
                           ((rax a.1 ra.5 rbp) ((rdi rbp) (rdi r15 rbp) (rdi r15 rbp)))
                           (a.1 b.2 ra.5 rbp)
                           (b.2 ra.5 rsi rbp)
                           (ra.5 rdi rsi rbp)
                           (rdi rsi r15 rbp)
                           (rdi rsi r15 rbp)))))
                       (call-undead (a.1 ra.5))
                       (conflicts
                        ((tmp.6 (z.3 y.2 ra.5 rbp))
                         (rbp (z.3 y.2 ra.5 rax rsi b.2 r15 rdi a.1 tmp.7 tmp.6))
                         (ra.5 (z.3 y.2 rbp rax rdi rsi b.2 a.1 tmp.7 tmp.6))
                         (y.2 (z.3 rsi ra.5 rbp a.1 tmp.7 tmp.6))
                         (z.3 (y.2 ra.5 rbp tmp.6))
                         (tmp.7 (rbp ra.5 y.2))
                         (a.1 (b.2 y.2 ra.5 rbp))
                         (rdi (ra.5 rsi r15 rbp))
                         (r15 (rsi rdi rbp))
                         (b.2 (rsi a.1 ra.5 rbp))
                         (rsi (y.2 r15 rdi b.2 ra.5 rbp))
                         (rax (ra.5 rbp)))))
                      (begin
                        (set! ra.5 r15)
                        (set! y.2 rdi)
                        (set! z.3 rsi)
                        (if (= z.3 0)
                            (begin (set! rax y.2) (jump ra.5 rbp rax))
                            (begin
                              (set! tmp.6 1)
                              (set! tmp.7 (- z.3 tmp.6))
                              (set! a.1 tmp.7)
                              (return-point L.rp.4
                                            (begin
                                              (set! rdi y.2)
                                              (set! r15 L.rp.4)
                                              (jump L.increment.1 rbp r15 rdi)))
                              (set! b.2 rax)
                              (set! rsi a.1)
                              (set! rdi b.2)
                              (set! r15 ra.5)
                              (jump L.add.2 rbp r15 rsi rdi)))))))
                '(module
                     (define L.main.1
                       ((new-frames ())
                        (locals (y.2))
                        (undead-out
                         ((ra.1 rbp)
                          ((rax ra.1 rbp) ((rdi rbp) (rdi r15 rbp) (rdi r15 rbp)))
                          (x.2 ra.1 rbp)
                          ((rax x.2 ra.1 rbp) ((rdi rbp) (rdi r15 rbp) (rdi r15 rbp)))
                          (y.2 x.2 ra.1 rbp)
                          (x.2 ra.1 rsi rbp)
                          (ra.1 rdi rsi rbp)
                          (rdi rsi r15 rbp)
                          (rdi rsi r15 rbp)))
                        (call-undead (x.2 ra.1))
                        (conflicts
                         ((ra.1 (rdi rsi y.2 x.2 rbp))
                          (rbp (rsi y.2 x.2 r15 rdi ra.1))
                          (rdi (ra.1 rsi r15 rbp))
                          (r15 (rsi rdi rbp))
                          (x.2 (rsi y.2 ra.1 rbp))
                          (y.2 (x.2 ra.1 rbp))
                          (rsi (r15 rdi x.2 ra.1 rbp))))
                        (assignment ((x.2 fv1) (ra.1 fv0))))
                       (begin
                         (set! ra.1 r15)
                         (return-point L.rp.2
                                       (begin
                                         (set! rdi 2)
                                         (set! r15 L.rp.2)
                                         (jump L.increment.1 rbp r15 rdi)))
                         (set! x.2 rax)
                         (return-point L.rp.3
                                       (begin
                                         (set! rdi 3)
                                         (set! r15 L.rp.3)
                                         (jump L.increment.1 rbp r15 rdi)))
                         (set! y.2 rax)
                         (set! rsi y.2)
                         (set! rdi x.2)
                         (set! r15 ra.1)
                         (jump L.add.2 rbp r15 rsi rdi)))
                   (define L.increment.1
                     ((new-frames ())
                      (locals (ra.2 x.1 tmp.3 tmp.4))
                      (undead-out
                       ((rdi ra.2 rbp)
                        (x.1 ra.2 rbp)
                        (tmp.3 x.1 ra.2 rbp)
                        (tmp.4 ra.2 rbp)
                        (ra.2 rax rbp)
                        (rax rbp)))
                      (call-undead ())
                      (conflicts
                       ((ra.2 (rax tmp.4 tmp.3 x.1 rdi rbp))
                        (rbp (rax tmp.4 tmp.3 x.1 ra.2))
                        (rdi (ra.2))
                        (x.1 (tmp.3 ra.2 rbp))
                        (tmp.3 (x.1 ra.2 rbp))
                        (tmp.4 (rbp ra.2))
                        (rax (ra.2 rbp))))
                      (assignment ()))
                     (begin
                       (set! ra.2 r15)
                       (set! x.1 rdi)
                       (set! tmp.3 1)
                       (set! tmp.4 (+ x.1 tmp.3))
                       (set! rax tmp.4)
                       (jump ra.2 rbp rax)))
                   (define L.add.2
                     ((new-frames ())
                      (locals (y.2 b.2 tmp.7 tmp.6 z.3))
                      (undead-out
                       ((rdi rsi ra.5 rbp)
                        (rsi y.2 ra.5 rbp)
                        (z.3 y.2 ra.5 rbp)
                        ((z.3 y.2 ra.5 rbp)
                         ((ra.5 rax rbp) (rax rbp))
                         ((tmp.6 z.3 y.2 ra.5 rbp)
                          (tmp.7 y.2 ra.5 rbp)
                          (y.2 a.1 ra.5 rbp)
                          ((rax a.1 ra.5 rbp) ((rdi rbp) (rdi r15 rbp) (rdi r15 rbp)))
                          (a.1 b.2 ra.5 rbp)
                          (b.2 ra.5 rsi rbp)
                          (ra.5 rdi rsi rbp)
                          (rdi rsi r15 rbp)
                          (rdi rsi r15 rbp)))))
                      (call-undead (a.1 ra.5))
                      (conflicts
                       ((tmp.6 (z.3 y.2 ra.5 rbp))
                        (rbp (z.3 y.2 ra.5 rax rsi b.2 r15 rdi a.1 tmp.7 tmp.6))
                        (ra.5 (z.3 y.2 rbp rax rdi rsi b.2 a.1 tmp.7 tmp.6))
                        (y.2 (z.3 rsi ra.5 rbp a.1 tmp.7 tmp.6))
                        (z.3 (y.2 ra.5 rbp tmp.6))
                        (tmp.7 (rbp ra.5 y.2))
                        (a.1 (b.2 y.2 ra.5 rbp))
                        (rdi (ra.5 rsi r15 rbp))
                        (r15 (rsi rdi rbp))
                        (b.2 (rsi a.1 ra.5 rbp))
                        (rsi (y.2 r15 rdi b.2 ra.5 rbp))
                        (rax (ra.5 rbp))))
                      (assignment ((a.1 fv1) (ra.5 fv0))))
                     (begin
                       (set! ra.5 r15)
                       (set! y.2 rdi)
                       (set! z.3 rsi)
                       (if (= z.3 0)
                           (begin (set! rax y.2) (jump ra.5 rbp rax))
                           (begin
                             (set! tmp.6 1)
                             (set! tmp.7 (- z.3 tmp.6))
                             (set! a.1 tmp.7)
                             (return-point L.rp.4
                                           (begin
                                             (set! rdi y.2)
                                             (set! r15 L.rp.4)
                                             (jump L.increment.1 rbp r15 rdi)))
                             (set! b.2 rax)
                             (set! rsi a.1)
                             (set! rdi b.2)
                             (set! r15 ra.5)
                             (jump L.add.2 rbp r15 rsi rdi)))))))
  (check-equal? (pre-assign-frame-variables
                 '(module
                      (define L.main.1
                        ((new-frames ())
                         (locals (y.2))
                         (undead-out
                          ((ra.1 rbp)
                           ((rax ra.1 rbp) ((rdi rbp) (rdi r15 rbp) (rdi r15 rbp)))
                           (x.2 ra.1 rbp)
                           ((rax x.2 ra.1 rbp) ((rdi rbp) (rdi r15 rbp) (rdi r15 rbp)))
                           (y.2 x.2 ra.1 rbp)
                           (x.2 ra.1 rsi rbp)
                           (ra.1 rdi rsi rbp)
                           (rdi rsi r15 rbp)
                           (rdi rsi r15 rbp)))
                         (call-undead (x.2 ra.1))
                         (conflicts
                          ((ra.1 (rdi rsi y.2 x.2 rbp))
                           (rbp (rsi y.2 x.2 r15 rdi ra.1))
                           (rdi (ra.1 rsi r15 rbp))
                           (r15 (rsi rdi rbp))
                           (x.2 (rsi y.2 ra.1 rbp))
                           (y.2 (x.2 ra.1 rbp))
                           (rsi (r15 rdi x.2 ra.1 rbp)))))
                        (begin
                          (set! ra.1 r15)
                          (return-point L.rp.2
                                        (begin
                                          (set! rdi 2)
                                          (set! r15 L.rp.2)
                                          (jump L.increment.1 rbp r15 rdi)))
                          (set! x.2 rax)
                          (return-point L.rp.3
                                        (begin
                                          (set! rdi 3)
                                          (set! r15 L.rp.3)
                                          (jump L.increment.1 rbp r15 rdi)))
                          (set! y.2 rax)
                          (set! rsi y.2)
                          (set! rdi x.2)
                          (set! r15 ra.1)
                          (jump L.add.2 rbp r15 rsi rdi)))
                    (define L.increment.1
                      ((new-frames ())
                       (locals (ra.2 x.1 tmp.3 tmp.4))
                       (undead-out
                        ((rdi ra.2 rbp)
                         (x.1 ra.2 rbp)
                         (tmp.3 x.1 ra.2 rbp)
                         (tmp.4 ra.2 rbp)
                         (ra.2 rax rbp)
                         (rax rbp)))
                       (call-undead ())
                       (conflicts
                        ((ra.2 (rax tmp.4 tmp.3 x.1 rdi rbp))
                         (rbp (rax tmp.4 tmp.3 x.1 ra.2))
                         (rdi (ra.2))
                         (x.1 (tmp.3 ra.2 rbp))
                         (tmp.3 (x.1 ra.2 rbp))
                         (tmp.4 (rbp ra.2))
                         (rax (ra.2 rbp)))))
                      (begin
                        (set! ra.2 r15)
                        (set! x.1 rdi)
                        (set! tmp.3 1)
                        (set! tmp.4 (+ x.1 tmp.3))
                        (set! rax tmp.4)
                        (jump ra.2 rbp rax)))
                    (define L.add.2
                      ((new-frames ())
                       (locals (ra.5 y.2 z.3 tmp.6))
                       (undead-out
                        ((rdi rsi ra.5 rbp)
                         (rsi y.2 ra.5 rbp)
                         (z.3 y.2 ra.5 rbp)
                         (tmp.6 ra.5 rbp)
                         (ra.5 rax rbp)
                         (rax rbp)))
                       (call-undead ())
                       (conflicts
                        ((ra.5 (rax tmp.6 z.3 y.2 rdi rsi rbp))
                         (rbp (rax tmp.6 z.3 y.2 ra.5))
                         (rsi (y.2 ra.5))
                         (rdi (ra.5))
                         (y.2 (z.3 rsi ra.5 rbp))
                         (z.3 (y.2 ra.5 rbp))
                         (tmp.6 (rbp ra.5))
                         (rax (ra.5 rbp)))))
                      (begin
                        (set! ra.5 r15)
                        (set! y.2 rdi)
                        (set! z.3 rsi)
                        (set! tmp.6 (+ y.2 z.3))
                        (set! rax tmp.6)
                        (jump ra.5 rbp rax)))))
                '(module
                     (define L.main.1
                       ((new-frames ())
                        (locals (y.2))
                        (undead-out
                         ((ra.1 rbp)
                          ((rax ra.1 rbp) ((rdi rbp) (rdi r15 rbp) (rdi r15 rbp)))
                          (x.2 ra.1 rbp)
                          ((rax x.2 ra.1 rbp) ((rdi rbp) (rdi r15 rbp) (rdi r15 rbp)))
                          (y.2 x.2 ra.1 rbp)
                          (x.2 ra.1 rsi rbp)
                          (ra.1 rdi rsi rbp)
                          (rdi rsi r15 rbp)
                          (rdi rsi r15 rbp)))
                        (call-undead (x.2 ra.1))
                        (conflicts
                         ((ra.1 (rdi rsi y.2 x.2 rbp))
                          (rbp (rsi y.2 x.2 r15 rdi ra.1))
                          (rdi (ra.1 rsi r15 rbp))
                          (r15 (rsi rdi rbp))
                          (x.2 (rsi y.2 ra.1 rbp))
                          (y.2 (x.2 ra.1 rbp))
                          (rsi (r15 rdi x.2 ra.1 rbp))))
                        (assignment ((x.2 fv1) (ra.1 fv0))))
                       (begin
                         (set! ra.1 r15)
                         (return-point L.rp.2
                                       (begin
                                         (set! rdi 2)
                                         (set! r15 L.rp.2)
                                         (jump L.increment.1 rbp r15 rdi)))
                         (set! x.2 rax)
                         (return-point L.rp.3
                                       (begin
                                         (set! rdi 3)
                                         (set! r15 L.rp.3)
                                         (jump L.increment.1 rbp r15 rdi)))
                         (set! y.2 rax)
                         (set! rsi y.2)
                         (set! rdi x.2)
                         (set! r15 ra.1)
                         (jump L.add.2 rbp r15 rsi rdi)))
                   (define L.increment.1
                     ((new-frames ())
                      (locals (ra.2 x.1 tmp.3 tmp.4))
                      (undead-out
                       ((rdi ra.2 rbp)
                        (x.1 ra.2 rbp)
                        (tmp.3 x.1 ra.2 rbp)
                        (tmp.4 ra.2 rbp)
                        (ra.2 rax rbp)
                        (rax rbp)))
                      (call-undead ())
                      (conflicts
                       ((ra.2 (rax tmp.4 tmp.3 x.1 rdi rbp))
                        (rbp (rax tmp.4 tmp.3 x.1 ra.2))
                        (rdi (ra.2))
                        (x.1 (tmp.3 ra.2 rbp))
                        (tmp.3 (x.1 ra.2 rbp))
                        (tmp.4 (rbp ra.2))
                        (rax (ra.2 rbp))))
                      (assignment ()))
                     (begin
                       (set! ra.2 r15)
                       (set! x.1 rdi)
                       (set! tmp.3 1)
                       (set! tmp.4 (+ x.1 tmp.3))
                       (set! rax tmp.4)
                       (jump ra.2 rbp rax)))
                   (define L.add.2
                     ((new-frames ())
                      (locals (ra.5 y.2 z.3 tmp.6))
                      (undead-out
                       ((rdi rsi ra.5 rbp)
                        (rsi y.2 ra.5 rbp)
                        (z.3 y.2 ra.5 rbp)
                        (tmp.6 ra.5 rbp)
                        (ra.5 rax rbp)
                        (rax rbp)))
                      (call-undead ())
                      (conflicts
                       ((ra.5 (rax tmp.6 z.3 y.2 rdi rsi rbp))
                        (rbp (rax tmp.6 z.3 y.2 ra.5))
                        (rsi (y.2 ra.5))
                        (rdi (ra.5))
                        (y.2 (z.3 rsi ra.5 rbp))
                        (z.3 (y.2 ra.5 rbp))
                        (tmp.6 (rbp ra.5))
                        (rax (ra.5 rbp))))
                      (assignment ()))
                     (begin
                       (set! ra.5 r15)
                       (set! y.2 rdi)
                       (set! z.3 rsi)
                       (set! tmp.6 (+ y.2 z.3))
                       (set! rax tmp.6)
                       (jump ra.5 rbp rax)))))
  )

; Exercise 3
(define (assign-frames p) 

    (displayln (format "assign frames ~a" p))
  ; Block -> Block
  ; Return a block with new Info
  (define (assign-frames-block b)
    (match b
      [`(define ,label ,info ,tail)
       (let ([call-undeads (info-ref info 'call-undead)])
        (if (empty? call-undeads)
            `(define ,label ,(clean-up-info info) ,tail)
            (let* ([assignment (info-ref info 'assignment)]
                    [fvars (for/list ([cu call-undeads]) (info-ref assignment cu))]
                    [n (add1 (get-max-index fvars))])
              `(define ,label 
                       ,(assign-frames-info info n) 
                       ,(assign-frames-tail tail n)))))]))
    
    ; Tail Number -> Tail
    (define (assign-frames-tail t n)
      (match t
        [`(begin ,ss ... ,tail)
         (append (list 'begin)
                 (for/fold ([ss^ '()])
                           ([s (for/list ([s ss]) (assign-frames-stmt s n))])
                    (append ss^ s))
                 (list (assign-frames-tail tail n)))]
        [`(if ,cmp-stmt ,tail1 ,tail2)
         (append (list 'if)
                 (list cmp-stmt)
                 (list (assign-frames-tail tail1 n))
                 (list (assign-frames-tail tail2 n)))]
        [_ t]))

    ;; Info Number -> Info
    (define (assign-frames-info info n)
      (let* ([new-frames (info-ref info 'new-frames)]
             [assignment (info-ref info 'assignment)]
             [assignment^ 
                (for/fold ([assignment^ assignment])
                          ([new-frame new-frames])
                    (assign-fvar assignment^ new-frame n))]
             [info^ (info-set info 'assignment assignment^)])
          (clean-up-info info^)))

    ;; Assignment New-frame Number -> Assignment
    (define (assign-fvar assignment new-frame n)
      (if (empty? new-frame)
          assignment
          (let* ([fvar (make-fvar n)]
                 [assignment^ (info-set assignment (first new-frame) fvar)])
            (assign-fvar assignment^ (rest new-frame) (add1 n)))))

    ;; Info -> Info
    (define (clean-up-info info)
      (let* ([locals (info-ref info 'locals)]
             [undead-out (info-ref info 'undead-out)]
             [conflicts (info-ref info 'conflicts)]
             [assignment (info-ref info 'assignment)]
             [locals^ (remove* (dict-keys assignment) locals)]
             [info^ (info-set '() 'locals locals^)]
             [info^2 (info-set info^ 'undead-out undead-out)]
             [info^3 (info-set info^2 'conflicts conflicts)]
             [info^4 (info-set info^3 'assignment assignment)])
          info^4))
          
    ;; Assignment New-frame (list of Fvar) Number -> Number Assignment
    (define (assign-fvar-to-new-frame assignment new-frame conflict-fvars n)
      (let ([fvar (make-fvar n)])
        (if (member fvar conflict-fvars)
            (assign-fvar-to-new-frame assignment new-frame conflict-fvars (add1 n))
            (values n (info-set assignment new-frame fvar)))))

    ; Stmt Number -> (listof Stmt)
    (define (assign-frames-stmt stmt n)
      (match stmt
        [`(return-point ,label ,tail)
         (let ([fbp (current-frame-base-pointer-register)]
               [offset (* n word-size-bytes)]
               [tail^ (assign-frames-tail tail n)])
            (list `(set! ,fbp (+ ,fbp ,offset))
                  `(return-point ,label ,tail^)
                  `(set! ,fbp (- ,fbp ,offset))))]
          [_ (list stmt)]))

    (define (get-max-index fvars)
      (let ([indices (map fvar->index fvars)])
        ((for/fold ([func max]) ([index indices]) (curry func index)))))
        
    (define (safe-dict-ref dict key)
      (if (member key (dict-keys dict))
          (dict-ref dict key)
          empty))

    ;; (listof fvar) -> fvar
    (define (produce-non-conflict-fvar conflict-fvars) 
      (define (helper indices n)
        (cond
          [(empty? indices) n]
          [(= (first indices) n) (helper (rest indices) (+ n 1))]
          [else n]))
      (let ([indices (set->list (list->set (map fvar->index conflict-fvars)))])
        (make-fvar (helper indices 0))))

    ; Conflict-graph Call-undead -> Assignment
    (define (produce-global-call-undead-assignment gcg gcu) 
      (for/fold ([assignment '()]) ([cu gcu])
        (let* ([conflict-alocs (filter aloc? (info-ref gcg cu))]
               [conflict-fvars
                  (for/fold ([conflict-fvars '()]) ([aloc conflict-alocs])
                    (append conflict-fvars (safe-dict-ref assignment aloc)))]
               [conflict-fvars^ (append (filter fvar? (info-ref gcg cu)) conflict-fvars)]
               [fvar (produce-non-conflict-fvar conflict-fvars^)])
          (cons (list cu fvar) assignment))))

  (match p
    [`(module ,bs ...)
      (append (list 'module)
              (for/list ([b bs])
                (assign-frames-block b)))]))

; Exercise 3
(define (assign-registers p)

  (displayln (format "assign-registers ~a" p))

  ; Block -> Block
  ; Return a block with new Info
  (define (assign-registers-block b)
    (match b
      [`(define ,label ,info ,tail)
       (let* ([locals (info-ref info 'locals)]
              [assignment (info-ref info 'assignment)]
              [conflicts (info-ref info 'conflicts)]
              ; [assignment^ (produce-assignment conflicts assignment)]
              [assignment^ (produce-assignment-local 
                              (sort locals (lambda (x y)  (< (length (safe-info-ref conflicts x)) (length (safe-info-ref conflicts y)))))
                              conflicts 
                              assignment)]
              [assigned-alocs (dict-keys assignment^)]
              [info^ (info-set info 'assignment assignment^)]
              [info^2 (info-set info^ 'locals (set-subtract locals assigned-alocs))])
        `(define ,label ,info^2 ,tail))]))
    
    (define (produce-assignment-local sorted-locals conflicts assignment)
      (define (find-avail-register cloc assign)
        (let ([conf-regs empty])
          (for ([conf (safe-info-ref conflicts cloc)])
            (let ([conf-r (safe-info-ref assign conf)])
              (unless (empty? conf-r)
                (when (register? conf-r)
                  (set! conf-regs (cons conf-r conf-regs))))))
          (let* ([conf-regs^ (append conf-regs
                          (filter rloc? (info-ref conflicts cloc)))]
                [avail-regs (remove* conf-regs^ (current-assignable-registers))])
          ; (displayln (format "conf-regs: ~a conf-regs^: ~a" conf-regs conf-regs^))
            (if (empty? avail-regs)
              empty
              (first (reverse avail-regs))))))

      (if (empty? sorted-locals)
            assignment
            (let* ([cloc (first sorted-locals)]
                    [assignment^ (produce-assignment-local (rest sorted-locals) conflicts assignment)]
                    [cloc-reg (find-avail-register cloc assignment^)])
              (if (empty? cloc-reg)
                assignment^
                (info-set assignment^ cloc cloc-reg))))
        )

    (define (safe-info-ref info key)
      (info-ref info key (lambda () '())))

    (define (safe-dict-ref dict key)
      (if (member key (dict-keys dict))
          (dict-ref dict key)
          empty))

    ; Conflict-graph Assignment -> Assignment
    (define (produce-assignment conflicts assignment) 
      (define sorted-conflicts (sort (filter filter-non-registers conflicts) conflict-<))

      (for/fold ([assignment^ assignment])
                ([conflict (sort (filter filter-non-registers conflicts) conflict-<)])
        (let* ([aloc (first conflict)]
               [conflict-alocs (filter aloc? (second conflict))]
               [conflict-rlocs 
                  (for/fold ([conflict-rlocs '()])
                            ([conflict-aloc conflict-alocs])
                      (append conflict-rlocs (safe-dict-ref assignment^ conflict-aloc)))]
               [conflict-rlocs^
                  (append conflict-rlocs
                          (filter rloc? (info-ref conflicts aloc)))]
               [rloc (produce-non-conflict-rloc conflict-rlocs^)])
            (if (rloc? rloc)
                (cons (list aloc rloc) assignment^)
                assignment^))))

    ; Conflict Conflict -> Boolean
    (define (conflict-< conflict1 conflict2)
      (< (length (second conflict1)) (length (second conflict2))))
    
    (define (filter-non-registers conflict)
      (not (register? (first conflict))))

    ; (listof rloc) -> False or rloc
    (define (produce-non-conflict-rloc conflict-rlocs) 
      (let ([available-rlocs (remove* conflict-rlocs (current-assignable-registers))])
        (if (empty? available-rlocs)
            #f
            (first available-rlocs))))

  (match p
    [`(module ,bs ...)
      (append (list 'module)
              (map assign-registers-block bs))]))