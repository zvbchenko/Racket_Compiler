#lang racket

(require
  racket/set
  "util.rkt"
  "a8-graph-lib.rkt"
  "a8-compiler-lib.rkt"
  )
(provide
 implement-safe-primops
 uniquify
 )


(module+ test
  (require rackunit))

; Ex 8
;Exprs-safe-data-lang v8 -> Exprs-data-lang v8
(define (reserved-funct-name? s)
  ; (displayln (format "reserved-funct-name? ~a" s))
  (member s '(make-vector vector-set! vector-length
                          vector-ref procedure-arity
                          cdr car cons vector? procedure? pair?
                          not error? ascii-char? void? empty?
                          boolean? fixnum? * + - eq? < <= > >=)))

(define OPERATIONS (make-hash))


(define (implement-safe-primops p)
  ;(fresh-label "a")
  ;(fresh "a")
  ;;(fresh "a")
  
  (define list_of_ops (list "*" "+" "-" "<" "<=" ">" ">="))
  (define list_of_huhs (list "fixnum?" "boolean?" "empty?" "void?" "ascii-char?" "error?" "pair?" "procedure?" "vector?" "not"))
  (define list_of_both (list "cons" "eq?"))
  (define error -1)
  (define (fresh-error)
    (set! error (add1 error))
    error
    )

  (define (generate-primops)
    
    (define list_operations empty)
  

    (define make-init-vector-label (fresh-label "make-init-vector"))
    (dict-set! OPERATIONS make-init-vector-label "make-init-vector") ;update dictionary

    (define unsafe-vector-set-label (fresh-label "unsafe-vector-set!"))
    (dict-set! OPERATIONS unsafe-vector-set-label "unsafe-vector-set!") ;update dictionary

    (define unsafe-vector-ref-label (fresh-label "unsafe-vector-ref"))
    (dict-set! OPERATIONS unsafe-vector-set-label "unsafe-vector-ref") ;update dictionary
    
    ;; Basic Operations
    (for ([op list_of_ops])
      (let* ([label1 (fresh-label op)]
             [var1 (fresh "x")]
             [var2 (fresh "y")]
             [error-code1 (fresh-error)]
             )
        (dict-set! OPERATIONS op label1) ;update dictionary
        (set! list_operations (foldr cons list_operations (list `(define ,label1 (lambda (,var1 ,var2)
                                                                                   (if (fixnum? ,var2)
                                                                                       (if (fixnum? ,var1)
                                                                                           (,(string->symbol (string-append "unsafe-fx" op)) ,var1 ,var2) (error ,error-code1))
                                                                                       (error ,error-code1)))))))))
    ;;Vector: make, length, set!
    
    
    (let* ([label1 (fresh-label "make-vector")]
           [var1 (fresh "x")]
           
           [error-code1 (fresh-error)]
           )
      (dict-set! OPERATIONS "make-vector" label1) ;update dictionary
      (set! list_operations (foldr cons list_operations (list `(define ,label1
                                                                 (lambda (,var1)
                                                                   (if (fixnum? ,var1) (apply ,make-init-vector-label ,var1) (error ,error-code1))))))))
    (let* ([label1 (fresh-label "vector-length")]
           [var1 (fresh "x")]
           
           [error-code1 (fresh-error)]
           )
      (dict-set! OPERATIONS "vector-length" label1) ;update dictionary
      (set! list_operations (foldr cons list_operations (list `(define ,label1
                                                                 (lambda (,var1)
                                                                   (if (vector? ,var1) (unsafe-vector-length ,var1) (error ,error-code1))))))))

    (define error-code-set (fresh-error))
    (let* ([label1 (fresh-label "vector-set!")]
           [var1 (fresh "x")]
           [var2 (fresh "y")]
           [var3 (fresh "z")]
           
           )
      (dict-set! OPERATIONS "vector-set!" label1) ;update dictionary
      (set! list_operations (foldr cons list_operations (list `(define ,label1 (lambda (,var1 ,var2 ,var3)
                                                                                 (if (fixnum? ,var2)
                                                                                     (if (vector? ,var1)
                                                                                         (apply ,unsafe-vector-set-label ,var1 ,var2 ,var3)
                                                                                         (error ,error-code-set))
                                                                                     (error ,error-code-set))))))))
    (define error-code-ref (fresh-error)) 
    (let* ([label1 (fresh-label "vector-ref")]
           [var1 (fresh "x")]
           [var2 (fresh "y")]
           
           )
      (dict-set! OPERATIONS "vector-ref" label1) ;update dictionary
      (set! list_operations (foldr cons list_operations (list `(define ,label1 (lambda (,var1 ,var2)
                                                                                 (if (fixnum? ,var2)
                                                                                     (if (vector? ,var1)
                                                                                         (apply ,unsafe-vector-ref-label ,var1 ,var2)
                                                                                         (error ,error-code-ref))
                                                                                     (error ,error-code-ref))))))))

    ;;  car and cdr

    (define list_of_cs (list "car" "cdr" "procedure-arity"))
    (for ([op list_of_cs])
      (let* ([label1 (fresh-label op)]
             [var1 (fresh "x")]
           
             [error-code1 (fresh-error)]
             )
        (dict-set! OPERATIONS op label1) ;update dictionary
        (if (eq? op "procedure-arity")
            (set! list_operations (foldr cons list_operations (list `(define ,label1 (lambda (,var1) (if (procedure? ,var1) (,(string->symbol (string-append "unsafe-" op)) ,var1)
                                                                                                         (error ,error-code1)
                                                                                                         ))))))
            (set! list_operations (foldr cons list_operations (list `(define ,label1 (lambda (,var1) (if (pair? ,var1) (,(string->symbol (string-append "unsafe-" op)) ,var1)
                                                                                                         (error ,error-code1)
                                                                                                         )))))))))
    



    ;; Booleans: 
    (for ([op list_of_huhs])
      (let* ([label1 (fresh-label op)]
             [var1 (fresh "x")]
             
             [error-code1 (fresh-error)]
             )
        (dict-set! OPERATIONS op label1) ;update dictionary
        (set! list_operations (foldr cons list_operations (list `(define ,label1 (lambda (,var1) (,(string->symbol op) ,var1))))))))
    
    (for ([b list_of_both])
      (let* ([label1 (fresh-label b)]
             [var1 (fresh "x")]
             [var2 (fresh "y")])
        (dict-set! OPERATIONS b label1) ;update dictionary
        (set! list_operations (foldr cons list_operations (list `(define ,label1 (lambda (,var1 ,var2) (,(string->symbol b) ,var1 ,var2))))))))

    ;; Vectors:
    (define vector-init-loop-label (fresh-label "vector-init-loop"))

    ;; make
    (let* (
           [var1 (fresh "x")]
           [var2 (fresh "y")])
      (dict-set! OPERATIONS "vector-init-loop" vector-init-loop-label) ;update dictionary
      (set! list_operations (foldr cons list_operations
                                   (list `(define ,make-init-vector-label (lambda (,var1) (let ((,var2 (unsafe-make-vector ,var1)))
                                                                                            (apply ,vector-init-loop-label ,var1 0 ,var2))))))))
    ;; init

    (let* (
           [var1 (fresh "len")]
           [var2 (fresh "vec")]
           [var3 (fresh "i")])
      (set! list_operations (foldr cons list_operations
                                   (list `(define ,vector-init-loop-label
                                            (lambda (,var1 ,var3 ,var2)
                                              (if (eq? ,var1 ,var3)
                                                  ,var2
                                                  (begin
                                                    (unsafe-vector-set! ,var2 ,var3 0)
                                                    (apply ,vector-init-loop-label ,var1 (unsafe-fx+ ,var3 1) ,var2)))))))))
    ;; ref + set 
    
    

    (let* (
           [var1 (fresh "x")]
           [var2 (fresh "y")]
           [var3 (fresh "z")]

           )
      (set! list_operations (foldr cons list_operations
                                   (list  `(define ,unsafe-vector-ref-label
                                             (lambda (,var1 ,var2)
                                               (if (unsafe-fx< ,var2 (unsafe-vector-length ,var1))
                                                   (if (unsafe-fx>= ,var2 0)
                                                       (unsafe-vector-ref ,var1 ,var2)
                                                       (error ,error-code-ref))
                                                   (error ,error-code-ref))))
                                          `(define ,unsafe-vector-set-label
                                             (lambda (,var1 ,var2 ,var3)
                                               (if (unsafe-fx< ,var2 (unsafe-vector-length ,var1))
                                                   (if (unsafe-fx>= tmp.45 0)
                                                       (begin (unsafe-vector-set! ,var1 ,var2 ,var3) ,var1)
                                                       (error ,error-code-set))
                                                   (error ,error-code-set))))))))
    

    
    

    list_operations
    )

  
  (define (substitute-seq b)
    (match b

      
      ;e-expressions
     
      
     
      
      [`(apply ,e1 ,e2 ...)`(apply ,(if (dict-has-key? OPERATIONS (symbol->string e1)) (dict-ref OPERATIONS (symbol->string e1)) e1) ,@(map substitute-seq e2))]
      [`(let ([,x ,e1]) ,e2)`(let ([,(substitute-seq x) ,(substitute-seq e1)]) ,(substitute-seq e2))]
      [`(let ((,x ,e1)) ,e2)`(let ((,(substitute-seq x) ,(substitute-seq e1))) ,(substitute-seq e2))]
      [`(if ,e1 ,e2 ,e3)`(if ,(substitute-seq e1) ,(substitute-seq e2) ,(substitute-seq e3))]
      [`(define ,x1 (lambda (,x2 ...) ,e))`(define ,(substitute-seq x1)
                                             (lambda (,@(map substitute-seq x2))
                                               ,(substitute-seq e)))]
      [else b]

      ))
    
    



  (define (trampoline p)
    (match p
      [`(module ,b ...) (append `(module) (append (generate-primops) (map substitute-seq b)))]
      ))
  (trampoline p))






(module+ test
  (check-equal? (implement-safe-primops '(module
                                             (let ((x.1.1 (apply make-vector 2)))
                                               (let ((x.2.2 (apply vector-set! x.1.1 0 1)))
                                                 (let ((x.3.3 (apply vector-set! x.1.1 1 2)))
                                                   (let ((x.4.4 (apply vector-set! x.1.1 2 3))) x.4.4))))))
                '(module
                     (define L.unsafe-vector-ref.3
                       (lambda (tmp.44 tmp.45)
                         (if (unsafe-fx< tmp.45 (unsafe-vector-length tmp.44))
                             (if (unsafe-fx>= tmp.45 0)
                                 (unsafe-vector-ref tmp.44 tmp.45)
                                 (error 10))
                             (error 10))))
                   (define L.unsafe-vector-set!.2
                     (lambda (tmp.44 tmp.45 tmp.46)
                       (if (unsafe-fx< tmp.45 (unsafe-vector-length tmp.44))
                           (if (unsafe-fx>= tmp.45 0)
                               (begin (unsafe-vector-set! tmp.44 tmp.45 tmp.46) tmp.44)
                               (error 9))
                           (error 9))))
                   (define L.vector-init-loop.30
                     (lambda (len.41 i.43 vec.42)
                       (if (eq? len.41 i.43)
                           vec.42
                           (begin
                             (unsafe-vector-set! vec.42 i.43 0)
                             (apply L.vector-init-loop.30 len.41 (unsafe-fx+ i.43 1) vec.42)))))
                   (define L.make-init-vector.1
                     (lambda (tmp.39)
                       (let ((tmp.40 (unsafe-make-vector tmp.39)))
                         (apply L.vector-init-loop.30 tmp.39 0 tmp.40))))
                   (define L.eq?.29 (lambda (tmp.37 tmp.38) (eq? tmp.37 tmp.38)))
                   (define L.cons.28 (lambda (tmp.35 tmp.36) (cons tmp.35 tmp.36)))
                   (define L.not.27 (lambda (tmp.34) (not tmp.34)))
                   (define L.vector?.26 (lambda (tmp.33) (vector? tmp.33)))
                   (define L.procedure?.25 (lambda (tmp.32) (procedure? tmp.32)))
                   (define L.pair?.24 (lambda (tmp.31) (pair? tmp.31)))
                   (define L.error?.23 (lambda (tmp.30) (error? tmp.30)))
                   (define L.ascii-char?.22 (lambda (tmp.29) (ascii-char? tmp.29)))
                   (define L.void?.21 (lambda (tmp.28) (void? tmp.28)))
                   (define L.empty?.20 (lambda (tmp.27) (empty? tmp.27)))
                   (define L.boolean?.19 (lambda (tmp.26) (boolean? tmp.26)))
                   (define L.fixnum?.18 (lambda (tmp.25) (fixnum? tmp.25)))
                   (define L.procedure-arity.17
                     (lambda (tmp.24)
                       (if (procedure? tmp.24) (unsafe-procedure-arity tmp.24) (error 13))))
                   (define L.cdr.16
                     (lambda (tmp.23) (if (pair? tmp.23) (unsafe-cdr tmp.23) (error 12))))
                   (define L.car.15
                     (lambda (tmp.22) (if (pair? tmp.22) (unsafe-car tmp.22) (error 11))))
                   (define L.vector-ref.14
                     (lambda (tmp.20 tmp.21)
                       (if (fixnum? tmp.21)
                           (if (vector? tmp.20)
                               (apply L.unsafe-vector-ref.3 tmp.20 tmp.21)
                               (error 10))
                           (error 10))))
                   (define L.vector-set!.13
                     (lambda (tmp.17 tmp.18 tmp.19)
                       (if (fixnum? tmp.18)
                           (if (vector? tmp.17)
                               (apply L.unsafe-vector-set!.2 tmp.17 tmp.18 tmp.19)
                               (error 9))
                           (error 9))))
                   (define L.vector-length.12
                     (lambda (tmp.16)
                       (if (vector? tmp.16) (unsafe-vector-length tmp.16) (error 8))))
                   (define L.make-vector.11
                     (lambda (tmp.15)
                       (if (fixnum? tmp.15) (apply L.make-init-vector.1 tmp.15) (error 7))))
                   (define L.>=.10
                     (lambda (tmp.13 tmp.14)
                       (if (fixnum? tmp.14)
                           (if (fixnum? tmp.13) (unsafe-fx>= tmp.13 tmp.14) (error 6))
                           (error 6))))
                   (define L.>.9
                     (lambda (tmp.11 tmp.12)
                       (if (fixnum? tmp.12)
                           (if (fixnum? tmp.11) (unsafe-fx> tmp.11 tmp.12) (error 5))
                           (error 5))))
                   (define L.<=.8
                     (lambda (tmp.9 tmp.10)
                       (if (fixnum? tmp.10)
                           (if (fixnum? tmp.9) (unsafe-fx<= tmp.9 tmp.10) (error 4))
                           (error 4))))
                   (define L.<.7
                     (lambda (tmp.7 tmp.8)
                       (if (fixnum? tmp.8)
                           (if (fixnum? tmp.7) (unsafe-fx< tmp.7 tmp.8) (error 3))
                           (error 3))))
                   (define L.-.6
                     (lambda (tmp.5 tmp.6)
                       (if (fixnum? tmp.6)
                           (if (fixnum? tmp.5) (unsafe-fx- tmp.5 tmp.6) (error 2))
                           (error 2))))
                   (define L.+.5
                     (lambda (tmp.3 tmp.4)
                       (if (fixnum? tmp.4)
                           (if (fixnum? tmp.3) (unsafe-fx+ tmp.3 tmp.4) (error 1))
                           (error 1))))
                   (define L.*.4
                     (lambda (tmp.1 tmp.2)
                       (if (fixnum? tmp.2)
                           (if (fixnum? tmp.1) (unsafe-fx* tmp.1 tmp.2) (error 0))
                           (error 0))))
                   (let ((x.1.1 (apply L.make-vector.11 2)))
                     (let ((x.2.2 (apply L.vector-set!.13 x.1.1 0 1)))
                       (let ((x.3.3 (apply L.vector-set!.13 x.1.1 1 2)))
                         (let ((x.4.4 (apply L.vector-set!.13 x.1.1 2 3))) x.4.4))))))


  (check-equal? (implement-safe-primops '(module
                                             (let ((x.1.1 (apply make-vector 2)))
                                               (let ((x.2.2 (apply vector-set! x.1.1 0 1)))
                                                 (let ((x.3.3 (apply vector-set! x.1.1 1 2)))
                                                   (let ((x.4.4 (apply + x.2.2 x.3.3))) x.4.4))))))
                '(module
                     (define L.unsafe-vector-ref.3
                       (lambda (tmp.44 tmp.45)
                         (if (unsafe-fx< tmp.45 (unsafe-vector-length tmp.44))
                             (if (unsafe-fx>= tmp.45 0)
                                 (unsafe-vector-ref tmp.44 tmp.45)
                                 (error 10))
                             (error 10))))
                   (define L.unsafe-vector-set!.2
                     (lambda (tmp.44 tmp.45 tmp.46)
                       (if (unsafe-fx< tmp.45 (unsafe-vector-length tmp.44))
                           (if (unsafe-fx>= tmp.45 0)
                               (begin (unsafe-vector-set! tmp.44 tmp.45 tmp.46) tmp.44)
                               (error 9))
                           (error 9))))
                   (define L.vector-init-loop.30
                     (lambda (len.41 i.43 vec.42)
                       (if (eq? len.41 i.43)
                           vec.42
                           (begin
                             (unsafe-vector-set! vec.42 i.43 0)
                             (apply L.vector-init-loop.30 len.41 (unsafe-fx+ i.43 1) vec.42)))))
                   (define L.make-init-vector.1
                     (lambda (tmp.39)
                       (let ((tmp.40 (unsafe-make-vector tmp.39)))
                         (apply L.vector-init-loop.30 tmp.39 0 tmp.40))))
                   (define L.eq?.29 (lambda (tmp.37 tmp.38) (eq? tmp.37 tmp.38)))
                   (define L.cons.28 (lambda (tmp.35 tmp.36) (cons tmp.35 tmp.36)))
                   (define L.not.27 (lambda (tmp.34) (not tmp.34)))
                   (define L.vector?.26 (lambda (tmp.33) (vector? tmp.33)))
                   (define L.procedure?.25 (lambda (tmp.32) (procedure? tmp.32)))
                   (define L.pair?.24 (lambda (tmp.31) (pair? tmp.31)))
                   (define L.error?.23 (lambda (tmp.30) (error? tmp.30)))
                   (define L.ascii-char?.22 (lambda (tmp.29) (ascii-char? tmp.29)))
                   (define L.void?.21 (lambda (tmp.28) (void? tmp.28)))
                   (define L.empty?.20 (lambda (tmp.27) (empty? tmp.27)))
                   (define L.boolean?.19 (lambda (tmp.26) (boolean? tmp.26)))
                   (define L.fixnum?.18 (lambda (tmp.25) (fixnum? tmp.25)))
                   (define L.procedure-arity.17
                     (lambda (tmp.24)
                       (if (procedure? tmp.24) (unsafe-procedure-arity tmp.24) (error 13))))
                   (define L.cdr.16
                     (lambda (tmp.23) (if (pair? tmp.23) (unsafe-cdr tmp.23) (error 12))))
                   (define L.car.15
                     (lambda (tmp.22) (if (pair? tmp.22) (unsafe-car tmp.22) (error 11))))
                   (define L.vector-ref.14
                     (lambda (tmp.20 tmp.21)
                       (if (fixnum? tmp.21)
                           (if (vector? tmp.20)
                               (apply L.unsafe-vector-ref.3 tmp.20 tmp.21)
                               (error 10))
                           (error 10))))
                   (define L.vector-set!.13
                     (lambda (tmp.17 tmp.18 tmp.19)
                       (if (fixnum? tmp.18)
                           (if (vector? tmp.17)
                               (apply L.unsafe-vector-set!.2 tmp.17 tmp.18 tmp.19)
                               (error 9))
                           (error 9))))
                   (define L.vector-length.12
                     (lambda (tmp.16)
                       (if (vector? tmp.16) (unsafe-vector-length tmp.16) (error 8))))
                   (define L.make-vector.11
                     (lambda (tmp.15)
                       (if (fixnum? tmp.15) (apply L.make-init-vector.1 tmp.15) (error 7))))
                   (define L.>=.10
                     (lambda (tmp.13 tmp.14)
                       (if (fixnum? tmp.14)
                           (if (fixnum? tmp.13) (unsafe-fx>= tmp.13 tmp.14) (error 6))
                           (error 6))))
                   (define L.>.9
                     (lambda (tmp.11 tmp.12)
                       (if (fixnum? tmp.12)
                           (if (fixnum? tmp.11) (unsafe-fx> tmp.11 tmp.12) (error 5))
                           (error 5))))
                   (define L.<=.8
                     (lambda (tmp.9 tmp.10)
                       (if (fixnum? tmp.10)
                           (if (fixnum? tmp.9) (unsafe-fx<= tmp.9 tmp.10) (error 4))
                           (error 4))))
                   (define L.<.7
                     (lambda (tmp.7 tmp.8)
                       (if (fixnum? tmp.8)
                           (if (fixnum? tmp.7) (unsafe-fx< tmp.7 tmp.8) (error 3))
                           (error 3))))
                   (define L.-.6
                     (lambda (tmp.5 tmp.6)
                       (if (fixnum? tmp.6)
                           (if (fixnum? tmp.5) (unsafe-fx- tmp.5 tmp.6) (error 2))
                           (error 2))))
                   (define L.+.5
                     (lambda (tmp.3 tmp.4)
                       (if (fixnum? tmp.4)
                           (if (fixnum? tmp.3) (unsafe-fx+ tmp.3 tmp.4) (error 1))
                           (error 1))))
                   (define L.*.4
                     (lambda (tmp.1 tmp.2)
                       (if (fixnum? tmp.2)
                           (if (fixnum? tmp.1) (unsafe-fx* tmp.1 tmp.2) (error 0))
                           (error 0))))
                   (let ((x.1.1 (apply L.make-vector.11 2)))
                     (let ((x.2.2 (apply L.vector-set!.13 x.1.1 0 1)))
                       (let ((x.3.3 (apply L.vector-set!.13 x.1.1 1 2)))
                         (let ((x.4.4 (apply L.+.5 x.2.2 x.3.3))) x.4.4))))))
                






  
  (check-equal? (implement-safe-primops
                 '(module
                      (define L.L.swap.1.1
                        (lambda (x.1.1)
                          (let ((z.3.2 (apply L.L.swap.1.1 x.1.1)))
                            z.3.2)))
                    (apply L.L.swap.1.1 1)))
                '(module
       
                     (define L.unsafe-vector-ref.3
                       (lambda (tmp.44 tmp.45)
                         (if (unsafe-fx< tmp.45 (unsafe-vector-length tmp.44))
                             (if (unsafe-fx>= tmp.45 0)
                                 (unsafe-vector-ref tmp.44 tmp.45)
                                 (error 10))
                             (error 10))))
                   (define L.unsafe-vector-set!.2
                     (lambda (tmp.44 tmp.45 tmp.46)
                       (if (unsafe-fx< tmp.45 (unsafe-vector-length tmp.44))
                           (if (unsafe-fx>= tmp.45 0)
                               (begin (unsafe-vector-set! tmp.44 tmp.45 tmp.46) tmp.44)
                               (error 9))
                           (error 9))))
                   (define L.vector-init-loop.30
                     (lambda (len.41 i.43 vec.42)
                       (if (eq? len.41 i.43)
                           vec.42
                           (begin
                             (unsafe-vector-set! vec.42 i.43 0)
                             (apply L.vector-init-loop.30 len.41 (unsafe-fx+ i.43 1) vec.42)))))
                   (define L.make-init-vector.1
                     (lambda (tmp.39)
                       (let ((tmp.40 (unsafe-make-vector tmp.39)))
                         (apply L.vector-init-loop.30 tmp.39 0 tmp.40))))

     
     
                   (define L.eq?.29 (lambda (tmp.37 tmp.38) (eq? tmp.37 tmp.38)))
                   (define L.cons.28 (lambda (tmp.35 tmp.36) (cons tmp.35 tmp.36)))
                   (define L.not.27 (lambda (tmp.34) (not tmp.34)))
                   (define L.vector?.26 (lambda (tmp.33) (vector? tmp.33)))
                   (define L.procedure?.25 (lambda (tmp.32) (procedure? tmp.32)))
                   (define L.pair?.24 (lambda (tmp.31) (pair? tmp.31)))
                   (define L.error?.23 (lambda (tmp.30) (error? tmp.30)))
                   (define L.ascii-char?.22 (lambda (tmp.29) (ascii-char? tmp.29)))
                   (define L.void?.21 (lambda (tmp.28) (void? tmp.28)))
                   (define L.empty?.20 (lambda (tmp.27) (empty? tmp.27)))
                   (define L.boolean?.19 (lambda (tmp.26) (boolean? tmp.26)))
                   (define L.fixnum?.18 (lambda (tmp.25) (fixnum? tmp.25)))
     
                   (define L.procedure-arity.17
                     (lambda (tmp.24)
                       (if (procedure? tmp.24) (unsafe-procedure-arity tmp.24) (error 13))))
                   (define L.cdr.16
                     (lambda (tmp.23) (if (pair? tmp.23) (unsafe-cdr tmp.23) (error 12))))
                   (define L.car.15
                     (lambda (tmp.22) (if (pair? tmp.22) (unsafe-car tmp.22) (error 11))))
                   (define L.vector-ref.14
                     (lambda (tmp.20 tmp.21)
                       (if (fixnum? tmp.21)
                           (if (vector? tmp.20)
                               (apply L.unsafe-vector-ref.3 tmp.20 tmp.21)
                               (error 10))
                           (error 10))))
                   (define L.vector-set!.13
                     (lambda (tmp.17 tmp.18 tmp.19)
                       (if (fixnum? tmp.18)
                           (if (vector? tmp.17)
                               (apply L.unsafe-vector-set!.2 tmp.17 tmp.18 tmp.19)
                               (error 9))
                           (error 9))))
                   (define L.vector-length.12
                     (lambda (tmp.16)
                       (if (vector? tmp.16) (unsafe-vector-length tmp.16) (error 8))))
                   (define L.make-vector.11
                     (lambda (tmp.15)
                       (if (fixnum? tmp.15) (apply L.make-init-vector.1 tmp.15) (error 7))))
     
                   (define L.>=.10
                     (lambda (tmp.13 tmp.14)
                       (if (fixnum? tmp.14)
                           (if (fixnum? tmp.13) (unsafe-fx>= tmp.13 tmp.14) (error 6))
                           (error 6))))
                   (define L.>.9
                     (lambda (tmp.11 tmp.12)
                       (if (fixnum? tmp.12)
                           (if (fixnum? tmp.11) (unsafe-fx> tmp.11 tmp.12) (error 5))
                           (error 5))))
                   (define L.<=.8
                     (lambda (tmp.9 tmp.10)
                       (if (fixnum? tmp.10)
                           (if (fixnum? tmp.9) (unsafe-fx<= tmp.9 tmp.10) (error 4))
                           (error 4))))
                   (define L.<.7
                     (lambda (tmp.7 tmp.8)
                       (if (fixnum? tmp.8)
                           (if (fixnum? tmp.7) (unsafe-fx< tmp.7 tmp.8) (error 3))
                           (error 3))))
                   (define L.-.6
                     (lambda (tmp.5 tmp.6)
                       (if (fixnum? tmp.6)
                           (if (fixnum? tmp.5) (unsafe-fx- tmp.5 tmp.6) (error 2))
                           (error 2))))
                   (define L.+.5
                     (lambda (tmp.3 tmp.4)
                       (if (fixnum? tmp.4)
                           (if (fixnum? tmp.3) (unsafe-fx+ tmp.3 tmp.4) (error 1))
                           (error 1))))
                   (define L.*.4
                     (lambda (tmp.1 tmp.2)
                       (if (fixnum? tmp.2)
                           (if (fixnum? tmp.1) (unsafe-fx* tmp.1 tmp.2) (error 0))
                           (error 0))))
                   (define L.L.swap.1.1
                     (lambda (x.1.1) (let ((z.3.2 (apply L.L.swap.1.1 x.1.1))) z.3.2)))
                   (apply L.L.swap.1.1 1)))

  (check-equal? (implement-safe-primops `(module (apply cons 7 ())))
                '(module
  (define L.unsafe-vector-ref.3
    (lambda (tmp.44 tmp.45)
      (if (unsafe-fx< tmp.45 (unsafe-vector-length tmp.44))
        (if (unsafe-fx>= tmp.45 0)
          (unsafe-vector-ref tmp.44 tmp.45)
          (error 10))
        (error 10))))
  (define L.unsafe-vector-set!.2
    (lambda (tmp.44 tmp.45 tmp.46)
      (if (unsafe-fx< tmp.45 (unsafe-vector-length tmp.44))
        (if (unsafe-fx>= tmp.45 0)
          (begin (unsafe-vector-set! tmp.44 tmp.45 tmp.46) tmp.44)
          (error 9))
        (error 9))))
  (define L.vector-init-loop.30
    (lambda (len.41 i.43 vec.42)
      (if (eq? len.41 i.43)
        vec.42
        (begin
          (unsafe-vector-set! vec.42 i.43 0)
          (apply L.vector-init-loop.30 len.41 (unsafe-fx+ i.43 1) vec.42)))))
  (define L.make-init-vector.1
    (lambda (tmp.39)
      (let ((tmp.40 (unsafe-make-vector tmp.39)))
        (apply L.vector-init-loop.30 tmp.39 0 tmp.40))))
  (define L.eq?.29 (lambda (tmp.37 tmp.38) (eq? tmp.37 tmp.38)))
  (define L.cons.28 (lambda (tmp.35 tmp.36) (cons tmp.35 tmp.36)))
  (define L.not.27 (lambda (tmp.34) (not tmp.34)))
  (define L.vector?.26 (lambda (tmp.33) (vector? tmp.33)))
  (define L.procedure?.25 (lambda (tmp.32) (procedure? tmp.32)))
  (define L.pair?.24 (lambda (tmp.31) (pair? tmp.31)))
  (define L.error?.23 (lambda (tmp.30) (error? tmp.30)))
  (define L.ascii-char?.22 (lambda (tmp.29) (ascii-char? tmp.29)))
  (define L.void?.21 (lambda (tmp.28) (void? tmp.28)))
  (define L.empty?.20 (lambda (tmp.27) (empty? tmp.27)))
  (define L.boolean?.19 (lambda (tmp.26) (boolean? tmp.26)))
  (define L.fixnum?.18 (lambda (tmp.25) (fixnum? tmp.25)))
  (define L.procedure-arity.17
    (lambda (tmp.24)
      (if (procedure? tmp.24) (unsafe-procedure-arity tmp.24) (error 13))))
  (define L.cdr.16
    (lambda (tmp.23) (if (pair? tmp.23) (unsafe-cdr tmp.23) (error 12))))
  (define L.car.15
    (lambda (tmp.22) (if (pair? tmp.22) (unsafe-car tmp.22) (error 11))))
  (define L.vector-ref.14
    (lambda (tmp.20 tmp.21)
      (if (fixnum? tmp.21)
        (if (vector? tmp.20)
          (apply L.unsafe-vector-ref.3 tmp.20 tmp.21)
          (error 10))
        (error 10))))
  (define L.vector-set!.13
    (lambda (tmp.17 tmp.18 tmp.19)
      (if (fixnum? tmp.18)
        (if (vector? tmp.17)
          (apply L.unsafe-vector-set!.2 tmp.17 tmp.18 tmp.19)
          (error 9))
        (error 9))))
  (define L.vector-length.12
    (lambda (tmp.16)
      (if (vector? tmp.16) (unsafe-vector-length tmp.16) (error 8))))
  (define L.make-vector.11
    (lambda (tmp.15)
      (if (fixnum? tmp.15) (apply L.make-init-vector.1 tmp.15) (error 7))))
  (define L.>=.10
    (lambda (tmp.13 tmp.14)
      (if (fixnum? tmp.14)
        (if (fixnum? tmp.13) (unsafe-fx>= tmp.13 tmp.14) (error 6))
        (error 6))))
  (define L.>.9
    (lambda (tmp.11 tmp.12)
      (if (fixnum? tmp.12)
        (if (fixnum? tmp.11) (unsafe-fx> tmp.11 tmp.12) (error 5))
        (error 5))))
  (define L.<=.8
    (lambda (tmp.9 tmp.10)
      (if (fixnum? tmp.10)
        (if (fixnum? tmp.9) (unsafe-fx<= tmp.9 tmp.10) (error 4))
        (error 4))))
  (define L.<.7
    (lambda (tmp.7 tmp.8)
      (if (fixnum? tmp.8)
        (if (fixnum? tmp.7) (unsafe-fx< tmp.7 tmp.8) (error 3))
        (error 3))))
  (define L.-.6
    (lambda (tmp.5 tmp.6)
      (if (fixnum? tmp.6)
        (if (fixnum? tmp.5) (unsafe-fx- tmp.5 tmp.6) (error 2))
        (error 2))))
  (define L.+.5
    (lambda (tmp.3 tmp.4)
      (if (fixnum? tmp.4)
        (if (fixnum? tmp.3) (unsafe-fx+ tmp.3 tmp.4) (error 1))
        (error 1))))
  (define L.*.4
    (lambda (tmp.1 tmp.2)
      (if (fixnum? tmp.2)
        (if (fixnum? tmp.1) (unsafe-fx* tmp.1 tmp.2) (error 0))
        (error 0))))
  (apply L.cons.28 7 ())))


  )
  





; Exercise 10
; Exprs-lang v8 -> Impure-Exprs-safe v8

(define (name? s)
  (and (symbol? s)
       (not (register? s))
       (not (valid-binop? s))
       (not (reserved-funct-name? s))
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
    (if (or (valid-binop? x) (cmp? x) (reserved-funct-name? x))
        x
        (if (dict-has-key? var-dict x)
            (dict-ref var-dict x)
            (begin
              (dict-set! var-dict x (fresh-label x))
              (dict-ref var-dict x)))))

  
  (define (generate-unique b)
    (match b

      
      ;e-expressions
     
      
      
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
(module+ test
  (check-equal? (uniquify '(module
                               (define L.+
                                 (lambda (x.1)
                                   (let ([z.3 (+ x.1 (procedure-arity cons))])
                                     z.3)))
                             (apply L.+ 1)))
                '(module
                     (define L.L.+.4
                       (lambda (x.1.1) (let ((z.3.2 (+ x.1 (procedure-arity cons)))) z.3.2)))
                   (apply L.L.+.4 1)))
  (check-equal? (uniquify '(module
                               (define L.+
                                 (lambda (x.1)
                                   (let ([z.3 (vector-set! vector 0 m)])
                                     z.3)))
                             (apply L.+ 1)))
                '(module
                     (define L.L.+.4
                       (lambda (x.1.1) (let ((z.3.2 (vector-set! vector 0 m))) z.3.2)))
                   (apply L.L.+.4 1))
                )
  (check-equal? (uniquify
                 `(module
                      (let ([x.1 (apply make-vector 2)])
                        (let ([x.2 (apply vector-set! x.1 0 1)])
                          (let ([x.3 (apply vector-set! x.1 1 2)])
                            (let ([x.4 (apply vector-set! x.1 2 3)])
                              x.4))))))
                '(module
                     (let ((x.1.1 (apply make-vector 2)))
                       (let ((x.2.2 (apply vector-set! x.1.1 0 1)))
                         (let ((x.3.3 (apply vector-set! x.1.1 1 2)))
                           (let ((x.4.4 (apply vector-set! x.1.1 2 3))) x.4.4))))))

  



  )














