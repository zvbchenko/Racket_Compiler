#lang racket

(require
 racket/set
 "util.rkt"
 "a7-graph-lib.rkt"
 "a7-compiler-lib.rkt"
 )

(provide 
  ;uncover-locals
  ; undead-analysis
  ;conflict-analysis
  ;pre-assign-frame-variables
  ;assign-frames
  ;assign-registers
  )


; Exercise 3
; Block-lang-v6 -> Block-locals-lang-v6
(define (uncover-locals p)

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

; Exercise 5
(define (conflict-analysis p)
  ; Vertex Vertex Graph -> Graph
  ; Return a new graph with an edge from from to to if to is not a neighbor of from
  (define (add-directed-conflict from to conflict-graph)
    (if (or (not (contain-vertex conflict-graph from))
            (eq? from to) 
            (member to (get-neighbors conflict-graph from)))
        conflict-graph
        (add-directed-edge conflict-graph from to)))

  ; Vertex Vertex Graph -> Graph
  ; Return a new graph with edges from a to b and from b to a if they do not already exist
  (define (add-conflict a b conflict-graph)
    (add-directed-conflict b a (add-directed-conflict a b conflict-graph)))

  ; Undead-set-tree Statement Conflict-graph -> Conflict-graph
  ; Update given conflict graph for the given statement and its undead-set-tree
  (define (conflict-analysis-stmt ust s conflict-graph) 
    (match s
      [`(set! ,loc ,_)
       (for/fold ([conflict-graph^ (safe-add-vertex conflict-graph loc)])
                 ([u-loc ust])
          (add-conflict loc u-loc conflict-graph^))]
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

; Exercise 6
(define (pre-assign-frame-variables p)
  ; Block -> Block
  ; Return a block with new Info
  (define (pre-assign-frame-variables-block b gcua)
    (match b
      [`(define ,label ,info ,tail)
       (let ([assignment (localize-assignment (info-ref info 'call-undead) gcua)])
         (append (list 'define)
                 (list label)
                 (list (info-set info 'assignment assignment))
                 (list tail)))]))
    
      ; Block -> Conflict-graph
    (define (get-conflict-graph b)
      (match b
        [`(define ,label ,info ,tail)
         (info-ref info 'conflicts)]))
    
    ; (listof Block) -> Conflict-graph
    ; Return one global conflict graph for all the given blocks
    (define (get-global-conflict-graph bs)
      (define (remove-duplicate conflict graph)
        (info-set graph (first conflict) (set->list (list->set (second conflict)))))
      (foldr remove-duplicate '() (merge-conflicts (map get-conflict-graph bs))))

    ; Block -> Call-undead
    ; Return locals of a block
    (define (get-call-undead b)
      (match b
        [`(define ,label ,info ,tail)
         (info-ref info 'call-undead)]))
    
    ; (listof Block) -> Call-undead
    ; Return one global Call-undead for all the given blocks
    (define (get-global-call-undead bs)
      (for/fold ([global-call-undead '()])
                ([b bs])
        (set->list (list->set (append global-call-undead (get-call-undead b))))))

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
     (let ([gcua (produce-global-call-undead-assignment (get-global-conflict-graph bs) 
                                                        (get-global-call-undead bs))])
        (append (list 'module)
                (for/list ([b bs])
                  (pre-assign-frame-variables-block b gcua))))]))

; Exercise 7
(define (assign-frames p) 
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

; Exercise 8
(define (assign-registers p)
  ; Block -> Block
  ; Return a block with new Info
  (define (assign-registers-block b global-assignment)
    (match b
      [`(define ,label ,info ,tail)
       (let* ([locals (info-ref info 'locals)]
              [assignment (info-ref info 'assignment)]
              [global-assigned-alocs (dict-keys global-assignment)]
              [assigned-locals 
                (set->list (set-intersect (list->set locals)
                                          (list->set global-assigned-alocs)))]
              [assignment^ (append assignment 
                           (localize-assignment assigned-locals global-assignment))]
              [info^ (info-set info 'assignment assignment^)]
              [info^2 (info-set info^ 'locals (remove* assigned-locals locals))])
        `(define ,label ,info^2 ,tail))]))
    
    ; Block -> Conflict-graph
    (define (get-conflict-graph b)
      (match b
        [`(define ,label ,info ,tail)
         (info-ref info 'conflicts)]))
    
    ; (listof Block) -> Conflict-graph
    ; Return one global conflict graph for all the given blocks
    (define (get-global-conflict-graph bs)
      (define (remove-duplicate conflict graph)
        (info-set graph (first conflict) (set->list (list->set (second conflict)))))
      (foldr remove-duplicate '() (merge-conflicts (map get-conflict-graph bs))))

    (define (safe-dict-ref dict key)
      (if (member key (dict-keys dict))
          (dict-ref dict key)
          empty))

    ; Conflict-graph Assignment -> Assignment
    (define (produce-global-assignment conflicts assignment) 
      (for/fold ([assignment^ assignment])
                ([conflict (sort conflicts conflict-<)])
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
    
    ; (listof rloc) -> False or rloc
    (define (produce-non-conflict-rloc conflict-rlocs) 
      (let ([available-rlocs (remove* conflict-rlocs (current-assignable-registers))])
        (if (empty? available-rlocs)
            #f
            (first available-rlocs))))

    ; Block -> Assignment
    (define (get-assignment b)
      (match b
        [`(define ,label ,info ,tail)
         (info-ref info 'assignment)]))

    ; (listof Block) -> Assignment
    (define (get-global-assignment bs)
      (for/fold ([global-assignment '()])
                ([assignment (map get-assignment bs)])
          (append global-assignment assignment)))

  (match p
    [`(module ,bs ...)
     (let* ([assignment (get-global-assignment bs)]
            [conflicts (get-global-conflict-graph bs)]
            [assignment^ (produce-global-assignment conflicts assignment)])
        (append (list 'module)
                (for/list ([b bs])
                  (assign-registers-block b assignment^))))]))
