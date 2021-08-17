#lang racket
(require racket/syntax)
(require
  "share/a9-compiler-lib.rkt"
  "share/util.rkt"
)

(provide
  implement-safe-primops
)
(module+ test
  (require rackunit))

;; exercise 4
; TODO finish implement-safe-primops
; Lam-opticon-lang v9 -> Safe-apply-lang v9.

(define fresh-offset
  (let ([counter (let ([x 41])
                   (lambda ()
                     (set! x (add1 x))
                     x))])
    (lambda ([x 'tmp])
      (format-symbol "~a.~a" x (counter)))))
(define (reserved-funct-name? s)
  (displayln (format "reserved-funct-name? ~a" s))
  (member s '(make-vector vector-set! vector-length
                          vector-ref procedure-arity
                          cdr car cons vector? procedure? pair?
                          not error? ascii-char? void? empty?
                          boolean? fixnum? * + - eq? < <= > >=)))

(define OPERATIONS (make-hash))

(define (implement-safe-primops p)
    ; adjust its language definition to remove define and support letrec
;   remove make-procedure and unsafe-procedure-label. 
;  These are introduced by a later pass that is responsible for implementing procedures safely.
;  This means that apply can be safely applied to arbitrary data—a later pass will implement dynamic checking for application.
  (define list_of_ops (list '* '+ '- '< '<= '> '>=))
  (define list_of_huhs (list 'fixnum? 'boolean? 'empty? 'void? 'ascii-char? 'error? 'pair? 'procedure? 'vector? 'not))
  (define list_of_both (list 'cons 'eq?))
  (define error -1)
  (define (fresh-error)
    (set! error (add1 error))
    error
    )

  (define (generate-primops)
    
    (define list_operations empty)
  

    (define make-init-vector-label (fresh 'make-init-vector))
    (dict-set! OPERATIONS make-init-vector-label 'make-init-vector) ;update dictionary

    (define unsafe-vector-set-label (fresh 'unsafe-vector-set!))
    (dict-set! OPERATIONS unsafe-vector-set-label 'unsafe-vector-set!) ;update dictionary

    (define unsafe-vector-ref-label (fresh 'unsafe-vector-ref))
    (dict-set! OPERATIONS unsafe-vector-set-label 'unsafe-vector-ref) ;update dictionary
    
    ;; Basic Operations
    (for ([op list_of_ops])
      (let* ([label1 (fresh-offset op)]
             [var1 (fresh 'x)]
             [var2 (fresh 'y)]
             [error-code1 (fresh-error)]
             )
        (dict-set! OPERATIONS op label1) ;update dictionary
        (set! list_operations (foldr cons list_operations (list `( ,label1 (lambda (,var1 ,var2)
                                                                                   (if (fixnum? ,var2)
                                                                                       (if (fixnum? ,var1)
                                                                                           (,(string->symbol (format "unsafe-fx~a" op)) ,var1 ,var2) (error ,error-code1))
                                                                                       (error ,error-code1)))))))))
    ;;Vector: make, length, set!
    
    
    (let* ([label1 (fresh-offset 'make-vector)]
           [var1 (fresh 'x)]
           
           [error-code1 (fresh-error)]
           )
      (dict-set! OPERATIONS 'make-vector label1) ;update dictionary
      (set! list_operations (foldr cons list_operations (list `( ,label1
                                                                 (lambda (,var1)
                                                                   (if (fixnum? ,var1) (apply ,make-init-vector-label ,var1) (error ,error-code1))))))))
    (let* ([label1 (fresh-offset 'vector-length)]
           [var1 (fresh 'x)]
           
           [error-code1 (fresh-error)]
           )
      (dict-set! OPERATIONS 'vector-length label1) ;update dictionary
      (set! list_operations (foldr cons list_operations (list `( ,label1
                                                                 (lambda (,var1)
                                                                   (if (vector? ,var1) (unsafe-vector-length ,var1) (error ,error-code1))))))))

    (define error-code-set (fresh-error))
    (let* ([label1 (fresh-offset 'vector-set!)]
           [var1 (fresh 'x)]
           [var2 (fresh 'y)]
           [var3 (fresh 'z)]
           
           )
      (dict-set! OPERATIONS 'vector-set! label1) ;update dictionary
      (set! list_operations (foldr cons list_operations (list `( ,label1 (lambda (,var1 ,var2 ,var3)
                                                                                 (if (fixnum? ,var2)
                                                                                     (if (vector? ,var1)
                                                                                         (apply ,unsafe-vector-set-label ,var1 ,var2 ,var3)
                                                                                         (error ,error-code-set))
                                                                                     (error ,error-code-set))))))))
    (define error-code-ref (fresh-error)) 
    (let* ([label1 (fresh-offset 'vector-ref)]
           [var1 (fresh 'x)]
           [var2 (fresh 'y)]
           
           )
      (dict-set! OPERATIONS 'vector-ref label1) ;update dictionary
      (set! list_operations (foldr cons list_operations (list `( ,label1 (lambda (,var1 ,var2)
                                                                                 (if (fixnum? ,var2)
                                                                                     (if (vector? ,var1)
                                                                                         (apply ,unsafe-vector-ref-label ,var1 ,var2)
                                                                                         (error ,error-code-ref))
                                                                                     (error ,error-code-ref))))))))

    ;;  car and cdr

    (define list_of_cs (list 'car 'cdr 'procedure-arity))
    (for ([op list_of_cs])
      (let* ([label1 (fresh-offset op)]
             [var1 (fresh 'x)]
           
             [error-code1 (fresh-error)]
             )
        (dict-set! OPERATIONS op label1) ;update dictionary
        (if (eq? op 'procedure-arity)
            (set! list_operations (foldr cons list_operations (list `( ,label1 (lambda (,var1) (if (procedure? ,var1) (,(string->symbol (format "unsafe-~a" op)) ,var1)
                                                                                                         (error ,error-code1)
                                                                                                         ))))))
            (set! list_operations (foldr cons list_operations (list `( ,label1 (lambda (,var1) (if (pair? ,var1) (,(string->symbol (format "unsafe-~a" op)) ,var1)
                                                                                                         (error ,error-code1)
                                                                                                         )))))))))
    



    ;; Booleans: 
    (for ([op list_of_huhs])
      (let* ([label1 (fresh-offset op)]
             [var1 (fresh 'x)]
             
             [error-code1 (fresh-error)]
             )
        (dict-set! OPERATIONS op label1) ;update dictionary
        (set! list_operations (foldr cons list_operations (list `( ,label1 (lambda (,var1) (,op ,var1))))))))
    
    (for ([b list_of_both])
      (let* ([label1 (fresh-offset b)]
             [var1 (fresh 'x)]
             [var2 (fresh 'y)])
        (dict-set! OPERATIONS b label1) ;update dictionary
        (set! list_operations (foldr cons list_operations (list `( ,label1 (lambda (,var1 ,var2) (,b ,var1 ,var2))))))))

    ;; Vectors:
    (define vector-init-loop-label 0)

    ;; make
    (let* (
           [var1 (fresh-offset 'x)]
           [var2 (fresh-offset 'y)])
      (set! vector-init-loop-label (fresh-offset 'vector-init-loop))
      (dict-set! OPERATIONS 'vector-init-loop vector-init-loop-label) ;update dictionary
      (set! list_operations (foldr cons list_operations
                                   (list `( ,make-init-vector-label (lambda (,var1) (let ((,var2 (unsafe-make-vector ,var1)))
                                                                                            (apply ,vector-init-loop-label ,var1 0 ,var2))))))))
    ;; init

    (let* (
           [var1 (fresh-offset 'len)]
           [var2 (fresh-offset 'vec)]
           [var3 (fresh-offset 'i)])
      (set! list_operations (foldr cons list_operations
                                   (list `( ,vector-init-loop-label
                                            (lambda (,var1 ,var3 ,var2)
                                              (if (eq? ,var1 ,var3)
                                                  ,var2
                                                  (begin
                                                    (unsafe-vector-set! ,var2 ,var3 0)
                                                    (apply ,vector-init-loop-label ,var1 (unsafe-fx+ ,var3 1) ,var2)))))))))
    ;; ref + set 
    
    

    (let* (
           [var1 (fresh-offset 'x)]
           [var2 (fresh-offset 'y)]
           [var3 (fresh-offset 'z)]

           )
      (set! list_operations (foldr cons list_operations
                                   (list  `( ,unsafe-vector-ref-label
                                             (lambda (,var1 ,var2)
                                               (if (unsafe-fx< ,var2 (unsafe-vector-length ,var1))
                                                   (if (unsafe-fx>= ,var2 0)
                                                       (unsafe-vector-ref ,var1 ,var2)
                                                       (error ,error-code-ref))
                                                   (error ,error-code-ref))))
                                          `( ,unsafe-vector-set-label
                                             (lambda (,var1 ,var2 ,var3)
                                               (if (unsafe-fx< ,var2 (unsafe-vector-length ,var1))
                                                   (if (unsafe-fx>= tmp.45 0)
                                                       (begin (unsafe-vector-set! ,var1 ,var2 ,var3) ,var1)
                                                       (error ,error-code-set))
                                                   (error ,error-code-set))))))))
    

    
    

    list_operations
    )
  
(define (letrec-seq b)
  (match b
    [`[,aloc1 (lambda (,aloc2 ...) ,e1)] b]))

  (define (substitute-let xs es ee)
    (if (empty? xs)
      (substitute-seq ee)
      `(let ((,(first xs) ,(substitute-seq (first es)))) ,(substitute-let (rest xs) (rest es) ee))))
  
  (define (substitute-seq b)
    ; (displayln (format "substitute-seq ~a" b))
    (match b

      
      ;e-expressions
      [`,x #:when(dict-has-key? OPERATIONS x) (dict-ref OPERATIONS x)]
      [`(apply ,e1 ,e2 ...)
        ; (displayln (format "implement apply e1 ~a in OPERATION ~a" e1 (dict-has-key? OPERATIONS e1)))
       `(apply ,(if (dict-has-key? OPERATIONS e1) 
                                        (dict-ref OPERATIONS e1) 
                                        (substitute-seq e1)) ,@(map substitute-seq e2))]
      [`(let () ,e) `(let () ,(substitute-seq e))]
      [`(let ([,xs ,e1s] ...) ,e2) 
          (substitute-let xs e1s e2)]
      [`(let ((,x ,e1)) ,e2)`(let ((,(substitute-seq x) ,(substitute-seq e1))) ,(substitute-seq e2))]
      [`(if ,e1 ,e2 ,e3)`(if ,(substitute-seq e1) ,(substitute-seq e2) ,(substitute-seq e3))]
      [`(lambda (,args ...) ,e) `(lambda ,args ,(substitute-seq e))]
      [`( ,x1 (lambda (,x2 ...) ,e))`( ,(substitute-seq x1)
                                             (lambda (,@(map substitute-seq x2))
                                               ,(substitute-seq e)))]
      [	`(letrec () ,e2)`(letrec () ,(substitute-seq e2))]
      [`(letrec ([,xs ,e1s] ...) ,e2) `(letrec ,(map (lambda (x y) `(,(substitute-seq x) ,(substitute-seq y))) xs e1s) ,(substitute-seq e2))]
      [else b]

      ))
    
    



  (define (trampoline p)
    (match p
      [`(module ,b ...) (append `(module) (list `(letrec ,(append (generate-primops)) ,@(map substitute-seq b))))]
      ))
  
  (displayln (format "implement-safe-primops ~a" p))
 
  (trampoline p))


(module+ test
  #;(check-equal? (implement-safe-primops '(module 77))
        '(module
  (letrec ((unsafe-vector-ref.3
            (lambda (tmp.74 tmp.75)
              (if (unsafe-fx< tmp.75 (unsafe-vector-length tmp.74))
                (if (unsafe-fx>= tmp.75 0)
                  (unsafe-vector-ref tmp.74 tmp.75)
                  (error 10))
                (error 10))))
           (unsafe-vector-set!.2
            (lambda (tmp.74 tmp.75 tmp.76)
              (if (unsafe-fx< tmp.75 (unsafe-vector-length tmp.74))
                (if (unsafe-fx>= tmp.75 0)
                  (begin (unsafe-vector-set! tmp.74 tmp.75 tmp.76) tmp.74)
                  (error 9))
                (error 9))))
           (vector-init-loop.70
            (lambda (len.71 i.73 vec.72)
              (if (eq? len.71 i.73)
                vec.72
                (begin
                  (unsafe-vector-set! vec.72 i.73 0)
                  (apply
                   vector-init-loop.70
                   len.71
                   (unsafe-fx+ i.73 1)
                   vec.72)))))
           (make-init-vector.1
            (lambda (tmp.68)
              (let ((tmp.69 (unsafe-make-vector tmp.68)))
                (apply vector-init-loop.70 tmp.68 0 tmp.69))))
           (eq?.67 (lambda (tmp.40 tmp.41) (eq? tmp.40 tmp.41)))
           (cons.66 (lambda (tmp.38 tmp.39) (cons tmp.38 tmp.39)))
           (not.65 (lambda (tmp.37) (not tmp.37)))
           (vector?.64 (lambda (tmp.36) (vector? tmp.36)))
           (procedure?.63 (lambda (tmp.35) (procedure? tmp.35)))
           (pair?.62 (lambda (tmp.34) (pair? tmp.34)))
           (error?.61 (lambda (tmp.33) (error? tmp.33)))
           (ascii-char?.60 (lambda (tmp.32) (ascii-char? tmp.32)))
           (void?.59 (lambda (tmp.31) (void? tmp.31)))
           (empty?.58 (lambda (tmp.30) (empty? tmp.30)))
           (boolean?.57 (lambda (tmp.29) (boolean? tmp.29)))
           (fixnum?.56 (lambda (tmp.28) (fixnum? tmp.28)))
           (procedure-arity.55
            (lambda (tmp.27)
              (if (procedure? tmp.27)
                (unsafe-procedure-arity tmp.27)
                (error 13))))
           (cdr.54
            (lambda (tmp.26)
              (if (pair? tmp.26) (unsafe-cdr tmp.26) (error 12))))
           (car.53
            (lambda (tmp.25)
              (if (pair? tmp.25) (unsafe-car tmp.25) (error 11))))
           (vector-ref.52
            (lambda (tmp.23 tmp.24)
              (if (fixnum? tmp.24)
                (if (vector? tmp.23)
                  (apply unsafe-vector-ref.3 tmp.23 tmp.24)
                  (error 10))
                (error 10))))
           (vector-set!.51
            (lambda (tmp.20 tmp.21 tmp.22)
              (if (fixnum? tmp.21)
                (if (vector? tmp.20)
                  (apply unsafe-vector-set!.2 tmp.20 tmp.21 tmp.22)
                  (error 9))
                (error 9))))
           (vector-length.50
            (lambda (tmp.19)
              (if (vector? tmp.19) (unsafe-vector-length tmp.19) (error 8))))
           (make-vector.49
            (lambda (tmp.18)
              (if (fixnum? tmp.18)
                (apply make-init-vector.1 tmp.18)
                (error 7))))
           (>=.48
            (lambda (tmp.16 tmp.17)
              (if (fixnum? tmp.17)
                (if (fixnum? tmp.16) (unsafe-fx>= tmp.16 tmp.17) (error 6))
                (error 6))))
           (>.47
            (lambda (tmp.14 tmp.15)
              (if (fixnum? tmp.15)
                (if (fixnum? tmp.14) (unsafe-fx> tmp.14 tmp.15) (error 5))
                (error 5))))
           (<=.46
            (lambda (tmp.12 tmp.13)
              (if (fixnum? tmp.13)
                (if (fixnum? tmp.12) (unsafe-fx<= tmp.12 tmp.13) (error 4))
                (error 4))))
           (<.45
            (lambda (tmp.10 tmp.11)
              (if (fixnum? tmp.11)
                (if (fixnum? tmp.10) (unsafe-fx< tmp.10 tmp.11) (error 3))
                (error 3))))
           (-.44
            (lambda (tmp.8 tmp.9)
              (if (fixnum? tmp.9)
                (if (fixnum? tmp.8) (unsafe-fx- tmp.8 tmp.9) (error 2))
                (error 2))))
           (+.43
            (lambda (tmp.6 tmp.7)
              (if (fixnum? tmp.7)
                (if (fixnum? tmp.6) (unsafe-fx+ tmp.6 tmp.7) (error 1))
                (error 1))))
           (*.42
            (lambda (tmp.4 tmp.5)
              (if (fixnum? tmp.5)
                (if (fixnum? tmp.4) (unsafe-fx* tmp.4 tmp.5) (error 0))
                (error 0)))))
    77)))

      (check-equal? (implement-safe-primops '(module
                                             (let ((x.1.1 (apply make-vector 2)))
                                               (let ((x.2.2 (apply vector-set! x.1.1 0 1)))
                                                 (let ((x.3.3 (apply vector-set! x.1.1 1 2)))
                                                   (let ((x.4.4 (apply vector-set! x.1.1 2 3))) x.4.4))))))
        
        '(module
  (letrec ((unsafe-vector-ref.3
            (lambda (tmp.74 tmp.75)
              (if (unsafe-fx< tmp.75 (unsafe-vector-length tmp.74))
                (if (unsafe-fx>= tmp.75 0)
                  (unsafe-vector-ref tmp.74 tmp.75)
                  (error 10))
                (error 10))))
           (unsafe-vector-set!.2
            (lambda (tmp.74 tmp.75 tmp.76)
              (if (unsafe-fx< tmp.75 (unsafe-vector-length tmp.74))
                (if (unsafe-fx>= tmp.75 0)
                  (begin (unsafe-vector-set! tmp.74 tmp.75 tmp.76) tmp.74)
                  (error 9))
                (error 9))))
           (vector-init-loop.70
            (lambda (len.71 i.73 vec.72)
              (if (eq? len.71 i.73)
                vec.72
                (begin
                  (unsafe-vector-set! vec.72 i.73 0)
                  (apply
                   vector-init-loop.70
                   len.71
                   (unsafe-fx+ i.73 1)
                   vec.72)))))
           (make-init-vector.1
            (lambda (tmp.68)
              (let ((tmp.69 (unsafe-make-vector tmp.68)))
                (apply vector-init-loop.70 tmp.68 0 tmp.69))))
           (eq?.67 (lambda (tmp.40 tmp.41) (eq? tmp.40 tmp.41)))
           (cons.66 (lambda (tmp.38 tmp.39) (cons tmp.38 tmp.39)))
           (not.65 (lambda (tmp.37) (not tmp.37)))
           (vector?.64 (lambda (tmp.36) (vector? tmp.36)))
           (procedure?.63 (lambda (tmp.35) (procedure? tmp.35)))
           (pair?.62 (lambda (tmp.34) (pair? tmp.34)))
           (error?.61 (lambda (tmp.33) (error? tmp.33)))
           (ascii-char?.60 (lambda (tmp.32) (ascii-char? tmp.32)))
           (void?.59 (lambda (tmp.31) (void? tmp.31)))
           (empty?.58 (lambda (tmp.30) (empty? tmp.30)))
           (boolean?.57 (lambda (tmp.29) (boolean? tmp.29)))
           (fixnum?.56 (lambda (tmp.28) (fixnum? tmp.28)))
           (procedure-arity.55
            (lambda (tmp.27)
              (if (procedure? tmp.27)
                (unsafe-procedure-arity tmp.27)
                (error 13))))
           (cdr.54
            (lambda (tmp.26)
              (if (pair? tmp.26) (unsafe-cdr tmp.26) (error 12))))
           (car.53
            (lambda (tmp.25)
              (if (pair? tmp.25) (unsafe-car tmp.25) (error 11))))
           (vector-ref.52
            (lambda (tmp.23 tmp.24)
              (if (fixnum? tmp.24)
                (if (vector? tmp.23)
                  (apply unsafe-vector-ref.3 tmp.23 tmp.24)
                  (error 10))
                (error 10))))
           (vector-set!.51
            (lambda (tmp.20 tmp.21 tmp.22)
              (if (fixnum? tmp.21)
                (if (vector? tmp.20)
                  (apply unsafe-vector-set!.2 tmp.20 tmp.21 tmp.22)
                  (error 9))
                (error 9))))
           (vector-length.50
            (lambda (tmp.19)
              (if (vector? tmp.19) (unsafe-vector-length tmp.19) (error 8))))
           (make-vector.49
            (lambda (tmp.18)
              (if (fixnum? tmp.18)
                (apply make-init-vector.1 tmp.18)
                (error 7))))
           (>=.48
            (lambda (tmp.16 tmp.17)
              (if (fixnum? tmp.17)
                (if (fixnum? tmp.16) (unsafe-fx>= tmp.16 tmp.17) (error 6))
                (error 6))))
           (>.47
            (lambda (tmp.14 tmp.15)
              (if (fixnum? tmp.15)
                (if (fixnum? tmp.14) (unsafe-fx> tmp.14 tmp.15) (error 5))
                (error 5))))
           (<=.46
            (lambda (tmp.12 tmp.13)
              (if (fixnum? tmp.13)
                (if (fixnum? tmp.12) (unsafe-fx<= tmp.12 tmp.13) (error 4))
                (error 4))))
           (<.45
            (lambda (tmp.10 tmp.11)
              (if (fixnum? tmp.11)
                (if (fixnum? tmp.10) (unsafe-fx< tmp.10 tmp.11) (error 3))
                (error 3))))
           (-.44
            (lambda (tmp.8 tmp.9)
              (if (fixnum? tmp.9)
                (if (fixnum? tmp.8) (unsafe-fx- tmp.8 tmp.9) (error 2))
                (error 2))))
           (+.43
            (lambda (tmp.6 tmp.7)
              (if (fixnum? tmp.7)
                (if (fixnum? tmp.6) (unsafe-fx+ tmp.6 tmp.7) (error 1))
                (error 1))))
           (*.42
            (lambda (tmp.4 tmp.5)
              (if (fixnum? tmp.5)
                (if (fixnum? tmp.4) (unsafe-fx* tmp.4 tmp.5) (error 0))
                (error 0)))))
    (let ((x.1.1 (apply make-vector.49 2)))
      (let ((x.2.2 (apply vector-set!.51 x.1.1 0 1)))
        (let ((x.3.3 (apply vector-set!.51 x.1.1 1 2)))
          (let ((x.4.4 (apply vector-set!.51 x.1.1 2 3))) x.4.4)))))))


    (check-equal? (implement-safe-primops '(module
                                             (let ((x.1.1 (apply make-vector 2)))
                                               (let ((x.2.2 (apply vector-set! x.1.1 0 1)))
                                                 (let ((x.3.3 (apply vector-set! x.1.1 1 2)))
                                                   (let ((x.4.4 (apply + x.2.2 x.3.3))) x.4.4))))))
          '(module
  (letrec ((unsafe-vector-ref.3
            (lambda (tmp.74 tmp.75)
              (if (unsafe-fx< tmp.75 (unsafe-vector-length tmp.74))
                (if (unsafe-fx>= tmp.75 0)
                  (unsafe-vector-ref tmp.74 tmp.75)
                  (error 10))
                (error 10))))
           (unsafe-vector-set!.2
            (lambda (tmp.74 tmp.75 tmp.76)
              (if (unsafe-fx< tmp.75 (unsafe-vector-length tmp.74))
                (if (unsafe-fx>= tmp.75 0)
                  (begin (unsafe-vector-set! tmp.74 tmp.75 tmp.76) tmp.74)
                  (error 9))
                (error 9))))
           (vector-init-loop.70
            (lambda (len.71 i.73 vec.72)
              (if (eq? len.71 i.73)
                vec.72
                (begin
                  (unsafe-vector-set! vec.72 i.73 0)
                  (apply
                   vector-init-loop.70
                   len.71
                   (unsafe-fx+ i.73 1)
                   vec.72)))))
           (make-init-vector.1
            (lambda (tmp.68)
              (let ((tmp.69 (unsafe-make-vector tmp.68)))
                (apply vector-init-loop.70 tmp.68 0 tmp.69))))
           (eq?.67 (lambda (tmp.40 tmp.41) (eq? tmp.40 tmp.41)))
           (cons.66 (lambda (tmp.38 tmp.39) (cons tmp.38 tmp.39)))
           (not.65 (lambda (tmp.37) (not tmp.37)))
           (vector?.64 (lambda (tmp.36) (vector? tmp.36)))
           (procedure?.63 (lambda (tmp.35) (procedure? tmp.35)))
           (pair?.62 (lambda (tmp.34) (pair? tmp.34)))
           (error?.61 (lambda (tmp.33) (error? tmp.33)))
           (ascii-char?.60 (lambda (tmp.32) (ascii-char? tmp.32)))
           (void?.59 (lambda (tmp.31) (void? tmp.31)))
           (empty?.58 (lambda (tmp.30) (empty? tmp.30)))
           (boolean?.57 (lambda (tmp.29) (boolean? tmp.29)))
           (fixnum?.56 (lambda (tmp.28) (fixnum? tmp.28)))
           (procedure-arity.55
            (lambda (tmp.27)
              (if (procedure? tmp.27)
                (unsafe-procedure-arity tmp.27)
                (error 13))))
           (cdr.54
            (lambda (tmp.26)
              (if (pair? tmp.26) (unsafe-cdr tmp.26) (error 12))))
           (car.53
            (lambda (tmp.25)
              (if (pair? tmp.25) (unsafe-car tmp.25) (error 11))))
           (vector-ref.52
            (lambda (tmp.23 tmp.24)
              (if (fixnum? tmp.24)
                (if (vector? tmp.23)
                  (apply unsafe-vector-ref.3 tmp.23 tmp.24)
                  (error 10))
                (error 10))))
           (vector-set!.51
            (lambda (tmp.20 tmp.21 tmp.22)
              (if (fixnum? tmp.21)
                (if (vector? tmp.20)
                  (apply unsafe-vector-set!.2 tmp.20 tmp.21 tmp.22)
                  (error 9))
                (error 9))))
           (vector-length.50
            (lambda (tmp.19)
              (if (vector? tmp.19) (unsafe-vector-length tmp.19) (error 8))))
           (make-vector.49
            (lambda (tmp.18)
              (if (fixnum? tmp.18)
                (apply make-init-vector.1 tmp.18)
                (error 7))))
           (>=.48
            (lambda (tmp.16 tmp.17)
              (if (fixnum? tmp.17)
                (if (fixnum? tmp.16) (unsafe-fx>= tmp.16 tmp.17) (error 6))
                (error 6))))
           (>.47
            (lambda (tmp.14 tmp.15)
              (if (fixnum? tmp.15)
                (if (fixnum? tmp.14) (unsafe-fx> tmp.14 tmp.15) (error 5))
                (error 5))))
           (<=.46
            (lambda (tmp.12 tmp.13)
              (if (fixnum? tmp.13)
                (if (fixnum? tmp.12) (unsafe-fx<= tmp.12 tmp.13) (error 4))
                (error 4))))
           (<.45
            (lambda (tmp.10 tmp.11)
              (if (fixnum? tmp.11)
                (if (fixnum? tmp.10) (unsafe-fx< tmp.10 tmp.11) (error 3))
                (error 3))))
           (-.44
            (lambda (tmp.8 tmp.9)
              (if (fixnum? tmp.9)
                (if (fixnum? tmp.8) (unsafe-fx- tmp.8 tmp.9) (error 2))
                (error 2))))
           (+.43
            (lambda (tmp.6 tmp.7)
              (if (fixnum? tmp.7)
                (if (fixnum? tmp.6) (unsafe-fx+ tmp.6 tmp.7) (error 1))
                (error 1))))
           (*.42
            (lambda (tmp.4 tmp.5)
              (if (fixnum? tmp.5)
                (if (fixnum? tmp.4) (unsafe-fx* tmp.4 tmp.5) (error 0))
                (error 0)))))
    (let ((x.1.1 (apply make-vector.49 2)))
      (let ((x.2.2 (apply vector-set!.51 x.1.1 0 1)))
        (let ((x.3.3 (apply vector-set!.51 x.1.1 1 2)))
          (let ((x.4.4 (apply +.43 x.2.2 x.3.3))) x.4.4)))))))                                         

  (check-equal? (implement-safe-primops `(module (apply cons 7 ())))
    '(module
  (letrec ((unsafe-vector-ref.3
            (lambda (tmp.74 tmp.75)
              (if (unsafe-fx< tmp.75 (unsafe-vector-length tmp.74))
                (if (unsafe-fx>= tmp.75 0)
                  (unsafe-vector-ref tmp.74 tmp.75)
                  (error 10))
                (error 10))))
           (unsafe-vector-set!.2
            (lambda (tmp.74 tmp.75 tmp.76)
              (if (unsafe-fx< tmp.75 (unsafe-vector-length tmp.74))
                (if (unsafe-fx>= tmp.75 0)
                  (begin (unsafe-vector-set! tmp.74 tmp.75 tmp.76) tmp.74)
                  (error 9))
                (error 9))))
           (vector-init-loop.70
            (lambda (len.71 i.73 vec.72)
              (if (eq? len.71 i.73)
                vec.72
                (begin
                  (unsafe-vector-set! vec.72 i.73 0)
                  (apply
                   vector-init-loop.70
                   len.71
                   (unsafe-fx+ i.73 1)
                   vec.72)))))
           (make-init-vector.1
            (lambda (tmp.68)
              (let ((tmp.69 (unsafe-make-vector tmp.68)))
                (apply vector-init-loop.70 tmp.68 0 tmp.69))))
           (eq?.67 (lambda (tmp.40 tmp.41) (eq? tmp.40 tmp.41)))
           (cons.66 (lambda (tmp.38 tmp.39) (cons tmp.38 tmp.39)))
           (not.65 (lambda (tmp.37) (not tmp.37)))
           (vector?.64 (lambda (tmp.36) (vector? tmp.36)))
           (procedure?.63 (lambda (tmp.35) (procedure? tmp.35)))
           (pair?.62 (lambda (tmp.34) (pair? tmp.34)))
           (error?.61 (lambda (tmp.33) (error? tmp.33)))
           (ascii-char?.60 (lambda (tmp.32) (ascii-char? tmp.32)))
           (void?.59 (lambda (tmp.31) (void? tmp.31)))
           (empty?.58 (lambda (tmp.30) (empty? tmp.30)))
           (boolean?.57 (lambda (tmp.29) (boolean? tmp.29)))
           (fixnum?.56 (lambda (tmp.28) (fixnum? tmp.28)))
           (procedure-arity.55
            (lambda (tmp.27)
              (if (procedure? tmp.27)
                (unsafe-procedure-arity tmp.27)
                (error 13))))
           (cdr.54
            (lambda (tmp.26)
              (if (pair? tmp.26) (unsafe-cdr tmp.26) (error 12))))
           (car.53
            (lambda (tmp.25)
              (if (pair? tmp.25) (unsafe-car tmp.25) (error 11))))
           (vector-ref.52
            (lambda (tmp.23 tmp.24)
              (if (fixnum? tmp.24)
                (if (vector? tmp.23)
                  (apply unsafe-vector-ref.3 tmp.23 tmp.24)
                  (error 10))
                (error 10))))
           (vector-set!.51
            (lambda (tmp.20 tmp.21 tmp.22)
              (if (fixnum? tmp.21)
                (if (vector? tmp.20)
                  (apply unsafe-vector-set!.2 tmp.20 tmp.21 tmp.22)
                  (error 9))
                (error 9))))
           (vector-length.50
            (lambda (tmp.19)
              (if (vector? tmp.19) (unsafe-vector-length tmp.19) (error 8))))
           (make-vector.49
            (lambda (tmp.18)
              (if (fixnum? tmp.18)
                (apply make-init-vector.1 tmp.18)
                (error 7))))
           (>=.48
            (lambda (tmp.16 tmp.17)
              (if (fixnum? tmp.17)
                (if (fixnum? tmp.16) (unsafe-fx>= tmp.16 tmp.17) (error 6))
                (error 6))))
           (>.47
            (lambda (tmp.14 tmp.15)
              (if (fixnum? tmp.15)
                (if (fixnum? tmp.14) (unsafe-fx> tmp.14 tmp.15) (error 5))
                (error 5))))
           (<=.46
            (lambda (tmp.12 tmp.13)
              (if (fixnum? tmp.13)
                (if (fixnum? tmp.12) (unsafe-fx<= tmp.12 tmp.13) (error 4))
                (error 4))))
           (<.45
            (lambda (tmp.10 tmp.11)
              (if (fixnum? tmp.11)
                (if (fixnum? tmp.10) (unsafe-fx< tmp.10 tmp.11) (error 3))
                (error 3))))
           (-.44
            (lambda (tmp.8 tmp.9)
              (if (fixnum? tmp.9)
                (if (fixnum? tmp.8) (unsafe-fx- tmp.8 tmp.9) (error 2))
                (error 2))))
           (+.43
            (lambda (tmp.6 tmp.7)
              (if (fixnum? tmp.7)
                (if (fixnum? tmp.6) (unsafe-fx+ tmp.6 tmp.7) (error 1))
                (error 1))))
           (*.42
            (lambda (tmp.4 tmp.5)
              (if (fixnum? tmp.5)
                (if (fixnum? tmp.4) (unsafe-fx* tmp.4 tmp.5) (error 0))
                (error 0)))))
    (apply cons.66 7 ()))))


    (check-equal?  (implement-safe-primops '(module (letrec () (apply cons 7 ()))))
      '(module
  (letrec ((unsafe-vector-ref.3
            (lambda (tmp.76 tmp.77)
              (if (unsafe-fx< tmp.77 (unsafe-vector-length tmp.76))
                (if (unsafe-fx>= tmp.77 0)
                  (unsafe-vector-ref tmp.76 tmp.77)
                  (error 10))
                (error 10))))
           (unsafe-vector-set!.2
            (lambda (tmp.79 tmp.80 tmp.81)
              (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
                (if (unsafe-fx>= tmp.80 0)
                  (begin (unsafe-vector-set! tmp.79 tmp.80 tmp.81) (void))
                  (error 9))
                (error 9))))
           (vector-init-loop.70
            (lambda (len.71 i.73 vec.72)
              (if (eq? len.71 i.73)
                vec.72
                (begin
                  (unsafe-vector-set! vec.72 i.73 0)
                  (apply
                   vector-init-loop.70
                   len.71
                   (unsafe-fx+ i.73 1)
                   vec.72)))))
           (make-init-vector.1
            (lambda (tmp.68)
              (let ((tmp.69 (unsafe-make-vector tmp.68)))
                (apply vector-init-loop.70 tmp.68 0 tmp.69))))
           (eq?.67 (lambda (tmp.40 tmp.41) (eq? tmp.40 tmp.41)))
           (cons.66 (lambda (tmp.38 tmp.39) (cons tmp.38 tmp.39)))
           (not.65 (lambda (tmp.37) (not tmp.37)))
           (vector?.64 (lambda (tmp.36) (vector? tmp.36)))
           (procedure?.63 (lambda (tmp.35) (procedure? tmp.35)))
           (pair?.62 (lambda (tmp.34) (pair? tmp.34)))
           (error?.61 (lambda (tmp.33) (error? tmp.33)))
           (ascii-char?.60 (lambda (tmp.32) (ascii-char? tmp.32)))
           (void?.59 (lambda (tmp.31) (void? tmp.31)))
           (empty?.58 (lambda (tmp.30) (empty? tmp.30)))
           (boolean?.57 (lambda (tmp.29) (boolean? tmp.29)))
           (fixnum?.56 (lambda (tmp.28) (fixnum? tmp.28)))
           (procedure-arity.55
            (lambda (tmp.27)
              (if (procedure? tmp.27)
                (unsafe-procedure-arity tmp.27)
                (error 13))))
           (cdr.54
            (lambda (tmp.26)
              (if (pair? tmp.26) (unsafe-cdr tmp.26) (error 12))))
           (car.53
            (lambda (tmp.25)
              (if (pair? tmp.25) (unsafe-car tmp.25) (error 11))))
           (vector-ref.52
            (lambda (tmp.23 tmp.24)
              (if (fixnum? tmp.24)
                (if (vector? tmp.23)
                  (apply unsafe-vector-ref.3 tmp.23 tmp.24)
                  (error 10))
                (error 10))))
           (vector-set!.51
            (lambda (tmp.20 tmp.21 tmp.22)
              (if (fixnum? tmp.21)
                (if (vector? tmp.20)
                  (apply unsafe-vector-set!.2 tmp.20 tmp.21 tmp.22)
                  (error 9))
                (error 9))))
           (vector-length.50
            (lambda (tmp.19)
              (if (vector? tmp.19) (unsafe-vector-length tmp.19) (error 8))))
           (make-vector.49
            (lambda (tmp.18)
              (if (fixnum? tmp.18)
                (apply make-init-vector.1 tmp.18)
                (error 7))))
           (>=.48
            (lambda (tmp.16 tmp.17)
              (if (fixnum? tmp.17)
                (if (fixnum? tmp.16) (unsafe-fx>= tmp.16 tmp.17) (error 6))
                (error 6))))
           (>.47
            (lambda (tmp.14 tmp.15)
              (if (fixnum? tmp.15)
                (if (fixnum? tmp.14) (unsafe-fx> tmp.14 tmp.15) (error 5))
                (error 5))))
           (<=.46
            (lambda (tmp.12 tmp.13)
              (if (fixnum? tmp.13)
                (if (fixnum? tmp.12) (unsafe-fx<= tmp.12 tmp.13) (error 4))
                (error 4))))
           (<.45
            (lambda (tmp.10 tmp.11)
              (if (fixnum? tmp.11)
                (if (fixnum? tmp.10) (unsafe-fx< tmp.10 tmp.11) (error 3))
                (error 3))))
           (-.44
            (lambda (tmp.8 tmp.9)
              (if (fixnum? tmp.9)
                (if (fixnum? tmp.8) (unsafe-fx- tmp.8 tmp.9) (error 2))
                (error 2))))
           (+.43
            (lambda (tmp.6 tmp.7)
              (if (fixnum? tmp.7)
                (if (fixnum? tmp.6) (unsafe-fx+ tmp.6 tmp.7) (error 1))
                (error 1))))
           (*.42
            (lambda (tmp.4 tmp.5)
              (if (fixnum? tmp.5)
                (if (fixnum? tmp.4) (unsafe-fx* tmp.4 tmp.5) (error 0))
                (error 0)))))
    (letrec () (apply cons.66 7 ())))))


  (check-equal? (implement-safe-primops '(module (letrec ([f.1 
                    (lambda (x.1) (letrec ([f.2 (lambda (x.2) (apply f.1 x.2 f.1))])))])(apply f.1 1))))
                '(module
  (letrec ((unsafe-vector-ref.3
            (lambda (tmp.76 tmp.77)
              (if (unsafe-fx< tmp.77 (unsafe-vector-length tmp.76))
                (if (unsafe-fx>= tmp.77 0)
                  (unsafe-vector-ref tmp.76 tmp.77)
                  (error 10))
                (error 10))))
           (unsafe-vector-set!.2
            (lambda (tmp.79 tmp.80 tmp.81)
              (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
                (if (unsafe-fx>= tmp.80 0)
                  (begin (unsafe-vector-set! tmp.79 tmp.80 tmp.81) (void))
                  (error 9))
                (error 9))))
           (vector-init-loop.70
            (lambda (len.71 i.73 vec.72)
              (if (eq? len.71 i.73)
                vec.72
                (begin
                  (unsafe-vector-set! vec.72 i.73 0)
                  (apply
                   vector-init-loop.70
                   len.71
                   (unsafe-fx+ i.73 1)
                   vec.72)))))
           (make-init-vector.1
            (lambda (tmp.68)
              (let ((tmp.69 (unsafe-make-vector tmp.68)))
                (apply vector-init-loop.70 tmp.68 0 tmp.69))))
           (eq?.67 (lambda (tmp.40 tmp.41) (eq? tmp.40 tmp.41)))
           (cons.66 (lambda (tmp.38 tmp.39) (cons tmp.38 tmp.39)))
           (not.65 (lambda (tmp.37) (not tmp.37)))
           (vector?.64 (lambda (tmp.36) (vector? tmp.36)))
           (procedure?.63 (lambda (tmp.35) (procedure? tmp.35)))
           (pair?.62 (lambda (tmp.34) (pair? tmp.34)))
           (error?.61 (lambda (tmp.33) (error? tmp.33)))
           (ascii-char?.60 (lambda (tmp.32) (ascii-char? tmp.32)))
           (void?.59 (lambda (tmp.31) (void? tmp.31)))
           (empty?.58 (lambda (tmp.30) (empty? tmp.30)))
           (boolean?.57 (lambda (tmp.29) (boolean? tmp.29)))
           (fixnum?.56 (lambda (tmp.28) (fixnum? tmp.28)))
           (procedure-arity.55
            (lambda (tmp.27)
              (if (procedure? tmp.27)
                (unsafe-procedure-arity tmp.27)
                (error 13))))
           (cdr.54
            (lambda (tmp.26)
              (if (pair? tmp.26) (unsafe-cdr tmp.26) (error 12))))
           (car.53
            (lambda (tmp.25)
              (if (pair? tmp.25) (unsafe-car tmp.25) (error 11))))
           (vector-ref.52
            (lambda (tmp.23 tmp.24)
              (if (fixnum? tmp.24)
                (if (vector? tmp.23)
                  (apply unsafe-vector-ref.3 tmp.23 tmp.24)
                  (error 10))
                (error 10))))
           (vector-set!.51
            (lambda (tmp.20 tmp.21 tmp.22)
              (if (fixnum? tmp.21)
                (if (vector? tmp.20)
                  (apply unsafe-vector-set!.2 tmp.20 tmp.21 tmp.22)
                  (error 9))
                (error 9))))
           (vector-length.50
            (lambda (tmp.19)
              (if (vector? tmp.19) (unsafe-vector-length tmp.19) (error 8))))
           (make-vector.49
            (lambda (tmp.18)
              (if (fixnum? tmp.18)
                (apply make-init-vector.1 tmp.18)
                (error 7))))
           (>=.48
            (lambda (tmp.16 tmp.17)
              (if (fixnum? tmp.17)
                (if (fixnum? tmp.16) (unsafe-fx>= tmp.16 tmp.17) (error 6))
                (error 6))))
           (>.47
            (lambda (tmp.14 tmp.15)
              (if (fixnum? tmp.15)
                (if (fixnum? tmp.14) (unsafe-fx> tmp.14 tmp.15) (error 5))
                (error 5))))
           (<=.46
            (lambda (tmp.12 tmp.13)
              (if (fixnum? tmp.13)
                (if (fixnum? tmp.12) (unsafe-fx<= tmp.12 tmp.13) (error 4))
                (error 4))))
           (<.45
            (lambda (tmp.10 tmp.11)
              (if (fixnum? tmp.11)
                (if (fixnum? tmp.10) (unsafe-fx< tmp.10 tmp.11) (error 3))
                (error 3))))
           (-.44
            (lambda (tmp.8 tmp.9)
              (if (fixnum? tmp.9)
                (if (fixnum? tmp.8) (unsafe-fx- tmp.8 tmp.9) (error 2))
                (error 2))))
           (+.43
            (lambda (tmp.6 tmp.7)
              (if (fixnum? tmp.7)
                (if (fixnum? tmp.6) (unsafe-fx+ tmp.6 tmp.7) (error 1))
                (error 1))))
           (*.42
            (lambda (tmp.4 tmp.5)
              (if (fixnum? tmp.5)
                (if (fixnum? tmp.4) (unsafe-fx* tmp.4 tmp.5) (error 0))
                (error 0)))))
    (letrec ((f.1
              (lambda (x.1)
                (letrec ((f.2 (lambda (x.2) (apply f.1 x.2 f.1))))))))
      (apply f.1 1)))))





(check-equal? (implement-safe-primops '(module (letrec ([f.1 
                    (lambda (x.1) (letrec ([f.2 (lambda (x.2) (apply cons x.2 f.1))])))])(apply cons (apply f.1 1 ) ()))))
'(module
  (letrec ((unsafe-vector-ref.3
            (lambda (tmp.76 tmp.77)
              (if (unsafe-fx< tmp.77 (unsafe-vector-length tmp.76))
                (if (unsafe-fx>= tmp.77 0)
                  (unsafe-vector-ref tmp.76 tmp.77)
                  (error 10))
                (error 10))))
           (unsafe-vector-set!.2
            (lambda (tmp.79 tmp.80 tmp.81)
              (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
                (if (unsafe-fx>= tmp.80 0)
                  (begin (unsafe-vector-set! tmp.79 tmp.80 tmp.81) (void))
                  (error 9))
                (error 9))))
           (vector-init-loop.70
            (lambda (len.71 i.73 vec.72)
              (if (eq? len.71 i.73)
                vec.72
                (begin
                  (unsafe-vector-set! vec.72 i.73 0)
                  (apply
                   vector-init-loop.70
                   len.71
                   (unsafe-fx+ i.73 1)
                   vec.72)))))
           (make-init-vector.1
            (lambda (tmp.68)
              (let ((tmp.69 (unsafe-make-vector tmp.68)))
                (apply vector-init-loop.70 tmp.68 0 tmp.69))))
           (eq?.67 (lambda (tmp.40 tmp.41) (eq? tmp.40 tmp.41)))
           (cons.66 (lambda (tmp.38 tmp.39) (cons tmp.38 tmp.39)))
           (not.65 (lambda (tmp.37) (not tmp.37)))
           (vector?.64 (lambda (tmp.36) (vector? tmp.36)))
           (procedure?.63 (lambda (tmp.35) (procedure? tmp.35)))
           (pair?.62 (lambda (tmp.34) (pair? tmp.34)))
           (error?.61 (lambda (tmp.33) (error? tmp.33)))
           (ascii-char?.60 (lambda (tmp.32) (ascii-char? tmp.32)))
           (void?.59 (lambda (tmp.31) (void? tmp.31)))
           (empty?.58 (lambda (tmp.30) (empty? tmp.30)))
           (boolean?.57 (lambda (tmp.29) (boolean? tmp.29)))
           (fixnum?.56 (lambda (tmp.28) (fixnum? tmp.28)))
           (procedure-arity.55
            (lambda (tmp.27)
              (if (procedure? tmp.27)
                (unsafe-procedure-arity tmp.27)
                (error 13))))
           (cdr.54
            (lambda (tmp.26)
              (if (pair? tmp.26) (unsafe-cdr tmp.26) (error 12))))
           (car.53
            (lambda (tmp.25)
              (if (pair? tmp.25) (unsafe-car tmp.25) (error 11))))
           (vector-ref.52
            (lambda (tmp.23 tmp.24)
              (if (fixnum? tmp.24)
                (if (vector? tmp.23)
                  (apply unsafe-vector-ref.3 tmp.23 tmp.24)
                  (error 10))
                (error 10))))
           (vector-set!.51
            (lambda (tmp.20 tmp.21 tmp.22)
              (if (fixnum? tmp.21)
                (if (vector? tmp.20)
                  (apply unsafe-vector-set!.2 tmp.20 tmp.21 tmp.22)
                  (error 9))
                (error 9))))
           (vector-length.50
            (lambda (tmp.19)
              (if (vector? tmp.19) (unsafe-vector-length tmp.19) (error 8))))
           (make-vector.49
            (lambda (tmp.18)
              (if (fixnum? tmp.18)
                (apply make-init-vector.1 tmp.18)
                (error 7))))
           (>=.48
            (lambda (tmp.16 tmp.17)
              (if (fixnum? tmp.17)
                (if (fixnum? tmp.16) (unsafe-fx>= tmp.16 tmp.17) (error 6))
                (error 6))))
           (>.47
            (lambda (tmp.14 tmp.15)
              (if (fixnum? tmp.15)
                (if (fixnum? tmp.14) (unsafe-fx> tmp.14 tmp.15) (error 5))
                (error 5))))
           (<=.46
            (lambda (tmp.12 tmp.13)
              (if (fixnum? tmp.13)
                (if (fixnum? tmp.12) (unsafe-fx<= tmp.12 tmp.13) (error 4))
                (error 4))))
           (<.45
            (lambda (tmp.10 tmp.11)
              (if (fixnum? tmp.11)
                (if (fixnum? tmp.10) (unsafe-fx< tmp.10 tmp.11) (error 3))
                (error 3))))
           (-.44
            (lambda (tmp.8 tmp.9)
              (if (fixnum? tmp.9)
                (if (fixnum? tmp.8) (unsafe-fx- tmp.8 tmp.9) (error 2))
                (error 2))))
           (+.43
            (lambda (tmp.6 tmp.7)
              (if (fixnum? tmp.7)
                (if (fixnum? tmp.6) (unsafe-fx+ tmp.6 tmp.7) (error 1))
                (error 1))))
           (*.42
            (lambda (tmp.4 tmp.5)
              (if (fixnum? tmp.5)
                (if (fixnum? tmp.4) (unsafe-fx* tmp.4 tmp.5) (error 0))
                (error 0)))))
    (letrec ((f.1
              (lambda (x.1)
                (letrec ((f.2 (lambda (x.2) (apply cons x.2 f.1))))))))
      (apply cons.66 (apply f.1 1) ())))))


  (check-equal? (implement-safe-primops '(module (letrec ([f.1 
                    (lambda (x.1) (letrec ([f.2 (lambda (x.2) (apply cons x.2 f.1))])))])(apply cons (apply cons (apply f.1 1 ) ())))))
                '(module
  (letrec ((unsafe-vector-ref.3
            (lambda (tmp.76 tmp.77)
              (if (unsafe-fx< tmp.77 (unsafe-vector-length tmp.76))
                (if (unsafe-fx>= tmp.77 0)
                  (unsafe-vector-ref tmp.76 tmp.77)
                  (error 10))
                (error 10))))
           (unsafe-vector-set!.2
            (lambda (tmp.79 tmp.80 tmp.81)
              (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
                (if (unsafe-fx>= tmp.80 0)
                  (begin (unsafe-vector-set! tmp.79 tmp.80 tmp.81) (void))
                  (error 9))
                (error 9))))
           (vector-init-loop.70
            (lambda (len.71 i.73 vec.72)
              (if (eq? len.71 i.73)
                vec.72
                (begin
                  (unsafe-vector-set! vec.72 i.73 0)
                  (apply
                   vector-init-loop.70
                   len.71
                   (unsafe-fx+ i.73 1)
                   vec.72)))))
           (make-init-vector.1
            (lambda (tmp.68)
              (let ((tmp.69 (unsafe-make-vector tmp.68)))
                (apply vector-init-loop.70 tmp.68 0 tmp.69))))
           (eq?.67 (lambda (tmp.40 tmp.41) (eq? tmp.40 tmp.41)))
           (cons.66 (lambda (tmp.38 tmp.39) (cons tmp.38 tmp.39)))
           (not.65 (lambda (tmp.37) (not tmp.37)))
           (vector?.64 (lambda (tmp.36) (vector? tmp.36)))
           (procedure?.63 (lambda (tmp.35) (procedure? tmp.35)))
           (pair?.62 (lambda (tmp.34) (pair? tmp.34)))
           (error?.61 (lambda (tmp.33) (error? tmp.33)))
           (ascii-char?.60 (lambda (tmp.32) (ascii-char? tmp.32)))
           (void?.59 (lambda (tmp.31) (void? tmp.31)))
           (empty?.58 (lambda (tmp.30) (empty? tmp.30)))
           (boolean?.57 (lambda (tmp.29) (boolean? tmp.29)))
           (fixnum?.56 (lambda (tmp.28) (fixnum? tmp.28)))
           (procedure-arity.55
            (lambda (tmp.27)
              (if (procedure? tmp.27)
                (unsafe-procedure-arity tmp.27)
                (error 13))))
           (cdr.54
            (lambda (tmp.26)
              (if (pair? tmp.26) (unsafe-cdr tmp.26) (error 12))))
           (car.53
            (lambda (tmp.25)
              (if (pair? tmp.25) (unsafe-car tmp.25) (error 11))))
           (vector-ref.52
            (lambda (tmp.23 tmp.24)
              (if (fixnum? tmp.24)
                (if (vector? tmp.23)
                  (apply unsafe-vector-ref.3 tmp.23 tmp.24)
                  (error 10))
                (error 10))))
           (vector-set!.51
            (lambda (tmp.20 tmp.21 tmp.22)
              (if (fixnum? tmp.21)
                (if (vector? tmp.20)
                  (apply unsafe-vector-set!.2 tmp.20 tmp.21 tmp.22)
                  (error 9))
                (error 9))))
           (vector-length.50
            (lambda (tmp.19)
              (if (vector? tmp.19) (unsafe-vector-length tmp.19) (error 8))))
           (make-vector.49
            (lambda (tmp.18)
              (if (fixnum? tmp.18)
                (apply make-init-vector.1 tmp.18)
                (error 7))))
           (>=.48
            (lambda (tmp.16 tmp.17)
              (if (fixnum? tmp.17)
                (if (fixnum? tmp.16) (unsafe-fx>= tmp.16 tmp.17) (error 6))
                (error 6))))
           (>.47
            (lambda (tmp.14 tmp.15)
              (if (fixnum? tmp.15)
                (if (fixnum? tmp.14) (unsafe-fx> tmp.14 tmp.15) (error 5))
                (error 5))))
           (<=.46
            (lambda (tmp.12 tmp.13)
              (if (fixnum? tmp.13)
                (if (fixnum? tmp.12) (unsafe-fx<= tmp.12 tmp.13) (error 4))
                (error 4))))
           (<.45
            (lambda (tmp.10 tmp.11)
              (if (fixnum? tmp.11)
                (if (fixnum? tmp.10) (unsafe-fx< tmp.10 tmp.11) (error 3))
                (error 3))))
           (-.44
            (lambda (tmp.8 tmp.9)
              (if (fixnum? tmp.9)
                (if (fixnum? tmp.8) (unsafe-fx- tmp.8 tmp.9) (error 2))
                (error 2))))
           (+.43
            (lambda (tmp.6 tmp.7)
              (if (fixnum? tmp.7)
                (if (fixnum? tmp.6) (unsafe-fx+ tmp.6 tmp.7) (error 1))
                (error 1))))
           (*.42
            (lambda (tmp.4 tmp.5)
              (if (fixnum? tmp.5)
                (if (fixnum? tmp.4) (unsafe-fx* tmp.4 tmp.5) (error 0))
                (error 0)))))
    (letrec ((f.1
              (lambda (x.1)
                (letrec ((f.2 (lambda (x.2) (apply cons x.2 f.1))))))))
      (apply cons.66 (apply cons.66 (apply f.1 1) ()))))))


  (check-equal? (implement-safe-primops '(module
                                             (let ((x.1.1 (apply make-vector 2)) (x.2.2 (apply vector-set! x.1.1 0 1)) (x.3.3 (apply vector-set! x.1.1 1 2)) (x.4.4 (apply + x.2.2 x.3.3)))
                                               x.4.4)))
          '(module
  (letrec ((unsafe-vector-ref.3
            (lambda (tmp.74 tmp.75)
              (if (unsafe-fx< tmp.75 (unsafe-vector-length tmp.74))
                (if (unsafe-fx>= tmp.75 0)
                  (unsafe-vector-ref tmp.74 tmp.75)
                  (error 10))
                (error 10))))
           (unsafe-vector-set!.2
            (lambda (tmp.74 tmp.75 tmp.76)
              (if (unsafe-fx< tmp.75 (unsafe-vector-length tmp.74))
                (if (unsafe-fx>= tmp.75 0)
                  (begin (unsafe-vector-set! tmp.74 tmp.75 tmp.76) tmp.74)
                  (error 9))
                (error 9))))
           (vector-init-loop.70
            (lambda (len.71 i.73 vec.72)
              (if (eq? len.71 i.73)
                vec.72
                (begin
                  (unsafe-vector-set! vec.72 i.73 0)
                  (apply
                   vector-init-loop.70
                   len.71
                   (unsafe-fx+ i.73 1)
                   vec.72)))))
           (make-init-vector.1
            (lambda (tmp.68)
              (let ((tmp.69 (unsafe-make-vector tmp.68)))
                (apply vector-init-loop.70 tmp.68 0 tmp.69))))
           (eq?.67 (lambda (tmp.40 tmp.41) (eq? tmp.40 tmp.41)))
           (cons.66 (lambda (tmp.38 tmp.39) (cons tmp.38 tmp.39)))
           (not.65 (lambda (tmp.37) (not tmp.37)))
           (vector?.64 (lambda (tmp.36) (vector? tmp.36)))
           (procedure?.63 (lambda (tmp.35) (procedure? tmp.35)))
           (pair?.62 (lambda (tmp.34) (pair? tmp.34)))
           (error?.61 (lambda (tmp.33) (error? tmp.33)))
           (ascii-char?.60 (lambda (tmp.32) (ascii-char? tmp.32)))
           (void?.59 (lambda (tmp.31) (void? tmp.31)))
           (empty?.58 (lambda (tmp.30) (empty? tmp.30)))
           (boolean?.57 (lambda (tmp.29) (boolean? tmp.29)))
           (fixnum?.56 (lambda (tmp.28) (fixnum? tmp.28)))
           (procedure-arity.55
            (lambda (tmp.27)
              (if (procedure? tmp.27)
                (unsafe-procedure-arity tmp.27)
                (error 13))))
           (cdr.54
            (lambda (tmp.26)
              (if (pair? tmp.26) (unsafe-cdr tmp.26) (error 12))))
           (car.53
            (lambda (tmp.25)
              (if (pair? tmp.25) (unsafe-car tmp.25) (error 11))))
           (vector-ref.52
            (lambda (tmp.23 tmp.24)
              (if (fixnum? tmp.24)
                (if (vector? tmp.23)
                  (apply unsafe-vector-ref.3 tmp.23 tmp.24)
                  (error 10))
                (error 10))))
           (vector-set!.51
            (lambda (tmp.20 tmp.21 tmp.22)
              (if (fixnum? tmp.21)
                (if (vector? tmp.20)
                  (apply unsafe-vector-set!.2 tmp.20 tmp.21 tmp.22)
                  (error 9))
                (error 9))))
           (vector-length.50
            (lambda (tmp.19)
              (if (vector? tmp.19) (unsafe-vector-length tmp.19) (error 8))))
           (make-vector.49
            (lambda (tmp.18)
              (if (fixnum? tmp.18)
                (apply make-init-vector.1 tmp.18)
                (error 7))))
           (>=.48
            (lambda (tmp.16 tmp.17)
              (if (fixnum? tmp.17)
                (if (fixnum? tmp.16) (unsafe-fx>= tmp.16 tmp.17) (error 6))
                (error 6))))
           (>.47
            (lambda (tmp.14 tmp.15)
              (if (fixnum? tmp.15)
                (if (fixnum? tmp.14) (unsafe-fx> tmp.14 tmp.15) (error 5))
                (error 5))))
           (<=.46
            (lambda (tmp.12 tmp.13)
              (if (fixnum? tmp.13)
                (if (fixnum? tmp.12) (unsafe-fx<= tmp.12 tmp.13) (error 4))
                (error 4))))
           (<.45
            (lambda (tmp.10 tmp.11)
              (if (fixnum? tmp.11)
                (if (fixnum? tmp.10) (unsafe-fx< tmp.10 tmp.11) (error 3))
                (error 3))))
           (-.44
            (lambda (tmp.8 tmp.9)
              (if (fixnum? tmp.9)
                (if (fixnum? tmp.8) (unsafe-fx- tmp.8 tmp.9) (error 2))
                (error 2))))
           (+.43
            (lambda (tmp.6 tmp.7)
              (if (fixnum? tmp.7)
                (if (fixnum? tmp.6) (unsafe-fx+ tmp.6 tmp.7) (error 1))
                (error 1))))
           (*.42
            (lambda (tmp.4 tmp.5)
              (if (fixnum? tmp.5)
                (if (fixnum? tmp.4) (unsafe-fx* tmp.4 tmp.5) (error 0))
                (error 0)))))
    (let ((x.1.1 (apply make-vector.49 2))
          (x.2.2 (apply vector-set!.51 x.1.1 0 1))
          (x.3.3 (apply vector-set!.51 x.1.1 1 2))
          (x.4.4 (apply +.43 x.2.2 x.3.3)))
      x.4.4))))
)
