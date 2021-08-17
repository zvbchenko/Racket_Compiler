#lang racket
(require
  "a10.rkt"
  "a10-implement-safe-primops.rkt"
  "a10-compiler-lib.rkt"
  "a10-graph-lib.rkt")
(module+ test
  (require rackunit))

(module+ test

#;(parameterize ([current-pass-list
                  (list
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
     (execute '(module
    (let ()
      (let ()
        (letrec ()
          (let ()
            (let ((x.4 #t))
              (let ((t.5 (apply make-vector 1)))
                (letrec ()
                  (let ((t.5.7
                         (if (let ((tmp.6 #t)) (if tmp.6 tmp.6 #f)) x.4 #f)))
                    (let ((tmp.8 (apply vector-set! t.5 0 t.5.7)))
                      (apply not (apply vector-ref t.5 0))))))))))))
     ) #f))


#;(parameterize ([current-pass-list
                  (list
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
     (execute '(module
    (let ()
      (let ()
        (letrec ()
          (let ()
            (let ((x.4 #t))
              (let ((t.5 (apply make-vector 1)))
                (letrec ()
                  (let ((t.5.7
                         (if (let ((tmp.6 #t)) (if tmp.6 tmp.6 #f)) x.4 #f)))
                    (let ((tmp.8 (apply vector-set! t.5 0 t.5.7)))
                      (apply not (apply vector-ref t.5 0))))))))))))
     ) #f))

#;(parameterize ([current-pass-list
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
            (let ((x.4 #t))
              (let ((t.5 (apply make-vector 1)))
                (letrec ()
                  (let ((t.5.7
                         (if (let ((tmp.6 #t)) (if tmp.6 tmp.6 #f)) x.4 #f)))
                    (let ((tmp.8 (apply vector-set! t.5 0 t.5.7)))
                      (apply not (apply vector-ref t.5 0))))))))))))
     ) #f))

#;(parameterize ([current-pass-list
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
              (lambda (tmp.79 tmp.80)
                (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
                  (if (unsafe-fx>= tmp.80 0)
                    (unsafe-vector-ref tmp.79 tmp.80)
                    (error 10))
                  (error 10))))
             (unsafe-vector-set!.2
              (lambda (tmp.79 tmp.80 tmp.81)
                (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
                  (if (unsafe-fx>= tmp.80 0)
                    (begin (unsafe-vector-set! tmp.79 tmp.80 tmp.81) tmp.79)
                    (error 9))
                  (error 9))))
             (vector-init-loop.75
              (lambda (len.76 i.78 vec.77)
                (if (eq? len.76 i.78)
                  vec.77
                  (begin
                    (unsafe-vector-set! vec.77 i.78 0)
                    (apply
                     vector-init-loop.75
                     len.76
                     (unsafe-fx+ i.78 1)
                     vec.77)))))
             (make-init-vector.1
              (lambda (tmp.73)
                (let ((tmp.74 (unsafe-make-vector tmp.73)))
                  (apply vector-init-loop.75 tmp.73 0 tmp.74))))
             (eq?.72 (lambda (tmp.45 tmp.46) (eq? tmp.45 tmp.46)))
             (cons.71 (lambda (tmp.43 tmp.44) (cons tmp.43 tmp.44)))
             (not.70 (lambda (tmp.42) (not tmp.42)))
             (vector?.69 (lambda (tmp.41) (vector? tmp.41)))
             (procedure?.68 (lambda (tmp.40) (procedure? tmp.40)))
             (pair?.67 (lambda (tmp.39) (pair? tmp.39)))
             (error?.66 (lambda (tmp.38) (error? tmp.38)))
             (ascii-char?.65 (lambda (tmp.37) (ascii-char? tmp.37)))
             (void?.64 (lambda (tmp.36) (void? tmp.36)))
             (empty?.63 (lambda (tmp.35) (empty? tmp.35)))
             (boolean?.62 (lambda (tmp.34) (boolean? tmp.34)))
             (fixnum?.61 (lambda (tmp.33) (fixnum? tmp.33)))
             (procedure-arity.60
              (lambda (tmp.32)
                (if (procedure? tmp.32)
                  (unsafe-procedure-arity tmp.32)
                  (error 13))))
             (cdr.59
              (lambda (tmp.31)
                (if (pair? tmp.31) (unsafe-cdr tmp.31) (error 12))))
             (car.58
              (lambda (tmp.30)
                (if (pair? tmp.30) (unsafe-car tmp.30) (error 11))))
             (vector-ref.57
              (lambda (tmp.28 tmp.29)
                (if (fixnum? tmp.29)
                  (if (vector? tmp.28)
                    (apply unsafe-vector-ref.3 tmp.28 tmp.29)
                    (error 10))
                  (error 10))))
             (vector-set!.56
              (lambda (tmp.25 tmp.26 tmp.27)
                (if (fixnum? tmp.26)
                  (if (vector? tmp.25)
                    (apply unsafe-vector-set!.2 tmp.25 tmp.26 tmp.27)
                    (error 9))
                  (error 9))))
             (vector-length.55
              (lambda (tmp.24)
                (if (vector? tmp.24) (unsafe-vector-length tmp.24) (error 8))))
             (make-vector.54
              (lambda (tmp.23)
                (if (fixnum? tmp.23)
                  (apply make-init-vector.1 tmp.23)
                  (error 7))))
             (>=.53
              (lambda (tmp.21 tmp.22)
                (if (fixnum? tmp.22)
                  (if (fixnum? tmp.21) (unsafe-fx>= tmp.21 tmp.22) (error 6))
                  (error 6))))
             (>.52
              (lambda (tmp.19 tmp.20)
                (if (fixnum? tmp.20)
                  (if (fixnum? tmp.19) (unsafe-fx> tmp.19 tmp.20) (error 5))
                  (error 5))))
             (<=.51
              (lambda (tmp.17 tmp.18)
                (if (fixnum? tmp.18)
                  (if (fixnum? tmp.17) (unsafe-fx<= tmp.17 tmp.18) (error 4))
                  (error 4))))
             (<.50
              (lambda (tmp.15 tmp.16)
                (if (fixnum? tmp.16)
                  (if (fixnum? tmp.15) (unsafe-fx< tmp.15 tmp.16) (error 3))
                  (error 3))))
             (|-.49|
              (lambda (tmp.13 tmp.14)
                (if (fixnum? tmp.14)
                  (if (fixnum? tmp.13) (unsafe-fx- tmp.13 tmp.14) (error 2))
                  (error 2))))
             (|+.48|
              (lambda (tmp.11 tmp.12)
                (if (fixnum? tmp.12)
                  (if (fixnum? tmp.11) (unsafe-fx+ tmp.11 tmp.12) (error 1))
                  (error 1))))
             (*.47
              (lambda (tmp.9 tmp.10)
                (if (fixnum? tmp.10)
                  (if (fixnum? tmp.9) (unsafe-fx* tmp.9 tmp.10) (error 0))
                  (error 0)))))
      (let ()
        (let ()
          (letrec ()
            (let ()
              (let ((x.4 #t))
                (let ((t.5 (apply make-vector.54 1)))
                  (letrec ()
                    (let ((t.5.7
                           (if (let ((tmp.6 #t)) (if tmp.6 tmp.6 #f)) x.4 #f)))
                      (let ((tmp.8 (apply vector-set!.56 t.5 0 t.5.7)))
                        (apply not.70 (apply vector-ref.57 t.5 0)))))))))))))
     ) #f))


#;(parameterize ([current-pass-list
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
              (lambda (tmp.79 tmp.80)
                (free ())
                (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
                  (if (unsafe-fx>= tmp.80 0)
                    (unsafe-vector-ref tmp.79 tmp.80)
                    (error 10))
                  (error 10))))
             (unsafe-vector-set!.2
              (lambda (tmp.79 tmp.80 tmp.81)
                (free ())
                (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
                  (if (unsafe-fx>= tmp.80 0)
                    (begin (unsafe-vector-set! tmp.79 tmp.80 tmp.81) tmp.79)
                    (error 9))
                  (error 9))))
             (vector-init-loop.75
              (lambda (len.76 i.78 vec.77)
                (free (vector-init-loop.75))
                (if (eq? len.76 i.78)
                  vec.77
                  (begin
                    (unsafe-vector-set! vec.77 i.78 0)
                    (apply
                     vector-init-loop.75
                     len.76
                     (unsafe-fx+ i.78 1)
                     vec.77)))))
             (make-init-vector.1
              (lambda (tmp.73)
                (free (vector-init-loop.75))
                (let ((tmp.74 (unsafe-make-vector tmp.73)))
                  (apply vector-init-loop.75 tmp.73 0 tmp.74))))
             (eq?.72 (lambda (tmp.45 tmp.46) (free ()) (eq? tmp.45 tmp.46)))
             (cons.71 (lambda (tmp.43 tmp.44) (free ()) (cons tmp.43 tmp.44)))
             (not.70 (lambda (tmp.42) (free ()) (not tmp.42)))
             (vector?.69 (lambda (tmp.41) (free ()) (vector? tmp.41)))
             (procedure?.68 (lambda (tmp.40) (free ()) (procedure? tmp.40)))
             (pair?.67 (lambda (tmp.39) (free ()) (pair? tmp.39)))
             (error?.66 (lambda (tmp.38) (free ()) (error? tmp.38)))
             (ascii-char?.65 (lambda (tmp.37) (free ()) (ascii-char? tmp.37)))
             (void?.64 (lambda (tmp.36) (free ()) (void? tmp.36)))
             (empty?.63 (lambda (tmp.35) (free ()) (empty? tmp.35)))
             (boolean?.62 (lambda (tmp.34) (free ()) (boolean? tmp.34)))
             (fixnum?.61 (lambda (tmp.33) (free ()) (fixnum? tmp.33)))
             (procedure-arity.60
              (lambda (tmp.32)
                (free ())
                (if (procedure? tmp.32)
                  (unsafe-procedure-arity tmp.32)
                  (error 13))))
             (cdr.59
              (lambda (tmp.31)
                (free ())
                (if (pair? tmp.31) (unsafe-cdr tmp.31) (error 12))))
             (car.58
              (lambda (tmp.30)
                (free ())
                (if (pair? tmp.30) (unsafe-car tmp.30) (error 11))))
             (vector-ref.57
              (lambda (tmp.28 tmp.29)
                (free (unsafe-vector-ref.3))
                (if (fixnum? tmp.29)
                  (if (vector? tmp.28)
                    (apply unsafe-vector-ref.3 tmp.28 tmp.29)
                    (error 10))
                  (error 10))))
             (vector-set!.56
              (lambda (tmp.25 tmp.26 tmp.27)
                (free (unsafe-vector-set!.2))
                (if (fixnum? tmp.26)
                  (if (vector? tmp.25)
                    (apply unsafe-vector-set!.2 tmp.25 tmp.26 tmp.27)
                    (error 9))
                  (error 9))))
             (vector-length.55
              (lambda (tmp.24)
                (free ())
                (if (vector? tmp.24) (unsafe-vector-length tmp.24) (error 8))))
             (make-vector.54
              (lambda (tmp.23)
                (free (make-init-vector.1))
                (if (fixnum? tmp.23)
                  (apply make-init-vector.1 tmp.23)
                  (error 7))))
             (>=.53
              (lambda (tmp.21 tmp.22)
                (free ())
                (if (fixnum? tmp.22)
                  (if (fixnum? tmp.21) (unsafe-fx>= tmp.21 tmp.22) (error 6))
                  (error 6))))
             (>.52
              (lambda (tmp.19 tmp.20)
                (free ())
                (if (fixnum? tmp.20)
                  (if (fixnum? tmp.19) (unsafe-fx> tmp.19 tmp.20) (error 5))
                  (error 5))))
             (<=.51
              (lambda (tmp.17 tmp.18)
                (free ())
                (if (fixnum? tmp.18)
                  (if (fixnum? tmp.17) (unsafe-fx<= tmp.17 tmp.18) (error 4))
                  (error 4))))
             (<.50
              (lambda (tmp.15 tmp.16)
                (free ())
                (if (fixnum? tmp.16)
                  (if (fixnum? tmp.15) (unsafe-fx< tmp.15 tmp.16) (error 3))
                  (error 3))))
             (|-.49|
              (lambda (tmp.13 tmp.14)
                (free ())
                (if (fixnum? tmp.14)
                  (if (fixnum? tmp.13) (unsafe-fx- tmp.13 tmp.14) (error 2))
                  (error 2))))
             (|+.48|
              (lambda (tmp.11 tmp.12)
                (free ())
                (if (fixnum? tmp.12)
                  (if (fixnum? tmp.11) (unsafe-fx+ tmp.11 tmp.12) (error 1))
                  (error 1))))
             (*.47
              (lambda (tmp.9 tmp.10)
                (free ())
                (if (fixnum? tmp.10)
                  (if (fixnum? tmp.9) (unsafe-fx* tmp.9 tmp.10) (error 0))
                  (error 0)))))
      (let ()
        (let ()
          (letrec ()
            (let ()
              (let ((x.4 #t))
                (let ((t.5 (apply make-vector.54 1)))
                  (letrec ()
                    (let ((t.5.7
                           (if (let ((tmp.6 #t)) (if tmp.6 tmp.6 #f)) x.4 #f)))
                      (let ((tmp.8 (apply vector-set!.56 t.5 0 t.5.7)))
                        (apply not.70 (apply vector-ref.57 t.5 0))))))))))))))
      #f))

#;(parameterize ([current-pass-list
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
              (lambda (c.84 tmp.79 tmp.80)
                (let ()
                  (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
                    (if (unsafe-fx>= tmp.80 0)
                      (unsafe-vector-ref tmp.79 tmp.80)
                      (error 10))
                    (error 10)))))
             (L.unsafe-vector-set!.2.2
              (lambda (c.85 tmp.79 tmp.80 tmp.81)
                (let ()
                  (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
                    (if (unsafe-fx>= tmp.80 0)
                      (begin (unsafe-vector-set! tmp.79 tmp.80 tmp.81) tmp.79)
                      (error 9))
                    (error 9)))))
             (L.vector-init-loop.75.3
              (lambda (c.86 len.76 i.78 vec.77)
                (let ((vector-init-loop.75 (closure-ref c.86 0)))
                  (if (eq? len.76 i.78)
                    vec.77
                    (begin
                      (unsafe-vector-set! vec.77 i.78 0)
                      (closure-apply
                       vector-init-loop.75
                       vector-init-loop.75
                       len.76
                       (unsafe-fx+ i.78 1)
                       vec.77))))))
             (L.make-init-vector.1.4
              (lambda (c.87 tmp.73)
                (let ((vector-init-loop.75 (closure-ref c.87 0)))
                  (let ((tmp.74 (unsafe-make-vector tmp.73)))
                    (closure-apply
                     vector-init-loop.75
                     vector-init-loop.75
                     tmp.73
                     0
                     tmp.74)))))
             (L.eq?.72.5
              (lambda (c.88 tmp.45 tmp.46) (let () (eq? tmp.45 tmp.46))))
             (L.cons.71.6
              (lambda (c.89 tmp.43 tmp.44) (let () (cons tmp.43 tmp.44))))
             (L.not.70.7 (lambda (c.90 tmp.42) (let () (not tmp.42))))
             (L.vector?.69.8 (lambda (c.91 tmp.41) (let () (vector? tmp.41))))
             (L.procedure?.68.9
              (lambda (c.92 tmp.40) (let () (procedure? tmp.40))))
             (L.pair?.67.10 (lambda (c.93 tmp.39) (let () (pair? tmp.39))))
             (L.error?.66.11 (lambda (c.94 tmp.38) (let () (error? tmp.38))))
             (L.ascii-char?.65.12
              (lambda (c.95 tmp.37) (let () (ascii-char? tmp.37))))
             (L.void?.64.13 (lambda (c.96 tmp.36) (let () (void? tmp.36))))
             (L.empty?.63.14 (lambda (c.97 tmp.35) (let () (empty? tmp.35))))
             (L.boolean?.62.15
              (lambda (c.98 tmp.34) (let () (boolean? tmp.34))))
             (L.fixnum?.61.16 (lambda (c.99 tmp.33) (let () (fixnum? tmp.33))))
             (L.procedure-arity.60.17
              (lambda (c.100 tmp.32)
                (let ()
                  (if (procedure? tmp.32)
                    (unsafe-procedure-arity tmp.32)
                    (error 13)))))
             (L.cdr.59.18
              (lambda (c.101 tmp.31)
                (let () (if (pair? tmp.31) (unsafe-cdr tmp.31) (error 12)))))
             (L.car.58.19
              (lambda (c.102 tmp.30)
                (let () (if (pair? tmp.30) (unsafe-car tmp.30) (error 11)))))
             (L.vector-ref.57.20
              (lambda (c.103 tmp.28 tmp.29)
                (let ((unsafe-vector-ref.3 (closure-ref c.103 0)))
                  (if (fixnum? tmp.29)
                    (if (vector? tmp.28)
                      (closure-apply
                       unsafe-vector-ref.3
                       unsafe-vector-ref.3
                       tmp.28
                       tmp.29)
                      (error 10))
                    (error 10)))))
             (L.vector-set!.56.21
              (lambda (c.104 tmp.25 tmp.26 tmp.27)
                (let ((unsafe-vector-set!.2 (closure-ref c.104 0)))
                  (if (fixnum? tmp.26)
                    (if (vector? tmp.25)
                      (closure-apply
                       unsafe-vector-set!.2
                       unsafe-vector-set!.2
                       tmp.25
                       tmp.26
                       tmp.27)
                      (error 9))
                    (error 9)))))
             (L.vector-length.55.22
              (lambda (c.105 tmp.24)
                (let ()
                  (if (vector? tmp.24)
                    (unsafe-vector-length tmp.24)
                    (error 8)))))
             (L.make-vector.54.23
              (lambda (c.106 tmp.23)
                (let ((make-init-vector.1 (closure-ref c.106 0)))
                  (if (fixnum? tmp.23)
                    (closure-apply
                     make-init-vector.1
                     make-init-vector.1
                     tmp.23)
                    (error 7)))))
             (L.>=.53.24
              (lambda (c.107 tmp.21 tmp.22)
                (let ()
                  (if (fixnum? tmp.22)
                    (if (fixnum? tmp.21) (unsafe-fx>= tmp.21 tmp.22) (error 6))
                    (error 6)))))
             (L.>.52.25
              (lambda (c.108 tmp.19 tmp.20)
                (let ()
                  (if (fixnum? tmp.20)
                    (if (fixnum? tmp.19) (unsafe-fx> tmp.19 tmp.20) (error 5))
                    (error 5)))))
             (L.<=.51.26
              (lambda (c.109 tmp.17 tmp.18)
                (let ()
                  (if (fixnum? tmp.18)
                    (if (fixnum? tmp.17) (unsafe-fx<= tmp.17 tmp.18) (error 4))
                    (error 4)))))
             (L.<.50.27
              (lambda (c.110 tmp.15 tmp.16)
                (let ()
                  (if (fixnum? tmp.16)
                    (if (fixnum? tmp.15) (unsafe-fx< tmp.15 tmp.16) (error 3))
                    (error 3)))))
             (L.-.49.28
              (lambda (c.111 tmp.13 tmp.14)
                (let ()
                  (if (fixnum? tmp.14)
                    (if (fixnum? tmp.13) (unsafe-fx- tmp.13 tmp.14) (error 2))
                    (error 2)))))
             (L.+.48.29
              (lambda (c.112 tmp.11 tmp.12)
                (let ()
                  (if (fixnum? tmp.12)
                    (if (fixnum? tmp.11) (unsafe-fx+ tmp.11 tmp.12) (error 1))
                    (error 1)))))
             (L.*.47.30
              (lambda (c.113 tmp.9 tmp.10)
                (let ()
                  (if (fixnum? tmp.10)
                    (if (fixnum? tmp.9) (unsafe-fx* tmp.9 tmp.10) (error 0))
                    (error 0))))))
      (cletrec
       ((unsafe-vector-ref.3 (make-closure L.unsafe-vector-ref.3.1 2))
        (unsafe-vector-set!.2 (make-closure L.unsafe-vector-set!.2.2 3))
        (vector-init-loop.75
         (make-closure L.vector-init-loop.75.3 3 vector-init-loop.75))
        (make-init-vector.1
         (make-closure L.make-init-vector.1.4 1 vector-init-loop.75))
        (eq?.72 (make-closure L.eq?.72.5 2))
        (cons.71 (make-closure L.cons.71.6 2))
        (not.70 (make-closure L.not.70.7 1))
        (vector?.69 (make-closure L.vector?.69.8 1))
        (procedure?.68 (make-closure L.procedure?.68.9 1))
        (pair?.67 (make-closure L.pair?.67.10 1))
        (error?.66 (make-closure L.error?.66.11 1))
        (ascii-char?.65 (make-closure L.ascii-char?.65.12 1))
        (void?.64 (make-closure L.void?.64.13 1))
        (empty?.63 (make-closure L.empty?.63.14 1))
        (boolean?.62 (make-closure L.boolean?.62.15 1))
        (fixnum?.61 (make-closure L.fixnum?.61.16 1))
        (procedure-arity.60 (make-closure L.procedure-arity.60.17 1))
        (cdr.59 (make-closure L.cdr.59.18 1))
        (car.58 (make-closure L.car.58.19 1))
        (vector-ref.57 (make-closure L.vector-ref.57.20 2 unsafe-vector-ref.3))
        (vector-set!.56
         (make-closure L.vector-set!.56.21 3 unsafe-vector-set!.2))
        (vector-length.55 (make-closure L.vector-length.55.22 1))
        (make-vector.54
         (make-closure L.make-vector.54.23 1 make-init-vector.1))
        (>=.53 (make-closure L.>=.53.24 2))
        (>.52 (make-closure L.>.52.25 2))
        (<=.51 (make-closure L.<=.51.26 2))
        (<.50 (make-closure L.<.50.27 2))
        (|-.49| (make-closure L.-.49.28 2))
        (|+.48| (make-closure L.+.48.29 2))
        (*.47 (make-closure L.*.47.30 2)))
       (let ()
         (let ()
           (letrec ()
             (cletrec
              ()
              (let ()
                (let ((x.4 #t))
                  (let ((t.5 (closure-apply make-vector.54 make-vector.54 1)))
                    (letrec ()
                      (cletrec
                       ()
                       (let ((t.5.7
                              (if (let ((tmp.6 #t)) (if tmp.6 tmp.6 #f))
                                x.4
                                #f)))
                         (let ((tmp.8
                                (closure-apply
                                 vector-set!.56
                                 vector-set!.56
                                 t.5
                                 0
                                 t.5.7)))
                           (closure-apply
                            not.70
                            not.70
                            (closure-apply
                             vector-ref.57
                             vector-ref.57
                             t.5
                             0))))))))))))))))
     ) #f))




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
              (lambda (c.84 tmp.79 tmp.80)
                (let ()
                  (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
                    (if (unsafe-fx>= tmp.80 0)
                      (unsafe-vector-ref tmp.79 tmp.80)
                      (error 10))
                    (error 10)))))
             (L.unsafe-vector-set!.2.2
              (lambda (c.85 tmp.79 tmp.80 tmp.81)
                (let ()
                  (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
                    (if (unsafe-fx>= tmp.80 0)
                      (begin (unsafe-vector-set! tmp.79 tmp.80 tmp.81) tmp.79)
                      (error 9))
                    (error 9)))))
             (L.vector-init-loop.75.3
              (lambda (c.86 len.76 i.78 vec.77)
                (let ((vector-init-loop.75 (closure-ref c.86 0)))
                  (if (eq? len.76 i.78)
                    vec.77
                    (begin
                      (unsafe-vector-set! vec.77 i.78 0)
                      (let ((tmp.114 vector-init-loop.75))
                        (unsafe-apply
                         L.vector-init-loop.75.3
                         vector-init-loop.75
                         len.76
                         (unsafe-fx+ i.78 1)
                         vec.77)))))))
             (L.make-init-vector.1.4
              (lambda (c.87 tmp.73)
                (let ((vector-init-loop.75 (closure-ref c.87 0)))
                  (let ((tmp.74 (unsafe-make-vector tmp.73)))
                    (let ((tmp.115 vector-init-loop.75))
                      (unsafe-apply
                       L.vector-init-loop.75.3
                       vector-init-loop.75
                       tmp.73
                       0
                       tmp.74))))))
             (L.eq?.72.5
              (lambda (c.88 tmp.45 tmp.46) (let () (eq? tmp.45 tmp.46))))
             (L.cons.71.6
              (lambda (c.89 tmp.43 tmp.44) (let () (cons tmp.43 tmp.44))))
             (L.not.70.7 (lambda (c.90 tmp.42) (let () (not tmp.42))))
             (L.vector?.69.8 (lambda (c.91 tmp.41) (let () (vector? tmp.41))))
             (L.procedure?.68.9
              (lambda (c.92 tmp.40) (let () (procedure? tmp.40))))
             (L.pair?.67.10 (lambda (c.93 tmp.39) (let () (pair? tmp.39))))
             (L.error?.66.11 (lambda (c.94 tmp.38) (let () (error? tmp.38))))
             (L.ascii-char?.65.12
              (lambda (c.95 tmp.37) (let () (ascii-char? tmp.37))))
             (L.void?.64.13 (lambda (c.96 tmp.36) (let () (void? tmp.36))))
             (L.empty?.63.14 (lambda (c.97 tmp.35) (let () (empty? tmp.35))))
             (L.boolean?.62.15
              (lambda (c.98 tmp.34) (let () (boolean? tmp.34))))
             (L.fixnum?.61.16 (lambda (c.99 tmp.33) (let () (fixnum? tmp.33))))
             (L.procedure-arity.60.17
              (lambda (c.100 tmp.32)
                (let ()
                  (if (procedure? tmp.32)
                    (unsafe-procedure-arity tmp.32)
                    (error 13)))))
             (L.cdr.59.18
              (lambda (c.101 tmp.31)
                (let () (if (pair? tmp.31) (unsafe-cdr tmp.31) (error 12)))))
             (L.car.58.19
              (lambda (c.102 tmp.30)
                (let () (if (pair? tmp.30) (unsafe-car tmp.30) (error 11)))))
             (L.vector-ref.57.20
              (lambda (c.103 tmp.28 tmp.29)
                (let ((unsafe-vector-ref.3 (closure-ref c.103 0)))
                  (if (fixnum? tmp.29)
                    (if (vector? tmp.28)
                      (let ((tmp.116 unsafe-vector-ref.3))
                        (unsafe-apply
                         L.unsafe-vector-ref.3.1
                         unsafe-vector-ref.3
                         tmp.28
                         tmp.29))
                      (error 10))
                    (error 10)))))
             (L.vector-set!.56.21
              (lambda (c.104 tmp.25 tmp.26 tmp.27)
                (let ((unsafe-vector-set!.2 (closure-ref c.104 0)))
                  (if (fixnum? tmp.26)
                    (if (vector? tmp.25)
                      (let ((tmp.117 unsafe-vector-set!.2))
                        (unsafe-apply
                         L.unsafe-vector-set!.2.2
                         unsafe-vector-set!.2
                         tmp.25
                         tmp.26
                         tmp.27))
                      (error 9))
                    (error 9)))))
             (L.vector-length.55.22
              (lambda (c.105 tmp.24)
                (let ()
                  (if (vector? tmp.24)
                    (unsafe-vector-length tmp.24)
                    (error 8)))))
             (L.make-vector.54.23
              (lambda (c.106 tmp.23)
                (let ((make-init-vector.1 (closure-ref c.106 0)))
                  (if (fixnum? tmp.23)
                    (let ((tmp.118 make-init-vector.1))
                      (unsafe-apply
                       L.make-init-vector.1.4
                       make-init-vector.1
                       tmp.23))
                    (error 7)))))
             (L.>=.53.24
              (lambda (c.107 tmp.21 tmp.22)
                (let ()
                  (if (fixnum? tmp.22)
                    (if (fixnum? tmp.21) (unsafe-fx>= tmp.21 tmp.22) (error 6))
                    (error 6)))))
             (L.>.52.25
              (lambda (c.108 tmp.19 tmp.20)
                (let ()
                  (if (fixnum? tmp.20)
                    (if (fixnum? tmp.19) (unsafe-fx> tmp.19 tmp.20) (error 5))
                    (error 5)))))
             (L.<=.51.26
              (lambda (c.109 tmp.17 tmp.18)
                (let ()
                  (if (fixnum? tmp.18)
                    (if (fixnum? tmp.17) (unsafe-fx<= tmp.17 tmp.18) (error 4))
                    (error 4)))))
             (L.<.50.27
              (lambda (c.110 tmp.15 tmp.16)
                (let ()
                  (if (fixnum? tmp.16)
                    (if (fixnum? tmp.15) (unsafe-fx< tmp.15 tmp.16) (error 3))
                    (error 3)))))
             (L.-.49.28
              (lambda (c.111 tmp.13 tmp.14)
                (let ()
                  (if (fixnum? tmp.14)
                    (if (fixnum? tmp.13) (unsafe-fx- tmp.13 tmp.14) (error 2))
                    (error 2)))))
             (L.+.48.29
              (lambda (c.112 tmp.11 tmp.12)
                (let ()
                  (if (fixnum? tmp.12)
                    (if (fixnum? tmp.11) (unsafe-fx+ tmp.11 tmp.12) (error 1))
                    (error 1)))))
             (L.*.47.30
              (lambda (c.113 tmp.9 tmp.10)
                (let ()
                  (if (fixnum? tmp.10)
                    (if (fixnum? tmp.9) (unsafe-fx* tmp.9 tmp.10) (error 0))
                    (error 0))))))
      (cletrec
       ((unsafe-vector-ref.3 (make-closure L.unsafe-vector-ref.3.1 2))
        (unsafe-vector-set!.2 (make-closure L.unsafe-vector-set!.2.2 3))
        (vector-init-loop.75
         (make-closure L.vector-init-loop.75.3 3 vector-init-loop.75))
        (make-init-vector.1
         (make-closure L.make-init-vector.1.4 1 vector-init-loop.75))
        (eq?.72 (make-closure L.eq?.72.5 2))
        (cons.71 (make-closure L.cons.71.6 2))
        (not.70 (make-closure L.not.70.7 1))
        (vector?.69 (make-closure L.vector?.69.8 1))
        (procedure?.68 (make-closure L.procedure?.68.9 1))
        (pair?.67 (make-closure L.pair?.67.10 1))
        (error?.66 (make-closure L.error?.66.11 1))
        (ascii-char?.65 (make-closure L.ascii-char?.65.12 1))
        (void?.64 (make-closure L.void?.64.13 1))
        (empty?.63 (make-closure L.empty?.63.14 1))
        (boolean?.62 (make-closure L.boolean?.62.15 1))
        (fixnum?.61 (make-closure L.fixnum?.61.16 1))
        (procedure-arity.60 (make-closure L.procedure-arity.60.17 1))
        (cdr.59 (make-closure L.cdr.59.18 1))
        (car.58 (make-closure L.car.58.19 1))
        (vector-ref.57 (make-closure L.vector-ref.57.20 2 unsafe-vector-ref.3))
        (vector-set!.56
         (make-closure L.vector-set!.56.21 3 unsafe-vector-set!.2))
        (vector-length.55 (make-closure L.vector-length.55.22 1))
        (make-vector.54
         (make-closure L.make-vector.54.23 1 make-init-vector.1))
        (>=.53 (make-closure L.>=.53.24 2))
        (>.52 (make-closure L.>.52.25 2))
        (<=.51 (make-closure L.<=.51.26 2))
        (<.50 (make-closure L.<.50.27 2))
        (|-.49| (make-closure L.-.49.28 2))
        (|+.48| (make-closure L.+.48.29 2))
        (*.47 (make-closure L.*.47.30 2)))
       (let ()
         (let ()
           (letrec ()
             (cletrec
              ()
              (let ()
                (let ((x.4 #t))
                  (let ((t.5
                         (let ((tmp.119 make-vector.54))
                           (unsafe-apply
                            L.make-vector.54.23
                            make-vector.54
                            1))))
                    (letrec ()
                      (cletrec
                       ()
                       (let ((t.5.7
                              (if (let ((tmp.6 #t)) (if tmp.6 tmp.6 #f))
                                x.4
                                #f)))
                         (let ((tmp.8
                                (let ((tmp.120 vector-set!.56))
                                  (unsafe-apply
                                   L.vector-set!.56.21
                                   vector-set!.56
                                   t.5
                                   0
                                   t.5.7))))
                           (let ((tmp.121 not.70))
                             (unsafe-apply
                              L.not.70.7
                              not.70
                              (let ((tmp.122 vector-ref.57))
                                (unsafe-apply
                                 L.vector-ref.57.20
                                 vector-ref.57
                                 t.5
                                 0))))))))))))))))))
     ) #f))

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
     (execute '(module
    (define L.*.47.30
      (lambda (c.113 tmp.9 tmp.10)
        (if (fixnum? tmp.10)
          (if (fixnum? tmp.9) (unsafe-fx* tmp.9 tmp.10) (error 0))
          (error 0))))
    (define L.+.48.29
      (lambda (c.112 tmp.11 tmp.12)
        (if (fixnum? tmp.12)
          (if (fixnum? tmp.11) (unsafe-fx+ tmp.11 tmp.12) (error 1))
          (error 1))))
    (define L.-.49.28
      (lambda (c.111 tmp.13 tmp.14)
        (if (fixnum? tmp.14)
          (if (fixnum? tmp.13) (unsafe-fx- tmp.13 tmp.14) (error 2))
          (error 2))))
    (define L.<.50.27
      (lambda (c.110 tmp.15 tmp.16)
        (if (fixnum? tmp.16)
          (if (fixnum? tmp.15) (unsafe-fx< tmp.15 tmp.16) (error 3))
          (error 3))))
    (define L.<=.51.26
      (lambda (c.109 tmp.17 tmp.18)
        (if (fixnum? tmp.18)
          (if (fixnum? tmp.17) (unsafe-fx<= tmp.17 tmp.18) (error 4))
          (error 4))))
    (define L.>.52.25
      (lambda (c.108 tmp.19 tmp.20)
        (if (fixnum? tmp.20)
          (if (fixnum? tmp.19) (unsafe-fx> tmp.19 tmp.20) (error 5))
          (error 5))))
    (define L.>=.53.24
      (lambda (c.107 tmp.21 tmp.22)
        (if (fixnum? tmp.22)
          (if (fixnum? tmp.21) (unsafe-fx>= tmp.21 tmp.22) (error 6))
          (error 6))))
    (define L.make-vector.54.23
      (lambda (c.106 tmp.23)
        (let ((make-init-vector.1 (unsafe-procedure-ref c.106 0)))
          (if (fixnum? tmp.23)
            (let ((tmp.118 make-init-vector.1))
              (apply L.make-init-vector.1.4 make-init-vector.1 tmp.23))
            (error 7)))))
    (define L.vector-length.55.22
      (lambda (c.105 tmp.24)
        (if (vector? tmp.24) (unsafe-vector-length tmp.24) (error 8))))
    (define L.vector-set!.56.21
      (lambda (c.104 tmp.25 tmp.26 tmp.27)
        (let ((unsafe-vector-set!.2 (unsafe-procedure-ref c.104 0)))
          (if (fixnum? tmp.26)
            (if (vector? tmp.25)
              (let ((tmp.117 unsafe-vector-set!.2))
                (apply
                 L.unsafe-vector-set!.2.2
                 unsafe-vector-set!.2
                 tmp.25
                 tmp.26
                 tmp.27))
              (error 9))
            (error 9)))))
    (define L.vector-ref.57.20
      (lambda (c.103 tmp.28 tmp.29)
        (let ((unsafe-vector-ref.3 (unsafe-procedure-ref c.103 0)))
          (if (fixnum? tmp.29)
            (if (vector? tmp.28)
              (let ((tmp.116 unsafe-vector-ref.3))
                (apply
                 L.unsafe-vector-ref.3.1
                 unsafe-vector-ref.3
                 tmp.28
                 tmp.29))
              (error 10))
            (error 10)))))
    (define L.car.58.19
      (lambda (c.102 tmp.30)
        (if (pair? tmp.30) (unsafe-car tmp.30) (error 11))))
    (define L.cdr.59.18
      (lambda (c.101 tmp.31)
        (if (pair? tmp.31) (unsafe-cdr tmp.31) (error 12))))
    (define L.procedure-arity.60.17
      (lambda (c.100 tmp.32)
        (if (procedure? tmp.32) (unsafe-procedure-arity tmp.32) (error 13))))
    (define L.fixnum?.61.16 (lambda (c.99 tmp.33) (fixnum? tmp.33)))
    (define L.boolean?.62.15 (lambda (c.98 tmp.34) (boolean? tmp.34)))
    (define L.empty?.63.14 (lambda (c.97 tmp.35) (empty? tmp.35)))
    (define L.void?.64.13 (lambda (c.96 tmp.36) (void? tmp.36)))
    (define L.ascii-char?.65.12 (lambda (c.95 tmp.37) (ascii-char? tmp.37)))
    (define L.error?.66.11 (lambda (c.94 tmp.38) (error? tmp.38)))
    (define L.pair?.67.10 (lambda (c.93 tmp.39) (pair? tmp.39)))
    (define L.procedure?.68.9 (lambda (c.92 tmp.40) (procedure? tmp.40)))
    (define L.vector?.69.8 (lambda (c.91 tmp.41) (vector? tmp.41)))
    (define L.not.70.7 (lambda (c.90 tmp.42) (not tmp.42)))
    (define L.cons.71.6 (lambda (c.89 tmp.43 tmp.44) (cons tmp.43 tmp.44)))
    (define L.eq?.72.5 (lambda (c.88 tmp.45 tmp.46) (eq? tmp.45 tmp.46)))
    (define L.make-init-vector.1.4
      (lambda (c.87 tmp.73)
        (let ((vector-init-loop.75 (unsafe-procedure-ref c.87 0)))
          (let ((tmp.74 (unsafe-make-vector tmp.73)))
            (let ((tmp.115 vector-init-loop.75))
              (apply
               L.vector-init-loop.75.3
               vector-init-loop.75
               tmp.73
               0
               tmp.74))))))
    (define L.vector-init-loop.75.3
      (lambda (c.86 len.76 i.78 vec.77)
        (let ((vector-init-loop.75 (unsafe-procedure-ref c.86 0)))
          (if (eq? len.76 i.78)
            vec.77
            (begin
              (unsafe-vector-set! vec.77 i.78 0)
              (let ((tmp.114 vector-init-loop.75))
                (apply
                 L.vector-init-loop.75.3
                 vector-init-loop.75
                 len.76
                 (unsafe-fx+ i.78 1)
                 vec.77)))))))
    (define L.unsafe-vector-set!.2.2
      (lambda (c.85 tmp.79 tmp.80 tmp.81)
        (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
          (if (unsafe-fx>= tmp.80 0)
            (begin (unsafe-vector-set! tmp.79 tmp.80 tmp.81) tmp.79)
            (error 9))
          (error 9))))
    (define L.unsafe-vector-ref.3.1
      (lambda (c.84 tmp.79 tmp.80)
        (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
          (if (unsafe-fx>= tmp.80 0)
            (unsafe-vector-ref tmp.79 tmp.80)
            (error 10))
          (error 10))))
    (let ((unsafe-vector-ref.3 (make-procedure L.unsafe-vector-ref.3.1 2 0)))
      (let ((unsafe-vector-set!.2
             (make-procedure L.unsafe-vector-set!.2.2 3 0)))
        (let ((vector-init-loop.75
               (make-procedure L.vector-init-loop.75.3 3 1)))
          (let ((make-init-vector.1
                 (make-procedure L.make-init-vector.1.4 1 1)))
            (let ((eq?.72 (make-procedure L.eq?.72.5 2 0)))
              (let ((cons.71 (make-procedure L.cons.71.6 2 0)))
                (let ((not.70 (make-procedure L.not.70.7 1 0)))
                  (let ((vector?.69 (make-procedure L.vector?.69.8 1 0)))
                    (let ((procedure?.68
                           (make-procedure L.procedure?.68.9 1 0)))
                      (let ((pair?.67 (make-procedure L.pair?.67.10 1 0)))
                        (let ((error?.66 (make-procedure L.error?.66.11 1 0)))
                          (let ((ascii-char?.65
                                 (make-procedure L.ascii-char?.65.12 1 0)))
                            (let ((void?.64
                                   (make-procedure L.void?.64.13 1 0)))
                              (let ((empty?.63
                                     (make-procedure L.empty?.63.14 1 0)))
                                (let ((boolean?.62
                                       (make-procedure L.boolean?.62.15 1 0)))
                                  (let ((fixnum?.61
                                         (make-procedure L.fixnum?.61.16 1 0)))
                                    (let ((procedure-arity.60
                                           (make-procedure
                                            L.procedure-arity.60.17
                                            1
                                            0)))
                                      (let ((cdr.59
                                             (make-procedure L.cdr.59.18 1 0)))
                                        (let ((car.58
                                               (make-procedure
                                                L.car.58.19
                                                1
                                                0)))
                                          (let ((vector-ref.57
                                                 (make-procedure
                                                  L.vector-ref.57.20
                                                  2
                                                  1)))
                                            (let ((vector-set!.56
                                                   (make-procedure
                                                    L.vector-set!.56.21
                                                    3
                                                    1)))
                                              (let ((vector-length.55
                                                     (make-procedure
                                                      L.vector-length.55.22
                                                      1
                                                      0)))
                                                (let ((make-vector.54
                                                       (make-procedure
                                                        L.make-vector.54.23
                                                        1
                                                        1)))
                                                  (let ((>=.53
                                                         (make-procedure
                                                          L.>=.53.24
                                                          2
                                                          0)))
                                                    (let ((>.52
                                                           (make-procedure
                                                            L.>.52.25
                                                            2
                                                            0)))
                                                      (let ((<=.51
                                                             (make-procedure
                                                              L.<=.51.26
                                                              2
                                                              0)))
                                                        (let ((<.50
                                                               (make-procedure
                                                                L.<.50.27
                                                                2
                                                                0)))
                                                          (let ((|-.49|
                                                                 (make-procedure
                                                                  L.-.49.28
                                                                  2
                                                                  0)))
                                                            (let ((|+.48|
                                                                   (make-procedure
                                                                    L.+.48.29
                                                                    2
                                                                    0)))
                                                              (let ((*.47
                                                                     (make-procedure
                                                                      L.*.47.30
                                                                      2
                                                                      0)))
                                                                (begin
                                                                  (begin)
                                                                  (begin)
                                                                  (begin
                                                                    (unsafe-procedure-set!
                                                                     vector-init-loop.75
                                                                     0
                                                                     vector-init-loop.75))
                                                                  (begin
                                                                    (unsafe-procedure-set!
                                                                     make-init-vector.1
                                                                     0
                                                                     vector-init-loop.75))
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin
                                                                    (unsafe-procedure-set!
                                                                     vector-ref.57
                                                                     0
                                                                     unsafe-vector-ref.3))
                                                                  (begin
                                                                    (unsafe-procedure-set!
                                                                     vector-set!.56
                                                                     0
                                                                     unsafe-vector-set!.2))
                                                                  (begin)
                                                                  (begin
                                                                    (unsafe-procedure-set!
                                                                     make-vector.54
                                                                     0
                                                                     make-init-vector.1))
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin
                                                                    (let ((x.4
                                                                           #t))
                                                                      (let ((t.5
                                                                             (let ((tmp.119
                                                                                    make-vector.54))
                                                                               (apply
                                                                                L.make-vector.54.23
                                                                                make-vector.54
                                                                                1))))
                                                                        (begin
                                                                          (let ((t.5.7
                                                                                 (if (let ((tmp.6
                                                                                            #t))
                                                                                       (if tmp.6
                                                                                         tmp.6
                                                                                         #f))
                                                                                   x.4
                                                                                   #f)))
                                                                            (let ((tmp.8
                                                                                   (let ((tmp.120
                                                                                          vector-set!.56))
                                                                                     (apply
                                                                                      L.vector-set!.56.21
                                                                                      vector-set!.56
                                                                                      t.5
                                                                                      0
                                                                                      t.5.7))))
                                                                              (let ((tmp.121
                                                                                     not.70))
                                                                                (apply
                                                                                 L.not.70.7
                                                                                 not.70
                                                                                 (let ((tmp.122
                                                                                        vector-ref.57))
                                                                                   (apply
                                                                                    L.vector-ref.57.20
                                                                                    vector-ref.57
                                                                                    t.5
                                                                                    0))))))))))))))))))))))))))))))))))))))))))
     ) #f))

#;(parameterize ([current-pass-list
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
     (execute '(module
    (define L.main.104
      ((new-frames ())
       (locals
        (tmp.119
         *.47
         tmp.154
         tmp.339
         tmp.305
         |+.48|
         tmp.153
         tmp.338
         tmp.304
         |-.49|
         tmp.152
         tmp.337
         tmp.303
         <.50
         tmp.151
         tmp.336
         tmp.302
         <=.51
         tmp.150
         tmp.335
         tmp.301
         >.52
         tmp.149
         tmp.334
         tmp.300
         >=.53
         tmp.148
         tmp.333
         tmp.299
         make-vector.54
         tmp.147
         tmp.332
         tmp.298
         vector-length.55
         tmp.146
         tmp.331
         tmp.297
         tmp.145
         tmp.330
         tmp.296
         tmp.144
         tmp.329
         tmp.295
         car.58
         tmp.143
         tmp.328
         tmp.294
         cdr.59
         tmp.142
         tmp.327
         tmp.293
         procedure-arity.60
         tmp.141
         tmp.326
         tmp.292
         fixnum?.61
         tmp.140
         tmp.325
         tmp.291
         boolean?.62
         tmp.139
         tmp.324
         tmp.290
         empty?.63
         tmp.138
         tmp.323
         tmp.289
         void?.64
         tmp.137
         tmp.322
         tmp.288
         ascii-char?.65
         tmp.136
         tmp.321
         tmp.287
         error?.66
         tmp.135
         tmp.320
         tmp.286
         pair?.67
         tmp.134
         tmp.319
         tmp.285
         procedure?.68
         tmp.133
         tmp.318
         tmp.284
         vector?.69
         tmp.132
         tmp.317
         tmp.283
         tmp.131
         tmp.316
         tmp.282
         cons.71
         tmp.130
         tmp.315
         tmp.281
         eq?.72
         tmp.129
         tmp.314
         tmp.280
         make-init-vector.1
         tmp.128
         tmp.313
         tmp.279
         vector-init-loop.75
         tmp.127
         tmp.312
         tmp.278
         unsafe-vector-set!.2
         tmp.126
         tmp.311
         tmp.277
         unsafe-vector-ref.3
         tmp.125
         tmp.310
         tmp.276
         ra.309
         tmp.6
         x.4
         vector-set!.56
         not.70
         vector-ref.57
         t.5))
       (undead-out
        ((r12 rbp ra.309)
         (r12 tmp.276 rbp ra.309)
         (tmp.276 r12 rbp ra.309)
         (tmp.310 r12 rbp ra.309)
         (r12 rbp ra.309 tmp.125)
         (ra.309 rbp r12 tmp.125)
         (tmp.125 r12 rbp ra.309)
         (r12 rbp ra.309 unsafe-vector-ref.3)
         (r12 tmp.277 rbp ra.309 unsafe-vector-ref.3)
         (tmp.277 r12 rbp ra.309 unsafe-vector-ref.3)
         (tmp.311 r12 rbp ra.309 unsafe-vector-ref.3)
         (r12 rbp ra.309 unsafe-vector-ref.3 tmp.126)
         (unsafe-vector-ref.3 ra.309 rbp r12 tmp.126)
         (tmp.126 r12 rbp ra.309 unsafe-vector-ref.3)
         (r12 unsafe-vector-set!.2 rbp ra.309 unsafe-vector-ref.3)
         (r12 tmp.278 unsafe-vector-set!.2 rbp ra.309 unsafe-vector-ref.3)
         (tmp.278 r12 unsafe-vector-set!.2 rbp ra.309 unsafe-vector-ref.3)
         (tmp.312 r12 unsafe-vector-set!.2 rbp ra.309 unsafe-vector-ref.3)
         (r12 unsafe-vector-set!.2 rbp ra.309 unsafe-vector-ref.3 tmp.127)
         (unsafe-vector-ref.3 ra.309 rbp unsafe-vector-set!.2 r12 tmp.127)
         (tmp.127 r12 unsafe-vector-set!.2 rbp ra.309 unsafe-vector-ref.3)
         (r12
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.279
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.279
          r12
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.313
          r12
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.128)
         (vector-init-loop.75
          unsafe-vector-ref.3
          ra.309
          rbp
          unsafe-vector-set!.2
          r12
          tmp.128)
         (tmp.128
          r12
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.280
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.280
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.314
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.129)
         (vector-init-loop.75
          unsafe-vector-ref.3
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.129)
         (tmp.129
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.281
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.281
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.315
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.130)
         (vector-init-loop.75
          unsafe-vector-ref.3
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.130)
         (tmp.130
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.282
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.282
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.316
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.131)
         (vector-init-loop.75
          unsafe-vector-ref.3
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.131)
         (tmp.131
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.283
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.283
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.317
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.132)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.132)
         (tmp.132
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.284
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.284
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.318
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.133)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.133)
         (tmp.133
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.285
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.285
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.319
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.134)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.134)
         (tmp.134
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.286
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.286
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.320
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.135)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.135)
         (tmp.135
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.287
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.287
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.321
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.136)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.136)
         (tmp.136
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.288
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.288
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.322
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.137)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.137)
         (tmp.137
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.289
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.289
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.323
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.138)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.138)
         (tmp.138
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.290
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.290
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.324
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.139)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.139)
         (tmp.139
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.291
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.291
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.325
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.140)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.140)
         (tmp.140
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.292
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.292
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.326
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.141)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.141)
         (tmp.141
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.293
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.293
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.327
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.142)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.142)
         (tmp.142
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.294
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.294
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.328
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.143)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.143)
         (tmp.143
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.295
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.295
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.329
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.144)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.144)
         (tmp.144
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.296
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.296
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.330
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.145)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.145)
         (tmp.145
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.297
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.297
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.331
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.146)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          r12
          tmp.146)
         (tmp.146
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.298
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.298
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.332
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.147)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          r12
          tmp.147)
         (tmp.147
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.299
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.299
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.333
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.148)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          make-vector.54
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          r12
          tmp.148)
         (tmp.148
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.300
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.300
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.334
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.149)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          make-vector.54
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          r12
          tmp.149)
         (tmp.149
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.301
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.301
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.335
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.150)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          make-vector.54
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          r12
          tmp.150)
         (tmp.150
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.302
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.302
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.336
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.151)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          make-vector.54
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          r12
          tmp.151)
         (tmp.151
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.303
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.303
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.337
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.152)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          make-vector.54
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          r12
          tmp.152)
         (tmp.152
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.304
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.304
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.338
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.153)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          make-vector.54
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          r12
          tmp.153)
         (tmp.153
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.305
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.305
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.339
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.154)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          make-vector.54
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          tmp.154)
         (tmp.154
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (vector-ref.57
          unsafe-vector-ref.3
          make-vector.54
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          vector-init-loop.75
          make-init-vector.1)
         (vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-init-vector.1
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57)
         (make-vector.54
          make-init-vector.1
          vector-ref.57
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56)
         (rbp
          ra.309
          vector-set!.56
          not.70
          vector-ref.57
          make-init-vector.1
          make-vector.54)
         (make-vector.54 vector-ref.57 not.70 vector-set!.56 ra.309 rbp)
         (make-vector.54 vector-ref.57 not.70 vector-set!.56 x.4 ra.309 rbp)
         (make-vector.54 vector-ref.57 not.70 vector-set!.56 x.4 ra.309 rbp)
         ((rax vector-ref.57 not.70 vector-set!.56 x.4 ra.309 rbp)
          ((make-vector.54 rsi rbp)
           (rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp)))
         (t.5 vector-ref.57 not.70 vector-set!.56 x.4 ra.309 rbp)
         (t.5 vector-ref.57 not.70 vector-set!.56 x.4 tmp.6 ra.309 rbp)
         ((t.5 vector-ref.57 not.70 vector-set!.56 x.4 tmp.6 ra.309 rbp)
          ((vector-ref.57 not.70 vector-set!.56 x.4 tmp.6 ra.309 r9 rbp)
           (not.70 vector-set!.56 x.4 tmp.6 ra.309 r8 r9 rbp)
           (vector-set!.56 x.4 tmp.6 ra.309 rcx r8 r9 rbp)
           (x.4 tmp.6 ra.309 rdx rcx r8 r9 rbp)
           (tmp.6 ra.309 rsi rdx rcx r8 r9 rbp)
           (ra.309 rdi rsi rdx rcx r8 r9 rbp)
           (rdi rsi rdx rcx r8 r9 r15 rbp)
           (rdi rsi rdx rcx r8 r9 r15 rbp))
          ((vector-ref.57 not.70 vector-set!.56 x.4 ra.309 r9 rbp)
           (not.70 vector-set!.56 x.4 ra.309 r8 r9 rbp)
           (vector-set!.56 x.4 ra.309 rcx r8 r9 rbp)
           (x.4 ra.309 rdx rcx r8 r9 rbp)
           (ra.309 rsi rdx rcx r8 r9 rbp)
           (ra.309 rdi rsi rdx rcx r8 r9 rbp)
           (rdi rsi rdx rcx r8 r9 r15 rbp)
           (rdi rsi rdx rcx r8 r9 r15 rbp)))))
       (call-undead (vector-ref.57 not.70 vector-set!.56 x.4 ra.309))
       (conflicts
        ((r9
          (tmp.6
           r15
           rdi
           rsi
           rdx
           rcx
           r8
           vector-ref.57
           not.70
           vector-set!.56
           x.4
           ra.309
           rbp))
         (rbp
          (tmp.6
           t.5
           rax
           tmp.119
           x.4
           *.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           vector-ref.57
           tmp.144
           tmp.329
           tmp.295
           car.58
           tmp.143
           tmp.328
           tmp.294
           cdr.59
           tmp.142
           tmp.327
           tmp.293
           procedure-arity.60
           tmp.141
           tmp.326
           tmp.292
           fixnum?.61
           tmp.140
           tmp.325
           tmp.291
           boolean?.62
           tmp.139
           tmp.324
           tmp.290
           empty?.63
           tmp.138
           tmp.323
           tmp.289
           void?.64
           tmp.137
           tmp.322
           tmp.288
           ascii-char?.65
           tmp.136
           tmp.321
           tmp.287
           error?.66
           tmp.135
           tmp.320
           tmp.286
           pair?.67
           tmp.134
           tmp.319
           tmp.285
           procedure?.68
           tmp.133
           tmp.318
           tmp.284
           vector?.69
           tmp.132
           tmp.317
           tmp.283
           not.70
           tmp.131
           tmp.316
           tmp.282
           cons.71
           tmp.130
           tmp.315
           tmp.281
           eq?.72
           tmp.129
           tmp.314
           tmp.280
           make-init-vector.1
           tmp.128
           tmp.313
           tmp.279
           vector-init-loop.75
           tmp.127
           tmp.312
           tmp.278
           unsafe-vector-set!.2
           tmp.126
           tmp.311
           tmp.277
           unsafe-vector-ref.3
           tmp.125
           tmp.310
           r12
           tmp.276
           ra.309
           r15
           rdi
           rsi
           rdx
           rcx
           r8
           r9))
         (ra.309
          (tmp.6
           t.5
           rax
           tmp.119
           x.4
           *.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           vector-ref.57
           tmp.144
           tmp.329
           tmp.295
           car.58
           tmp.143
           tmp.328
           tmp.294
           cdr.59
           tmp.142
           tmp.327
           tmp.293
           procedure-arity.60
           tmp.141
           tmp.326
           tmp.292
           fixnum?.61
           tmp.140
           tmp.325
           tmp.291
           boolean?.62
           tmp.139
           tmp.324
           tmp.290
           empty?.63
           tmp.138
           tmp.323
           tmp.289
           void?.64
           tmp.137
           tmp.322
           tmp.288
           ascii-char?.65
           tmp.136
           tmp.321
           tmp.287
           error?.66
           tmp.135
           tmp.320
           tmp.286
           pair?.67
           tmp.134
           tmp.319
           tmp.285
           procedure?.68
           tmp.133
           tmp.318
           tmp.284
           vector?.69
           tmp.132
           tmp.317
           tmp.283
           not.70
           tmp.131
           tmp.316
           tmp.282
           cons.71
           tmp.130
           tmp.315
           tmp.281
           eq?.72
           tmp.129
           tmp.314
           tmp.280
           make-init-vector.1
           tmp.128
           tmp.313
           tmp.279
           vector-init-loop.75
           tmp.127
           tmp.312
           tmp.278
           unsafe-vector-set!.2
           tmp.126
           tmp.311
           tmp.277
           unsafe-vector-ref.3
           tmp.125
           tmp.310
           tmp.276
           r12
           rbp
           rdi
           rsi
           rdx
           rcx
           r8
           r9))
         (x.4
          (tmp.6
           t.5
           rax
           tmp.119
           make-vector.54
           vector-ref.57
           not.70
           vector-set!.56
           ra.309
           rbp
           rdx
           rcx
           r8
           r9))
         (vector-set!.56
          (tmp.6
           t.5
           rax
           tmp.119
           x.4
           *.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75
           rcx
           r8
           r9))
         (not.70
          (tmp.6
           t.5
           rax
           tmp.119
           x.4
           *.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           vector-ref.57
           tmp.144
           tmp.329
           tmp.295
           car.58
           tmp.143
           tmp.328
           tmp.294
           cdr.59
           tmp.142
           tmp.327
           tmp.293
           procedure-arity.60
           tmp.141
           tmp.326
           tmp.292
           fixnum?.61
           tmp.140
           tmp.325
           tmp.291
           boolean?.62
           tmp.139
           tmp.324
           tmp.290
           empty?.63
           tmp.138
           tmp.323
           tmp.289
           void?.64
           tmp.137
           tmp.322
           tmp.288
           ascii-char?.65
           tmp.136
           tmp.321
           tmp.287
           error?.66
           tmp.135
           tmp.320
           tmp.286
           pair?.67
           tmp.134
           tmp.319
           tmp.285
           procedure?.68
           tmp.133
           tmp.318
           tmp.284
           vector?.69
           tmp.132
           tmp.317
           tmp.283
           r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75
           r8
           r9))
         (vector-ref.57
          (tmp.6
           t.5
           rax
           tmp.119
           x.4
           *.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75
           r9))
         (r8
          (tmp.6 r15 rdi rsi rdx rcx not.70 vector-set!.56 x.4 ra.309 r9 rbp))
         (rcx (tmp.6 r15 rdi rsi rdx vector-set!.56 x.4 ra.309 r8 r9 rbp))
         (rdx (tmp.6 r15 rdi rsi x.4 ra.309 rcx r8 r9 rbp))
         (rsi (make-vector.54 tmp.6 r15 rdi ra.309 rdx rcx r8 r9 rbp))
         (rdi (r15 ra.309 rsi rdx rcx r8 r9 rbp))
         (r15 (rdi rsi rdx rcx r8 r9 rbp))
         (tmp.6
          (t.5
           vector-ref.57
           not.70
           vector-set!.56
           x.4
           ra.309
           rbp
           rsi
           rdx
           rcx
           r8
           r9))
         (r12
          (tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           vector-ref.57
           tmp.144
           tmp.329
           tmp.295
           car.58
           tmp.143
           tmp.328
           tmp.294
           cdr.59
           tmp.142
           tmp.327
           tmp.293
           procedure-arity.60
           tmp.141
           tmp.326
           tmp.292
           fixnum?.61
           tmp.140
           tmp.325
           tmp.291
           boolean?.62
           tmp.139
           tmp.324
           tmp.290
           empty?.63
           tmp.138
           tmp.323
           tmp.289
           void?.64
           tmp.137
           tmp.322
           tmp.288
           ascii-char?.65
           tmp.136
           tmp.321
           tmp.287
           error?.66
           tmp.135
           tmp.320
           tmp.286
           pair?.67
           tmp.134
           tmp.319
           tmp.285
           procedure?.68
           tmp.133
           tmp.318
           tmp.284
           vector?.69
           tmp.132
           tmp.317
           tmp.283
           not.70
           tmp.131
           tmp.316
           tmp.282
           cons.71
           tmp.130
           tmp.315
           tmp.281
           eq?.72
           tmp.129
           tmp.314
           tmp.280
           make-init-vector.1
           tmp.128
           tmp.313
           tmp.279
           vector-init-loop.75
           tmp.127
           tmp.312
           tmp.278
           unsafe-vector-set!.2
           tmp.126
           tmp.311
           tmp.277
           unsafe-vector-ref.3
           tmp.125
           tmp.310
           rbp
           tmp.276
           ra.309))
         (tmp.276 (r12 rbp ra.309))
         (tmp.310 (ra.309 rbp r12))
         (tmp.125 (r12 rbp ra.309))
         (unsafe-vector-ref.3
          (*.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           vector-ref.57
           tmp.144
           tmp.329
           tmp.295
           car.58
           tmp.143
           tmp.328
           tmp.294
           cdr.59
           tmp.142
           tmp.327
           tmp.293
           procedure-arity.60
           tmp.141
           tmp.326
           tmp.292
           fixnum?.61
           tmp.140
           tmp.325
           tmp.291
           boolean?.62
           tmp.139
           tmp.324
           tmp.290
           empty?.63
           tmp.138
           tmp.323
           tmp.289
           void?.64
           tmp.137
           tmp.322
           tmp.288
           ascii-char?.65
           tmp.136
           tmp.321
           tmp.287
           error?.66
           tmp.135
           tmp.320
           tmp.286
           pair?.67
           tmp.134
           tmp.319
           tmp.285
           procedure?.68
           tmp.133
           tmp.318
           tmp.284
           vector?.69
           tmp.132
           tmp.317
           tmp.283
           not.70
           tmp.131
           tmp.316
           tmp.282
           cons.71
           tmp.130
           tmp.315
           tmp.281
           eq?.72
           tmp.129
           tmp.314
           tmp.280
           make-init-vector.1
           tmp.128
           tmp.313
           tmp.279
           vector-init-loop.75
           tmp.127
           tmp.312
           tmp.278
           unsafe-vector-set!.2
           tmp.126
           tmp.311
           tmp.277
           r12
           rbp
           ra.309))
         (tmp.277 (r12 rbp ra.309 unsafe-vector-ref.3))
         (tmp.311 (unsafe-vector-ref.3 ra.309 rbp r12))
         (tmp.126 (r12 rbp ra.309 unsafe-vector-ref.3))
         (unsafe-vector-set!.2
          (*.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           vector-ref.57
           tmp.144
           tmp.329
           tmp.295
           car.58
           tmp.143
           tmp.328
           tmp.294
           cdr.59
           tmp.142
           tmp.327
           tmp.293
           procedure-arity.60
           tmp.141
           tmp.326
           tmp.292
           fixnum?.61
           tmp.140
           tmp.325
           tmp.291
           boolean?.62
           tmp.139
           tmp.324
           tmp.290
           empty?.63
           tmp.138
           tmp.323
           tmp.289
           void?.64
           tmp.137
           tmp.322
           tmp.288
           ascii-char?.65
           tmp.136
           tmp.321
           tmp.287
           error?.66
           tmp.135
           tmp.320
           tmp.286
           pair?.67
           tmp.134
           tmp.319
           tmp.285
           procedure?.68
           tmp.133
           tmp.318
           tmp.284
           vector?.69
           tmp.132
           tmp.317
           tmp.283
           not.70
           tmp.131
           tmp.316
           tmp.282
           cons.71
           tmp.130
           tmp.315
           tmp.281
           eq?.72
           tmp.129
           tmp.314
           tmp.280
           make-init-vector.1
           tmp.128
           tmp.313
           tmp.279
           vector-init-loop.75
           tmp.127
           tmp.312
           tmp.278
           r12
           rbp
           ra.309
           unsafe-vector-ref.3))
         (tmp.278 (r12 unsafe-vector-set!.2 rbp ra.309 unsafe-vector-ref.3))
         (tmp.312 (unsafe-vector-ref.3 ra.309 rbp unsafe-vector-set!.2 r12))
         (tmp.127 (r12 unsafe-vector-set!.2 rbp ra.309 unsafe-vector-ref.3))
         (vector-init-loop.75
          (*.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           vector-ref.57
           tmp.144
           tmp.329
           tmp.295
           car.58
           tmp.143
           tmp.328
           tmp.294
           cdr.59
           tmp.142
           tmp.327
           tmp.293
           procedure-arity.60
           tmp.141
           tmp.326
           tmp.292
           fixnum?.61
           tmp.140
           tmp.325
           tmp.291
           boolean?.62
           tmp.139
           tmp.324
           tmp.290
           empty?.63
           tmp.138
           tmp.323
           tmp.289
           void?.64
           tmp.137
           tmp.322
           tmp.288
           ascii-char?.65
           tmp.136
           tmp.321
           tmp.287
           error?.66
           tmp.135
           tmp.320
           tmp.286
           pair?.67
           tmp.134
           tmp.319
           tmp.285
           procedure?.68
           tmp.133
           tmp.318
           tmp.284
           vector?.69
           tmp.132
           tmp.317
           tmp.283
           not.70
           tmp.131
           tmp.316
           tmp.282
           cons.71
           tmp.130
           tmp.315
           tmp.281
           eq?.72
           tmp.129
           tmp.314
           tmp.280
           make-init-vector.1
           tmp.128
           tmp.313
           tmp.279
           r12
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3))
         (tmp.279
          (r12
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.313
          (vector-init-loop.75
           unsafe-vector-ref.3
           ra.309
           rbp
           unsafe-vector-set!.2
           r12))
         (tmp.128
          (r12
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (make-init-vector.1
          (*.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           vector-ref.57
           tmp.144
           tmp.329
           tmp.295
           car.58
           tmp.143
           tmp.328
           tmp.294
           cdr.59
           tmp.142
           tmp.327
           tmp.293
           procedure-arity.60
           tmp.141
           tmp.326
           tmp.292
           fixnum?.61
           tmp.140
           tmp.325
           tmp.291
           boolean?.62
           tmp.139
           tmp.324
           tmp.290
           empty?.63
           tmp.138
           tmp.323
           tmp.289
           void?.64
           tmp.137
           tmp.322
           tmp.288
           ascii-char?.65
           tmp.136
           tmp.321
           tmp.287
           error?.66
           tmp.135
           tmp.320
           tmp.286
           pair?.67
           tmp.134
           tmp.319
           tmp.285
           procedure?.68
           tmp.133
           tmp.318
           tmp.284
           vector?.69
           tmp.132
           tmp.317
           tmp.283
           not.70
           tmp.131
           tmp.316
           tmp.282
           cons.71
           tmp.130
           tmp.315
           tmp.281
           eq?.72
           tmp.129
           tmp.314
           tmp.280
           r12
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.280
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.314
          (vector-init-loop.75
           unsafe-vector-ref.3
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.129
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (eq?.72
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.281
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.315
          (vector-init-loop.75
           unsafe-vector-ref.3
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.130
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (cons.71
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.282
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.316
          (vector-init-loop.75
           unsafe-vector-ref.3
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.131
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.283
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.317
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.132
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (vector?.69
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.284
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.318
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.133
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (procedure?.68
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.285
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.319
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.134
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (pair?.67
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.286
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.320
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.135
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (error?.66
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.287
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.321
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.136
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (ascii-char?.65
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.288
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.322
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.137
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (void?.64
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.289
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.323
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.138
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (empty?.63
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.290
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.324
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.139
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (boolean?.62
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.291
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.325
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.140
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (fixnum?.61
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.292
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.326
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.141
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (procedure-arity.60
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.293
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.327
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.142
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (cdr.59
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.294
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.328
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.143
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (car.58
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.295
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.329
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.144
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.296
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.330
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.145
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.297
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.331
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1
           r12))
         (tmp.146
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (vector-length.55
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.298
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.332
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1
           r12))
         (tmp.147
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (make-vector.54
          (rsi
           x.4
           *.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.299
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.333
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           make-vector.54
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1
           r12))
         (tmp.148
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (>=.53
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.300
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.334
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           make-vector.54
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1
           r12))
         (tmp.149
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (>.52
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.301
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.335
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           make-vector.54
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1
           r12))
         (tmp.150
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (<=.51
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.302
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.336
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           make-vector.54
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1
           r12))
         (tmp.151
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (<.50
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.303
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.337
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           make-vector.54
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1
           r12))
         (tmp.152
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (|-.49|
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.304
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.338
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           make-vector.54
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1
           r12))
         (tmp.153
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (|+.48|
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.305
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.339
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           make-vector.54
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1))
         (tmp.154
          (make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (*.47
          (make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.119 (vector-ref.57 not.70 vector-set!.56 x.4 ra.309 rbp))
         (rax (rbp ra.309 x.4 vector-set!.56 not.70 vector-ref.57))
         (t.5 (tmp.6 vector-ref.57 not.70 vector-set!.56 x.4 ra.309 rbp)))))
      (begin
        (set! ra.309 r15)
        (set! tmp.276 r12)
        (set! r12 (+ r12 16))
        (set! tmp.310 (+ tmp.276 2))
        (set! tmp.125 tmp.310)
        (mset! tmp.125 -2 L.unsafe-vector-ref.3.1)
        (mset! tmp.125 6 16)
        (set! unsafe-vector-ref.3 tmp.125)
        (set! tmp.277 r12)
        (set! r12 (+ r12 16))
        (set! tmp.311 (+ tmp.277 2))
        (set! tmp.126 tmp.311)
        (mset! tmp.126 -2 L.unsafe-vector-set!.2.2)
        (mset! tmp.126 6 24)
        (set! unsafe-vector-set!.2 tmp.126)
        (set! tmp.278 r12)
        (set! r12 (+ r12 80))
        (set! tmp.312 (+ tmp.278 2))
        (set! tmp.127 tmp.312)
        (mset! tmp.127 -2 L.vector-init-loop.75.3)
        (mset! tmp.127 6 24)
        (set! vector-init-loop.75 tmp.127)
        (set! tmp.279 r12)
        (set! r12 (+ r12 80))
        (set! tmp.313 (+ tmp.279 2))
        (set! tmp.128 tmp.313)
        (mset! tmp.128 -2 L.make-init-vector.1.4)
        (mset! tmp.128 6 8)
        (set! make-init-vector.1 tmp.128)
        (set! tmp.280 r12)
        (set! r12 (+ r12 16))
        (set! tmp.314 (+ tmp.280 2))
        (set! tmp.129 tmp.314)
        (mset! tmp.129 -2 L.eq?.72.5)
        (mset! tmp.129 6 16)
        (set! eq?.72 tmp.129)
        (set! tmp.281 r12)
        (set! r12 (+ r12 16))
        (set! tmp.315 (+ tmp.281 2))
        (set! tmp.130 tmp.315)
        (mset! tmp.130 -2 L.cons.71.6)
        (mset! tmp.130 6 16)
        (set! cons.71 tmp.130)
        (set! tmp.282 r12)
        (set! r12 (+ r12 16))
        (set! tmp.316 (+ tmp.282 2))
        (set! tmp.131 tmp.316)
        (mset! tmp.131 -2 L.not.70.7)
        (mset! tmp.131 6 8)
        (set! not.70 tmp.131)
        (set! tmp.283 r12)
        (set! r12 (+ r12 16))
        (set! tmp.317 (+ tmp.283 2))
        (set! tmp.132 tmp.317)
        (mset! tmp.132 -2 L.vector?.69.8)
        (mset! tmp.132 6 8)
        (set! vector?.69 tmp.132)
        (set! tmp.284 r12)
        (set! r12 (+ r12 16))
        (set! tmp.318 (+ tmp.284 2))
        (set! tmp.133 tmp.318)
        (mset! tmp.133 -2 L.procedure?.68.9)
        (mset! tmp.133 6 8)
        (set! procedure?.68 tmp.133)
        (set! tmp.285 r12)
        (set! r12 (+ r12 16))
        (set! tmp.319 (+ tmp.285 2))
        (set! tmp.134 tmp.319)
        (mset! tmp.134 -2 L.pair?.67.10)
        (mset! tmp.134 6 8)
        (set! pair?.67 tmp.134)
        (set! tmp.286 r12)
        (set! r12 (+ r12 16))
        (set! tmp.320 (+ tmp.286 2))
        (set! tmp.135 tmp.320)
        (mset! tmp.135 -2 L.error?.66.11)
        (mset! tmp.135 6 8)
        (set! error?.66 tmp.135)
        (set! tmp.287 r12)
        (set! r12 (+ r12 16))
        (set! tmp.321 (+ tmp.287 2))
        (set! tmp.136 tmp.321)
        (mset! tmp.136 -2 L.ascii-char?.65.12)
        (mset! tmp.136 6 8)
        (set! ascii-char?.65 tmp.136)
        (set! tmp.288 r12)
        (set! r12 (+ r12 16))
        (set! tmp.322 (+ tmp.288 2))
        (set! tmp.137 tmp.322)
        (mset! tmp.137 -2 L.void?.64.13)
        (mset! tmp.137 6 8)
        (set! void?.64 tmp.137)
        (set! tmp.289 r12)
        (set! r12 (+ r12 16))
        (set! tmp.323 (+ tmp.289 2))
        (set! tmp.138 tmp.323)
        (mset! tmp.138 -2 L.empty?.63.14)
        (mset! tmp.138 6 8)
        (set! empty?.63 tmp.138)
        (set! tmp.290 r12)
        (set! r12 (+ r12 16))
        (set! tmp.324 (+ tmp.290 2))
        (set! tmp.139 tmp.324)
        (mset! tmp.139 -2 L.boolean?.62.15)
        (mset! tmp.139 6 8)
        (set! boolean?.62 tmp.139)
        (set! tmp.291 r12)
        (set! r12 (+ r12 16))
        (set! tmp.325 (+ tmp.291 2))
        (set! tmp.140 tmp.325)
        (mset! tmp.140 -2 L.fixnum?.61.16)
        (mset! tmp.140 6 8)
        (set! fixnum?.61 tmp.140)
        (set! tmp.292 r12)
        (set! r12 (+ r12 16))
        (set! tmp.326 (+ tmp.292 2))
        (set! tmp.141 tmp.326)
        (mset! tmp.141 -2 L.procedure-arity.60.17)
        (mset! tmp.141 6 8)
        (set! procedure-arity.60 tmp.141)
        (set! tmp.293 r12)
        (set! r12 (+ r12 16))
        (set! tmp.327 (+ tmp.293 2))
        (set! tmp.142 tmp.327)
        (mset! tmp.142 -2 L.cdr.59.18)
        (mset! tmp.142 6 8)
        (set! cdr.59 tmp.142)
        (set! tmp.294 r12)
        (set! r12 (+ r12 16))
        (set! tmp.328 (+ tmp.294 2))
        (set! tmp.143 tmp.328)
        (mset! tmp.143 -2 L.car.58.19)
        (mset! tmp.143 6 8)
        (set! car.58 tmp.143)
        (set! tmp.295 r12)
        (set! r12 (+ r12 80))
        (set! tmp.329 (+ tmp.295 2))
        (set! tmp.144 tmp.329)
        (mset! tmp.144 -2 L.vector-ref.57.20)
        (mset! tmp.144 6 16)
        (set! vector-ref.57 tmp.144)
        (set! tmp.296 r12)
        (set! r12 (+ r12 80))
        (set! tmp.330 (+ tmp.296 2))
        (set! tmp.145 tmp.330)
        (mset! tmp.145 -2 L.vector-set!.56.21)
        (mset! tmp.145 6 24)
        (set! vector-set!.56 tmp.145)
        (set! tmp.297 r12)
        (set! r12 (+ r12 16))
        (set! tmp.331 (+ tmp.297 2))
        (set! tmp.146 tmp.331)
        (mset! tmp.146 -2 L.vector-length.55.22)
        (mset! tmp.146 6 8)
        (set! vector-length.55 tmp.146)
        (set! tmp.298 r12)
        (set! r12 (+ r12 80))
        (set! tmp.332 (+ tmp.298 2))
        (set! tmp.147 tmp.332)
        (mset! tmp.147 -2 L.make-vector.54.23)
        (mset! tmp.147 6 8)
        (set! make-vector.54 tmp.147)
        (set! tmp.299 r12)
        (set! r12 (+ r12 16))
        (set! tmp.333 (+ tmp.299 2))
        (set! tmp.148 tmp.333)
        (mset! tmp.148 -2 L.>=.53.24)
        (mset! tmp.148 6 16)
        (set! >=.53 tmp.148)
        (set! tmp.300 r12)
        (set! r12 (+ r12 16))
        (set! tmp.334 (+ tmp.300 2))
        (set! tmp.149 tmp.334)
        (mset! tmp.149 -2 L.>.52.25)
        (mset! tmp.149 6 16)
        (set! >.52 tmp.149)
        (set! tmp.301 r12)
        (set! r12 (+ r12 16))
        (set! tmp.335 (+ tmp.301 2))
        (set! tmp.150 tmp.335)
        (mset! tmp.150 -2 L.<=.51.26)
        (mset! tmp.150 6 16)
        (set! <=.51 tmp.150)
        (set! tmp.302 r12)
        (set! r12 (+ r12 16))
        (set! tmp.336 (+ tmp.302 2))
        (set! tmp.151 tmp.336)
        (mset! tmp.151 -2 L.<.50.27)
        (mset! tmp.151 6 16)
        (set! <.50 tmp.151)
        (set! tmp.303 r12)
        (set! r12 (+ r12 16))
        (set! tmp.337 (+ tmp.303 2))
        (set! tmp.152 tmp.337)
        (mset! tmp.152 -2 L.-.49.28)
        (mset! tmp.152 6 16)
        (set! |-.49| tmp.152)
        (set! tmp.304 r12)
        (set! r12 (+ r12 16))
        (set! tmp.338 (+ tmp.304 2))
        (set! tmp.153 tmp.338)
        (mset! tmp.153 -2 L.+.48.29)
        (mset! tmp.153 6 16)
        (set! |+.48| tmp.153)
        (set! tmp.305 r12)
        (set! r12 (+ r12 16))
        (set! tmp.339 (+ tmp.305 2))
        (set! tmp.154 tmp.339)
        (mset! tmp.154 -2 L.*.47.30)
        (mset! tmp.154 6 16)
        (set! *.47 tmp.154)
        (mset! vector-init-loop.75 14 vector-init-loop.75)
        (mset! make-init-vector.1 14 vector-init-loop.75)
        (mset! vector-ref.57 14 unsafe-vector-ref.3)
        (mset! vector-set!.56 14 unsafe-vector-set!.2)
        (mset! make-vector.54 14 make-init-vector.1)
        (set! x.4 14)
        (set! tmp.119 make-vector.54)
        (return-point L.rp.105
          (begin
            (set! rsi 8)
            (set! rdi make-vector.54)
            (set! r15 L.rp.105)
            (jump L.make-vector.54.23 rbp r15 rsi rdi)))
        (set! t.5 rax)
        (set! tmp.6 14)
        (if (neq? tmp.6 6)
          (begin
            (set! r9 t.5)
            (set! r8 vector-ref.57)
            (set! rcx not.70)
            (set! rdx vector-set!.56)
            (set! rsi x.4)
            (set! rdi tmp.6)
            (set! r15 ra.309)
            (jump L.jp.103 rbp r15 r9 r8 rcx rdx rsi rdi))
          (begin
            (set! r9 t.5)
            (set! r8 vector-ref.57)
            (set! rcx not.70)
            (set! rdx vector-set!.56)
            (set! rsi x.4)
            (set! rdi 6)
            (set! r15 ra.309)
            (jump L.jp.103 rbp r15 r9 r8 rcx rdx rsi rdi)))))
    (define L.*.47.30
      ((new-frames ())
       (locals (tmp.341 c.113 tmp.161 ra.340 tmp.9 tmp.10))
       (undead-out
        ((rdi rsi rdx ra.340 rbp)
         (rsi rdx ra.340 rbp)
         (rdx tmp.9 ra.340 rbp)
         (tmp.10 tmp.9 ra.340 rbp)
         (tmp.341 tmp.10 tmp.9 ra.340 rbp)
         (tmp.161 tmp.10 tmp.9 ra.340 rbp)
         ((tmp.10 tmp.9 ra.340 rbp)
          ((tmp.9 ra.340 rdx rbp)
           (ra.340 rsi rdx rbp)
           (ra.340 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.9 ra.340 rdx rbp)
           (ra.340 rsi rdx rbp)
           (ra.340 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.113 r15 rdi rsi tmp.9 ra.340 rbp))
         (rbp (tmp.161 tmp.341 tmp.10 tmp.9 c.113 ra.340 r15 rdi rsi rdx))
         (ra.340 (tmp.161 tmp.341 tmp.10 tmp.9 c.113 rbp rdi rsi rdx))
         (tmp.9 (tmp.161 tmp.341 tmp.10 ra.340 rbp rdx))
         (rsi (c.113 r15 rdi ra.340 rdx rbp))
         (rdi (r15 ra.340 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.113 (rsi rdx ra.340 rbp))
         (tmp.10 (tmp.161 tmp.341 tmp.9 ra.340 rbp))
         (tmp.341 (rbp ra.340 tmp.9 tmp.10))
         (tmp.161 (tmp.10 tmp.9 ra.340 rbp)))))
      (begin
        (set! ra.340 r15)
        (set! c.113 rdi)
        (set! tmp.9 rsi)
        (set! tmp.10 rdx)
        (set! tmp.341 (bitwise-and tmp.10 7))
        (set! tmp.161 tmp.341)
        (if (eq? tmp.161 0)
          (begin
            (set! rdx tmp.10)
            (set! rsi tmp.9)
            (set! rdi 14)
            (set! r15 ra.340)
            (jump L.jp.34 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.10)
            (set! rsi tmp.9)
            (set! rdi 6)
            (set! r15 ra.340)
            (jump L.jp.34 rbp r15 rdx rsi rdi)))))
    (define L.+.48.29
      ((new-frames ())
       (locals (tmp.343 c.112 tmp.167 ra.342 tmp.11 tmp.12))
       (undead-out
        ((rdi rsi rdx ra.342 rbp)
         (rsi rdx ra.342 rbp)
         (rdx tmp.11 ra.342 rbp)
         (tmp.12 tmp.11 ra.342 rbp)
         (tmp.343 tmp.12 tmp.11 ra.342 rbp)
         (tmp.167 tmp.12 tmp.11 ra.342 rbp)
         ((tmp.12 tmp.11 ra.342 rbp)
          ((tmp.11 ra.342 rdx rbp)
           (ra.342 rsi rdx rbp)
           (ra.342 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.11 ra.342 rdx rbp)
           (ra.342 rsi rdx rbp)
           (ra.342 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.112 r15 rdi rsi tmp.11 ra.342 rbp))
         (rbp (tmp.167 tmp.343 tmp.12 tmp.11 c.112 ra.342 r15 rdi rsi rdx))
         (ra.342 (tmp.167 tmp.343 tmp.12 tmp.11 c.112 rbp rdi rsi rdx))
         (tmp.11 (tmp.167 tmp.343 tmp.12 ra.342 rbp rdx))
         (rsi (c.112 r15 rdi ra.342 rdx rbp))
         (rdi (r15 ra.342 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.112 (rsi rdx ra.342 rbp))
         (tmp.12 (tmp.167 tmp.343 tmp.11 ra.342 rbp))
         (tmp.343 (rbp ra.342 tmp.11 tmp.12))
         (tmp.167 (tmp.12 tmp.11 ra.342 rbp)))))
      (begin
        (set! ra.342 r15)
        (set! c.112 rdi)
        (set! tmp.11 rsi)
        (set! tmp.12 rdx)
        (set! tmp.343 (bitwise-and tmp.12 7))
        (set! tmp.167 tmp.343)
        (if (eq? tmp.167 0)
          (begin
            (set! rdx tmp.12)
            (set! rsi tmp.11)
            (set! rdi 14)
            (set! r15 ra.342)
            (jump L.jp.38 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.12)
            (set! rsi tmp.11)
            (set! rdi 6)
            (set! r15 ra.342)
            (jump L.jp.38 rbp r15 rdx rsi rdi)))))
    (define L.-.49.28
      ((new-frames ())
       (locals (tmp.345 c.111 tmp.173 ra.344 tmp.13 tmp.14))
       (undead-out
        ((rdi rsi rdx ra.344 rbp)
         (rsi rdx ra.344 rbp)
         (rdx tmp.13 ra.344 rbp)
         (tmp.14 tmp.13 ra.344 rbp)
         (tmp.345 tmp.14 tmp.13 ra.344 rbp)
         (tmp.173 tmp.14 tmp.13 ra.344 rbp)
         ((tmp.14 tmp.13 ra.344 rbp)
          ((tmp.13 ra.344 rdx rbp)
           (ra.344 rsi rdx rbp)
           (ra.344 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.13 ra.344 rdx rbp)
           (ra.344 rsi rdx rbp)
           (ra.344 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.111 r15 rdi rsi tmp.13 ra.344 rbp))
         (rbp (tmp.173 tmp.345 tmp.14 tmp.13 c.111 ra.344 r15 rdi rsi rdx))
         (ra.344 (tmp.173 tmp.345 tmp.14 tmp.13 c.111 rbp rdi rsi rdx))
         (tmp.13 (tmp.173 tmp.345 tmp.14 ra.344 rbp rdx))
         (rsi (c.111 r15 rdi ra.344 rdx rbp))
         (rdi (r15 ra.344 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.111 (rsi rdx ra.344 rbp))
         (tmp.14 (tmp.173 tmp.345 tmp.13 ra.344 rbp))
         (tmp.345 (rbp ra.344 tmp.13 tmp.14))
         (tmp.173 (tmp.14 tmp.13 ra.344 rbp)))))
      (begin
        (set! ra.344 r15)
        (set! c.111 rdi)
        (set! tmp.13 rsi)
        (set! tmp.14 rdx)
        (set! tmp.345 (bitwise-and tmp.14 7))
        (set! tmp.173 tmp.345)
        (if (eq? tmp.173 0)
          (begin
            (set! rdx tmp.14)
            (set! rsi tmp.13)
            (set! rdi 14)
            (set! r15 ra.344)
            (jump L.jp.42 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.14)
            (set! rsi tmp.13)
            (set! rdi 6)
            (set! r15 ra.344)
            (jump L.jp.42 rbp r15 rdx rsi rdi)))))
    (define L.<.50.27
      ((new-frames ())
       (locals (tmp.347 c.110 tmp.180 ra.346 tmp.15 tmp.16))
       (undead-out
        ((rdi rsi rdx ra.346 rbp)
         (rsi rdx ra.346 rbp)
         (rdx tmp.15 ra.346 rbp)
         (tmp.16 tmp.15 ra.346 rbp)
         (tmp.347 tmp.16 tmp.15 ra.346 rbp)
         (tmp.180 tmp.16 tmp.15 ra.346 rbp)
         ((tmp.16 tmp.15 ra.346 rbp)
          ((tmp.15 ra.346 rdx rbp)
           (ra.346 rsi rdx rbp)
           (ra.346 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.15 ra.346 rdx rbp)
           (ra.346 rsi rdx rbp)
           (ra.346 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.110 r15 rdi rsi tmp.15 ra.346 rbp))
         (rbp (tmp.180 tmp.347 tmp.16 tmp.15 c.110 ra.346 r15 rdi rsi rdx))
         (ra.346 (tmp.180 tmp.347 tmp.16 tmp.15 c.110 rbp rdi rsi rdx))
         (tmp.15 (tmp.180 tmp.347 tmp.16 ra.346 rbp rdx))
         (rsi (c.110 r15 rdi ra.346 rdx rbp))
         (rdi (r15 ra.346 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.110 (rsi rdx ra.346 rbp))
         (tmp.16 (tmp.180 tmp.347 tmp.15 ra.346 rbp))
         (tmp.347 (rbp ra.346 tmp.15 tmp.16))
         (tmp.180 (tmp.16 tmp.15 ra.346 rbp)))))
      (begin
        (set! ra.346 r15)
        (set! c.110 rdi)
        (set! tmp.15 rsi)
        (set! tmp.16 rdx)
        (set! tmp.347 (bitwise-and tmp.16 7))
        (set! tmp.180 tmp.347)
        (if (eq? tmp.180 0)
          (begin
            (set! rdx tmp.16)
            (set! rsi tmp.15)
            (set! rdi 14)
            (set! r15 ra.346)
            (jump L.jp.47 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.16)
            (set! rsi tmp.15)
            (set! rdi 6)
            (set! r15 ra.346)
            (jump L.jp.47 rbp r15 rdx rsi rdi)))))
    (define L.<=.51.26
      ((new-frames ())
       (locals (tmp.349 c.109 tmp.187 ra.348 tmp.17 tmp.18))
       (undead-out
        ((rdi rsi rdx ra.348 rbp)
         (rsi rdx ra.348 rbp)
         (rdx tmp.17 ra.348 rbp)
         (tmp.18 tmp.17 ra.348 rbp)
         (tmp.349 tmp.18 tmp.17 ra.348 rbp)
         (tmp.187 tmp.18 tmp.17 ra.348 rbp)
         ((tmp.18 tmp.17 ra.348 rbp)
          ((tmp.17 ra.348 rdx rbp)
           (ra.348 rsi rdx rbp)
           (ra.348 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.17 ra.348 rdx rbp)
           (ra.348 rsi rdx rbp)
           (ra.348 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.109 r15 rdi rsi tmp.17 ra.348 rbp))
         (rbp (tmp.187 tmp.349 tmp.18 tmp.17 c.109 ra.348 r15 rdi rsi rdx))
         (ra.348 (tmp.187 tmp.349 tmp.18 tmp.17 c.109 rbp rdi rsi rdx))
         (tmp.17 (tmp.187 tmp.349 tmp.18 ra.348 rbp rdx))
         (rsi (c.109 r15 rdi ra.348 rdx rbp))
         (rdi (r15 ra.348 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.109 (rsi rdx ra.348 rbp))
         (tmp.18 (tmp.187 tmp.349 tmp.17 ra.348 rbp))
         (tmp.349 (rbp ra.348 tmp.17 tmp.18))
         (tmp.187 (tmp.18 tmp.17 ra.348 rbp)))))
      (begin
        (set! ra.348 r15)
        (set! c.109 rdi)
        (set! tmp.17 rsi)
        (set! tmp.18 rdx)
        (set! tmp.349 (bitwise-and tmp.18 7))
        (set! tmp.187 tmp.349)
        (if (eq? tmp.187 0)
          (begin
            (set! rdx tmp.18)
            (set! rsi tmp.17)
            (set! rdi 14)
            (set! r15 ra.348)
            (jump L.jp.52 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.18)
            (set! rsi tmp.17)
            (set! rdi 6)
            (set! r15 ra.348)
            (jump L.jp.52 rbp r15 rdx rsi rdi)))))
    (define L.>.52.25
      ((new-frames ())
       (locals (tmp.351 c.108 tmp.194 ra.350 tmp.19 tmp.20))
       (undead-out
        ((rdi rsi rdx ra.350 rbp)
         (rsi rdx ra.350 rbp)
         (rdx tmp.19 ra.350 rbp)
         (tmp.20 tmp.19 ra.350 rbp)
         (tmp.351 tmp.20 tmp.19 ra.350 rbp)
         (tmp.194 tmp.20 tmp.19 ra.350 rbp)
         ((tmp.20 tmp.19 ra.350 rbp)
          ((tmp.19 ra.350 rdx rbp)
           (ra.350 rsi rdx rbp)
           (ra.350 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.19 ra.350 rdx rbp)
           (ra.350 rsi rdx rbp)
           (ra.350 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.108 r15 rdi rsi tmp.19 ra.350 rbp))
         (rbp (tmp.194 tmp.351 tmp.20 tmp.19 c.108 ra.350 r15 rdi rsi rdx))
         (ra.350 (tmp.194 tmp.351 tmp.20 tmp.19 c.108 rbp rdi rsi rdx))
         (tmp.19 (tmp.194 tmp.351 tmp.20 ra.350 rbp rdx))
         (rsi (c.108 r15 rdi ra.350 rdx rbp))
         (rdi (r15 ra.350 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.108 (rsi rdx ra.350 rbp))
         (tmp.20 (tmp.194 tmp.351 tmp.19 ra.350 rbp))
         (tmp.351 (rbp ra.350 tmp.19 tmp.20))
         (tmp.194 (tmp.20 tmp.19 ra.350 rbp)))))
      (begin
        (set! ra.350 r15)
        (set! c.108 rdi)
        (set! tmp.19 rsi)
        (set! tmp.20 rdx)
        (set! tmp.351 (bitwise-and tmp.20 7))
        (set! tmp.194 tmp.351)
        (if (eq? tmp.194 0)
          (begin
            (set! rdx tmp.20)
            (set! rsi tmp.19)
            (set! rdi 14)
            (set! r15 ra.350)
            (jump L.jp.57 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.20)
            (set! rsi tmp.19)
            (set! rdi 6)
            (set! r15 ra.350)
            (jump L.jp.57 rbp r15 rdx rsi rdi)))))
    (define L.>=.53.24
      ((new-frames ())
       (locals (tmp.353 c.107 tmp.201 ra.352 tmp.21 tmp.22))
       (undead-out
        ((rdi rsi rdx ra.352 rbp)
         (rsi rdx ra.352 rbp)
         (rdx tmp.21 ra.352 rbp)
         (tmp.22 tmp.21 ra.352 rbp)
         (tmp.353 tmp.22 tmp.21 ra.352 rbp)
         (tmp.201 tmp.22 tmp.21 ra.352 rbp)
         ((tmp.22 tmp.21 ra.352 rbp)
          ((tmp.21 ra.352 rdx rbp)
           (ra.352 rsi rdx rbp)
           (ra.352 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.21 ra.352 rdx rbp)
           (ra.352 rsi rdx rbp)
           (ra.352 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.107 r15 rdi rsi tmp.21 ra.352 rbp))
         (rbp (tmp.201 tmp.353 tmp.22 tmp.21 c.107 ra.352 r15 rdi rsi rdx))
         (ra.352 (tmp.201 tmp.353 tmp.22 tmp.21 c.107 rbp rdi rsi rdx))
         (tmp.21 (tmp.201 tmp.353 tmp.22 ra.352 rbp rdx))
         (rsi (c.107 r15 rdi ra.352 rdx rbp))
         (rdi (r15 ra.352 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.107 (rsi rdx ra.352 rbp))
         (tmp.22 (tmp.201 tmp.353 tmp.21 ra.352 rbp))
         (tmp.353 (rbp ra.352 tmp.21 tmp.22))
         (tmp.201 (tmp.22 tmp.21 ra.352 rbp)))))
      (begin
        (set! ra.352 r15)
        (set! c.107 rdi)
        (set! tmp.21 rsi)
        (set! tmp.22 rdx)
        (set! tmp.353 (bitwise-and tmp.22 7))
        (set! tmp.201 tmp.353)
        (if (eq? tmp.201 0)
          (begin
            (set! rdx tmp.22)
            (set! rsi tmp.21)
            (set! rdi 14)
            (set! r15 ra.352)
            (jump L.jp.62 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.22)
            (set! rsi tmp.21)
            (set! rdi 6)
            (set! r15 ra.352)
            (jump L.jp.62 rbp r15 rdx rsi rdi)))))
    (define L.make-vector.54.23
      ((new-frames ())
       (locals (tmp.355 c.106 tmp.204 ra.354 make-init-vector.1 tmp.23))
       (undead-out
        ((rdi rsi ra.354 rbp)
         (rsi c.106 ra.354 rbp)
         (c.106 tmp.23 ra.354 rbp)
         (tmp.23 make-init-vector.1 ra.354 rbp)
         (tmp.355 tmp.23 make-init-vector.1 ra.354 rbp)
         (tmp.204 tmp.23 make-init-vector.1 ra.354 rbp)
         ((tmp.23 make-init-vector.1 ra.354 rbp)
          ((make-init-vector.1 ra.354 rdx rbp)
           (ra.354 rsi rdx rbp)
           (ra.354 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((make-init-vector.1 ra.354 rdx rbp)
           (ra.354 rsi rdx rbp)
           (ra.354 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (r15 rdi rsi make-init-vector.1 ra.354 rbp))
         (rbp
          (tmp.204
           tmp.355
           make-init-vector.1
           tmp.23
           c.106
           ra.354
           r15
           rdi
           rsi
           rdx))
         (ra.354
          (tmp.204 tmp.355 make-init-vector.1 tmp.23 c.106 rbp rdi rsi rdx))
         (make-init-vector.1 (tmp.204 tmp.355 rbp ra.354 tmp.23 rdx))
         (rsi (c.106 r15 rdi ra.354 rdx rbp))
         (rdi (r15 ra.354 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.106 (tmp.23 rsi ra.354 rbp))
         (tmp.23 (tmp.204 tmp.355 make-init-vector.1 c.106 ra.354 rbp))
         (tmp.355 (rbp ra.354 make-init-vector.1 tmp.23))
         (tmp.204 (tmp.23 make-init-vector.1 ra.354 rbp)))))
      (begin
        (set! ra.354 r15)
        (set! c.106 rdi)
        (set! tmp.23 rsi)
        (set! make-init-vector.1 (mref c.106 14))
        (set! tmp.355 (bitwise-and tmp.23 7))
        (set! tmp.204 tmp.355)
        (if (eq? tmp.204 0)
          (begin
            (set! rdx tmp.23)
            (set! rsi make-init-vector.1)
            (set! rdi 14)
            (set! r15 ra.354)
            (jump L.jp.64 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.23)
            (set! rsi make-init-vector.1)
            (set! rdi 6)
            (set! r15 ra.354)
            (jump L.jp.64 rbp r15 rdx rsi rdi)))))
    (define L.vector-length.55.22
      ((new-frames ())
       (locals (tmp.357 c.105 tmp.207 ra.356 tmp.24))
       (undead-out
        ((rdi rsi ra.356 rbp)
         (rsi ra.356 rbp)
         (tmp.24 ra.356 rbp)
         (tmp.357 tmp.24 ra.356 rbp)
         (tmp.207 tmp.24 ra.356 rbp)
         ((tmp.24 ra.356 rbp)
          ((ra.356 rsi rbp)
           (ra.356 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp))
          ((ra.356 rsi rbp)
           (ra.356 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rsi (c.105 r15 rdi ra.356 rbp))
         (rbp (tmp.207 tmp.357 tmp.24 c.105 ra.356 r15 rdi rsi))
         (ra.356 (tmp.207 tmp.357 tmp.24 c.105 rbp rdi rsi))
         (rdi (r15 ra.356 rsi rbp))
         (r15 (rdi rsi rbp))
         (c.105 (rsi ra.356 rbp))
         (tmp.24 (tmp.207 tmp.357 ra.356 rbp))
         (tmp.357 (rbp ra.356 tmp.24))
         (tmp.207 (tmp.24 ra.356 rbp)))))
      (begin
        (set! ra.356 r15)
        (set! c.105 rdi)
        (set! tmp.24 rsi)
        (set! tmp.357 (bitwise-and tmp.24 7))
        (set! tmp.207 tmp.357)
        (if (eq? tmp.207 3)
          (begin
            (set! rsi tmp.24)
            (set! rdi 14)
            (set! r15 ra.356)
            (jump L.jp.66 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.24)
            (set! rdi 6)
            (set! r15 ra.356)
            (jump L.jp.66 rbp r15 rsi rdi)))))
    (define L.vector-set!.56.21
      ((new-frames ())
       (locals
        (tmp.359
         c.104
         tmp.213
         ra.358
         tmp.25
         unsafe-vector-set!.2
         tmp.27
         tmp.26))
       (undead-out
        ((rdi rsi rdx rcx ra.358 rbp)
         (rsi rdx rcx c.104 ra.358 rbp)
         (rdx rcx c.104 tmp.25 ra.358 rbp)
         (rcx c.104 tmp.26 tmp.25 ra.358 rbp)
         (c.104 tmp.26 tmp.27 tmp.25 ra.358 rbp)
         (tmp.26 tmp.27 unsafe-vector-set!.2 tmp.25 ra.358 rbp)
         (tmp.359 tmp.26 tmp.27 unsafe-vector-set!.2 tmp.25 ra.358 rbp)
         (tmp.213 tmp.26 tmp.27 unsafe-vector-set!.2 tmp.25 ra.358 rbp)
         ((tmp.26 tmp.27 unsafe-vector-set!.2 tmp.25 ra.358 rbp)
          ((tmp.27 unsafe-vector-set!.2 tmp.25 ra.358 r8 rbp)
           (unsafe-vector-set!.2 tmp.25 ra.358 rcx r8 rbp)
           (tmp.25 ra.358 rdx rcx r8 rbp)
           (ra.358 rsi rdx rcx r8 rbp)
           (ra.358 rdi rsi rdx rcx r8 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)
           (rdi rsi rdx rcx r8 r15 rbp))
          ((tmp.27 unsafe-vector-set!.2 tmp.25 ra.358 r8 rbp)
           (unsafe-vector-set!.2 tmp.25 ra.358 rcx r8 rbp)
           (tmp.25 ra.358 rdx rcx r8 rbp)
           (ra.358 rsi rdx rcx r8 rbp)
           (ra.358 rdi rsi rdx rcx r8 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)))))
       (call-undead ())
       (conflicts
        ((r8
          (r15 rdi rsi rdx rcx tmp.27 unsafe-vector-set!.2 tmp.25 ra.358 rbp))
         (rbp
          (tmp.213
           tmp.359
           unsafe-vector-set!.2
           tmp.27
           tmp.26
           tmp.25
           c.104
           ra.358
           r15
           rdi
           rsi
           rdx
           rcx
           r8))
         (ra.358
          (tmp.213
           tmp.359
           unsafe-vector-set!.2
           tmp.27
           tmp.26
           tmp.25
           c.104
           rbp
           rdi
           rsi
           rdx
           rcx
           r8))
         (tmp.25
          (tmp.213
           tmp.359
           unsafe-vector-set!.2
           tmp.27
           tmp.26
           c.104
           ra.358
           rbp
           rdx
           rcx
           r8))
         (unsafe-vector-set!.2
          (tmp.213 tmp.359 rbp ra.358 tmp.25 tmp.27 tmp.26 rcx r8))
         (tmp.27
          (tmp.213
           tmp.359
           unsafe-vector-set!.2
           c.104
           tmp.26
           tmp.25
           ra.358
           rbp
           r8))
         (rcx
          (tmp.26
           c.104
           r15
           rdi
           rsi
           rdx
           unsafe-vector-set!.2
           tmp.25
           ra.358
           r8
           rbp))
         (rdx (c.104 r15 rdi rsi tmp.25 ra.358 rcx r8 rbp))
         (rsi (c.104 r15 rdi ra.358 rdx rcx r8 rbp))
         (rdi (r15 ra.358 rsi rdx rcx r8 rbp))
         (r15 (rdi rsi rdx rcx r8 rbp))
         (c.104 (tmp.27 tmp.26 tmp.25 rsi rdx rcx ra.358 rbp))
         (tmp.26
          (tmp.213
           tmp.359
           unsafe-vector-set!.2
           tmp.27
           rcx
           c.104
           tmp.25
           ra.358
           rbp))
         (tmp.359 (rbp ra.358 tmp.25 unsafe-vector-set!.2 tmp.27 tmp.26))
         (tmp.213 (tmp.26 tmp.27 unsafe-vector-set!.2 tmp.25 ra.358 rbp)))))
      (begin
        (set! ra.358 r15)
        (set! c.104 rdi)
        (set! tmp.25 rsi)
        (set! tmp.26 rdx)
        (set! tmp.27 rcx)
        (set! unsafe-vector-set!.2 (mref c.104 14))
        (set! tmp.359 (bitwise-and tmp.26 7))
        (set! tmp.213 tmp.359)
        (if (eq? tmp.213 0)
          (begin
            (set! r8 tmp.26)
            (set! rcx tmp.27)
            (set! rdx unsafe-vector-set!.2)
            (set! rsi tmp.25)
            (set! rdi 14)
            (set! r15 ra.358)
            (jump L.jp.70 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 tmp.26)
            (set! rcx tmp.27)
            (set! rdx unsafe-vector-set!.2)
            (set! rsi tmp.25)
            (set! rdi 6)
            (set! r15 ra.358)
            (jump L.jp.70 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.vector-ref.57.20
      ((new-frames ())
       (locals
        (tmp.361 c.103 tmp.219 ra.360 tmp.28 unsafe-vector-ref.3 tmp.29))
       (undead-out
        ((rdi rsi rdx ra.360 rbp)
         (rsi rdx c.103 ra.360 rbp)
         (rdx c.103 tmp.28 ra.360 rbp)
         (c.103 tmp.29 tmp.28 ra.360 rbp)
         (tmp.29 unsafe-vector-ref.3 tmp.28 ra.360 rbp)
         (tmp.361 tmp.29 unsafe-vector-ref.3 tmp.28 ra.360 rbp)
         (tmp.219 tmp.29 unsafe-vector-ref.3 tmp.28 ra.360 rbp)
         ((tmp.29 unsafe-vector-ref.3 tmp.28 ra.360 rbp)
          ((unsafe-vector-ref.3 tmp.28 ra.360 rcx rbp)
           (tmp.28 ra.360 rdx rcx rbp)
           (ra.360 rsi rdx rcx rbp)
           (ra.360 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp))
          ((unsafe-vector-ref.3 tmp.28 ra.360 rcx rbp)
           (tmp.28 ra.360 rdx rcx rbp)
           (ra.360 rsi rdx rcx rbp)
           (ra.360 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rcx (r15 rdi rsi rdx unsafe-vector-ref.3 tmp.28 ra.360 rbp))
         (rbp
          (tmp.219
           tmp.361
           unsafe-vector-ref.3
           tmp.29
           tmp.28
           c.103
           ra.360
           r15
           rdi
           rsi
           rdx
           rcx))
         (ra.360
          (tmp.219
           tmp.361
           unsafe-vector-ref.3
           tmp.29
           tmp.28
           c.103
           rbp
           rdi
           rsi
           rdx
           rcx))
         (tmp.28
          (tmp.219
           tmp.361
           unsafe-vector-ref.3
           tmp.29
           c.103
           ra.360
           rbp
           rdx
           rcx))
         (unsafe-vector-ref.3 (tmp.219 tmp.361 rbp ra.360 tmp.28 tmp.29 rcx))
         (rdx (c.103 r15 rdi rsi tmp.28 ra.360 rcx rbp))
         (rsi (c.103 r15 rdi ra.360 rdx rcx rbp))
         (rdi (r15 ra.360 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (c.103 (tmp.29 tmp.28 rsi rdx ra.360 rbp))
         (tmp.29 (tmp.219 tmp.361 unsafe-vector-ref.3 c.103 tmp.28 ra.360 rbp))
         (tmp.361 (rbp ra.360 tmp.28 unsafe-vector-ref.3 tmp.29))
         (tmp.219 (tmp.29 unsafe-vector-ref.3 tmp.28 ra.360 rbp)))))
      (begin
        (set! ra.360 r15)
        (set! c.103 rdi)
        (set! tmp.28 rsi)
        (set! tmp.29 rdx)
        (set! unsafe-vector-ref.3 (mref c.103 14))
        (set! tmp.361 (bitwise-and tmp.29 7))
        (set! tmp.219 tmp.361)
        (if (eq? tmp.219 0)
          (begin
            (set! rcx tmp.29)
            (set! rdx unsafe-vector-ref.3)
            (set! rsi tmp.28)
            (set! rdi 14)
            (set! r15 ra.360)
            (jump L.jp.74 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx tmp.29)
            (set! rdx unsafe-vector-ref.3)
            (set! rsi tmp.28)
            (set! rdi 6)
            (set! r15 ra.360)
            (jump L.jp.74 rbp r15 rcx rdx rsi rdi)))))
    (define L.car.58.19
      ((new-frames ())
       (locals (tmp.363 c.102 tmp.222 ra.362 tmp.30))
       (undead-out
        ((rdi rsi ra.362 rbp)
         (rsi ra.362 rbp)
         (tmp.30 ra.362 rbp)
         (tmp.363 tmp.30 ra.362 rbp)
         (tmp.222 tmp.30 ra.362 rbp)
         ((tmp.30 ra.362 rbp)
          ((ra.362 rsi rbp)
           (ra.362 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp))
          ((ra.362 rsi rbp)
           (ra.362 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rsi (c.102 r15 rdi ra.362 rbp))
         (rbp (tmp.222 tmp.363 tmp.30 c.102 ra.362 r15 rdi rsi))
         (ra.362 (tmp.222 tmp.363 tmp.30 c.102 rbp rdi rsi))
         (rdi (r15 ra.362 rsi rbp))
         (r15 (rdi rsi rbp))
         (c.102 (rsi ra.362 rbp))
         (tmp.30 (tmp.222 tmp.363 ra.362 rbp))
         (tmp.363 (rbp ra.362 tmp.30))
         (tmp.222 (tmp.30 ra.362 rbp)))))
      (begin
        (set! ra.362 r15)
        (set! c.102 rdi)
        (set! tmp.30 rsi)
        (set! tmp.363 (bitwise-and tmp.30 7))
        (set! tmp.222 tmp.363)
        (if (eq? tmp.222 1)
          (begin
            (set! rsi tmp.30)
            (set! rdi 14)
            (set! r15 ra.362)
            (jump L.jp.76 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.30)
            (set! rdi 6)
            (set! r15 ra.362)
            (jump L.jp.76 rbp r15 rsi rdi)))))
    (define L.cdr.59.18
      ((new-frames ())
       (locals (tmp.365 c.101 tmp.225 ra.364 tmp.31))
       (undead-out
        ((rdi rsi ra.364 rbp)
         (rsi ra.364 rbp)
         (tmp.31 ra.364 rbp)
         (tmp.365 tmp.31 ra.364 rbp)
         (tmp.225 tmp.31 ra.364 rbp)
         ((tmp.31 ra.364 rbp)
          ((ra.364 rsi rbp)
           (ra.364 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp))
          ((ra.364 rsi rbp)
           (ra.364 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rsi (c.101 r15 rdi ra.364 rbp))
         (rbp (tmp.225 tmp.365 tmp.31 c.101 ra.364 r15 rdi rsi))
         (ra.364 (tmp.225 tmp.365 tmp.31 c.101 rbp rdi rsi))
         (rdi (r15 ra.364 rsi rbp))
         (r15 (rdi rsi rbp))
         (c.101 (rsi ra.364 rbp))
         (tmp.31 (tmp.225 tmp.365 ra.364 rbp))
         (tmp.365 (rbp ra.364 tmp.31))
         (tmp.225 (tmp.31 ra.364 rbp)))))
      (begin
        (set! ra.364 r15)
        (set! c.101 rdi)
        (set! tmp.31 rsi)
        (set! tmp.365 (bitwise-and tmp.31 7))
        (set! tmp.225 tmp.365)
        (if (eq? tmp.225 1)
          (begin
            (set! rsi tmp.31)
            (set! rdi 14)
            (set! r15 ra.364)
            (jump L.jp.78 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.31)
            (set! rdi 6)
            (set! r15 ra.364)
            (jump L.jp.78 rbp r15 rsi rdi)))))
    (define L.procedure-arity.60.17
      ((new-frames ())
       (locals (tmp.367 c.100 tmp.228 ra.366 tmp.32))
       (undead-out
        ((rdi rsi ra.366 rbp)
         (rsi ra.366 rbp)
         (tmp.32 ra.366 rbp)
         (tmp.367 tmp.32 ra.366 rbp)
         (tmp.228 tmp.32 ra.366 rbp)
         ((tmp.32 ra.366 rbp)
          ((ra.366 rsi rbp)
           (ra.366 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp))
          ((ra.366 rsi rbp)
           (ra.366 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rsi (c.100 r15 rdi ra.366 rbp))
         (rbp (tmp.228 tmp.367 tmp.32 c.100 ra.366 r15 rdi rsi))
         (ra.366 (tmp.228 tmp.367 tmp.32 c.100 rbp rdi rsi))
         (rdi (r15 ra.366 rsi rbp))
         (r15 (rdi rsi rbp))
         (c.100 (rsi ra.366 rbp))
         (tmp.32 (tmp.228 tmp.367 ra.366 rbp))
         (tmp.367 (rbp ra.366 tmp.32))
         (tmp.228 (tmp.32 ra.366 rbp)))))
      (begin
        (set! ra.366 r15)
        (set! c.100 rdi)
        (set! tmp.32 rsi)
        (set! tmp.367 (bitwise-and tmp.32 7))
        (set! tmp.228 tmp.367)
        (if (eq? tmp.228 2)
          (begin
            (set! rsi tmp.32)
            (set! rdi 14)
            (set! r15 ra.366)
            (jump L.jp.80 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.32)
            (set! rdi 6)
            (set! r15 ra.366)
            (jump L.jp.80 rbp r15 rsi rdi)))))
    (define L.fixnum?.61.16
      ((new-frames ())
       (locals (tmp.369 tmp.33 c.99 ra.368 tmp.230))
       (undead-out
        ((rdi rsi ra.368 rbp)
         (rsi ra.368 rbp)
         (tmp.33 ra.368 rbp)
         (tmp.369 ra.368 rbp)
         (tmp.230 ra.368 rbp)
         ((ra.368 rbp)
          ((ra.368 rax rbp) (rax rbp))
          ((ra.368 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.368 rbp))
         (rbp (tmp.230 tmp.369 tmp.33 c.99 ra.368 rax))
         (ra.368 (tmp.230 tmp.369 tmp.33 c.99 rdi rsi rbp rax))
         (rsi (c.99 ra.368))
         (rdi (ra.368))
         (c.99 (rsi ra.368 rbp))
         (tmp.33 (ra.368 rbp))
         (tmp.369 (rbp ra.368))
         (tmp.230 (ra.368 rbp)))))
      (begin
        (set! ra.368 r15)
        (set! c.99 rdi)
        (set! tmp.33 rsi)
        (set! tmp.369 (bitwise-and tmp.33 7))
        (set! tmp.230 tmp.369)
        (if (eq? tmp.230 0)
          (begin (set! rax 14) (jump ra.368 rbp rax))
          (begin (set! rax 6) (jump ra.368 rbp rax)))))
    (define L.boolean?.62.15
      ((new-frames ())
       (locals (tmp.371 tmp.34 c.98 ra.370 tmp.232))
       (undead-out
        ((rdi rsi ra.370 rbp)
         (rsi ra.370 rbp)
         (tmp.34 ra.370 rbp)
         (tmp.371 ra.370 rbp)
         (tmp.232 ra.370 rbp)
         ((ra.370 rbp)
          ((ra.370 rax rbp) (rax rbp))
          ((ra.370 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.370 rbp))
         (rbp (tmp.232 tmp.371 tmp.34 c.98 ra.370 rax))
         (ra.370 (tmp.232 tmp.371 tmp.34 c.98 rdi rsi rbp rax))
         (rsi (c.98 ra.370))
         (rdi (ra.370))
         (c.98 (rsi ra.370 rbp))
         (tmp.34 (ra.370 rbp))
         (tmp.371 (rbp ra.370))
         (tmp.232 (ra.370 rbp)))))
      (begin
        (set! ra.370 r15)
        (set! c.98 rdi)
        (set! tmp.34 rsi)
        (set! tmp.371 (bitwise-and tmp.34 247))
        (set! tmp.232 tmp.371)
        (if (eq? tmp.232 6)
          (begin (set! rax 14) (jump ra.370 rbp rax))
          (begin (set! rax 6) (jump ra.370 rbp rax)))))
    (define L.empty?.63.14
      ((new-frames ())
       (locals (tmp.373 tmp.35 c.97 ra.372 tmp.234))
       (undead-out
        ((rdi rsi ra.372 rbp)
         (rsi ra.372 rbp)
         (tmp.35 ra.372 rbp)
         (tmp.373 ra.372 rbp)
         (tmp.234 ra.372 rbp)
         ((ra.372 rbp)
          ((ra.372 rax rbp) (rax rbp))
          ((ra.372 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.372 rbp))
         (rbp (tmp.234 tmp.373 tmp.35 c.97 ra.372 rax))
         (ra.372 (tmp.234 tmp.373 tmp.35 c.97 rdi rsi rbp rax))
         (rsi (c.97 ra.372))
         (rdi (ra.372))
         (c.97 (rsi ra.372 rbp))
         (tmp.35 (ra.372 rbp))
         (tmp.373 (rbp ra.372))
         (tmp.234 (ra.372 rbp)))))
      (begin
        (set! ra.372 r15)
        (set! c.97 rdi)
        (set! tmp.35 rsi)
        (set! tmp.373 (bitwise-and tmp.35 255))
        (set! tmp.234 tmp.373)
        (if (eq? tmp.234 22)
          (begin (set! rax 14) (jump ra.372 rbp rax))
          (begin (set! rax 6) (jump ra.372 rbp rax)))))
    (define L.void?.64.13
      ((new-frames ())
       (locals (tmp.375 tmp.36 c.96 ra.374 tmp.236))
       (undead-out
        ((rdi rsi ra.374 rbp)
         (rsi ra.374 rbp)
         (tmp.36 ra.374 rbp)
         (tmp.375 ra.374 rbp)
         (tmp.236 ra.374 rbp)
         ((ra.374 rbp)
          ((ra.374 rax rbp) (rax rbp))
          ((ra.374 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.374 rbp))
         (rbp (tmp.236 tmp.375 tmp.36 c.96 ra.374 rax))
         (ra.374 (tmp.236 tmp.375 tmp.36 c.96 rdi rsi rbp rax))
         (rsi (c.96 ra.374))
         (rdi (ra.374))
         (c.96 (rsi ra.374 rbp))
         (tmp.36 (ra.374 rbp))
         (tmp.375 (rbp ra.374))
         (tmp.236 (ra.374 rbp)))))
      (begin
        (set! ra.374 r15)
        (set! c.96 rdi)
        (set! tmp.36 rsi)
        (set! tmp.375 (bitwise-and tmp.36 255))
        (set! tmp.236 tmp.375)
        (if (eq? tmp.236 30)
          (begin (set! rax 14) (jump ra.374 rbp rax))
          (begin (set! rax 6) (jump ra.374 rbp rax)))))
    (define L.ascii-char?.65.12
      ((new-frames ())
       (locals (tmp.377 tmp.37 c.95 ra.376 tmp.238))
       (undead-out
        ((rdi rsi ra.376 rbp)
         (rsi ra.376 rbp)
         (tmp.37 ra.376 rbp)
         (tmp.377 ra.376 rbp)
         (tmp.238 ra.376 rbp)
         ((ra.376 rbp)
          ((ra.376 rax rbp) (rax rbp))
          ((ra.376 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.376 rbp))
         (rbp (tmp.238 tmp.377 tmp.37 c.95 ra.376 rax))
         (ra.376 (tmp.238 tmp.377 tmp.37 c.95 rdi rsi rbp rax))
         (rsi (c.95 ra.376))
         (rdi (ra.376))
         (c.95 (rsi ra.376 rbp))
         (tmp.37 (ra.376 rbp))
         (tmp.377 (rbp ra.376))
         (tmp.238 (ra.376 rbp)))))
      (begin
        (set! ra.376 r15)
        (set! c.95 rdi)
        (set! tmp.37 rsi)
        (set! tmp.377 (bitwise-and tmp.37 255))
        (set! tmp.238 tmp.377)
        (if (eq? tmp.238 46)
          (begin (set! rax 14) (jump ra.376 rbp rax))
          (begin (set! rax 6) (jump ra.376 rbp rax)))))
    (define L.error?.66.11
      ((new-frames ())
       (locals (tmp.379 tmp.38 c.94 ra.378 tmp.240))
       (undead-out
        ((rdi rsi ra.378 rbp)
         (rsi ra.378 rbp)
         (tmp.38 ra.378 rbp)
         (tmp.379 ra.378 rbp)
         (tmp.240 ra.378 rbp)
         ((ra.378 rbp)
          ((ra.378 rax rbp) (rax rbp))
          ((ra.378 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.378 rbp))
         (rbp (tmp.240 tmp.379 tmp.38 c.94 ra.378 rax))
         (ra.378 (tmp.240 tmp.379 tmp.38 c.94 rdi rsi rbp rax))
         (rsi (c.94 ra.378))
         (rdi (ra.378))
         (c.94 (rsi ra.378 rbp))
         (tmp.38 (ra.378 rbp))
         (tmp.379 (rbp ra.378))
         (tmp.240 (ra.378 rbp)))))
      (begin
        (set! ra.378 r15)
        (set! c.94 rdi)
        (set! tmp.38 rsi)
        (set! tmp.379 (bitwise-and tmp.38 255))
        (set! tmp.240 tmp.379)
        (if (eq? tmp.240 62)
          (begin (set! rax 14) (jump ra.378 rbp rax))
          (begin (set! rax 6) (jump ra.378 rbp rax)))))
    (define L.pair?.67.10
      ((new-frames ())
       (locals (tmp.381 tmp.39 c.93 ra.380 tmp.242))
       (undead-out
        ((rdi rsi ra.380 rbp)
         (rsi ra.380 rbp)
         (tmp.39 ra.380 rbp)
         (tmp.381 ra.380 rbp)
         (tmp.242 ra.380 rbp)
         ((ra.380 rbp)
          ((ra.380 rax rbp) (rax rbp))
          ((ra.380 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.380 rbp))
         (rbp (tmp.242 tmp.381 tmp.39 c.93 ra.380 rax))
         (ra.380 (tmp.242 tmp.381 tmp.39 c.93 rdi rsi rbp rax))
         (rsi (c.93 ra.380))
         (rdi (ra.380))
         (c.93 (rsi ra.380 rbp))
         (tmp.39 (ra.380 rbp))
         (tmp.381 (rbp ra.380))
         (tmp.242 (ra.380 rbp)))))
      (begin
        (set! ra.380 r15)
        (set! c.93 rdi)
        (set! tmp.39 rsi)
        (set! tmp.381 (bitwise-and tmp.39 7))
        (set! tmp.242 tmp.381)
        (if (eq? tmp.242 1)
          (begin (set! rax 14) (jump ra.380 rbp rax))
          (begin (set! rax 6) (jump ra.380 rbp rax)))))
    (define L.procedure?.68.9
      ((new-frames ())
       (locals (tmp.383 tmp.40 c.92 ra.382 tmp.244))
       (undead-out
        ((rdi rsi ra.382 rbp)
         (rsi ra.382 rbp)
         (tmp.40 ra.382 rbp)
         (tmp.383 ra.382 rbp)
         (tmp.244 ra.382 rbp)
         ((ra.382 rbp)
          ((ra.382 rax rbp) (rax rbp))
          ((ra.382 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.382 rbp))
         (rbp (tmp.244 tmp.383 tmp.40 c.92 ra.382 rax))
         (ra.382 (tmp.244 tmp.383 tmp.40 c.92 rdi rsi rbp rax))
         (rsi (c.92 ra.382))
         (rdi (ra.382))
         (c.92 (rsi ra.382 rbp))
         (tmp.40 (ra.382 rbp))
         (tmp.383 (rbp ra.382))
         (tmp.244 (ra.382 rbp)))))
      (begin
        (set! ra.382 r15)
        (set! c.92 rdi)
        (set! tmp.40 rsi)
        (set! tmp.383 (bitwise-and tmp.40 7))
        (set! tmp.244 tmp.383)
        (if (eq? tmp.244 2)
          (begin (set! rax 14) (jump ra.382 rbp rax))
          (begin (set! rax 6) (jump ra.382 rbp rax)))))
    (define L.vector?.69.8
      ((new-frames ())
       (locals (tmp.385 tmp.41 c.91 ra.384 tmp.246))
       (undead-out
        ((rdi rsi ra.384 rbp)
         (rsi ra.384 rbp)
         (tmp.41 ra.384 rbp)
         (tmp.385 ra.384 rbp)
         (tmp.246 ra.384 rbp)
         ((ra.384 rbp)
          ((ra.384 rax rbp) (rax rbp))
          ((ra.384 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.384 rbp))
         (rbp (tmp.246 tmp.385 tmp.41 c.91 ra.384 rax))
         (ra.384 (tmp.246 tmp.385 tmp.41 c.91 rdi rsi rbp rax))
         (rsi (c.91 ra.384))
         (rdi (ra.384))
         (c.91 (rsi ra.384 rbp))
         (tmp.41 (ra.384 rbp))
         (tmp.385 (rbp ra.384))
         (tmp.246 (ra.384 rbp)))))
      (begin
        (set! ra.384 r15)
        (set! c.91 rdi)
        (set! tmp.41 rsi)
        (set! tmp.385 (bitwise-and tmp.41 7))
        (set! tmp.246 tmp.385)
        (if (eq? tmp.246 3)
          (begin (set! rax 14) (jump ra.384 rbp rax))
          (begin (set! rax 6) (jump ra.384 rbp rax)))))
    (define L.not.70.7
      ((new-frames ())
       (locals (c.90 ra.386 tmp.42))
       (undead-out
        ((rdi rsi ra.386 rbp)
         (rsi ra.386 rbp)
         (tmp.42 ra.386 rbp)
         ((ra.386 rbp)
          ((ra.386 rax rbp) (rax rbp))
          ((ra.386 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.386 rbp))
         (rbp (tmp.42 c.90 ra.386 rax))
         (ra.386 (tmp.42 c.90 rdi rsi rbp rax))
         (rsi (c.90 ra.386))
         (rdi (ra.386))
         (c.90 (rsi ra.386 rbp))
         (tmp.42 (ra.386 rbp)))))
      (begin
        (set! ra.386 r15)
        (set! c.90 rdi)
        (set! tmp.42 rsi)
        (if (neq? tmp.42 6)
          (begin (set! rax 6) (jump ra.386 rbp rax))
          (begin (set! rax 14) (jump ra.386 rbp rax)))))
    (define L.cons.71.6
      ((new-frames ())
       (locals (tmp.123 tmp.388 tmp.248 tmp.44 tmp.43 c.89 ra.387))
       (undead-out
        ((rdi rsi rdx r12 ra.387 rbp)
         (rsi rdx r12 ra.387 rbp)
         (rdx r12 ra.387 rbp tmp.43)
         (r12 tmp.44 ra.387 rbp tmp.43)
         (r12 tmp.248 tmp.44 ra.387 rbp tmp.43)
         (tmp.248 tmp.44 ra.387 rbp tmp.43)
         (tmp.388 tmp.44 ra.387 rbp tmp.43)
         (tmp.44 ra.387 rbp tmp.43 tmp.123)
         (rbp ra.387 tmp.44 tmp.123)
         (tmp.123 ra.387 rbp)
         (ra.387 rax rbp)
         (rax rbp)))
       (call-undead ())
       (conflicts
        ((ra.387
          (rax tmp.123 tmp.388 tmp.248 tmp.44 tmp.43 c.89 rdi rsi rdx r12 rbp))
         (rbp (rax tmp.123 tmp.388 r12 tmp.248 tmp.44 tmp.43 c.89 ra.387))
         (r12 (rbp tmp.248 tmp.44 tmp.43 c.89 ra.387))
         (rdx (tmp.43 c.89 ra.387))
         (rsi (c.89 ra.387))
         (rdi (ra.387))
         (c.89 (rsi rdx r12 ra.387 rbp))
         (tmp.43 (tmp.123 tmp.388 tmp.248 tmp.44 rdx r12 ra.387 rbp))
         (tmp.44 (tmp.123 tmp.388 tmp.248 r12 ra.387 rbp tmp.43))
         (tmp.248 (r12 tmp.44 ra.387 rbp tmp.43))
         (tmp.388 (tmp.43 rbp ra.387 tmp.44))
         (tmp.123 (tmp.44 ra.387 rbp tmp.43))
         (rax (ra.387 rbp)))))
      (begin
        (set! ra.387 r15)
        (set! c.89 rdi)
        (set! tmp.43 rsi)
        (set! tmp.44 rdx)
        (set! tmp.248 r12)
        (set! r12 (+ r12 16))
        (set! tmp.388 (+ tmp.248 1))
        (set! tmp.123 tmp.388)
        (mset! tmp.123 -1 tmp.43)
        (mset! tmp.123 7 tmp.44)
        (set! rax tmp.123)
        (jump ra.387 rbp rax)))
    (define L.eq?.72.5
      ((new-frames ())
       (locals (c.88 ra.389 tmp.46 tmp.45))
       (undead-out
        ((rdi rsi rdx ra.389 rbp)
         (rsi rdx ra.389 rbp)
         (rdx tmp.45 ra.389 rbp)
         (tmp.45 tmp.46 ra.389 rbp)
         ((ra.389 rbp)
          ((ra.389 rax rbp) (rax rbp))
          ((ra.389 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.389 rbp))
         (rbp (tmp.46 tmp.45 c.88 ra.389 rax))
         (ra.389 (tmp.46 tmp.45 c.88 rdi rsi rdx rbp rax))
         (rdx (tmp.45 c.88 ra.389))
         (rsi (c.88 ra.389))
         (rdi (ra.389))
         (c.88 (rsi rdx ra.389 rbp))
         (tmp.45 (tmp.46 rdx ra.389 rbp))
         (tmp.46 (tmp.45 ra.389 rbp)))))
      (begin
        (set! ra.389 r15)
        (set! c.88 rdi)
        (set! tmp.45 rsi)
        (set! tmp.46 rdx)
        (if (eq? tmp.45 tmp.46)
          (begin (set! rax 14) (jump ra.389 rbp rax))
          (begin (set! rax 6) (jump ra.389 rbp rax)))))
    (define L.make-init-vector.1.4
      ((new-frames ())
       (locals
        (tmp.115
         tmp.74
         tmp.124
         tmp.395
         tmp.253
         tmp.483
         tmp.252
         tmp.394
         tmp.251
         tmp.393
         tmp.392
         tmp.250
         tmp.391
         vector-init-loop.75
         tmp.73
         c.87
         ra.390))
       (undead-out
        ((rdi rsi r12 rbp ra.390)
         (rsi c.87 r12 rbp ra.390)
         (c.87 r12 rbp ra.390 tmp.73)
         (r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.391 r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.250 r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.250 tmp.392 r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.393 r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.251 r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.394 r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.252 r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.483 r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.483 r12 tmp.253 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.253 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.395 rbp ra.390 vector-init-loop.75 tmp.73)
         (rbp ra.390 vector-init-loop.75 tmp.73 tmp.124)
         (tmp.124 tmp.73 vector-init-loop.75 ra.390 rbp)
         (tmp.74 tmp.73 vector-init-loop.75 ra.390 rbp)
         (tmp.74 tmp.73 vector-init-loop.75 ra.390 rbp)
         (tmp.73 vector-init-loop.75 ra.390 rcx rbp)
         (tmp.73 vector-init-loop.75 ra.390 rdx rcx rbp)
         (vector-init-loop.75 ra.390 rsi rdx rcx rbp)
         (ra.390 rdi rsi rdx rcx rbp)
         (rdi rsi rdx rcx r15 rbp)
         (rdi rsi rdx rcx r15 rbp)))
       (call-undead ())
       (conflicts
        ((ra.390
          (rdx
           rcx
           tmp.115
           tmp.74
           tmp.124
           tmp.395
           tmp.253
           tmp.483
           tmp.252
           tmp.394
           tmp.251
           tmp.393
           tmp.392
           tmp.250
           tmp.391
           vector-init-loop.75
           tmp.73
           c.87
           rdi
           rsi
           r12
           rbp))
         (rbp
          (r15
           rdi
           rsi
           rdx
           rcx
           tmp.115
           tmp.74
           tmp.124
           tmp.395
           r12
           tmp.253
           tmp.483
           tmp.252
           tmp.394
           tmp.251
           tmp.393
           tmp.392
           tmp.250
           tmp.391
           vector-init-loop.75
           tmp.73
           c.87
           ra.390))
         (r12
          (rbp
           tmp.253
           tmp.483
           tmp.252
           tmp.394
           tmp.251
           tmp.393
           tmp.392
           tmp.250
           tmp.391
           vector-init-loop.75
           tmp.73
           c.87
           ra.390))
         (rsi (r15 rdi vector-init-loop.75 rdx rcx rbp c.87 ra.390))
         (rdi (r15 rsi rdx rcx rbp ra.390))
         (c.87 (tmp.73 rsi r12 rbp ra.390))
         (tmp.73
          (rdx
           rcx
           tmp.115
           tmp.74
           tmp.124
           tmp.395
           tmp.253
           tmp.483
           tmp.252
           tmp.394
           tmp.251
           tmp.393
           tmp.392
           tmp.250
           tmp.391
           vector-init-loop.75
           c.87
           r12
           rbp
           ra.390))
         (vector-init-loop.75
          (rsi
           rdx
           rcx
           tmp.74
           tmp.124
           tmp.395
           tmp.253
           tmp.483
           tmp.252
           tmp.394
           tmp.251
           tmp.393
           tmp.392
           tmp.250
           tmp.391
           tmp.73
           ra.390
           rbp
           r12))
         (tmp.391 (tmp.73 vector-init-loop.75 ra.390 rbp r12))
         (tmp.250 (tmp.392 r12 rbp ra.390 vector-init-loop.75 tmp.73))
         (tmp.392 (tmp.250 r12 rbp ra.390 vector-init-loop.75 tmp.73))
         (tmp.393 (tmp.73 vector-init-loop.75 ra.390 rbp r12))
         (tmp.251 (r12 rbp ra.390 vector-init-loop.75 tmp.73))
         (tmp.394 (tmp.73 vector-init-loop.75 ra.390 rbp r12))
         (tmp.252 (r12 rbp ra.390 vector-init-loop.75 tmp.73))
         (tmp.483 (tmp.253 r12 rbp ra.390 vector-init-loop.75 tmp.73))
         (tmp.253 (r12 tmp.483 rbp ra.390 vector-init-loop.75 tmp.73))
         (tmp.395 (tmp.73 vector-init-loop.75 ra.390 rbp))
         (tmp.124 (rbp ra.390 vector-init-loop.75 tmp.73))
         (tmp.74 (tmp.115 tmp.73 vector-init-loop.75 ra.390 rbp))
         (tmp.115 (tmp.74 tmp.73 ra.390 rbp))
         (rcx (r15 rdi rsi rdx tmp.73 vector-init-loop.75 ra.390 rbp))
         (rdx (r15 rdi rsi tmp.73 vector-init-loop.75 ra.390 rcx rbp))
         (r15 (rdi rsi rdx rcx rbp)))))
      (begin
        (set! ra.390 r15)
        (set! c.87 rdi)
        (set! tmp.73 rsi)
        (set! vector-init-loop.75 (mref c.87 14))
        (set! tmp.391 (arithmetic-shift-right tmp.73 3))
        (set! tmp.250 tmp.391)
        (set! tmp.392 1)
        (set! tmp.393 (+ tmp.392 tmp.250))
        (set! tmp.251 tmp.393)
        (set! tmp.394 (* tmp.251 8))
        (set! tmp.252 tmp.394)
        (set! tmp.483 tmp.252)
        (set! tmp.253 r12)
        (set! r12 (+ r12 tmp.483))
        (set! tmp.395 (+ tmp.253 3))
        (set! tmp.124 tmp.395)
        (mset! tmp.124 -3 tmp.73)
        (set! tmp.74 tmp.124)
        (set! tmp.115 vector-init-loop.75)
        (set! rcx tmp.74)
        (set! rdx 0)
        (set! rsi tmp.73)
        (set! rdi vector-init-loop.75)
        (set! r15 ra.390)
        (jump L.vector-init-loop.75.3 rbp r15 rcx rdx rsi rdi)))
    (define L.vector-init-loop.75.3
      ((new-frames ())
       (locals (c.86 ra.396 i.78 len.76 vector-init-loop.75 vec.77))
       (undead-out
        ((rdi rsi rdx rcx ra.396 rbp)
         (rsi rdx rcx c.86 ra.396 rbp)
         (rdx rcx c.86 len.76 ra.396 rbp)
         (rcx c.86 len.76 i.78 ra.396 rbp)
         (c.86 vec.77 len.76 i.78 ra.396 rbp)
         (vec.77 vector-init-loop.75 len.76 i.78 ra.396 rbp)
         ((vec.77 vector-init-loop.75 len.76 i.78 ra.396 rbp)
          ((vector-init-loop.75 len.76 i.78 ra.396 r8 rbp)
           (len.76 i.78 ra.396 rcx r8 rbp)
           (i.78 ra.396 rdx rcx r8 rbp)
           (ra.396 rsi rdx rcx r8 rbp)
           (ra.396 rdi rsi rdx rcx r8 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)
           (rdi rsi rdx rcx r8 r15 rbp))
          ((vector-init-loop.75 len.76 i.78 ra.396 r8 rbp)
           (len.76 i.78 ra.396 rcx r8 rbp)
           (i.78 ra.396 rdx rcx r8 rbp)
           (ra.396 rsi rdx rcx r8 rbp)
           (ra.396 rdi rsi rdx rcx r8 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)))))
       (call-undead ())
       (conflicts
        ((r8 (r15 rdi rsi rdx rcx vector-init-loop.75 len.76 i.78 ra.396 rbp))
         (rbp
          (vector-init-loop.75
           vec.77
           i.78
           len.76
           c.86
           ra.396
           r15
           rdi
           rsi
           rdx
           rcx
           r8))
         (ra.396
          (vector-init-loop.75 vec.77 i.78 len.76 c.86 rbp rdi rsi rdx rcx r8))
         (i.78 (vector-init-loop.75 vec.77 c.86 len.76 ra.396 rbp rdx rcx r8))
         (len.76 (vector-init-loop.75 vec.77 i.78 rdx c.86 ra.396 rbp rcx r8))
         (vector-init-loop.75 (rbp ra.396 i.78 len.76 vec.77 r8))
         (rcx (c.86 r15 rdi rsi rdx len.76 i.78 ra.396 r8 rbp))
         (rdx (len.76 c.86 r15 rdi rsi i.78 ra.396 rcx r8 rbp))
         (rsi (c.86 r15 rdi ra.396 rdx rcx r8 rbp))
         (rdi (r15 ra.396 rsi rdx rcx r8 rbp))
         (r15 (rdi rsi rdx rcx r8 rbp))
         (c.86 (vec.77 i.78 len.76 rsi rdx rcx ra.396 rbp))
         (vec.77 (vector-init-loop.75 c.86 len.76 i.78 ra.396 rbp)))))
      (begin
        (set! ra.396 r15)
        (set! c.86 rdi)
        (set! len.76 rsi)
        (set! i.78 rdx)
        (set! vec.77 rcx)
        (set! vector-init-loop.75 (mref c.86 14))
        (if (eq? len.76 i.78)
          (begin
            (set! r8 vec.77)
            (set! rcx vector-init-loop.75)
            (set! rdx len.76)
            (set! rsi i.78)
            (set! rdi 14)
            (set! r15 ra.396)
            (jump L.jp.93 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 vec.77)
            (set! rcx vector-init-loop.75)
            (set! rdx len.76)
            (set! rsi i.78)
            (set! rdi 6)
            (set! r15 ra.396)
            (jump L.jp.93 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.unsafe-vector-set!.2.2
      ((new-frames ())
       (locals (c.85 tmp.267 ra.397 tmp.80 tmp.79 tmp.81))
       (undead-out
        ((rdi rsi rdx rcx ra.397 rbp)
         (rsi rdx rcx ra.397 rbp)
         (rdx rcx tmp.79 ra.397 rbp)
         (rcx tmp.79 tmp.80 ra.397 rbp)
         (tmp.81 tmp.79 tmp.80 ra.397 rbp)
         (tmp.267 tmp.81 tmp.79 tmp.80 ra.397 rbp)
         ((tmp.81 tmp.79 tmp.80 ra.397 rbp)
          ((tmp.79 tmp.80 ra.397 rcx rbp)
           (tmp.80 ra.397 rdx rcx rbp)
           (ra.397 rsi rdx rcx rbp)
           (ra.397 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp))
          ((tmp.79 tmp.80 ra.397 rcx rbp)
           (tmp.80 ra.397 rdx rcx rbp)
           (ra.397 rsi rdx rcx rbp)
           (ra.397 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rcx (c.85 r15 rdi rsi rdx tmp.79 tmp.80 ra.397 rbp))
         (rbp (tmp.267 tmp.81 tmp.80 tmp.79 c.85 ra.397 r15 rdi rsi rdx rcx))
         (ra.397 (tmp.267 tmp.81 tmp.80 tmp.79 c.85 rbp rdi rsi rdx rcx))
         (tmp.80 (tmp.267 tmp.81 tmp.79 ra.397 rbp rdx rcx))
         (tmp.79 (tmp.267 tmp.81 tmp.80 rdx ra.397 rbp rcx))
         (rdx (tmp.79 c.85 r15 rdi rsi tmp.80 ra.397 rcx rbp))
         (rsi (c.85 r15 rdi ra.397 rdx rcx rbp))
         (rdi (r15 ra.397 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (c.85 (rsi rdx rcx ra.397 rbp))
         (tmp.81 (tmp.267 tmp.79 tmp.80 ra.397 rbp))
         (tmp.267 (rbp ra.397 tmp.80 tmp.79 tmp.81)))))
      (begin
        (set! ra.397 r15)
        (set! c.85 rdi)
        (set! tmp.79 rsi)
        (set! tmp.80 rdx)
        (set! tmp.81 rcx)
        (set! tmp.267 (mref tmp.79 -3))
        (if (< tmp.80 tmp.267)
          (begin
            (set! rcx tmp.81)
            (set! rdx tmp.79)
            (set! rsi tmp.80)
            (set! rdi 14)
            (set! r15 ra.397)
            (jump L.jp.97 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx tmp.81)
            (set! rdx tmp.79)
            (set! rsi tmp.80)
            (set! rdi 6)
            (set! r15 ra.397)
            (jump L.jp.97 rbp r15 rcx rdx rsi rdi)))))
    (define L.unsafe-vector-ref.3.1
      ((new-frames ())
       (locals (c.84 tmp.275 ra.398 tmp.80 tmp.79))
       (undead-out
        ((rdi rsi rdx ra.398 rbp)
         (rsi rdx ra.398 rbp)
         (rdx tmp.79 ra.398 rbp)
         (tmp.79 tmp.80 ra.398 rbp)
         (tmp.275 tmp.79 tmp.80 ra.398 rbp)
         ((tmp.79 tmp.80 ra.398 rbp)
          ((tmp.80 ra.398 rdx rbp)
           (ra.398 rsi rdx rbp)
           (ra.398 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.80 ra.398 rdx rbp)
           (ra.398 rsi rdx rbp)
           (ra.398 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (tmp.79 c.84 r15 rdi rsi tmp.80 ra.398 rbp))
         (rbp (tmp.275 tmp.80 tmp.79 c.84 ra.398 r15 rdi rsi rdx))
         (ra.398 (tmp.275 tmp.80 tmp.79 c.84 rbp rdi rsi rdx))
         (tmp.80 (tmp.275 tmp.79 ra.398 rbp rdx))
         (rsi (c.84 r15 rdi ra.398 rdx rbp))
         (rdi (r15 ra.398 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.84 (rsi rdx ra.398 rbp))
         (tmp.79 (tmp.275 tmp.80 rdx ra.398 rbp))
         (tmp.275 (rbp ra.398 tmp.80 tmp.79)))))
      (begin
        (set! ra.398 r15)
        (set! c.84 rdi)
        (set! tmp.79 rsi)
        (set! tmp.80 rdx)
        (set! tmp.275 (mref tmp.79 -3))
        (if (< tmp.80 tmp.275)
          (begin
            (set! rdx tmp.79)
            (set! rsi tmp.80)
            (set! rdi 14)
            (set! r15 ra.398)
            (jump L.jp.101 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.79)
            (set! rsi tmp.80)
            (set! rdi 6)
            (set! r15 ra.398)
            (jump L.jp.101 rbp r15 rdx rsi rdi)))))
    (define L.jp.103
      ((new-frames ())
       (locals (tmp.308 ra.399 x.4 vector-set!.56 not.70 vector-ref.57 t.5))
       (undead-out
        ((rdi rsi rdx rcx r8 r9 ra.399 rbp)
         (rsi rdx rcx r8 r9 tmp.308 ra.399 rbp)
         (rdx rcx r8 r9 tmp.308 x.4 ra.399 rbp)
         (rcx r8 r9 tmp.308 vector-set!.56 x.4 ra.399 rbp)
         (r8 r9 tmp.308 not.70 vector-set!.56 x.4 ra.399 rbp)
         (r9 tmp.308 vector-ref.57 not.70 vector-set!.56 x.4 ra.399 rbp)
         (tmp.308 t.5 vector-ref.57 not.70 vector-set!.56 x.4 ra.399 rbp)
         ((t.5 vector-ref.57 not.70 vector-set!.56 x.4 ra.399 rbp)
          ((vector-ref.57 not.70 vector-set!.56 x.4 ra.399 r8 rbp)
           (not.70 vector-set!.56 x.4 ra.399 rcx r8 rbp)
           (vector-set!.56 x.4 ra.399 rdx rcx r8 rbp)
           (x.4 ra.399 rsi rdx rcx r8 rbp)
           (ra.399 rdi rsi rdx rcx r8 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)
           (rdi rsi rdx rcx r8 r15 rbp))
          ((vector-ref.57 not.70 vector-set!.56 ra.399 r8 rbp)
           (not.70 vector-set!.56 ra.399 rcx r8 rbp)
           (vector-set!.56 ra.399 rdx rcx r8 rbp)
           (ra.399 rsi rdx rcx r8 rbp)
           (ra.399 rdi rsi rdx rcx r8 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)))))
       (call-undead ())
       (conflicts
        ((r8
          (tmp.308
           x.4
           r15
           rdi
           rsi
           rdx
           rcx
           vector-ref.57
           not.70
           vector-set!.56
           ra.399
           rbp))
         (rbp
          (t.5
           vector-ref.57
           not.70
           vector-set!.56
           x.4
           tmp.308
           ra.399
           r15
           rdi
           rsi
           rdx
           rcx
           r8))
         (ra.399
          (t.5
           vector-ref.57
           not.70
           vector-set!.56
           x.4
           tmp.308
           r9
           rbp
           rdi
           rsi
           rdx
           rcx
           r8))
         (vector-set!.56
          (t.5 vector-ref.57 not.70 r9 tmp.308 x.4 ra.399 rbp rdx rcx r8))
         (not.70
          (t.5 vector-ref.57 r9 tmp.308 vector-set!.56 x.4 ra.399 rbp rcx r8))
         (vector-ref.57
          (t.5 r9 tmp.308 not.70 vector-set!.56 x.4 ra.399 rbp r8))
         (rcx
          (tmp.308 x.4 r15 rdi rsi rdx not.70 vector-set!.56 ra.399 r8 rbp))
         (rdx (tmp.308 x.4 r15 rdi rsi vector-set!.56 ra.399 rcx r8 rbp))
         (rsi (tmp.308 x.4 r15 rdi ra.399 rdx rcx r8 rbp))
         (rdi (r15 ra.399 rsi rdx rcx r8 rbp))
         (r15 (rdi rsi rdx rcx r8 rbp))
         (x.4
          (t.5
           vector-ref.57
           not.70
           vector-set!.56
           r9
           tmp.308
           ra.399
           rbp
           rsi
           rdx
           rcx
           r8))
         (r9 (vector-ref.57 not.70 vector-set!.56 x.4 tmp.308 ra.399))
         (tmp.308
          (t.5
           vector-ref.57
           not.70
           vector-set!.56
           x.4
           rsi
           rdx
           rcx
           r8
           r9
           ra.399
           rbp))
         (t.5 (tmp.308 vector-ref.57 not.70 vector-set!.56 x.4 ra.399 rbp)))))
      (begin
        (set! ra.399 r15)
        (set! tmp.308 rdi)
        (set! x.4 rsi)
        (set! vector-set!.56 rdx)
        (set! not.70 rcx)
        (set! vector-ref.57 r8)
        (set! t.5 r9)
        (if (neq? tmp.308 6)
          (begin
            (set! r8 t.5)
            (set! rcx vector-ref.57)
            (set! rdx not.70)
            (set! rsi vector-set!.56)
            (set! rdi x.4)
            (set! r15 ra.399)
            (jump L.jp.102 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 t.5)
            (set! rcx vector-ref.57)
            (set! rdx not.70)
            (set! rsi vector-set!.56)
            (set! rdi 6)
            (set! r15 ra.399)
            (jump L.jp.102 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.jp.102
      ((new-frames ())
       (locals
        (tmp.307
         tmp.122
         tmp.121
         tmp.8
         tmp.120
         t.5.7
         t.5
         vector-ref.57
         not.70
         vector-set!.56
         tmp.306
         ra.400))
       (undead-out
        ((rdi rsi rdx rcx r8 ra.400 rbp)
         (rsi rdx rcx r8 tmp.306 ra.400 rbp)
         (rdx rcx r8 tmp.306 vector-set!.56 ra.400 rbp)
         (rcx r8 tmp.306 vector-set!.56 not.70 ra.400 rbp)
         (r8 tmp.306 vector-set!.56 vector-ref.57 not.70 ra.400 rbp)
         (tmp.306 vector-set!.56 vector-ref.57 t.5 not.70 ra.400 rbp)
         (vector-set!.56 t.5.7 vector-ref.57 t.5 not.70 ra.400 rbp)
         (vector-set!.56 t.5.7 vector-ref.57 t.5 not.70 ra.400 rbp)
         ((rax vector-ref.57 t.5 not.70 ra.400 rbp)
          ((t.5 vector-set!.56 rcx rbp)
           (t.5 vector-set!.56 rdx rcx rbp)
           (vector-set!.56 rsi rdx rcx rbp)
           (rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp)))
         (vector-ref.57 t.5 not.70 ra.400 rbp)
         (vector-ref.57 t.5 not.70 ra.400 rbp)
         (vector-ref.57 t.5 not.70 ra.400 rbp)
         ((rax not.70 ra.400 rbp)
          ((t.5 vector-ref.57 rdx rbp)
           (vector-ref.57 rsi rdx rbp)
           (rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))
         (tmp.307 not.70 ra.400 rbp)
         (not.70 ra.400 rsi rbp)
         (ra.400 rdi rsi rbp)
         (rdi rsi r15 rbp)
         (rdi rsi r15 rbp)))
       (call-undead (vector-ref.57 t.5 not.70 ra.400))
       (conflicts
        ((ra.400
          (tmp.307
           tmp.122
           tmp.121
           tmp.8
           rax
           tmp.120
           t.5.7
           t.5
           vector-ref.57
           not.70
           vector-set!.56
           tmp.306
           rdi
           rsi
           rdx
           rcx
           r8
           rbp))
         (rbp
          (tmp.307
           tmp.122
           tmp.121
           tmp.8
           r15
           rdi
           rsi
           rdx
           rcx
           rax
           tmp.120
           t.5.7
           t.5
           vector-ref.57
           not.70
           vector-set!.56
           tmp.306
           ra.400))
         (r8 (vector-ref.57 not.70 vector-set!.56 tmp.306 ra.400))
         (rcx (r15 rdi rsi rdx t.5 rbp not.70 vector-set!.56 tmp.306 ra.400))
         (rdx
          (vector-ref.57
           r15
           rdi
           rsi
           t.5
           rcx
           rbp
           vector-set!.56
           tmp.306
           ra.400))
         (rsi
          (not.70
           vector-ref.57
           r15
           rdi
           vector-set!.56
           rdx
           rcx
           rbp
           tmp.306
           ra.400))
         (rdi (r15 rsi rdx rcx rbp ra.400))
         (tmp.306
          (t.5 vector-ref.57 not.70 vector-set!.56 rsi rdx rcx r8 ra.400 rbp))
         (vector-set!.56
          (rsi t.5.7 t.5 vector-ref.57 not.70 rdx rcx r8 tmp.306 ra.400 rbp))
         (not.70
          (rsi
           tmp.307
           tmp.122
           tmp.8
           rax
           tmp.120
           t.5.7
           t.5
           vector-ref.57
           rcx
           r8
           tmp.306
           vector-set!.56
           ra.400
           rbp))
         (vector-ref.57
          (rsi
           rdx
           tmp.121
           tmp.8
           rax
           tmp.120
           t.5.7
           t.5
           r8
           tmp.306
           vector-set!.56
           not.70
           ra.400
           rbp))
         (t.5
          (tmp.122
           tmp.121
           tmp.8
           rdx
           rcx
           rax
           tmp.120
           t.5.7
           tmp.306
           vector-set!.56
           vector-ref.57
           not.70
           ra.400
           rbp))
         (t.5.7 (tmp.120 vector-set!.56 vector-ref.57 t.5 not.70 ra.400 rbp))
         (tmp.120 (t.5.7 vector-ref.57 t.5 not.70 ra.400 rbp))
         (rax (rbp ra.400 not.70 t.5 vector-ref.57))
         (r15 (rdi rsi rdx rcx rbp))
         (tmp.8 (vector-ref.57 t.5 not.70 ra.400 rbp))
         (tmp.121 (vector-ref.57 t.5 ra.400 rbp))
         (tmp.122 (t.5 not.70 ra.400 rbp))
         (tmp.307 (not.70 ra.400 rbp)))))
      (begin
        (set! ra.400 r15)
        (set! tmp.306 rdi)
        (set! vector-set!.56 rsi)
        (set! not.70 rdx)
        (set! vector-ref.57 rcx)
        (set! t.5 r8)
        (set! t.5.7 tmp.306)
        (set! tmp.120 vector-set!.56)
        (return-point L.rp.106
          (begin
            (set! rcx t.5.7)
            (set! rdx 0)
            (set! rsi t.5)
            (set! rdi vector-set!.56)
            (set! r15 L.rp.106)
            (jump L.vector-set!.56.21 rbp r15 rcx rdx rsi rdi)))
        (set! tmp.8 rax)
        (set! tmp.121 not.70)
        (set! tmp.122 vector-ref.57)
        (return-point L.rp.107
          (begin
            (set! rdx 0)
            (set! rsi t.5)
            (set! rdi vector-ref.57)
            (set! r15 L.rp.107)
            (jump L.vector-ref.57.20 rbp r15 rdx rsi rdi)))
        (set! tmp.307 rax)
        (set! rsi tmp.307)
        (set! rdi not.70)
        (set! r15 ra.400)
        (jump L.not.70.7 rbp r15 rsi rdi)))
    (define L.jp.101
      ((new-frames ())
       (locals (tmp.269 ra.401 tmp.80 tmp.79))
       (undead-out
        ((rdi rsi rdx ra.401 rbp)
         (rsi rdx tmp.269 ra.401 rbp)
         (rdx tmp.269 tmp.80 ra.401 rbp)
         (tmp.269 tmp.79 tmp.80 ra.401 rbp)
         ((tmp.79 tmp.80 ra.401 rbp)
          ((tmp.79 tmp.80 ra.401 rbp)
           ((tmp.80 ra.401 rdx rbp)
            (ra.401 rsi rdx rbp)
            (ra.401 rdi rsi rdx rbp)
            (rdi rsi rdx r15 rbp)
            (rdi rsi rdx r15 rbp))
           ((tmp.80 ra.401 rdx rbp)
            (ra.401 rsi rdx rbp)
            (ra.401 rdi rsi rdx rbp)
            (rdi rsi rdx r15 rbp)
            (rdi rsi rdx r15 rbp)))
          ((ra.401 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.401 rbp))
         (rbp (tmp.79 tmp.80 tmp.269 ra.401 r15 rdi rsi rdx rax))
         (ra.401 (tmp.79 tmp.80 tmp.269 rbp rdi rsi rdx rax))
         (rdx (tmp.269 r15 rdi rsi tmp.80 ra.401 rbp))
         (tmp.80 (tmp.79 tmp.269 ra.401 rbp rdx))
         (rsi (tmp.269 r15 rdi ra.401 rdx rbp))
         (rdi (r15 ra.401 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.269 (tmp.79 tmp.80 rsi rdx ra.401 rbp))
         (tmp.79 (tmp.269 tmp.80 ra.401 rbp)))))
      (begin
        (set! ra.401 r15)
        (set! tmp.269 rdi)
        (set! tmp.80 rsi)
        (set! tmp.79 rdx)
        (if (neq? tmp.269 6)
          (if (>= tmp.80 0)
            (begin
              (set! rdx tmp.79)
              (set! rsi tmp.80)
              (set! rdi 14)
              (set! r15 ra.401)
              (jump L.jp.100 rbp r15 rdx rsi rdi))
            (begin
              (set! rdx tmp.79)
              (set! rsi tmp.80)
              (set! rdi 6)
              (set! r15 ra.401)
              (jump L.jp.100 rbp r15 rdx rsi rdi)))
          (begin (set! rax 2622) (jump ra.401 rbp rax)))))
    (define L.jp.100
      ((new-frames ())
       (locals
        (ra.402
         tmp.271
         tmp.79
         tmp.274
         tmp.405
         tmp.273
         tmp.404
         tmp.272
         tmp.403
         tmp.80))
       (undead-out
        ((rdi rsi rdx ra.402 rbp)
         (rsi rdx tmp.271 ra.402 rbp)
         (rdx tmp.271 tmp.80 ra.402 rbp)
         (tmp.271 tmp.80 tmp.79 ra.402 rbp)
         ((tmp.80 tmp.79 ra.402 rbp)
          ((tmp.403 tmp.79 ra.402 rbp)
           (tmp.272 tmp.79 ra.402 rbp)
           (tmp.404 tmp.79 ra.402 rbp)
           (tmp.273 tmp.79 ra.402 rbp)
           (tmp.405 tmp.79 ra.402 rbp)
           (tmp.274 tmp.79 ra.402 rbp)
           (ra.402 rax rbp)
           (rax rbp))
          ((ra.402 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.402 rbp))
         (rbp
          (tmp.79
           tmp.80
           tmp.271
           ra.402
           tmp.274
           tmp.405
           tmp.273
           tmp.404
           tmp.272
           tmp.403
           rax))
         (ra.402
          (tmp.79
           tmp.80
           tmp.271
           rdi
           rsi
           rdx
           rbp
           tmp.274
           tmp.405
           tmp.273
           tmp.404
           tmp.272
           tmp.403
           rax))
         (tmp.403 (rbp ra.402 tmp.79))
         (tmp.79
          (tmp.271
           tmp.80
           ra.402
           rbp
           tmp.274
           tmp.405
           tmp.273
           tmp.404
           tmp.272
           tmp.403))
         (tmp.272 (tmp.79 ra.402 rbp))
         (tmp.404 (rbp ra.402 tmp.79))
         (tmp.273 (tmp.79 ra.402 rbp))
         (tmp.405 (rbp ra.402 tmp.79))
         (tmp.274 (tmp.79 ra.402 rbp))
         (rdx (tmp.80 tmp.271 ra.402))
         (rsi (tmp.271 ra.402))
         (rdi (ra.402))
         (tmp.271 (tmp.79 tmp.80 rsi rdx ra.402 rbp))
         (tmp.80 (tmp.79 rdx tmp.271 ra.402 rbp)))))
      (begin
        (set! ra.402 r15)
        (set! tmp.271 rdi)
        (set! tmp.80 rsi)
        (set! tmp.79 rdx)
        (if (neq? tmp.271 6)
          (begin
            (set! tmp.403 (arithmetic-shift-right tmp.80 3))
            (set! tmp.272 tmp.403)
            (set! tmp.404 (* tmp.272 8))
            (set! tmp.273 tmp.404)
            (set! tmp.405 (+ tmp.273 5))
            (set! tmp.274 tmp.405)
            (set! rax (mref tmp.79 tmp.274))
            (jump ra.402 rbp rax))
          (begin (set! rax 2622) (jump ra.402 rbp rax)))))
    (define L.jp.97
      ((new-frames ())
       (locals (tmp.261 ra.406 tmp.80 tmp.81 tmp.79))
       (undead-out
        ((rdi rsi rdx rcx ra.406 rbp)
         (rsi rdx rcx tmp.261 ra.406 rbp)
         (rdx rcx tmp.261 tmp.80 ra.406 rbp)
         (rcx tmp.261 tmp.79 tmp.80 ra.406 rbp)
         (tmp.261 tmp.79 tmp.81 tmp.80 ra.406 rbp)
         ((tmp.79 tmp.81 tmp.80 ra.406 rbp)
          ((tmp.79 tmp.81 tmp.80 ra.406 rbp)
           ((tmp.81 tmp.80 ra.406 rcx rbp)
            (tmp.80 ra.406 rdx rcx rbp)
            (ra.406 rsi rdx rcx rbp)
            (ra.406 rdi rsi rdx rcx rbp)
            (rdi rsi rdx rcx r15 rbp)
            (rdi rsi rdx rcx r15 rbp))
           ((tmp.81 tmp.80 ra.406 rcx rbp)
            (tmp.80 ra.406 rdx rcx rbp)
            (ra.406 rsi rdx rcx rbp)
            (ra.406 rdi rsi rdx rcx rbp)
            (rdi rsi rdx rcx r15 rbp)
            (rdi rsi rdx rcx r15 rbp)))
          ((ra.406 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.406 rbp))
         (rbp (tmp.81 tmp.79 tmp.80 tmp.261 ra.406 r15 rdi rsi rdx rcx rax))
         (ra.406 (tmp.81 tmp.79 tmp.80 tmp.261 rbp rdi rsi rdx rcx rax))
         (rcx (tmp.79 tmp.261 r15 rdi rsi rdx tmp.81 tmp.80 ra.406 rbp))
         (tmp.80 (tmp.81 tmp.79 tmp.261 ra.406 rbp rdx rcx))
         (tmp.81 (tmp.261 tmp.79 tmp.80 ra.406 rbp rcx))
         (rdx (tmp.261 r15 rdi rsi tmp.80 ra.406 rcx rbp))
         (rsi (tmp.261 r15 rdi ra.406 rdx rcx rbp))
         (rdi (r15 ra.406 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (tmp.261 (tmp.81 tmp.79 tmp.80 rsi rdx rcx ra.406 rbp))
         (tmp.79 (tmp.81 rcx tmp.261 tmp.80 ra.406 rbp)))))
      (begin
        (set! ra.406 r15)
        (set! tmp.261 rdi)
        (set! tmp.80 rsi)
        (set! tmp.79 rdx)
        (set! tmp.81 rcx)
        (if (neq? tmp.261 6)
          (if (>= tmp.80 0)
            (begin
              (set! rcx tmp.79)
              (set! rdx tmp.81)
              (set! rsi tmp.80)
              (set! rdi 14)
              (set! r15 ra.406)
              (jump L.jp.96 rbp r15 rcx rdx rsi rdi))
            (begin
              (set! rcx tmp.79)
              (set! rdx tmp.81)
              (set! rsi tmp.80)
              (set! rdi 6)
              (set! r15 ra.406)
              (jump L.jp.96 rbp r15 rcx rdx rsi rdi)))
          (begin (set! rax 2366) (jump ra.406 rbp rax)))))
    (define L.jp.96
      ((new-frames ())
       (locals
        (ra.407
         tmp.263
         tmp.79
         tmp.81
         tmp.266
         tmp.410
         tmp.265
         tmp.409
         tmp.264
         tmp.408
         tmp.80))
       (undead-out
        ((rdi rsi rdx rcx rbp ra.407)
         (rsi rdx rcx tmp.263 rbp ra.407)
         (rdx rcx tmp.263 tmp.80 rbp ra.407)
         (rcx tmp.263 tmp.80 rbp ra.407 tmp.81)
         (tmp.263 tmp.80 rbp ra.407 tmp.81 tmp.79)
         ((tmp.80 rbp ra.407 tmp.81 tmp.79)
          ((tmp.408 rbp ra.407 tmp.81 tmp.79)
           (tmp.264 rbp ra.407 tmp.81 tmp.79)
           (tmp.409 rbp ra.407 tmp.81 tmp.79)
           (tmp.265 rbp ra.407 tmp.81 tmp.79)
           (tmp.410 rbp ra.407 tmp.81 tmp.79)
           (rbp ra.407 tmp.81 tmp.266 tmp.79)
           (tmp.79 ra.407 rbp)
           (ra.407 rax rbp)
           (rax rbp))
          ((ra.407 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.407 rbp))
         (rbp
          (tmp.79
           tmp.81
           tmp.80
           tmp.263
           ra.407
           tmp.266
           tmp.410
           tmp.265
           tmp.409
           tmp.264
           tmp.408
           rax))
         (ra.407
          (tmp.79
           tmp.81
           tmp.80
           tmp.263
           rdi
           rsi
           rdx
           rcx
           rbp
           tmp.266
           tmp.410
           tmp.265
           tmp.409
           tmp.264
           tmp.408
           rax))
         (tmp.408 (tmp.79 tmp.81 ra.407 rbp))
         (tmp.81
          (tmp.79
           rcx
           tmp.263
           tmp.80
           rbp
           ra.407
           tmp.266
           tmp.410
           tmp.265
           tmp.409
           tmp.264
           tmp.408))
         (tmp.79
          (tmp.263
           tmp.80
           rbp
           ra.407
           tmp.81
           tmp.266
           tmp.410
           tmp.265
           tmp.409
           tmp.264
           tmp.408))
         (tmp.264 (rbp ra.407 tmp.81 tmp.79))
         (tmp.409 (tmp.79 tmp.81 ra.407 rbp))
         (tmp.265 (rbp ra.407 tmp.81 tmp.79))
         (tmp.410 (tmp.79 tmp.81 ra.407 rbp))
         (tmp.266 (rbp ra.407 tmp.81 tmp.79))
         (rcx (tmp.81 tmp.80 tmp.263 ra.407))
         (rdx (tmp.80 tmp.263 ra.407))
         (rsi (tmp.263 ra.407))
         (rdi (ra.407))
         (tmp.263 (tmp.79 tmp.81 tmp.80 rsi rdx rcx rbp ra.407))
         (tmp.80 (tmp.79 tmp.81 rdx rcx tmp.263 rbp ra.407)))))
      (begin
        (set! ra.407 r15)
        (set! tmp.263 rdi)
        (set! tmp.80 rsi)
        (set! tmp.81 rdx)
        (set! tmp.79 rcx)
        (if (neq? tmp.263 6)
          (begin
            (set! tmp.408 (arithmetic-shift-right tmp.80 3))
            (set! tmp.264 tmp.408)
            (set! tmp.409 (* tmp.264 8))
            (set! tmp.265 tmp.409)
            (set! tmp.410 (+ tmp.265 5))
            (set! tmp.266 tmp.410)
            (mset! tmp.79 tmp.266 tmp.81)
            (set! rax tmp.79)
            (jump ra.407 rbp rax))
          (begin (set! rax 2366) (jump ra.407 rbp rax)))))
    (define L.jp.93
      ((new-frames ())
       (locals
        (tmp.255
         i.78
         tmp.412
         tmp.256
         tmp.413
         tmp.257
         tmp.414
         tmp.258
         vector-init-loop.75
         tmp.114
         tmp.415
         tmp.259
         len.76
         ra.411
         vec.77))
       (undead-out
        ((rdi rsi rdx rcx r8 ra.411 rbp)
         (rsi rdx rcx r8 tmp.255 ra.411 rbp)
         (rdx rcx r8 tmp.255 i.78 ra.411 rbp)
         (rcx r8 tmp.255 i.78 len.76 ra.411 rbp)
         (r8 tmp.255 i.78 len.76 vector-init-loop.75 ra.411 rbp)
         (tmp.255 i.78 len.76 vector-init-loop.75 vec.77 ra.411 rbp)
         ((i.78 len.76 vector-init-loop.75 vec.77 ra.411 rbp)
          ((ra.411 rax rbp) (rax rbp))
          ((tmp.412 rbp ra.411 vector-init-loop.75 len.76 i.78 vec.77)
           (tmp.256 rbp ra.411 vector-init-loop.75 len.76 i.78 vec.77)
           (tmp.413 rbp ra.411 vector-init-loop.75 len.76 i.78 vec.77)
           (tmp.257 rbp ra.411 vector-init-loop.75 len.76 i.78 vec.77)
           (tmp.414 rbp ra.411 vector-init-loop.75 len.76 i.78 vec.77)
           (rbp ra.411 vector-init-loop.75 len.76 i.78 tmp.258 vec.77)
           (i.78 vec.77 len.76 vector-init-loop.75 ra.411 rbp)
           (i.78 vec.77 len.76 vector-init-loop.75 ra.411 rbp)
           (tmp.415 vec.77 len.76 vector-init-loop.75 ra.411 rbp)
           (vec.77 tmp.259 len.76 vector-init-loop.75 ra.411 rbp)
           (tmp.259 len.76 vector-init-loop.75 ra.411 rcx rbp)
           (len.76 vector-init-loop.75 ra.411 rdx rcx rbp)
           (vector-init-loop.75 ra.411 rsi rdx rcx rbp)
           (ra.411 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((tmp.412 (vec.77 i.78 len.76 vector-init-loop.75 ra.411 rbp))
         (rbp
          (vec.77
           vector-init-loop.75
           len.76
           i.78
           tmp.255
           ra.411
           rax
           r15
           rdi
           rsi
           rdx
           rcx
           tmp.259
           tmp.415
           tmp.114
           tmp.258
           tmp.414
           tmp.257
           tmp.413
           tmp.256
           tmp.412))
         (ra.411
          (vec.77
           vector-init-loop.75
           len.76
           i.78
           tmp.255
           r8
           rbp
           rax
           rdi
           rsi
           rdx
           rcx
           tmp.259
           tmp.415
           tmp.114
           tmp.258
           tmp.414
           tmp.257
           tmp.413
           tmp.256
           tmp.412))
         (vector-init-loop.75
          (vec.77
           r8
           tmp.255
           i.78
           len.76
           ra.411
           rbp
           rsi
           rdx
           rcx
           tmp.259
           tmp.415
           tmp.258
           tmp.414
           tmp.257
           tmp.413
           tmp.256
           tmp.412))
         (len.76
          (vec.77
           vector-init-loop.75
           r8
           tmp.255
           i.78
           ra.411
           rbp
           rdx
           rcx
           tmp.259
           tmp.415
           tmp.114
           tmp.258
           tmp.414
           tmp.257
           tmp.413
           tmp.256
           tmp.412))
         (i.78
          (vec.77
           vector-init-loop.75
           len.76
           rdx
           rcx
           r8
           tmp.255
           ra.411
           rbp
           tmp.114
           tmp.258
           tmp.414
           tmp.257
           tmp.413
           tmp.256
           tmp.412))
         (vec.77
          (tmp.255
           i.78
           len.76
           vector-init-loop.75
           ra.411
           rbp
           tmp.259
           tmp.415
           tmp.114
           tmp.258
           tmp.414
           tmp.257
           tmp.413
           tmp.256
           tmp.412))
         (tmp.256 (rbp ra.411 vector-init-loop.75 len.76 i.78 vec.77))
         (tmp.413 (vec.77 i.78 len.76 vector-init-loop.75 ra.411 rbp))
         (tmp.257 (rbp ra.411 vector-init-loop.75 len.76 i.78 vec.77))
         (tmp.414 (vec.77 i.78 len.76 vector-init-loop.75 ra.411 rbp))
         (tmp.258 (rbp ra.411 vector-init-loop.75 len.76 i.78 vec.77))
         (tmp.114 (i.78 vec.77 len.76 ra.411 rbp))
         (tmp.415 (rbp ra.411 vector-init-loop.75 len.76 vec.77))
         (tmp.259 (rcx vec.77 len.76 vector-init-loop.75 ra.411 rbp))
         (rcx
          (i.78
           tmp.255
           r15
           rdi
           rsi
           rdx
           tmp.259
           len.76
           vector-init-loop.75
           ra.411
           rbp))
         (rdx
          (i.78 tmp.255 r15 rdi rsi len.76 vector-init-loop.75 ra.411 rcx rbp))
         (rsi (tmp.255 r15 rdi vector-init-loop.75 ra.411 rdx rcx rbp))
         (rdi (r15 ra.411 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (rax (ra.411 rbp))
         (r8 (vector-init-loop.75 len.76 i.78 tmp.255 ra.411))
         (tmp.255
          (vec.77
           vector-init-loop.75
           len.76
           i.78
           rsi
           rdx
           rcx
           r8
           ra.411
           rbp)))))
      (begin
        (set! ra.411 r15)
        (set! tmp.255 rdi)
        (set! i.78 rsi)
        (set! len.76 rdx)
        (set! vector-init-loop.75 rcx)
        (set! vec.77 r8)
        (if (neq? tmp.255 6)
          (begin (set! rax vec.77) (jump ra.411 rbp rax))
          (begin
            (set! tmp.412 (arithmetic-shift-right i.78 3))
            (set! tmp.256 tmp.412)
            (set! tmp.413 (* tmp.256 8))
            (set! tmp.257 tmp.413)
            (set! tmp.414 (+ tmp.257 5))
            (set! tmp.258 tmp.414)
            (mset! vec.77 tmp.258 0)
            (set! tmp.114 vector-init-loop.75)
            (set! tmp.415 (+ i.78 8))
            (set! tmp.259 tmp.415)
            (set! rcx vec.77)
            (set! rdx tmp.259)
            (set! rsi len.76)
            (set! rdi vector-init-loop.75)
            (set! r15 ra.411)
            (jump L.vector-init-loop.75.3 rbp r15 rcx rdx rsi rdi)))))
    (define L.jp.80
      ((new-frames ())
       (locals (ra.416 tmp.227 tmp.32))
       (undead-out
        ((rdi rsi ra.416 rbp)
         (rsi tmp.227 ra.416 rbp)
         (tmp.227 tmp.32 ra.416 rbp)
         ((tmp.32 ra.416 rbp)
          ((ra.416 rax rbp) (rax rbp))
          ((ra.416 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.416 rbp))
         (rbp (tmp.32 tmp.227 ra.416 rax))
         (ra.416 (tmp.32 tmp.227 rdi rsi rbp rax))
         (rsi (tmp.227 ra.416))
         (rdi (ra.416))
         (tmp.227 (tmp.32 rsi ra.416 rbp))
         (tmp.32 (tmp.227 ra.416 rbp)))))
      (begin
        (set! ra.416 r15)
        (set! tmp.227 rdi)
        (set! tmp.32 rsi)
        (if (neq? tmp.227 6)
          (begin (set! rax (mref tmp.32 6)) (jump ra.416 rbp rax))
          (begin (set! rax 3390) (jump ra.416 rbp rax)))))
    (define L.jp.78
      ((new-frames ())
       (locals (ra.417 tmp.224 tmp.31))
       (undead-out
        ((rdi rsi ra.417 rbp)
         (rsi tmp.224 ra.417 rbp)
         (tmp.224 tmp.31 ra.417 rbp)
         ((tmp.31 ra.417 rbp)
          ((ra.417 rax rbp) (rax rbp))
          ((ra.417 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.417 rbp))
         (rbp (tmp.31 tmp.224 ra.417 rax))
         (ra.417 (tmp.31 tmp.224 rdi rsi rbp rax))
         (rsi (tmp.224 ra.417))
         (rdi (ra.417))
         (tmp.224 (tmp.31 rsi ra.417 rbp))
         (tmp.31 (tmp.224 ra.417 rbp)))))
      (begin
        (set! ra.417 r15)
        (set! tmp.224 rdi)
        (set! tmp.31 rsi)
        (if (neq? tmp.224 6)
          (begin (set! rax (mref tmp.31 7)) (jump ra.417 rbp rax))
          (begin (set! rax 3134) (jump ra.417 rbp rax)))))
    (define L.jp.76
      ((new-frames ())
       (locals (ra.418 tmp.221 tmp.30))
       (undead-out
        ((rdi rsi ra.418 rbp)
         (rsi tmp.221 ra.418 rbp)
         (tmp.221 tmp.30 ra.418 rbp)
         ((tmp.30 ra.418 rbp)
          ((ra.418 rax rbp) (rax rbp))
          ((ra.418 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.418 rbp))
         (rbp (tmp.30 tmp.221 ra.418 rax))
         (ra.418 (tmp.30 tmp.221 rdi rsi rbp rax))
         (rsi (tmp.221 ra.418))
         (rdi (ra.418))
         (tmp.221 (tmp.30 rsi ra.418 rbp))
         (tmp.30 (tmp.221 ra.418 rbp)))))
      (begin
        (set! ra.418 r15)
        (set! tmp.221 rdi)
        (set! tmp.30 rsi)
        (if (neq? tmp.221 6)
          (begin (set! rax (mref tmp.30 -1)) (jump ra.418 rbp rax))
          (begin (set! rax 2878) (jump ra.418 rbp rax)))))
    (define L.jp.74
      ((new-frames ())
       (locals
        (tmp.215 tmp.420 tmp.218 ra.419 unsafe-vector-ref.3 tmp.29 tmp.28))
       (undead-out
        ((rdi rsi rdx rcx ra.419 rbp)
         (rsi rdx rcx tmp.215 ra.419 rbp)
         (rdx rcx tmp.215 tmp.28 ra.419 rbp)
         (rcx tmp.215 tmp.28 unsafe-vector-ref.3 ra.419 rbp)
         (tmp.215 tmp.28 tmp.29 unsafe-vector-ref.3 ra.419 rbp)
         ((tmp.28 tmp.29 unsafe-vector-ref.3 ra.419 rbp)
          ((tmp.420 tmp.28 tmp.29 unsafe-vector-ref.3 ra.419 rbp)
           (tmp.218 tmp.28 tmp.29 unsafe-vector-ref.3 ra.419 rbp)
           ((tmp.28 tmp.29 unsafe-vector-ref.3 ra.419 rbp)
            ((tmp.29 unsafe-vector-ref.3 ra.419 rcx rbp)
             (unsafe-vector-ref.3 ra.419 rdx rcx rbp)
             (ra.419 rsi rdx rcx rbp)
             (ra.419 rdi rsi rdx rcx rbp)
             (rdi rsi rdx rcx r15 rbp)
             (rdi rsi rdx rcx r15 rbp))
            ((tmp.29 unsafe-vector-ref.3 ra.419 rcx rbp)
             (unsafe-vector-ref.3 ra.419 rdx rcx rbp)
             (ra.419 rsi rdx rcx rbp)
             (ra.419 rdi rsi rdx rcx rbp)
             (rdi rsi rdx rcx r15 rbp)
             (rdi rsi rdx rcx r15 rbp))))
          ((ra.419 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.419 rbp))
         (rbp
          (tmp.29
           unsafe-vector-ref.3
           tmp.28
           tmp.215
           ra.419
           tmp.218
           tmp.420
           r15
           rdi
           rsi
           rdx
           rcx
           rax))
         (ra.419
          (tmp.29
           unsafe-vector-ref.3
           tmp.28
           tmp.215
           rbp
           tmp.218
           tmp.420
           rdi
           rsi
           rdx
           rcx
           rax))
         (rcx
          (tmp.28
           tmp.215
           r15
           rdi
           rsi
           rdx
           tmp.29
           unsafe-vector-ref.3
           ra.419
           rbp))
         (unsafe-vector-ref.3
          (tmp.29 tmp.215 tmp.28 ra.419 rbp tmp.218 tmp.420 rdx rcx))
         (tmp.29
          (tmp.215 tmp.28 unsafe-vector-ref.3 ra.419 rbp tmp.218 tmp.420 rcx))
         (rdx (tmp.28 tmp.215 r15 rdi rsi unsafe-vector-ref.3 ra.419 rcx rbp))
         (rsi (tmp.215 r15 rdi ra.419 rdx rcx rbp))
         (rdi (r15 ra.419 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (tmp.420 (rbp ra.419 unsafe-vector-ref.3 tmp.29 tmp.28))
         (tmp.28
          (tmp.29
           unsafe-vector-ref.3
           rdx
           rcx
           tmp.215
           ra.419
           rbp
           tmp.218
           tmp.420))
         (tmp.218 (tmp.28 tmp.29 unsafe-vector-ref.3 ra.419 rbp))
         (tmp.215
          (tmp.29 unsafe-vector-ref.3 tmp.28 rsi rdx rcx ra.419 rbp)))))
      (begin
        (set! ra.419 r15)
        (set! tmp.215 rdi)
        (set! tmp.28 rsi)
        (set! unsafe-vector-ref.3 rdx)
        (set! tmp.29 rcx)
        (if (neq? tmp.215 6)
          (begin
            (set! tmp.420 (bitwise-and tmp.28 7))
            (set! tmp.218 tmp.420)
            (if (eq? tmp.218 3)
              (begin
                (set! rcx tmp.28)
                (set! rdx tmp.29)
                (set! rsi unsafe-vector-ref.3)
                (set! rdi 14)
                (set! r15 ra.419)
                (jump L.jp.73 rbp r15 rcx rdx rsi rdi))
              (begin
                (set! rcx tmp.28)
                (set! rdx tmp.29)
                (set! rsi unsafe-vector-ref.3)
                (set! rdi 6)
                (set! r15 ra.419)
                (jump L.jp.73 rbp r15 rcx rdx rsi rdi))))
          (begin (set! rax 2622) (jump ra.419 rbp rax)))))
    (define L.jp.73
      ((new-frames ())
       (locals (tmp.217 ra.421 tmp.28 tmp.29 tmp.116 unsafe-vector-ref.3))
       (undead-out
        ((rdi rsi rdx rcx ra.421 rbp)
         (rsi rdx rcx tmp.217 ra.421 rbp)
         (rdx rcx tmp.217 unsafe-vector-ref.3 ra.421 rbp)
         (rcx tmp.217 tmp.29 unsafe-vector-ref.3 ra.421 rbp)
         (tmp.217 tmp.29 tmp.28 unsafe-vector-ref.3 ra.421 rbp)
         ((tmp.29 tmp.28 unsafe-vector-ref.3 ra.421 rbp)
          ((tmp.29 tmp.28 unsafe-vector-ref.3 ra.421 rbp)
           (tmp.28 unsafe-vector-ref.3 ra.421 rdx rbp)
           (unsafe-vector-ref.3 ra.421 rsi rdx rbp)
           (ra.421 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((ra.421 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.421 rbp))
         (rbp
          (tmp.28
           tmp.29
           unsafe-vector-ref.3
           tmp.217
           ra.421
           r15
           rdi
           rsi
           rdx
           tmp.116
           rax))
         (ra.421
          (tmp.28
           tmp.29
           unsafe-vector-ref.3
           tmp.217
           rcx
           rbp
           rdi
           rsi
           rdx
           tmp.116
           rax))
         (tmp.116 (tmp.29 tmp.28 ra.421 rbp))
         (tmp.28 (tmp.217 tmp.29 unsafe-vector-ref.3 ra.421 rbp rdx tmp.116))
         (tmp.29 (tmp.28 rcx tmp.217 unsafe-vector-ref.3 ra.421 rbp tmp.116))
         (rdx (tmp.217 r15 rdi rsi tmp.28 unsafe-vector-ref.3 ra.421 rbp))
         (unsafe-vector-ref.3 (tmp.28 tmp.29 rcx tmp.217 ra.421 rbp rsi rdx))
         (rsi (tmp.217 r15 rdi unsafe-vector-ref.3 ra.421 rdx rbp))
         (rdi (r15 ra.421 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (rcx (tmp.29 unsafe-vector-ref.3 tmp.217 ra.421))
         (tmp.217
          (tmp.28 tmp.29 unsafe-vector-ref.3 rsi rdx rcx ra.421 rbp)))))
      (begin
        (set! ra.421 r15)
        (set! tmp.217 rdi)
        (set! unsafe-vector-ref.3 rsi)
        (set! tmp.29 rdx)
        (set! tmp.28 rcx)
        (if (neq? tmp.217 6)
          (begin
            (set! tmp.116 unsafe-vector-ref.3)
            (set! rdx tmp.29)
            (set! rsi tmp.28)
            (set! rdi unsafe-vector-ref.3)
            (set! r15 ra.421)
            (jump L.unsafe-vector-ref.3.1 rbp r15 rdx rsi rdi))
          (begin (set! rax 2622) (jump ra.421 rbp rax)))))
    (define L.jp.70
      ((new-frames ())
       (locals
        (tmp.209
         tmp.423
         tmp.212
         ra.422
         unsafe-vector-set!.2
         tmp.27
         tmp.26
         tmp.25))
       (undead-out
        ((rdi rsi rdx rcx r8 ra.422 rbp)
         (rsi rdx rcx r8 tmp.209 ra.422 rbp)
         (rdx rcx r8 tmp.209 tmp.25 ra.422 rbp)
         (rcx r8 tmp.209 tmp.25 unsafe-vector-set!.2 ra.422 rbp)
         (r8 tmp.209 tmp.25 tmp.27 unsafe-vector-set!.2 ra.422 rbp)
         (tmp.209 tmp.25 tmp.26 tmp.27 unsafe-vector-set!.2 ra.422 rbp)
         ((tmp.25 tmp.26 tmp.27 unsafe-vector-set!.2 ra.422 rbp)
          ((tmp.423 tmp.25 tmp.26 tmp.27 unsafe-vector-set!.2 ra.422 rbp)
           (tmp.212 tmp.25 tmp.26 tmp.27 unsafe-vector-set!.2 ra.422 rbp)
           ((tmp.25 tmp.26 tmp.27 unsafe-vector-set!.2 ra.422 rbp)
            ((tmp.26 tmp.27 unsafe-vector-set!.2 ra.422 r8 rbp)
             (tmp.27 unsafe-vector-set!.2 ra.422 rcx r8 rbp)
             (unsafe-vector-set!.2 ra.422 rdx rcx r8 rbp)
             (ra.422 rsi rdx rcx r8 rbp)
             (ra.422 rdi rsi rdx rcx r8 rbp)
             (rdi rsi rdx rcx r8 r15 rbp)
             (rdi rsi rdx rcx r8 r15 rbp))
            ((tmp.26 tmp.27 unsafe-vector-set!.2 ra.422 r8 rbp)
             (tmp.27 unsafe-vector-set!.2 ra.422 rcx r8 rbp)
             (unsafe-vector-set!.2 ra.422 rdx rcx r8 rbp)
             (ra.422 rsi rdx rcx r8 rbp)
             (ra.422 rdi rsi rdx rcx r8 rbp)
             (rdi rsi rdx rcx r8 r15 rbp)
             (rdi rsi rdx rcx r8 r15 rbp))))
          ((ra.422 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.422 rbp))
         (rbp
          (tmp.26
           tmp.27
           unsafe-vector-set!.2
           tmp.25
           tmp.209
           ra.422
           tmp.212
           tmp.423
           r15
           rdi
           rsi
           rdx
           rcx
           r8
           rax))
         (ra.422
          (tmp.26
           tmp.27
           unsafe-vector-set!.2
           tmp.25
           tmp.209
           rbp
           tmp.212
           tmp.423
           rdi
           rsi
           rdx
           rcx
           r8
           rax))
         (r8
          (tmp.25
           tmp.209
           r15
           rdi
           rsi
           rdx
           rcx
           tmp.26
           tmp.27
           unsafe-vector-set!.2
           ra.422
           rbp))
         (unsafe-vector-set!.2
          (tmp.26 tmp.27 tmp.209 tmp.25 ra.422 rbp tmp.212 tmp.423 rdx rcx r8))
         (tmp.27
          (tmp.26
           tmp.209
           tmp.25
           unsafe-vector-set!.2
           ra.422
           rbp
           tmp.212
           tmp.423
           rcx
           r8))
         (tmp.26
          (tmp.209
           tmp.25
           tmp.27
           unsafe-vector-set!.2
           ra.422
           rbp
           tmp.212
           tmp.423
           r8))
         (rcx
          (tmp.25
           tmp.209
           r15
           rdi
           rsi
           rdx
           tmp.27
           unsafe-vector-set!.2
           ra.422
           r8
           rbp))
         (rdx
          (tmp.25 tmp.209 r15 rdi rsi unsafe-vector-set!.2 ra.422 rcx r8 rbp))
         (rsi (tmp.209 r15 rdi ra.422 rdx rcx r8 rbp))
         (rdi (r15 ra.422 rsi rdx rcx r8 rbp))
         (r15 (rdi rsi rdx rcx r8 rbp))
         (tmp.423 (rbp ra.422 unsafe-vector-set!.2 tmp.27 tmp.26 tmp.25))
         (tmp.25
          (tmp.26
           tmp.27
           unsafe-vector-set!.2
           rdx
           rcx
           r8
           tmp.209
           ra.422
           rbp
           tmp.212
           tmp.423))
         (tmp.212 (tmp.25 tmp.26 tmp.27 unsafe-vector-set!.2 ra.422 rbp))
         (tmp.209
          (tmp.26
           tmp.27
           unsafe-vector-set!.2
           tmp.25
           rsi
           rdx
           rcx
           r8
           ra.422
           rbp)))))
      (begin
        (set! ra.422 r15)
        (set! tmp.209 rdi)
        (set! tmp.25 rsi)
        (set! unsafe-vector-set!.2 rdx)
        (set! tmp.27 rcx)
        (set! tmp.26 r8)
        (if (neq? tmp.209 6)
          (begin
            (set! tmp.423 (bitwise-and tmp.25 7))
            (set! tmp.212 tmp.423)
            (if (eq? tmp.212 3)
              (begin
                (set! r8 tmp.25)
                (set! rcx tmp.26)
                (set! rdx tmp.27)
                (set! rsi unsafe-vector-set!.2)
                (set! rdi 14)
                (set! r15 ra.422)
                (jump L.jp.69 rbp r15 r8 rcx rdx rsi rdi))
              (begin
                (set! r8 tmp.25)
                (set! rcx tmp.26)
                (set! rdx tmp.27)
                (set! rsi unsafe-vector-set!.2)
                (set! rdi 6)
                (set! r15 ra.422)
                (jump L.jp.69 rbp r15 r8 rcx rdx rsi rdi))))
          (begin (set! rax 2366) (jump ra.422 rbp rax)))))
    (define L.jp.69
      ((new-frames ())
       (locals
        (tmp.211 ra.424 tmp.25 tmp.26 tmp.27 tmp.117 unsafe-vector-set!.2))
       (undead-out
        ((rdi rsi rdx rcx r8 ra.424 rbp)
         (rsi rdx rcx r8 tmp.211 ra.424 rbp)
         (rdx rcx r8 tmp.211 unsafe-vector-set!.2 ra.424 rbp)
         (rcx r8 tmp.211 tmp.27 unsafe-vector-set!.2 ra.424 rbp)
         (r8 tmp.211 tmp.27 tmp.26 unsafe-vector-set!.2 ra.424 rbp)
         (tmp.211 tmp.27 tmp.26 tmp.25 unsafe-vector-set!.2 ra.424 rbp)
         ((tmp.27 tmp.26 tmp.25 unsafe-vector-set!.2 ra.424 rbp)
          ((tmp.27 tmp.26 tmp.25 unsafe-vector-set!.2 ra.424 rbp)
           (tmp.26 tmp.25 unsafe-vector-set!.2 ra.424 rcx rbp)
           (tmp.25 unsafe-vector-set!.2 ra.424 rdx rcx rbp)
           (unsafe-vector-set!.2 ra.424 rsi rdx rcx rbp)
           (ra.424 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp))
          ((ra.424 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.424 rbp))
         (rbp
          (tmp.25
           tmp.26
           tmp.27
           unsafe-vector-set!.2
           tmp.211
           ra.424
           r15
           rdi
           rsi
           rdx
           rcx
           tmp.117
           rax))
         (ra.424
          (tmp.25
           tmp.26
           tmp.27
           unsafe-vector-set!.2
           tmp.211
           r8
           rbp
           rdi
           rsi
           rdx
           rcx
           tmp.117
           rax))
         (tmp.117 (tmp.27 tmp.26 tmp.25 ra.424 rbp))
         (tmp.25
          (tmp.211
           tmp.27
           tmp.26
           unsafe-vector-set!.2
           ra.424
           rbp
           rdx
           rcx
           tmp.117))
         (tmp.26
          (tmp.25
           r8
           tmp.211
           tmp.27
           unsafe-vector-set!.2
           ra.424
           rbp
           rcx
           tmp.117))
         (tmp.27
          (tmp.25
           tmp.26
           rcx
           r8
           tmp.211
           unsafe-vector-set!.2
           ra.424
           rbp
           tmp.117))
         (rcx
          (tmp.27
           tmp.211
           r15
           rdi
           rsi
           rdx
           tmp.26
           tmp.25
           unsafe-vector-set!.2
           ra.424
           rbp))
         (unsafe-vector-set!.2
          (tmp.25 tmp.26 tmp.27 r8 tmp.211 ra.424 rbp rsi rdx rcx))
         (rdx (tmp.211 r15 rdi rsi tmp.25 unsafe-vector-set!.2 ra.424 rcx rbp))
         (rsi (tmp.211 r15 rdi unsafe-vector-set!.2 ra.424 rdx rcx rbp))
         (rdi (r15 ra.424 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (r8 (tmp.26 tmp.27 unsafe-vector-set!.2 tmp.211 ra.424))
         (tmp.211
          (tmp.25
           tmp.26
           tmp.27
           unsafe-vector-set!.2
           rsi
           rdx
           rcx
           r8
           ra.424
           rbp)))))
      (begin
        (set! ra.424 r15)
        (set! tmp.211 rdi)
        (set! unsafe-vector-set!.2 rsi)
        (set! tmp.27 rdx)
        (set! tmp.26 rcx)
        (set! tmp.25 r8)
        (if (neq? tmp.211 6)
          (begin
            (set! tmp.117 unsafe-vector-set!.2)
            (set! rcx tmp.27)
            (set! rdx tmp.26)
            (set! rsi tmp.25)
            (set! rdi unsafe-vector-set!.2)
            (set! r15 ra.424)
            (jump L.unsafe-vector-set!.2.2 rbp r15 rcx rdx rsi rdi))
          (begin (set! rax 2366) (jump ra.424 rbp rax)))))
    (define L.jp.66
      ((new-frames ())
       (locals (ra.425 tmp.206 tmp.24))
       (undead-out
        ((rdi rsi ra.425 rbp)
         (rsi tmp.206 ra.425 rbp)
         (tmp.206 tmp.24 ra.425 rbp)
         ((tmp.24 ra.425 rbp)
          ((ra.425 rax rbp) (rax rbp))
          ((ra.425 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.425 rbp))
         (rbp (tmp.24 tmp.206 ra.425 rax))
         (ra.425 (tmp.24 tmp.206 rdi rsi rbp rax))
         (rsi (tmp.206 ra.425))
         (rdi (ra.425))
         (tmp.206 (tmp.24 rsi ra.425 rbp))
         (tmp.24 (tmp.206 ra.425 rbp)))))
      (begin
        (set! ra.425 r15)
        (set! tmp.206 rdi)
        (set! tmp.24 rsi)
        (if (neq? tmp.206 6)
          (begin (set! rax (mref tmp.24 -3)) (jump ra.425 rbp rax))
          (begin (set! rax 2110) (jump ra.425 rbp rax)))))
    (define L.jp.64
      ((new-frames ())
       (locals (tmp.203 ra.426 tmp.23 tmp.118 make-init-vector.1))
       (undead-out
        ((rdi rsi rdx ra.426 rbp)
         (rsi rdx tmp.203 ra.426 rbp)
         (rdx tmp.203 make-init-vector.1 ra.426 rbp)
         (tmp.203 tmp.23 make-init-vector.1 ra.426 rbp)
         ((tmp.23 make-init-vector.1 ra.426 rbp)
          ((tmp.23 make-init-vector.1 ra.426 rbp)
           (make-init-vector.1 ra.426 rsi rbp)
           (ra.426 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp))
          ((ra.426 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.426 rbp))
         (rbp
          (tmp.23 make-init-vector.1 tmp.203 ra.426 r15 rdi rsi tmp.118 rax))
         (ra.426
          (tmp.23 make-init-vector.1 tmp.203 rdx rbp rdi rsi tmp.118 rax))
         (tmp.118 (tmp.23 ra.426 rbp))
         (tmp.23 (tmp.203 make-init-vector.1 ra.426 rbp tmp.118))
         (rsi (tmp.203 r15 rdi make-init-vector.1 ra.426 rbp))
         (make-init-vector.1 (tmp.23 rdx tmp.203 ra.426 rbp rsi))
         (rdi (r15 ra.426 rsi rbp))
         (r15 (rdi rsi rbp))
         (rdx (make-init-vector.1 tmp.203 ra.426))
         (tmp.203 (tmp.23 make-init-vector.1 rsi rdx ra.426 rbp)))))
      (begin
        (set! ra.426 r15)
        (set! tmp.203 rdi)
        (set! make-init-vector.1 rsi)
        (set! tmp.23 rdx)
        (if (neq? tmp.203 6)
          (begin
            (set! tmp.118 make-init-vector.1)
            (set! rsi tmp.23)
            (set! rdi make-init-vector.1)
            (set! r15 ra.426)
            (jump L.make-init-vector.1.4 rbp r15 rsi rdi))
          (begin (set! rax 1854) (jump ra.426 rbp rax)))))
    (define L.jp.62
      ((new-frames ())
       (locals (tmp.196 tmp.428 tmp.200 ra.427 tmp.21 tmp.22))
       (undead-out
        ((rdi rsi rdx ra.427 rbp)
         (rsi rdx tmp.196 ra.427 rbp)
         (rdx tmp.196 tmp.21 ra.427 rbp)
         (tmp.196 tmp.22 tmp.21 ra.427 rbp)
         ((tmp.22 tmp.21 ra.427 rbp)
          ((tmp.428 tmp.22 tmp.21 ra.427 rbp)
           (tmp.200 tmp.22 tmp.21 ra.427 rbp)
           ((tmp.22 tmp.21 ra.427 rbp)
            ((tmp.21 ra.427 rdx rbp)
             (ra.427 rsi rdx rbp)
             (ra.427 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.21 ra.427 rdx rbp)
             (ra.427 rsi rdx rbp)
             (ra.427 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.427 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.427 rbp))
         (rbp
          (tmp.22 tmp.21 tmp.196 ra.427 tmp.200 tmp.428 r15 rdi rsi rdx rax))
         (ra.427 (tmp.22 tmp.21 tmp.196 rbp tmp.200 tmp.428 rdi rsi rdx rax))
         (rdx (tmp.196 r15 rdi rsi tmp.21 ra.427 rbp))
         (tmp.21 (tmp.22 tmp.196 ra.427 rbp tmp.200 tmp.428 rdx))
         (rsi (tmp.196 r15 rdi ra.427 rdx rbp))
         (rdi (r15 ra.427 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.428 (rbp ra.427 tmp.21 tmp.22))
         (tmp.22 (tmp.196 tmp.21 ra.427 rbp tmp.200 tmp.428))
         (tmp.200 (tmp.22 tmp.21 ra.427 rbp))
         (tmp.196 (tmp.22 tmp.21 rsi rdx ra.427 rbp)))))
      (begin
        (set! ra.427 r15)
        (set! tmp.196 rdi)
        (set! tmp.21 rsi)
        (set! tmp.22 rdx)
        (if (neq? tmp.196 6)
          (begin
            (set! tmp.428 (bitwise-and tmp.21 7))
            (set! tmp.200 tmp.428)
            (if (eq? tmp.200 0)
              (begin
                (set! rdx tmp.22)
                (set! rsi tmp.21)
                (set! rdi 14)
                (set! r15 ra.427)
                (jump L.jp.61 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.22)
                (set! rsi tmp.21)
                (set! rdi 6)
                (set! r15 ra.427)
                (jump L.jp.61 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1598) (jump ra.427 rbp rax)))))
    (define L.jp.61
      ((new-frames ())
       (locals (ra.429 tmp.198 tmp.22 tmp.21))
       (undead-out
        ((rdi rsi rdx ra.429 rbp)
         (rsi rdx tmp.198 ra.429 rbp)
         (rdx tmp.198 tmp.21 ra.429 rbp)
         (tmp.198 tmp.21 tmp.22 ra.429 rbp)
         ((tmp.21 tmp.22 ra.429 rbp)
          ((ra.429 rbp)
           ((ra.429 rax rbp) (rax rbp))
           ((ra.429 rax rbp) (rax rbp)))
          ((ra.429 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.429 rbp))
         (rbp (tmp.22 tmp.21 tmp.198 ra.429 rax))
         (ra.429 (tmp.22 tmp.21 tmp.198 rdi rsi rdx rbp rax))
         (rdx (tmp.21 tmp.198 ra.429))
         (rsi (tmp.198 ra.429))
         (rdi (ra.429))
         (tmp.198 (tmp.22 tmp.21 rsi rdx ra.429 rbp))
         (tmp.21 (tmp.22 rdx tmp.198 ra.429 rbp))
         (tmp.22 (tmp.198 tmp.21 ra.429 rbp)))))
      (begin
        (set! ra.429 r15)
        (set! tmp.198 rdi)
        (set! tmp.21 rsi)
        (set! tmp.22 rdx)
        (if (neq? tmp.198 6)
          (if (>= tmp.21 tmp.22)
            (begin (set! rax 14) (jump ra.429 rbp rax))
            (begin (set! rax 6) (jump ra.429 rbp rax)))
          (begin (set! rax 1598) (jump ra.429 rbp rax)))))
    (define L.jp.57
      ((new-frames ())
       (locals (tmp.189 tmp.431 tmp.193 ra.430 tmp.19 tmp.20))
       (undead-out
        ((rdi rsi rdx ra.430 rbp)
         (rsi rdx tmp.189 ra.430 rbp)
         (rdx tmp.189 tmp.19 ra.430 rbp)
         (tmp.189 tmp.20 tmp.19 ra.430 rbp)
         ((tmp.20 tmp.19 ra.430 rbp)
          ((tmp.431 tmp.20 tmp.19 ra.430 rbp)
           (tmp.193 tmp.20 tmp.19 ra.430 rbp)
           ((tmp.20 tmp.19 ra.430 rbp)
            ((tmp.19 ra.430 rdx rbp)
             (ra.430 rsi rdx rbp)
             (ra.430 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.19 ra.430 rdx rbp)
             (ra.430 rsi rdx rbp)
             (ra.430 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.430 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.430 rbp))
         (rbp
          (tmp.20 tmp.19 tmp.189 ra.430 tmp.193 tmp.431 r15 rdi rsi rdx rax))
         (ra.430 (tmp.20 tmp.19 tmp.189 rbp tmp.193 tmp.431 rdi rsi rdx rax))
         (rdx (tmp.189 r15 rdi rsi tmp.19 ra.430 rbp))
         (tmp.19 (tmp.20 tmp.189 ra.430 rbp tmp.193 tmp.431 rdx))
         (rsi (tmp.189 r15 rdi ra.430 rdx rbp))
         (rdi (r15 ra.430 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.431 (rbp ra.430 tmp.19 tmp.20))
         (tmp.20 (tmp.189 tmp.19 ra.430 rbp tmp.193 tmp.431))
         (tmp.193 (tmp.20 tmp.19 ra.430 rbp))
         (tmp.189 (tmp.20 tmp.19 rsi rdx ra.430 rbp)))))
      (begin
        (set! ra.430 r15)
        (set! tmp.189 rdi)
        (set! tmp.19 rsi)
        (set! tmp.20 rdx)
        (if (neq? tmp.189 6)
          (begin
            (set! tmp.431 (bitwise-and tmp.19 7))
            (set! tmp.193 tmp.431)
            (if (eq? tmp.193 0)
              (begin
                (set! rdx tmp.20)
                (set! rsi tmp.19)
                (set! rdi 14)
                (set! r15 ra.430)
                (jump L.jp.56 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.20)
                (set! rsi tmp.19)
                (set! rdi 6)
                (set! r15 ra.430)
                (jump L.jp.56 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1342) (jump ra.430 rbp rax)))))
    (define L.jp.56
      ((new-frames ())
       (locals (ra.432 tmp.191 tmp.20 tmp.19))
       (undead-out
        ((rdi rsi rdx ra.432 rbp)
         (rsi rdx tmp.191 ra.432 rbp)
         (rdx tmp.191 tmp.19 ra.432 rbp)
         (tmp.191 tmp.19 tmp.20 ra.432 rbp)
         ((tmp.19 tmp.20 ra.432 rbp)
          ((ra.432 rbp)
           ((ra.432 rax rbp) (rax rbp))
           ((ra.432 rax rbp) (rax rbp)))
          ((ra.432 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.432 rbp))
         (rbp (tmp.20 tmp.19 tmp.191 ra.432 rax))
         (ra.432 (tmp.20 tmp.19 tmp.191 rdi rsi rdx rbp rax))
         (rdx (tmp.19 tmp.191 ra.432))
         (rsi (tmp.191 ra.432))
         (rdi (ra.432))
         (tmp.191 (tmp.20 tmp.19 rsi rdx ra.432 rbp))
         (tmp.19 (tmp.20 rdx tmp.191 ra.432 rbp))
         (tmp.20 (tmp.191 tmp.19 ra.432 rbp)))))
      (begin
        (set! ra.432 r15)
        (set! tmp.191 rdi)
        (set! tmp.19 rsi)
        (set! tmp.20 rdx)
        (if (neq? tmp.191 6)
          (if (> tmp.19 tmp.20)
            (begin (set! rax 14) (jump ra.432 rbp rax))
            (begin (set! rax 6) (jump ra.432 rbp rax)))
          (begin (set! rax 1342) (jump ra.432 rbp rax)))))
    (define L.jp.52
      ((new-frames ())
       (locals (tmp.182 tmp.434 tmp.186 ra.433 tmp.17 tmp.18))
       (undead-out
        ((rdi rsi rdx ra.433 rbp)
         (rsi rdx tmp.182 ra.433 rbp)
         (rdx tmp.182 tmp.17 ra.433 rbp)
         (tmp.182 tmp.18 tmp.17 ra.433 rbp)
         ((tmp.18 tmp.17 ra.433 rbp)
          ((tmp.434 tmp.18 tmp.17 ra.433 rbp)
           (tmp.186 tmp.18 tmp.17 ra.433 rbp)
           ((tmp.18 tmp.17 ra.433 rbp)
            ((tmp.17 ra.433 rdx rbp)
             (ra.433 rsi rdx rbp)
             (ra.433 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.17 ra.433 rdx rbp)
             (ra.433 rsi rdx rbp)
             (ra.433 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.433 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.433 rbp))
         (rbp
          (tmp.18 tmp.17 tmp.182 ra.433 tmp.186 tmp.434 r15 rdi rsi rdx rax))
         (ra.433 (tmp.18 tmp.17 tmp.182 rbp tmp.186 tmp.434 rdi rsi rdx rax))
         (rdx (tmp.182 r15 rdi rsi tmp.17 ra.433 rbp))
         (tmp.17 (tmp.18 tmp.182 ra.433 rbp tmp.186 tmp.434 rdx))
         (rsi (tmp.182 r15 rdi ra.433 rdx rbp))
         (rdi (r15 ra.433 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.434 (rbp ra.433 tmp.17 tmp.18))
         (tmp.18 (tmp.182 tmp.17 ra.433 rbp tmp.186 tmp.434))
         (tmp.186 (tmp.18 tmp.17 ra.433 rbp))
         (tmp.182 (tmp.18 tmp.17 rsi rdx ra.433 rbp)))))
      (begin
        (set! ra.433 r15)
        (set! tmp.182 rdi)
        (set! tmp.17 rsi)
        (set! tmp.18 rdx)
        (if (neq? tmp.182 6)
          (begin
            (set! tmp.434 (bitwise-and tmp.17 7))
            (set! tmp.186 tmp.434)
            (if (eq? tmp.186 0)
              (begin
                (set! rdx tmp.18)
                (set! rsi tmp.17)
                (set! rdi 14)
                (set! r15 ra.433)
                (jump L.jp.51 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.18)
                (set! rsi tmp.17)
                (set! rdi 6)
                (set! r15 ra.433)
                (jump L.jp.51 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1086) (jump ra.433 rbp rax)))))
    (define L.jp.51
      ((new-frames ())
       (locals (ra.435 tmp.184 tmp.18 tmp.17))
       (undead-out
        ((rdi rsi rdx ra.435 rbp)
         (rsi rdx tmp.184 ra.435 rbp)
         (rdx tmp.184 tmp.17 ra.435 rbp)
         (tmp.184 tmp.17 tmp.18 ra.435 rbp)
         ((tmp.17 tmp.18 ra.435 rbp)
          ((ra.435 rbp)
           ((ra.435 rax rbp) (rax rbp))
           ((ra.435 rax rbp) (rax rbp)))
          ((ra.435 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.435 rbp))
         (rbp (tmp.18 tmp.17 tmp.184 ra.435 rax))
         (ra.435 (tmp.18 tmp.17 tmp.184 rdi rsi rdx rbp rax))
         (rdx (tmp.17 tmp.184 ra.435))
         (rsi (tmp.184 ra.435))
         (rdi (ra.435))
         (tmp.184 (tmp.18 tmp.17 rsi rdx ra.435 rbp))
         (tmp.17 (tmp.18 rdx tmp.184 ra.435 rbp))
         (tmp.18 (tmp.184 tmp.17 ra.435 rbp)))))
      (begin
        (set! ra.435 r15)
        (set! tmp.184 rdi)
        (set! tmp.17 rsi)
        (set! tmp.18 rdx)
        (if (neq? tmp.184 6)
          (if (<= tmp.17 tmp.18)
            (begin (set! rax 14) (jump ra.435 rbp rax))
            (begin (set! rax 6) (jump ra.435 rbp rax)))
          (begin (set! rax 1086) (jump ra.435 rbp rax)))))
    (define L.jp.47
      ((new-frames ())
       (locals (tmp.175 tmp.437 tmp.179 ra.436 tmp.15 tmp.16))
       (undead-out
        ((rdi rsi rdx ra.436 rbp)
         (rsi rdx tmp.175 ra.436 rbp)
         (rdx tmp.175 tmp.15 ra.436 rbp)
         (tmp.175 tmp.16 tmp.15 ra.436 rbp)
         ((tmp.16 tmp.15 ra.436 rbp)
          ((tmp.437 tmp.16 tmp.15 ra.436 rbp)
           (tmp.179 tmp.16 tmp.15 ra.436 rbp)
           ((tmp.16 tmp.15 ra.436 rbp)
            ((tmp.15 ra.436 rdx rbp)
             (ra.436 rsi rdx rbp)
             (ra.436 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.15 ra.436 rdx rbp)
             (ra.436 rsi rdx rbp)
             (ra.436 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.436 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.436 rbp))
         (rbp
          (tmp.16 tmp.15 tmp.175 ra.436 tmp.179 tmp.437 r15 rdi rsi rdx rax))
         (ra.436 (tmp.16 tmp.15 tmp.175 rbp tmp.179 tmp.437 rdi rsi rdx rax))
         (rdx (tmp.175 r15 rdi rsi tmp.15 ra.436 rbp))
         (tmp.15 (tmp.16 tmp.175 ra.436 rbp tmp.179 tmp.437 rdx))
         (rsi (tmp.175 r15 rdi ra.436 rdx rbp))
         (rdi (r15 ra.436 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.437 (rbp ra.436 tmp.15 tmp.16))
         (tmp.16 (tmp.175 tmp.15 ra.436 rbp tmp.179 tmp.437))
         (tmp.179 (tmp.16 tmp.15 ra.436 rbp))
         (tmp.175 (tmp.16 tmp.15 rsi rdx ra.436 rbp)))))
      (begin
        (set! ra.436 r15)
        (set! tmp.175 rdi)
        (set! tmp.15 rsi)
        (set! tmp.16 rdx)
        (if (neq? tmp.175 6)
          (begin
            (set! tmp.437 (bitwise-and tmp.15 7))
            (set! tmp.179 tmp.437)
            (if (eq? tmp.179 0)
              (begin
                (set! rdx tmp.16)
                (set! rsi tmp.15)
                (set! rdi 14)
                (set! r15 ra.436)
                (jump L.jp.46 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.16)
                (set! rsi tmp.15)
                (set! rdi 6)
                (set! r15 ra.436)
                (jump L.jp.46 rbp r15 rdx rsi rdi))))
          (begin (set! rax 830) (jump ra.436 rbp rax)))))
    (define L.jp.46
      ((new-frames ())
       (locals (ra.438 tmp.177 tmp.16 tmp.15))
       (undead-out
        ((rdi rsi rdx ra.438 rbp)
         (rsi rdx tmp.177 ra.438 rbp)
         (rdx tmp.177 tmp.15 ra.438 rbp)
         (tmp.177 tmp.15 tmp.16 ra.438 rbp)
         ((tmp.15 tmp.16 ra.438 rbp)
          ((ra.438 rbp)
           ((ra.438 rax rbp) (rax rbp))
           ((ra.438 rax rbp) (rax rbp)))
          ((ra.438 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.438 rbp))
         (rbp (tmp.16 tmp.15 tmp.177 ra.438 rax))
         (ra.438 (tmp.16 tmp.15 tmp.177 rdi rsi rdx rbp rax))
         (rdx (tmp.15 tmp.177 ra.438))
         (rsi (tmp.177 ra.438))
         (rdi (ra.438))
         (tmp.177 (tmp.16 tmp.15 rsi rdx ra.438 rbp))
         (tmp.15 (tmp.16 rdx tmp.177 ra.438 rbp))
         (tmp.16 (tmp.177 tmp.15 ra.438 rbp)))))
      (begin
        (set! ra.438 r15)
        (set! tmp.177 rdi)
        (set! tmp.15 rsi)
        (set! tmp.16 rdx)
        (if (neq? tmp.177 6)
          (if (< tmp.15 tmp.16)
            (begin (set! rax 14) (jump ra.438 rbp rax))
            (begin (set! rax 6) (jump ra.438 rbp rax)))
          (begin (set! rax 830) (jump ra.438 rbp rax)))))
    (define L.jp.42
      ((new-frames ())
       (locals (tmp.169 tmp.440 tmp.172 ra.439 tmp.13 tmp.14))
       (undead-out
        ((rdi rsi rdx ra.439 rbp)
         (rsi rdx tmp.169 ra.439 rbp)
         (rdx tmp.169 tmp.13 ra.439 rbp)
         (tmp.169 tmp.14 tmp.13 ra.439 rbp)
         ((tmp.14 tmp.13 ra.439 rbp)
          ((tmp.440 tmp.14 tmp.13 ra.439 rbp)
           (tmp.172 tmp.14 tmp.13 ra.439 rbp)
           ((tmp.14 tmp.13 ra.439 rbp)
            ((tmp.13 ra.439 rdx rbp)
             (ra.439 rsi rdx rbp)
             (ra.439 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.13 ra.439 rdx rbp)
             (ra.439 rsi rdx rbp)
             (ra.439 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.439 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.439 rbp))
         (rbp
          (tmp.14 tmp.13 tmp.169 ra.439 tmp.172 tmp.440 r15 rdi rsi rdx rax))
         (ra.439 (tmp.14 tmp.13 tmp.169 rbp tmp.172 tmp.440 rdi rsi rdx rax))
         (rdx (tmp.169 r15 rdi rsi tmp.13 ra.439 rbp))
         (tmp.13 (tmp.14 tmp.169 ra.439 rbp tmp.172 tmp.440 rdx))
         (rsi (tmp.169 r15 rdi ra.439 rdx rbp))
         (rdi (r15 ra.439 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.440 (rbp ra.439 tmp.13 tmp.14))
         (tmp.14 (tmp.169 tmp.13 ra.439 rbp tmp.172 tmp.440))
         (tmp.172 (tmp.14 tmp.13 ra.439 rbp))
         (tmp.169 (tmp.14 tmp.13 rsi rdx ra.439 rbp)))))
      (begin
        (set! ra.439 r15)
        (set! tmp.169 rdi)
        (set! tmp.13 rsi)
        (set! tmp.14 rdx)
        (if (neq? tmp.169 6)
          (begin
            (set! tmp.440 (bitwise-and tmp.13 7))
            (set! tmp.172 tmp.440)
            (if (eq? tmp.172 0)
              (begin
                (set! rdx tmp.14)
                (set! rsi tmp.13)
                (set! rdi 14)
                (set! r15 ra.439)
                (jump L.jp.41 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.14)
                (set! rsi tmp.13)
                (set! rdi 6)
                (set! r15 ra.439)
                (jump L.jp.41 rbp r15 rdx rsi rdi))))
          (begin (set! rax 574) (jump ra.439 rbp rax)))))
    (define L.jp.41
      ((new-frames ())
       (locals (ra.441 tmp.171 tmp.442 tmp.13 tmp.14))
       (undead-out
        ((rdi rsi rdx ra.441 rbp)
         (rsi rdx tmp.171 ra.441 rbp)
         (rdx tmp.171 tmp.13 ra.441 rbp)
         (tmp.171 tmp.14 tmp.13 ra.441 rbp)
         ((tmp.14 tmp.13 ra.441 rbp)
          ((tmp.442 ra.441 rbp) (ra.441 rax rbp) (rax rbp))
          ((ra.441 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.441 rbp))
         (rbp (tmp.14 tmp.13 tmp.171 ra.441 tmp.442 rax))
         (ra.441 (tmp.14 tmp.13 tmp.171 rdi rsi rdx rbp tmp.442 rax))
         (tmp.442 (rbp ra.441))
         (rdx (tmp.13 tmp.171 ra.441))
         (rsi (tmp.171 ra.441))
         (rdi (ra.441))
         (tmp.171 (tmp.14 tmp.13 rsi rdx ra.441 rbp))
         (tmp.13 (tmp.14 rdx tmp.171 ra.441 rbp))
         (tmp.14 (tmp.171 tmp.13 ra.441 rbp)))))
      (begin
        (set! ra.441 r15)
        (set! tmp.171 rdi)
        (set! tmp.13 rsi)
        (set! tmp.14 rdx)
        (if (neq? tmp.171 6)
          (begin
            (set! tmp.442 (- tmp.13 tmp.14))
            (set! rax tmp.442)
            (jump ra.441 rbp rax))
          (begin (set! rax 574) (jump ra.441 rbp rax)))))
    (define L.jp.38
      ((new-frames ())
       (locals (tmp.163 tmp.444 tmp.166 ra.443 tmp.11 tmp.12))
       (undead-out
        ((rdi rsi rdx ra.443 rbp)
         (rsi rdx tmp.163 ra.443 rbp)
         (rdx tmp.163 tmp.11 ra.443 rbp)
         (tmp.163 tmp.12 tmp.11 ra.443 rbp)
         ((tmp.12 tmp.11 ra.443 rbp)
          ((tmp.444 tmp.12 tmp.11 ra.443 rbp)
           (tmp.166 tmp.12 tmp.11 ra.443 rbp)
           ((tmp.12 tmp.11 ra.443 rbp)
            ((tmp.11 ra.443 rdx rbp)
             (ra.443 rsi rdx rbp)
             (ra.443 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.11 ra.443 rdx rbp)
             (ra.443 rsi rdx rbp)
             (ra.443 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.443 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.443 rbp))
         (rbp
          (tmp.12 tmp.11 tmp.163 ra.443 tmp.166 tmp.444 r15 rdi rsi rdx rax))
         (ra.443 (tmp.12 tmp.11 tmp.163 rbp tmp.166 tmp.444 rdi rsi rdx rax))
         (rdx (tmp.163 r15 rdi rsi tmp.11 ra.443 rbp))
         (tmp.11 (tmp.12 tmp.163 ra.443 rbp tmp.166 tmp.444 rdx))
         (rsi (tmp.163 r15 rdi ra.443 rdx rbp))
         (rdi (r15 ra.443 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.444 (rbp ra.443 tmp.11 tmp.12))
         (tmp.12 (tmp.163 tmp.11 ra.443 rbp tmp.166 tmp.444))
         (tmp.166 (tmp.12 tmp.11 ra.443 rbp))
         (tmp.163 (tmp.12 tmp.11 rsi rdx ra.443 rbp)))))
      (begin
        (set! ra.443 r15)
        (set! tmp.163 rdi)
        (set! tmp.11 rsi)
        (set! tmp.12 rdx)
        (if (neq? tmp.163 6)
          (begin
            (set! tmp.444 (bitwise-and tmp.11 7))
            (set! tmp.166 tmp.444)
            (if (eq? tmp.166 0)
              (begin
                (set! rdx tmp.12)
                (set! rsi tmp.11)
                (set! rdi 14)
                (set! r15 ra.443)
                (jump L.jp.37 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.12)
                (set! rsi tmp.11)
                (set! rdi 6)
                (set! r15 ra.443)
                (jump L.jp.37 rbp r15 rdx rsi rdi))))
          (begin (set! rax 318) (jump ra.443 rbp rax)))))
    (define L.jp.37
      ((new-frames ())
       (locals (ra.445 tmp.165 tmp.446 tmp.11 tmp.12))
       (undead-out
        ((rdi rsi rdx ra.445 rbp)
         (rsi rdx tmp.165 ra.445 rbp)
         (rdx tmp.165 tmp.11 ra.445 rbp)
         (tmp.165 tmp.12 tmp.11 ra.445 rbp)
         ((tmp.12 tmp.11 ra.445 rbp)
          ((tmp.446 ra.445 rbp) (ra.445 rax rbp) (rax rbp))
          ((ra.445 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.445 rbp))
         (rbp (tmp.12 tmp.11 tmp.165 ra.445 tmp.446 rax))
         (ra.445 (tmp.12 tmp.11 tmp.165 rdi rsi rdx rbp tmp.446 rax))
         (tmp.446 (rbp ra.445))
         (rdx (tmp.11 tmp.165 ra.445))
         (rsi (tmp.165 ra.445))
         (rdi (ra.445))
         (tmp.165 (tmp.12 tmp.11 rsi rdx ra.445 rbp))
         (tmp.11 (tmp.12 rdx tmp.165 ra.445 rbp))
         (tmp.12 (tmp.165 tmp.11 ra.445 rbp)))))
      (begin
        (set! ra.445 r15)
        (set! tmp.165 rdi)
        (set! tmp.11 rsi)
        (set! tmp.12 rdx)
        (if (neq? tmp.165 6)
          (begin
            (set! tmp.446 (+ tmp.11 tmp.12))
            (set! rax tmp.446)
            (jump ra.445 rbp rax))
          (begin (set! rax 318) (jump ra.445 rbp rax)))))
    (define L.jp.34
      ((new-frames ())
       (locals (tmp.156 tmp.448 tmp.160 ra.447 tmp.10 tmp.9))
       (undead-out
        ((rdi rsi rdx ra.447 rbp)
         (rsi rdx tmp.156 ra.447 rbp)
         (rdx tmp.156 tmp.9 ra.447 rbp)
         (tmp.156 tmp.9 tmp.10 ra.447 rbp)
         ((tmp.9 tmp.10 ra.447 rbp)
          ((tmp.448 tmp.9 tmp.10 ra.447 rbp)
           (tmp.160 tmp.9 tmp.10 ra.447 rbp)
           ((tmp.9 tmp.10 ra.447 rbp)
            ((tmp.10 ra.447 rdx rbp)
             (ra.447 rsi rdx rbp)
             (ra.447 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.10 ra.447 rdx rbp)
             (ra.447 rsi rdx rbp)
             (ra.447 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.447 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.447 rbp))
         (rbp
          (tmp.10 tmp.9 tmp.156 ra.447 tmp.160 tmp.448 r15 rdi rsi rdx rax))
         (ra.447 (tmp.10 tmp.9 tmp.156 rbp tmp.160 tmp.448 rdi rsi rdx rax))
         (rdx (tmp.9 tmp.156 r15 rdi rsi tmp.10 ra.447 rbp))
         (tmp.10 (tmp.156 tmp.9 ra.447 rbp tmp.160 tmp.448 rdx))
         (rsi (tmp.156 r15 rdi ra.447 rdx rbp))
         (rdi (r15 ra.447 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.448 (rbp ra.447 tmp.10 tmp.9))
         (tmp.9 (tmp.10 rdx tmp.156 ra.447 rbp tmp.160 tmp.448))
         (tmp.160 (tmp.9 tmp.10 ra.447 rbp))
         (tmp.156 (tmp.10 tmp.9 rsi rdx ra.447 rbp)))))
      (begin
        (set! ra.447 r15)
        (set! tmp.156 rdi)
        (set! tmp.9 rsi)
        (set! tmp.10 rdx)
        (if (neq? tmp.156 6)
          (begin
            (set! tmp.448 (bitwise-and tmp.9 7))
            (set! tmp.160 tmp.448)
            (if (eq? tmp.160 0)
              (begin
                (set! rdx tmp.9)
                (set! rsi tmp.10)
                (set! rdi 14)
                (set! r15 ra.447)
                (jump L.jp.33 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.9)
                (set! rsi tmp.10)
                (set! rdi 6)
                (set! r15 ra.447)
                (jump L.jp.33 rbp r15 rdx rsi rdi))))
          (begin (set! rax 62) (jump ra.447 rbp rax)))))
    (define L.jp.33
      ((new-frames ())
       (locals (ra.449 tmp.158 tmp.451 tmp.9 tmp.159 tmp.450 tmp.10))
       (undead-out
        ((rdi rsi rdx ra.449 rbp)
         (rsi rdx tmp.158 ra.449 rbp)
         (rdx tmp.158 tmp.10 ra.449 rbp)
         (tmp.158 tmp.10 tmp.9 ra.449 rbp)
         ((tmp.10 tmp.9 ra.449 rbp)
          ((tmp.450 tmp.9 ra.449 rbp)
           (tmp.159 tmp.9 ra.449 rbp)
           (tmp.451 ra.449 rbp)
           (ra.449 rax rbp)
           (rax rbp))
          ((ra.449 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.449 rbp))
         (rbp (tmp.9 tmp.10 tmp.158 ra.449 tmp.451 tmp.159 tmp.450 rax))
         (ra.449
          (tmp.9 tmp.10 tmp.158 rdi rsi rdx rbp tmp.451 tmp.159 tmp.450 rax))
         (tmp.450 (rbp ra.449 tmp.9))
         (tmp.9 (tmp.158 tmp.10 ra.449 rbp tmp.159 tmp.450))
         (tmp.159 (tmp.9 ra.449 rbp))
         (tmp.451 (rbp ra.449))
         (rdx (tmp.10 tmp.158 ra.449))
         (rsi (tmp.158 ra.449))
         (rdi (ra.449))
         (tmp.158 (tmp.9 tmp.10 rsi rdx ra.449 rbp))
         (tmp.10 (tmp.9 rdx tmp.158 ra.449 rbp)))))
      (begin
        (set! ra.449 r15)
        (set! tmp.158 rdi)
        (set! tmp.10 rsi)
        (set! tmp.9 rdx)
        (if (neq? tmp.158 6)
          (begin
            (set! tmp.450 (arithmetic-shift-right tmp.10 3))
            (set! tmp.159 tmp.450)
            (set! tmp.451 (* tmp.9 tmp.159))
            (set! rax tmp.451)
            (jump ra.449 rbp rax))
          (begin (set! rax 62) (jump ra.449 rbp rax))))))
     ) #f))

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
     (execute '(module
    (define L.main.104
      ((new-frames ())
       (locals
        (t.5
         tmp.6
         tmp.276
         tmp.310
         tmp.125
         unsafe-vector-ref.3
         tmp.277
         tmp.311
         tmp.126
         unsafe-vector-set!.2
         tmp.278
         tmp.312
         tmp.127
         vector-init-loop.75
         tmp.279
         tmp.313
         tmp.128
         make-init-vector.1
         tmp.280
         tmp.314
         tmp.129
         eq?.72
         tmp.281
         tmp.315
         tmp.130
         cons.71
         tmp.282
         tmp.316
         tmp.131
         tmp.283
         tmp.317
         tmp.132
         vector?.69
         tmp.284
         tmp.318
         tmp.133
         procedure?.68
         tmp.285
         tmp.319
         tmp.134
         pair?.67
         tmp.286
         tmp.320
         tmp.135
         error?.66
         tmp.287
         tmp.321
         tmp.136
         ascii-char?.65
         tmp.288
         tmp.322
         tmp.137
         void?.64
         tmp.289
         tmp.323
         tmp.138
         empty?.63
         tmp.290
         tmp.324
         tmp.139
         boolean?.62
         tmp.291
         tmp.325
         tmp.140
         fixnum?.61
         tmp.292
         tmp.326
         tmp.141
         procedure-arity.60
         tmp.293
         tmp.327
         tmp.142
         cdr.59
         tmp.294
         tmp.328
         tmp.143
         car.58
         tmp.295
         tmp.329
         tmp.144
         tmp.296
         tmp.330
         tmp.145
         tmp.297
         tmp.331
         tmp.146
         vector-length.55
         tmp.298
         tmp.332
         tmp.147
         make-vector.54
         tmp.299
         tmp.333
         tmp.148
         >=.53
         tmp.300
         tmp.334
         tmp.149
         >.52
         tmp.301
         tmp.335
         tmp.150
         <=.51
         tmp.302
         tmp.336
         tmp.151
         <.50
         tmp.303
         tmp.337
         tmp.152
         |-.49|
         tmp.304
         tmp.338
         tmp.153
         |+.48|
         tmp.305
         tmp.339
         tmp.154
         *.47
         tmp.119))
       (undead-out
        ((r12 rbp ra.309)
         (r12 tmp.276 rbp ra.309)
         (tmp.276 r12 rbp ra.309)
         (tmp.310 r12 rbp ra.309)
         (r12 rbp ra.309 tmp.125)
         (ra.309 rbp r12 tmp.125)
         (tmp.125 r12 rbp ra.309)
         (r12 rbp ra.309 unsafe-vector-ref.3)
         (r12 tmp.277 rbp ra.309 unsafe-vector-ref.3)
         (tmp.277 r12 rbp ra.309 unsafe-vector-ref.3)
         (tmp.311 r12 rbp ra.309 unsafe-vector-ref.3)
         (r12 rbp ra.309 unsafe-vector-ref.3 tmp.126)
         (unsafe-vector-ref.3 ra.309 rbp r12 tmp.126)
         (tmp.126 r12 rbp ra.309 unsafe-vector-ref.3)
         (r12 unsafe-vector-set!.2 rbp ra.309 unsafe-vector-ref.3)
         (r12 tmp.278 unsafe-vector-set!.2 rbp ra.309 unsafe-vector-ref.3)
         (tmp.278 r12 unsafe-vector-set!.2 rbp ra.309 unsafe-vector-ref.3)
         (tmp.312 r12 unsafe-vector-set!.2 rbp ra.309 unsafe-vector-ref.3)
         (r12 unsafe-vector-set!.2 rbp ra.309 unsafe-vector-ref.3 tmp.127)
         (unsafe-vector-ref.3 ra.309 rbp unsafe-vector-set!.2 r12 tmp.127)
         (tmp.127 r12 unsafe-vector-set!.2 rbp ra.309 unsafe-vector-ref.3)
         (r12
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.279
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.279
          r12
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.313
          r12
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.128)
         (vector-init-loop.75
          unsafe-vector-ref.3
          ra.309
          rbp
          unsafe-vector-set!.2
          r12
          tmp.128)
         (tmp.128
          r12
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.280
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.280
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.314
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.129)
         (vector-init-loop.75
          unsafe-vector-ref.3
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.129)
         (tmp.129
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.281
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.281
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.315
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.130)
         (vector-init-loop.75
          unsafe-vector-ref.3
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.130)
         (tmp.130
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.282
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.282
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.316
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.131)
         (vector-init-loop.75
          unsafe-vector-ref.3
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.131)
         (tmp.131
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.283
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.283
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.317
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.132)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.132)
         (tmp.132
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.284
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.284
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.318
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.133)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.133)
         (tmp.133
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.285
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.285
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.319
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.134)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.134)
         (tmp.134
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.286
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.286
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.320
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.135)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.135)
         (tmp.135
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.287
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.287
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.321
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.136)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.136)
         (tmp.136
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.288
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.288
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.322
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.137)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.137)
         (tmp.137
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.289
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.289
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.323
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.138)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.138)
         (tmp.138
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.290
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.290
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.324
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.139)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.139)
         (tmp.139
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.291
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.291
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.325
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.140)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.140)
         (tmp.140
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.292
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.292
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.326
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.141)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.141)
         (tmp.141
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.293
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.293
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.327
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.142)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.142)
         (tmp.142
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.294
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.294
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.328
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.143)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.143)
         (tmp.143
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          tmp.295
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.295
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (tmp.329
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75
          tmp.144)
         (vector-init-loop.75
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.144)
         (tmp.144
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.296
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.296
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.330
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.145)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.145)
         (tmp.145
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.297
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.297
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.331
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.146)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          r12
          tmp.146)
         (tmp.146
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.298
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.298
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.332
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.147)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          r12
          tmp.147)
         (tmp.147
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.299
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.299
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.333
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.148)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          make-vector.54
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          r12
          tmp.148)
         (tmp.148
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.300
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.300
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.334
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.149)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          make-vector.54
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          r12
          tmp.149)
         (tmp.149
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.301
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.301
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.335
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.150)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          make-vector.54
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          r12
          tmp.150)
         (tmp.150
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.302
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.302
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.336
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.151)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          make-vector.54
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          r12
          tmp.151)
         (tmp.151
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.303
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.303
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.337
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.152)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          make-vector.54
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          r12
          tmp.152)
         (tmp.152
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.304
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.304
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.338
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.153)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          make-vector.54
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          r12
          tmp.153)
         (tmp.153
          r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (r12
          tmp.305
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.305
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (tmp.339
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75
          tmp.154)
         (vector-init-loop.75
          vector-ref.57
          unsafe-vector-ref.3
          make-vector.54
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          make-init-vector.1
          tmp.154)
         (tmp.154
          make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (make-init-vector.1
          vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57
          vector-init-loop.75)
         (vector-ref.57
          unsafe-vector-ref.3
          make-vector.54
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56
          vector-init-loop.75
          make-init-vector.1)
         (vector-set!.56
          unsafe-vector-set!.2
          rbp
          ra.309
          not.70
          make-init-vector.1
          make-vector.54
          unsafe-vector-ref.3
          vector-ref.57)
         (make-vector.54
          make-init-vector.1
          vector-ref.57
          not.70
          ra.309
          rbp
          unsafe-vector-set!.2
          vector-set!.56)
         (rbp
          ra.309
          vector-set!.56
          not.70
          vector-ref.57
          make-init-vector.1
          make-vector.54)
         (make-vector.54 vector-ref.57 not.70 vector-set!.56 ra.309 rbp)
         (make-vector.54 vector-ref.57 not.70 vector-set!.56 x.4 ra.309 rbp)
         (make-vector.54 vector-ref.57 not.70 vector-set!.56 x.4 ra.309 rbp)
         ((rax vector-ref.57 not.70 vector-set!.56 x.4 ra.309 rbp)
          ((make-vector.54 rsi rbp)
           (rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp)))
         (t.5 vector-ref.57 not.70 vector-set!.56 x.4 ra.309 rbp)
         (t.5 vector-ref.57 not.70 vector-set!.56 x.4 tmp.6 ra.309 rbp)
         ((t.5 vector-ref.57 not.70 vector-set!.56 x.4 tmp.6 ra.309 rbp)
          ((vector-ref.57 not.70 vector-set!.56 x.4 tmp.6 ra.309 r9 rbp)
           (not.70 vector-set!.56 x.4 tmp.6 ra.309 r8 r9 rbp)
           (vector-set!.56 x.4 tmp.6 ra.309 rcx r8 r9 rbp)
           (x.4 tmp.6 ra.309 rdx rcx r8 r9 rbp)
           (tmp.6 ra.309 rsi rdx rcx r8 r9 rbp)
           (ra.309 rdi rsi rdx rcx r8 r9 rbp)
           (rdi rsi rdx rcx r8 r9 r15 rbp)
           (rdi rsi rdx rcx r8 r9 r15 rbp))
          ((vector-ref.57 not.70 vector-set!.56 x.4 ra.309 r9 rbp)
           (not.70 vector-set!.56 x.4 ra.309 r8 r9 rbp)
           (vector-set!.56 x.4 ra.309 rcx r8 r9 rbp)
           (x.4 ra.309 rdx rcx r8 r9 rbp)
           (ra.309 rsi rdx rcx r8 r9 rbp)
           (ra.309 rdi rsi rdx rcx r8 r9 rbp)
           (rdi rsi rdx rcx r8 r9 r15 rbp)
           (rdi rsi rdx rcx r8 r9 r15 rbp)))))
       (call-undead (vector-ref.57 not.70 vector-set!.56 x.4 ra.309))
       (conflicts
        ((r9
          (tmp.6
           r15
           rdi
           rsi
           rdx
           rcx
           r8
           vector-ref.57
           not.70
           vector-set!.56
           x.4
           ra.309
           rbp))
         (rbp
          (tmp.6
           t.5
           rax
           tmp.119
           x.4
           *.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           vector-ref.57
           tmp.144
           tmp.329
           tmp.295
           car.58
           tmp.143
           tmp.328
           tmp.294
           cdr.59
           tmp.142
           tmp.327
           tmp.293
           procedure-arity.60
           tmp.141
           tmp.326
           tmp.292
           fixnum?.61
           tmp.140
           tmp.325
           tmp.291
           boolean?.62
           tmp.139
           tmp.324
           tmp.290
           empty?.63
           tmp.138
           tmp.323
           tmp.289
           void?.64
           tmp.137
           tmp.322
           tmp.288
           ascii-char?.65
           tmp.136
           tmp.321
           tmp.287
           error?.66
           tmp.135
           tmp.320
           tmp.286
           pair?.67
           tmp.134
           tmp.319
           tmp.285
           procedure?.68
           tmp.133
           tmp.318
           tmp.284
           vector?.69
           tmp.132
           tmp.317
           tmp.283
           not.70
           tmp.131
           tmp.316
           tmp.282
           cons.71
           tmp.130
           tmp.315
           tmp.281
           eq?.72
           tmp.129
           tmp.314
           tmp.280
           make-init-vector.1
           tmp.128
           tmp.313
           tmp.279
           vector-init-loop.75
           tmp.127
           tmp.312
           tmp.278
           unsafe-vector-set!.2
           tmp.126
           tmp.311
           tmp.277
           unsafe-vector-ref.3
           tmp.125
           tmp.310
           r12
           tmp.276
           ra.309
           r15
           rdi
           rsi
           rdx
           rcx
           r8
           r9))
         (ra.309
          (tmp.6
           t.5
           rax
           tmp.119
           x.4
           *.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           vector-ref.57
           tmp.144
           tmp.329
           tmp.295
           car.58
           tmp.143
           tmp.328
           tmp.294
           cdr.59
           tmp.142
           tmp.327
           tmp.293
           procedure-arity.60
           tmp.141
           tmp.326
           tmp.292
           fixnum?.61
           tmp.140
           tmp.325
           tmp.291
           boolean?.62
           tmp.139
           tmp.324
           tmp.290
           empty?.63
           tmp.138
           tmp.323
           tmp.289
           void?.64
           tmp.137
           tmp.322
           tmp.288
           ascii-char?.65
           tmp.136
           tmp.321
           tmp.287
           error?.66
           tmp.135
           tmp.320
           tmp.286
           pair?.67
           tmp.134
           tmp.319
           tmp.285
           procedure?.68
           tmp.133
           tmp.318
           tmp.284
           vector?.69
           tmp.132
           tmp.317
           tmp.283
           not.70
           tmp.131
           tmp.316
           tmp.282
           cons.71
           tmp.130
           tmp.315
           tmp.281
           eq?.72
           tmp.129
           tmp.314
           tmp.280
           make-init-vector.1
           tmp.128
           tmp.313
           tmp.279
           vector-init-loop.75
           tmp.127
           tmp.312
           tmp.278
           unsafe-vector-set!.2
           tmp.126
           tmp.311
           tmp.277
           unsafe-vector-ref.3
           tmp.125
           tmp.310
           tmp.276
           r12
           rbp
           rdi
           rsi
           rdx
           rcx
           r8
           r9))
         (x.4
          (tmp.6
           t.5
           rax
           tmp.119
           make-vector.54
           vector-ref.57
           not.70
           vector-set!.56
           ra.309
           rbp
           rdx
           rcx
           r8
           r9))
         (vector-set!.56
          (tmp.6
           t.5
           rax
           tmp.119
           x.4
           *.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75
           rcx
           r8
           r9))
         (not.70
          (tmp.6
           t.5
           rax
           tmp.119
           x.4
           *.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           vector-ref.57
           tmp.144
           tmp.329
           tmp.295
           car.58
           tmp.143
           tmp.328
           tmp.294
           cdr.59
           tmp.142
           tmp.327
           tmp.293
           procedure-arity.60
           tmp.141
           tmp.326
           tmp.292
           fixnum?.61
           tmp.140
           tmp.325
           tmp.291
           boolean?.62
           tmp.139
           tmp.324
           tmp.290
           empty?.63
           tmp.138
           tmp.323
           tmp.289
           void?.64
           tmp.137
           tmp.322
           tmp.288
           ascii-char?.65
           tmp.136
           tmp.321
           tmp.287
           error?.66
           tmp.135
           tmp.320
           tmp.286
           pair?.67
           tmp.134
           tmp.319
           tmp.285
           procedure?.68
           tmp.133
           tmp.318
           tmp.284
           vector?.69
           tmp.132
           tmp.317
           tmp.283
           r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75
           r8
           r9))
         (vector-ref.57
          (tmp.6
           t.5
           rax
           tmp.119
           x.4
           *.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75
           r9))
         (r8
          (tmp.6 r15 rdi rsi rdx rcx not.70 vector-set!.56 x.4 ra.309 r9 rbp))
         (rcx (tmp.6 r15 rdi rsi rdx vector-set!.56 x.4 ra.309 r8 r9 rbp))
         (rdx (tmp.6 r15 rdi rsi x.4 ra.309 rcx r8 r9 rbp))
         (rsi (make-vector.54 tmp.6 r15 rdi ra.309 rdx rcx r8 r9 rbp))
         (rdi (r15 ra.309 rsi rdx rcx r8 r9 rbp))
         (r15 (rdi rsi rdx rcx r8 r9 rbp))
         (tmp.6
          (t.5
           vector-ref.57
           not.70
           vector-set!.56
           x.4
           ra.309
           rbp
           rsi
           rdx
           rcx
           r8
           r9))
         (r12
          (tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           vector-ref.57
           tmp.144
           tmp.329
           tmp.295
           car.58
           tmp.143
           tmp.328
           tmp.294
           cdr.59
           tmp.142
           tmp.327
           tmp.293
           procedure-arity.60
           tmp.141
           tmp.326
           tmp.292
           fixnum?.61
           tmp.140
           tmp.325
           tmp.291
           boolean?.62
           tmp.139
           tmp.324
           tmp.290
           empty?.63
           tmp.138
           tmp.323
           tmp.289
           void?.64
           tmp.137
           tmp.322
           tmp.288
           ascii-char?.65
           tmp.136
           tmp.321
           tmp.287
           error?.66
           tmp.135
           tmp.320
           tmp.286
           pair?.67
           tmp.134
           tmp.319
           tmp.285
           procedure?.68
           tmp.133
           tmp.318
           tmp.284
           vector?.69
           tmp.132
           tmp.317
           tmp.283
           not.70
           tmp.131
           tmp.316
           tmp.282
           cons.71
           tmp.130
           tmp.315
           tmp.281
           eq?.72
           tmp.129
           tmp.314
           tmp.280
           make-init-vector.1
           tmp.128
           tmp.313
           tmp.279
           vector-init-loop.75
           tmp.127
           tmp.312
           tmp.278
           unsafe-vector-set!.2
           tmp.126
           tmp.311
           tmp.277
           unsafe-vector-ref.3
           tmp.125
           tmp.310
           rbp
           tmp.276
           ra.309))
         (tmp.276 (r12 rbp ra.309))
         (tmp.310 (ra.309 rbp r12))
         (tmp.125 (r12 rbp ra.309))
         (unsafe-vector-ref.3
          (*.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           vector-ref.57
           tmp.144
           tmp.329
           tmp.295
           car.58
           tmp.143
           tmp.328
           tmp.294
           cdr.59
           tmp.142
           tmp.327
           tmp.293
           procedure-arity.60
           tmp.141
           tmp.326
           tmp.292
           fixnum?.61
           tmp.140
           tmp.325
           tmp.291
           boolean?.62
           tmp.139
           tmp.324
           tmp.290
           empty?.63
           tmp.138
           tmp.323
           tmp.289
           void?.64
           tmp.137
           tmp.322
           tmp.288
           ascii-char?.65
           tmp.136
           tmp.321
           tmp.287
           error?.66
           tmp.135
           tmp.320
           tmp.286
           pair?.67
           tmp.134
           tmp.319
           tmp.285
           procedure?.68
           tmp.133
           tmp.318
           tmp.284
           vector?.69
           tmp.132
           tmp.317
           tmp.283
           not.70
           tmp.131
           tmp.316
           tmp.282
           cons.71
           tmp.130
           tmp.315
           tmp.281
           eq?.72
           tmp.129
           tmp.314
           tmp.280
           make-init-vector.1
           tmp.128
           tmp.313
           tmp.279
           vector-init-loop.75
           tmp.127
           tmp.312
           tmp.278
           unsafe-vector-set!.2
           tmp.126
           tmp.311
           tmp.277
           r12
           rbp
           ra.309))
         (tmp.277 (r12 rbp ra.309 unsafe-vector-ref.3))
         (tmp.311 (unsafe-vector-ref.3 ra.309 rbp r12))
         (tmp.126 (r12 rbp ra.309 unsafe-vector-ref.3))
         (unsafe-vector-set!.2
          (*.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           vector-ref.57
           tmp.144
           tmp.329
           tmp.295
           car.58
           tmp.143
           tmp.328
           tmp.294
           cdr.59
           tmp.142
           tmp.327
           tmp.293
           procedure-arity.60
           tmp.141
           tmp.326
           tmp.292
           fixnum?.61
           tmp.140
           tmp.325
           tmp.291
           boolean?.62
           tmp.139
           tmp.324
           tmp.290
           empty?.63
           tmp.138
           tmp.323
           tmp.289
           void?.64
           tmp.137
           tmp.322
           tmp.288
           ascii-char?.65
           tmp.136
           tmp.321
           tmp.287
           error?.66
           tmp.135
           tmp.320
           tmp.286
           pair?.67
           tmp.134
           tmp.319
           tmp.285
           procedure?.68
           tmp.133
           tmp.318
           tmp.284
           vector?.69
           tmp.132
           tmp.317
           tmp.283
           not.70
           tmp.131
           tmp.316
           tmp.282
           cons.71
           tmp.130
           tmp.315
           tmp.281
           eq?.72
           tmp.129
           tmp.314
           tmp.280
           make-init-vector.1
           tmp.128
           tmp.313
           tmp.279
           vector-init-loop.75
           tmp.127
           tmp.312
           tmp.278
           r12
           rbp
           ra.309
           unsafe-vector-ref.3))
         (tmp.278 (r12 unsafe-vector-set!.2 rbp ra.309 unsafe-vector-ref.3))
         (tmp.312 (unsafe-vector-ref.3 ra.309 rbp unsafe-vector-set!.2 r12))
         (tmp.127 (r12 unsafe-vector-set!.2 rbp ra.309 unsafe-vector-ref.3))
         (vector-init-loop.75
          (*.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           vector-ref.57
           tmp.144
           tmp.329
           tmp.295
           car.58
           tmp.143
           tmp.328
           tmp.294
           cdr.59
           tmp.142
           tmp.327
           tmp.293
           procedure-arity.60
           tmp.141
           tmp.326
           tmp.292
           fixnum?.61
           tmp.140
           tmp.325
           tmp.291
           boolean?.62
           tmp.139
           tmp.324
           tmp.290
           empty?.63
           tmp.138
           tmp.323
           tmp.289
           void?.64
           tmp.137
           tmp.322
           tmp.288
           ascii-char?.65
           tmp.136
           tmp.321
           tmp.287
           error?.66
           tmp.135
           tmp.320
           tmp.286
           pair?.67
           tmp.134
           tmp.319
           tmp.285
           procedure?.68
           tmp.133
           tmp.318
           tmp.284
           vector?.69
           tmp.132
           tmp.317
           tmp.283
           not.70
           tmp.131
           tmp.316
           tmp.282
           cons.71
           tmp.130
           tmp.315
           tmp.281
           eq?.72
           tmp.129
           tmp.314
           tmp.280
           make-init-vector.1
           tmp.128
           tmp.313
           tmp.279
           r12
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3))
         (tmp.279
          (r12
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.313
          (vector-init-loop.75
           unsafe-vector-ref.3
           ra.309
           rbp
           unsafe-vector-set!.2
           r12))
         (tmp.128
          (r12
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (make-init-vector.1
          (*.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           make-vector.54
           tmp.147
           tmp.332
           tmp.298
           vector-length.55
           tmp.146
           tmp.331
           tmp.297
           vector-set!.56
           tmp.145
           tmp.330
           tmp.296
           vector-ref.57
           tmp.144
           tmp.329
           tmp.295
           car.58
           tmp.143
           tmp.328
           tmp.294
           cdr.59
           tmp.142
           tmp.327
           tmp.293
           procedure-arity.60
           tmp.141
           tmp.326
           tmp.292
           fixnum?.61
           tmp.140
           tmp.325
           tmp.291
           boolean?.62
           tmp.139
           tmp.324
           tmp.290
           empty?.63
           tmp.138
           tmp.323
           tmp.289
           void?.64
           tmp.137
           tmp.322
           tmp.288
           ascii-char?.65
           tmp.136
           tmp.321
           tmp.287
           error?.66
           tmp.135
           tmp.320
           tmp.286
           pair?.67
           tmp.134
           tmp.319
           tmp.285
           procedure?.68
           tmp.133
           tmp.318
           tmp.284
           vector?.69
           tmp.132
           tmp.317
           tmp.283
           not.70
           tmp.131
           tmp.316
           tmp.282
           cons.71
           tmp.130
           tmp.315
           tmp.281
           eq?.72
           tmp.129
           tmp.314
           tmp.280
           r12
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.280
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.314
          (vector-init-loop.75
           unsafe-vector-ref.3
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.129
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (eq?.72
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.281
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.315
          (vector-init-loop.75
           unsafe-vector-ref.3
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.130
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (cons.71
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.282
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.316
          (vector-init-loop.75
           unsafe-vector-ref.3
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.131
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.283
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.317
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.132
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (vector?.69
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.284
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.318
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.133
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (procedure?.68
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.285
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.319
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.134
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (pair?.67
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.286
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.320
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.135
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (error?.66
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.287
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.321
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.136
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (ascii-char?.65
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.288
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.322
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.137
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (void?.64
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.289
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.323
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.138
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (empty?.63
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.290
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.324
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.139
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (boolean?.62
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.291
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.325
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.140
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (fixnum?.61
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.292
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.326
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.141
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (procedure-arity.60
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.293
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.327
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.142
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (cdr.59
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.294
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.328
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.143
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (car.58
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.295
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.329
          (vector-init-loop.75
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.144
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-init-loop.75))
         (tmp.296
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.330
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.145
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.297
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.331
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1
           r12))
         (tmp.146
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (vector-length.55
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.298
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.332
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1
           r12))
         (tmp.147
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (make-vector.54
          (rsi
           x.4
           *.47
           tmp.154
           tmp.339
           tmp.305
           |+.48|
           tmp.153
           tmp.338
           tmp.304
           |-.49|
           tmp.152
           tmp.337
           tmp.303
           <.50
           tmp.151
           tmp.336
           tmp.302
           <=.51
           tmp.150
           tmp.335
           tmp.301
           >.52
           tmp.149
           tmp.334
           tmp.300
           >=.53
           tmp.148
           tmp.333
           tmp.299
           r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.299
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.333
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           make-vector.54
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1
           r12))
         (tmp.148
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (>=.53
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.300
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.334
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           make-vector.54
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1
           r12))
         (tmp.149
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (>.52
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.301
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.335
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           make-vector.54
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1
           r12))
         (tmp.150
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (<=.51
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.302
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.336
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           make-vector.54
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1
           r12))
         (tmp.151
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (<.50
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.303
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.337
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           make-vector.54
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1
           r12))
         (tmp.152
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (|-.49|
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.304
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.338
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           make-vector.54
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1
           r12))
         (tmp.153
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (|+.48|
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.305
          (r12
           make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.339
          (vector-init-loop.75
           vector-ref.57
           unsafe-vector-ref.3
           make-vector.54
           not.70
           ra.309
           rbp
           unsafe-vector-set!.2
           vector-set!.56
           make-init-vector.1))
         (tmp.154
          (make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (*.47
          (make-init-vector.1
           vector-set!.56
           unsafe-vector-set!.2
           rbp
           ra.309
           not.70
           make-vector.54
           unsafe-vector-ref.3
           vector-ref.57
           vector-init-loop.75))
         (tmp.119 (vector-ref.57 not.70 vector-set!.56 x.4 ra.309 rbp))
         (rax (rbp ra.309 x.4 vector-set!.56 not.70 vector-ref.57))
         (t.5 (tmp.6 vector-ref.57 not.70 vector-set!.56 x.4 ra.309 rbp))))
       (assignment
        ((ra.309 fv0)
         (x.4 fv1)
         (vector-set!.56 fv2)
         (not.70 fv3)
         (vector-ref.57 fv4))))
      (begin
        (set! ra.309 r15)
        (set! tmp.276 r12)
        (set! r12 (+ r12 16))
        (set! tmp.310 (+ tmp.276 2))
        (set! tmp.125 tmp.310)
        (mset! tmp.125 -2 L.unsafe-vector-ref.3.1)
        (mset! tmp.125 6 16)
        (set! unsafe-vector-ref.3 tmp.125)
        (set! tmp.277 r12)
        (set! r12 (+ r12 16))
        (set! tmp.311 (+ tmp.277 2))
        (set! tmp.126 tmp.311)
        (mset! tmp.126 -2 L.unsafe-vector-set!.2.2)
        (mset! tmp.126 6 24)
        (set! unsafe-vector-set!.2 tmp.126)
        (set! tmp.278 r12)
        (set! r12 (+ r12 80))
        (set! tmp.312 (+ tmp.278 2))
        (set! tmp.127 tmp.312)
        (mset! tmp.127 -2 L.vector-init-loop.75.3)
        (mset! tmp.127 6 24)
        (set! vector-init-loop.75 tmp.127)
        (set! tmp.279 r12)
        (set! r12 (+ r12 80))
        (set! tmp.313 (+ tmp.279 2))
        (set! tmp.128 tmp.313)
        (mset! tmp.128 -2 L.make-init-vector.1.4)
        (mset! tmp.128 6 8)
        (set! make-init-vector.1 tmp.128)
        (set! tmp.280 r12)
        (set! r12 (+ r12 16))
        (set! tmp.314 (+ tmp.280 2))
        (set! tmp.129 tmp.314)
        (mset! tmp.129 -2 L.eq?.72.5)
        (mset! tmp.129 6 16)
        (set! eq?.72 tmp.129)
        (set! tmp.281 r12)
        (set! r12 (+ r12 16))
        (set! tmp.315 (+ tmp.281 2))
        (set! tmp.130 tmp.315)
        (mset! tmp.130 -2 L.cons.71.6)
        (mset! tmp.130 6 16)
        (set! cons.71 tmp.130)
        (set! tmp.282 r12)
        (set! r12 (+ r12 16))
        (set! tmp.316 (+ tmp.282 2))
        (set! tmp.131 tmp.316)
        (mset! tmp.131 -2 L.not.70.7)
        (mset! tmp.131 6 8)
        (set! not.70 tmp.131)
        (set! tmp.283 r12)
        (set! r12 (+ r12 16))
        (set! tmp.317 (+ tmp.283 2))
        (set! tmp.132 tmp.317)
        (mset! tmp.132 -2 L.vector?.69.8)
        (mset! tmp.132 6 8)
        (set! vector?.69 tmp.132)
        (set! tmp.284 r12)
        (set! r12 (+ r12 16))
        (set! tmp.318 (+ tmp.284 2))
        (set! tmp.133 tmp.318)
        (mset! tmp.133 -2 L.procedure?.68.9)
        (mset! tmp.133 6 8)
        (set! procedure?.68 tmp.133)
        (set! tmp.285 r12)
        (set! r12 (+ r12 16))
        (set! tmp.319 (+ tmp.285 2))
        (set! tmp.134 tmp.319)
        (mset! tmp.134 -2 L.pair?.67.10)
        (mset! tmp.134 6 8)
        (set! pair?.67 tmp.134)
        (set! tmp.286 r12)
        (set! r12 (+ r12 16))
        (set! tmp.320 (+ tmp.286 2))
        (set! tmp.135 tmp.320)
        (mset! tmp.135 -2 L.error?.66.11)
        (mset! tmp.135 6 8)
        (set! error?.66 tmp.135)
        (set! tmp.287 r12)
        (set! r12 (+ r12 16))
        (set! tmp.321 (+ tmp.287 2))
        (set! tmp.136 tmp.321)
        (mset! tmp.136 -2 L.ascii-char?.65.12)
        (mset! tmp.136 6 8)
        (set! ascii-char?.65 tmp.136)
        (set! tmp.288 r12)
        (set! r12 (+ r12 16))
        (set! tmp.322 (+ tmp.288 2))
        (set! tmp.137 tmp.322)
        (mset! tmp.137 -2 L.void?.64.13)
        (mset! tmp.137 6 8)
        (set! void?.64 tmp.137)
        (set! tmp.289 r12)
        (set! r12 (+ r12 16))
        (set! tmp.323 (+ tmp.289 2))
        (set! tmp.138 tmp.323)
        (mset! tmp.138 -2 L.empty?.63.14)
        (mset! tmp.138 6 8)
        (set! empty?.63 tmp.138)
        (set! tmp.290 r12)
        (set! r12 (+ r12 16))
        (set! tmp.324 (+ tmp.290 2))
        (set! tmp.139 tmp.324)
        (mset! tmp.139 -2 L.boolean?.62.15)
        (mset! tmp.139 6 8)
        (set! boolean?.62 tmp.139)
        (set! tmp.291 r12)
        (set! r12 (+ r12 16))
        (set! tmp.325 (+ tmp.291 2))
        (set! tmp.140 tmp.325)
        (mset! tmp.140 -2 L.fixnum?.61.16)
        (mset! tmp.140 6 8)
        (set! fixnum?.61 tmp.140)
        (set! tmp.292 r12)
        (set! r12 (+ r12 16))
        (set! tmp.326 (+ tmp.292 2))
        (set! tmp.141 tmp.326)
        (mset! tmp.141 -2 L.procedure-arity.60.17)
        (mset! tmp.141 6 8)
        (set! procedure-arity.60 tmp.141)
        (set! tmp.293 r12)
        (set! r12 (+ r12 16))
        (set! tmp.327 (+ tmp.293 2))
        (set! tmp.142 tmp.327)
        (mset! tmp.142 -2 L.cdr.59.18)
        (mset! tmp.142 6 8)
        (set! cdr.59 tmp.142)
        (set! tmp.294 r12)
        (set! r12 (+ r12 16))
        (set! tmp.328 (+ tmp.294 2))
        (set! tmp.143 tmp.328)
        (mset! tmp.143 -2 L.car.58.19)
        (mset! tmp.143 6 8)
        (set! car.58 tmp.143)
        (set! tmp.295 r12)
        (set! r12 (+ r12 80))
        (set! tmp.329 (+ tmp.295 2))
        (set! tmp.144 tmp.329)
        (mset! tmp.144 -2 L.vector-ref.57.20)
        (mset! tmp.144 6 16)
        (set! vector-ref.57 tmp.144)
        (set! tmp.296 r12)
        (set! r12 (+ r12 80))
        (set! tmp.330 (+ tmp.296 2))
        (set! tmp.145 tmp.330)
        (mset! tmp.145 -2 L.vector-set!.56.21)
        (mset! tmp.145 6 24)
        (set! vector-set!.56 tmp.145)
        (set! tmp.297 r12)
        (set! r12 (+ r12 16))
        (set! tmp.331 (+ tmp.297 2))
        (set! tmp.146 tmp.331)
        (mset! tmp.146 -2 L.vector-length.55.22)
        (mset! tmp.146 6 8)
        (set! vector-length.55 tmp.146)
        (set! tmp.298 r12)
        (set! r12 (+ r12 80))
        (set! tmp.332 (+ tmp.298 2))
        (set! tmp.147 tmp.332)
        (mset! tmp.147 -2 L.make-vector.54.23)
        (mset! tmp.147 6 8)
        (set! make-vector.54 tmp.147)
        (set! tmp.299 r12)
        (set! r12 (+ r12 16))
        (set! tmp.333 (+ tmp.299 2))
        (set! tmp.148 tmp.333)
        (mset! tmp.148 -2 L.>=.53.24)
        (mset! tmp.148 6 16)
        (set! >=.53 tmp.148)
        (set! tmp.300 r12)
        (set! r12 (+ r12 16))
        (set! tmp.334 (+ tmp.300 2))
        (set! tmp.149 tmp.334)
        (mset! tmp.149 -2 L.>.52.25)
        (mset! tmp.149 6 16)
        (set! >.52 tmp.149)
        (set! tmp.301 r12)
        (set! r12 (+ r12 16))
        (set! tmp.335 (+ tmp.301 2))
        (set! tmp.150 tmp.335)
        (mset! tmp.150 -2 L.<=.51.26)
        (mset! tmp.150 6 16)
        (set! <=.51 tmp.150)
        (set! tmp.302 r12)
        (set! r12 (+ r12 16))
        (set! tmp.336 (+ tmp.302 2))
        (set! tmp.151 tmp.336)
        (mset! tmp.151 -2 L.<.50.27)
        (mset! tmp.151 6 16)
        (set! <.50 tmp.151)
        (set! tmp.303 r12)
        (set! r12 (+ r12 16))
        (set! tmp.337 (+ tmp.303 2))
        (set! tmp.152 tmp.337)
        (mset! tmp.152 -2 L.-.49.28)
        (mset! tmp.152 6 16)
        (set! |-.49| tmp.152)
        (set! tmp.304 r12)
        (set! r12 (+ r12 16))
        (set! tmp.338 (+ tmp.304 2))
        (set! tmp.153 tmp.338)
        (mset! tmp.153 -2 L.+.48.29)
        (mset! tmp.153 6 16)
        (set! |+.48| tmp.153)
        (set! tmp.305 r12)
        (set! r12 (+ r12 16))
        (set! tmp.339 (+ tmp.305 2))
        (set! tmp.154 tmp.339)
        (mset! tmp.154 -2 L.*.47.30)
        (mset! tmp.154 6 16)
        (set! *.47 tmp.154)
        (mset! vector-init-loop.75 14 vector-init-loop.75)
        (mset! make-init-vector.1 14 vector-init-loop.75)
        (mset! vector-ref.57 14 unsafe-vector-ref.3)
        (mset! vector-set!.56 14 unsafe-vector-set!.2)
        (mset! make-vector.54 14 make-init-vector.1)
        (set! x.4 14)
        (set! tmp.119 make-vector.54)
        (return-point L.rp.105
          (begin
            (set! rsi 8)
            (set! rdi make-vector.54)
            (set! r15 L.rp.105)
            (jump L.make-vector.54.23 rbp r15 rsi rdi)))
        (set! t.5 rax)
        (set! tmp.6 14)
        (if (neq? tmp.6 6)
          (begin
            (set! r9 t.5)
            (set! r8 vector-ref.57)
            (set! rcx not.70)
            (set! rdx vector-set!.56)
            (set! rsi x.4)
            (set! rdi tmp.6)
            (set! r15 ra.309)
            (jump L.jp.103 rbp r15 r9 r8 rcx rdx rsi rdi))
          (begin
            (set! r9 t.5)
            (set! r8 vector-ref.57)
            (set! rcx not.70)
            (set! rdx vector-set!.56)
            (set! rsi x.4)
            (set! rdi 6)
            (set! r15 ra.309)
            (jump L.jp.103 rbp r15 r9 r8 rcx rdx rsi rdi)))))
    (define L.*.47.30
      ((new-frames ())
       (locals (tmp.10 tmp.9 ra.340 tmp.161 c.113 tmp.341))
       (undead-out
        ((rdi rsi rdx ra.340 rbp)
         (rsi rdx ra.340 rbp)
         (rdx tmp.9 ra.340 rbp)
         (tmp.10 tmp.9 ra.340 rbp)
         (tmp.341 tmp.10 tmp.9 ra.340 rbp)
         (tmp.161 tmp.10 tmp.9 ra.340 rbp)
         ((tmp.10 tmp.9 ra.340 rbp)
          ((tmp.9 ra.340 rdx rbp)
           (ra.340 rsi rdx rbp)
           (ra.340 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.9 ra.340 rdx rbp)
           (ra.340 rsi rdx rbp)
           (ra.340 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.113 r15 rdi rsi tmp.9 ra.340 rbp))
         (rbp (tmp.161 tmp.341 tmp.10 tmp.9 c.113 ra.340 r15 rdi rsi rdx))
         (ra.340 (tmp.161 tmp.341 tmp.10 tmp.9 c.113 rbp rdi rsi rdx))
         (tmp.9 (tmp.161 tmp.341 tmp.10 ra.340 rbp rdx))
         (rsi (c.113 r15 rdi ra.340 rdx rbp))
         (rdi (r15 ra.340 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.113 (rsi rdx ra.340 rbp))
         (tmp.10 (tmp.161 tmp.341 tmp.9 ra.340 rbp))
         (tmp.341 (rbp ra.340 tmp.9 tmp.10))
         (tmp.161 (tmp.10 tmp.9 ra.340 rbp))))
       (assignment ()))
      (begin
        (set! ra.340 r15)
        (set! c.113 rdi)
        (set! tmp.9 rsi)
        (set! tmp.10 rdx)
        (set! tmp.341 (bitwise-and tmp.10 7))
        (set! tmp.161 tmp.341)
        (if (eq? tmp.161 0)
          (begin
            (set! rdx tmp.10)
            (set! rsi tmp.9)
            (set! rdi 14)
            (set! r15 ra.340)
            (jump L.jp.34 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.10)
            (set! rsi tmp.9)
            (set! rdi 6)
            (set! r15 ra.340)
            (jump L.jp.34 rbp r15 rdx rsi rdi)))))
    (define L.+.48.29
      ((new-frames ())
       (locals (tmp.12 tmp.11 ra.342 tmp.167 c.112 tmp.343))
       (undead-out
        ((rdi rsi rdx ra.342 rbp)
         (rsi rdx ra.342 rbp)
         (rdx tmp.11 ra.342 rbp)
         (tmp.12 tmp.11 ra.342 rbp)
         (tmp.343 tmp.12 tmp.11 ra.342 rbp)
         (tmp.167 tmp.12 tmp.11 ra.342 rbp)
         ((tmp.12 tmp.11 ra.342 rbp)
          ((tmp.11 ra.342 rdx rbp)
           (ra.342 rsi rdx rbp)
           (ra.342 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.11 ra.342 rdx rbp)
           (ra.342 rsi rdx rbp)
           (ra.342 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.112 r15 rdi rsi tmp.11 ra.342 rbp))
         (rbp (tmp.167 tmp.343 tmp.12 tmp.11 c.112 ra.342 r15 rdi rsi rdx))
         (ra.342 (tmp.167 tmp.343 tmp.12 tmp.11 c.112 rbp rdi rsi rdx))
         (tmp.11 (tmp.167 tmp.343 tmp.12 ra.342 rbp rdx))
         (rsi (c.112 r15 rdi ra.342 rdx rbp))
         (rdi (r15 ra.342 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.112 (rsi rdx ra.342 rbp))
         (tmp.12 (tmp.167 tmp.343 tmp.11 ra.342 rbp))
         (tmp.343 (rbp ra.342 tmp.11 tmp.12))
         (tmp.167 (tmp.12 tmp.11 ra.342 rbp))))
       (assignment ()))
      (begin
        (set! ra.342 r15)
        (set! c.112 rdi)
        (set! tmp.11 rsi)
        (set! tmp.12 rdx)
        (set! tmp.343 (bitwise-and tmp.12 7))
        (set! tmp.167 tmp.343)
        (if (eq? tmp.167 0)
          (begin
            (set! rdx tmp.12)
            (set! rsi tmp.11)
            (set! rdi 14)
            (set! r15 ra.342)
            (jump L.jp.38 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.12)
            (set! rsi tmp.11)
            (set! rdi 6)
            (set! r15 ra.342)
            (jump L.jp.38 rbp r15 rdx rsi rdi)))))
    (define L.-.49.28
      ((new-frames ())
       (locals (tmp.14 tmp.13 ra.344 tmp.173 c.111 tmp.345))
       (undead-out
        ((rdi rsi rdx ra.344 rbp)
         (rsi rdx ra.344 rbp)
         (rdx tmp.13 ra.344 rbp)
         (tmp.14 tmp.13 ra.344 rbp)
         (tmp.345 tmp.14 tmp.13 ra.344 rbp)
         (tmp.173 tmp.14 tmp.13 ra.344 rbp)
         ((tmp.14 tmp.13 ra.344 rbp)
          ((tmp.13 ra.344 rdx rbp)
           (ra.344 rsi rdx rbp)
           (ra.344 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.13 ra.344 rdx rbp)
           (ra.344 rsi rdx rbp)
           (ra.344 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.111 r15 rdi rsi tmp.13 ra.344 rbp))
         (rbp (tmp.173 tmp.345 tmp.14 tmp.13 c.111 ra.344 r15 rdi rsi rdx))
         (ra.344 (tmp.173 tmp.345 tmp.14 tmp.13 c.111 rbp rdi rsi rdx))
         (tmp.13 (tmp.173 tmp.345 tmp.14 ra.344 rbp rdx))
         (rsi (c.111 r15 rdi ra.344 rdx rbp))
         (rdi (r15 ra.344 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.111 (rsi rdx ra.344 rbp))
         (tmp.14 (tmp.173 tmp.345 tmp.13 ra.344 rbp))
         (tmp.345 (rbp ra.344 tmp.13 tmp.14))
         (tmp.173 (tmp.14 tmp.13 ra.344 rbp))))
       (assignment ()))
      (begin
        (set! ra.344 r15)
        (set! c.111 rdi)
        (set! tmp.13 rsi)
        (set! tmp.14 rdx)
        (set! tmp.345 (bitwise-and tmp.14 7))
        (set! tmp.173 tmp.345)
        (if (eq? tmp.173 0)
          (begin
            (set! rdx tmp.14)
            (set! rsi tmp.13)
            (set! rdi 14)
            (set! r15 ra.344)
            (jump L.jp.42 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.14)
            (set! rsi tmp.13)
            (set! rdi 6)
            (set! r15 ra.344)
            (jump L.jp.42 rbp r15 rdx rsi rdi)))))
    (define L.<.50.27
      ((new-frames ())
       (locals (tmp.16 tmp.15 ra.346 tmp.180 c.110 tmp.347))
       (undead-out
        ((rdi rsi rdx ra.346 rbp)
         (rsi rdx ra.346 rbp)
         (rdx tmp.15 ra.346 rbp)
         (tmp.16 tmp.15 ra.346 rbp)
         (tmp.347 tmp.16 tmp.15 ra.346 rbp)
         (tmp.180 tmp.16 tmp.15 ra.346 rbp)
         ((tmp.16 tmp.15 ra.346 rbp)
          ((tmp.15 ra.346 rdx rbp)
           (ra.346 rsi rdx rbp)
           (ra.346 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.15 ra.346 rdx rbp)
           (ra.346 rsi rdx rbp)
           (ra.346 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.110 r15 rdi rsi tmp.15 ra.346 rbp))
         (rbp (tmp.180 tmp.347 tmp.16 tmp.15 c.110 ra.346 r15 rdi rsi rdx))
         (ra.346 (tmp.180 tmp.347 tmp.16 tmp.15 c.110 rbp rdi rsi rdx))
         (tmp.15 (tmp.180 tmp.347 tmp.16 ra.346 rbp rdx))
         (rsi (c.110 r15 rdi ra.346 rdx rbp))
         (rdi (r15 ra.346 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.110 (rsi rdx ra.346 rbp))
         (tmp.16 (tmp.180 tmp.347 tmp.15 ra.346 rbp))
         (tmp.347 (rbp ra.346 tmp.15 tmp.16))
         (tmp.180 (tmp.16 tmp.15 ra.346 rbp))))
       (assignment ()))
      (begin
        (set! ra.346 r15)
        (set! c.110 rdi)
        (set! tmp.15 rsi)
        (set! tmp.16 rdx)
        (set! tmp.347 (bitwise-and tmp.16 7))
        (set! tmp.180 tmp.347)
        (if (eq? tmp.180 0)
          (begin
            (set! rdx tmp.16)
            (set! rsi tmp.15)
            (set! rdi 14)
            (set! r15 ra.346)
            (jump L.jp.47 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.16)
            (set! rsi tmp.15)
            (set! rdi 6)
            (set! r15 ra.346)
            (jump L.jp.47 rbp r15 rdx rsi rdi)))))
    (define L.<=.51.26
      ((new-frames ())
       (locals (tmp.18 tmp.17 ra.348 tmp.187 c.109 tmp.349))
       (undead-out
        ((rdi rsi rdx ra.348 rbp)
         (rsi rdx ra.348 rbp)
         (rdx tmp.17 ra.348 rbp)
         (tmp.18 tmp.17 ra.348 rbp)
         (tmp.349 tmp.18 tmp.17 ra.348 rbp)
         (tmp.187 tmp.18 tmp.17 ra.348 rbp)
         ((tmp.18 tmp.17 ra.348 rbp)
          ((tmp.17 ra.348 rdx rbp)
           (ra.348 rsi rdx rbp)
           (ra.348 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.17 ra.348 rdx rbp)
           (ra.348 rsi rdx rbp)
           (ra.348 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.109 r15 rdi rsi tmp.17 ra.348 rbp))
         (rbp (tmp.187 tmp.349 tmp.18 tmp.17 c.109 ra.348 r15 rdi rsi rdx))
         (ra.348 (tmp.187 tmp.349 tmp.18 tmp.17 c.109 rbp rdi rsi rdx))
         (tmp.17 (tmp.187 tmp.349 tmp.18 ra.348 rbp rdx))
         (rsi (c.109 r15 rdi ra.348 rdx rbp))
         (rdi (r15 ra.348 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.109 (rsi rdx ra.348 rbp))
         (tmp.18 (tmp.187 tmp.349 tmp.17 ra.348 rbp))
         (tmp.349 (rbp ra.348 tmp.17 tmp.18))
         (tmp.187 (tmp.18 tmp.17 ra.348 rbp))))
       (assignment ()))
      (begin
        (set! ra.348 r15)
        (set! c.109 rdi)
        (set! tmp.17 rsi)
        (set! tmp.18 rdx)
        (set! tmp.349 (bitwise-and tmp.18 7))
        (set! tmp.187 tmp.349)
        (if (eq? tmp.187 0)
          (begin
            (set! rdx tmp.18)
            (set! rsi tmp.17)
            (set! rdi 14)
            (set! r15 ra.348)
            (jump L.jp.52 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.18)
            (set! rsi tmp.17)
            (set! rdi 6)
            (set! r15 ra.348)
            (jump L.jp.52 rbp r15 rdx rsi rdi)))))
    (define L.>.52.25
      ((new-frames ())
       (locals (tmp.20 tmp.19 ra.350 tmp.194 c.108 tmp.351))
       (undead-out
        ((rdi rsi rdx ra.350 rbp)
         (rsi rdx ra.350 rbp)
         (rdx tmp.19 ra.350 rbp)
         (tmp.20 tmp.19 ra.350 rbp)
         (tmp.351 tmp.20 tmp.19 ra.350 rbp)
         (tmp.194 tmp.20 tmp.19 ra.350 rbp)
         ((tmp.20 tmp.19 ra.350 rbp)
          ((tmp.19 ra.350 rdx rbp)
           (ra.350 rsi rdx rbp)
           (ra.350 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.19 ra.350 rdx rbp)
           (ra.350 rsi rdx rbp)
           (ra.350 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.108 r15 rdi rsi tmp.19 ra.350 rbp))
         (rbp (tmp.194 tmp.351 tmp.20 tmp.19 c.108 ra.350 r15 rdi rsi rdx))
         (ra.350 (tmp.194 tmp.351 tmp.20 tmp.19 c.108 rbp rdi rsi rdx))
         (tmp.19 (tmp.194 tmp.351 tmp.20 ra.350 rbp rdx))
         (rsi (c.108 r15 rdi ra.350 rdx rbp))
         (rdi (r15 ra.350 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.108 (rsi rdx ra.350 rbp))
         (tmp.20 (tmp.194 tmp.351 tmp.19 ra.350 rbp))
         (tmp.351 (rbp ra.350 tmp.19 tmp.20))
         (tmp.194 (tmp.20 tmp.19 ra.350 rbp))))
       (assignment ()))
      (begin
        (set! ra.350 r15)
        (set! c.108 rdi)
        (set! tmp.19 rsi)
        (set! tmp.20 rdx)
        (set! tmp.351 (bitwise-and tmp.20 7))
        (set! tmp.194 tmp.351)
        (if (eq? tmp.194 0)
          (begin
            (set! rdx tmp.20)
            (set! rsi tmp.19)
            (set! rdi 14)
            (set! r15 ra.350)
            (jump L.jp.57 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.20)
            (set! rsi tmp.19)
            (set! rdi 6)
            (set! r15 ra.350)
            (jump L.jp.57 rbp r15 rdx rsi rdi)))))
    (define L.>=.53.24
      ((new-frames ())
       (locals (tmp.22 tmp.21 ra.352 tmp.201 c.107 tmp.353))
       (undead-out
        ((rdi rsi rdx ra.352 rbp)
         (rsi rdx ra.352 rbp)
         (rdx tmp.21 ra.352 rbp)
         (tmp.22 tmp.21 ra.352 rbp)
         (tmp.353 tmp.22 tmp.21 ra.352 rbp)
         (tmp.201 tmp.22 tmp.21 ra.352 rbp)
         ((tmp.22 tmp.21 ra.352 rbp)
          ((tmp.21 ra.352 rdx rbp)
           (ra.352 rsi rdx rbp)
           (ra.352 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.21 ra.352 rdx rbp)
           (ra.352 rsi rdx rbp)
           (ra.352 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.107 r15 rdi rsi tmp.21 ra.352 rbp))
         (rbp (tmp.201 tmp.353 tmp.22 tmp.21 c.107 ra.352 r15 rdi rsi rdx))
         (ra.352 (tmp.201 tmp.353 tmp.22 tmp.21 c.107 rbp rdi rsi rdx))
         (tmp.21 (tmp.201 tmp.353 tmp.22 ra.352 rbp rdx))
         (rsi (c.107 r15 rdi ra.352 rdx rbp))
         (rdi (r15 ra.352 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.107 (rsi rdx ra.352 rbp))
         (tmp.22 (tmp.201 tmp.353 tmp.21 ra.352 rbp))
         (tmp.353 (rbp ra.352 tmp.21 tmp.22))
         (tmp.201 (tmp.22 tmp.21 ra.352 rbp))))
       (assignment ()))
      (begin
        (set! ra.352 r15)
        (set! c.107 rdi)
        (set! tmp.21 rsi)
        (set! tmp.22 rdx)
        (set! tmp.353 (bitwise-and tmp.22 7))
        (set! tmp.201 tmp.353)
        (if (eq? tmp.201 0)
          (begin
            (set! rdx tmp.22)
            (set! rsi tmp.21)
            (set! rdi 14)
            (set! r15 ra.352)
            (jump L.jp.62 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.22)
            (set! rsi tmp.21)
            (set! rdi 6)
            (set! r15 ra.352)
            (jump L.jp.62 rbp r15 rdx rsi rdi)))))
    (define L.make-vector.54.23
      ((new-frames ())
       (locals (tmp.23 make-init-vector.1 ra.354 tmp.204 c.106 tmp.355))
       (undead-out
        ((rdi rsi ra.354 rbp)
         (rsi c.106 ra.354 rbp)
         (c.106 tmp.23 ra.354 rbp)
         (tmp.23 make-init-vector.1 ra.354 rbp)
         (tmp.355 tmp.23 make-init-vector.1 ra.354 rbp)
         (tmp.204 tmp.23 make-init-vector.1 ra.354 rbp)
         ((tmp.23 make-init-vector.1 ra.354 rbp)
          ((make-init-vector.1 ra.354 rdx rbp)
           (ra.354 rsi rdx rbp)
           (ra.354 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((make-init-vector.1 ra.354 rdx rbp)
           (ra.354 rsi rdx rbp)
           (ra.354 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (r15 rdi rsi make-init-vector.1 ra.354 rbp))
         (rbp
          (tmp.204
           tmp.355
           make-init-vector.1
           tmp.23
           c.106
           ra.354
           r15
           rdi
           rsi
           rdx))
         (ra.354
          (tmp.204 tmp.355 make-init-vector.1 tmp.23 c.106 rbp rdi rsi rdx))
         (make-init-vector.1 (tmp.204 tmp.355 rbp ra.354 tmp.23 rdx))
         (rsi (c.106 r15 rdi ra.354 rdx rbp))
         (rdi (r15 ra.354 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.106 (tmp.23 rsi ra.354 rbp))
         (tmp.23 (tmp.204 tmp.355 make-init-vector.1 c.106 ra.354 rbp))
         (tmp.355 (rbp ra.354 make-init-vector.1 tmp.23))
         (tmp.204 (tmp.23 make-init-vector.1 ra.354 rbp))))
       (assignment ()))
      (begin
        (set! ra.354 r15)
        (set! c.106 rdi)
        (set! tmp.23 rsi)
        (set! make-init-vector.1 (mref c.106 14))
        (set! tmp.355 (bitwise-and tmp.23 7))
        (set! tmp.204 tmp.355)
        (if (eq? tmp.204 0)
          (begin
            (set! rdx tmp.23)
            (set! rsi make-init-vector.1)
            (set! rdi 14)
            (set! r15 ra.354)
            (jump L.jp.64 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.23)
            (set! rsi make-init-vector.1)
            (set! rdi 6)
            (set! r15 ra.354)
            (jump L.jp.64 rbp r15 rdx rsi rdi)))))
    (define L.vector-length.55.22
      ((new-frames ())
       (locals (tmp.24 ra.356 tmp.207 c.105 tmp.357))
       (undead-out
        ((rdi rsi ra.356 rbp)
         (rsi ra.356 rbp)
         (tmp.24 ra.356 rbp)
         (tmp.357 tmp.24 ra.356 rbp)
         (tmp.207 tmp.24 ra.356 rbp)
         ((tmp.24 ra.356 rbp)
          ((ra.356 rsi rbp)
           (ra.356 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp))
          ((ra.356 rsi rbp)
           (ra.356 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rsi (c.105 r15 rdi ra.356 rbp))
         (rbp (tmp.207 tmp.357 tmp.24 c.105 ra.356 r15 rdi rsi))
         (ra.356 (tmp.207 tmp.357 tmp.24 c.105 rbp rdi rsi))
         (rdi (r15 ra.356 rsi rbp))
         (r15 (rdi rsi rbp))
         (c.105 (rsi ra.356 rbp))
         (tmp.24 (tmp.207 tmp.357 ra.356 rbp))
         (tmp.357 (rbp ra.356 tmp.24))
         (tmp.207 (tmp.24 ra.356 rbp))))
       (assignment ()))
      (begin
        (set! ra.356 r15)
        (set! c.105 rdi)
        (set! tmp.24 rsi)
        (set! tmp.357 (bitwise-and tmp.24 7))
        (set! tmp.207 tmp.357)
        (if (eq? tmp.207 3)
          (begin
            (set! rsi tmp.24)
            (set! rdi 14)
            (set! r15 ra.356)
            (jump L.jp.66 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.24)
            (set! rdi 6)
            (set! r15 ra.356)
            (jump L.jp.66 rbp r15 rsi rdi)))))
    (define L.vector-set!.56.21
      ((new-frames ())
       (locals
        (tmp.26
         tmp.27
         unsafe-vector-set!.2
         tmp.25
         ra.358
         tmp.213
         c.104
         tmp.359))
       (undead-out
        ((rdi rsi rdx rcx ra.358 rbp)
         (rsi rdx rcx c.104 ra.358 rbp)
         (rdx rcx c.104 tmp.25 ra.358 rbp)
         (rcx c.104 tmp.26 tmp.25 ra.358 rbp)
         (c.104 tmp.26 tmp.27 tmp.25 ra.358 rbp)
         (tmp.26 tmp.27 unsafe-vector-set!.2 tmp.25 ra.358 rbp)
         (tmp.359 tmp.26 tmp.27 unsafe-vector-set!.2 tmp.25 ra.358 rbp)
         (tmp.213 tmp.26 tmp.27 unsafe-vector-set!.2 tmp.25 ra.358 rbp)
         ((tmp.26 tmp.27 unsafe-vector-set!.2 tmp.25 ra.358 rbp)
          ((tmp.27 unsafe-vector-set!.2 tmp.25 ra.358 r8 rbp)
           (unsafe-vector-set!.2 tmp.25 ra.358 rcx r8 rbp)
           (tmp.25 ra.358 rdx rcx r8 rbp)
           (ra.358 rsi rdx rcx r8 rbp)
           (ra.358 rdi rsi rdx rcx r8 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)
           (rdi rsi rdx rcx r8 r15 rbp))
          ((tmp.27 unsafe-vector-set!.2 tmp.25 ra.358 r8 rbp)
           (unsafe-vector-set!.2 tmp.25 ra.358 rcx r8 rbp)
           (tmp.25 ra.358 rdx rcx r8 rbp)
           (ra.358 rsi rdx rcx r8 rbp)
           (ra.358 rdi rsi rdx rcx r8 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)))))
       (call-undead ())
       (conflicts
        ((r8
          (r15 rdi rsi rdx rcx tmp.27 unsafe-vector-set!.2 tmp.25 ra.358 rbp))
         (rbp
          (tmp.213
           tmp.359
           unsafe-vector-set!.2
           tmp.27
           tmp.26
           tmp.25
           c.104
           ra.358
           r15
           rdi
           rsi
           rdx
           rcx
           r8))
         (ra.358
          (tmp.213
           tmp.359
           unsafe-vector-set!.2
           tmp.27
           tmp.26
           tmp.25
           c.104
           rbp
           rdi
           rsi
           rdx
           rcx
           r8))
         (tmp.25
          (tmp.213
           tmp.359
           unsafe-vector-set!.2
           tmp.27
           tmp.26
           c.104
           ra.358
           rbp
           rdx
           rcx
           r8))
         (unsafe-vector-set!.2
          (tmp.213 tmp.359 rbp ra.358 tmp.25 tmp.27 tmp.26 rcx r8))
         (tmp.27
          (tmp.213
           tmp.359
           unsafe-vector-set!.2
           c.104
           tmp.26
           tmp.25
           ra.358
           rbp
           r8))
         (rcx
          (tmp.26
           c.104
           r15
           rdi
           rsi
           rdx
           unsafe-vector-set!.2
           tmp.25
           ra.358
           r8
           rbp))
         (rdx (c.104 r15 rdi rsi tmp.25 ra.358 rcx r8 rbp))
         (rsi (c.104 r15 rdi ra.358 rdx rcx r8 rbp))
         (rdi (r15 ra.358 rsi rdx rcx r8 rbp))
         (r15 (rdi rsi rdx rcx r8 rbp))
         (c.104 (tmp.27 tmp.26 tmp.25 rsi rdx rcx ra.358 rbp))
         (tmp.26
          (tmp.213
           tmp.359
           unsafe-vector-set!.2
           tmp.27
           rcx
           c.104
           tmp.25
           ra.358
           rbp))
         (tmp.359 (rbp ra.358 tmp.25 unsafe-vector-set!.2 tmp.27 tmp.26))
         (tmp.213 (tmp.26 tmp.27 unsafe-vector-set!.2 tmp.25 ra.358 rbp))))
       (assignment ()))
      (begin
        (set! ra.358 r15)
        (set! c.104 rdi)
        (set! tmp.25 rsi)
        (set! tmp.26 rdx)
        (set! tmp.27 rcx)
        (set! unsafe-vector-set!.2 (mref c.104 14))
        (set! tmp.359 (bitwise-and tmp.26 7))
        (set! tmp.213 tmp.359)
        (if (eq? tmp.213 0)
          (begin
            (set! r8 tmp.26)
            (set! rcx tmp.27)
            (set! rdx unsafe-vector-set!.2)
            (set! rsi tmp.25)
            (set! rdi 14)
            (set! r15 ra.358)
            (jump L.jp.70 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 tmp.26)
            (set! rcx tmp.27)
            (set! rdx unsafe-vector-set!.2)
            (set! rsi tmp.25)
            (set! rdi 6)
            (set! r15 ra.358)
            (jump L.jp.70 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.vector-ref.57.20
      ((new-frames ())
       (locals
        (tmp.29 unsafe-vector-ref.3 tmp.28 ra.360 tmp.219 c.103 tmp.361))
       (undead-out
        ((rdi rsi rdx ra.360 rbp)
         (rsi rdx c.103 ra.360 rbp)
         (rdx c.103 tmp.28 ra.360 rbp)
         (c.103 tmp.29 tmp.28 ra.360 rbp)
         (tmp.29 unsafe-vector-ref.3 tmp.28 ra.360 rbp)
         (tmp.361 tmp.29 unsafe-vector-ref.3 tmp.28 ra.360 rbp)
         (tmp.219 tmp.29 unsafe-vector-ref.3 tmp.28 ra.360 rbp)
         ((tmp.29 unsafe-vector-ref.3 tmp.28 ra.360 rbp)
          ((unsafe-vector-ref.3 tmp.28 ra.360 rcx rbp)
           (tmp.28 ra.360 rdx rcx rbp)
           (ra.360 rsi rdx rcx rbp)
           (ra.360 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp))
          ((unsafe-vector-ref.3 tmp.28 ra.360 rcx rbp)
           (tmp.28 ra.360 rdx rcx rbp)
           (ra.360 rsi rdx rcx rbp)
           (ra.360 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rcx (r15 rdi rsi rdx unsafe-vector-ref.3 tmp.28 ra.360 rbp))
         (rbp
          (tmp.219
           tmp.361
           unsafe-vector-ref.3
           tmp.29
           tmp.28
           c.103
           ra.360
           r15
           rdi
           rsi
           rdx
           rcx))
         (ra.360
          (tmp.219
           tmp.361
           unsafe-vector-ref.3
           tmp.29
           tmp.28
           c.103
           rbp
           rdi
           rsi
           rdx
           rcx))
         (tmp.28
          (tmp.219
           tmp.361
           unsafe-vector-ref.3
           tmp.29
           c.103
           ra.360
           rbp
           rdx
           rcx))
         (unsafe-vector-ref.3 (tmp.219 tmp.361 rbp ra.360 tmp.28 tmp.29 rcx))
         (rdx (c.103 r15 rdi rsi tmp.28 ra.360 rcx rbp))
         (rsi (c.103 r15 rdi ra.360 rdx rcx rbp))
         (rdi (r15 ra.360 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (c.103 (tmp.29 tmp.28 rsi rdx ra.360 rbp))
         (tmp.29 (tmp.219 tmp.361 unsafe-vector-ref.3 c.103 tmp.28 ra.360 rbp))
         (tmp.361 (rbp ra.360 tmp.28 unsafe-vector-ref.3 tmp.29))
         (tmp.219 (tmp.29 unsafe-vector-ref.3 tmp.28 ra.360 rbp))))
       (assignment ()))
      (begin
        (set! ra.360 r15)
        (set! c.103 rdi)
        (set! tmp.28 rsi)
        (set! tmp.29 rdx)
        (set! unsafe-vector-ref.3 (mref c.103 14))
        (set! tmp.361 (bitwise-and tmp.29 7))
        (set! tmp.219 tmp.361)
        (if (eq? tmp.219 0)
          (begin
            (set! rcx tmp.29)
            (set! rdx unsafe-vector-ref.3)
            (set! rsi tmp.28)
            (set! rdi 14)
            (set! r15 ra.360)
            (jump L.jp.74 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx tmp.29)
            (set! rdx unsafe-vector-ref.3)
            (set! rsi tmp.28)
            (set! rdi 6)
            (set! r15 ra.360)
            (jump L.jp.74 rbp r15 rcx rdx rsi rdi)))))
    (define L.car.58.19
      ((new-frames ())
       (locals (tmp.30 ra.362 tmp.222 c.102 tmp.363))
       (undead-out
        ((rdi rsi ra.362 rbp)
         (rsi ra.362 rbp)
         (tmp.30 ra.362 rbp)
         (tmp.363 tmp.30 ra.362 rbp)
         (tmp.222 tmp.30 ra.362 rbp)
         ((tmp.30 ra.362 rbp)
          ((ra.362 rsi rbp)
           (ra.362 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp))
          ((ra.362 rsi rbp)
           (ra.362 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rsi (c.102 r15 rdi ra.362 rbp))
         (rbp (tmp.222 tmp.363 tmp.30 c.102 ra.362 r15 rdi rsi))
         (ra.362 (tmp.222 tmp.363 tmp.30 c.102 rbp rdi rsi))
         (rdi (r15 ra.362 rsi rbp))
         (r15 (rdi rsi rbp))
         (c.102 (rsi ra.362 rbp))
         (tmp.30 (tmp.222 tmp.363 ra.362 rbp))
         (tmp.363 (rbp ra.362 tmp.30))
         (tmp.222 (tmp.30 ra.362 rbp))))
       (assignment ()))
      (begin
        (set! ra.362 r15)
        (set! c.102 rdi)
        (set! tmp.30 rsi)
        (set! tmp.363 (bitwise-and tmp.30 7))
        (set! tmp.222 tmp.363)
        (if (eq? tmp.222 1)
          (begin
            (set! rsi tmp.30)
            (set! rdi 14)
            (set! r15 ra.362)
            (jump L.jp.76 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.30)
            (set! rdi 6)
            (set! r15 ra.362)
            (jump L.jp.76 rbp r15 rsi rdi)))))
    (define L.cdr.59.18
      ((new-frames ())
       (locals (tmp.31 ra.364 tmp.225 c.101 tmp.365))
       (undead-out
        ((rdi rsi ra.364 rbp)
         (rsi ra.364 rbp)
         (tmp.31 ra.364 rbp)
         (tmp.365 tmp.31 ra.364 rbp)
         (tmp.225 tmp.31 ra.364 rbp)
         ((tmp.31 ra.364 rbp)
          ((ra.364 rsi rbp)
           (ra.364 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp))
          ((ra.364 rsi rbp)
           (ra.364 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rsi (c.101 r15 rdi ra.364 rbp))
         (rbp (tmp.225 tmp.365 tmp.31 c.101 ra.364 r15 rdi rsi))
         (ra.364 (tmp.225 tmp.365 tmp.31 c.101 rbp rdi rsi))
         (rdi (r15 ra.364 rsi rbp))
         (r15 (rdi rsi rbp))
         (c.101 (rsi ra.364 rbp))
         (tmp.31 (tmp.225 tmp.365 ra.364 rbp))
         (tmp.365 (rbp ra.364 tmp.31))
         (tmp.225 (tmp.31 ra.364 rbp))))
       (assignment ()))
      (begin
        (set! ra.364 r15)
        (set! c.101 rdi)
        (set! tmp.31 rsi)
        (set! tmp.365 (bitwise-and tmp.31 7))
        (set! tmp.225 tmp.365)
        (if (eq? tmp.225 1)
          (begin
            (set! rsi tmp.31)
            (set! rdi 14)
            (set! r15 ra.364)
            (jump L.jp.78 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.31)
            (set! rdi 6)
            (set! r15 ra.364)
            (jump L.jp.78 rbp r15 rsi rdi)))))
    (define L.procedure-arity.60.17
      ((new-frames ())
       (locals (tmp.32 ra.366 tmp.228 c.100 tmp.367))
       (undead-out
        ((rdi rsi ra.366 rbp)
         (rsi ra.366 rbp)
         (tmp.32 ra.366 rbp)
         (tmp.367 tmp.32 ra.366 rbp)
         (tmp.228 tmp.32 ra.366 rbp)
         ((tmp.32 ra.366 rbp)
          ((ra.366 rsi rbp)
           (ra.366 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp))
          ((ra.366 rsi rbp)
           (ra.366 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rsi (c.100 r15 rdi ra.366 rbp))
         (rbp (tmp.228 tmp.367 tmp.32 c.100 ra.366 r15 rdi rsi))
         (ra.366 (tmp.228 tmp.367 tmp.32 c.100 rbp rdi rsi))
         (rdi (r15 ra.366 rsi rbp))
         (r15 (rdi rsi rbp))
         (c.100 (rsi ra.366 rbp))
         (tmp.32 (tmp.228 tmp.367 ra.366 rbp))
         (tmp.367 (rbp ra.366 tmp.32))
         (tmp.228 (tmp.32 ra.366 rbp))))
       (assignment ()))
      (begin
        (set! ra.366 r15)
        (set! c.100 rdi)
        (set! tmp.32 rsi)
        (set! tmp.367 (bitwise-and tmp.32 7))
        (set! tmp.228 tmp.367)
        (if (eq? tmp.228 2)
          (begin
            (set! rsi tmp.32)
            (set! rdi 14)
            (set! r15 ra.366)
            (jump L.jp.80 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.32)
            (set! rdi 6)
            (set! r15 ra.366)
            (jump L.jp.80 rbp r15 rsi rdi)))))
    (define L.fixnum?.61.16
      ((new-frames ())
       (locals (tmp.230 ra.368 c.99 tmp.33 tmp.369))
       (undead-out
        ((rdi rsi ra.368 rbp)
         (rsi ra.368 rbp)
         (tmp.33 ra.368 rbp)
         (tmp.369 ra.368 rbp)
         (tmp.230 ra.368 rbp)
         ((ra.368 rbp)
          ((ra.368 rax rbp) (rax rbp))
          ((ra.368 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.368 rbp))
         (rbp (tmp.230 tmp.369 tmp.33 c.99 ra.368 rax))
         (ra.368 (tmp.230 tmp.369 tmp.33 c.99 rdi rsi rbp rax))
         (rsi (c.99 ra.368))
         (rdi (ra.368))
         (c.99 (rsi ra.368 rbp))
         (tmp.33 (ra.368 rbp))
         (tmp.369 (rbp ra.368))
         (tmp.230 (ra.368 rbp))))
       (assignment ()))
      (begin
        (set! ra.368 r15)
        (set! c.99 rdi)
        (set! tmp.33 rsi)
        (set! tmp.369 (bitwise-and tmp.33 7))
        (set! tmp.230 tmp.369)
        (if (eq? tmp.230 0)
          (begin (set! rax 14) (jump ra.368 rbp rax))
          (begin (set! rax 6) (jump ra.368 rbp rax)))))
    (define L.boolean?.62.15
      ((new-frames ())
       (locals (tmp.232 ra.370 c.98 tmp.34 tmp.371))
       (undead-out
        ((rdi rsi ra.370 rbp)
         (rsi ra.370 rbp)
         (tmp.34 ra.370 rbp)
         (tmp.371 ra.370 rbp)
         (tmp.232 ra.370 rbp)
         ((ra.370 rbp)
          ((ra.370 rax rbp) (rax rbp))
          ((ra.370 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.370 rbp))
         (rbp (tmp.232 tmp.371 tmp.34 c.98 ra.370 rax))
         (ra.370 (tmp.232 tmp.371 tmp.34 c.98 rdi rsi rbp rax))
         (rsi (c.98 ra.370))
         (rdi (ra.370))
         (c.98 (rsi ra.370 rbp))
         (tmp.34 (ra.370 rbp))
         (tmp.371 (rbp ra.370))
         (tmp.232 (ra.370 rbp))))
       (assignment ()))
      (begin
        (set! ra.370 r15)
        (set! c.98 rdi)
        (set! tmp.34 rsi)
        (set! tmp.371 (bitwise-and tmp.34 247))
        (set! tmp.232 tmp.371)
        (if (eq? tmp.232 6)
          (begin (set! rax 14) (jump ra.370 rbp rax))
          (begin (set! rax 6) (jump ra.370 rbp rax)))))
    (define L.empty?.63.14
      ((new-frames ())
       (locals (tmp.234 ra.372 c.97 tmp.35 tmp.373))
       (undead-out
        ((rdi rsi ra.372 rbp)
         (rsi ra.372 rbp)
         (tmp.35 ra.372 rbp)
         (tmp.373 ra.372 rbp)
         (tmp.234 ra.372 rbp)
         ((ra.372 rbp)
          ((ra.372 rax rbp) (rax rbp))
          ((ra.372 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.372 rbp))
         (rbp (tmp.234 tmp.373 tmp.35 c.97 ra.372 rax))
         (ra.372 (tmp.234 tmp.373 tmp.35 c.97 rdi rsi rbp rax))
         (rsi (c.97 ra.372))
         (rdi (ra.372))
         (c.97 (rsi ra.372 rbp))
         (tmp.35 (ra.372 rbp))
         (tmp.373 (rbp ra.372))
         (tmp.234 (ra.372 rbp))))
       (assignment ()))
      (begin
        (set! ra.372 r15)
        (set! c.97 rdi)
        (set! tmp.35 rsi)
        (set! tmp.373 (bitwise-and tmp.35 255))
        (set! tmp.234 tmp.373)
        (if (eq? tmp.234 22)
          (begin (set! rax 14) (jump ra.372 rbp rax))
          (begin (set! rax 6) (jump ra.372 rbp rax)))))
    (define L.void?.64.13
      ((new-frames ())
       (locals (tmp.236 ra.374 c.96 tmp.36 tmp.375))
       (undead-out
        ((rdi rsi ra.374 rbp)
         (rsi ra.374 rbp)
         (tmp.36 ra.374 rbp)
         (tmp.375 ra.374 rbp)
         (tmp.236 ra.374 rbp)
         ((ra.374 rbp)
          ((ra.374 rax rbp) (rax rbp))
          ((ra.374 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.374 rbp))
         (rbp (tmp.236 tmp.375 tmp.36 c.96 ra.374 rax))
         (ra.374 (tmp.236 tmp.375 tmp.36 c.96 rdi rsi rbp rax))
         (rsi (c.96 ra.374))
         (rdi (ra.374))
         (c.96 (rsi ra.374 rbp))
         (tmp.36 (ra.374 rbp))
         (tmp.375 (rbp ra.374))
         (tmp.236 (ra.374 rbp))))
       (assignment ()))
      (begin
        (set! ra.374 r15)
        (set! c.96 rdi)
        (set! tmp.36 rsi)
        (set! tmp.375 (bitwise-and tmp.36 255))
        (set! tmp.236 tmp.375)
        (if (eq? tmp.236 30)
          (begin (set! rax 14) (jump ra.374 rbp rax))
          (begin (set! rax 6) (jump ra.374 rbp rax)))))
    (define L.ascii-char?.65.12
      ((new-frames ())
       (locals (tmp.238 ra.376 c.95 tmp.37 tmp.377))
       (undead-out
        ((rdi rsi ra.376 rbp)
         (rsi ra.376 rbp)
         (tmp.37 ra.376 rbp)
         (tmp.377 ra.376 rbp)
         (tmp.238 ra.376 rbp)
         ((ra.376 rbp)
          ((ra.376 rax rbp) (rax rbp))
          ((ra.376 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.376 rbp))
         (rbp (tmp.238 tmp.377 tmp.37 c.95 ra.376 rax))
         (ra.376 (tmp.238 tmp.377 tmp.37 c.95 rdi rsi rbp rax))
         (rsi (c.95 ra.376))
         (rdi (ra.376))
         (c.95 (rsi ra.376 rbp))
         (tmp.37 (ra.376 rbp))
         (tmp.377 (rbp ra.376))
         (tmp.238 (ra.376 rbp))))
       (assignment ()))
      (begin
        (set! ra.376 r15)
        (set! c.95 rdi)
        (set! tmp.37 rsi)
        (set! tmp.377 (bitwise-and tmp.37 255))
        (set! tmp.238 tmp.377)
        (if (eq? tmp.238 46)
          (begin (set! rax 14) (jump ra.376 rbp rax))
          (begin (set! rax 6) (jump ra.376 rbp rax)))))
    (define L.error?.66.11
      ((new-frames ())
       (locals (tmp.240 ra.378 c.94 tmp.38 tmp.379))
       (undead-out
        ((rdi rsi ra.378 rbp)
         (rsi ra.378 rbp)
         (tmp.38 ra.378 rbp)
         (tmp.379 ra.378 rbp)
         (tmp.240 ra.378 rbp)
         ((ra.378 rbp)
          ((ra.378 rax rbp) (rax rbp))
          ((ra.378 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.378 rbp))
         (rbp (tmp.240 tmp.379 tmp.38 c.94 ra.378 rax))
         (ra.378 (tmp.240 tmp.379 tmp.38 c.94 rdi rsi rbp rax))
         (rsi (c.94 ra.378))
         (rdi (ra.378))
         (c.94 (rsi ra.378 rbp))
         (tmp.38 (ra.378 rbp))
         (tmp.379 (rbp ra.378))
         (tmp.240 (ra.378 rbp))))
       (assignment ()))
      (begin
        (set! ra.378 r15)
        (set! c.94 rdi)
        (set! tmp.38 rsi)
        (set! tmp.379 (bitwise-and tmp.38 255))
        (set! tmp.240 tmp.379)
        (if (eq? tmp.240 62)
          (begin (set! rax 14) (jump ra.378 rbp rax))
          (begin (set! rax 6) (jump ra.378 rbp rax)))))
    (define L.pair?.67.10
      ((new-frames ())
       (locals (tmp.242 ra.380 c.93 tmp.39 tmp.381))
       (undead-out
        ((rdi rsi ra.380 rbp)
         (rsi ra.380 rbp)
         (tmp.39 ra.380 rbp)
         (tmp.381 ra.380 rbp)
         (tmp.242 ra.380 rbp)
         ((ra.380 rbp)
          ((ra.380 rax rbp) (rax rbp))
          ((ra.380 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.380 rbp))
         (rbp (tmp.242 tmp.381 tmp.39 c.93 ra.380 rax))
         (ra.380 (tmp.242 tmp.381 tmp.39 c.93 rdi rsi rbp rax))
         (rsi (c.93 ra.380))
         (rdi (ra.380))
         (c.93 (rsi ra.380 rbp))
         (tmp.39 (ra.380 rbp))
         (tmp.381 (rbp ra.380))
         (tmp.242 (ra.380 rbp))))
       (assignment ()))
      (begin
        (set! ra.380 r15)
        (set! c.93 rdi)
        (set! tmp.39 rsi)
        (set! tmp.381 (bitwise-and tmp.39 7))
        (set! tmp.242 tmp.381)
        (if (eq? tmp.242 1)
          (begin (set! rax 14) (jump ra.380 rbp rax))
          (begin (set! rax 6) (jump ra.380 rbp rax)))))
    (define L.procedure?.68.9
      ((new-frames ())
       (locals (tmp.244 ra.382 c.92 tmp.40 tmp.383))
       (undead-out
        ((rdi rsi ra.382 rbp)
         (rsi ra.382 rbp)
         (tmp.40 ra.382 rbp)
         (tmp.383 ra.382 rbp)
         (tmp.244 ra.382 rbp)
         ((ra.382 rbp)
          ((ra.382 rax rbp) (rax rbp))
          ((ra.382 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.382 rbp))
         (rbp (tmp.244 tmp.383 tmp.40 c.92 ra.382 rax))
         (ra.382 (tmp.244 tmp.383 tmp.40 c.92 rdi rsi rbp rax))
         (rsi (c.92 ra.382))
         (rdi (ra.382))
         (c.92 (rsi ra.382 rbp))
         (tmp.40 (ra.382 rbp))
         (tmp.383 (rbp ra.382))
         (tmp.244 (ra.382 rbp))))
       (assignment ()))
      (begin
        (set! ra.382 r15)
        (set! c.92 rdi)
        (set! tmp.40 rsi)
        (set! tmp.383 (bitwise-and tmp.40 7))
        (set! tmp.244 tmp.383)
        (if (eq? tmp.244 2)
          (begin (set! rax 14) (jump ra.382 rbp rax))
          (begin (set! rax 6) (jump ra.382 rbp rax)))))
    (define L.vector?.69.8
      ((new-frames ())
       (locals (tmp.246 ra.384 c.91 tmp.41 tmp.385))
       (undead-out
        ((rdi rsi ra.384 rbp)
         (rsi ra.384 rbp)
         (tmp.41 ra.384 rbp)
         (tmp.385 ra.384 rbp)
         (tmp.246 ra.384 rbp)
         ((ra.384 rbp)
          ((ra.384 rax rbp) (rax rbp))
          ((ra.384 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.384 rbp))
         (rbp (tmp.246 tmp.385 tmp.41 c.91 ra.384 rax))
         (ra.384 (tmp.246 tmp.385 tmp.41 c.91 rdi rsi rbp rax))
         (rsi (c.91 ra.384))
         (rdi (ra.384))
         (c.91 (rsi ra.384 rbp))
         (tmp.41 (ra.384 rbp))
         (tmp.385 (rbp ra.384))
         (tmp.246 (ra.384 rbp))))
       (assignment ()))
      (begin
        (set! ra.384 r15)
        (set! c.91 rdi)
        (set! tmp.41 rsi)
        (set! tmp.385 (bitwise-and tmp.41 7))
        (set! tmp.246 tmp.385)
        (if (eq? tmp.246 3)
          (begin (set! rax 14) (jump ra.384 rbp rax))
          (begin (set! rax 6) (jump ra.384 rbp rax)))))
    (define L.not.70.7
      ((new-frames ())
       (locals (tmp.42 ra.386 c.90))
       (undead-out
        ((rdi rsi ra.386 rbp)
         (rsi ra.386 rbp)
         (tmp.42 ra.386 rbp)
         ((ra.386 rbp)
          ((ra.386 rax rbp) (rax rbp))
          ((ra.386 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.386 rbp))
         (rbp (tmp.42 c.90 ra.386 rax))
         (ra.386 (tmp.42 c.90 rdi rsi rbp rax))
         (rsi (c.90 ra.386))
         (rdi (ra.386))
         (c.90 (rsi ra.386 rbp))
         (tmp.42 (ra.386 rbp))))
       (assignment ()))
      (begin
        (set! ra.386 r15)
        (set! c.90 rdi)
        (set! tmp.42 rsi)
        (if (neq? tmp.42 6)
          (begin (set! rax 6) (jump ra.386 rbp rax))
          (begin (set! rax 14) (jump ra.386 rbp rax)))))
    (define L.cons.71.6
      ((new-frames ())
       (locals (ra.387 c.89 tmp.43 tmp.44 tmp.248 tmp.388 tmp.123))
       (undead-out
        ((rdi rsi rdx r12 ra.387 rbp)
         (rsi rdx r12 ra.387 rbp)
         (rdx r12 ra.387 rbp tmp.43)
         (r12 tmp.44 ra.387 rbp tmp.43)
         (r12 tmp.248 tmp.44 ra.387 rbp tmp.43)
         (tmp.248 tmp.44 ra.387 rbp tmp.43)
         (tmp.388 tmp.44 ra.387 rbp tmp.43)
         (tmp.44 ra.387 rbp tmp.43 tmp.123)
         (rbp ra.387 tmp.44 tmp.123)
         (tmp.123 ra.387 rbp)
         (ra.387 rax rbp)
         (rax rbp)))
       (call-undead ())
       (conflicts
        ((ra.387
          (rax tmp.123 tmp.388 tmp.248 tmp.44 tmp.43 c.89 rdi rsi rdx r12 rbp))
         (rbp (rax tmp.123 tmp.388 r12 tmp.248 tmp.44 tmp.43 c.89 ra.387))
         (r12 (rbp tmp.248 tmp.44 tmp.43 c.89 ra.387))
         (rdx (tmp.43 c.89 ra.387))
         (rsi (c.89 ra.387))
         (rdi (ra.387))
         (c.89 (rsi rdx r12 ra.387 rbp))
         (tmp.43 (tmp.123 tmp.388 tmp.248 tmp.44 rdx r12 ra.387 rbp))
         (tmp.44 (tmp.123 tmp.388 tmp.248 r12 ra.387 rbp tmp.43))
         (tmp.248 (r12 tmp.44 ra.387 rbp tmp.43))
         (tmp.388 (tmp.43 rbp ra.387 tmp.44))
         (tmp.123 (tmp.44 ra.387 rbp tmp.43))
         (rax (ra.387 rbp))))
       (assignment ()))
      (begin
        (set! ra.387 r15)
        (set! c.89 rdi)
        (set! tmp.43 rsi)
        (set! tmp.44 rdx)
        (set! tmp.248 r12)
        (set! r12 (+ r12 16))
        (set! tmp.388 (+ tmp.248 1))
        (set! tmp.123 tmp.388)
        (mset! tmp.123 -1 tmp.43)
        (mset! tmp.123 7 tmp.44)
        (set! rax tmp.123)
        (jump ra.387 rbp rax)))
    (define L.eq?.72.5
      ((new-frames ())
       (locals (tmp.45 tmp.46 ra.389 c.88))
       (undead-out
        ((rdi rsi rdx ra.389 rbp)
         (rsi rdx ra.389 rbp)
         (rdx tmp.45 ra.389 rbp)
         (tmp.45 tmp.46 ra.389 rbp)
         ((ra.389 rbp)
          ((ra.389 rax rbp) (rax rbp))
          ((ra.389 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.389 rbp))
         (rbp (tmp.46 tmp.45 c.88 ra.389 rax))
         (ra.389 (tmp.46 tmp.45 c.88 rdi rsi rdx rbp rax))
         (rdx (tmp.45 c.88 ra.389))
         (rsi (c.88 ra.389))
         (rdi (ra.389))
         (c.88 (rsi rdx ra.389 rbp))
         (tmp.45 (tmp.46 rdx ra.389 rbp))
         (tmp.46 (tmp.45 ra.389 rbp))))
       (assignment ()))
      (begin
        (set! ra.389 r15)
        (set! c.88 rdi)
        (set! tmp.45 rsi)
        (set! tmp.46 rdx)
        (if (eq? tmp.45 tmp.46)
          (begin (set! rax 14) (jump ra.389 rbp rax))
          (begin (set! rax 6) (jump ra.389 rbp rax)))))
    (define L.make-init-vector.1.4
      ((new-frames ())
       (locals
        (ra.390
         c.87
         tmp.73
         vector-init-loop.75
         tmp.391
         tmp.250
         tmp.392
         tmp.393
         tmp.251
         tmp.394
         tmp.252
         tmp.483
         tmp.253
         tmp.395
         tmp.124
         tmp.74
         tmp.115))
       (undead-out
        ((rdi rsi r12 rbp ra.390)
         (rsi c.87 r12 rbp ra.390)
         (c.87 r12 rbp ra.390 tmp.73)
         (r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.391 r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.250 r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.250 tmp.392 r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.393 r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.251 r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.394 r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.252 r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.483 r12 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.483 r12 tmp.253 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.253 rbp ra.390 vector-init-loop.75 tmp.73)
         (tmp.395 rbp ra.390 vector-init-loop.75 tmp.73)
         (rbp ra.390 vector-init-loop.75 tmp.73 tmp.124)
         (tmp.124 tmp.73 vector-init-loop.75 ra.390 rbp)
         (tmp.74 tmp.73 vector-init-loop.75 ra.390 rbp)
         (tmp.74 tmp.73 vector-init-loop.75 ra.390 rbp)
         (tmp.73 vector-init-loop.75 ra.390 rcx rbp)
         (tmp.73 vector-init-loop.75 ra.390 rdx rcx rbp)
         (vector-init-loop.75 ra.390 rsi rdx rcx rbp)
         (ra.390 rdi rsi rdx rcx rbp)
         (rdi rsi rdx rcx r15 rbp)
         (rdi rsi rdx rcx r15 rbp)))
       (call-undead ())
       (conflicts
        ((ra.390
          (rdx
           rcx
           tmp.115
           tmp.74
           tmp.124
           tmp.395
           tmp.253
           tmp.483
           tmp.252
           tmp.394
           tmp.251
           tmp.393
           tmp.392
           tmp.250
           tmp.391
           vector-init-loop.75
           tmp.73
           c.87
           rdi
           rsi
           r12
           rbp))
         (rbp
          (r15
           rdi
           rsi
           rdx
           rcx
           tmp.115
           tmp.74
           tmp.124
           tmp.395
           r12
           tmp.253
           tmp.483
           tmp.252
           tmp.394
           tmp.251
           tmp.393
           tmp.392
           tmp.250
           tmp.391
           vector-init-loop.75
           tmp.73
           c.87
           ra.390))
         (r12
          (rbp
           tmp.253
           tmp.483
           tmp.252
           tmp.394
           tmp.251
           tmp.393
           tmp.392
           tmp.250
           tmp.391
           vector-init-loop.75
           tmp.73
           c.87
           ra.390))
         (rsi (r15 rdi vector-init-loop.75 rdx rcx rbp c.87 ra.390))
         (rdi (r15 rsi rdx rcx rbp ra.390))
         (c.87 (tmp.73 rsi r12 rbp ra.390))
         (tmp.73
          (rdx
           rcx
           tmp.115
           tmp.74
           tmp.124
           tmp.395
           tmp.253
           tmp.483
           tmp.252
           tmp.394
           tmp.251
           tmp.393
           tmp.392
           tmp.250
           tmp.391
           vector-init-loop.75
           c.87
           r12
           rbp
           ra.390))
         (vector-init-loop.75
          (rsi
           rdx
           rcx
           tmp.74
           tmp.124
           tmp.395
           tmp.253
           tmp.483
           tmp.252
           tmp.394
           tmp.251
           tmp.393
           tmp.392
           tmp.250
           tmp.391
           tmp.73
           ra.390
           rbp
           r12))
         (tmp.391 (tmp.73 vector-init-loop.75 ra.390 rbp r12))
         (tmp.250 (tmp.392 r12 rbp ra.390 vector-init-loop.75 tmp.73))
         (tmp.392 (tmp.250 r12 rbp ra.390 vector-init-loop.75 tmp.73))
         (tmp.393 (tmp.73 vector-init-loop.75 ra.390 rbp r12))
         (tmp.251 (r12 rbp ra.390 vector-init-loop.75 tmp.73))
         (tmp.394 (tmp.73 vector-init-loop.75 ra.390 rbp r12))
         (tmp.252 (r12 rbp ra.390 vector-init-loop.75 tmp.73))
         (tmp.483 (tmp.253 r12 rbp ra.390 vector-init-loop.75 tmp.73))
         (tmp.253 (r12 tmp.483 rbp ra.390 vector-init-loop.75 tmp.73))
         (tmp.395 (tmp.73 vector-init-loop.75 ra.390 rbp))
         (tmp.124 (rbp ra.390 vector-init-loop.75 tmp.73))
         (tmp.74 (tmp.115 tmp.73 vector-init-loop.75 ra.390 rbp))
         (tmp.115 (tmp.74 tmp.73 ra.390 rbp))
         (rcx (r15 rdi rsi rdx tmp.73 vector-init-loop.75 ra.390 rbp))
         (rdx (r15 rdi rsi tmp.73 vector-init-loop.75 ra.390 rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))))
       (assignment ()))
      (begin
        (set! ra.390 r15)
        (set! c.87 rdi)
        (set! tmp.73 rsi)
        (set! vector-init-loop.75 (mref c.87 14))
        (set! tmp.391 (arithmetic-shift-right tmp.73 3))
        (set! tmp.250 tmp.391)
        (set! tmp.392 1)
        (set! tmp.393 (+ tmp.392 tmp.250))
        (set! tmp.251 tmp.393)
        (set! tmp.394 (* tmp.251 8))
        (set! tmp.252 tmp.394)
        (set! tmp.483 tmp.252)
        (set! tmp.253 r12)
        (set! r12 (+ r12 tmp.483))
        (set! tmp.395 (+ tmp.253 3))
        (set! tmp.124 tmp.395)
        (mset! tmp.124 -3 tmp.73)
        (set! tmp.74 tmp.124)
        (set! tmp.115 vector-init-loop.75)
        (set! rcx tmp.74)
        (set! rdx 0)
        (set! rsi tmp.73)
        (set! rdi vector-init-loop.75)
        (set! r15 ra.390)
        (jump L.vector-init-loop.75.3 rbp r15 rcx rdx rsi rdi)))
    (define L.vector-init-loop.75.3
      ((new-frames ())
       (locals (vec.77 vector-init-loop.75 len.76 i.78 ra.396 c.86))
       (undead-out
        ((rdi rsi rdx rcx ra.396 rbp)
         (rsi rdx rcx c.86 ra.396 rbp)
         (rdx rcx c.86 len.76 ra.396 rbp)
         (rcx c.86 len.76 i.78 ra.396 rbp)
         (c.86 vec.77 len.76 i.78 ra.396 rbp)
         (vec.77 vector-init-loop.75 len.76 i.78 ra.396 rbp)
         ((vec.77 vector-init-loop.75 len.76 i.78 ra.396 rbp)
          ((vector-init-loop.75 len.76 i.78 ra.396 r8 rbp)
           (len.76 i.78 ra.396 rcx r8 rbp)
           (i.78 ra.396 rdx rcx r8 rbp)
           (ra.396 rsi rdx rcx r8 rbp)
           (ra.396 rdi rsi rdx rcx r8 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)
           (rdi rsi rdx rcx r8 r15 rbp))
          ((vector-init-loop.75 len.76 i.78 ra.396 r8 rbp)
           (len.76 i.78 ra.396 rcx r8 rbp)
           (i.78 ra.396 rdx rcx r8 rbp)
           (ra.396 rsi rdx rcx r8 rbp)
           (ra.396 rdi rsi rdx rcx r8 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)))))
       (call-undead ())
       (conflicts
        ((r8 (r15 rdi rsi rdx rcx vector-init-loop.75 len.76 i.78 ra.396 rbp))
         (rbp
          (vector-init-loop.75
           vec.77
           i.78
           len.76
           c.86
           ra.396
           r15
           rdi
           rsi
           rdx
           rcx
           r8))
         (ra.396
          (vector-init-loop.75 vec.77 i.78 len.76 c.86 rbp rdi rsi rdx rcx r8))
         (i.78 (vector-init-loop.75 vec.77 c.86 len.76 ra.396 rbp rdx rcx r8))
         (len.76 (vector-init-loop.75 vec.77 i.78 rdx c.86 ra.396 rbp rcx r8))
         (vector-init-loop.75 (rbp ra.396 i.78 len.76 vec.77 r8))
         (rcx (c.86 r15 rdi rsi rdx len.76 i.78 ra.396 r8 rbp))
         (rdx (len.76 c.86 r15 rdi rsi i.78 ra.396 rcx r8 rbp))
         (rsi (c.86 r15 rdi ra.396 rdx rcx r8 rbp))
         (rdi (r15 ra.396 rsi rdx rcx r8 rbp))
         (r15 (rdi rsi rdx rcx r8 rbp))
         (c.86 (vec.77 i.78 len.76 rsi rdx rcx ra.396 rbp))
         (vec.77 (vector-init-loop.75 c.86 len.76 i.78 ra.396 rbp))))
       (assignment ()))
      (begin
        (set! ra.396 r15)
        (set! c.86 rdi)
        (set! len.76 rsi)
        (set! i.78 rdx)
        (set! vec.77 rcx)
        (set! vector-init-loop.75 (mref c.86 14))
        (if (eq? len.76 i.78)
          (begin
            (set! r8 vec.77)
            (set! rcx vector-init-loop.75)
            (set! rdx len.76)
            (set! rsi i.78)
            (set! rdi 14)
            (set! r15 ra.396)
            (jump L.jp.93 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 vec.77)
            (set! rcx vector-init-loop.75)
            (set! rdx len.76)
            (set! rsi i.78)
            (set! rdi 6)
            (set! r15 ra.396)
            (jump L.jp.93 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.unsafe-vector-set!.2.2
      ((new-frames ())
       (locals (tmp.81 tmp.79 tmp.80 ra.397 tmp.267 c.85))
       (undead-out
        ((rdi rsi rdx rcx ra.397 rbp)
         (rsi rdx rcx ra.397 rbp)
         (rdx rcx tmp.79 ra.397 rbp)
         (rcx tmp.79 tmp.80 ra.397 rbp)
         (tmp.81 tmp.79 tmp.80 ra.397 rbp)
         (tmp.267 tmp.81 tmp.79 tmp.80 ra.397 rbp)
         ((tmp.81 tmp.79 tmp.80 ra.397 rbp)
          ((tmp.79 tmp.80 ra.397 rcx rbp)
           (tmp.80 ra.397 rdx rcx rbp)
           (ra.397 rsi rdx rcx rbp)
           (ra.397 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp))
          ((tmp.79 tmp.80 ra.397 rcx rbp)
           (tmp.80 ra.397 rdx rcx rbp)
           (ra.397 rsi rdx rcx rbp)
           (ra.397 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rcx (c.85 r15 rdi rsi rdx tmp.79 tmp.80 ra.397 rbp))
         (rbp (tmp.267 tmp.81 tmp.80 tmp.79 c.85 ra.397 r15 rdi rsi rdx rcx))
         (ra.397 (tmp.267 tmp.81 tmp.80 tmp.79 c.85 rbp rdi rsi rdx rcx))
         (tmp.80 (tmp.267 tmp.81 tmp.79 ra.397 rbp rdx rcx))
         (tmp.79 (tmp.267 tmp.81 tmp.80 rdx ra.397 rbp rcx))
         (rdx (tmp.79 c.85 r15 rdi rsi tmp.80 ra.397 rcx rbp))
         (rsi (c.85 r15 rdi ra.397 rdx rcx rbp))
         (rdi (r15 ra.397 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (c.85 (rsi rdx rcx ra.397 rbp))
         (tmp.81 (tmp.267 tmp.79 tmp.80 ra.397 rbp))
         (tmp.267 (rbp ra.397 tmp.80 tmp.79 tmp.81))))
       (assignment ()))
      (begin
        (set! ra.397 r15)
        (set! c.85 rdi)
        (set! tmp.79 rsi)
        (set! tmp.80 rdx)
        (set! tmp.81 rcx)
        (set! tmp.267 (mref tmp.79 -3))
        (if (< tmp.80 tmp.267)
          (begin
            (set! rcx tmp.81)
            (set! rdx tmp.79)
            (set! rsi tmp.80)
            (set! rdi 14)
            (set! r15 ra.397)
            (jump L.jp.97 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx tmp.81)
            (set! rdx tmp.79)
            (set! rsi tmp.80)
            (set! rdi 6)
            (set! r15 ra.397)
            (jump L.jp.97 rbp r15 rcx rdx rsi rdi)))))
    (define L.unsafe-vector-ref.3.1
      ((new-frames ())
       (locals (tmp.79 tmp.80 ra.398 tmp.275 c.84))
       (undead-out
        ((rdi rsi rdx ra.398 rbp)
         (rsi rdx ra.398 rbp)
         (rdx tmp.79 ra.398 rbp)
         (tmp.79 tmp.80 ra.398 rbp)
         (tmp.275 tmp.79 tmp.80 ra.398 rbp)
         ((tmp.79 tmp.80 ra.398 rbp)
          ((tmp.80 ra.398 rdx rbp)
           (ra.398 rsi rdx rbp)
           (ra.398 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.80 ra.398 rdx rbp)
           (ra.398 rsi rdx rbp)
           (ra.398 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (tmp.79 c.84 r15 rdi rsi tmp.80 ra.398 rbp))
         (rbp (tmp.275 tmp.80 tmp.79 c.84 ra.398 r15 rdi rsi rdx))
         (ra.398 (tmp.275 tmp.80 tmp.79 c.84 rbp rdi rsi rdx))
         (tmp.80 (tmp.275 tmp.79 ra.398 rbp rdx))
         (rsi (c.84 r15 rdi ra.398 rdx rbp))
         (rdi (r15 ra.398 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.84 (rsi rdx ra.398 rbp))
         (tmp.79 (tmp.275 tmp.80 rdx ra.398 rbp))
         (tmp.275 (rbp ra.398 tmp.80 tmp.79))))
       (assignment ()))
      (begin
        (set! ra.398 r15)
        (set! c.84 rdi)
        (set! tmp.79 rsi)
        (set! tmp.80 rdx)
        (set! tmp.275 (mref tmp.79 -3))
        (if (< tmp.80 tmp.275)
          (begin
            (set! rdx tmp.79)
            (set! rsi tmp.80)
            (set! rdi 14)
            (set! r15 ra.398)
            (jump L.jp.101 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.79)
            (set! rsi tmp.80)
            (set! rdi 6)
            (set! r15 ra.398)
            (jump L.jp.101 rbp r15 rdx rsi rdi)))))
    (define L.jp.103
      ((new-frames ())
       (locals (t.5 vector-ref.57 not.70 vector-set!.56 x.4 ra.399 tmp.308))
       (undead-out
        ((rdi rsi rdx rcx r8 r9 ra.399 rbp)
         (rsi rdx rcx r8 r9 tmp.308 ra.399 rbp)
         (rdx rcx r8 r9 tmp.308 x.4 ra.399 rbp)
         (rcx r8 r9 tmp.308 vector-set!.56 x.4 ra.399 rbp)
         (r8 r9 tmp.308 not.70 vector-set!.56 x.4 ra.399 rbp)
         (r9 tmp.308 vector-ref.57 not.70 vector-set!.56 x.4 ra.399 rbp)
         (tmp.308 t.5 vector-ref.57 not.70 vector-set!.56 x.4 ra.399 rbp)
         ((t.5 vector-ref.57 not.70 vector-set!.56 x.4 ra.399 rbp)
          ((vector-ref.57 not.70 vector-set!.56 x.4 ra.399 r8 rbp)
           (not.70 vector-set!.56 x.4 ra.399 rcx r8 rbp)
           (vector-set!.56 x.4 ra.399 rdx rcx r8 rbp)
           (x.4 ra.399 rsi rdx rcx r8 rbp)
           (ra.399 rdi rsi rdx rcx r8 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)
           (rdi rsi rdx rcx r8 r15 rbp))
          ((vector-ref.57 not.70 vector-set!.56 ra.399 r8 rbp)
           (not.70 vector-set!.56 ra.399 rcx r8 rbp)
           (vector-set!.56 ra.399 rdx rcx r8 rbp)
           (ra.399 rsi rdx rcx r8 rbp)
           (ra.399 rdi rsi rdx rcx r8 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)))))
       (call-undead ())
       (conflicts
        ((r8
          (tmp.308
           x.4
           r15
           rdi
           rsi
           rdx
           rcx
           vector-ref.57
           not.70
           vector-set!.56
           ra.399
           rbp))
         (rbp
          (t.5
           vector-ref.57
           not.70
           vector-set!.56
           x.4
           tmp.308
           ra.399
           r15
           rdi
           rsi
           rdx
           rcx
           r8))
         (ra.399
          (t.5
           vector-ref.57
           not.70
           vector-set!.56
           x.4
           tmp.308
           r9
           rbp
           rdi
           rsi
           rdx
           rcx
           r8))
         (vector-set!.56
          (t.5 vector-ref.57 not.70 r9 tmp.308 x.4 ra.399 rbp rdx rcx r8))
         (not.70
          (t.5 vector-ref.57 r9 tmp.308 vector-set!.56 x.4 ra.399 rbp rcx r8))
         (vector-ref.57
          (t.5 r9 tmp.308 not.70 vector-set!.56 x.4 ra.399 rbp r8))
         (rcx
          (tmp.308 x.4 r15 rdi rsi rdx not.70 vector-set!.56 ra.399 r8 rbp))
         (rdx (tmp.308 x.4 r15 rdi rsi vector-set!.56 ra.399 rcx r8 rbp))
         (rsi (tmp.308 x.4 r15 rdi ra.399 rdx rcx r8 rbp))
         (rdi (r15 ra.399 rsi rdx rcx r8 rbp))
         (r15 (rdi rsi rdx rcx r8 rbp))
         (x.4
          (t.5
           vector-ref.57
           not.70
           vector-set!.56
           r9
           tmp.308
           ra.399
           rbp
           rsi
           rdx
           rcx
           r8))
         (r9 (vector-ref.57 not.70 vector-set!.56 x.4 tmp.308 ra.399))
         (tmp.308
          (t.5
           vector-ref.57
           not.70
           vector-set!.56
           x.4
           rsi
           rdx
           rcx
           r8
           r9
           ra.399
           rbp))
         (t.5 (tmp.308 vector-ref.57 not.70 vector-set!.56 x.4 ra.399 rbp))))
       (assignment ()))
      (begin
        (set! ra.399 r15)
        (set! tmp.308 rdi)
        (set! x.4 rsi)
        (set! vector-set!.56 rdx)
        (set! not.70 rcx)
        (set! vector-ref.57 r8)
        (set! t.5 r9)
        (if (neq? tmp.308 6)
          (begin
            (set! r8 t.5)
            (set! rcx vector-ref.57)
            (set! rdx not.70)
            (set! rsi vector-set!.56)
            (set! rdi x.4)
            (set! r15 ra.399)
            (jump L.jp.102 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 t.5)
            (set! rcx vector-ref.57)
            (set! rdx not.70)
            (set! rsi vector-set!.56)
            (set! rdi 6)
            (set! r15 ra.399)
            (jump L.jp.102 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.jp.102
      ((new-frames ())
       (locals
        (tmp.306 vector-set!.56 t.5.7 tmp.120 tmp.8 tmp.121 tmp.122 tmp.307))
       (undead-out
        ((rdi rsi rdx rcx r8 ra.400 rbp)
         (rsi rdx rcx r8 tmp.306 ra.400 rbp)
         (rdx rcx r8 tmp.306 vector-set!.56 ra.400 rbp)
         (rcx r8 tmp.306 vector-set!.56 not.70 ra.400 rbp)
         (r8 tmp.306 vector-set!.56 vector-ref.57 not.70 ra.400 rbp)
         (tmp.306 vector-set!.56 vector-ref.57 t.5 not.70 ra.400 rbp)
         (vector-set!.56 t.5.7 vector-ref.57 t.5 not.70 ra.400 rbp)
         (vector-set!.56 t.5.7 vector-ref.57 t.5 not.70 ra.400 rbp)
         ((rax vector-ref.57 t.5 not.70 ra.400 rbp)
          ((t.5 vector-set!.56 rcx rbp)
           (t.5 vector-set!.56 rdx rcx rbp)
           (vector-set!.56 rsi rdx rcx rbp)
           (rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp)))
         (vector-ref.57 t.5 not.70 ra.400 rbp)
         (vector-ref.57 t.5 not.70 ra.400 rbp)
         (vector-ref.57 t.5 not.70 ra.400 rbp)
         ((rax not.70 ra.400 rbp)
          ((t.5 vector-ref.57 rdx rbp)
           (vector-ref.57 rsi rdx rbp)
           (rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))
         (tmp.307 not.70 ra.400 rbp)
         (not.70 ra.400 rsi rbp)
         (ra.400 rdi rsi rbp)
         (rdi rsi r15 rbp)
         (rdi rsi r15 rbp)))
       (call-undead (vector-ref.57 t.5 not.70 ra.400))
       (conflicts
        ((ra.400
          (tmp.307
           tmp.122
           tmp.121
           tmp.8
           rax
           tmp.120
           t.5.7
           t.5
           vector-ref.57
           not.70
           vector-set!.56
           tmp.306
           rdi
           rsi
           rdx
           rcx
           r8
           rbp))
         (rbp
          (tmp.307
           tmp.122
           tmp.121
           tmp.8
           r15
           rdi
           rsi
           rdx
           rcx
           rax
           tmp.120
           t.5.7
           t.5
           vector-ref.57
           not.70
           vector-set!.56
           tmp.306
           ra.400))
         (r8 (vector-ref.57 not.70 vector-set!.56 tmp.306 ra.400))
         (rcx (r15 rdi rsi rdx t.5 rbp not.70 vector-set!.56 tmp.306 ra.400))
         (rdx
          (vector-ref.57
           r15
           rdi
           rsi
           t.5
           rcx
           rbp
           vector-set!.56
           tmp.306
           ra.400))
         (rsi
          (not.70
           vector-ref.57
           r15
           rdi
           vector-set!.56
           rdx
           rcx
           rbp
           tmp.306
           ra.400))
         (rdi (r15 rsi rdx rcx rbp ra.400))
         (tmp.306
          (t.5 vector-ref.57 not.70 vector-set!.56 rsi rdx rcx r8 ra.400 rbp))
         (vector-set!.56
          (rsi t.5.7 t.5 vector-ref.57 not.70 rdx rcx r8 tmp.306 ra.400 rbp))
         (not.70
          (rsi
           tmp.307
           tmp.122
           tmp.8
           rax
           tmp.120
           t.5.7
           t.5
           vector-ref.57
           rcx
           r8
           tmp.306
           vector-set!.56
           ra.400
           rbp))
         (vector-ref.57
          (rsi
           rdx
           tmp.121
           tmp.8
           rax
           tmp.120
           t.5.7
           t.5
           r8
           tmp.306
           vector-set!.56
           not.70
           ra.400
           rbp))
         (t.5
          (tmp.122
           tmp.121
           tmp.8
           rdx
           rcx
           rax
           tmp.120
           t.5.7
           tmp.306
           vector-set!.56
           vector-ref.57
           not.70
           ra.400
           rbp))
         (t.5.7 (tmp.120 vector-set!.56 vector-ref.57 t.5 not.70 ra.400 rbp))
         (tmp.120 (t.5.7 vector-ref.57 t.5 not.70 ra.400 rbp))
         (rax (rbp ra.400 not.70 t.5 vector-ref.57))
         (r15 (rdi rsi rdx rcx rbp))
         (tmp.8 (vector-ref.57 t.5 not.70 ra.400 rbp))
         (tmp.121 (vector-ref.57 t.5 ra.400 rbp))
         (tmp.122 (t.5 not.70 ra.400 rbp))
         (tmp.307 (not.70 ra.400 rbp))))
       (assignment ((ra.400 fv0) (not.70 fv1) (t.5 fv2) (vector-ref.57 fv3))))
      (begin
        (set! ra.400 r15)
        (set! tmp.306 rdi)
        (set! vector-set!.56 rsi)
        (set! not.70 rdx)
        (set! vector-ref.57 rcx)
        (set! t.5 r8)
        (set! t.5.7 tmp.306)
        (set! tmp.120 vector-set!.56)
        (return-point L.rp.106
          (begin
            (set! rcx t.5.7)
            (set! rdx 0)
            (set! rsi t.5)
            (set! rdi vector-set!.56)
            (set! r15 L.rp.106)
            (jump L.vector-set!.56.21 rbp r15 rcx rdx rsi rdi)))
        (set! tmp.8 rax)
        (set! tmp.121 not.70)
        (set! tmp.122 vector-ref.57)
        (return-point L.rp.107
          (begin
            (set! rdx 0)
            (set! rsi t.5)
            (set! rdi vector-ref.57)
            (set! r15 L.rp.107)
            (jump L.vector-ref.57.20 rbp r15 rdx rsi rdi)))
        (set! tmp.307 rax)
        (set! rsi tmp.307)
        (set! rdi not.70)
        (set! r15 ra.400)
        (jump L.not.70.7 rbp r15 rsi rdi)))
    (define L.jp.101
      ((new-frames ())
       (locals (tmp.79 tmp.80 ra.401 tmp.269))
       (undead-out
        ((rdi rsi rdx ra.401 rbp)
         (rsi rdx tmp.269 ra.401 rbp)
         (rdx tmp.269 tmp.80 ra.401 rbp)
         (tmp.269 tmp.79 tmp.80 ra.401 rbp)
         ((tmp.79 tmp.80 ra.401 rbp)
          ((tmp.79 tmp.80 ra.401 rbp)
           ((tmp.80 ra.401 rdx rbp)
            (ra.401 rsi rdx rbp)
            (ra.401 rdi rsi rdx rbp)
            (rdi rsi rdx r15 rbp)
            (rdi rsi rdx r15 rbp))
           ((tmp.80 ra.401 rdx rbp)
            (ra.401 rsi rdx rbp)
            (ra.401 rdi rsi rdx rbp)
            (rdi rsi rdx r15 rbp)
            (rdi rsi rdx r15 rbp)))
          ((ra.401 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.401 rbp))
         (rbp (tmp.79 tmp.80 tmp.269 ra.401 r15 rdi rsi rdx rax))
         (ra.401 (tmp.79 tmp.80 tmp.269 rbp rdi rsi rdx rax))
         (rdx (tmp.269 r15 rdi rsi tmp.80 ra.401 rbp))
         (tmp.80 (tmp.79 tmp.269 ra.401 rbp rdx))
         (rsi (tmp.269 r15 rdi ra.401 rdx rbp))
         (rdi (r15 ra.401 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.269 (tmp.79 tmp.80 rsi rdx ra.401 rbp))
         (tmp.79 (tmp.269 tmp.80 ra.401 rbp))))
       (assignment ()))
      (begin
        (set! ra.401 r15)
        (set! tmp.269 rdi)
        (set! tmp.80 rsi)
        (set! tmp.79 rdx)
        (if (neq? tmp.269 6)
          (if (>= tmp.80 0)
            (begin
              (set! rdx tmp.79)
              (set! rsi tmp.80)
              (set! rdi 14)
              (set! r15 ra.401)
              (jump L.jp.100 rbp r15 rdx rsi rdi))
            (begin
              (set! rdx tmp.79)
              (set! rsi tmp.80)
              (set! rdi 6)
              (set! r15 ra.401)
              (jump L.jp.100 rbp r15 rdx rsi rdi)))
          (begin (set! rax 2622) (jump ra.401 rbp rax)))))
    (define L.jp.100
      ((new-frames ())
       (locals
        (tmp.80
         tmp.403
         tmp.272
         tmp.404
         tmp.273
         tmp.405
         tmp.274
         tmp.79
         tmp.271
         ra.402))
       (undead-out
        ((rdi rsi rdx ra.402 rbp)
         (rsi rdx tmp.271 ra.402 rbp)
         (rdx tmp.271 tmp.80 ra.402 rbp)
         (tmp.271 tmp.80 tmp.79 ra.402 rbp)
         ((tmp.80 tmp.79 ra.402 rbp)
          ((tmp.403 tmp.79 ra.402 rbp)
           (tmp.272 tmp.79 ra.402 rbp)
           (tmp.404 tmp.79 ra.402 rbp)
           (tmp.273 tmp.79 ra.402 rbp)
           (tmp.405 tmp.79 ra.402 rbp)
           (tmp.274 tmp.79 ra.402 rbp)
           (ra.402 rax rbp)
           (rax rbp))
          ((ra.402 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.402 rbp))
         (rbp
          (tmp.79
           tmp.80
           tmp.271
           ra.402
           tmp.274
           tmp.405
           tmp.273
           tmp.404
           tmp.272
           tmp.403
           rax))
         (ra.402
          (tmp.79
           tmp.80
           tmp.271
           rdi
           rsi
           rdx
           rbp
           tmp.274
           tmp.405
           tmp.273
           tmp.404
           tmp.272
           tmp.403
           rax))
         (tmp.403 (rbp ra.402 tmp.79))
         (tmp.79
          (tmp.271
           tmp.80
           ra.402
           rbp
           tmp.274
           tmp.405
           tmp.273
           tmp.404
           tmp.272
           tmp.403))
         (tmp.272 (tmp.79 ra.402 rbp))
         (tmp.404 (rbp ra.402 tmp.79))
         (tmp.273 (tmp.79 ra.402 rbp))
         (tmp.405 (rbp ra.402 tmp.79))
         (tmp.274 (tmp.79 ra.402 rbp))
         (rdx (tmp.80 tmp.271 ra.402))
         (rsi (tmp.271 ra.402))
         (rdi (ra.402))
         (tmp.271 (tmp.79 tmp.80 rsi rdx ra.402 rbp))
         (tmp.80 (tmp.79 rdx tmp.271 ra.402 rbp))))
       (assignment ()))
      (begin
        (set! ra.402 r15)
        (set! tmp.271 rdi)
        (set! tmp.80 rsi)
        (set! tmp.79 rdx)
        (if (neq? tmp.271 6)
          (begin
            (set! tmp.403 (arithmetic-shift-right tmp.80 3))
            (set! tmp.272 tmp.403)
            (set! tmp.404 (* tmp.272 8))
            (set! tmp.273 tmp.404)
            (set! tmp.405 (+ tmp.273 5))
            (set! tmp.274 tmp.405)
            (set! rax (mref tmp.79 tmp.274))
            (jump ra.402 rbp rax))
          (begin (set! rax 2622) (jump ra.402 rbp rax)))))
    (define L.jp.97
      ((new-frames ())
       (locals (tmp.79 tmp.81 tmp.80 ra.406 tmp.261))
       (undead-out
        ((rdi rsi rdx rcx ra.406 rbp)
         (rsi rdx rcx tmp.261 ra.406 rbp)
         (rdx rcx tmp.261 tmp.80 ra.406 rbp)
         (rcx tmp.261 tmp.79 tmp.80 ra.406 rbp)
         (tmp.261 tmp.79 tmp.81 tmp.80 ra.406 rbp)
         ((tmp.79 tmp.81 tmp.80 ra.406 rbp)
          ((tmp.79 tmp.81 tmp.80 ra.406 rbp)
           ((tmp.81 tmp.80 ra.406 rcx rbp)
            (tmp.80 ra.406 rdx rcx rbp)
            (ra.406 rsi rdx rcx rbp)
            (ra.406 rdi rsi rdx rcx rbp)
            (rdi rsi rdx rcx r15 rbp)
            (rdi rsi rdx rcx r15 rbp))
           ((tmp.81 tmp.80 ra.406 rcx rbp)
            (tmp.80 ra.406 rdx rcx rbp)
            (ra.406 rsi rdx rcx rbp)
            (ra.406 rdi rsi rdx rcx rbp)
            (rdi rsi rdx rcx r15 rbp)
            (rdi rsi rdx rcx r15 rbp)))
          ((ra.406 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.406 rbp))
         (rbp (tmp.81 tmp.79 tmp.80 tmp.261 ra.406 r15 rdi rsi rdx rcx rax))
         (ra.406 (tmp.81 tmp.79 tmp.80 tmp.261 rbp rdi rsi rdx rcx rax))
         (rcx (tmp.79 tmp.261 r15 rdi rsi rdx tmp.81 tmp.80 ra.406 rbp))
         (tmp.80 (tmp.81 tmp.79 tmp.261 ra.406 rbp rdx rcx))
         (tmp.81 (tmp.261 tmp.79 tmp.80 ra.406 rbp rcx))
         (rdx (tmp.261 r15 rdi rsi tmp.80 ra.406 rcx rbp))
         (rsi (tmp.261 r15 rdi ra.406 rdx rcx rbp))
         (rdi (r15 ra.406 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (tmp.261 (tmp.81 tmp.79 tmp.80 rsi rdx rcx ra.406 rbp))
         (tmp.79 (tmp.81 rcx tmp.261 tmp.80 ra.406 rbp))))
       (assignment ()))
      (begin
        (set! ra.406 r15)
        (set! tmp.261 rdi)
        (set! tmp.80 rsi)
        (set! tmp.79 rdx)
        (set! tmp.81 rcx)
        (if (neq? tmp.261 6)
          (if (>= tmp.80 0)
            (begin
              (set! rcx tmp.79)
              (set! rdx tmp.81)
              (set! rsi tmp.80)
              (set! rdi 14)
              (set! r15 ra.406)
              (jump L.jp.96 rbp r15 rcx rdx rsi rdi))
            (begin
              (set! rcx tmp.79)
              (set! rdx tmp.81)
              (set! rsi tmp.80)
              (set! rdi 6)
              (set! r15 ra.406)
              (jump L.jp.96 rbp r15 rcx rdx rsi rdi)))
          (begin (set! rax 2366) (jump ra.406 rbp rax)))))
    (define L.jp.96
      ((new-frames ())
       (locals
        (tmp.80
         tmp.408
         tmp.264
         tmp.409
         tmp.265
         tmp.410
         tmp.266
         tmp.81
         tmp.79
         tmp.263
         ra.407))
       (undead-out
        ((rdi rsi rdx rcx rbp ra.407)
         (rsi rdx rcx tmp.263 rbp ra.407)
         (rdx rcx tmp.263 tmp.80 rbp ra.407)
         (rcx tmp.263 tmp.80 rbp ra.407 tmp.81)
         (tmp.263 tmp.80 rbp ra.407 tmp.81 tmp.79)
         ((tmp.80 rbp ra.407 tmp.81 tmp.79)
          ((tmp.408 rbp ra.407 tmp.81 tmp.79)
           (tmp.264 rbp ra.407 tmp.81 tmp.79)
           (tmp.409 rbp ra.407 tmp.81 tmp.79)
           (tmp.265 rbp ra.407 tmp.81 tmp.79)
           (tmp.410 rbp ra.407 tmp.81 tmp.79)
           (rbp ra.407 tmp.81 tmp.266 tmp.79)
           (tmp.79 ra.407 rbp)
           (ra.407 rax rbp)
           (rax rbp))
          ((ra.407 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.407 rbp))
         (rbp
          (tmp.79
           tmp.81
           tmp.80
           tmp.263
           ra.407
           tmp.266
           tmp.410
           tmp.265
           tmp.409
           tmp.264
           tmp.408
           rax))
         (ra.407
          (tmp.79
           tmp.81
           tmp.80
           tmp.263
           rdi
           rsi
           rdx
           rcx
           rbp
           tmp.266
           tmp.410
           tmp.265
           tmp.409
           tmp.264
           tmp.408
           rax))
         (tmp.408 (tmp.79 tmp.81 ra.407 rbp))
         (tmp.81
          (tmp.79
           rcx
           tmp.263
           tmp.80
           rbp
           ra.407
           tmp.266
           tmp.410
           tmp.265
           tmp.409
           tmp.264
           tmp.408))
         (tmp.79
          (tmp.263
           tmp.80
           rbp
           ra.407
           tmp.81
           tmp.266
           tmp.410
           tmp.265
           tmp.409
           tmp.264
           tmp.408))
         (tmp.264 (rbp ra.407 tmp.81 tmp.79))
         (tmp.409 (tmp.79 tmp.81 ra.407 rbp))
         (tmp.265 (rbp ra.407 tmp.81 tmp.79))
         (tmp.410 (tmp.79 tmp.81 ra.407 rbp))
         (tmp.266 (rbp ra.407 tmp.81 tmp.79))
         (rcx (tmp.81 tmp.80 tmp.263 ra.407))
         (rdx (tmp.80 tmp.263 ra.407))
         (rsi (tmp.263 ra.407))
         (rdi (ra.407))
         (tmp.263 (tmp.79 tmp.81 tmp.80 rsi rdx rcx rbp ra.407))
         (tmp.80 (tmp.79 tmp.81 rdx rcx tmp.263 rbp ra.407))))
       (assignment ()))
      (begin
        (set! ra.407 r15)
        (set! tmp.263 rdi)
        (set! tmp.80 rsi)
        (set! tmp.81 rdx)
        (set! tmp.79 rcx)
        (if (neq? tmp.263 6)
          (begin
            (set! tmp.408 (arithmetic-shift-right tmp.80 3))
            (set! tmp.264 tmp.408)
            (set! tmp.409 (* tmp.264 8))
            (set! tmp.265 tmp.409)
            (set! tmp.410 (+ tmp.265 5))
            (set! tmp.266 tmp.410)
            (mset! tmp.79 tmp.266 tmp.81)
            (set! rax tmp.79)
            (jump ra.407 rbp rax))
          (begin (set! rax 2366) (jump ra.407 rbp rax)))))
    (define L.jp.93
      ((new-frames ())
       (locals
        (vec.77
         ra.411
         len.76
         tmp.259
         tmp.415
         tmp.114
         vector-init-loop.75
         tmp.258
         tmp.414
         tmp.257
         tmp.413
         tmp.256
         tmp.412
         i.78
         tmp.255))
       (undead-out
        ((rdi rsi rdx rcx r8 ra.411 rbp)
         (rsi rdx rcx r8 tmp.255 ra.411 rbp)
         (rdx rcx r8 tmp.255 i.78 ra.411 rbp)
         (rcx r8 tmp.255 i.78 len.76 ra.411 rbp)
         (r8 tmp.255 i.78 len.76 vector-init-loop.75 ra.411 rbp)
         (tmp.255 i.78 len.76 vector-init-loop.75 vec.77 ra.411 rbp)
         ((i.78 len.76 vector-init-loop.75 vec.77 ra.411 rbp)
          ((ra.411 rax rbp) (rax rbp))
          ((tmp.412 rbp ra.411 vector-init-loop.75 len.76 i.78 vec.77)
           (tmp.256 rbp ra.411 vector-init-loop.75 len.76 i.78 vec.77)
           (tmp.413 rbp ra.411 vector-init-loop.75 len.76 i.78 vec.77)
           (tmp.257 rbp ra.411 vector-init-loop.75 len.76 i.78 vec.77)
           (tmp.414 rbp ra.411 vector-init-loop.75 len.76 i.78 vec.77)
           (rbp ra.411 vector-init-loop.75 len.76 i.78 tmp.258 vec.77)
           (i.78 vec.77 len.76 vector-init-loop.75 ra.411 rbp)
           (i.78 vec.77 len.76 vector-init-loop.75 ra.411 rbp)
           (tmp.415 vec.77 len.76 vector-init-loop.75 ra.411 rbp)
           (vec.77 tmp.259 len.76 vector-init-loop.75 ra.411 rbp)
           (tmp.259 len.76 vector-init-loop.75 ra.411 rcx rbp)
           (len.76 vector-init-loop.75 ra.411 rdx rcx rbp)
           (vector-init-loop.75 ra.411 rsi rdx rcx rbp)
           (ra.411 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((tmp.412 (vec.77 i.78 len.76 vector-init-loop.75 ra.411 rbp))
         (rbp
          (vec.77
           vector-init-loop.75
           len.76
           i.78
           tmp.255
           ra.411
           rax
           r15
           rdi
           rsi
           rdx
           rcx
           tmp.259
           tmp.415
           tmp.114
           tmp.258
           tmp.414
           tmp.257
           tmp.413
           tmp.256
           tmp.412))
         (ra.411
          (vec.77
           vector-init-loop.75
           len.76
           i.78
           tmp.255
           r8
           rbp
           rax
           rdi
           rsi
           rdx
           rcx
           tmp.259
           tmp.415
           tmp.114
           tmp.258
           tmp.414
           tmp.257
           tmp.413
           tmp.256
           tmp.412))
         (vector-init-loop.75
          (vec.77
           r8
           tmp.255
           i.78
           len.76
           ra.411
           rbp
           rsi
           rdx
           rcx
           tmp.259
           tmp.415
           tmp.258
           tmp.414
           tmp.257
           tmp.413
           tmp.256
           tmp.412))
         (len.76
          (vec.77
           vector-init-loop.75
           r8
           tmp.255
           i.78
           ra.411
           rbp
           rdx
           rcx
           tmp.259
           tmp.415
           tmp.114
           tmp.258
           tmp.414
           tmp.257
           tmp.413
           tmp.256
           tmp.412))
         (i.78
          (vec.77
           vector-init-loop.75
           len.76
           rdx
           rcx
           r8
           tmp.255
           ra.411
           rbp
           tmp.114
           tmp.258
           tmp.414
           tmp.257
           tmp.413
           tmp.256
           tmp.412))
         (vec.77
          (tmp.255
           i.78
           len.76
           vector-init-loop.75
           ra.411
           rbp
           tmp.259
           tmp.415
           tmp.114
           tmp.258
           tmp.414
           tmp.257
           tmp.413
           tmp.256
           tmp.412))
         (tmp.256 (rbp ra.411 vector-init-loop.75 len.76 i.78 vec.77))
         (tmp.413 (vec.77 i.78 len.76 vector-init-loop.75 ra.411 rbp))
         (tmp.257 (rbp ra.411 vector-init-loop.75 len.76 i.78 vec.77))
         (tmp.414 (vec.77 i.78 len.76 vector-init-loop.75 ra.411 rbp))
         (tmp.258 (rbp ra.411 vector-init-loop.75 len.76 i.78 vec.77))
         (tmp.114 (i.78 vec.77 len.76 ra.411 rbp))
         (tmp.415 (rbp ra.411 vector-init-loop.75 len.76 vec.77))
         (tmp.259 (rcx vec.77 len.76 vector-init-loop.75 ra.411 rbp))
         (rcx
          (i.78
           tmp.255
           r15
           rdi
           rsi
           rdx
           tmp.259
           len.76
           vector-init-loop.75
           ra.411
           rbp))
         (rdx
          (i.78 tmp.255 r15 rdi rsi len.76 vector-init-loop.75 ra.411 rcx rbp))
         (rsi (tmp.255 r15 rdi vector-init-loop.75 ra.411 rdx rcx rbp))
         (rdi (r15 ra.411 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (rax (ra.411 rbp))
         (r8 (vector-init-loop.75 len.76 i.78 tmp.255 ra.411))
         (tmp.255
          (vec.77 vector-init-loop.75 len.76 i.78 rsi rdx rcx r8 ra.411 rbp))))
       (assignment ()))
      (begin
        (set! ra.411 r15)
        (set! tmp.255 rdi)
        (set! i.78 rsi)
        (set! len.76 rdx)
        (set! vector-init-loop.75 rcx)
        (set! vec.77 r8)
        (if (neq? tmp.255 6)
          (begin (set! rax vec.77) (jump ra.411 rbp rax))
          (begin
            (set! tmp.412 (arithmetic-shift-right i.78 3))
            (set! tmp.256 tmp.412)
            (set! tmp.413 (* tmp.256 8))
            (set! tmp.257 tmp.413)
            (set! tmp.414 (+ tmp.257 5))
            (set! tmp.258 tmp.414)
            (mset! vec.77 tmp.258 0)
            (set! tmp.114 vector-init-loop.75)
            (set! tmp.415 (+ i.78 8))
            (set! tmp.259 tmp.415)
            (set! rcx vec.77)
            (set! rdx tmp.259)
            (set! rsi len.76)
            (set! rdi vector-init-loop.75)
            (set! r15 ra.411)
            (jump L.vector-init-loop.75.3 rbp r15 rcx rdx rsi rdi)))))
    (define L.jp.80
      ((new-frames ())
       (locals (tmp.32 tmp.227 ra.416))
       (undead-out
        ((rdi rsi ra.416 rbp)
         (rsi tmp.227 ra.416 rbp)
         (tmp.227 tmp.32 ra.416 rbp)
         ((tmp.32 ra.416 rbp)
          ((ra.416 rax rbp) (rax rbp))
          ((ra.416 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.416 rbp))
         (rbp (tmp.32 tmp.227 ra.416 rax))
         (ra.416 (tmp.32 tmp.227 rdi rsi rbp rax))
         (rsi (tmp.227 ra.416))
         (rdi (ra.416))
         (tmp.227 (tmp.32 rsi ra.416 rbp))
         (tmp.32 (tmp.227 ra.416 rbp))))
       (assignment ()))
      (begin
        (set! ra.416 r15)
        (set! tmp.227 rdi)
        (set! tmp.32 rsi)
        (if (neq? tmp.227 6)
          (begin (set! rax (mref tmp.32 6)) (jump ra.416 rbp rax))
          (begin (set! rax 3390) (jump ra.416 rbp rax)))))
    (define L.jp.78
      ((new-frames ())
       (locals (tmp.31 tmp.224 ra.417))
       (undead-out
        ((rdi rsi ra.417 rbp)
         (rsi tmp.224 ra.417 rbp)
         (tmp.224 tmp.31 ra.417 rbp)
         ((tmp.31 ra.417 rbp)
          ((ra.417 rax rbp) (rax rbp))
          ((ra.417 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.417 rbp))
         (rbp (tmp.31 tmp.224 ra.417 rax))
         (ra.417 (tmp.31 tmp.224 rdi rsi rbp rax))
         (rsi (tmp.224 ra.417))
         (rdi (ra.417))
         (tmp.224 (tmp.31 rsi ra.417 rbp))
         (tmp.31 (tmp.224 ra.417 rbp))))
       (assignment ()))
      (begin
        (set! ra.417 r15)
        (set! tmp.224 rdi)
        (set! tmp.31 rsi)
        (if (neq? tmp.224 6)
          (begin (set! rax (mref tmp.31 7)) (jump ra.417 rbp rax))
          (begin (set! rax 3134) (jump ra.417 rbp rax)))))
    (define L.jp.76
      ((new-frames ())
       (locals (tmp.30 tmp.221 ra.418))
       (undead-out
        ((rdi rsi ra.418 rbp)
         (rsi tmp.221 ra.418 rbp)
         (tmp.221 tmp.30 ra.418 rbp)
         ((tmp.30 ra.418 rbp)
          ((ra.418 rax rbp) (rax rbp))
          ((ra.418 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.418 rbp))
         (rbp (tmp.30 tmp.221 ra.418 rax))
         (ra.418 (tmp.30 tmp.221 rdi rsi rbp rax))
         (rsi (tmp.221 ra.418))
         (rdi (ra.418))
         (tmp.221 (tmp.30 rsi ra.418 rbp))
         (tmp.30 (tmp.221 ra.418 rbp))))
       (assignment ()))
      (begin
        (set! ra.418 r15)
        (set! tmp.221 rdi)
        (set! tmp.30 rsi)
        (if (neq? tmp.221 6)
          (begin (set! rax (mref tmp.30 -1)) (jump ra.418 rbp rax))
          (begin (set! rax 2878) (jump ra.418 rbp rax)))))
    (define L.jp.74
      ((new-frames ())
       (locals
        (tmp.28 tmp.29 unsafe-vector-ref.3 ra.419 tmp.218 tmp.420 tmp.215))
       (undead-out
        ((rdi rsi rdx rcx ra.419 rbp)
         (rsi rdx rcx tmp.215 ra.419 rbp)
         (rdx rcx tmp.215 tmp.28 ra.419 rbp)
         (rcx tmp.215 tmp.28 unsafe-vector-ref.3 ra.419 rbp)
         (tmp.215 tmp.28 tmp.29 unsafe-vector-ref.3 ra.419 rbp)
         ((tmp.28 tmp.29 unsafe-vector-ref.3 ra.419 rbp)
          ((tmp.420 tmp.28 tmp.29 unsafe-vector-ref.3 ra.419 rbp)
           (tmp.218 tmp.28 tmp.29 unsafe-vector-ref.3 ra.419 rbp)
           ((tmp.28 tmp.29 unsafe-vector-ref.3 ra.419 rbp)
            ((tmp.29 unsafe-vector-ref.3 ra.419 rcx rbp)
             (unsafe-vector-ref.3 ra.419 rdx rcx rbp)
             (ra.419 rsi rdx rcx rbp)
             (ra.419 rdi rsi rdx rcx rbp)
             (rdi rsi rdx rcx r15 rbp)
             (rdi rsi rdx rcx r15 rbp))
            ((tmp.29 unsafe-vector-ref.3 ra.419 rcx rbp)
             (unsafe-vector-ref.3 ra.419 rdx rcx rbp)
             (ra.419 rsi rdx rcx rbp)
             (ra.419 rdi rsi rdx rcx rbp)
             (rdi rsi rdx rcx r15 rbp)
             (rdi rsi rdx rcx r15 rbp))))
          ((ra.419 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.419 rbp))
         (rbp
          (tmp.29
           unsafe-vector-ref.3
           tmp.28
           tmp.215
           ra.419
           tmp.218
           tmp.420
           r15
           rdi
           rsi
           rdx
           rcx
           rax))
         (ra.419
          (tmp.29
           unsafe-vector-ref.3
           tmp.28
           tmp.215
           rbp
           tmp.218
           tmp.420
           rdi
           rsi
           rdx
           rcx
           rax))
         (rcx
          (tmp.28
           tmp.215
           r15
           rdi
           rsi
           rdx
           tmp.29
           unsafe-vector-ref.3
           ra.419
           rbp))
         (unsafe-vector-ref.3
          (tmp.29 tmp.215 tmp.28 ra.419 rbp tmp.218 tmp.420 rdx rcx))
         (tmp.29
          (tmp.215 tmp.28 unsafe-vector-ref.3 ra.419 rbp tmp.218 tmp.420 rcx))
         (rdx (tmp.28 tmp.215 r15 rdi rsi unsafe-vector-ref.3 ra.419 rcx rbp))
         (rsi (tmp.215 r15 rdi ra.419 rdx rcx rbp))
         (rdi (r15 ra.419 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (tmp.420 (rbp ra.419 unsafe-vector-ref.3 tmp.29 tmp.28))
         (tmp.28
          (tmp.29
           unsafe-vector-ref.3
           rdx
           rcx
           tmp.215
           ra.419
           rbp
           tmp.218
           tmp.420))
         (tmp.218 (tmp.28 tmp.29 unsafe-vector-ref.3 ra.419 rbp))
         (tmp.215 (tmp.29 unsafe-vector-ref.3 tmp.28 rsi rdx rcx ra.419 rbp))))
       (assignment ()))
      (begin
        (set! ra.419 r15)
        (set! tmp.215 rdi)
        (set! tmp.28 rsi)
        (set! unsafe-vector-ref.3 rdx)
        (set! tmp.29 rcx)
        (if (neq? tmp.215 6)
          (begin
            (set! tmp.420 (bitwise-and tmp.28 7))
            (set! tmp.218 tmp.420)
            (if (eq? tmp.218 3)
              (begin
                (set! rcx tmp.28)
                (set! rdx tmp.29)
                (set! rsi unsafe-vector-ref.3)
                (set! rdi 14)
                (set! r15 ra.419)
                (jump L.jp.73 rbp r15 rcx rdx rsi rdi))
              (begin
                (set! rcx tmp.28)
                (set! rdx tmp.29)
                (set! rsi unsafe-vector-ref.3)
                (set! rdi 6)
                (set! r15 ra.419)
                (jump L.jp.73 rbp r15 rcx rdx rsi rdi))))
          (begin (set! rax 2622) (jump ra.419 rbp rax)))))
    (define L.jp.73
      ((new-frames ())
       (locals (unsafe-vector-ref.3 tmp.116 tmp.29 tmp.28 ra.421 tmp.217))
       (undead-out
        ((rdi rsi rdx rcx ra.421 rbp)
         (rsi rdx rcx tmp.217 ra.421 rbp)
         (rdx rcx tmp.217 unsafe-vector-ref.3 ra.421 rbp)
         (rcx tmp.217 tmp.29 unsafe-vector-ref.3 ra.421 rbp)
         (tmp.217 tmp.29 tmp.28 unsafe-vector-ref.3 ra.421 rbp)
         ((tmp.29 tmp.28 unsafe-vector-ref.3 ra.421 rbp)
          ((tmp.29 tmp.28 unsafe-vector-ref.3 ra.421 rbp)
           (tmp.28 unsafe-vector-ref.3 ra.421 rdx rbp)
           (unsafe-vector-ref.3 ra.421 rsi rdx rbp)
           (ra.421 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((ra.421 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.421 rbp))
         (rbp
          (tmp.28
           tmp.29
           unsafe-vector-ref.3
           tmp.217
           ra.421
           r15
           rdi
           rsi
           rdx
           tmp.116
           rax))
         (ra.421
          (tmp.28
           tmp.29
           unsafe-vector-ref.3
           tmp.217
           rcx
           rbp
           rdi
           rsi
           rdx
           tmp.116
           rax))
         (tmp.116 (tmp.29 tmp.28 ra.421 rbp))
         (tmp.28 (tmp.217 tmp.29 unsafe-vector-ref.3 ra.421 rbp rdx tmp.116))
         (tmp.29 (tmp.28 rcx tmp.217 unsafe-vector-ref.3 ra.421 rbp tmp.116))
         (rdx (tmp.217 r15 rdi rsi tmp.28 unsafe-vector-ref.3 ra.421 rbp))
         (unsafe-vector-ref.3 (tmp.28 tmp.29 rcx tmp.217 ra.421 rbp rsi rdx))
         (rsi (tmp.217 r15 rdi unsafe-vector-ref.3 ra.421 rdx rbp))
         (rdi (r15 ra.421 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (rcx (tmp.29 unsafe-vector-ref.3 tmp.217 ra.421))
         (tmp.217 (tmp.28 tmp.29 unsafe-vector-ref.3 rsi rdx rcx ra.421 rbp))))
       (assignment ()))
      (begin
        (set! ra.421 r15)
        (set! tmp.217 rdi)
        (set! unsafe-vector-ref.3 rsi)
        (set! tmp.29 rdx)
        (set! tmp.28 rcx)
        (if (neq? tmp.217 6)
          (begin
            (set! tmp.116 unsafe-vector-ref.3)
            (set! rdx tmp.29)
            (set! rsi tmp.28)
            (set! rdi unsafe-vector-ref.3)
            (set! r15 ra.421)
            (jump L.unsafe-vector-ref.3.1 rbp r15 rdx rsi rdi))
          (begin (set! rax 2622) (jump ra.421 rbp rax)))))
    (define L.jp.70
      ((new-frames ())
       (locals
        (tmp.25
         tmp.26
         tmp.27
         unsafe-vector-set!.2
         ra.422
         tmp.212
         tmp.423
         tmp.209))
       (undead-out
        ((rdi rsi rdx rcx r8 ra.422 rbp)
         (rsi rdx rcx r8 tmp.209 ra.422 rbp)
         (rdx rcx r8 tmp.209 tmp.25 ra.422 rbp)
         (rcx r8 tmp.209 tmp.25 unsafe-vector-set!.2 ra.422 rbp)
         (r8 tmp.209 tmp.25 tmp.27 unsafe-vector-set!.2 ra.422 rbp)
         (tmp.209 tmp.25 tmp.26 tmp.27 unsafe-vector-set!.2 ra.422 rbp)
         ((tmp.25 tmp.26 tmp.27 unsafe-vector-set!.2 ra.422 rbp)
          ((tmp.423 tmp.25 tmp.26 tmp.27 unsafe-vector-set!.2 ra.422 rbp)
           (tmp.212 tmp.25 tmp.26 tmp.27 unsafe-vector-set!.2 ra.422 rbp)
           ((tmp.25 tmp.26 tmp.27 unsafe-vector-set!.2 ra.422 rbp)
            ((tmp.26 tmp.27 unsafe-vector-set!.2 ra.422 r8 rbp)
             (tmp.27 unsafe-vector-set!.2 ra.422 rcx r8 rbp)
             (unsafe-vector-set!.2 ra.422 rdx rcx r8 rbp)
             (ra.422 rsi rdx rcx r8 rbp)
             (ra.422 rdi rsi rdx rcx r8 rbp)
             (rdi rsi rdx rcx r8 r15 rbp)
             (rdi rsi rdx rcx r8 r15 rbp))
            ((tmp.26 tmp.27 unsafe-vector-set!.2 ra.422 r8 rbp)
             (tmp.27 unsafe-vector-set!.2 ra.422 rcx r8 rbp)
             (unsafe-vector-set!.2 ra.422 rdx rcx r8 rbp)
             (ra.422 rsi rdx rcx r8 rbp)
             (ra.422 rdi rsi rdx rcx r8 rbp)
             (rdi rsi rdx rcx r8 r15 rbp)
             (rdi rsi rdx rcx r8 r15 rbp))))
          ((ra.422 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.422 rbp))
         (rbp
          (tmp.26
           tmp.27
           unsafe-vector-set!.2
           tmp.25
           tmp.209
           ra.422
           tmp.212
           tmp.423
           r15
           rdi
           rsi
           rdx
           rcx
           r8
           rax))
         (ra.422
          (tmp.26
           tmp.27
           unsafe-vector-set!.2
           tmp.25
           tmp.209
           rbp
           tmp.212
           tmp.423
           rdi
           rsi
           rdx
           rcx
           r8
           rax))
         (r8
          (tmp.25
           tmp.209
           r15
           rdi
           rsi
           rdx
           rcx
           tmp.26
           tmp.27
           unsafe-vector-set!.2
           ra.422
           rbp))
         (unsafe-vector-set!.2
          (tmp.26 tmp.27 tmp.209 tmp.25 ra.422 rbp tmp.212 tmp.423 rdx rcx r8))
         (tmp.27
          (tmp.26
           tmp.209
           tmp.25
           unsafe-vector-set!.2
           ra.422
           rbp
           tmp.212
           tmp.423
           rcx
           r8))
         (tmp.26
          (tmp.209
           tmp.25
           tmp.27
           unsafe-vector-set!.2
           ra.422
           rbp
           tmp.212
           tmp.423
           r8))
         (rcx
          (tmp.25
           tmp.209
           r15
           rdi
           rsi
           rdx
           tmp.27
           unsafe-vector-set!.2
           ra.422
           r8
           rbp))
         (rdx
          (tmp.25 tmp.209 r15 rdi rsi unsafe-vector-set!.2 ra.422 rcx r8 rbp))
         (rsi (tmp.209 r15 rdi ra.422 rdx rcx r8 rbp))
         (rdi (r15 ra.422 rsi rdx rcx r8 rbp))
         (r15 (rdi rsi rdx rcx r8 rbp))
         (tmp.423 (rbp ra.422 unsafe-vector-set!.2 tmp.27 tmp.26 tmp.25))
         (tmp.25
          (tmp.26
           tmp.27
           unsafe-vector-set!.2
           rdx
           rcx
           r8
           tmp.209
           ra.422
           rbp
           tmp.212
           tmp.423))
         (tmp.212 (tmp.25 tmp.26 tmp.27 unsafe-vector-set!.2 ra.422 rbp))
         (tmp.209
          (tmp.26
           tmp.27
           unsafe-vector-set!.2
           tmp.25
           rsi
           rdx
           rcx
           r8
           ra.422
           rbp))))
       (assignment ()))
      (begin
        (set! ra.422 r15)
        (set! tmp.209 rdi)
        (set! tmp.25 rsi)
        (set! unsafe-vector-set!.2 rdx)
        (set! tmp.27 rcx)
        (set! tmp.26 r8)
        (if (neq? tmp.209 6)
          (begin
            (set! tmp.423 (bitwise-and tmp.25 7))
            (set! tmp.212 tmp.423)
            (if (eq? tmp.212 3)
              (begin
                (set! r8 tmp.25)
                (set! rcx tmp.26)
                (set! rdx tmp.27)
                (set! rsi unsafe-vector-set!.2)
                (set! rdi 14)
                (set! r15 ra.422)
                (jump L.jp.69 rbp r15 r8 rcx rdx rsi rdi))
              (begin
                (set! r8 tmp.25)
                (set! rcx tmp.26)
                (set! rdx tmp.27)
                (set! rsi unsafe-vector-set!.2)
                (set! rdi 6)
                (set! r15 ra.422)
                (jump L.jp.69 rbp r15 r8 rcx rdx rsi rdi))))
          (begin (set! rax 2366) (jump ra.422 rbp rax)))))
    (define L.jp.69
      ((new-frames ())
       (locals
        (unsafe-vector-set!.2 tmp.117 tmp.27 tmp.26 tmp.25 ra.424 tmp.211))
       (undead-out
        ((rdi rsi rdx rcx r8 ra.424 rbp)
         (rsi rdx rcx r8 tmp.211 ra.424 rbp)
         (rdx rcx r8 tmp.211 unsafe-vector-set!.2 ra.424 rbp)
         (rcx r8 tmp.211 tmp.27 unsafe-vector-set!.2 ra.424 rbp)
         (r8 tmp.211 tmp.27 tmp.26 unsafe-vector-set!.2 ra.424 rbp)
         (tmp.211 tmp.27 tmp.26 tmp.25 unsafe-vector-set!.2 ra.424 rbp)
         ((tmp.27 tmp.26 tmp.25 unsafe-vector-set!.2 ra.424 rbp)
          ((tmp.27 tmp.26 tmp.25 unsafe-vector-set!.2 ra.424 rbp)
           (tmp.26 tmp.25 unsafe-vector-set!.2 ra.424 rcx rbp)
           (tmp.25 unsafe-vector-set!.2 ra.424 rdx rcx rbp)
           (unsafe-vector-set!.2 ra.424 rsi rdx rcx rbp)
           (ra.424 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp))
          ((ra.424 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.424 rbp))
         (rbp
          (tmp.25
           tmp.26
           tmp.27
           unsafe-vector-set!.2
           tmp.211
           ra.424
           r15
           rdi
           rsi
           rdx
           rcx
           tmp.117
           rax))
         (ra.424
          (tmp.25
           tmp.26
           tmp.27
           unsafe-vector-set!.2
           tmp.211
           r8
           rbp
           rdi
           rsi
           rdx
           rcx
           tmp.117
           rax))
         (tmp.117 (tmp.27 tmp.26 tmp.25 ra.424 rbp))
         (tmp.25
          (tmp.211
           tmp.27
           tmp.26
           unsafe-vector-set!.2
           ra.424
           rbp
           rdx
           rcx
           tmp.117))
         (tmp.26
          (tmp.25
           r8
           tmp.211
           tmp.27
           unsafe-vector-set!.2
           ra.424
           rbp
           rcx
           tmp.117))
         (tmp.27
          (tmp.25
           tmp.26
           rcx
           r8
           tmp.211
           unsafe-vector-set!.2
           ra.424
           rbp
           tmp.117))
         (rcx
          (tmp.27
           tmp.211
           r15
           rdi
           rsi
           rdx
           tmp.26
           tmp.25
           unsafe-vector-set!.2
           ra.424
           rbp))
         (unsafe-vector-set!.2
          (tmp.25 tmp.26 tmp.27 r8 tmp.211 ra.424 rbp rsi rdx rcx))
         (rdx (tmp.211 r15 rdi rsi tmp.25 unsafe-vector-set!.2 ra.424 rcx rbp))
         (rsi (tmp.211 r15 rdi unsafe-vector-set!.2 ra.424 rdx rcx rbp))
         (rdi (r15 ra.424 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (r8 (tmp.26 tmp.27 unsafe-vector-set!.2 tmp.211 ra.424))
         (tmp.211
          (tmp.25
           tmp.26
           tmp.27
           unsafe-vector-set!.2
           rsi
           rdx
           rcx
           r8
           ra.424
           rbp))))
       (assignment ()))
      (begin
        (set! ra.424 r15)
        (set! tmp.211 rdi)
        (set! unsafe-vector-set!.2 rsi)
        (set! tmp.27 rdx)
        (set! tmp.26 rcx)
        (set! tmp.25 r8)
        (if (neq? tmp.211 6)
          (begin
            (set! tmp.117 unsafe-vector-set!.2)
            (set! rcx tmp.27)
            (set! rdx tmp.26)
            (set! rsi tmp.25)
            (set! rdi unsafe-vector-set!.2)
            (set! r15 ra.424)
            (jump L.unsafe-vector-set!.2.2 rbp r15 rcx rdx rsi rdi))
          (begin (set! rax 2366) (jump ra.424 rbp rax)))))
    (define L.jp.66
      ((new-frames ())
       (locals (tmp.24 tmp.206 ra.425))
       (undead-out
        ((rdi rsi ra.425 rbp)
         (rsi tmp.206 ra.425 rbp)
         (tmp.206 tmp.24 ra.425 rbp)
         ((tmp.24 ra.425 rbp)
          ((ra.425 rax rbp) (rax rbp))
          ((ra.425 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.425 rbp))
         (rbp (tmp.24 tmp.206 ra.425 rax))
         (ra.425 (tmp.24 tmp.206 rdi rsi rbp rax))
         (rsi (tmp.206 ra.425))
         (rdi (ra.425))
         (tmp.206 (tmp.24 rsi ra.425 rbp))
         (tmp.24 (tmp.206 ra.425 rbp))))
       (assignment ()))
      (begin
        (set! ra.425 r15)
        (set! tmp.206 rdi)
        (set! tmp.24 rsi)
        (if (neq? tmp.206 6)
          (begin (set! rax (mref tmp.24 -3)) (jump ra.425 rbp rax))
          (begin (set! rax 2110) (jump ra.425 rbp rax)))))
    (define L.jp.64
      ((new-frames ())
       (locals (make-init-vector.1 tmp.118 tmp.23 ra.426 tmp.203))
       (undead-out
        ((rdi rsi rdx ra.426 rbp)
         (rsi rdx tmp.203 ra.426 rbp)
         (rdx tmp.203 make-init-vector.1 ra.426 rbp)
         (tmp.203 tmp.23 make-init-vector.1 ra.426 rbp)
         ((tmp.23 make-init-vector.1 ra.426 rbp)
          ((tmp.23 make-init-vector.1 ra.426 rbp)
           (make-init-vector.1 ra.426 rsi rbp)
           (ra.426 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp))
          ((ra.426 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.426 rbp))
         (rbp
          (tmp.23 make-init-vector.1 tmp.203 ra.426 r15 rdi rsi tmp.118 rax))
         (ra.426
          (tmp.23 make-init-vector.1 tmp.203 rdx rbp rdi rsi tmp.118 rax))
         (tmp.118 (tmp.23 ra.426 rbp))
         (tmp.23 (tmp.203 make-init-vector.1 ra.426 rbp tmp.118))
         (rsi (tmp.203 r15 rdi make-init-vector.1 ra.426 rbp))
         (make-init-vector.1 (tmp.23 rdx tmp.203 ra.426 rbp rsi))
         (rdi (r15 ra.426 rsi rbp))
         (r15 (rdi rsi rbp))
         (rdx (make-init-vector.1 tmp.203 ra.426))
         (tmp.203 (tmp.23 make-init-vector.1 rsi rdx ra.426 rbp))))
       (assignment ()))
      (begin
        (set! ra.426 r15)
        (set! tmp.203 rdi)
        (set! make-init-vector.1 rsi)
        (set! tmp.23 rdx)
        (if (neq? tmp.203 6)
          (begin
            (set! tmp.118 make-init-vector.1)
            (set! rsi tmp.23)
            (set! rdi make-init-vector.1)
            (set! r15 ra.426)
            (jump L.make-init-vector.1.4 rbp r15 rsi rdi))
          (begin (set! rax 1854) (jump ra.426 rbp rax)))))
    (define L.jp.62
      ((new-frames ())
       (locals (tmp.22 tmp.21 ra.427 tmp.200 tmp.428 tmp.196))
       (undead-out
        ((rdi rsi rdx ra.427 rbp)
         (rsi rdx tmp.196 ra.427 rbp)
         (rdx tmp.196 tmp.21 ra.427 rbp)
         (tmp.196 tmp.22 tmp.21 ra.427 rbp)
         ((tmp.22 tmp.21 ra.427 rbp)
          ((tmp.428 tmp.22 tmp.21 ra.427 rbp)
           (tmp.200 tmp.22 tmp.21 ra.427 rbp)
           ((tmp.22 tmp.21 ra.427 rbp)
            ((tmp.21 ra.427 rdx rbp)
             (ra.427 rsi rdx rbp)
             (ra.427 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.21 ra.427 rdx rbp)
             (ra.427 rsi rdx rbp)
             (ra.427 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.427 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.427 rbp))
         (rbp
          (tmp.22 tmp.21 tmp.196 ra.427 tmp.200 tmp.428 r15 rdi rsi rdx rax))
         (ra.427 (tmp.22 tmp.21 tmp.196 rbp tmp.200 tmp.428 rdi rsi rdx rax))
         (rdx (tmp.196 r15 rdi rsi tmp.21 ra.427 rbp))
         (tmp.21 (tmp.22 tmp.196 ra.427 rbp tmp.200 tmp.428 rdx))
         (rsi (tmp.196 r15 rdi ra.427 rdx rbp))
         (rdi (r15 ra.427 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.428 (rbp ra.427 tmp.21 tmp.22))
         (tmp.22 (tmp.196 tmp.21 ra.427 rbp tmp.200 tmp.428))
         (tmp.200 (tmp.22 tmp.21 ra.427 rbp))
         (tmp.196 (tmp.22 tmp.21 rsi rdx ra.427 rbp))))
       (assignment ()))
      (begin
        (set! ra.427 r15)
        (set! tmp.196 rdi)
        (set! tmp.21 rsi)
        (set! tmp.22 rdx)
        (if (neq? tmp.196 6)
          (begin
            (set! tmp.428 (bitwise-and tmp.21 7))
            (set! tmp.200 tmp.428)
            (if (eq? tmp.200 0)
              (begin
                (set! rdx tmp.22)
                (set! rsi tmp.21)
                (set! rdi 14)
                (set! r15 ra.427)
                (jump L.jp.61 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.22)
                (set! rsi tmp.21)
                (set! rdi 6)
                (set! r15 ra.427)
                (jump L.jp.61 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1598) (jump ra.427 rbp rax)))))
    (define L.jp.61
      ((new-frames ())
       (locals (tmp.21 tmp.22 tmp.198 ra.429))
       (undead-out
        ((rdi rsi rdx ra.429 rbp)
         (rsi rdx tmp.198 ra.429 rbp)
         (rdx tmp.198 tmp.21 ra.429 rbp)
         (tmp.198 tmp.21 tmp.22 ra.429 rbp)
         ((tmp.21 tmp.22 ra.429 rbp)
          ((ra.429 rbp)
           ((ra.429 rax rbp) (rax rbp))
           ((ra.429 rax rbp) (rax rbp)))
          ((ra.429 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.429 rbp))
         (rbp (tmp.22 tmp.21 tmp.198 ra.429 rax))
         (ra.429 (tmp.22 tmp.21 tmp.198 rdi rsi rdx rbp rax))
         (rdx (tmp.21 tmp.198 ra.429))
         (rsi (tmp.198 ra.429))
         (rdi (ra.429))
         (tmp.198 (tmp.22 tmp.21 rsi rdx ra.429 rbp))
         (tmp.21 (tmp.22 rdx tmp.198 ra.429 rbp))
         (tmp.22 (tmp.198 tmp.21 ra.429 rbp))))
       (assignment ()))
      (begin
        (set! ra.429 r15)
        (set! tmp.198 rdi)
        (set! tmp.21 rsi)
        (set! tmp.22 rdx)
        (if (neq? tmp.198 6)
          (if (>= tmp.21 tmp.22)
            (begin (set! rax 14) (jump ra.429 rbp rax))
            (begin (set! rax 6) (jump ra.429 rbp rax)))
          (begin (set! rax 1598) (jump ra.429 rbp rax)))))
    (define L.jp.57
      ((new-frames ())
       (locals (tmp.20 tmp.19 ra.430 tmp.193 tmp.431 tmp.189))
       (undead-out
        ((rdi rsi rdx ra.430 rbp)
         (rsi rdx tmp.189 ra.430 rbp)
         (rdx tmp.189 tmp.19 ra.430 rbp)
         (tmp.189 tmp.20 tmp.19 ra.430 rbp)
         ((tmp.20 tmp.19 ra.430 rbp)
          ((tmp.431 tmp.20 tmp.19 ra.430 rbp)
           (tmp.193 tmp.20 tmp.19 ra.430 rbp)
           ((tmp.20 tmp.19 ra.430 rbp)
            ((tmp.19 ra.430 rdx rbp)
             (ra.430 rsi rdx rbp)
             (ra.430 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.19 ra.430 rdx rbp)
             (ra.430 rsi rdx rbp)
             (ra.430 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.430 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.430 rbp))
         (rbp
          (tmp.20 tmp.19 tmp.189 ra.430 tmp.193 tmp.431 r15 rdi rsi rdx rax))
         (ra.430 (tmp.20 tmp.19 tmp.189 rbp tmp.193 tmp.431 rdi rsi rdx rax))
         (rdx (tmp.189 r15 rdi rsi tmp.19 ra.430 rbp))
         (tmp.19 (tmp.20 tmp.189 ra.430 rbp tmp.193 tmp.431 rdx))
         (rsi (tmp.189 r15 rdi ra.430 rdx rbp))
         (rdi (r15 ra.430 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.431 (rbp ra.430 tmp.19 tmp.20))
         (tmp.20 (tmp.189 tmp.19 ra.430 rbp tmp.193 tmp.431))
         (tmp.193 (tmp.20 tmp.19 ra.430 rbp))
         (tmp.189 (tmp.20 tmp.19 rsi rdx ra.430 rbp))))
       (assignment ()))
      (begin
        (set! ra.430 r15)
        (set! tmp.189 rdi)
        (set! tmp.19 rsi)
        (set! tmp.20 rdx)
        (if (neq? tmp.189 6)
          (begin
            (set! tmp.431 (bitwise-and tmp.19 7))
            (set! tmp.193 tmp.431)
            (if (eq? tmp.193 0)
              (begin
                (set! rdx tmp.20)
                (set! rsi tmp.19)
                (set! rdi 14)
                (set! r15 ra.430)
                (jump L.jp.56 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.20)
                (set! rsi tmp.19)
                (set! rdi 6)
                (set! r15 ra.430)
                (jump L.jp.56 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1342) (jump ra.430 rbp rax)))))
    (define L.jp.56
      ((new-frames ())
       (locals (tmp.19 tmp.20 tmp.191 ra.432))
       (undead-out
        ((rdi rsi rdx ra.432 rbp)
         (rsi rdx tmp.191 ra.432 rbp)
         (rdx tmp.191 tmp.19 ra.432 rbp)
         (tmp.191 tmp.19 tmp.20 ra.432 rbp)
         ((tmp.19 tmp.20 ra.432 rbp)
          ((ra.432 rbp)
           ((ra.432 rax rbp) (rax rbp))
           ((ra.432 rax rbp) (rax rbp)))
          ((ra.432 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.432 rbp))
         (rbp (tmp.20 tmp.19 tmp.191 ra.432 rax))
         (ra.432 (tmp.20 tmp.19 tmp.191 rdi rsi rdx rbp rax))
         (rdx (tmp.19 tmp.191 ra.432))
         (rsi (tmp.191 ra.432))
         (rdi (ra.432))
         (tmp.191 (tmp.20 tmp.19 rsi rdx ra.432 rbp))
         (tmp.19 (tmp.20 rdx tmp.191 ra.432 rbp))
         (tmp.20 (tmp.191 tmp.19 ra.432 rbp))))
       (assignment ()))
      (begin
        (set! ra.432 r15)
        (set! tmp.191 rdi)
        (set! tmp.19 rsi)
        (set! tmp.20 rdx)
        (if (neq? tmp.191 6)
          (if (> tmp.19 tmp.20)
            (begin (set! rax 14) (jump ra.432 rbp rax))
            (begin (set! rax 6) (jump ra.432 rbp rax)))
          (begin (set! rax 1342) (jump ra.432 rbp rax)))))
    (define L.jp.52
      ((new-frames ())
       (locals (tmp.18 tmp.17 ra.433 tmp.186 tmp.434 tmp.182))
       (undead-out
        ((rdi rsi rdx ra.433 rbp)
         (rsi rdx tmp.182 ra.433 rbp)
         (rdx tmp.182 tmp.17 ra.433 rbp)
         (tmp.182 tmp.18 tmp.17 ra.433 rbp)
         ((tmp.18 tmp.17 ra.433 rbp)
          ((tmp.434 tmp.18 tmp.17 ra.433 rbp)
           (tmp.186 tmp.18 tmp.17 ra.433 rbp)
           ((tmp.18 tmp.17 ra.433 rbp)
            ((tmp.17 ra.433 rdx rbp)
             (ra.433 rsi rdx rbp)
             (ra.433 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.17 ra.433 rdx rbp)
             (ra.433 rsi rdx rbp)
             (ra.433 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.433 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.433 rbp))
         (rbp
          (tmp.18 tmp.17 tmp.182 ra.433 tmp.186 tmp.434 r15 rdi rsi rdx rax))
         (ra.433 (tmp.18 tmp.17 tmp.182 rbp tmp.186 tmp.434 rdi rsi rdx rax))
         (rdx (tmp.182 r15 rdi rsi tmp.17 ra.433 rbp))
         (tmp.17 (tmp.18 tmp.182 ra.433 rbp tmp.186 tmp.434 rdx))
         (rsi (tmp.182 r15 rdi ra.433 rdx rbp))
         (rdi (r15 ra.433 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.434 (rbp ra.433 tmp.17 tmp.18))
         (tmp.18 (tmp.182 tmp.17 ra.433 rbp tmp.186 tmp.434))
         (tmp.186 (tmp.18 tmp.17 ra.433 rbp))
         (tmp.182 (tmp.18 tmp.17 rsi rdx ra.433 rbp))))
       (assignment ()))
      (begin
        (set! ra.433 r15)
        (set! tmp.182 rdi)
        (set! tmp.17 rsi)
        (set! tmp.18 rdx)
        (if (neq? tmp.182 6)
          (begin
            (set! tmp.434 (bitwise-and tmp.17 7))
            (set! tmp.186 tmp.434)
            (if (eq? tmp.186 0)
              (begin
                (set! rdx tmp.18)
                (set! rsi tmp.17)
                (set! rdi 14)
                (set! r15 ra.433)
                (jump L.jp.51 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.18)
                (set! rsi tmp.17)
                (set! rdi 6)
                (set! r15 ra.433)
                (jump L.jp.51 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1086) (jump ra.433 rbp rax)))))
    (define L.jp.51
      ((new-frames ())
       (locals (tmp.17 tmp.18 tmp.184 ra.435))
       (undead-out
        ((rdi rsi rdx ra.435 rbp)
         (rsi rdx tmp.184 ra.435 rbp)
         (rdx tmp.184 tmp.17 ra.435 rbp)
         (tmp.184 tmp.17 tmp.18 ra.435 rbp)
         ((tmp.17 tmp.18 ra.435 rbp)
          ((ra.435 rbp)
           ((ra.435 rax rbp) (rax rbp))
           ((ra.435 rax rbp) (rax rbp)))
          ((ra.435 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.435 rbp))
         (rbp (tmp.18 tmp.17 tmp.184 ra.435 rax))
         (ra.435 (tmp.18 tmp.17 tmp.184 rdi rsi rdx rbp rax))
         (rdx (tmp.17 tmp.184 ra.435))
         (rsi (tmp.184 ra.435))
         (rdi (ra.435))
         (tmp.184 (tmp.18 tmp.17 rsi rdx ra.435 rbp))
         (tmp.17 (tmp.18 rdx tmp.184 ra.435 rbp))
         (tmp.18 (tmp.184 tmp.17 ra.435 rbp))))
       (assignment ()))
      (begin
        (set! ra.435 r15)
        (set! tmp.184 rdi)
        (set! tmp.17 rsi)
        (set! tmp.18 rdx)
        (if (neq? tmp.184 6)
          (if (<= tmp.17 tmp.18)
            (begin (set! rax 14) (jump ra.435 rbp rax))
            (begin (set! rax 6) (jump ra.435 rbp rax)))
          (begin (set! rax 1086) (jump ra.435 rbp rax)))))
    (define L.jp.47
      ((new-frames ())
       (locals (tmp.16 tmp.15 ra.436 tmp.179 tmp.437 tmp.175))
       (undead-out
        ((rdi rsi rdx ra.436 rbp)
         (rsi rdx tmp.175 ra.436 rbp)
         (rdx tmp.175 tmp.15 ra.436 rbp)
         (tmp.175 tmp.16 tmp.15 ra.436 rbp)
         ((tmp.16 tmp.15 ra.436 rbp)
          ((tmp.437 tmp.16 tmp.15 ra.436 rbp)
           (tmp.179 tmp.16 tmp.15 ra.436 rbp)
           ((tmp.16 tmp.15 ra.436 rbp)
            ((tmp.15 ra.436 rdx rbp)
             (ra.436 rsi rdx rbp)
             (ra.436 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.15 ra.436 rdx rbp)
             (ra.436 rsi rdx rbp)
             (ra.436 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.436 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.436 rbp))
         (rbp
          (tmp.16 tmp.15 tmp.175 ra.436 tmp.179 tmp.437 r15 rdi rsi rdx rax))
         (ra.436 (tmp.16 tmp.15 tmp.175 rbp tmp.179 tmp.437 rdi rsi rdx rax))
         (rdx (tmp.175 r15 rdi rsi tmp.15 ra.436 rbp))
         (tmp.15 (tmp.16 tmp.175 ra.436 rbp tmp.179 tmp.437 rdx))
         (rsi (tmp.175 r15 rdi ra.436 rdx rbp))
         (rdi (r15 ra.436 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.437 (rbp ra.436 tmp.15 tmp.16))
         (tmp.16 (tmp.175 tmp.15 ra.436 rbp tmp.179 tmp.437))
         (tmp.179 (tmp.16 tmp.15 ra.436 rbp))
         (tmp.175 (tmp.16 tmp.15 rsi rdx ra.436 rbp))))
       (assignment ()))
      (begin
        (set! ra.436 r15)
        (set! tmp.175 rdi)
        (set! tmp.15 rsi)
        (set! tmp.16 rdx)
        (if (neq? tmp.175 6)
          (begin
            (set! tmp.437 (bitwise-and tmp.15 7))
            (set! tmp.179 tmp.437)
            (if (eq? tmp.179 0)
              (begin
                (set! rdx tmp.16)
                (set! rsi tmp.15)
                (set! rdi 14)
                (set! r15 ra.436)
                (jump L.jp.46 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.16)
                (set! rsi tmp.15)
                (set! rdi 6)
                (set! r15 ra.436)
                (jump L.jp.46 rbp r15 rdx rsi rdi))))
          (begin (set! rax 830) (jump ra.436 rbp rax)))))
    (define L.jp.46
      ((new-frames ())
       (locals (tmp.15 tmp.16 tmp.177 ra.438))
       (undead-out
        ((rdi rsi rdx ra.438 rbp)
         (rsi rdx tmp.177 ra.438 rbp)
         (rdx tmp.177 tmp.15 ra.438 rbp)
         (tmp.177 tmp.15 tmp.16 ra.438 rbp)
         ((tmp.15 tmp.16 ra.438 rbp)
          ((ra.438 rbp)
           ((ra.438 rax rbp) (rax rbp))
           ((ra.438 rax rbp) (rax rbp)))
          ((ra.438 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.438 rbp))
         (rbp (tmp.16 tmp.15 tmp.177 ra.438 rax))
         (ra.438 (tmp.16 tmp.15 tmp.177 rdi rsi rdx rbp rax))
         (rdx (tmp.15 tmp.177 ra.438))
         (rsi (tmp.177 ra.438))
         (rdi (ra.438))
         (tmp.177 (tmp.16 tmp.15 rsi rdx ra.438 rbp))
         (tmp.15 (tmp.16 rdx tmp.177 ra.438 rbp))
         (tmp.16 (tmp.177 tmp.15 ra.438 rbp))))
       (assignment ()))
      (begin
        (set! ra.438 r15)
        (set! tmp.177 rdi)
        (set! tmp.15 rsi)
        (set! tmp.16 rdx)
        (if (neq? tmp.177 6)
          (if (< tmp.15 tmp.16)
            (begin (set! rax 14) (jump ra.438 rbp rax))
            (begin (set! rax 6) (jump ra.438 rbp rax)))
          (begin (set! rax 830) (jump ra.438 rbp rax)))))
    (define L.jp.42
      ((new-frames ())
       (locals (tmp.14 tmp.13 ra.439 tmp.172 tmp.440 tmp.169))
       (undead-out
        ((rdi rsi rdx ra.439 rbp)
         (rsi rdx tmp.169 ra.439 rbp)
         (rdx tmp.169 tmp.13 ra.439 rbp)
         (tmp.169 tmp.14 tmp.13 ra.439 rbp)
         ((tmp.14 tmp.13 ra.439 rbp)
          ((tmp.440 tmp.14 tmp.13 ra.439 rbp)
           (tmp.172 tmp.14 tmp.13 ra.439 rbp)
           ((tmp.14 tmp.13 ra.439 rbp)
            ((tmp.13 ra.439 rdx rbp)
             (ra.439 rsi rdx rbp)
             (ra.439 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.13 ra.439 rdx rbp)
             (ra.439 rsi rdx rbp)
             (ra.439 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.439 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.439 rbp))
         (rbp
          (tmp.14 tmp.13 tmp.169 ra.439 tmp.172 tmp.440 r15 rdi rsi rdx rax))
         (ra.439 (tmp.14 tmp.13 tmp.169 rbp tmp.172 tmp.440 rdi rsi rdx rax))
         (rdx (tmp.169 r15 rdi rsi tmp.13 ra.439 rbp))
         (tmp.13 (tmp.14 tmp.169 ra.439 rbp tmp.172 tmp.440 rdx))
         (rsi (tmp.169 r15 rdi ra.439 rdx rbp))
         (rdi (r15 ra.439 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.440 (rbp ra.439 tmp.13 tmp.14))
         (tmp.14 (tmp.169 tmp.13 ra.439 rbp tmp.172 tmp.440))
         (tmp.172 (tmp.14 tmp.13 ra.439 rbp))
         (tmp.169 (tmp.14 tmp.13 rsi rdx ra.439 rbp))))
       (assignment ()))
      (begin
        (set! ra.439 r15)
        (set! tmp.169 rdi)
        (set! tmp.13 rsi)
        (set! tmp.14 rdx)
        (if (neq? tmp.169 6)
          (begin
            (set! tmp.440 (bitwise-and tmp.13 7))
            (set! tmp.172 tmp.440)
            (if (eq? tmp.172 0)
              (begin
                (set! rdx tmp.14)
                (set! rsi tmp.13)
                (set! rdi 14)
                (set! r15 ra.439)
                (jump L.jp.41 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.14)
                (set! rsi tmp.13)
                (set! rdi 6)
                (set! r15 ra.439)
                (jump L.jp.41 rbp r15 rdx rsi rdi))))
          (begin (set! rax 574) (jump ra.439 rbp rax)))))
    (define L.jp.41
      ((new-frames ())
       (locals (tmp.14 tmp.13 tmp.442 tmp.171 ra.441))
       (undead-out
        ((rdi rsi rdx ra.441 rbp)
         (rsi rdx tmp.171 ra.441 rbp)
         (rdx tmp.171 tmp.13 ra.441 rbp)
         (tmp.171 tmp.14 tmp.13 ra.441 rbp)
         ((tmp.14 tmp.13 ra.441 rbp)
          ((tmp.442 ra.441 rbp) (ra.441 rax rbp) (rax rbp))
          ((ra.441 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.441 rbp))
         (rbp (tmp.14 tmp.13 tmp.171 ra.441 tmp.442 rax))
         (ra.441 (tmp.14 tmp.13 tmp.171 rdi rsi rdx rbp tmp.442 rax))
         (tmp.442 (rbp ra.441))
         (rdx (tmp.13 tmp.171 ra.441))
         (rsi (tmp.171 ra.441))
         (rdi (ra.441))
         (tmp.171 (tmp.14 tmp.13 rsi rdx ra.441 rbp))
         (tmp.13 (tmp.14 rdx tmp.171 ra.441 rbp))
         (tmp.14 (tmp.171 tmp.13 ra.441 rbp))))
       (assignment ()))
      (begin
        (set! ra.441 r15)
        (set! tmp.171 rdi)
        (set! tmp.13 rsi)
        (set! tmp.14 rdx)
        (if (neq? tmp.171 6)
          (begin
            (set! tmp.442 (- tmp.13 tmp.14))
            (set! rax tmp.442)
            (jump ra.441 rbp rax))
          (begin (set! rax 574) (jump ra.441 rbp rax)))))
    (define L.jp.38
      ((new-frames ())
       (locals (tmp.12 tmp.11 ra.443 tmp.166 tmp.444 tmp.163))
       (undead-out
        ((rdi rsi rdx ra.443 rbp)
         (rsi rdx tmp.163 ra.443 rbp)
         (rdx tmp.163 tmp.11 ra.443 rbp)
         (tmp.163 tmp.12 tmp.11 ra.443 rbp)
         ((tmp.12 tmp.11 ra.443 rbp)
          ((tmp.444 tmp.12 tmp.11 ra.443 rbp)
           (tmp.166 tmp.12 tmp.11 ra.443 rbp)
           ((tmp.12 tmp.11 ra.443 rbp)
            ((tmp.11 ra.443 rdx rbp)
             (ra.443 rsi rdx rbp)
             (ra.443 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.11 ra.443 rdx rbp)
             (ra.443 rsi rdx rbp)
             (ra.443 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.443 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.443 rbp))
         (rbp
          (tmp.12 tmp.11 tmp.163 ra.443 tmp.166 tmp.444 r15 rdi rsi rdx rax))
         (ra.443 (tmp.12 tmp.11 tmp.163 rbp tmp.166 tmp.444 rdi rsi rdx rax))
         (rdx (tmp.163 r15 rdi rsi tmp.11 ra.443 rbp))
         (tmp.11 (tmp.12 tmp.163 ra.443 rbp tmp.166 tmp.444 rdx))
         (rsi (tmp.163 r15 rdi ra.443 rdx rbp))
         (rdi (r15 ra.443 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.444 (rbp ra.443 tmp.11 tmp.12))
         (tmp.12 (tmp.163 tmp.11 ra.443 rbp tmp.166 tmp.444))
         (tmp.166 (tmp.12 tmp.11 ra.443 rbp))
         (tmp.163 (tmp.12 tmp.11 rsi rdx ra.443 rbp))))
       (assignment ()))
      (begin
        (set! ra.443 r15)
        (set! tmp.163 rdi)
        (set! tmp.11 rsi)
        (set! tmp.12 rdx)
        (if (neq? tmp.163 6)
          (begin
            (set! tmp.444 (bitwise-and tmp.11 7))
            (set! tmp.166 tmp.444)
            (if (eq? tmp.166 0)
              (begin
                (set! rdx tmp.12)
                (set! rsi tmp.11)
                (set! rdi 14)
                (set! r15 ra.443)
                (jump L.jp.37 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.12)
                (set! rsi tmp.11)
                (set! rdi 6)
                (set! r15 ra.443)
                (jump L.jp.37 rbp r15 rdx rsi rdi))))
          (begin (set! rax 318) (jump ra.443 rbp rax)))))
    (define L.jp.37
      ((new-frames ())
       (locals (tmp.12 tmp.11 tmp.446 tmp.165 ra.445))
       (undead-out
        ((rdi rsi rdx ra.445 rbp)
         (rsi rdx tmp.165 ra.445 rbp)
         (rdx tmp.165 tmp.11 ra.445 rbp)
         (tmp.165 tmp.12 tmp.11 ra.445 rbp)
         ((tmp.12 tmp.11 ra.445 rbp)
          ((tmp.446 ra.445 rbp) (ra.445 rax rbp) (rax rbp))
          ((ra.445 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.445 rbp))
         (rbp (tmp.12 tmp.11 tmp.165 ra.445 tmp.446 rax))
         (ra.445 (tmp.12 tmp.11 tmp.165 rdi rsi rdx rbp tmp.446 rax))
         (tmp.446 (rbp ra.445))
         (rdx (tmp.11 tmp.165 ra.445))
         (rsi (tmp.165 ra.445))
         (rdi (ra.445))
         (tmp.165 (tmp.12 tmp.11 rsi rdx ra.445 rbp))
         (tmp.11 (tmp.12 rdx tmp.165 ra.445 rbp))
         (tmp.12 (tmp.165 tmp.11 ra.445 rbp))))
       (assignment ()))
      (begin
        (set! ra.445 r15)
        (set! tmp.165 rdi)
        (set! tmp.11 rsi)
        (set! tmp.12 rdx)
        (if (neq? tmp.165 6)
          (begin
            (set! tmp.446 (+ tmp.11 tmp.12))
            (set! rax tmp.446)
            (jump ra.445 rbp rax))
          (begin (set! rax 318) (jump ra.445 rbp rax)))))
    (define L.jp.34
      ((new-frames ())
       (locals (tmp.9 tmp.10 ra.447 tmp.160 tmp.448 tmp.156))
       (undead-out
        ((rdi rsi rdx ra.447 rbp)
         (rsi rdx tmp.156 ra.447 rbp)
         (rdx tmp.156 tmp.9 ra.447 rbp)
         (tmp.156 tmp.9 tmp.10 ra.447 rbp)
         ((tmp.9 tmp.10 ra.447 rbp)
          ((tmp.448 tmp.9 tmp.10 ra.447 rbp)
           (tmp.160 tmp.9 tmp.10 ra.447 rbp)
           ((tmp.9 tmp.10 ra.447 rbp)
            ((tmp.10 ra.447 rdx rbp)
             (ra.447 rsi rdx rbp)
             (ra.447 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.10 ra.447 rdx rbp)
             (ra.447 rsi rdx rbp)
             (ra.447 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.447 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.447 rbp))
         (rbp
          (tmp.10 tmp.9 tmp.156 ra.447 tmp.160 tmp.448 r15 rdi rsi rdx rax))
         (ra.447 (tmp.10 tmp.9 tmp.156 rbp tmp.160 tmp.448 rdi rsi rdx rax))
         (rdx (tmp.9 tmp.156 r15 rdi rsi tmp.10 ra.447 rbp))
         (tmp.10 (tmp.156 tmp.9 ra.447 rbp tmp.160 tmp.448 rdx))
         (rsi (tmp.156 r15 rdi ra.447 rdx rbp))
         (rdi (r15 ra.447 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.448 (rbp ra.447 tmp.10 tmp.9))
         (tmp.9 (tmp.10 rdx tmp.156 ra.447 rbp tmp.160 tmp.448))
         (tmp.160 (tmp.9 tmp.10 ra.447 rbp))
         (tmp.156 (tmp.10 tmp.9 rsi rdx ra.447 rbp))))
       (assignment ()))
      (begin
        (set! ra.447 r15)
        (set! tmp.156 rdi)
        (set! tmp.9 rsi)
        (set! tmp.10 rdx)
        (if (neq? tmp.156 6)
          (begin
            (set! tmp.448 (bitwise-and tmp.9 7))
            (set! tmp.160 tmp.448)
            (if (eq? tmp.160 0)
              (begin
                (set! rdx tmp.9)
                (set! rsi tmp.10)
                (set! rdi 14)
                (set! r15 ra.447)
                (jump L.jp.33 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.9)
                (set! rsi tmp.10)
                (set! rdi 6)
                (set! r15 ra.447)
                (jump L.jp.33 rbp r15 rdx rsi rdi))))
          (begin (set! rax 62) (jump ra.447 rbp rax)))))
    (define L.jp.33
      ((new-frames ())
       (locals (tmp.10 tmp.450 tmp.159 tmp.9 tmp.451 tmp.158 ra.449))
       (undead-out
        ((rdi rsi rdx ra.449 rbp)
         (rsi rdx tmp.158 ra.449 rbp)
         (rdx tmp.158 tmp.10 ra.449 rbp)
         (tmp.158 tmp.10 tmp.9 ra.449 rbp)
         ((tmp.10 tmp.9 ra.449 rbp)
          ((tmp.450 tmp.9 ra.449 rbp)
           (tmp.159 tmp.9 ra.449 rbp)
           (tmp.451 ra.449 rbp)
           (ra.449 rax rbp)
           (rax rbp))
          ((ra.449 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.449 rbp))
         (rbp (tmp.9 tmp.10 tmp.158 ra.449 tmp.451 tmp.159 tmp.450 rax))
         (ra.449
          (tmp.9 tmp.10 tmp.158 rdi rsi rdx rbp tmp.451 tmp.159 tmp.450 rax))
         (tmp.450 (rbp ra.449 tmp.9))
         (tmp.9 (tmp.158 tmp.10 ra.449 rbp tmp.159 tmp.450))
         (tmp.159 (tmp.9 ra.449 rbp))
         (tmp.451 (rbp ra.449))
         (rdx (tmp.10 tmp.158 ra.449))
         (rsi (tmp.158 ra.449))
         (rdi (ra.449))
         (tmp.158 (tmp.9 tmp.10 rsi rdx ra.449 rbp))
         (tmp.10 (tmp.9 rdx tmp.158 ra.449 rbp))))
       (assignment ()))
      (begin
        (set! ra.449 r15)
        (set! tmp.158 rdi)
        (set! tmp.10 rsi)
        (set! tmp.9 rdx)
        (if (neq? tmp.158 6)
          (begin
            (set! tmp.450 (arithmetic-shift-right tmp.10 3))
            (set! tmp.159 tmp.450)
            (set! tmp.451 (* tmp.9 tmp.159))
            (set! rax tmp.451)
            (jump ra.449 rbp rax))
          (begin (set! rax 62) (jump ra.449 rbp rax))))))
     ) #f))    

)