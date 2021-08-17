#lang racket
(require
  "a10-impl.rkt"
  "a10-implement-safe-primops.rkt"
  "a10-compiler-lib.rkt"
  "a10-graph-lib.rkt")
(module+ test
  (require rackunit))

;; integration test only for new functions in a10
(define (run p)
    (convert-closures
    (uncover-free
    (implement-safe-primops
    (dox-lambdas
    (convert-assigned
   (purify-letrec
   (define->letrec
   (expand-macros
    (uniquify p))))))))))



(module+ test
    (check-equal? (run '(module (define f.1 (cons 12 33)) f.1))
        '(module
  (letrec ((L.unsafe-vector-ref.3.1
            (lambda (c.80 tmp.75 tmp.76)
              (let ()
                (if (unsafe-fx< tmp.76 (unsafe-vector-length tmp.75))
                  (if (unsafe-fx>= tmp.76 0)
                    (unsafe-vector-ref tmp.75 tmp.76)
                    (error 10))
                  (error 10)))))
           (L.unsafe-vector-set!.2.2
            (lambda (c.81 tmp.75 tmp.76 tmp.77)
              (let ()
                (if (unsafe-fx< tmp.76 (unsafe-vector-length tmp.75))
                  (if (unsafe-fx>= tmp.76 0)
                    (begin (unsafe-vector-set! tmp.75 tmp.76 tmp.77) tmp.75)
                    (error 9))
                  (error 9)))))
           (L.vector-init-loop.71.3
            (lambda (c.82 len.72 i.74 vec.73)
              (let ((vector-init-loop.71 (closure-ref c.82 0)))
                (if (eq? len.72 i.74)
                  vec.73
                  (begin
                    (unsafe-vector-set! vec.73 i.74 0)
                    (closure-apply
                     vector-init-loop.71
                     vector-init-loop.71
                     len.72
                     (unsafe-fx+ i.74 1)
                     vec.73))))))
           (L.make-init-vector.1.4
            (lambda (c.83 tmp.69)
              (let ((vector-init-loop.71 (closure-ref c.83 0)))
                (let ((tmp.70 (unsafe-make-vector tmp.69)))
                  (closure-apply
                   vector-init-loop.71
                   vector-init-loop.71
                   tmp.69
                   0
                   tmp.70)))))
           (L.eq?.68.5
            (lambda (c.84 tmp.41 tmp.42) (let () (eq? tmp.41 tmp.42))))
           (L.cons.67.6
            (lambda (c.85 tmp.39 tmp.40) (let () (cons tmp.39 tmp.40))))
           (L.not.66.7 (lambda (c.86 tmp.38) (let () (not tmp.38))))
           (L.vector?.65.8 (lambda (c.87 tmp.37) (let () (vector? tmp.37))))
           (L.procedure?.64.9
            (lambda (c.88 tmp.36) (let () (procedure? tmp.36))))
           (L.pair?.63.10 (lambda (c.89 tmp.35) (let () (pair? tmp.35))))
           (L.error?.62.11 (lambda (c.90 tmp.34) (let () (error? tmp.34))))
           (L.ascii-char?.61.12
            (lambda (c.91 tmp.33) (let () (ascii-char? tmp.33))))
           (L.void?.60.13 (lambda (c.92 tmp.32) (let () (void? tmp.32))))
           (L.empty?.59.14 (lambda (c.93 tmp.31) (let () (empty? tmp.31))))
           (L.boolean?.58.15 (lambda (c.94 tmp.30) (let () (boolean? tmp.30))))
           (L.fixnum?.57.16 (lambda (c.95 tmp.29) (let () (fixnum? tmp.29))))
           (L.procedure-arity.56.17
            (lambda (c.96 tmp.28)
              (let ()
                (if (procedure? tmp.28)
                  (unsafe-procedure-arity tmp.28)
                  (error 13)))))
           (L.cdr.55.18
            (lambda (c.97 tmp.27)
              (let () (if (pair? tmp.27) (unsafe-cdr tmp.27) (error 12)))))
           (L.car.54.19
            (lambda (c.98 tmp.26)
              (let () (if (pair? tmp.26) (unsafe-car tmp.26) (error 11)))))
           (L.vector-ref.53.20
            (lambda (c.99 tmp.24 tmp.25)
              (let ((unsafe-vector-ref.3 (closure-ref c.99 0)))
                (if (fixnum? tmp.25)
                  (if (vector? tmp.24)
                    (closure-apply
                     unsafe-vector-ref.3
                     unsafe-vector-ref.3
                     tmp.24
                     tmp.25)
                    (error 10))
                  (error 10)))))
           (L.vector-set!.52.21
            (lambda (c.100 tmp.21 tmp.22 tmp.23)
              (let ((unsafe-vector-set!.2 (closure-ref c.100 0)))
                (if (fixnum? tmp.22)
                  (if (vector? tmp.21)
                    (closure-apply
                     unsafe-vector-set!.2
                     unsafe-vector-set!.2
                     tmp.21
                     tmp.22
                     tmp.23)
                    (error 9))
                  (error 9)))))
           (L.vector-length.51.22
            (lambda (c.101 tmp.20)
              (let ()
                (if (vector? tmp.20)
                  (unsafe-vector-length tmp.20)
                  (error 8)))))
           (L.make-vector.50.23
            (lambda (c.102 tmp.19)
              (let ((make-init-vector.1 (closure-ref c.102 0)))
                (if (fixnum? tmp.19)
                  (closure-apply make-init-vector.1 make-init-vector.1 tmp.19)
                  (error 7)))))
           (L.>=.49.24
            (lambda (c.103 tmp.17 tmp.18)
              (let ()
                (if (fixnum? tmp.18)
                  (if (fixnum? tmp.17) (unsafe-fx>= tmp.17 tmp.18) (error 6))
                  (error 6)))))
           (L.>.48.25
            (lambda (c.104 tmp.15 tmp.16)
              (let ()
                (if (fixnum? tmp.16)
                  (if (fixnum? tmp.15) (unsafe-fx> tmp.15 tmp.16) (error 5))
                  (error 5)))))
           (L.<=.47.26
            (lambda (c.105 tmp.13 tmp.14)
              (let ()
                (if (fixnum? tmp.14)
                  (if (fixnum? tmp.13) (unsafe-fx<= tmp.13 tmp.14) (error 4))
                  (error 4)))))
           (L.<.46.27
            (lambda (c.106 tmp.11 tmp.12)
              (let ()
                (if (fixnum? tmp.12)
                  (if (fixnum? tmp.11) (unsafe-fx< tmp.11 tmp.12) (error 3))
                  (error 3)))))
           (L.-.45.28
            (lambda (c.107 tmp.9 tmp.10)
              (let ()
                (if (fixnum? tmp.10)
                  (if (fixnum? tmp.9) (unsafe-fx- tmp.9 tmp.10) (error 2))
                  (error 2)))))
           (L.+.44.29
            (lambda (c.108 tmp.7 tmp.8)
              (let ()
                (if (fixnum? tmp.8)
                  (if (fixnum? tmp.7) (unsafe-fx+ tmp.7 tmp.8) (error 1))
                  (error 1)))))
           (L.*.43.30
            (lambda (c.109 tmp.5 tmp.6)
              (let ()
                (if (fixnum? tmp.6)
                  (if (fixnum? tmp.5) (unsafe-fx* tmp.5 tmp.6) (error 0))
                  (error 0))))))
    (cletrec
     ((unsafe-vector-ref.3 (make-closure L.unsafe-vector-ref.3.1 2))
      (unsafe-vector-set!.2 (make-closure L.unsafe-vector-set!.2.2 3))
      (vector-init-loop.71
       (make-closure L.vector-init-loop.71.3 3 vector-init-loop.71))
      (make-init-vector.1
       (make-closure L.make-init-vector.1.4 1 vector-init-loop.71))
      (eq?.68 (make-closure L.eq?.68.5 2))
      (cons.67 (make-closure L.cons.67.6 2))
      (not.66 (make-closure L.not.66.7 1))
      (vector?.65 (make-closure L.vector?.65.8 1))
      (procedure?.64 (make-closure L.procedure?.64.9 1))
      (pair?.63 (make-closure L.pair?.63.10 1))
      (error?.62 (make-closure L.error?.62.11 1))
      (ascii-char?.61 (make-closure L.ascii-char?.61.12 1))
      (void?.60 (make-closure L.void?.60.13 1))
      (empty?.59 (make-closure L.empty?.59.14 1))
      (boolean?.58 (make-closure L.boolean?.58.15 1))
      (fixnum?.57 (make-closure L.fixnum?.57.16 1))
      (procedure-arity.56 (make-closure L.procedure-arity.56.17 1))
      (cdr.55 (make-closure L.cdr.55.18 1))
      (car.54 (make-closure L.car.54.19 1))
      (vector-ref.53 (make-closure L.vector-ref.53.20 2 unsafe-vector-ref.3))
      (vector-set!.52
       (make-closure L.vector-set!.52.21 3 unsafe-vector-set!.2))
      (vector-length.51 (make-closure L.vector-length.51.22 1))
      (make-vector.50 (make-closure L.make-vector.50.23 1 make-init-vector.1))
      (>=.49 (make-closure L.>=.49.24 2))
      (>.48 (make-closure L.>.48.25 2))
      (<=.47 (make-closure L.<=.47.26 2))
      (<.46 (make-closure L.<.46.27 2))
      (-.45 (make-closure L.-.45.28 2))
      (+.44 (make-closure L.+.44.29 2))
      (*.43 (make-closure L.*.43.30 2)))
     (let ((f.1.4 (closure-apply cons.67 cons.67 12 33)))
       (let () (letrec () (cletrec () (let () f.1.4)))))))))

  (check-equal? (run `(module (let ([f (lambda (a) (and a #t))])
                                (f #t))))
    '(module
  (letrec ((L.unsafe-vector-ref.3.1
            (lambda (c.82 tmp.77 tmp.78)
              (let ()
                (if (unsafe-fx< tmp.78 (unsafe-vector-length tmp.77))
                  (if (unsafe-fx>= tmp.78 0)
                    (unsafe-vector-ref tmp.77 tmp.78)
                    (error 10))
                  (error 10)))))
           (L.unsafe-vector-set!.2.2
            (lambda (c.83 tmp.77 tmp.78 tmp.79)
              (let ()
                (if (unsafe-fx< tmp.78 (unsafe-vector-length tmp.77))
                  (if (unsafe-fx>= tmp.78 0)
                    (begin (unsafe-vector-set! tmp.77 tmp.78 tmp.79) tmp.77)
                    (error 9))
                  (error 9)))))
           (L.vector-init-loop.73.3
            (lambda (c.84 len.74 i.76 vec.75)
              (let ((vector-init-loop.73 (closure-ref c.84 0)))
                (if (eq? len.74 i.76)
                  vec.75
                  (begin
                    (unsafe-vector-set! vec.75 i.76 0)
                    (closure-apply
                     vector-init-loop.73
                     vector-init-loop.73
                     len.74
                     (unsafe-fx+ i.76 1)
                     vec.75))))))
           (L.make-init-vector.1.4
            (lambda (c.85 tmp.71)
              (let ((vector-init-loop.73 (closure-ref c.85 0)))
                (let ((tmp.72 (unsafe-make-vector tmp.71)))
                  (closure-apply
                   vector-init-loop.73
                   vector-init-loop.73
                   tmp.71
                   0
                   tmp.72)))))
           (L.eq?.70.5
            (lambda (c.86 tmp.43 tmp.44) (let () (eq? tmp.43 tmp.44))))
           (L.cons.69.6
            (lambda (c.87 tmp.41 tmp.42) (let () (cons tmp.41 tmp.42))))
           (L.not.68.7 (lambda (c.88 tmp.40) (let () (not tmp.40))))
           (L.vector?.67.8 (lambda (c.89 tmp.39) (let () (vector? tmp.39))))
           (L.procedure?.66.9
            (lambda (c.90 tmp.38) (let () (procedure? tmp.38))))
           (L.pair?.65.10 (lambda (c.91 tmp.37) (let () (pair? tmp.37))))
           (L.error?.64.11 (lambda (c.92 tmp.36) (let () (error? tmp.36))))
           (L.ascii-char?.63.12
            (lambda (c.93 tmp.35) (let () (ascii-char? tmp.35))))
           (L.void?.62.13 (lambda (c.94 tmp.34) (let () (void? tmp.34))))
           (L.empty?.61.14 (lambda (c.95 tmp.33) (let () (empty? tmp.33))))
           (L.boolean?.60.15 (lambda (c.96 tmp.32) (let () (boolean? tmp.32))))
           (L.fixnum?.59.16 (lambda (c.97 tmp.31) (let () (fixnum? tmp.31))))
           (L.procedure-arity.58.17
            (lambda (c.98 tmp.30)
              (let ()
                (if (procedure? tmp.30)
                  (unsafe-procedure-arity tmp.30)
                  (error 13)))))
           (L.cdr.57.18
            (lambda (c.99 tmp.29)
              (let () (if (pair? tmp.29) (unsafe-cdr tmp.29) (error 12)))))
           (L.car.56.19
            (lambda (c.100 tmp.28)
              (let () (if (pair? tmp.28) (unsafe-car tmp.28) (error 11)))))
           (L.vector-ref.55.20
            (lambda (c.101 tmp.26 tmp.27)
              (let ((unsafe-vector-ref.3 (closure-ref c.101 0)))
                (if (fixnum? tmp.27)
                  (if (vector? tmp.26)
                    (closure-apply
                     unsafe-vector-ref.3
                     unsafe-vector-ref.3
                     tmp.26
                     tmp.27)
                    (error 10))
                  (error 10)))))
           (L.vector-set!.54.21
            (lambda (c.102 tmp.23 tmp.24 tmp.25)
              (let ((unsafe-vector-set!.2 (closure-ref c.102 0)))
                (if (fixnum? tmp.24)
                  (if (vector? tmp.23)
                    (closure-apply
                     unsafe-vector-set!.2
                     unsafe-vector-set!.2
                     tmp.23
                     tmp.24
                     tmp.25)
                    (error 9))
                  (error 9)))))
           (L.vector-length.53.22
            (lambda (c.103 tmp.22)
              (let ()
                (if (vector? tmp.22)
                  (unsafe-vector-length tmp.22)
                  (error 8)))))
           (L.make-vector.52.23
            (lambda (c.104 tmp.21)
              (let ((make-init-vector.1 (closure-ref c.104 0)))
                (if (fixnum? tmp.21)
                  (closure-apply make-init-vector.1 make-init-vector.1 tmp.21)
                  (error 7)))))
           (L.>=.51.24
            (lambda (c.105 tmp.19 tmp.20)
              (let ()
                (if (fixnum? tmp.20)
                  (if (fixnum? tmp.19) (unsafe-fx>= tmp.19 tmp.20) (error 6))
                  (error 6)))))
           (L.>.50.25
            (lambda (c.106 tmp.17 tmp.18)
              (let ()
                (if (fixnum? tmp.18)
                  (if (fixnum? tmp.17) (unsafe-fx> tmp.17 tmp.18) (error 5))
                  (error 5)))))
           (L.<=.49.26
            (lambda (c.107 tmp.15 tmp.16)
              (let ()
                (if (fixnum? tmp.16)
                  (if (fixnum? tmp.15) (unsafe-fx<= tmp.15 tmp.16) (error 4))
                  (error 4)))))
           (L.<.48.27
            (lambda (c.108 tmp.13 tmp.14)
              (let ()
                (if (fixnum? tmp.14)
                  (if (fixnum? tmp.13) (unsafe-fx< tmp.13 tmp.14) (error 3))
                  (error 3)))))
           (L.-.47.28
            (lambda (c.109 tmp.11 tmp.12)
              (let ()
                (if (fixnum? tmp.12)
                  (if (fixnum? tmp.11) (unsafe-fx- tmp.11 tmp.12) (error 2))
                  (error 2)))))
           (L.+.46.29
            (lambda (c.110 tmp.9 tmp.10)
              (let ()
                (if (fixnum? tmp.10)
                  (if (fixnum? tmp.9) (unsafe-fx+ tmp.9 tmp.10) (error 1))
                  (error 1)))))
           (L.*.45.30
            (lambda (c.111 tmp.7 tmp.8)
              (let ()
                (if (fixnum? tmp.8)
                  (if (fixnum? tmp.7) (unsafe-fx* tmp.7 tmp.8) (error 0))
                  (error 0))))))
    (cletrec
     ((unsafe-vector-ref.3 (make-closure L.unsafe-vector-ref.3.1 2))
      (unsafe-vector-set!.2 (make-closure L.unsafe-vector-set!.2.2 3))
      (vector-init-loop.73
       (make-closure L.vector-init-loop.73.3 3 vector-init-loop.73))
      (make-init-vector.1
       (make-closure L.make-init-vector.1.4 1 vector-init-loop.73))
      (eq?.70 (make-closure L.eq?.70.5 2))
      (cons.69 (make-closure L.cons.69.6 2))
      (not.68 (make-closure L.not.68.7 1))
      (vector?.67 (make-closure L.vector?.67.8 1))
      (procedure?.66 (make-closure L.procedure?.66.9 1))
      (pair?.65 (make-closure L.pair?.65.10 1))
      (error?.64 (make-closure L.error?.64.11 1))
      (ascii-char?.63 (make-closure L.ascii-char?.63.12 1))
      (void?.62 (make-closure L.void?.62.13 1))
      (empty?.61 (make-closure L.empty?.61.14 1))
      (boolean?.60 (make-closure L.boolean?.60.15 1))
      (fixnum?.59 (make-closure L.fixnum?.59.16 1))
      (procedure-arity.58 (make-closure L.procedure-arity.58.17 1))
      (cdr.57 (make-closure L.cdr.57.18 1))
      (car.56 (make-closure L.car.56.19 1))
      (vector-ref.55 (make-closure L.vector-ref.55.20 2 unsafe-vector-ref.3))
      (vector-set!.54
       (make-closure L.vector-set!.54.21 3 unsafe-vector-set!.2))
      (vector-length.53 (make-closure L.vector-length.53.22 1))
      (make-vector.52 (make-closure L.make-vector.52.23 1 make-init-vector.1))
      (>=.51 (make-closure L.>=.51.24 2))
      (>.50 (make-closure L.>.50.25 2))
      (<=.49 (make-closure L.<=.49.26 2))
      (<.48 (make-closure L.<.48.27 2))
      (-.47 (make-closure L.-.47.28 2))
      (+.46 (make-closure L.+.46.29 2))
      (*.45 (make-closure L.*.45.30 2)))
     (let ()
       (let ()
         (letrec ()
           (cletrec
            ()
            (let ()
              (let ((f.4
                     (letrec ((L.tmp.6.31
                               (lambda (c.112 a.5) (let () (if a.5 #t #f)))))
                       (cletrec ((tmp.6 (make-closure L.tmp.6.31 1))) tmp.6))))
                (closure-apply f.4 f.4 #t)))))))))))


    (check-equal? (run '(module (define f (lambda (x y) (* (and x (or y #t)))))
                                    (letrec ([a (f '(ab ni im) #t)] [b (f a b)]) 
                                            #(a b)))
                    )
        '(module
  (letrec ((L.unsafe-vector-ref.3.1
            (lambda (c.92 tmp.87 tmp.88)
              (let ()
                (if (unsafe-fx< tmp.88 (unsafe-vector-length tmp.87))
                  (if (unsafe-fx>= tmp.88 0)
                    (unsafe-vector-ref tmp.87 tmp.88)
                    (error 10))
                  (error 10)))))
           (L.unsafe-vector-set!.2.2
            (lambda (c.93 tmp.87 tmp.88 tmp.89)
              (let ()
                (if (unsafe-fx< tmp.88 (unsafe-vector-length tmp.87))
                  (if (unsafe-fx>= tmp.88 0)
                    (begin (unsafe-vector-set! tmp.87 tmp.88 tmp.89) tmp.87)
                    (error 9))
                  (error 9)))))
           (L.vector-init-loop.83.3
            (lambda (c.94 len.84 i.86 vec.85)
              (let ((vector-init-loop.83 (closure-ref c.94 0)))
                (if (eq? len.84 i.86)
                  vec.85
                  (begin
                    (unsafe-vector-set! vec.85 i.86 0)
                    (closure-apply
                     vector-init-loop.83
                     vector-init-loop.83
                     len.84
                     (unsafe-fx+ i.86 1)
                     vec.85))))))
           (L.make-init-vector.1.4
            (lambda (c.95 tmp.81)
              (let ((vector-init-loop.83 (closure-ref c.95 0)))
                (let ((tmp.82 (unsafe-make-vector tmp.81)))
                  (closure-apply
                   vector-init-loop.83
                   vector-init-loop.83
                   tmp.81
                   0
                   tmp.82)))))
           (L.eq?.80.5
            (lambda (c.96 tmp.53 tmp.54) (let () (eq? tmp.53 tmp.54))))
           (L.cons.79.6
            (lambda (c.97 tmp.51 tmp.52) (let () (cons tmp.51 tmp.52))))
           (L.not.78.7 (lambda (c.98 tmp.50) (let () (not tmp.50))))
           (L.vector?.77.8 (lambda (c.99 tmp.49) (let () (vector? tmp.49))))
           (L.procedure?.76.9
            (lambda (c.100 tmp.48) (let () (procedure? tmp.48))))
           (L.pair?.75.10 (lambda (c.101 tmp.47) (let () (pair? tmp.47))))
           (L.error?.74.11 (lambda (c.102 tmp.46) (let () (error? tmp.46))))
           (L.ascii-char?.73.12
            (lambda (c.103 tmp.45) (let () (ascii-char? tmp.45))))
           (L.void?.72.13 (lambda (c.104 tmp.44) (let () (void? tmp.44))))
           (L.empty?.71.14 (lambda (c.105 tmp.43) (let () (empty? tmp.43))))
           (L.boolean?.70.15
            (lambda (c.106 tmp.42) (let () (boolean? tmp.42))))
           (L.fixnum?.69.16 (lambda (c.107 tmp.41) (let () (fixnum? tmp.41))))
           (L.procedure-arity.68.17
            (lambda (c.108 tmp.40)
              (let ()
                (if (procedure? tmp.40)
                  (unsafe-procedure-arity tmp.40)
                  (error 13)))))
           (L.cdr.67.18
            (lambda (c.109 tmp.39)
              (let () (if (pair? tmp.39) (unsafe-cdr tmp.39) (error 12)))))
           (L.car.66.19
            (lambda (c.110 tmp.38)
              (let () (if (pair? tmp.38) (unsafe-car tmp.38) (error 11)))))
           (L.vector-ref.65.20
            (lambda (c.111 tmp.36 tmp.37)
              (let ((unsafe-vector-ref.3 (closure-ref c.111 0)))
                (if (fixnum? tmp.37)
                  (if (vector? tmp.36)
                    (closure-apply
                     unsafe-vector-ref.3
                     unsafe-vector-ref.3
                     tmp.36
                     tmp.37)
                    (error 10))
                  (error 10)))))
           (L.vector-set!.64.21
            (lambda (c.112 tmp.33 tmp.34 tmp.35)
              (let ((unsafe-vector-set!.2 (closure-ref c.112 0)))
                (if (fixnum? tmp.34)
                  (if (vector? tmp.33)
                    (closure-apply
                     unsafe-vector-set!.2
                     unsafe-vector-set!.2
                     tmp.33
                     tmp.34
                     tmp.35)
                    (error 9))
                  (error 9)))))
           (L.vector-length.63.22
            (lambda (c.113 tmp.32)
              (let ()
                (if (vector? tmp.32)
                  (unsafe-vector-length tmp.32)
                  (error 8)))))
           (L.make-vector.62.23
            (lambda (c.114 tmp.31)
              (let ((make-init-vector.1 (closure-ref c.114 0)))
                (if (fixnum? tmp.31)
                  (closure-apply make-init-vector.1 make-init-vector.1 tmp.31)
                  (error 7)))))
           (L.>=.61.24
            (lambda (c.115 tmp.29 tmp.30)
              (let ()
                (if (fixnum? tmp.30)
                  (if (fixnum? tmp.29) (unsafe-fx>= tmp.29 tmp.30) (error 6))
                  (error 6)))))
           (L.>.60.25
            (lambda (c.116 tmp.27 tmp.28)
              (let ()
                (if (fixnum? tmp.28)
                  (if (fixnum? tmp.27) (unsafe-fx> tmp.27 tmp.28) (error 5))
                  (error 5)))))
           (L.<=.59.26
            (lambda (c.117 tmp.25 tmp.26)
              (let ()
                (if (fixnum? tmp.26)
                  (if (fixnum? tmp.25) (unsafe-fx<= tmp.25 tmp.26) (error 4))
                  (error 4)))))
           (L.<.58.27
            (lambda (c.118 tmp.23 tmp.24)
              (let ()
                (if (fixnum? tmp.24)
                  (if (fixnum? tmp.23) (unsafe-fx< tmp.23 tmp.24) (error 3))
                  (error 3)))))
           (L.-.57.28
            (lambda (c.119 tmp.21 tmp.22)
              (let ()
                (if (fixnum? tmp.22)
                  (if (fixnum? tmp.21) (unsafe-fx- tmp.21 tmp.22) (error 2))
                  (error 2)))))
           (L.+.56.29
            (lambda (c.120 tmp.19 tmp.20)
              (let ()
                (if (fixnum? tmp.20)
                  (if (fixnum? tmp.19) (unsafe-fx+ tmp.19 tmp.20) (error 1))
                  (error 1)))))
           (L.*.55.30
            (lambda (c.121 tmp.17 tmp.18)
              (let ()
                (if (fixnum? tmp.18)
                  (if (fixnum? tmp.17) (unsafe-fx* tmp.17 tmp.18) (error 0))
                  (error 0))))))
    (cletrec
     ((unsafe-vector-ref.3 (make-closure L.unsafe-vector-ref.3.1 2))
      (unsafe-vector-set!.2 (make-closure L.unsafe-vector-set!.2.2 3))
      (vector-init-loop.83
       (make-closure L.vector-init-loop.83.3 3 vector-init-loop.83))
      (make-init-vector.1
       (make-closure L.make-init-vector.1.4 1 vector-init-loop.83))
      (eq?.80 (make-closure L.eq?.80.5 2))
      (cons.79 (make-closure L.cons.79.6 2))
      (not.78 (make-closure L.not.78.7 1))
      (vector?.77 (make-closure L.vector?.77.8 1))
      (procedure?.76 (make-closure L.procedure?.76.9 1))
      (pair?.75 (make-closure L.pair?.75.10 1))
      (error?.74 (make-closure L.error?.74.11 1))
      (ascii-char?.73 (make-closure L.ascii-char?.73.12 1))
      (void?.72 (make-closure L.void?.72.13 1))
      (empty?.71 (make-closure L.empty?.71.14 1))
      (boolean?.70 (make-closure L.boolean?.70.15 1))
      (fixnum?.69 (make-closure L.fixnum?.69.16 1))
      (procedure-arity.68 (make-closure L.procedure-arity.68.17 1))
      (cdr.67 (make-closure L.cdr.67.18 1))
      (car.66 (make-closure L.car.66.19 1))
      (vector-ref.65 (make-closure L.vector-ref.65.20 2 unsafe-vector-ref.3))
      (vector-set!.64
       (make-closure L.vector-set!.64.21 3 unsafe-vector-set!.2))
      (vector-length.63 (make-closure L.vector-length.63.22 1))
      (make-vector.62 (make-closure L.make-vector.62.23 1 make-init-vector.1))
      (>=.61 (make-closure L.>=.61.24 2))
      (>.60 (make-closure L.>.60.25 2))
      (<=.59 (make-closure L.<=.59.26 2))
      (<.58 (make-closure L.<.58.27 2))
      (-.57 (make-closure L.-.57.28 2))
      (+.56 (make-closure L.+.56.29 2))
      (*.55 (make-closure L.*.55.30 2)))
     (let ()
       (let ()
         (letrec ((L.f.4.31
                   (lambda (c.122 x.5 y.6)
                     (let ((*.55 (closure-ref c.122 0)))
                       (closure-apply
                        *.55
                        *.55
                        (if x.5
                          (let ((tmp.9 y.6)) (if tmp.9 tmp.9 #t))
                          #f))))))
           (cletrec
            ((f.4 (make-closure L.f.4.31 2 *.55)))
            (let ()
              (let ()
                (let ((a.7 (closure-apply make-vector.62 make-vector.62 1))
                      (b.8 (closure-apply make-vector.62 make-vector.62 1)))
                  (letrec ()
                    (cletrec
                     ()
                     (let ((a.7.13
                            (closure-apply
                             f.4
                             f.4
                             (closure-apply
                              cons.79
                              cons.79
                              ab
                              (closure-apply
                               cons.79
                               cons.79
                               ni
                               (closure-apply cons.79 cons.79 im ())))
                             #t))
                           (b.8.14
                            (closure-apply
                             f.4
                             f.4
                             (closure-apply vector-ref.65 vector-ref.65 a.7 0)
                             (closure-apply
                              vector-ref.65
                              vector-ref.65
                              b.8
                              0))))
                       (let ((tmp.15
                              (closure-apply
                               vector-set!.64
                               vector-set!.64
                               a.7
                               0
                               a.7.13)))
                         (let ((tmp.16
                                (closure-apply
                                 vector-set!.64
                                 vector-set!.64
                                 b.8
                                 0
                                 b.8.14)))
                           (let ((tmp.10
                                  (closure-apply
                                   make-vector.62
                                   make-vector.62
                                   2)))
                             (let ((tmp.11
                                    (closure-apply
                                     vector-set!.64
                                     vector-set!.64
                                     tmp.10
                                     0
                                     a)))
                               (if (closure-apply error?.74 error?.74 tmp.11)
                                 tmp.11
                                 (let ((tmp.12
                                        (closure-apply
                                         vector-set!.64
                                         vector-set!.64
                                         tmp.10
                                         1
                                         b)))
                                   (if (closure-apply
                                        error?.74
                                        error?.74
                                        tmp.12)
                                     tmp.12
                                     tmp.10)))))))))))))))))))))
  
  (check-equal? 
  (implement-safe-primops (dox-lambdas
    (convert-assigned
   (purify-letrec
   (define->letrec (expand-macros (uniquify '(module (define f (lambda (x y) (* (and x (or y #t)))))
                                    (letrec ([a (f '(ab ni im) #t)] [b (f a b)]) 
                                            #(a b))))))))))
                                            '(module
  (letrec ((unsafe-vector-ref.3
            (lambda (tmp.87 tmp.88)
              (if (unsafe-fx< tmp.88 (unsafe-vector-length tmp.87))
                (if (unsafe-fx>= tmp.88 0)
                  (unsafe-vector-ref tmp.87 tmp.88)
                  (error 10))
                (error 10))))
           (unsafe-vector-set!.2
            (lambda (tmp.87 tmp.88 tmp.89)
              (if (unsafe-fx< tmp.88 (unsafe-vector-length tmp.87))
                (if (unsafe-fx>= tmp.88 0)
                  (begin (unsafe-vector-set! tmp.87 tmp.88 tmp.89) tmp.87)
                  (error 9))
                (error 9))))
           (vector-init-loop.83
            (lambda (len.84 i.86 vec.85)
              (if (eq? len.84 i.86)
                vec.85
                (begin
                  (unsafe-vector-set! vec.85 i.86 0)
                  (apply
                   vector-init-loop.83
                   len.84
                   (unsafe-fx+ i.86 1)
                   vec.85)))))
           (make-init-vector.1
            (lambda (tmp.81)
              (let ((tmp.82 (unsafe-make-vector tmp.81)))
                (apply vector-init-loop.83 tmp.81 0 tmp.82))))
           (eq?.80 (lambda (tmp.53 tmp.54) (eq? tmp.53 tmp.54)))
           (cons.79 (lambda (tmp.51 tmp.52) (cons tmp.51 tmp.52)))
           (not.78 (lambda (tmp.50) (not tmp.50)))
           (vector?.77 (lambda (tmp.49) (vector? tmp.49)))
           (procedure?.76 (lambda (tmp.48) (procedure? tmp.48)))
           (pair?.75 (lambda (tmp.47) (pair? tmp.47)))
           (error?.74 (lambda (tmp.46) (error? tmp.46)))
           (ascii-char?.73 (lambda (tmp.45) (ascii-char? tmp.45)))
           (void?.72 (lambda (tmp.44) (void? tmp.44)))
           (empty?.71 (lambda (tmp.43) (empty? tmp.43)))
           (boolean?.70 (lambda (tmp.42) (boolean? tmp.42)))
           (fixnum?.69 (lambda (tmp.41) (fixnum? tmp.41)))
           (procedure-arity.68
            (lambda (tmp.40)
              (if (procedure? tmp.40)
                (unsafe-procedure-arity tmp.40)
                (error 13))))
           (cdr.67
            (lambda (tmp.39)
              (if (pair? tmp.39) (unsafe-cdr tmp.39) (error 12))))
           (car.66
            (lambda (tmp.38)
              (if (pair? tmp.38) (unsafe-car tmp.38) (error 11))))
           (vector-ref.65
            (lambda (tmp.36 tmp.37)
              (if (fixnum? tmp.37)
                (if (vector? tmp.36)
                  (apply unsafe-vector-ref.3 tmp.36 tmp.37)
                  (error 10))
                (error 10))))
           (vector-set!.64
            (lambda (tmp.33 tmp.34 tmp.35)
              (if (fixnum? tmp.34)
                (if (vector? tmp.33)
                  (apply unsafe-vector-set!.2 tmp.33 tmp.34 tmp.35)
                  (error 9))
                (error 9))))
           (vector-length.63
            (lambda (tmp.32)
              (if (vector? tmp.32) (unsafe-vector-length tmp.32) (error 8))))
           (make-vector.62
            (lambda (tmp.31)
              (if (fixnum? tmp.31)
                (apply make-init-vector.1 tmp.31)
                (error 7))))
           (>=.61
            (lambda (tmp.29 tmp.30)
              (if (fixnum? tmp.30)
                (if (fixnum? tmp.29) (unsafe-fx>= tmp.29 tmp.30) (error 6))
                (error 6))))
           (>.60
            (lambda (tmp.27 tmp.28)
              (if (fixnum? tmp.28)
                (if (fixnum? tmp.27) (unsafe-fx> tmp.27 tmp.28) (error 5))
                (error 5))))
           (<=.59
            (lambda (tmp.25 tmp.26)
              (if (fixnum? tmp.26)
                (if (fixnum? tmp.25) (unsafe-fx<= tmp.25 tmp.26) (error 4))
                (error 4))))
           (<.58
            (lambda (tmp.23 tmp.24)
              (if (fixnum? tmp.24)
                (if (fixnum? tmp.23) (unsafe-fx< tmp.23 tmp.24) (error 3))
                (error 3))))
           (-.57
            (lambda (tmp.21 tmp.22)
              (if (fixnum? tmp.22)
                (if (fixnum? tmp.21) (unsafe-fx- tmp.21 tmp.22) (error 2))
                (error 2))))
           (+.56
            (lambda (tmp.19 tmp.20)
              (if (fixnum? tmp.20)
                (if (fixnum? tmp.19) (unsafe-fx+ tmp.19 tmp.20) (error 1))
                (error 1))))
           (*.55
            (lambda (tmp.17 tmp.18)
              (if (fixnum? tmp.18)
                (if (fixnum? tmp.17) (unsafe-fx* tmp.17 tmp.18) (error 0))
                (error 0)))))
    (let ()
      (let ()
        (letrec ((f.4
                  (lambda (x.5 y.6)
                    (apply
                     *.55
                     (if x.5 (let ((tmp.9 y.6)) (if tmp.9 tmp.9 #t)) #f)))))
          (let ()
            (let ()
              (let ((a.7 (apply make-vector.62 1))
                    (b.8 (apply make-vector.62 1)))
                (letrec ()
                  (let ((a.7.13
                         (apply
                          f.4
                          (apply
                           cons.79
                           ab
                           (apply cons.79 ni (apply cons.79 im ())))
                          #t))
                        (b.8.14
                         (apply
                          f.4
                          (apply vector-ref.65 a.7 0)
                          (apply vector-ref.65 b.8 0))))
                    (let ((tmp.15 (apply vector-set!.64 a.7 0 a.7.13)))
                      (let ((tmp.16 (apply vector-set!.64 b.8 0 b.8.14)))
                        (let ((tmp.10 (apply make-vector.62 2)))
                          (let ((tmp.11 (apply vector-set!.64 tmp.10 0 a)))
                            (if (apply error?.74 tmp.11)
                              tmp.11
                              (let ((tmp.12 (apply vector-set!.64 tmp.10 1 b)))
                                (if (apply error?.74 tmp.12)
                                  tmp.12
                                  tmp.10))))))))))))))))))
  
  )


#||#
(convert-closures
    (uncover-free
    (implement-safe-primops
    (dox-lambdas
    (convert-assigned
   (purify-letrec
   (define->letrec
   (expand-macros
    (uniquify '(module (define f (lambda (x y) (* (and x (or y #t)))))
                                    (letrec ([a (f '(ab ni im) #t)] [b (f a b)]) 
                                            #(a b)))
    )))))))))

