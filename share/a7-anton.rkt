#lang racket
(require
  racket/set
  "util.rkt"
  "a7-graph-lib.rkt"
  "a7-compiler-lib.rkt"
  )

(provide
 ;implement-safe-primops
; uniquify
 expose-basic-blocks
 )

(module+ test
  (require rackunit))

; Exercise 7
;Exprs-safe-data-lang v7 -> Exprs-data-lang v7
(define (implement-safe-primops p)
  ;(fresh-label "a")
  ;(fresh "a")
  ;;(fresh "a")
  
  (define list_of_ops (list "*" "+" "-" "<" "<=" ">" ">="))
  (define list_of_huhs (list "fixnum?" "boolean?" "empty?" "void?" "ascii-char?" "error?" "not"))
  (define error -1)
  (define (fresh-error)
    (set! error (add1 error))
    error
    )

  (define (generate-primops)
    (define list_operations (let* ([label1 (fresh-label "eq?")]
                                   [var1 (fresh "x")]
                                   [var2 (fresh "y")])
                              (list `(define ,label1 (lambda (,var1 ,var2) (eq? ,var1 ,var2))))))

    (for ([op list_of_ops])
      (let* ([label1 (fresh-label op)]
             [var1 (fresh "x")]
             [var2 (fresh "y")]
             [error-code1 (fresh-error)]
             [error-code2 (fresh-error)])
        (set! list_operations (foldr cons list_operations (list `(define ,label1 (lambda (,var1 ,var2)
                                                                                   (if (fixnum? ,var1)
                                                                                       (if (fixnum? ,var2)
                                                                                           (,(string->symbol (string-append "unsafe-fx" op)) ,var1 ,var2) (error ,error-code2))
                                                                                       (error ,error-code1)))))))))
    (for ([op list_of_huhs])
      (let* ([label1 (fresh-label op)]
             [var1 (fresh "x")]
             
             [error-code1 (fresh-error)]
             )
        (set! list_operations (foldr cons list_operations (list `(define ,label1 (lambda (,var1) (,(string->symbol op) ,var1))))))))

    list_operations
    )

    
    
    



  (define (trampoline p)
    (match p
      [`(module ,b ...) (append `(module) (append (generate-primops) b))]
      ))
  (trampoline p))



#;(module+ test
    (check-equal? (implement-safe-primops
                   '(module
                        (define L.L.swap.1.1
                          (lambda (x.1.1)
                            (let ((z.3.2 (apply L.L.swap.1.1 x.1.1)))
                              z.3.2)))
                      (apply L.L.swap.1.1 1))

                   )

                  '(module
                       (define L.not.16 (lambda (x.25) (not x.25)))
                     (define L.error?.15 (lambda (x.24) (error? x.24)))
                     (define L.ascii-char?.14 (lambda (x.23) (ascii-char? x.23)))
                     (define L.void?.13 (lambda (x.22) (void? x.22)))
                     (define L.empty?.12 (lambda (x.21) (empty? x.21)))
                     (define L.boolean?.11 (lambda (x.20) (boolean? x.20)))
                     (define L.fixnum?.10 (lambda (x.19) (fixnum? x.19)))
                     (define L.>=.9
                       (lambda (x.17 y.18)
                         (if (fixnum? x.17)
                             (if (fixnum? y.18) (unsafe-fx>= x.17 y.18) (error 13))
                             (error 12))))
                     (define L.>.8
                       (lambda (x.15 y.16)
                         (if (fixnum? x.15)
                             (if (fixnum? y.16) (unsafe-fx> x.15 y.16) (error 11))
                             (error 10))))
                     (define L.<=.7
                       (lambda (x.13 y.14)
                         (if (fixnum? x.13)
                             (if (fixnum? y.14) (unsafe-fx<= x.13 y.14) (error 9))
                             (error 8))))
                     (define L.<.6
                       (lambda (x.11 y.12)
                         (if (fixnum? x.11)
                             (if (fixnum? y.12) (unsafe-fx< x.11 y.12) (error 7))
                             (error 6))))
                     (define L.-.5
                       (lambda (x.9 y.10)
                         (if (fixnum? x.9)
                             (if (fixnum? y.10) (unsafe-fx- x.9 y.10) (error 5))
                             (error 4))))
                     (define L.+.4
                       (lambda (x.7 y.8)
                         (if (fixnum? x.7)
                             (if (fixnum? y.8) (unsafe-fx+ x.7 y.8) (error 3))
                             (error 2))))
                     (define L.*.3
                       (lambda (x.5 y.6)
                         (if (fixnum? x.5)
                             (if (fixnum? y.6) (unsafe-fx* x.5 y.6) (error 1))
                             (error 0))))
                     (define L.eq?.2 (lambda (x.3 y.4) (eq? x.3 y.4)))
                     (define L.L.swap.1.1
                       (lambda (x.1.1) (let ((z.3.2 (apply L.L.swap.1.1 x.1.1))) z.3.2)))
                     (apply L.L.swap.1.1 1)))
    (check-equal? (implement-safe-primops '(module
                                               (define L.+.1 (lambda (x.1.1) (let ((z.3.2 (+ x.1 x.1))) z.3.2)))
                                             (apply L.+.1 1)))
               

                  '(module
                       (define L.not.15 (lambda (x.23) (not x.23)))
                     (define L.error?.14 (lambda (x.22) (error? x.22)))
                     (define L.ascii-char?.13 (lambda (x.21) (ascii-char? x.21)))
                     (define L.void?.12 (lambda (x.20) (void? x.20)))
                     (define L.empty?.11 (lambda (x.19) (empty? x.19)))
                     (define L.boolean?.10 (lambda (x.18) (boolean? x.18)))
                     (define L.fixnum?.9 (lambda (x.17) (fixnum? x.17)))
                     (define L.>=.8
                       (lambda (x.15 y.16)
                         (if (fixnum? x.15)
                             (if (fixnum? y.16) (unsafe-fx>= x.15 y.16) (error 13))
                             (error 12))))
                     (define L.>.7
                       (lambda (x.13 y.14)
                         (if (fixnum? x.13)
                             (if (fixnum? y.14) (unsafe-fx> x.13 y.14) (error 11))
                             (error 10))))
                     (define L.<=.6
                       (lambda (x.11 y.12)
                         (if (fixnum? x.11)
                             (if (fixnum? y.12) (unsafe-fx<= x.11 y.12) (error 9))
                             (error 8))))
                     (define L.<.5
                       (lambda (x.9 y.10)
                         (if (fixnum? x.9)
                             (if (fixnum? y.10) (unsafe-fx< x.9 y.10) (error 7))
                             (error 6))))
                     (define L.-.4
                       (lambda (x.7 y.8)
                         (if (fixnum? x.7)
                             (if (fixnum? y.8) (unsafe-fx- x.7 y.8) (error 5))
                             (error 4))))
                     (define L.+.3
                       (lambda (x.5 y.6)
                         (if (fixnum? x.5)
                             (if (fixnum? y.6) (unsafe-fx+ x.5 y.6) (error 3))
                             (error 2))))
                     (define L.*.2
                       (lambda (x.3 y.4)
                         (if (fixnum? x.3)
                             (if (fixnum? y.4) (unsafe-fx* x.3 y.4) (error 1))
                             (error 0))))
                     (define L.eq?.1 (lambda (x.1 y.2) (eq? x.1 y.2)))
                     (define L.+.1 (lambda (x.1.1) (let ((z.3.2 (+ x.1 x.1))) z.3.2)))
                     (apply L.+.1 1)))


    (check-equal? (implement-safe-primops '(module
                                               (define M (lambda (x.1.1)(let ((z.3.2 (if (eq? x.1 0) 1 2))) z.3.2)))
                                             (apply M 1)))
                  '(module
                       (define L.not.15 (lambda (x.23) (not x.23)))
                     (define L.error?.14 (lambda (x.22) (error? x.22)))
                     (define L.ascii-char?.13 (lambda (x.21) (ascii-char? x.21)))
                     (define L.void?.12 (lambda (x.20) (void? x.20)))
                     (define L.empty?.11 (lambda (x.19) (empty? x.19)))
                     (define L.boolean?.10 (lambda (x.18) (boolean? x.18)))
                     (define L.fixnum?.9 (lambda (x.17) (fixnum? x.17)))
                     (define L.>=.8
                       (lambda (x.15 y.16)
                         (if (fixnum? x.15)
                             (if (fixnum? y.16) (unsafe-fx>= x.15 y.16) (error 13))
                             (error 12))))
                     (define L.>.7
                       (lambda (x.13 y.14)
                         (if (fixnum? x.13)
                             (if (fixnum? y.14) (unsafe-fx> x.13 y.14) (error 11))
                             (error 10))))
                     (define L.<=.6
                       (lambda (x.11 y.12)
                         (if (fixnum? x.11)
                             (if (fixnum? y.12) (unsafe-fx<= x.11 y.12) (error 9))
                             (error 8))))
                     (define L.<.5
                       (lambda (x.9 y.10)
                         (if (fixnum? x.9)
                             (if (fixnum? y.10) (unsafe-fx< x.9 y.10) (error 7))
                             (error 6))))
                     (define L.-.4
                       (lambda (x.7 y.8)
                         (if (fixnum? x.7)
                             (if (fixnum? y.8) (unsafe-fx- x.7 y.8) (error 5))
                             (error 4))))
                     (define L.+.3
                       (lambda (x.5 y.6)
                         (if (fixnum? x.5)
                             (if (fixnum? y.6) (unsafe-fx+ x.5 y.6) (error 3))
                             (error 2))))
                     (define L.*.2
                       (lambda (x.3 y.4)
                         (if (fixnum? x.3)
                             (if (fixnum? y.4) (unsafe-fx* x.3 y.4) (error 1))
                             (error 0))))
                     (define L.eq?.1 (lambda (x.1 y.2) (eq? x.1 y.2)))
                     (define M (lambda (x.1.1) (let ((z.3.2 (if (eq? x.1 0) 1 2))) z.3.2)))
                     (apply M 1))
                  )
    (check-equal? (implement-safe-primops '(module
                                               0))
                  '(module
                       (define L.not.15 (lambda (x.23) (not x.23)))
                     (define L.error?.14 (lambda (x.22) (error? x.22)))
                     (define L.ascii-char?.13 (lambda (x.21) (ascii-char? x.21)))
                     (define L.void?.12 (lambda (x.20) (void? x.20)))
                     (define L.empty?.11 (lambda (x.19) (empty? x.19)))
                     (define L.boolean?.10 (lambda (x.18) (boolean? x.18)))
                     (define L.fixnum?.9 (lambda (x.17) (fixnum? x.17)))
                     (define L.>=.8
                       (lambda (x.15 y.16)
                         (if (fixnum? x.15)
                             (if (fixnum? y.16) (unsafe-fx>= x.15 y.16) (error 13))
                             (error 12))))
                     (define L.>.7
                       (lambda (x.13 y.14)
                         (if (fixnum? x.13)
                             (if (fixnum? y.14) (unsafe-fx> x.13 y.14) (error 11))
                             (error 10))))
                     (define L.<=.6
                       (lambda (x.11 y.12)
                         (if (fixnum? x.11)
                             (if (fixnum? y.12) (unsafe-fx<= x.11 y.12) (error 9))
                             (error 8))))
                     (define L.<.5
                       (lambda (x.9 y.10)
                         (if (fixnum? x.9)
                             (if (fixnum? y.10) (unsafe-fx< x.9 y.10) (error 7))
                             (error 6))))
                     (define L.-.4
                       (lambda (x.7 y.8)
                         (if (fixnum? x.7)
                             (if (fixnum? y.8) (unsafe-fx- x.7 y.8) (error 5))
                             (error 4))))
                     (define L.+.3
                       (lambda (x.5 y.6)
                         (if (fixnum? x.5)
                             (if (fixnum? y.6) (unsafe-fx+ x.5 y.6) (error 3))
                             (error 2))))
                     (define L.*.2
                       (lambda (x.3 y.4)
                         (if (fixnum? x.3)
                             (if (fixnum? y.4) (unsafe-fx* x.3 y.4) (error 1))
                             (error 0))))
                     (define L.eq?.1 (lambda (x.1 y.2) (eq? x.1 y.2)))
                     0))

  
    )


#;((compose
    
    implement-safe-primops
    uniquify)
   '(module
        (define L.+
          (lambda (x.1)
            (let ([z.3 (+ x.1 x.1)])
              z.3)))
      (apply L.+. 1))
   )

; Exercise 8

(define (name? s)
  (and (symbol? s)
       (not (register? s))
       (not (valid-binop? s))
       (not (cmp? s))
       (or (regexp-match-exact? #rx"([a-z]+[0-9]+)" (symbol->string s))
           (regexp-match-exact? #rx"([a-z]+)" (symbol->string s))
           (regexp-match-exact? #rx"([A-Z]+[0-9]+)" (symbol->string s))
           (regexp-match-exact? #rx"([A-Z]+)" (symbol->string s)))
       ))

(define (uniquify p)
  ; (displayln (format "uniquify ~a" p))

  (define (label-name? s)(and (symbol? s)
                              (regexp-match-exact? #rx"L\\..+\\.[0-9]+" (symbol->string s))))

  (define var-dict (make-hash))

  (define (generate-unique-label x)
    (if (or (valid-binop? x) (cmp? x))
        x
        (if (dict-has-key? var-dict x)
            (dict-ref var-dict x)
            (begin
              (dict-set! var-dict x (fresh-label x))
              (dict-ref var-dict x)))))

  
  (define (generate-unique b)
    (match b

      
      ;e-expressions
     
      
      #;[v #:when (and (symbol? v)
                       (not (aloc? v))
                       (not (valid-binop? v))
                       (not (cmp? v)))
           (if (dict-has-key? var-dict v)
               (dict-ref var-dict v)
               (begin
                 (dict-set! var-dict v (fresh-label v))
                 (dict-ref var-dict v)))]
      [v #:when  (or (name? v )(loc? v))
         (if (dict-has-key? var-dict v)
             (dict-ref var-dict v)
             (begin
               (dict-set! var-dict v (fresh v))
               (dict-ref var-dict v)))]
     
      
      [`(apply ,e1 ,e2 ...)`(apply ,(generate-unique-label e1) ,@(map generate-unique e2))]
      [`(let ([,x ,e1]) ,e2)`(let ([,(generate-unique x) ,(generate-unique e1)]) ,(generate-unique e2))]
      [`(let ((,x ,e1)) ,e2)`(let ((,(generate-unique x) ,(generate-unique e1))) ,(generate-unique e2))]
      [`(if ,e1 ,e2 ,e3)`(if ,(generate-unique e1) ,(generate-unique e2) ,(generate-unique e3))]
      [`(define ,x1 (lambda (,x2 ...) ,e))`(define ,(generate-unique-label x1)
                                             (lambda (,@(map generate-unique x2))
                                               ,(generate-unique e)))]
      [else b]

      ))


  (define (trampoline p)
    (match p
      [`(module ,b ...) (append `(module) (map generate-unique b))]
      ))
  (trampoline p))


#;(module+ test
    (check-equal? (uniquify '(module
                                 (define L.swap.1
                                   (lambda (x.1)
                                     (let ([z.3 (apply L.swap.1 x.1)])
                                       z.3)))
                               (apply L.swap.1 1))
                            )
                  '(module
                       (define L.L.swap.1.1
                         (lambda (x.1.1) (let ((z.3.2 (apply L.L.swap.1.1 x.1.1))) z.3.2)))
                     (apply L.L.swap.1.1 1)))
    (check-equal? (uniquify '(module
                                 (define L.+
                                   (lambda (x.1)
                                     (let ([z.3 (+ x.1 x.1)])
                                       z.3)))
                               (apply L.+ 1)))
                  '(module
                       (define L.L.+.1 (lambda (x.1.1) (let ((z.3.2 (+ x.1 x.1))) z.3.2)))
                     (apply L.L.+.1 1)))
    (check-equal? (uniquify '(module 0))
                  '(module 0))
                    
    )


(define (expose-basic-blocks p)
  (displayln (format "expose ~a" p))

  (define (construct-defs label info tail)
    (local [(define defs empty)
        (define (make-def label info s) 
          `(define ,label ,info (begin ,@(reverse s))))    

        (define (construct-impl label info tail acc)
           (if (empty? tail)
            (set! defs (cons (make-def label info acc) defs))
            (match (first tail)
              [`(set! ,v1 ,v2) (construct-impl label info (rest tail) (cons (first tail) acc))]
              [`(mset! ,loc ,index ,triv)(construct-impl label info (rest tail) (cons (first tail) acc))] ;; added line
              [`(mref ,loc ,index)(construct-impl label info (rest tail) (cons (first tail) acc))] ;; added line
              [`(return-point ,rlabel ,rtail) 
                  (begin (construct-impl rlabel '() (rest tail) empty)
                         (construct-impl label info rtail acc))]
              [`(jump ,trg) (construct-impl label info (rest tail) (cons (first tail) acc))]
              [`(if (,cmp ,v1 ,v2) ,t1 ,t2) 
                (let* ([t-label (fresh-label 'nest_t)]
                      [f-label (fresh-label 'nest_f)]
                      [last-s `(if (,cmp ,v1 ,v2) (jump ,t-label) (jump ,f-label))])
                  (begin (construct-impl label info (rest tail) (cons last-s acc))
                         (construct-impl t-label empty t1 empty)
                         (construct-impl f-label empty t2 empty)))]
              [`begin (construct-impl label info (rest tail) acc)]
              [`if (match tail
                      [`(if (,cmp ,v1 ,v2) ,t1 ,t2) 
                          (let* ([t-label (fresh-label 'nest_t)]
                                [f-label (fresh-label 'nest_f)]
                                [last-s `(if (,cmp ,v1 ,v2) (jump ,t-label) (jump ,f-label))])
                            (begin (construct-impl label info empty (cons last-s acc))
                                  (construct-impl t-label empty t1 empty)
                                  (construct-impl f-label empty t2 empty)))])]
              ['jump (match tail
                        (construct-impl label info empty (cons (first tail) acc)))]
              [else (construct-impl label info (rest tail) (cons (first tail) acc))]))

          )]
    (begin
    (match tail
      [`(begin ,s ... ) (construct-impl label info s empty)]
      [`(jump ,label) (set! defs (cons `(define ,label ,info ,tail) defs))]
      [`(if (,cmp ,rloc ,opand) ,t1 ,t2) (construct-impl label info tail empty)])
      ; (displayln (format "~a" defs))
      defs)
  ))

  (define (expose-b b)
    (match b
      [`(define ,label ,info ,tail)
          (construct-defs label info tail)]
      [_ empty]))

  (define (find-main b)
    (if (empty? b)
      empty
      (match (first b)
        [`(define ,label ,info ,tail)
          (if (regexp-match-exact? #rx"L\\.main\\.[0-9]+" (symbol->string label))
            (begin ;(displayln label)
              (first b))
            (find-main (rest b)))]
        [_ empty])))

;; assume thers is a label contain main
  (match p 
    [`(module ,bs ...) 
      (let* ([res (append-map expose-b bs)]
            [main (find-main res)]
            [rest-list (remove main res)])
            ;  (displayln (format "\n\n res is ~a \n main is ~a \n removed is ~a" res main rest-list))
        `(module ,main ,@rest-list)
      )])
)

(module+ test
(check-equal? 
(expose-basic-blocks '(module
                          (define L.main.1 () (begin (nop) (set! rdi 1) (nop) (jump L.swap.1)))
                        (define L.swap.1
                          ()
                          (begin
                            (set! (rbp + 0) r15)
                            (set! r15 rdi)
                            (return-point L.rp.2
                                          (begin (set! rdi r15) (return-point L.rp.1
                                          (begin (set! rdi r15) (jump L.swap.1))) (jump L.swap.1)))
                            (set! r15 rax)
                            (set! rax r15)
                            (jump (rbp + 0))))))

'(module
  (define L.main.1 () (begin (nop) (set! rdi 1) (nop) (jump L.swap.1)))
  (define L.swap.1
    ()
    (begin
      (set! (rbp + 0) r15)
      (set! r15 rdi)
      (set! rdi r15)
      (set! rdi r15)
      (jump L.swap.1)))
  (define L.rp.1 () (begin (jump L.swap.1)))
  (define L.rp.2 () (begin (set! r15 rax) (set! rax r15) (jump (rbp + 0)))))
  )

  (check-equal? (expose-basic-blocks `(module (define L.main.1 () (begin (set! rsp r15) (set! rdi 56) (set! rsi 22) (set! r15 rsp) (jump cons))) )
)
'(module
  (define L.main.1
    ()
    (begin
      (set! rsp r15)
      (set! rdi 56)
      (set! rsi 22)
      (set! r15 rsp)
      (jump cons)))))

(check-match (expose-basic-blocks `(module (define L.not.15 () (begin (set! rsp r15) (set! rsp rdi) (set! rsp rsp) 
    (if (neq? rsp 6) (begin (set! rax 6) (jump rsp)) (begin (set! rax 14) (jump rsp))))) )
)
`,(list-no-order 'module
  `(define L.not.15
    ()
    (begin
      (set! rsp r15)
      (set! rsp rdi)
      (set! rsp rsp)
      (if (neq? rsp 6) (jump L.nest_t.1) (jump L.nest_f.2))))
  `(define L.nest_t.1 () (begin (set! rax 6) (jump rsp)))
  `(define L.nest_f.2 () (begin (set! rax 14) (jump rsp))))
)

(check-match (expose-basic-blocks `(module (define L.error?.14 () (begin (set! rsp r15) (set! rsp rdi) (set! rsp rsp) (set! rsp (bitwise-and rsp 255)) (set! rsp rsp) (if (eq? rsp 62) (begin (set! rax 14) (jump rsp)) (begin (set! rax 6) (jump rsp))))) 
))
`,(list-no-order 'module
  `(define L.error?.14
    ()
    (begin
      (set! rsp r15)
      (set! rsp rdi)
      (set! rsp rsp)
      (set! rsp (bitwise-and rsp 255))
      (set! rsp rsp)
      (if (eq? rsp 62) (jump L.nest_t.3) (jump L.nest_f.4))))
  `(define L.nest_t.3 () (begin (set! rax 14) (jump rsp)))
  `(define L.nest_f.4 () (begin (set! rax 6) (jump rsp))))
)

(check-equal? (expose-basic-blocks '(module
                                          (define L.main.1 () (begin (nop) (set! rdi 1) (nop) (jump L.swap.1)))
                                        (define L.swap.1
                                          ()
                                          (begin
                                            (set! (rbp + 0) r15)
                                            (set! r15 rdi)
                                            (set! rbp (+ rbp 8))
                                            (return-point L.rp.2
                                                          (begin (set! rdi r15) (set! r15 L.rp.2) (jump L.swap.1)))
                                            (set! rbp (- rbp 8))
                                            (set! r15 rax)
                                            (set! rax r15)
                                            (jump (rbp + 0))))))
                '(module
                     (define L.main.1 () (begin (nop) (set! rdi 1) (nop) (jump L.swap.1)))
                   (define L.swap.1
                     ()
                     (begin
                       (set! (rbp + 0) r15)
                       (set! r15 rdi)
                       (set! rbp (+ rbp 8))
                       (set! rdi r15)
                       (set! r15 L.rp.2)
                       (jump L.swap.1)))
                   (define L.rp.2
                     ()
                     (begin
                       (set! rbp (- rbp 8))
                       (set! r15 rax)
                       (set! rax r15)
                       (jump (rbp + 0))))))


  (check-match
   (expose-basic-blocks
    '(module
         (define L.main.3
           ()
           (begin
             (set! (rbp + 0) r15)
             (set! rbp (+ rbp 8))
             (return-point L.rp.4
                           (begin
                             (set! rsi 2)
                             (set! rdi 1)
                             (set! r15 L.rp.4)
                             (jump L.L.f1.1.2)))
             (set! rbp (- rbp 8))
             (set! r15 rax)
             (set! rsi r15)
             (set! rdi r15)
             (set! r15 (rbp + 0))
             (jump L.L.f1.1.2)))
       (define L.L.f1.1.8
         ()
         (begin
           (nop)
           (set! r14 rdi)
           (set! r13 rsi)
           (set! r14 (+ r14 r13))
           (set! rax r14)
           (jump r15)))))
   `,(list-no-order 'module
        `(define L.main.3
          ()
          (begin
            (set! (rbp + 0) r15)
            (set! rbp (+ rbp 8))
            (set! rsi 2)
            (set! rdi 1)
            (set! r15 L.rp.4)
            (jump L.L.f1.1.2)))
      `(define L.L.f1.1.8
        ()
        (begin
          (nop)
          (set! r14 rdi)
          (set! r13 rsi)
          (set! r14 (+ r14 r13))
          (set! rax r14)
          (jump r15)))
      `(define L.rp.4
        ()
        (begin
          (set! rbp (- rbp 8))
          (set! r15 rax)
          (set! rsi r15)
          (set! rdi r15)
          (set! r15 (rbp + 0))
          (jump L.L.f1.1.2)))))


(check-match (expose-basic-blocks '(module 
(define L.main.1 () (begin (set! rsp r15) (set! rdi 56) (set! rsi 22) (set! r15 rsp) (jump cons))) 
(define L.not.15 () (begin (set! rsp r15) (set! rsp rdi) (set! rsp rsp) 
    (if (neq? rsp 6) (begin (set! rax 6) (jump rsp)) (begin (set! rax 14) (jump rsp)))))))
    `,(list-no-order 'module
  `(define L.main.1
    ()
    (begin
      (set! rsp r15)
      (set! rdi 56)
      (set! rsi 22)
      (set! r15 rsp)
      (jump cons)))
  `(define L.not.15
    ()
    (begin
      (set! rsp r15)
      (set! rsp rdi)
      (set! rsp rsp)
      (if (neq? rsp 6) (jump L.nest_t.5) (jump L.nest_f.6))))
  `(define L.nest_t.5 () (begin (set! rax 6) (jump rsp)))
  `(define L.nest_f.6 () (begin (set! rax 14) (jump rsp))))
  )
)