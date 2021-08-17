#lang racket
(require
  "../a10.rkt"
  "../a10-implement-safe-primops.rkt"
  "../a10-compiler-lib.rkt"
  "../a10-graph-lib.rkt")
(module+ test
  (require rackunit))

(module+ test 
#;(check-equal? (uniquify 
                '(module (define error 
                  (lambda (define) 
                    (let ((not eq?)) 
                      (letrec ((letrec -)) 
                        (let ((eq? 1)) 
                          (let ((apply 0)) 
                            (let ((lambda define)) 
                              (let ((let *)) 
                                (if (not define apply) 
                                  eq? 
                                  (let define (error (letrec lambda eq?)))))))))))) 
                            (let ((let 5)) (letrec ((define error)) (define let)))))
  '(module
    (define error.4
      (lambda (define.5)
        (let ((not.6 eq?))
          (letrec ((letrec.7 -))
            (let ((eq?.8 1))
              (let ((apply.9 0))
                (let ((lambda.10 define.5))
                  (let ((let.11 *))
                    (if (not.6 define.5 apply.9)
                      eq?.8
                      (let.11
                      define.5
                      (error.4 (letrec.7 lambda.10 eq?.8))))))))))))
    (let ((let.12 5)) (letrec ((define.13 error.4)) (define.13 let.12)))))

(check-equal? (implement-safe-primops '(module
    (let ()
      (let ()
        (letrec ((error.4
                  (lambda (define.5)
                    (let ((not.6 eq?))
                      (let ((letrec.7 -))
                        (let ()
                          (letrec ()
                            (let ()
                              (let ((eq?.8 1))
                                (let ((apply.9 0))
                                  (let ((lambda.10 define.5))
                                    (let ((let.11 *))
                                      (if (apply not.6 define.5 apply.9)
                                        eq?.8
                                        (apply
                                         let.11
                                         define.5
                                         (apply
                                          error.4
                                          (apply
                                           letrec.7
                                           lambda.10
                                           eq?.8))))))))))))))))
          (let ()
            (let ((let.12 5))
              (let ((define.13 error.4))
                (let () (letrec () (let () (apply define.13 let.12))))))))))))
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
    (let ()
      (let ()
        (letrec ((error.4
                  (lambda (define.5)
                    (let ((not.6 eq?.67))
                      (let ((letrec.7 -.44))
                        (let ()
                          (letrec ()
                            (let ()
                              (let ((eq?.8 1))
                                (let ((apply.9 0))
                                  (let ((lambda.10 define.5))
                                    (let ((let.11 *.42))
                                      (if (apply not.6 define.5 apply.9)
                                        eq?.8
                                        (apply
                                         let.11
                                         define.5
                                         (apply
                                          error.4
                                          (apply
                                           letrec.7
                                           lambda.10
                                           eq?.8))))))))))))))))
          (let ()
            (let ((let.12 5))
              (let ((define.13 error.4))
                (let () (letrec () (let () (apply define.13 let.12)))))))))))))

(check-equal? (uniquify '(module (letrec ([f (lambda (x) (lambda (y) (+ x y)))])
                ((f 7) 9))))
                '(module (letrec ((f.4 (lambda (x.5) (lambda (y.6) (+ x.5 y.6))))) ((f.4 7) 9))))

(check-equal? (implement-safe-primops '(module
    (let ()
      (let ((counter!.4 (apply make-vector 1)))
        (letrec ()
          (let ((counter!.4.9
                 (let ((x.5 (apply make-vector 1)))
                   (letrec ((tmp.11
                             (lambda ()
                               (let ((tmp.6
                                      (apply
                                       vector-set!
                                       x.5
                                       0
                                       (apply + 1 (apply vector-ref x.5 0)))))
                                 (if (apply error? tmp.6)
                                   tmp.6
                                   (apply vector-ref x.5 0))))))
                     tmp.11))))
            (let ((tmp.10 (apply vector-set! counter!.4 0 counter!.4.9)))
              (let ((tmp.7 (apply (apply vector-ref counter!.4 0))))
                (if (apply error? tmp.7)
                  tmp.7
                  (let ((tmp.8 (apply (apply vector-ref counter!.4 0))))
                    (if (apply error? tmp.8)
                      tmp.8
                      (apply (apply vector-ref counter!.4 0)))))))))))))
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
    (let ()
      (let ((counter!.4 (apply make-vector.49 1)))
        (letrec ()
          (let ((counter!.4.9
                 (let ((x.5 (apply make-vector.49 1)))
                   (letrec ((tmp.11
                             (lambda ()
                               (let ((tmp.6
                                      (apply
                                       vector-set!.51
                                       x.5
                                       0
                                       (apply
                                        +.43
                                        1
                                        (apply vector-ref.52 x.5 0)))))
                                 (if (apply error?.61 tmp.6)
                                   tmp.6
                                   (apply vector-ref.52 x.5 0))))))
                     tmp.11))))
            (let ((tmp.10 (apply vector-set!.51 counter!.4 0 counter!.4.9)))
              (let ((tmp.7 (apply (apply vector-ref.52 counter!.4 0))))
                (if (apply error?.61 tmp.7)
                  tmp.7
                  (let ((tmp.8 (apply (apply vector-ref.52 counter!.4 0))))
                    (if (apply error?.61 tmp.8)
                      tmp.8
                      (apply (apply vector-ref.52 counter!.4 0))))))))))))) )

)