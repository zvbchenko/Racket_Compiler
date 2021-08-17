#lang racket
(require
  "../a10.rkt"
  "../a10-implement-safe-primops.rkt"
  "../a10-compiler-lib.rkt"
  "../a10-graph-lib.rkt")
(module+ test
  (require rackunit))


(module+ test
#|
(parameterize ([current-pass-list
                  (list
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute 
     ) '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)))

(parameterize ([current-pass-list
                  (list
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute 
     ) '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)))

(parameterize ([current-pass-list
                  (list
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute 
     ) '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)))

(parameterize ([current-pass-list
                  (list
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute 
     ) '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)))

(parameterize ([current-pass-list
                  (list
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute 
     ) '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)))

(parameterize ([current-pass-list
                  (list
                   implement-fvars
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute 
     ) '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)))



(parameterize ([current-pass-list
                  (list
                   replace-locations
                   implement-fvars
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute 
     ) '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)))



(parameterize ([current-pass-list
                  (list
                   discard-call-live
                   replace-locations
                   implement-fvars
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute
     ) '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)))

  (parameterize ([current-pass-list
                  (list
                   assign-frame-variables
                   discard-call-live
                   replace-locations
                   implement-fvars
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute 
     ) '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))

  )

  (parameterize ([current-pass-list
                  (list
                   assign-frames
                   assign-registers
                   assign-frame-variables
                   discard-call-live
                   replace-locations
                   implement-fvars
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute 
     ) '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))

  )
  (parameterize ([current-pass-list
                  (list
                   pre-assign-frame-variables
                   assign-frames
                   assign-registers
                   assign-frame-variables
                   discard-call-live
                   replace-locations
                   implement-fvars
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute 
     ) '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))

  )
  (parameterize ([current-pass-list
                  (list
                   a-normalize
                   select-instructions
                   expose-allocation-pointer
                   uncover-locals
                   undead-analysis
                   conflict-analysis
                   pre-assign-frame-variables
                   assign-frames
                   assign-registers
                   assign-frame-variables
                   discard-call-live
                   replace-locations
                   implement-fvars
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute      ) '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))

  )
  (parameterize ([current-pass-list
                  (list
                   specify-representation
                   a-normalize
                   select-instructions
                   expose-allocation-pointer
                   uncover-locals
                   undead-analysis
                   conflict-analysis
                   pre-assign-frame-variables
                   assign-frames
                   assign-registers
                   assign-frame-variables
                   discard-call-live
                   replace-locations
                   implement-fvars
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute 
          ) '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))

  )
  (parameterize ([current-pass-list
                  (list
                   implement-closures
                   sequentialize-let
                   implement-safe-apply
                   specify-representation
                   a-normalize
                   select-instructions
                   expose-allocation-pointer
                   uncover-locals
                   undead-analysis
                   conflict-analysis
                   pre-assign-frame-variables
                   assign-frames
                   assign-registers
                   assign-frame-variables
                   discard-call-live
                   replace-locations
                   implement-fvars
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute 
     ) '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))

  )
  |#
  (parameterize ([current-pass-list
                  (list
                   hoist-lambdas
                   implement-closures
                   sequentialize-let
                   implement-safe-apply
                   specify-representation
                   a-normalize
                   select-instructions
                   expose-allocation-pointer
                   uncover-locals
                   undead-analysis
                   conflict-analysis
                   pre-assign-frame-variables
                   assign-frames
                   assign-registers
                   assign-frame-variables
                   discard-call-live
                   replace-locations
                   implement-fvars
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute '(module
    (letrec ((L.unsafe-vector-ref.3.1
              (lambda (c.86 tmp.80 tmp.81)
                (let ()
                  (if (unsafe-fx< tmp.81 (unsafe-vector-length tmp.80))
                    (if (unsafe-fx>= tmp.81 0)
                      (unsafe-vector-ref tmp.80 tmp.81)
                      (error 10))
                    (error 10)))))
             (L.unsafe-vector-set!.2.2
              (lambda (c.87 tmp.83 tmp.84 tmp.85)
                (let ()
                  (if (unsafe-fx< tmp.84 (unsafe-vector-length tmp.83))
                    (if (unsafe-fx>= tmp.84 0)
                      (begin (unsafe-vector-set! tmp.83 tmp.84 tmp.85) (void))
                      (error 9))
                    (error 9)))))
             (L.vector-init-loop.74.3
              (lambda (c.88 len.75 i.77 vec.76)
                (let ((vector-init-loop.74 (closure-ref c.88 0)))
                  (if (eq? len.75 i.77)
                    vec.76
                    (begin
                      (unsafe-vector-set! vec.76 i.77 0)
                      (let ((tmp.119 vector-init-loop.74))
                        (unsafe-apply
                         L.vector-init-loop.74.3
                         vector-init-loop.74
                         len.75
                         (unsafe-fx+ i.77 1)
                         vec.76)))))))
             (L.make-init-vector.1.4
              (lambda (c.89 tmp.72)
                (let ((vector-init-loop.74 (closure-ref c.89 0)))
                  (let ((tmp.73 (unsafe-make-vector tmp.72)))
                    (let ((tmp.120 vector-init-loop.74))
                      (unsafe-apply
                       L.vector-init-loop.74.3
                       vector-init-loop.74
                       tmp.72
                       0
                       tmp.73))))))
             (L.eq?.71.5
              (lambda (c.90 tmp.44 tmp.45) (let () (eq? tmp.44 tmp.45))))
             (L.cons.70.6
              (lambda (c.91 tmp.42 tmp.43) (let () (cons tmp.42 tmp.43))))
             (L.not.69.7 (lambda (c.92 tmp.41) (let () (not tmp.41))))
             (L.vector?.68.8 (lambda (c.93 tmp.40) (let () (vector? tmp.40))))
             (L.procedure?.67.9
              (lambda (c.94 tmp.39) (let () (procedure? tmp.39))))
             (L.pair?.66.10 (lambda (c.95 tmp.38) (let () (pair? tmp.38))))
             (L.error?.65.11 (lambda (c.96 tmp.37) (let () (error? tmp.37))))
             (L.ascii-char?.64.12
              (lambda (c.97 tmp.36) (let () (ascii-char? tmp.36))))
             (L.void?.63.13 (lambda (c.98 tmp.35) (let () (void? tmp.35))))
             (L.empty?.62.14 (lambda (c.99 tmp.34) (let () (empty? tmp.34))))
             (L.boolean?.61.15
              (lambda (c.100 tmp.33) (let () (boolean? tmp.33))))
             (L.fixnum?.60.16
              (lambda (c.101 tmp.32) (let () (fixnum? tmp.32))))
             (L.procedure-arity.59.17
              (lambda (c.102 tmp.31)
                (let ()
                  (if (procedure? tmp.31)
                    (unsafe-procedure-arity tmp.31)
                    (error 13)))))
             (L.cdr.58.18
              (lambda (c.103 tmp.30)
                (let () (if (pair? tmp.30) (unsafe-cdr tmp.30) (error 12)))))
             (L.car.57.19
              (lambda (c.104 tmp.29)
                (let () (if (pair? tmp.29) (unsafe-car tmp.29) (error 11)))))
             (L.vector-ref.56.20
              (lambda (c.105 tmp.27 tmp.28)
                (let ((unsafe-vector-ref.3 (closure-ref c.105 0)))
                  (if (fixnum? tmp.28)
                    (if (vector? tmp.27)
                      (let ((tmp.121 unsafe-vector-ref.3))
                        (unsafe-apply
                         L.unsafe-vector-ref.3.1
                         unsafe-vector-ref.3
                         tmp.27
                         tmp.28))
                      (error 10))
                    (error 10)))))
             (L.vector-set!.55.21
              (lambda (c.106 tmp.24 tmp.25 tmp.26)
                (let ((unsafe-vector-set!.2 (closure-ref c.106 0)))
                  (if (fixnum? tmp.25)
                    (if (vector? tmp.24)
                      (let ((tmp.122 unsafe-vector-set!.2))
                        (unsafe-apply
                         L.unsafe-vector-set!.2.2
                         unsafe-vector-set!.2
                         tmp.24
                         tmp.25
                         tmp.26))
                      (error 9))
                    (error 9)))))
             (L.vector-length.54.22
              (lambda (c.107 tmp.23)
                (let ()
                  (if (vector? tmp.23)
                    (unsafe-vector-length tmp.23)
                    (error 8)))))
             (L.make-vector.53.23
              (lambda (c.108 tmp.22)
                (let ((make-init-vector.1 (closure-ref c.108 0)))
                  (if (fixnum? tmp.22)
                    (let ((tmp.123 make-init-vector.1))
                      (unsafe-apply
                       L.make-init-vector.1.4
                       make-init-vector.1
                       tmp.22))
                    (error 7)))))
             (L.>=.52.24
              (lambda (c.109 tmp.20 tmp.21)
                (let ()
                  (if (fixnum? tmp.21)
                    (if (fixnum? tmp.20) (unsafe-fx>= tmp.20 tmp.21) (error 6))
                    (error 6)))))
             (L.>.51.25
              (lambda (c.110 tmp.18 tmp.19)
                (let ()
                  (if (fixnum? tmp.19)
                    (if (fixnum? tmp.18) (unsafe-fx> tmp.18 tmp.19) (error 5))
                    (error 5)))))
             (L.<=.50.26
              (lambda (c.111 tmp.16 tmp.17)
                (let ()
                  (if (fixnum? tmp.17)
                    (if (fixnum? tmp.16) (unsafe-fx<= tmp.16 tmp.17) (error 4))
                    (error 4)))))
             (L.<.49.27
              (lambda (c.112 tmp.14 tmp.15)
                (let ()
                  (if (fixnum? tmp.15)
                    (if (fixnum? tmp.14) (unsafe-fx< tmp.14 tmp.15) (error 3))
                    (error 3)))))
             (L.-.48.28
              (lambda (c.113 tmp.12 tmp.13)
                (let ()
                  (if (fixnum? tmp.13)
                    (if (fixnum? tmp.12) (unsafe-fx- tmp.12 tmp.13) (error 2))
                    (error 2)))))
             (L.+.47.29
              (lambda (c.114 tmp.10 tmp.11)
                (let ()
                  (if (fixnum? tmp.11)
                    (if (fixnum? tmp.10) (unsafe-fx+ tmp.10 tmp.11) (error 1))
                    (error 1)))))
             (L.*.46.30
              (lambda (c.115 tmp.8 tmp.9)
                (let ()
                  (if (fixnum? tmp.9)
                    (if (fixnum? tmp.8) (unsafe-fx* tmp.8 tmp.9) (error 0))
                    (error 0))))))
      (cletrec
       ((unsafe-vector-ref.3 (make-closure L.unsafe-vector-ref.3.1 2))
        (unsafe-vector-set!.2 (make-closure L.unsafe-vector-set!.2.2 3))
        (vector-init-loop.74
         (make-closure L.vector-init-loop.74.3 3 vector-init-loop.74))
        (make-init-vector.1
         (make-closure L.make-init-vector.1.4 1 vector-init-loop.74))
        (eq?.71 (make-closure L.eq?.71.5 2))
        (cons.70 (make-closure L.cons.70.6 2))
        (not.69 (make-closure L.not.69.7 1))
        (vector?.68 (make-closure L.vector?.68.8 1))
        (procedure?.67 (make-closure L.procedure?.67.9 1))
        (pair?.66 (make-closure L.pair?.66.10 1))
        (error?.65 (make-closure L.error?.65.11 1))
        (ascii-char?.64 (make-closure L.ascii-char?.64.12 1))
        (void?.63 (make-closure L.void?.63.13 1))
        (empty?.62 (make-closure L.empty?.62.14 1))
        (boolean?.61 (make-closure L.boolean?.61.15 1))
        (fixnum?.60 (make-closure L.fixnum?.60.16 1))
        (procedure-arity.59 (make-closure L.procedure-arity.59.17 1))
        (cdr.58 (make-closure L.cdr.58.18 1))
        (car.57 (make-closure L.car.57.19 1))
        (vector-ref.56 (make-closure L.vector-ref.56.20 2 unsafe-vector-ref.3))
        (vector-set!.55
         (make-closure L.vector-set!.55.21 3 unsafe-vector-set!.2))
        (vector-length.54 (make-closure L.vector-length.54.22 1))
        (make-vector.53
         (make-closure L.make-vector.53.23 1 make-init-vector.1))
        (>=.52 (make-closure L.>=.52.24 2))
        (>.51 (make-closure L.>.51.25 2))
        (<=.50 (make-closure L.<=.50.26 2))
        (<.49 (make-closure L.<.49.27 2))
        (|-.48| (make-closure L.-.48.28 2))
        (|+.47| (make-closure L.+.47.29 2))
        (*.46 (make-closure L.*.46.30 2)))
       (let ()
         (let ()
           (letrec ()
             (cletrec
              ()
              (let ()
                (let ()
                  (let ()
                    (letrec ((L.f.4.31
                              (lambda (c.116 x.5)
                                (let ((|+.47| (closure-ref c.116 0)))
                                  (letrec ((L.tmp.7.32
                                            (lambda (c.117 y.6)
                                              (let ((x.5 (closure-ref c.117 0))
                                                    (|+.47|
                                                     (closure-ref c.117 1)))
                                                (let ((tmp.124 |+.47|))
                                                  (unsafe-apply
                                                   L.+.47.29
                                                   |+.47|
                                                   x.5
                                                   y.6))))))
                                    (cletrec
                                     ((tmp.7
                                       (make-closure L.tmp.7.32 1 x.5 |+.47|)))
                                     tmp.7))))))
                      (cletrec
                       ((f.4 (make-closure L.f.4.31 1 |+.47|)))
                       (let ()
                         (let ((tmp.118
                                (let ((tmp.125 f.4))
                                  (unsafe-apply L.f.4.31 f.4 7))))
                           (closure-apply tmp.118 tmp.118 9)))))))))))))))
     ) 16)

  )
  (parameterize ([current-pass-list
                  (list
                   optimize-known-calls
                   hoist-lambdas
                   implement-closures
                   sequentialize-let
                   implement-safe-apply
                   specify-representation
                   a-normalize
                   select-instructions
                   expose-allocation-pointer
                   uncover-locals
                   undead-analysis
                   conflict-analysis
                   pre-assign-frame-variables
                   assign-frames
                   assign-registers
                   assign-frame-variables
                   discard-call-live
                   replace-locations
                   implement-fvars
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute '(module
    (letrec ((L.unsafe-vector-ref.3.1
              (lambda (c.86 tmp.80 tmp.81)
                (let ()
                  (if (unsafe-fx< tmp.81 (unsafe-vector-length tmp.80))
                    (if (unsafe-fx>= tmp.81 0)
                      (unsafe-vector-ref tmp.80 tmp.81)
                      (error 10))
                    (error 10)))))
             (L.unsafe-vector-set!.2.2
              (lambda (c.87 tmp.83 tmp.84 tmp.85)
                (let ()
                  (if (unsafe-fx< tmp.84 (unsafe-vector-length tmp.83))
                    (if (unsafe-fx>= tmp.84 0)
                      (begin (unsafe-vector-set! tmp.83 tmp.84 tmp.85) (void))
                      (error 9))
                    (error 9)))))
             (L.vector-init-loop.74.3
              (lambda (c.88 len.75 i.77 vec.76)
                (let ((vector-init-loop.74 (closure-ref c.88 0)))
                  (if (eq? len.75 i.77)
                    vec.76
                    (begin
                      (unsafe-vector-set! vec.76 i.77 0)
                      (closure-apply
                       vector-init-loop.74
                       vector-init-loop.74
                       len.75
                       (unsafe-fx+ i.77 1)
                       vec.76))))))
             (L.make-init-vector.1.4
              (lambda (c.89 tmp.72)
                (let ((vector-init-loop.74 (closure-ref c.89 0)))
                  (let ((tmp.73 (unsafe-make-vector tmp.72)))
                    (closure-apply
                     vector-init-loop.74
                     vector-init-loop.74
                     tmp.72
                     0
                     tmp.73)))))
             (L.eq?.71.5
              (lambda (c.90 tmp.44 tmp.45) (let () (eq? tmp.44 tmp.45))))
             (L.cons.70.6
              (lambda (c.91 tmp.42 tmp.43) (let () (cons tmp.42 tmp.43))))
             (L.not.69.7 (lambda (c.92 tmp.41) (let () (not tmp.41))))
             (L.vector?.68.8 (lambda (c.93 tmp.40) (let () (vector? tmp.40))))
             (L.procedure?.67.9
              (lambda (c.94 tmp.39) (let () (procedure? tmp.39))))
             (L.pair?.66.10 (lambda (c.95 tmp.38) (let () (pair? tmp.38))))
             (L.error?.65.11 (lambda (c.96 tmp.37) (let () (error? tmp.37))))
             (L.ascii-char?.64.12
              (lambda (c.97 tmp.36) (let () (ascii-char? tmp.36))))
             (L.void?.63.13 (lambda (c.98 tmp.35) (let () (void? tmp.35))))
             (L.empty?.62.14 (lambda (c.99 tmp.34) (let () (empty? tmp.34))))
             (L.boolean?.61.15
              (lambda (c.100 tmp.33) (let () (boolean? tmp.33))))
             (L.fixnum?.60.16
              (lambda (c.101 tmp.32) (let () (fixnum? tmp.32))))
             (L.procedure-arity.59.17
              (lambda (c.102 tmp.31)
                (let ()
                  (if (procedure? tmp.31)
                    (unsafe-procedure-arity tmp.31)
                    (error 13)))))
             (L.cdr.58.18
              (lambda (c.103 tmp.30)
                (let () (if (pair? tmp.30) (unsafe-cdr tmp.30) (error 12)))))
             (L.car.57.19
              (lambda (c.104 tmp.29)
                (let () (if (pair? tmp.29) (unsafe-car tmp.29) (error 11)))))
             (L.vector-ref.56.20
              (lambda (c.105 tmp.27 tmp.28)
                (let ((unsafe-vector-ref.3 (closure-ref c.105 0)))
                  (if (fixnum? tmp.28)
                    (if (vector? tmp.27)
                      (closure-apply
                       unsafe-vector-ref.3
                       unsafe-vector-ref.3
                       tmp.27
                       tmp.28)
                      (error 10))
                    (error 10)))))
             (L.vector-set!.55.21
              (lambda (c.106 tmp.24 tmp.25 tmp.26)
                (let ((unsafe-vector-set!.2 (closure-ref c.106 0)))
                  (if (fixnum? tmp.25)
                    (if (vector? tmp.24)
                      (closure-apply
                       unsafe-vector-set!.2
                       unsafe-vector-set!.2
                       tmp.24
                       tmp.25
                       tmp.26)
                      (error 9))
                    (error 9)))))
             (L.vector-length.54.22
              (lambda (c.107 tmp.23)
                (let ()
                  (if (vector? tmp.23)
                    (unsafe-vector-length tmp.23)
                    (error 8)))))
             (L.make-vector.53.23
              (lambda (c.108 tmp.22)
                (let ((make-init-vector.1 (closure-ref c.108 0)))
                  (if (fixnum? tmp.22)
                    (closure-apply
                     make-init-vector.1
                     make-init-vector.1
                     tmp.22)
                    (error 7)))))
             (L.>=.52.24
              (lambda (c.109 tmp.20 tmp.21)
                (let ()
                  (if (fixnum? tmp.21)
                    (if (fixnum? tmp.20) (unsafe-fx>= tmp.20 tmp.21) (error 6))
                    (error 6)))))
             (L.>.51.25
              (lambda (c.110 tmp.18 tmp.19)
                (let ()
                  (if (fixnum? tmp.19)
                    (if (fixnum? tmp.18) (unsafe-fx> tmp.18 tmp.19) (error 5))
                    (error 5)))))
             (L.<=.50.26
              (lambda (c.111 tmp.16 tmp.17)
                (let ()
                  (if (fixnum? tmp.17)
                    (if (fixnum? tmp.16) (unsafe-fx<= tmp.16 tmp.17) (error 4))
                    (error 4)))))
             (L.<.49.27
              (lambda (c.112 tmp.14 tmp.15)
                (let ()
                  (if (fixnum? tmp.15)
                    (if (fixnum? tmp.14) (unsafe-fx< tmp.14 tmp.15) (error 3))
                    (error 3)))))
             (L.-.48.28
              (lambda (c.113 tmp.12 tmp.13)
                (let ()
                  (if (fixnum? tmp.13)
                    (if (fixnum? tmp.12) (unsafe-fx- tmp.12 tmp.13) (error 2))
                    (error 2)))))
             (L.+.47.29
              (lambda (c.114 tmp.10 tmp.11)
                (let ()
                  (if (fixnum? tmp.11)
                    (if (fixnum? tmp.10) (unsafe-fx+ tmp.10 tmp.11) (error 1))
                    (error 1)))))
             (L.*.46.30
              (lambda (c.115 tmp.8 tmp.9)
                (let ()
                  (if (fixnum? tmp.9)
                    (if (fixnum? tmp.8) (unsafe-fx* tmp.8 tmp.9) (error 0))
                    (error 0))))))
      (cletrec
       ((unsafe-vector-ref.3 (make-closure L.unsafe-vector-ref.3.1 2))
        (unsafe-vector-set!.2 (make-closure L.unsafe-vector-set!.2.2 3))
        (vector-init-loop.74
         (make-closure L.vector-init-loop.74.3 3 vector-init-loop.74))
        (make-init-vector.1
         (make-closure L.make-init-vector.1.4 1 vector-init-loop.74))
        (eq?.71 (make-closure L.eq?.71.5 2))
        (cons.70 (make-closure L.cons.70.6 2))
        (not.69 (make-closure L.not.69.7 1))
        (vector?.68 (make-closure L.vector?.68.8 1))
        (procedure?.67 (make-closure L.procedure?.67.9 1))
        (pair?.66 (make-closure L.pair?.66.10 1))
        (error?.65 (make-closure L.error?.65.11 1))
        (ascii-char?.64 (make-closure L.ascii-char?.64.12 1))
        (void?.63 (make-closure L.void?.63.13 1))
        (empty?.62 (make-closure L.empty?.62.14 1))
        (boolean?.61 (make-closure L.boolean?.61.15 1))
        (fixnum?.60 (make-closure L.fixnum?.60.16 1))
        (procedure-arity.59 (make-closure L.procedure-arity.59.17 1))
        (cdr.58 (make-closure L.cdr.58.18 1))
        (car.57 (make-closure L.car.57.19 1))
        (vector-ref.56 (make-closure L.vector-ref.56.20 2 unsafe-vector-ref.3))
        (vector-set!.55
         (make-closure L.vector-set!.55.21 3 unsafe-vector-set!.2))
        (vector-length.54 (make-closure L.vector-length.54.22 1))
        (make-vector.53
         (make-closure L.make-vector.53.23 1 make-init-vector.1))
        (>=.52 (make-closure L.>=.52.24 2))
        (>.51 (make-closure L.>.51.25 2))
        (<=.50 (make-closure L.<=.50.26 2))
        (<.49 (make-closure L.<.49.27 2))
        (|-.48| (make-closure L.-.48.28 2))
        (|+.47| (make-closure L.+.47.29 2))
        (*.46 (make-closure L.*.46.30 2)))
       (let ()
         (let ()
           (letrec ()
             (cletrec
              ()
              (let ()
                (let ()
                  (let ()
                    (letrec ((L.f.4.31
                              (lambda (c.116 x.5)
                                (let ((|+.47| (closure-ref c.116 0)))
                                  (letrec ((L.tmp.7.32
                                            (lambda (c.117 y.6)
                                              (let ((x.5 (closure-ref c.117 0))
                                                    (|+.47|
                                                     (closure-ref c.117 1)))
                                                (closure-apply
                                                 |+.47|
                                                 |+.47|
                                                 x.5
                                                 y.6)))))
                                    (cletrec
                                     ((tmp.7
                                       (make-closure L.tmp.7.32 1 x.5 |+.47|)))
                                     tmp.7))))))
                      (cletrec
                       ((f.4 (make-closure L.f.4.31 1 |+.47|)))
                       (let ()
                         (let ((tmp.118 (closure-apply f.4 f.4 7)))
                           (closure-apply tmp.118 tmp.118 9)))))))))))))))
     ) 16)

  )

(parameterize ([current-pass-list
                  (list
                   convert-closures
                   optimize-known-calls
                   hoist-lambdas
                   implement-closures
                   sequentialize-let
                   implement-safe-apply
                   specify-representation
                   a-normalize
                   select-instructions
                   expose-allocation-pointer
                   uncover-locals
                   undead-analysis
                   conflict-analysis
                   pre-assign-frame-variables
                   assign-frames
                   assign-registers
                   assign-frame-variables
                   discard-call-live
                   replace-locations
                   implement-fvars
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute '(module
    (letrec ((unsafe-vector-ref.3
              (lambda (tmp.80 tmp.81)
                (free ())
                (if (unsafe-fx< tmp.81 (unsafe-vector-length tmp.80))
                  (if (unsafe-fx>= tmp.81 0)
                    (unsafe-vector-ref tmp.80 tmp.81)
                    (error 10))
                  (error 10))))
             (unsafe-vector-set!.2
              (lambda (tmp.83 tmp.84 tmp.85)
                (free ())
                (if (unsafe-fx< tmp.84 (unsafe-vector-length tmp.83))
                  (if (unsafe-fx>= tmp.84 0)
                    (begin (unsafe-vector-set! tmp.83 tmp.84 tmp.85) (void))
                    (error 9))
                  (error 9))))
             (vector-init-loop.74
              (lambda (len.75 i.77 vec.76)
                (free (vector-init-loop.74))
                (if (eq? len.75 i.77)
                  vec.76
                  (begin
                    (unsafe-vector-set! vec.76 i.77 0)
                    (apply
                     vector-init-loop.74
                     len.75
                     (unsafe-fx+ i.77 1)
                     vec.76)))))
             (make-init-vector.1
              (lambda (tmp.72)
                (free (vector-init-loop.74))
                (let ((tmp.73 (unsafe-make-vector tmp.72)))
                  (apply vector-init-loop.74 tmp.72 0 tmp.73))))
             (eq?.71 (lambda (tmp.44 tmp.45) (free ()) (eq? tmp.44 tmp.45)))
             (cons.70 (lambda (tmp.42 tmp.43) (free ()) (cons tmp.42 tmp.43)))
             (not.69 (lambda (tmp.41) (free ()) (not tmp.41)))
             (vector?.68 (lambda (tmp.40) (free ()) (vector? tmp.40)))
             (procedure?.67 (lambda (tmp.39) (free ()) (procedure? tmp.39)))
             (pair?.66 (lambda (tmp.38) (free ()) (pair? tmp.38)))
             (error?.65 (lambda (tmp.37) (free ()) (error? tmp.37)))
             (ascii-char?.64 (lambda (tmp.36) (free ()) (ascii-char? tmp.36)))
             (void?.63 (lambda (tmp.35) (free ()) (void? tmp.35)))
             (empty?.62 (lambda (tmp.34) (free ()) (empty? tmp.34)))
             (boolean?.61 (lambda (tmp.33) (free ()) (boolean? tmp.33)))
             (fixnum?.60 (lambda (tmp.32) (free ()) (fixnum? tmp.32)))
             (procedure-arity.59
              (lambda (tmp.31)
                (free ())
                (if (procedure? tmp.31)
                  (unsafe-procedure-arity tmp.31)
                  (error 13))))
             (cdr.58
              (lambda (tmp.30)
                (free ())
                (if (pair? tmp.30) (unsafe-cdr tmp.30) (error 12))))
             (car.57
              (lambda (tmp.29)
                (free ())
                (if (pair? tmp.29) (unsafe-car tmp.29) (error 11))))
             (vector-ref.56
              (lambda (tmp.27 tmp.28)
                (free (unsafe-vector-ref.3))
                (if (fixnum? tmp.28)
                  (if (vector? tmp.27)
                    (apply unsafe-vector-ref.3 tmp.27 tmp.28)
                    (error 10))
                  (error 10))))
             (vector-set!.55
              (lambda (tmp.24 tmp.25 tmp.26)
                (free (unsafe-vector-set!.2))
                (if (fixnum? tmp.25)
                  (if (vector? tmp.24)
                    (apply unsafe-vector-set!.2 tmp.24 tmp.25 tmp.26)
                    (error 9))
                  (error 9))))
             (vector-length.54
              (lambda (tmp.23)
                (free ())
                (if (vector? tmp.23) (unsafe-vector-length tmp.23) (error 8))))
             (make-vector.53
              (lambda (tmp.22)
                (free (make-init-vector.1))
                (if (fixnum? tmp.22)
                  (apply make-init-vector.1 tmp.22)
                  (error 7))))
             (>=.52
              (lambda (tmp.20 tmp.21)
                (free ())
                (if (fixnum? tmp.21)
                  (if (fixnum? tmp.20) (unsafe-fx>= tmp.20 tmp.21) (error 6))
                  (error 6))))
             (>.51
              (lambda (tmp.18 tmp.19)
                (free ())
                (if (fixnum? tmp.19)
                  (if (fixnum? tmp.18) (unsafe-fx> tmp.18 tmp.19) (error 5))
                  (error 5))))
             (<=.50
              (lambda (tmp.16 tmp.17)
                (free ())
                (if (fixnum? tmp.17)
                  (if (fixnum? tmp.16) (unsafe-fx<= tmp.16 tmp.17) (error 4))
                  (error 4))))
             (<.49
              (lambda (tmp.14 tmp.15)
                (free ())
                (if (fixnum? tmp.15)
                  (if (fixnum? tmp.14) (unsafe-fx< tmp.14 tmp.15) (error 3))
                  (error 3))))
             (|-.48|
              (lambda (tmp.12 tmp.13)
                (free ())
                (if (fixnum? tmp.13)
                  (if (fixnum? tmp.12) (unsafe-fx- tmp.12 tmp.13) (error 2))
                  (error 2))))
             (|+.47|
              (lambda (tmp.10 tmp.11)
                (free ())
                (if (fixnum? tmp.11)
                  (if (fixnum? tmp.10) (unsafe-fx+ tmp.10 tmp.11) (error 1))
                  (error 1))))
             (*.46
              (lambda (tmp.8 tmp.9)
                (free ())
                (if (fixnum? tmp.9)
                  (if (fixnum? tmp.8) (unsafe-fx* tmp.8 tmp.9) (error 0))
                  (error 0)))))
      (let ()
        (let ()
          (letrec ()
            (let ()
              (let ()
                (let ()
                  (letrec ((f.4
                            (lambda (x.5)
                              (free (|+.47|))
                              (letrec ((tmp.7
                                        (lambda (y.6)
                                          (free (x.5 |+.47|))
                                          (apply |+.47| x.5 y.6))))
                                tmp.7))))
                    (let () (apply (apply f.4 7) 9)))))))))))
     ) 16))

(parameterize ([current-pass-list
                  (list
                   uncover-free
                   convert-closures
                   optimize-known-calls
                   hoist-lambdas
                   implement-closures
                   sequentialize-let
                   implement-safe-apply
                   specify-representation
                   a-normalize
                   select-instructions
                   expose-allocation-pointer
                   uncover-locals
                   undead-analysis
                   conflict-analysis
                   pre-assign-frame-variables
                   assign-frames
                   assign-registers
                   assign-frame-variables
                   discard-call-live
                   replace-locations
                   implement-fvars
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute '(module
    (letrec ((unsafe-vector-ref.3
              (lambda (tmp.80 tmp.81)
                (if (unsafe-fx< tmp.81 (unsafe-vector-length tmp.80))
                  (if (unsafe-fx>= tmp.81 0)
                    (unsafe-vector-ref tmp.80 tmp.81)
                    (error 10))
                  (error 10))))
             (unsafe-vector-set!.2
              (lambda (tmp.83 tmp.84 tmp.85)
                (if (unsafe-fx< tmp.84 (unsafe-vector-length tmp.83))
                  (if (unsafe-fx>= tmp.84 0)
                    (begin (unsafe-vector-set! tmp.83 tmp.84 tmp.85) (void))
                    (error 9))
                  (error 9))))
             (vector-init-loop.74
              (lambda (len.75 i.77 vec.76)
                (if (eq? len.75 i.77)
                  vec.76
                  (begin
                    (unsafe-vector-set! vec.76 i.77 0)
                    (apply
                     vector-init-loop.74
                     len.75
                     (unsafe-fx+ i.77 1)
                     vec.76)))))
             (make-init-vector.1
              (lambda (tmp.72)
                (let ((tmp.73 (unsafe-make-vector tmp.72)))
                  (apply vector-init-loop.74 tmp.72 0 tmp.73))))
             (eq?.71 (lambda (tmp.44 tmp.45) (eq? tmp.44 tmp.45)))
             (cons.70 (lambda (tmp.42 tmp.43) (cons tmp.42 tmp.43)))
             (not.69 (lambda (tmp.41) (not tmp.41)))
             (vector?.68 (lambda (tmp.40) (vector? tmp.40)))
             (procedure?.67 (lambda (tmp.39) (procedure? tmp.39)))
             (pair?.66 (lambda (tmp.38) (pair? tmp.38)))
             (error?.65 (lambda (tmp.37) (error? tmp.37)))
             (ascii-char?.64 (lambda (tmp.36) (ascii-char? tmp.36)))
             (void?.63 (lambda (tmp.35) (void? tmp.35)))
             (empty?.62 (lambda (tmp.34) (empty? tmp.34)))
             (boolean?.61 (lambda (tmp.33) (boolean? tmp.33)))
             (fixnum?.60 (lambda (tmp.32) (fixnum? tmp.32)))
             (procedure-arity.59
              (lambda (tmp.31)
                (if (procedure? tmp.31)
                  (unsafe-procedure-arity tmp.31)
                  (error 13))))
             (cdr.58
              (lambda (tmp.30)
                (if (pair? tmp.30) (unsafe-cdr tmp.30) (error 12))))
             (car.57
              (lambda (tmp.29)
                (if (pair? tmp.29) (unsafe-car tmp.29) (error 11))))
             (vector-ref.56
              (lambda (tmp.27 tmp.28)
                (if (fixnum? tmp.28)
                  (if (vector? tmp.27)
                    (apply unsafe-vector-ref.3 tmp.27 tmp.28)
                    (error 10))
                  (error 10))))
             (vector-set!.55
              (lambda (tmp.24 tmp.25 tmp.26)
                (if (fixnum? tmp.25)
                  (if (vector? tmp.24)
                    (apply unsafe-vector-set!.2 tmp.24 tmp.25 tmp.26)
                    (error 9))
                  (error 9))))
             (vector-length.54
              (lambda (tmp.23)
                (if (vector? tmp.23) (unsafe-vector-length tmp.23) (error 8))))
             (make-vector.53
              (lambda (tmp.22)
                (if (fixnum? tmp.22)
                  (apply make-init-vector.1 tmp.22)
                  (error 7))))
             (>=.52
              (lambda (tmp.20 tmp.21)
                (if (fixnum? tmp.21)
                  (if (fixnum? tmp.20) (unsafe-fx>= tmp.20 tmp.21) (error 6))
                  (error 6))))
             (>.51
              (lambda (tmp.18 tmp.19)
                (if (fixnum? tmp.19)
                  (if (fixnum? tmp.18) (unsafe-fx> tmp.18 tmp.19) (error 5))
                  (error 5))))
             (<=.50
              (lambda (tmp.16 tmp.17)
                (if (fixnum? tmp.17)
                  (if (fixnum? tmp.16) (unsafe-fx<= tmp.16 tmp.17) (error 4))
                  (error 4))))
             (<.49
              (lambda (tmp.14 tmp.15)
                (if (fixnum? tmp.15)
                  (if (fixnum? tmp.14) (unsafe-fx< tmp.14 tmp.15) (error 3))
                  (error 3))))
             (|-.48|
              (lambda (tmp.12 tmp.13)
                (if (fixnum? tmp.13)
                  (if (fixnum? tmp.12) (unsafe-fx- tmp.12 tmp.13) (error 2))
                  (error 2))))
             (|+.47|
              (lambda (tmp.10 tmp.11)
                (if (fixnum? tmp.11)
                  (if (fixnum? tmp.10) (unsafe-fx+ tmp.10 tmp.11) (error 1))
                  (error 1))))
             (*.46
              (lambda (tmp.8 tmp.9)
                (if (fixnum? tmp.9)
                  (if (fixnum? tmp.8) (unsafe-fx* tmp.8 tmp.9) (error 0))
                  (error 0)))))
      (let ()
        (let ()
          (letrec ()
            (let ()
              (let ()
                (let ()
                  (letrec ((f.4
                            (lambda (x.5)
                              (letrec ((tmp.7
                                        (lambda (y.6) (apply |+.47| x.5 y.6))))
                                tmp.7))))
                    (let () (apply (apply f.4 7) 9)))))))))))
     ) 16))


  (parameterize ([current-pass-list
                  (list
                   implement-safe-primops
                   uncover-free
                   convert-closures
                   optimize-known-calls
                   hoist-lambdas
                   implement-closures
                   sequentialize-let
                   implement-safe-apply
                   specify-representation
                   a-normalize
                   select-instructions
                   expose-allocation-pointer
                   uncover-locals
                   undead-analysis
                   conflict-analysis
                   pre-assign-frame-variables
                   assign-frames
                   assign-registers
                   assign-frame-variables
                   discard-call-live
                   replace-locations
                   implement-fvars
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute '(module
    (let ()
      (let ()
        (letrec ()
          (let ()
            (let ()
              (let ()
                (letrec ((f.4
                          (lambda (x.5)
                            (letrec ((tmp.7 (lambda (y.6) (apply + x.5 y.6))))
                              tmp.7))))
                  (let () (apply (apply f.4 7) 9))))))))))
     ) 16)

  )

  (parameterize ([current-pass-list
                  (list
                   uniquify
                   expand-macros
                   define->letrec
                   purify-letrec
                   convert-assigned
                   dox-lambdas
                   implement-safe-primops
                   uncover-free
                   convert-closures
                   optimize-known-calls
                   hoist-lambdas
                   implement-closures
                   sequentialize-let
                   implement-safe-apply
                   specify-representation
                   a-normalize
                   select-instructions
                   expose-allocation-pointer
                   uncover-locals
                   undead-analysis
                   conflict-analysis
                   pre-assign-frame-variables
                   assign-frames
                   assign-registers
                   assign-frame-variables
                   discard-call-live
                   replace-locations
                   implement-fvars
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute '(module (letrec ((f (lambda (x) (lambda (y) (+ x y))))) ((f 7) 9)))
     ) 16)

  )
  
  )