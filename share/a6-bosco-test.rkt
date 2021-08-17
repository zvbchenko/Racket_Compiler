#lang racket

(require
 "a6-bosco.rkt"
 "a7-bosco.rkt"
 "a7-compiler-lib.rkt"
 )

(module+ test 
  (require rackunit))

; Exercise 3
(module+ test
  (check-equal? (uncover-locals
                 '(module
                      (define L.main.1
                        ((new-frames ()))
                        (begin
                          (set! ra.1 r15)
                          (set! rsi 2)
                          (set! rdi 1)
                          (set! r15 ra.1)
                          (jump L.swap.1 rbp r15 rsi rdi)))
                    (define L.swap.1
                      ((new-frames ()))
                      (begin
                        (set! x.1 rdi)
                        (set! y.2 rsi)
                        (set! ra.2 r15)
                        (if (< y.2 x.1)
                            (begin (set! rax x.1) (jump ra.2 rbp rax))
                            (begin
                              (set! rsi x.1)
                              (set! rdi y.2)
                              (set! r15 ra.2)
                              (jump L.swap.1 rbp r15 rsi rdi))))))
                 )
                '(module
                     (define L.main.1
                       ((new-frames ()) (locals (ra.1)))
                       (begin
                         (set! ra.1 r15)
                         (set! rsi 2)
                         (set! rdi 1)
                         (set! r15 ra.1)
                         (jump L.swap.1 rbp r15 rsi rdi)))
                   (define L.swap.1
                     ((new-frames ()) (locals (ra.2 y.2 x.1)))
                     (begin
                       (set! x.1 rdi)
                       (set! y.2 rsi)
                       (set! ra.2 r15)
                       (if (< y.2 x.1)
                           (begin (set! rax x.1) (jump ra.2 rbp rax))
                           (begin
                             (set! rsi x.1)
                             (set! rdi y.2)
                             (set! r15 ra.2)
                             (jump L.swap.1 rbp r15 rsi rdi)))))))
  (check-equal? (uncover-locals
                 '(module
                      (define L.main.2
                        ((new-frames ()))
                        (begin
                          (set! ra.3 r15)
                          (set! fv1 2)
                          (set! fv0 1)
                          (set! r15 ra.3)
                          (jump L.swap.1 rbp r15 fv1 fv0)))
                    (define L.swap.1
                      ((new-frames ()))
                      (begin
                        (set! x.1 fv0)
                        (set! y.2 fv1)
                        (set! ra.4 r15)
                        (if (< y.2 x.1)
                            (begin (set! rax x.1) (jump ra.4 rbp rax))
                            (begin
                              (set! fv1 x.1)
                              (set! fv0 y.2)
                              (set! r15 ra.4)
                              (jump L.swap.1 rbp r15 fv1 fv0)))))))
                '(module
                     (define L.main.2
                       ((new-frames ()) (locals (ra.3)))
                       (begin
                         (set! ra.3 r15)
                         (set! fv1 2)
                         (set! fv0 1)
                         (set! r15 ra.3)
                         (jump L.swap.1 rbp r15 fv1 fv0)))
                   (define L.swap.1
                     ((new-frames ()) (locals (ra.4 y.2 x.1)))
                     (begin
                       (set! x.1 fv0)
                       (set! y.2 fv1)
                       (set! ra.4 r15)
                       (if (< y.2 x.1)
                           (begin (set! rax x.1) (jump ra.4 rbp rax))
                           (begin
                             (set! fv1 x.1)
                             (set! fv0 y.2)
                             (set! r15 ra.4)
                             (jump L.swap.1 rbp r15 fv1 fv0)))))))
  (check-equal? (uncover-locals
                 '(module
                      (define L.main.3
                        ((new-frames ()))
                        (begin
                          (set! ra.5 r15)
                          (set! rsi 2)
                          (set! rdi 1)
                          (set! r15 ra.5)
                          (jump L.swap.1 rbp r15 rsi rdi)))
                    (define L.swap.1
                      ((new-frames ()))
                      (begin
                        (set! x.1 rdi)
                        (set! y.2 rsi)
                        (set! ra.6 r15)
                        (if (< y.2 x.1)
                            (begin (set! rax x.1) (jump ra.6 rbp rax))
                            (begin
                              (return-point L.rp.4
                                            (begin
                                              (set! rsi x.1)
                                              (set! rdi y.2)
                                              (set! r15 L.rp.4)
                                              (jump L.swap.1 rbp r15 rsi rdi)))
                              (set! z.3 rax)
                              (set! rax z.3)
                              (jump ra.6 rbp rax)))))))
                '(module
                     (define L.main.3
                       ((new-frames ()) (locals (ra.5)))
                       (begin
                         (set! ra.5 r15)
                         (set! rsi 2)
                         (set! rdi 1)
                         (set! r15 ra.5)
                         (jump L.swap.1 rbp r15 rsi rdi)))
                   (define L.swap.1
                     ((new-frames ()) (locals (z.3 ra.6 y.2 x.1)))
                     (begin
                       (set! x.1 rdi)
                       (set! y.2 rsi)
                       (set! ra.6 r15)
                       (if (< y.2 x.1)
                           (begin (set! rax x.1) (jump ra.6 rbp rax))
                           (begin
                             (return-point L.rp.4
                                           (begin
                                             (set! rsi x.1)
                                             (set! rdi y.2)
                                             (set! r15 L.rp.4)
                                             (jump L.swap.1 rbp r15 rsi rdi)))
                             (set! z.3 rax)
                             (set! rax z.3)
                             (jump ra.6 rbp rax)))))))
  (check-equal?
   (uncover-locals
    '(module
         (define L.main.5
           ((new-frames ()))
           (begin
             (set! ra.7 r15)
             (set! fv1 2)
             (set! fv0 1)
             (set! r15 ra.7)
             (jump L.swap.1 rbp r15 fv1 fv0)))
       (define L.swap.1
         ((new-frames ((nfv.10 nfv.9))))
         (begin
           (set! x.1 fv0)
           (set! y.2 fv1)
           (set! ra.8 r15)
           (if (< y.2 x.1)
               (begin (set! rax x.1) (jump ra.8 rbp rax))
               (begin
                 (return-point L.rp.6
                               (begin
                                 (set! nfv.10 x.1)
                                 (set! nfv.9 y.2)
                                 (set! r15 L.rp.6)
                                 (jump L.swap.1 rbp r15 nfv.10 nfv.9)))
                 (set! z.3 rax)
                 (set! rax z.3)
                 (jump ra.8 rbp rax)))))))
   '(module
        (define L.main.5
          ((new-frames ()) (locals (ra.7)))
          (begin
            (set! ra.7 r15)
            (set! fv1 2)
            (set! fv0 1)
            (set! r15 ra.7)
            (jump L.swap.1 rbp r15 fv1 fv0)))
      (define L.swap.1
        ((new-frames ((nfv.10 nfv.9))) (locals (z.3 nfv.9 nfv.10 ra.8 y.2 x.1)))
        (begin
          (set! x.1 fv0)
          (set! y.2 fv1)
          (set! ra.8 r15)
          (if (< y.2 x.1)
              (begin (set! rax x.1) (jump ra.8 rbp rax))
              (begin
                (return-point L.rp.6
                              (begin
                                (set! nfv.10 x.1)
                                (set! nfv.9 y.2)
                                (set! r15 L.rp.6)
                                (jump L.swap.1 rbp r15 nfv.10 nfv.9)))
                (set! z.3 rax)
                (set! rax z.3)
                (jump ra.8 rbp rax)))))))
  (check-equal? (uncover-locals
                 '(module
                      (define L.main.1
                        ((new-frames ()))
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
                      ((new-frames ()))
                      (begin
                        (set! ra.2 r15)
                        (set! x.1 rdi)
                        (set! tmp.3 1)
                        (set! tmp.4 (+ x.1 tmp.3))
                        (set! rax tmp.4)
                        (jump ra.2 rbp rax)))
                    (define L.add.2
                      ((new-frames ()))
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
                        (locals (y.2 x.2 ra.1)))
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
                      (locals (tmp.4 tmp.3 x.1 ra.2)))
                     (begin
                       (set! ra.2 r15)
                       (set! x.1 rdi)
                       (set! tmp.3 1)
                       (set! tmp.4 (+ x.1 tmp.3))
                       (set! rax tmp.4)
                       (jump ra.2 rbp rax)))
                   (define L.add.2
                     ((new-frames ())
                      (locals (tmp.6 z.3 y.2 ra.5)))
                     (begin
                       (set! ra.5 r15)
                       (set! y.2 rdi)
                       (set! z.3 rsi)
                       (set! tmp.6 (+ y.2 z.3))
                       (set! rax tmp.6)
                       (jump ra.5 rbp rax)))))
  (check-equal? (uncover-locals
                 '(module
                      (define L.main.1
                        ((new-frames ()))
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
                      ((new-frames ()))
                      (begin
                        (set! ra.2 r15)
                        (set! x.1 rdi)
                        (set! tmp.3 1)
                        (set! tmp.4 (+ x.1 tmp.3))
                        (set! rax tmp.4)
                        (jump ra.2 rbp rax)))
                    (define L.add.2
                      ((new-frames ()))
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
                        (locals (y.2 x.2 ra.1)))
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
                      (locals (tmp.4 tmp.3 x.1 ra.2)))
                     (begin
                       (set! ra.2 r15)
                       (set! x.1 rdi)
                       (set! tmp.3 1)
                       (set! tmp.4 (+ x.1 tmp.3))
                       (set! rax tmp.4)
                       (jump ra.2 rbp rax)))
                   (define L.add.2
                     ((new-frames ())
                      (locals (b.2 a.1 tmp.7 tmp.6 z.3 y.2 ra.5)))
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
  )

; Exercise 4
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
        ( ,(list-no-order 'ra.7 'rbp)
         ,(list-no-order 'ra.7 'x.3.6 'rbp)
         ,(list-no-order 'ra.7 'x.3.6 'rsi 'rbp)
         ,(list-no-order 'ra.7 'x.3.6 'rdi 'rsi 'rbp)
         ,(list-no-order 'x.3.6 'rdi 'rsi 'r15 'rbp)
         ,(list-no-order 'rdi 'rsi 'r15 'rbp)))
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
        ( ,(list-no-order 'rdi 'rsi 'ra.8 'rbp)
         ,(list-no-order 'rsi 'x.1.4 'ra.8 'rbp)
         ,(list-no-order 'y.2.5 'x.1.4 'ra.8 'rbp)
         ,(list-no-order 'tmp.9 'ra.8 'rbp)
         ,(list-no-order 'ra.8 'rax 'rbp)
         ,(list-no-order 'rax 'rbp)))
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
                      (define L.main.1
                        ((new-frames ()) (locals (ra.1)))
                        (begin
                          (set! ra.1 r15)
                          (set! rsi 2)
                          (set! rdi 1)
                          (set! r15 ra.1)
                          (jump L.swap.1 rbp r15 rsi rdi)))
                    (define L.swap.1
                      ((new-frames ()) (locals (y.2 ra.2 x.1)))
                      (begin
                        (set! x.1 rdi)
                        (set! y.2 rsi)
                        (set! ra.2 r15)
                        (if (< y.2 x.1)
                            (begin (set! rax x.1) (jump ra.2 rbp rax))
                            (begin
                              (set! rsi x.1)
                              (set! rdi y.2)
                              (set! r15 ra.2)
                              (jump L.swap.1 rbp r15 rsi rdi))))))
                 )
                `(module
                     (define L.main.1
                       ((new-frames ())
                        (locals (ra.1))
                        (undead-out
                         (,(list-no-order 'ra.1 'rbp)
                          ,(list-no-order 'ra.1 'rsi 'rbp)
                          ,(list-no-order 'ra.1 'rdi 'rsi 'rbp)
                          ,(list-no-order 'rdi 'rsi 'r15 'rbp)
                          ,(list-no-order 'rdi 'rsi 'r15 'rbp)))
                        (call-undead ()))
                       (begin
                         (set! ra.1 r15)
                         (set! rsi 2)
                         (set! rdi 1)
                         (set! r15 ra.1)
                         (jump L.swap.1 rbp r15 rsi rdi)))
                   (define L.swap.1
                     ((new-frames ())
                      (locals (y.2 ra.2 x.1))
                      (undead-out
                       (,(list-no-order 'rsi  'r15 'x.1 'rbp)
                        ,(list-no-order 'r15 'y.2 'x.1 'rbp)
                        ,(list-no-order 'y.2 'x.1 'ra.2 'rbp)
                        (,(list-no-order 'y.2 'x.1 'ra.2 'rbp)
                         (,(list-no-order 'ra.2 'rax 'rbp) ,(list-no-order 'rax 'rbp))
                         (,(list-no-order 'y.2 'ra.2 'rsi 'rbp)
                          ,(list-no-order 'ra.2 'rdi 'rsi 'rbp)
                          ,(list-no-order 'rdi 'rsi 'r15 'rbp)
                          ,(list-no-order 'rdi 'rsi 'r15 'rbp)))))
                      (call-undead ()))
                     (begin
                       (set! x.1 rdi)
                       (set! y.2 rsi)
                       (set! ra.2 r15)
                       (if (< y.2 x.1)
                           (begin (set! rax x.1) (jump ra.2 rbp rax))
                           (begin
                             (set! rsi x.1)
                             (set! rdi y.2)
                             (set! r15 ra.2)
                             (jump L.swap.1 rbp r15 rsi rdi)))))))
  
  (check-match (undead-analysis
                 '(module
                      (define L.main.2
                        ((new-frames ()) (locals (ra.3)))
                        (begin
                          (set! ra.3 r15)
                          (set! fv1 2)
                          (set! fv0 1)
                          (set! r15 ra.3)
                          (jump L.swap.1 rbp r15 fv1 fv0)))
                    (define L.swap.1
                      ((new-frames ()) (locals (y.2 ra.4 x.1)))
                      (begin
                        (set! x.1 fv0)
                        (set! y.2 fv1)
                        (set! ra.4 r15)
                        (if (< y.2 x.1)
                            (begin (set! rax x.1) (jump ra.4 rbp rax))
                            (begin
                              (set! fv1 x.1)
                              (set! fv0 y.2)
                              (set! r15 ra.4)
                              (jump L.swap.1 rbp r15 fv1 fv0)))))))
                `(module
                     (define L.main.2
                       ((new-frames ())
                        (locals (ra.3))
                        (undead-out
                         (,(list-no-order 'ra.3 'rbp)
                          ,(list-no-order 'ra.3 'fv1 'rbp)
                          ,(list-no-order 'ra.3 'fv0 'fv1 'rbp)
                          ,(list-no-order 'fv0 'fv1 'r15 'rbp)
                          ,(list-no-order 'fv0 'fv1 'r15 'rbp)))
                        (call-undead ()))
                       (begin
                         (set! ra.3 r15)
                         (set! fv1 2)
                         (set! fv0 1)
                         (set! r15 ra.3)
                         (jump L.swap.1 rbp r15 fv1 fv0)))
                   (define L.swap.1
                     ((new-frames ())
                      (locals (y.2 ra.4 x.1))
                      (undead-out
                       (,(list-no-order 'fv1 'r15 'x.1 'rbp)
                        ,(list-no-order 'r15 'y.2 'x.1 'rbp)
                        ,(list-no-order 'y.2 'x.1 'ra.4 'rbp)
                        (,(list-no-order 'y.2 'x.1 'ra.4 'rbp)
                          ((rax rbp ra.4) (rbp rax))
                         (,(list-no-order 'y.2 'ra.4 'fv1 'rbp)
                          ,(list-no-order 'ra.4 'fv0 'fv1 'rbp)
                          ,(list-no-order 'fv0 'fv1 'r15 'rbp)
                          ,(list-no-order 'fv0 'fv1 'r15 'rbp)))))
                      (call-undead ()))
                     (begin
                       (set! x.1 fv0)
                       (set! y.2 fv1)
                       (set! ra.4 r15)
                       (if (< y.2 x.1)
                           (begin (set! rax x.1) (jump ra.4 rbp rax))
                           (begin
                             (set! fv1 x.1)
                             (set! fv0 y.2)
                             (set! r15 ra.4)
                             (jump L.swap.1 rbp r15 fv1 fv0)))))))
  (check-match
      (undead-analysis
                  '(module
                    (define L.swap.1
                      ((new-frames ((nfv.4 nfv.3))))
                      (begin
                        (set! x.1 fv0)
                        (set! y.2 fv1)
                        (set! ra.2 r15)
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
                              `(module
                                (define L.swap.1
                                  ((new-frames ((nfv.4 nfv.3)))
                                  (undead-out
                                    (,(list-no-order 'fv1 'r15 'x.1 'rbp)
                                    ,(list-no-order 'r15 'y.2 'x.1 'rbp)
                                    ,(list-no-order 'y.2 'x.1 'ra.2 'rbp)
                                    (,(list-no-order 'y.2 'x.1 'ra.2 'rbp)
                                      (,(list-no-order 'ra.2 'rax 'rbp) ,(list-no-order 'rax 'rbp))
                                      ((,(list-no-order 'rax 'ra.2 'rbp)
                                        (,(list-no-order 'y.2 'nfv.4 'rbp)
                                        ,(list-no-order 'nfv.3 'nfv.4 'rbp)
                                        ,(list-no-order 'nfv.3 'nfv.4 'r15 'rbp)
                                        ,(list-no-order 'nfv.3 'nfv.4 'r15 'rbp)))
                                      ,(list-no-order 'z.3 'ra.2 'rbp)
                                      ,(list-no-order 'ra.2 'rax 'rbp)
                                      ,(list-no-order 'rax 'rbp)))))
                                  (call-undead (ra.2)))
                                  (begin
                                    (set! x.1 fv0)
                                    (set! y.2 fv1)
                                    (set! ra.2 r15)
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


  #;(check-equal? (undead-analysis
                 '(module
                      (define L.main.1
                        ((new-frames ()) (locals (ra.1)))
                        (begin
                          (set! ra.1 r15)
                          (set! rsi 2)
                          (set! rdi 1)
                          (set! r15 ra.1)
                          (jump L.swap.1 rbp r15 rsi rdi)))
                    (define L.swap.1
                      ((new-frames ()) (locals (ra.2 y.2 z.3 x.1)))
                      (begin
                        (set! ra.2 r15)
                        (set! x.1 rdi)
                        (set! y.2 rsi)
                        (if (< y.2 x.1)
                            (begin (set! rax x.1) (jump ra.2 rbp rax))
                            (begin
                              (return-point L.rp.2
                                            (begin
                                              (set! rsi x.1)
                                              (set! rdi y.2)
                                              (set! r15 L.rp.2)
                                              (jump L.swap.1 rbp r15 rsi rdi)))
                              (set! z.3 rax)
                              (set! rax z.3)
                              (jump ra.2 rbp rax)))))))
                '(module
                     (define L.main.1
                       ((new-frames ())
                        (locals (ra.1))
                        (undead-out
                         ((ra.1 rbp)
                          (ra.1 rsi rbp)
                          (ra.1 rdi rsi rbp)
                          (rdi rsi r15 rbp)
                          (rdi rsi r15 rbp)))
                        (call-undead ()))
                       (begin
                         (set! ra.1 r15)
                         (set! rsi 2)
                         (set! rdi 1)
                         (set! r15 ra.1)
                         (jump L.swap.1 rbp r15 rsi rdi)))
                   (define L.swap.1
                     ((new-frames ())
                      (locals (ra.2 y.2 z.3 x.1))
                      (undead-out
                       ((rdi rsi ra.2 rbp)
                        (rsi x.1 ra.2 rbp)
                        (y.2 x.1 ra.2 rbp)
                        ((y.2 x.1 ra.2 rbp)
                         ((ra.2 rax rbp) (rax rbp))
                         (((rax ra.2 rbp)
                           ((y.2 rsi rbp) (rdi rsi rbp) (rdi rsi r15 rbp) (rdi rsi r15 rbp)))
                          (z.3 ra.2 rbp)
                          (ra.2 rax rbp)
                          (rax rbp)))))
                      (call-undead (ra.2)))
                     (begin
                       (set! ra.2 r15)
                       (set! x.1 rdi)
                       (set! y.2 rsi)
                       (if (< y.2 x.1)
                           (begin (set! rax x.1) (jump ra.2 rbp rax))
                           (begin
                             (return-point L.rp.2
                                           (begin
                                             (set! rsi x.1)
                                             (set! rdi y.2)
                                             (set! r15 L.rp.2)
                                             (jump L.swap.1 rbp r15 rsi rdi)))
                             (set! z.3 rax)
                             (set! rax z.3)
                             (jump ra.2 rbp rax)))))))
  #;(check-equal? (undead-analysis
                '(module
                    (define L.main.1
                      ((new-frames ()) (locals (ra.1)))
                      (begin
                        (set! ra.1 r15)
                        (set! fv1 2)
                        (set! fv0 1)
                        (set! r15 ra.1)
                        (jump L.swap.1 rbp r15 fv1 fv0)))
                  (define L.swap.1
                    ((new-frames ((nfv.4 nfv.3))) (locals (ra.2 y.2 nfv.3 nfv.4 z.3 x.1)))
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
                      (call-undead ()))
                      (begin
                        (set! ra.1 r15)
                        (set! fv1 2)
                        (set! fv0 1)
                        (set! r15 ra.1)
                        (jump L.swap.1 rbp r15 fv1 fv0)))
                  (define L.swap.1
                    ((new-frames ((nfv.4 nfv.3)))
                    (locals (ra.2 y.2 nfv.3 nfv.4 z.3 x.1))
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
                    (call-undead (ra.2)))
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
  #;(check-equal? (undead-analysis
                 '(module
                      (define L.main.5
                        ((new-frames ()) (locals (ra.12)))
                        (begin
                          (set! ra.12 r15)
                          (set! fv0 5)
                          (set! r15 ra.12)
                          (jump L.fact.4 rbp r15 fv0)))
                    (define L.fact.4
                      ((new-frames (nfv.16))
                       (locals (ra.13 x.9 tmp.14 tmp.15 new-n.10 nfv.16 factn-1.11 tmp.17)))
                      (begin
                        (set! x.9 fv0)
                        (set! ra.13 r15)
                        (if (= x.9 0)
                            (begin (set! rax 1) (jump ra.13 rbp rax))
                            (begin
                              (set! tmp.14 -1)
                              (set! tmp.15 (+ x.9 tmp.14))
                              (set! new-n.10 tmp.15)
                              (return-point
                               L.rp.6
                               (begin
                                 (set! nfv.16 new-n.10)
                                 (set! r15 L.rp.6)
                                 (jump L.fact.4 rbp r15 nfv.16)))
                              (set! factn-1.11 rax)
                              (set! tmp.17 (* x.9 factn-1.11))
                              (set! rax tmp.17)
                              (jump ra.13 rbp rax)))))))
                '(module
                     (define L.main.5
                       ((new-frames ())
                        (locals (ra.12))
                        (undead-out ((ra.12 rbp) (ra.12 fv0 rbp) (fv0 r15 rbp) (fv0 r15 rbp)))
                        (call-undead ()))
                       (begin
                         (set! ra.12 r15)
                         (set! fv0 5)
                         (set! r15 ra.12)
                         (jump L.fact.4 rbp r15 fv0)))
                   (define L.fact.4
                     ((new-frames (nfv.16))
                      (locals (ra.13 x.9 tmp.14 tmp.15 new-n.10 nfv.16 factn-1.11 tmp.17))
                      (undead-out
                       ((r15 x.9 rbp)
                        (x.9 ra.13 rbp)
                        ((rax rbp)
                         ((ra.13 rax rbp) (rax rbp))
                         ((tmp.14 x.9 ra.13 rbp)
                          (tmp.15 x.9 ra.13 rbp)
                          (new-n.10 x.9 ra.13 rbp)
                          ((rax x.9 ra.13 rbp) ((nfv.16 rbp) (nfv.16 r15 rbp) (nfv.16 r15 rbp)))
                          (factn-1.11 x.9 ra.13 rbp)
                          (tmp.17 ra.13 rbp)
                          (ra.13 rax rbp)
                          (rax rbp)))))
                      (call-undead (x.9 ra.13)))
                     (begin
                       (set! x.9 fv0)
                       (set! ra.13 r15)
                       (if (= x.9 0)
                           (begin (set! rax 1) (jump ra.13 rbp rax))
                           (begin
                             (set! tmp.14 -1)
                             (set! tmp.15 (+ x.9 tmp.14))
                             (set! new-n.10 tmp.15)
                             (return-point L.rp.6
                                           (begin
                                             (set! nfv.16 new-n.10)
                                             (set! r15 L.rp.6)
                                             (jump L.fact.4 rbp r15 nfv.16)))
                             (set! factn-1.11 rax)
                             (set! tmp.17 (* x.9 factn-1.11))
                             (set! rax tmp.17)
                             (jump ra.13 rbp rax)))))))
  #;(check-equal? (undead-analysis
                 '(module
                      (define L.main.1
                        ((new-frames ())
                         (locals (y.2 x.2 ra.1)))
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
                       (locals (tmp.4 tmp.3 x.1 ra.2)))
                      (begin
                        (set! ra.2 r15)
                        (set! x.1 rdi)
                        (set! tmp.3 1)
                        (set! tmp.4 (+ x.1 tmp.3))
                        (set! rax tmp.4)
                        (jump ra.2 rbp rax)))
                    (define L.add.2
                      ((new-frames ())
                       (locals (tmp.6 z.3 y.2 ra.5)))
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
                        (locals (y.2 x.2 ra.1))
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
                        (call-undead (x.2 ra.1)))
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
                      (locals (tmp.4 tmp.3 x.1 ra.2))
                      (undead-out
                       ((rdi ra.2 rbp)
                        (x.1 ra.2 rbp)
                        (tmp.3 x.1 ra.2 rbp)
                        (tmp.4 ra.2 rbp)
                        (ra.2 rax rbp)
                        (rax rbp)))
                      (call-undead ()))
                     (begin
                       (set! ra.2 r15)
                       (set! x.1 rdi)
                       (set! tmp.3 1)
                       (set! tmp.4 (+ x.1 tmp.3))
                       (set! rax tmp.4)
                       (jump ra.2 rbp rax)))
                   (define L.add.2
                     ((new-frames ())
                      (locals (tmp.6 z.3 y.2 ra.5))
                      (undead-out
                       ((rdi rsi ra.5 rbp)
                        (rsi y.2 ra.5 rbp)
                        (z.3 y.2 ra.5 rbp)
                        (tmp.6 ra.5 rbp)
                        (ra.5 rax rbp)
                        (rax rbp)))
                      (call-undead ()))
                     (begin
                       (set! ra.5 r15)
                       (set! y.2 rdi)
                       (set! z.3 rsi)
                       (set! tmp.6 (+ y.2 z.3))
                       (set! rax tmp.6)
                       (jump ra.5 rbp rax)))))
  #;(check-equal? (undead-analysis
                 '(module
                      (define L.main.1
                        ((new-frames ())
                         (locals (y.2 x.2 ra.1)))
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
                       (locals (tmp.4 tmp.3 x.1 ra.2)))
                      (begin
                        (set! ra.2 r15)
                        (set! x.1 rdi)
                        (set! tmp.3 1)
                        (set! tmp.4 (+ x.1 tmp.3))
                        (set! rax tmp.4)
                        (jump ra.2 rbp rax)))
                    (define L.add.2
                      ((new-frames ())
                       (locals (z.3 tmp.6 tmp.7 a.1 b.2 ra.5 y.2)))
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
                        (locals (y.2 x.2 ra.1))
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
                        (call-undead (x.2 ra.1)))
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
                      (locals (tmp.4 tmp.3 x.1 ra.2))
                      (undead-out
                       ((rdi ra.2 rbp)
                        (x.1 ra.2 rbp)
                        (tmp.3 x.1 ra.2 rbp)
                        (tmp.4 ra.2 rbp)
                        (ra.2 rax rbp)
                        (rax rbp)))
                      (call-undead ()))
                     (begin
                       (set! ra.2 r15)
                       (set! x.1 rdi)
                       (set! tmp.3 1)
                       (set! tmp.4 (+ x.1 tmp.3))
                       (set! rax tmp.4)
                       (jump ra.2 rbp rax)))
                   (define L.add.2
                     ((new-frames ())
                      (locals (z.3 tmp.6 tmp.7 a.1 b.2 ra.5 y.2))
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
                      (call-undead (a.1 ra.5)))
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
  )

; Exercise 5
(module+ test
  (check-equal? (conflict-analysis
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
                         (call-undead ()))
                        (begin
                          (set! ra.1 r15)
                          (set! fv1 2)
                          (set! fv0 1)
                          (set! r15 ra.1)
                          (jump L.swap.1 rbp r15 fv1 fv0)))
                    (define L.swap.1
                      ((new-frames ((nfv.4 nfv.3)))
                       (locals (ra.2 y.2 nfv.3 nfv.4 z.3 x.1))
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
                       (call-undead (ra.2)))
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
                         ((r15 (rbp fv1 fv0))
                          (fv0 (r15 rbp fv1 ra.1))
                          (fv1 (r15 fv0 rbp ra.1))
                          (ra.1 (fv0 fv1 rbp)))))
                       (begin
                         (set! ra.1 r15)
                         (set! fv1 2)
                         (set! fv0 1)
                         (set! r15 ra.1)
                         (jump L.swap.1 rbp r15 fv1 fv0)))
                   (define L.swap.1
                     ((new-frames ((nfv.4 nfv.3)))
                      (locals (ra.2 y.2 nfv.3 nfv.4 z.3 x.1))
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
                       ((z.3 (rbp ra.2))
                        (r15 (rbp nfv.4 nfv.3))
                        (nfv.3 (r15 rbp nfv.4))
                        (nfv.4 (r15 nfv.3 rbp y.2))
                        (rax (rbp ra.2))
                        (y.2 (nfv.4 rbp ra.2 x.1))
                        (x.1 (y.2 rbp ra.2 fv1))
                        (ra.2 (z.3 rax y.2 x.1 rbp fv1 fv0)))))
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
  (check-equal? (conflict-analysis
                 '(module
                      (define L.main.1
                        ((new-frames ())
                         (locals (y.2 x.2 ra.1))
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
                         (call-undead (x.2 ra.1)))
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
                       (locals (tmp.4 tmp.3 x.1 ra.2))
                       (undead-out
                        ((rdi ra.2 rbp)
                         (x.1 ra.2 rbp)
                         (tmp.3 x.1 ra.2 rbp)
                         (tmp.4 ra.2 rbp)
                         (ra.2 rax rbp)
                         (rax rbp)))
                       (call-undead ()))
                      (begin
                        (set! ra.2 r15)
                        (set! x.1 rdi)
                        (set! tmp.3 1)
                        (set! tmp.4 (+ x.1 tmp.3))
                        (set! rax tmp.4)
                        (jump ra.2 rbp rax)))
                    (define L.add.2
                      ((new-frames ())
                       (locals (tmp.6 z.3 y.2 ra.5))
                       (undead-out
                        ((rdi rsi ra.5 rbp)
                         (rsi y.2 ra.5 rbp)
                         (z.3 y.2 ra.5 rbp)
                         (tmp.6 ra.5 rbp)
                         (ra.5 rax rbp)
                         (rax rbp)))
                       (call-undead ()))
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
                        (locals (y.2 x.2 ra.1))
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
                         ((rsi (r15 rdi rbp ra.1 x.2))
                          (y.2 (rbp ra.1 x.2))
                          (x.2 (rsi y.2 rbp ra.1))
                          (r15 (rsi rbp rdi))
                          (rdi (rsi ra.1 r15 rbp))
                          (ra.1 (rdi rsi y.2 x.2 rbp)))))
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
                      (locals (tmp.4 tmp.3 x.1 ra.2))
                      (undead-out
                       ((rdi ra.2 rbp)
                        (x.1 ra.2 rbp)
                        (tmp.3 x.1 ra.2 rbp)
                        (tmp.4 ra.2 rbp)
                        (ra.2 rax rbp)
                        (rax rbp)))
                      (call-undead ())
                      (conflicts
                       ((rax (rbp ra.2))
                        (tmp.4 (rbp ra.2))
                        (tmp.3 (rbp ra.2 x.1))
                        (x.1 (tmp.3 rbp ra.2))
                        (ra.2 (rax tmp.4 tmp.3 x.1 rbp rdi)))))
                     (begin
                       (set! ra.2 r15)
                       (set! x.1 rdi)
                       (set! tmp.3 1)
                       (set! tmp.4 (+ x.1 tmp.3))
                       (set! rax tmp.4)
                       (jump ra.2 rbp rax)))
                   (define L.add.2
                     ((new-frames ())
                      (locals (tmp.6 z.3 y.2 ra.5))
                      (undead-out
                       ((rdi rsi ra.5 rbp)
                        (rsi y.2 ra.5 rbp)
                        (z.3 y.2 ra.5 rbp)
                        (tmp.6 ra.5 rbp)
                        (ra.5 rax rbp)
                        (rax rbp)))
                      (call-undead ())
                      (conflicts
                       ((rax (rbp ra.5))
                        (tmp.6 (rbp ra.5))
                        (z.3 (rbp ra.5 y.2))
                        (y.2 (z.3 rbp ra.5 rsi))
                        (ra.5 (rax tmp.6 z.3 y.2 rbp rsi rdi)))))
                     (begin
                       (set! ra.5 r15)
                       (set! y.2 rdi)
                       (set! z.3 rsi)
                       (set! tmp.6 (+ y.2 z.3))
                       (set! rax tmp.6)
                       (jump ra.5 rbp rax)))))
  )

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

; Exercise 7
(module+ test
  (check-equal? (assign-frames
                 '(module
                      (define L.main.1
                        ((new-frames ())
                         (locals (ra.1))
                         (undead-out
                          ((ra.1 rbp)
                           (ra.1 fv1 rbp)
                           (ra.1 fv1 fv0 rbp)
                           (fv1 fv0 r15 rbp)
                           (fv1 fv0 r15 rbp)))
                         (call-undead ())
                         (conflicts
                          ((ra.1 (fv0 fv1 rbp))
                           (rbp (r15 fv0 fv1 ra.1))
                           (fv1 (r15 fv0 ra.1 rbp))
                           (fv0 (r15 ra.1 fv1 rbp))
                           (r15 (fv1 fv0 rbp))))
                         (assignment ()))
                        (begin
                          (set! ra.1 r15)
                          (set! fv1 2)
                          (set! fv0 1)
                          (set! r15 ra.1)
                          (jump L.swap.1 rbp r15 fv0 fv1)))
                    (define L.swap.1
                      ((new-frames ((nfv.3 nfv.4)))
                       (locals (x.1 z.3 nfv.3 nfv.4 y.2))
                       (undead-out
                        ((fv0 fv1 ra.2 rbp)
                         (fv1 x.1 ra.2 rbp)
                         (y.2 x.1 ra.2 rbp)
                         ((y.2 x.1 ra.2 rbp)
                          ((ra.2 rax rbp) (rax rbp))
                          (((rax ra.2 rbp)
                            ((y.2 nfv.4 rbp)
                             (nfv.4 nfv.3 rbp)
                             (nfv.4 nfv.3 r15 rbp)
                             (nfv.4 nfv.3 r15 rbp)))
                           (z.3 ra.2 rbp)
                           (ra.2 rax rbp)
                           (rax rbp)))))
                       (call-undead (ra.2))
                       (conflicts
                        ((rax (rbp ra.2))
                         (ra.2 (y.2 x.1 fv0 fv1 rbp z.3 rax))
                         (rbp (y.2 x.1 ra.2 z.3 r15 nfv.3 nfv.4 rax))
                         (nfv.4 (r15 nfv.3 y.2 rbp))
                         (y.2 (x.1 ra.2 rbp nfv.4))
                         (nfv.3 (r15 nfv.4 rbp))
                         (r15 (nfv.4 nfv.3 rbp))
                         (z.3 (ra.2 rbp))
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
                                              (jump L.swap.1 rbp r15 nfv.3 nfv.4)))
                              (set! z.3 rax)
                              (set! rax z.3)
                              (jump ra.2 rbp rax)))))))
                '(module
                     (define L.main.1
                       ((locals (ra.1))
                        (undead-out
                         ((ra.1 rbp)
                          (ra.1 fv1 rbp)
                          (ra.1 fv1 fv0 rbp)
                          (fv1 fv0 r15 rbp)
                          (fv1 fv0 r15 rbp)))
                        (conflicts
                         ((ra.1 (fv0 fv1 rbp))
                          (rbp (r15 fv0 fv1 ra.1))
                          (fv1 (r15 fv0 ra.1 rbp))
                          (fv0 (r15 ra.1 fv1 rbp))
                          (r15 (fv1 fv0 rbp))))
                        (assignment ()))
                       (begin
                         (set! ra.1 r15)
                         (set! fv1 2)
                         (set! fv0 1)
                         (set! r15 ra.1)
                         (jump L.swap.1 rbp r15 fv0 fv1)))
                   (define L.swap.1
                     ((locals (x.1 z.3 y.2))
                      (undead-out
                       ((fv0 fv1 ra.2 rbp)
                        (fv1 x.1 ra.2 rbp)
                        (y.2 x.1 ra.2 rbp)
                        ((y.2 x.1 ra.2 rbp)
                         ((ra.2 rax rbp) (rax rbp))
                         (((rax ra.2 rbp)
                           ((y.2 nfv.4 rbp)
                            (nfv.4 nfv.3 rbp)
                            (nfv.4 nfv.3 r15 rbp)
                            (nfv.4 nfv.3 r15 rbp)))
                          (z.3 ra.2 rbp)
                          (ra.2 rax rbp)
                          (rax rbp)))))
                      (conflicts
                       ((rax (rbp ra.2))
                        (ra.2 (y.2 x.1 fv0 fv1 rbp z.3 rax))
                        (rbp (y.2 x.1 ra.2 z.3 r15 nfv.3 nfv.4 rax))
                        (nfv.4 (r15 nfv.3 y.2 rbp))
                        (y.2 (x.1 ra.2 rbp nfv.4))
                        (nfv.3 (r15 nfv.4 rbp))
                        (r15 (nfv.4 nfv.3 rbp))
                        (z.3 (ra.2 rbp))
                        (fv1 (x.1 ra.2))
                        (fv0 (ra.2))
                        (x.1 (y.2 fv1 ra.2 rbp))))
                      (assignment ((ra.2 fv2) (nfv.3 fv3) (nfv.4 fv4))))
                     (begin
                       (set! ra.2 r15)
                       (set! x.1 fv0)
                       (set! y.2 fv1)
                       (if (< y.2 x.1)
                           (begin (set! rax x.1) (jump ra.2 rbp rax))
                           (begin
                             (set! rbp (+ rbp 24))
                             (return-point L.rp.2
                                           (begin
                                             (set! nfv.4 x.1)
                                             (set! nfv.3 y.2)
                                             (set! r15 L.rp.2)
                                             (jump L.swap.1 rbp r15 nfv.3 nfv.4)))
                             (set! rbp (- rbp 24))
                             (set! z.3 rax)
                             (set! rax z.3)
                             (jump ra.2 rbp rax)))))))
  (check-equal? (assign-frames
                 '(module
                      (define L.main.1
                        ((new-frames ((nfv.2) (nfv.3)))
                         (locals (nfv.2 nfv.3 y.2))
                         (undead-out
                          ((ra.1 rbp)
                           ((rax ra.1 rbp) ((nfv.2 rbp) (nfv.2 r15 rbp) (nfv.2 r15 rbp)))
                           (x.2 ra.1 rbp)
                           ((rax x.2 ra.1 rbp) ((nfv.3 rbp) (nfv.3 r15 rbp) (nfv.3 r15 rbp)))
                           (y.2 x.2 ra.1 rbp)
                           (x.2 ra.1 fv1 rbp)
                           (ra.1 fv1 fv0 rbp)
                           (fv1 fv0 r15 rbp)
                           (fv1 fv0 r15 rbp)))
                         (call-undead (x.2 ra.1))
                         (conflicts
                          ((ra.1 (fv0 fv1 y.2 x.2 rax rbp))
                           (rbp (fv0 fv1 y.2 nfv.3 x.2 r15 nfv.2 rax ra.1))
                           (rax (x.2 rbp ra.1))
                           (nfv.2 (r15 rbp))
                           (r15 (fv1 fv0 nfv.3 nfv.2 rbp))
                           (x.2 (fv1 y.2 rax ra.1 rbp))
                           (nfv.3 (r15 rbp))
                           (y.2 (x.2 ra.1 rbp))
                           (fv1 (r15 fv0 x.2 ra.1 rbp))
                           (fv0 (r15 ra.1 fv1 rbp))))
                         (assignment ((ra.1 fv2) (x.2 fv0))))
                        (begin
                          (set! ra.1 r15)
                          (return-point L.rp.2
                                        (begin
                                          (set! nfv.2 2)
                                          (set! r15 L.rp.2)
                                          (jump L.increment.1 rbp r15 nfv.2)))
                          (set! x.2 rax)
                          (return-point L.rp.3
                                        (begin
                                          (set! nfv.3 3)
                                          (set! r15 L.rp.3)
                                          (jump L.increment.1 rbp r15 nfv.3)))
                          (set! y.2 rax)
                          (set! fv1 y.2)
                          (set! fv0 x.2)
                          (set! r15 ra.1)
                          (jump L.add.2 rbp r15 fv0 fv1)))
                    (define L.increment.1
                      ((new-frames ())
                       (locals (ra.4 x.1 tmp.5 tmp.6))
                       (undead-out
                        ((fv0 ra.4 rbp)
                         (x.1 ra.4 rbp)
                         (tmp.5 x.1 ra.4 rbp)
                         (tmp.6 ra.4 rbp)
                         (ra.4 rax rbp)
                         (rax rbp)))
                       (call-undead ())
                       (conflicts
                        ((ra.4 (rax tmp.6 tmp.5 x.1 fv0 rbp))
                         (rbp (rax tmp.6 tmp.5 x.1 ra.4))
                         (fv0 (ra.4))
                         (x.1 (tmp.5 ra.4 rbp))
                         (tmp.5 (x.1 ra.4 rbp))
                         (tmp.6 (rbp ra.4))
                         (rax (ra.4 rbp))))
                       (assignment ()))
                      (begin
                        (set! ra.4 r15)
                        (set! x.1 fv0)
                        (set! tmp.5 1)
                        (set! tmp.6 (+ x.1 tmp.5))
                        (set! rax tmp.6)
                        (jump ra.4 rbp rax)))
                    (define L.add.2
                      ((new-frames ())
                       (locals (ra.7 y.2 z.3 tmp.8))
                       (undead-out
                        ((fv0 fv1 ra.7 rbp)
                         (fv1 y.2 ra.7 rbp)
                         (z.3 y.2 ra.7 rbp)
                         (tmp.8 ra.7 rbp)
                         (ra.7 rax rbp)
                         (rax rbp)))
                       (call-undead ())
                       (conflicts
                        ((ra.7 (rax tmp.8 z.3 y.2 fv0 fv1 rbp))
                         (rbp (rax tmp.8 z.3 y.2 ra.7))
                         (fv1 (y.2 ra.7))
                         (fv0 (ra.7))
                         (y.2 (z.3 fv1 ra.7 rbp))
                         (z.3 (y.2 ra.7 rbp))
                         (tmp.8 (rbp ra.7))
                         (rax (ra.7 rbp))))
                       (assignment ()))
                      (begin
                        (set! ra.7 r15)
                        (set! y.2 fv0)
                        (set! z.3 fv1)
                        (set! tmp.8 (+ y.2 z.3))
                        (set! rax tmp.8)
                        (jump ra.7 rbp rax)))))
                '(module
                     (define L.main.1
                       ((locals (y.2))
                        (undead-out
                         ((ra.1 rbp)
                          ((rax ra.1 rbp) ((nfv.2 rbp) (nfv.2 r15 rbp) (nfv.2 r15 rbp)))
                          (x.2 ra.1 rbp)
                          ((rax x.2 ra.1 rbp) ((nfv.3 rbp) (nfv.3 r15 rbp) (nfv.3 r15 rbp)))
                          (y.2 x.2 ra.1 rbp)
                          (x.2 ra.1 fv1 rbp)
                          (ra.1 fv1 fv0 rbp)
                          (fv1 fv0 r15 rbp)
                          (fv1 fv0 r15 rbp)))
                        (conflicts
                         ((ra.1 (fv0 fv1 y.2 x.2 rax rbp))
                          (rbp (fv0 fv1 y.2 nfv.3 x.2 r15 nfv.2 rax ra.1))
                          (rax (x.2 rbp ra.1))
                          (nfv.2 (r15 rbp))
                          (r15 (fv1 fv0 nfv.3 nfv.2 rbp))
                          (x.2 (fv1 y.2 rax ra.1 rbp))
                          (nfv.3 (r15 rbp))
                          (y.2 (x.2 ra.1 rbp))
                          (fv1 (r15 fv0 x.2 ra.1 rbp))
                          (fv0 (r15 ra.1 fv1 rbp))))
                        (assignment ((ra.1 fv2) (x.2 fv0) (nfv.2 fv3) (nfv.3 fv3))))
                       (begin
                         (set! ra.1 r15)
                         (set! rbp (+ rbp 24))
                         (return-point L.rp.2
                                       (begin
                                         (set! nfv.2 2)
                                         (set! r15 L.rp.2)
                                         (jump L.increment.1 rbp r15 nfv.2)))
                         (set! rbp (- rbp 24))
                         (set! x.2 rax)
                         (set! rbp (+ rbp 24))
                         (return-point L.rp.3
                                       (begin
                                         (set! nfv.3 3)
                                         (set! r15 L.rp.3)
                                         (jump L.increment.1 rbp r15 nfv.3)))
                         (set! rbp (- rbp 24))
                         (set! y.2 rax)
                         (set! fv1 y.2)
                         (set! fv0 x.2)
                         (set! r15 ra.1)
                         (jump L.add.2 rbp r15 fv0 fv1)))
                   (define L.increment.1
                     ((locals (ra.4 x.1 tmp.5 tmp.6))
                      (undead-out
                       ((fv0 ra.4 rbp)
                        (x.1 ra.4 rbp)
                        (tmp.5 x.1 ra.4 rbp)
                        (tmp.6 ra.4 rbp)
                        (ra.4 rax rbp)
                        (rax rbp)))
                      (conflicts
                       ((ra.4 (rax tmp.6 tmp.5 x.1 fv0 rbp))
                        (rbp (rax tmp.6 tmp.5 x.1 ra.4))
                        (fv0 (ra.4))
                        (x.1 (tmp.5 ra.4 rbp))
                        (tmp.5 (x.1 ra.4 rbp))
                        (tmp.6 (rbp ra.4))
                        (rax (ra.4 rbp))))
                      (assignment ()))
                     (begin
                       (set! ra.4 r15)
                       (set! x.1 fv0)
                       (set! tmp.5 1)
                       (set! tmp.6 (+ x.1 tmp.5))
                       (set! rax tmp.6)
                       (jump ra.4 rbp rax)))
                   (define L.add.2
                     ((locals (ra.7 y.2 z.3 tmp.8))
                      (undead-out
                       ((fv0 fv1 ra.7 rbp)
                        (fv1 y.2 ra.7 rbp)
                        (z.3 y.2 ra.7 rbp)
                        (tmp.8 ra.7 rbp)
                        (ra.7 rax rbp)
                        (rax rbp)))
                      (conflicts
                       ((ra.7 (rax tmp.8 z.3 y.2 fv0 fv1 rbp))
                        (rbp (rax tmp.8 z.3 y.2 ra.7))
                        (fv1 (y.2 ra.7))
                        (fv0 (ra.7))
                        (y.2 (z.3 fv1 ra.7 rbp))
                        (z.3 (y.2 ra.7 rbp))
                        (tmp.8 (rbp ra.7))
                        (rax (ra.7 rbp))))
                      (assignment ()))
                     (begin
                       (set! ra.7 r15)
                       (set! y.2 fv0)
                       (set! z.3 fv1)
                       (set! tmp.8 (+ y.2 z.3))
                       (set! rax tmp.8)
                       (jump ra.7 rbp rax)))))
  (check-equal? (assign-frames
                 '(module
                      (define L.main.1
                        ((new-frames ((nfv.2) (nfv.3)))
                         (locals (nfv.2 nfv.3 y.2))
                         (undead-out
                          ((ra.1 rbp)
                           ((rax ra.1 rbp) ((nfv.2 rbp) (nfv.2 r15 rbp) (nfv.2 r15 rbp)))
                           (x.2 ra.1 rbp)
                           ((rax x.2 ra.1 rbp) ((nfv.3 rbp) (nfv.3 r15 rbp) (nfv.3 r15 rbp)))
                           (y.2 x.2 ra.1 rbp)
                           (x.2 ra.1 fv1 rbp)
                           (ra.1 fv1 fv0 rbp)
                           (fv1 fv0 r15 rbp)
                           (fv1 fv0 r15 rbp)))
                         (call-undead (x.2 ra.1))
                         (conflicts
                          ((ra.1 (fv0 fv1 y.2 x.2 rax rbp))
                           (rbp (fv0 fv1 y.2 nfv.3 x.2 r15 nfv.2 rax ra.1))
                           (rax (x.2 rbp ra.1))
                           (nfv.2 (r15 rbp))
                           (r15 (fv1 fv0 nfv.3 nfv.2 rbp))
                           (x.2 (fv1 y.2 rax ra.1 rbp))
                           (nfv.3 (r15 rbp))
                           (y.2 (x.2 ra.1 rbp))
                           (fv1 (r15 fv0 x.2 ra.1 rbp))
                           (fv0 (r15 ra.1 fv1 rbp))))
                         (assignment ((ra.1 fv2) (x.2 fv0))))
                        (begin
                          (set! ra.1 r15)
                          (return-point L.rp.2
                                        (begin
                                          (set! nfv.2 2)
                                          (set! r15 L.rp.2)
                                          (jump L.increment.1 rbp r15 nfv.2)))
                          (set! x.2 rax)
                          (return-point L.rp.3
                                        (begin
                                          (set! nfv.3 3)
                                          (set! r15 L.rp.3)
                                          (jump L.increment.1 rbp r15 nfv.3)))
                          (set! y.2 rax)
                          (set! fv1 y.2)
                          (set! fv0 x.2)
                          (set! r15 ra.1)
                          (jump L.add.2 rbp r15 fv0 fv1)))
                    (define L.increment.1
                      ((new-frames ())
                       (locals (ra.4 x.1 tmp.5 tmp.6))
                       (undead-out
                        ((fv0 ra.4 rbp)
                         (x.1 ra.4 rbp)
                         (tmp.5 x.1 ra.4 rbp)
                         (tmp.6 ra.4 rbp)
                         (ra.4 rax rbp)
                         (rax rbp)))
                       (call-undead ())
                       (conflicts
                        ((ra.4 (rax tmp.6 tmp.5 x.1 fv0 rbp))
                         (rbp (rax tmp.6 tmp.5 x.1 ra.4))
                         (fv0 (ra.4))
                         (x.1 (tmp.5 ra.4 rbp))
                         (tmp.5 (x.1 ra.4 rbp))
                         (tmp.6 (rbp ra.4))
                         (rax (ra.4 rbp))))
                       (assignment ()))
                      (begin
                        (set! ra.4 r15)
                        (set! x.1 fv0)
                        (set! tmp.5 1)
                        (set! tmp.6 (+ x.1 tmp.5))
                        (set! rax tmp.6)
                        (jump ra.4 rbp rax)))
                    (define L.add.2
                      ((new-frames ((nfv.10)))
                       (locals (y.2 b.2 nfv.10 tmp.9 tmp.8 z.3))
                       (undead-out
                        ((fv0 fv1 ra.7 rbp)
                         (fv1 y.2 ra.7 rbp)
                         (z.3 y.2 ra.7 rbp)
                         ((z.3 y.2 ra.7 rbp)
                          ((ra.7 rax rbp) (rax rbp))
                          ((tmp.8 z.3 y.2 ra.7 rbp)
                           (tmp.9 y.2 ra.7 rbp)
                           (y.2 a.1 ra.7 rbp)
                           ((rax a.1 ra.7 rbp) ((nfv.10 rbp) (nfv.10 r15 rbp) (nfv.10 r15 rbp)))
                           (a.1 b.2 ra.7 rbp)
                           (b.2 ra.7 fv1 rbp)
                           (ra.7 fv1 fv0 rbp)
                           (fv1 fv0 r15 rbp)
                           (fv1 fv0 r15 rbp)))))
                       (call-undead (a.1 ra.7))
                       (conflicts
                        ((tmp.8 (z.3 y.2 ra.7 rbp))
                         (rbp (z.3 y.2 ra.7 fv0 fv1 b.2 r15 nfv.10 rax a.1 tmp.9 tmp.8))
                         (ra.7 (z.3 y.2 rbp fv0 fv1 b.2 rax a.1 tmp.9 tmp.8))
                         (y.2 (z.3 fv1 ra.7 rbp a.1 tmp.9 tmp.8))
                         (z.3 (y.2 ra.7 rbp tmp.8))
                         (tmp.9 (rbp ra.7 y.2))
                         (a.1 (b.2 rax y.2 ra.7 rbp))
                         (rax (rbp ra.7 a.1))
                         (nfv.10 (r15 rbp))
                         (r15 (fv1 fv0 nfv.10 rbp))
                         (b.2 (fv1 a.1 ra.7 rbp))
                         (fv1 (y.2 r15 fv0 b.2 ra.7 rbp))
                         (fv0 (r15 ra.7 fv1 rbp))))
                       (assignment ((ra.7 fv2) (a.1 fv0))))
                      (begin
                        (set! ra.7 r15)
                        (set! y.2 fv0)
                        (set! z.3 fv1)
                        (if (= z.3 0)
                            (begin (set! rax y.2) (jump ra.7 rbp rax))
                            (begin
                              (set! tmp.8 1)
                              (set! tmp.9 (- z.3 tmp.8))
                              (set! a.1 tmp.9)
                              (return-point L.rp.4
                                            (begin
                                              (set! nfv.10 y.2)
                                              (set! r15 L.rp.4)
                                              (jump L.increment.1 rbp r15 nfv.10)))
                              (set! b.2 rax)
                              (set! fv1 a.1)
                              (set! fv0 b.2)
                              (set! r15 ra.7)
                              (jump L.add.2 rbp r15 fv0 fv1)))))))
                '(module
                     (define L.main.1
                       ((locals (y.2))
                        (undead-out
                         ((ra.1 rbp)
                          ((rax ra.1 rbp) ((nfv.2 rbp) (nfv.2 r15 rbp) (nfv.2 r15 rbp)))
                          (x.2 ra.1 rbp)
                          ((rax x.2 ra.1 rbp) ((nfv.3 rbp) (nfv.3 r15 rbp) (nfv.3 r15 rbp)))
                          (y.2 x.2 ra.1 rbp)
                          (x.2 ra.1 fv1 rbp)
                          (ra.1 fv1 fv0 rbp)
                          (fv1 fv0 r15 rbp)
                          (fv1 fv0 r15 rbp)))
                        (conflicts
                         ((ra.1 (fv0 fv1 y.2 x.2 rax rbp))
                          (rbp (fv0 fv1 y.2 nfv.3 x.2 r15 nfv.2 rax ra.1))
                          (rax (x.2 rbp ra.1))
                          (nfv.2 (r15 rbp))
                          (r15 (fv1 fv0 nfv.3 nfv.2 rbp))
                          (x.2 (fv1 y.2 rax ra.1 rbp))
                          (nfv.3 (r15 rbp))
                          (y.2 (x.2 ra.1 rbp))
                          (fv1 (r15 fv0 x.2 ra.1 rbp))
                          (fv0 (r15 ra.1 fv1 rbp))))
                        (assignment ((ra.1 fv2) (x.2 fv0) (nfv.2 fv3) (nfv.3 fv3))))
                       (begin
                         (set! ra.1 r15)
                         (set! rbp (+ rbp 24))
                         (return-point L.rp.2
                                       (begin
                                         (set! nfv.2 2)
                                         (set! r15 L.rp.2)
                                         (jump L.increment.1 rbp r15 nfv.2)))
                         (set! rbp (- rbp 24))
                         (set! x.2 rax)
                         (set! rbp (+ rbp 24))
                         (return-point L.rp.3
                                       (begin
                                         (set! nfv.3 3)
                                         (set! r15 L.rp.3)
                                         (jump L.increment.1 rbp r15 nfv.3)))
                         (set! rbp (- rbp 24))
                         (set! y.2 rax)
                         (set! fv1 y.2)
                         (set! fv0 x.2)
                         (set! r15 ra.1)
                         (jump L.add.2 rbp r15 fv0 fv1)))
                   (define L.increment.1
                     ((locals (ra.4 x.1 tmp.5 tmp.6))
                      (undead-out
                       ((fv0 ra.4 rbp)
                        (x.1 ra.4 rbp)
                        (tmp.5 x.1 ra.4 rbp)
                        (tmp.6 ra.4 rbp)
                        (ra.4 rax rbp)
                        (rax rbp)))
                      (conflicts
                       ((ra.4 (rax tmp.6 tmp.5 x.1 fv0 rbp))
                        (rbp (rax tmp.6 tmp.5 x.1 ra.4))
                        (fv0 (ra.4))
                        (x.1 (tmp.5 ra.4 rbp))
                        (tmp.5 (x.1 ra.4 rbp))
                        (tmp.6 (rbp ra.4))
                        (rax (ra.4 rbp))))
                      (assignment ()))
                     (begin
                       (set! ra.4 r15)
                       (set! x.1 fv0)
                       (set! tmp.5 1)
                       (set! tmp.6 (+ x.1 tmp.5))
                       (set! rax tmp.6)
                       (jump ra.4 rbp rax)))
                   (define L.add.2
                     ((locals (y.2 b.2 tmp.9 tmp.8 z.3))
                      (undead-out
                       ((fv0 fv1 ra.7 rbp)
                        (fv1 y.2 ra.7 rbp)
                        (z.3 y.2 ra.7 rbp)
                        ((z.3 y.2 ra.7 rbp)
                         ((ra.7 rax rbp) (rax rbp))
                         ((tmp.8 z.3 y.2 ra.7 rbp)
                          (tmp.9 y.2 ra.7 rbp)
                          (y.2 a.1 ra.7 rbp)
                          ((rax a.1 ra.7 rbp) ((nfv.10 rbp) (nfv.10 r15 rbp) (nfv.10 r15 rbp)))
                          (a.1 b.2 ra.7 rbp)
                          (b.2 ra.7 fv1 rbp)
                          (ra.7 fv1 fv0 rbp)
                          (fv1 fv0 r15 rbp)
                          (fv1 fv0 r15 rbp)))))
                      (conflicts
                       ((tmp.8 (z.3 y.2 ra.7 rbp))
                        (rbp (z.3 y.2 ra.7 fv0 fv1 b.2 r15 nfv.10 rax a.1 tmp.9 tmp.8))
                        (ra.7 (z.3 y.2 rbp fv0 fv1 b.2 rax a.1 tmp.9 tmp.8))
                        (y.2 (z.3 fv1 ra.7 rbp a.1 tmp.9 tmp.8))
                        (z.3 (y.2 ra.7 rbp tmp.8))
                        (tmp.9 (rbp ra.7 y.2))
                        (a.1 (b.2 rax y.2 ra.7 rbp))
                        (rax (rbp ra.7 a.1))
                        (nfv.10 (r15 rbp))
                        (r15 (fv1 fv0 nfv.10 rbp))
                        (b.2 (fv1 a.1 ra.7 rbp))
                        (fv1 (y.2 r15 fv0 b.2 ra.7 rbp))
                        (fv0 (r15 ra.7 fv1 rbp))))
                      (assignment ((ra.7 fv2) (a.1 fv0) (nfv.10 fv3))))
                     (begin
                       (set! ra.7 r15)
                       (set! y.2 fv0)
                       (set! z.3 fv1)
                       (if (= z.3 0)
                           (begin (set! rax y.2) (jump ra.7 rbp rax))
                           (begin
                             (set! tmp.8 1)
                             (set! tmp.9 (- z.3 tmp.8))
                             (set! a.1 tmp.9)
                             (set! rbp (+ rbp 24))
                             (return-point L.rp.4
                                           (begin
                                             (set! nfv.10 y.2)
                                             (set! r15 L.rp.4)
                                             (jump L.increment.1 rbp r15 nfv.10)))
                             (set! rbp (- rbp 24))
                             (set! b.2 rax)
                             (set! fv1 a.1)
                             (set! fv0 b.2)
                             (set! r15 ra.7)
                             (jump L.add.2 rbp r15 fv0 fv1)))))))
  )

; Exercise 8
(module+ test
  (check-equal? (parameterize ([current-parameter-registers '()]
                               [current-assignable-registers '(r13 r14 r15)])
                  (assign-registers
                  '(module
                        (define L.main.1
                          ((locals (ra.1))
                          (undead-out
                            ((ra.1 rbp)
                            (ra.1 fv1 rbp)
                            (ra.1 fv0 fv1 rbp)
                            (fv0 fv1 r15 rbp)
                            (fv0 fv1 r15 rbp)))
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
                        ((locals (y.2 z.3 x.1))
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
                        (assignment ((ra.2 fv2) (nfv.4 fv3) (nfv.3 fv4))))
                        (begin
                          (set! ra.2 r15)
                          (set! x.1 fv0)
                          (set! y.2 fv1)
                          (if (< y.2 x.1)
                              (begin (set! rax x.1) (jump ra.2 rbp rax))
                              (begin
                                (set! rbp (+ rbp 24))
                                (return-point L.rp.2
                                              (begin
                                                (set! nfv.4 x.1)
                                                (set! nfv.3 y.2)
                                                (set! r15 L.rp.2)
                                                (jump L.swap.1 rbp r15 nfv.4 nfv.3)))
                                (set! rbp (- rbp 24))
                                (set! z.3 rax)
                                (set! rax z.3)
                                (jump ra.2 rbp rax))))))))
                '(module
                     (define L.main.1
                       ((locals ())
                        (undead-out
                         ((ra.1 rbp)
                          (ra.1 fv1 rbp)
                          (ra.1 fv0 fv1 rbp)
                          (fv0 fv1 r15 rbp)
                          (fv0 fv1 r15 rbp)))
                        (conflicts
                         ((ra.1 (fv0 fv1 rbp))
                          (rbp (r15 fv0 fv1 ra.1))
                          (fv1 (r15 fv0 ra.1 rbp))
                          (fv0 (r15 ra.1 fv1 rbp))
                          (r15 (fv0 fv1 rbp))))
                        (assignment ((ra.1 r13))))
                       (begin
                         (set! ra.1 r15)
                         (set! fv1 2)
                         (set! fv0 1)
                         (set! r15 ra.1)
                         (jump L.swap.1 rbp r15 fv1 fv0)))
                   (define L.swap.1
                     ((locals ())
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
                      (assignment
                       ((ra.2 fv2) (nfv.4 fv3) (nfv.3 fv4) (z.3 r13) (y.2 r13) (x.1 r14))))
                     (begin
                       (set! ra.2 r15)
                       (set! x.1 fv0)
                       (set! y.2 fv1)
                       (if (< y.2 x.1)
                           (begin (set! rax x.1) (jump ra.2 rbp rax))
                           (begin
                             (set! rbp (+ rbp 24))
                             (return-point L.rp.2
                                           (begin
                                             (set! nfv.4 x.1)
                                             (set! nfv.3 y.2)
                                             (set! r15 L.rp.2)
                                             (jump L.swap.1 rbp r15 nfv.4 nfv.3)))
                             (set! rbp (- rbp 24))
                             (set! z.3 rax)
                             (set! rax z.3)
                             (jump ra.2 rbp rax)))))))
  (check-equal? (parameterize ([current-parameter-registers '()]
                               [current-assignable-registers '(r13 r14 r15)])
                  (assign-registers
                  '(module
                        (define L.main.1
                          ((locals (y.2))
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
                          (conflicts
                            ((ra.1 (rdi rsi y.2 x.2 rbp))
                            (rbp (rsi y.2 x.2 r15 rdi ra.1))
                            (rdi (ra.1 rsi r15 rbp))
                            (r15 (rsi rdi rbp))
                            (x.2 (rsi y.2 ra.1 rbp))
                            (y.2 (x.2 ra.1 rbp))
                            (rsi (r15 rdi x.2 ra.1 rbp))))
                          (assignment ((ra.1 fv0) (x.2 fv1))))
                          (begin
                            (set! ra.1 r15)
                            (set! rbp (+ rbp 16))
                            (return-point L.rp.2
                                          (begin
                                            (set! rdi 2)
                                            (set! r15 L.rp.2)
                                            (jump L.increment.1 rbp r15 rdi)))
                            (set! rbp (- rbp 16))
                            (set! x.2 rax)
                            (set! rbp (+ rbp 16))
                            (return-point L.rp.3
                                          (begin
                                            (set! rdi 3)
                                            (set! r15 L.rp.3)
                                            (jump L.increment.1 rbp r15 rdi)))
                            (set! rbp (- rbp 16))
                            (set! y.2 rax)
                            (set! rsi y.2)
                            (set! rdi x.2)
                            (set! r15 ra.1)
                            (jump L.add.2 rbp r15 rsi rdi)))
                      (define L.increment.1
                        ((locals (tmp.4 tmp.3 x.1 ra.2))
                        (undead-out
                          ((rdi ra.2 rbp)
                          (x.1 ra.2 rbp)
                          (tmp.3 x.1 ra.2 rbp)
                          (tmp.4 ra.2 rbp)
                          (ra.2 rax rbp)
                          (rax rbp)))
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
                        ((locals (tmp.6 z.3 y.2 ra.5))
                        (undead-out
                          ((rdi rsi ra.5 rbp)
                          (rsi y.2 ra.5 rbp)
                          (z.3 y.2 ra.5 rbp)
                          (tmp.6 ra.5 rbp)
                          (ra.5 rax rbp)
                          (rax rbp)))
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
                          (jump ra.5 rbp rax))))))
                '(module
                     (define L.main.1
                       ((locals ())
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
                        (conflicts
                         ((ra.1 (rdi rsi y.2 x.2 rbp))
                          (rbp (rsi y.2 x.2 r15 rdi ra.1))
                          (rdi (ra.1 rsi r15 rbp))
                          (r15 (rsi rdi rbp))
                          (x.2 (rsi y.2 ra.1 rbp))
                          (y.2 (x.2 ra.1 rbp))
                          (rsi (r15 rdi x.2 ra.1 rbp))))
                        (assignment ((ra.1 fv0) (x.2 fv1) (y.2 r15))))
                       (begin
                         (set! ra.1 r15)
                         (set! rbp (+ rbp 16))
                         (return-point L.rp.2
                                       (begin
                                         (set! rdi 2)
                                         (set! r15 L.rp.2)
                                         (jump L.increment.1 rbp r15 rdi)))
                         (set! rbp (- rbp 16))
                         (set! x.2 rax)
                         (set! rbp (+ rbp 16))
                         (return-point L.rp.3
                                       (begin
                                         (set! rdi 3)
                                         (set! r15 L.rp.3)
                                         (jump L.increment.1 rbp r15 rdi)))
                         (set! rbp (- rbp 16))
                         (set! y.2 rax)
                         (set! rsi y.2)
                         (set! rdi x.2)
                         (set! r15 ra.1)
                         (jump L.add.2 rbp r15 rsi rdi)))
                   (define L.increment.1
                     ((locals ())
                      (undead-out
                       ((rdi ra.2 rbp)
                        (x.1 ra.2 rbp)
                        (tmp.3 x.1 ra.2 rbp)
                        (tmp.4 ra.2 rbp)
                        (ra.2 rax rbp)
                        (rax rbp)))
                      (conflicts
                       ((ra.2 (rax tmp.4 tmp.3 x.1 rdi rbp))
                        (rbp (rax tmp.4 tmp.3 x.1 ra.2))
                        (rdi (ra.2))
                        (x.1 (tmp.3 ra.2 rbp))
                        (tmp.3 (x.1 ra.2 rbp))
                        (tmp.4 (rbp ra.2))
                        (rax (ra.2 rbp))))
                      (assignment ((ra.2 r15) (tmp.4 r13) (tmp.3 r13) (x.1 r14))))
                     (begin
                       (set! ra.2 r15)
                       (set! x.1 rdi)
                       (set! tmp.3 1)
                       (set! tmp.4 (+ x.1 tmp.3))
                       (set! rax tmp.4)
                       (jump ra.2 rbp rax)))
                   (define L.add.2
                     ((locals ())
                      (undead-out
                       ((rdi rsi ra.5 rbp)
                        (rsi y.2 ra.5 rbp)
                        (z.3 y.2 ra.5 rbp)
                        (tmp.6 ra.5 rbp)
                        (ra.5 rax rbp)
                        (rax rbp)))
                      (conflicts
                       ((ra.5 (rax tmp.6 z.3 y.2 rdi rsi rbp))
                        (rbp (rax tmp.6 z.3 y.2 ra.5))
                        (rsi (y.2 ra.5))
                        (rdi (ra.5))
                        (y.2 (z.3 rsi ra.5 rbp))
                        (z.3 (y.2 ra.5 rbp))
                        (tmp.6 (rbp ra.5))
                        (rax (ra.5 rbp))))
                      (assignment ((ra.5 r14) (z.3 r13) (tmp.6 r13) (y.2 r15))))
                     (begin
                       (set! ra.5 r15)
                       (set! y.2 rdi)
                       (set! z.3 rsi)
                       (set! tmp.6 (+ y.2 z.3))
                       (set! rax tmp.6)
                       (jump ra.5 rbp rax)))))
  (check-equal? (parameterize ([current-parameter-registers '()]
                               [current-assignable-registers '(r13 r14 r15)])
                  (assign-registers
                    '(module
                          (define L.main.1
                            ((locals (y.2))
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
                            (conflicts
                              ((ra.1 (rdi rsi y.2 x.2 rbp))
                              (rbp (rsi y.2 x.2 r15 rdi ra.1))
                              (rdi (ra.1 rsi r15 rbp))
                              (r15 (rsi rdi rbp))
                              (x.2 (rsi y.2 ra.1 rbp))
                              (y.2 (x.2 ra.1 rbp))
                              (rsi (r15 rdi x.2 ra.1 rbp))))
                            (assignment ((ra.1 fv0) (x.2 fv1))))
                            (begin
                              (set! ra.1 r15)
                              (set! rbp (+ rbp 16))
                              (return-point L.rp.2
                                            (begin
                                              (set! rdi 2)
                                              (set! r15 L.rp.2)
                                              (jump L.increment.1 rbp r15 rdi)))
                              (set! rbp (- rbp 16))
                              (set! x.2 rax)
                              (set! rbp (+ rbp 16))
                              (return-point L.rp.3
                                            (begin
                                              (set! rdi 3)
                                              (set! r15 L.rp.3)
                                              (jump L.increment.1 rbp r15 rdi)))
                              (set! rbp (- rbp 16))
                              (set! y.2 rax)
                              (set! rsi y.2)
                              (set! rdi x.2)
                              (set! r15 ra.1)
                              (jump L.add.2 rbp r15 rsi rdi)))
                        (define L.increment.1
                          ((locals (tmp.4 tmp.3 x.1 ra.2))
                          (undead-out
                            ((rdi ra.2 rbp)
                            (x.1 ra.2 rbp)
                            (tmp.3 x.1 ra.2 rbp)
                            (tmp.4 ra.2 rbp)
                            (ra.2 rax rbp)
                            (rax rbp)))
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
                          ((locals (z.3 tmp.6 tmp.7 b.2 y.2))
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
                          (assignment ((ra.5 fv0) (a.1 fv1))))
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
                                  (set! rbp (+ rbp 16))
                                  (return-point L.rp.4
                                                (begin
                                                  (set! rdi y.2)
                                                  (set! r15 L.rp.4)
                                                  (jump L.increment.1 rbp r15 rdi)))
                                  (set! rbp (- rbp 16))
                                  (set! b.2 rax)
                                  (set! rsi a.1)
                                  (set! rdi b.2)
                                  (set! r15 ra.5)
                                  (jump L.add.2 rbp r15 rsi rdi))))))))
                '(module
                     (define L.main.1
                       ((locals ())
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
                        (conflicts
                         ((ra.1 (rdi rsi y.2 x.2 rbp))
                          (rbp (rsi y.2 x.2 r15 rdi ra.1))
                          (rdi (ra.1 rsi r15 rbp))
                          (r15 (rsi rdi rbp))
                          (x.2 (rsi y.2 ra.1 rbp))
                          (y.2 (x.2 ra.1 rbp))
                          (rsi (r15 rdi x.2 ra.1 rbp))))
                        (assignment ((ra.1 fv0) (x.2 fv1) (y.2 r15))))
                       (begin
                         (set! ra.1 r15)
                         (set! rbp (+ rbp 16))
                         (return-point L.rp.2
                                       (begin
                                         (set! rdi 2)
                                         (set! r15 L.rp.2)
                                         (jump L.increment.1 rbp r15 rdi)))
                         (set! rbp (- rbp 16))
                         (set! x.2 rax)
                         (set! rbp (+ rbp 16))
                         (return-point L.rp.3
                                       (begin
                                         (set! rdi 3)
                                         (set! r15 L.rp.3)
                                         (jump L.increment.1 rbp r15 rdi)))
                         (set! rbp (- rbp 16))
                         (set! y.2 rax)
                         (set! rsi y.2)
                         (set! rdi x.2)
                         (set! r15 ra.1)
                         (jump L.add.2 rbp r15 rsi rdi)))
                   (define L.increment.1
                     ((locals ())
                      (undead-out
                       ((rdi ra.2 rbp)
                        (x.1 ra.2 rbp)
                        (tmp.3 x.1 ra.2 rbp)
                        (tmp.4 ra.2 rbp)
                        (ra.2 rax rbp)
                        (rax rbp)))
                      (conflicts
                       ((ra.2 (rax tmp.4 tmp.3 x.1 rdi rbp))
                        (rbp (rax tmp.4 tmp.3 x.1 ra.2))
                        (rdi (ra.2))
                        (x.1 (tmp.3 ra.2 rbp))
                        (tmp.3 (x.1 ra.2 rbp))
                        (tmp.4 (rbp ra.2))
                        (rax (ra.2 rbp))))
                      (assignment ((ra.2 r15) (tmp.4 r13) (tmp.3 r13) (x.1 r14))))
                     (begin
                       (set! ra.2 r15)
                       (set! x.1 rdi)
                       (set! tmp.3 1)
                       (set! tmp.4 (+ x.1 tmp.3))
                       (set! rax tmp.4)
                       (jump ra.2 rbp rax)))
                   (define L.add.2
                     ((locals ())
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
                      (assignment
                        ((ra.5 fv0)
                          (a.1 fv1)
                          (z.3 r14)
                          (tmp.6 r13)
                          (y.2 r15)
                          (tmp.7 r13)
                          (b.2 r13))))
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
                             (set! rbp (+ rbp 16))
                             (return-point L.rp.4
                                           (begin
                                             (set! rdi y.2)
                                             (set! r15 L.rp.4)
                                             (jump L.increment.1 rbp r15 rdi)))
                             (set! rbp (- rbp 16))
                             (set! b.2 rax)
                             (set! rsi a.1)
                             (set! rdi b.2)
                             (set! r15 ra.5)
                             (jump L.add.2 rbp r15 rsi rdi)))))))
  (check-equal? (parameterize ([current-parameter-registers '()]
                               [current-assignable-registers '(r15)])
                  (assign-registers
                   '(module
                        (define L.main.1
                          ((locals
                            (tmp.5 o.15 tmp.4 n.14 tmp.3 m.13 tmp.2 f.6 e.5 d.4 c.3 b.2 a.1 ra.1))
                           (undead-out
                            ((k.11 ra.1 rbp)
                             (a.1 k.11 ra.1 rbp)
                             (b.2 a.1 k.11 ra.1 rbp)
                             (c.3 b.2 a.1 k.11 ra.1 rbp)
                             (d.4 c.3 b.2 a.1 k.11 ra.1 rbp)
                             (e.5 d.4 c.3 b.2 a.1 k.11 ra.1 rbp)
                             (f.6 e.5 d.4 c.3 b.2 a.1 k.11 ra.1 rbp)
                             (tmp.2 d.4 c.3 b.2 a.1 k.11 ra.1 rbp)
                             (d.4 c.3 b.2 a.1 k.11 ra.1 rbp)
                             (tmp.3 b.2 a.1 k.11 ra.1 rbp)
                             (b.2 a.1 k.11 ra.1 rbp)
                             (tmp.4 k.11 ra.1 rbp)
                             (k.11 o.15 ra.1 rbp)
                             (tmp.5 ra.1 rbp)
                             (ra.1 rax rbp)
                             (rax rbp)))
                           (conflicts
                            ((ra.1
                              (rax
                               tmp.5
                               o.15
                               tmp.4
                               n.14
                               tmp.3
                               m.13
                               tmp.2
                               f.6
                               e.5
                               d.4
                               c.3
                               b.2
                               a.1
                               k.11
                               rbp))
                             (rbp
                              (rax
                               tmp.5
                               o.15
                               tmp.4
                               n.14
                               tmp.3
                               m.13
                               tmp.2
                               f.6
                               e.5
                               d.4
                               c.3
                               b.2
                               a.1
                               ra.1))
                             (k.11 (o.15 tmp.4 n.14 tmp.3 m.13 tmp.2 f.6 e.5 d.4 c.3 b.2 a.1 ra.1))
                             (a.1 (n.14 tmp.3 m.13 tmp.2 f.6 e.5 d.4 c.3 b.2 k.11 ra.1 rbp))
                             (b.2 (n.14 tmp.3 m.13 tmp.2 f.6 e.5 d.4 c.3 a.1 k.11 ra.1 rbp))
                             (c.3 (m.13 tmp.2 f.6 e.5 d.4 b.2 a.1 k.11 ra.1 rbp))
                             (d.4 (m.13 tmp.2 f.6 e.5 c.3 b.2 a.1 k.11 ra.1 rbp))
                             (e.5 (f.6 d.4 c.3 b.2 a.1 k.11 ra.1 rbp))
                             (f.6 (e.5 d.4 c.3 b.2 a.1 k.11 ra.1 rbp))
                             (tmp.2 (rbp ra.1 k.11 a.1 b.2 c.3 d.4))
                             (m.13 (d.4 c.3 b.2 a.1 k.11 ra.1 rbp))
                             (tmp.3 (rbp ra.1 k.11 a.1 b.2))
                             (n.14 (b.2 a.1 k.11 ra.1 rbp))
                             (tmp.4 (rbp ra.1 k.11))
                             (o.15 (k.11 ra.1 rbp))
                             (tmp.5 (rbp ra.1))
                             (rax (ra.1 rbp))))
                           (assignment ()))
                          (begin
                            (set! ra.1 r15)
                            (set! a.1 1)
                            (set! b.2 2)
                            (set! c.3 3)
                            (set! d.4 4)
                            (set! e.5 5)
                            (set! f.6 6)
                            (set! tmp.2 (+ e.5 f.6))
                            (set! m.13 tmp.2)
                            (set! tmp.3 (+ c.3 d.4))
                            (set! n.14 tmp.3)
                            (set! tmp.4 (+ a.1 b.2))
                            (set! o.15 tmp.4)
                            (set! tmp.5 (+ o.15 k.11))
                            (set! rax tmp.5)
                            (jump ra.1 rbp rax))))))
                  '(module
                       (define L.main.1
                         ((locals (e.5 d.4 c.3 b.2 a.1 ra.1))
                          (undead-out
                           ((k.11 ra.1 rbp)
                            (a.1 k.11 ra.1 rbp)
                            (b.2 a.1 k.11 ra.1 rbp)
                            (c.3 b.2 a.1 k.11 ra.1 rbp)
                            (d.4 c.3 b.2 a.1 k.11 ra.1 rbp)
                            (e.5 d.4 c.3 b.2 a.1 k.11 ra.1 rbp)
                            (f.6 e.5 d.4 c.3 b.2 a.1 k.11 ra.1 rbp)
                            (tmp.2 d.4 c.3 b.2 a.1 k.11 ra.1 rbp)
                            (d.4 c.3 b.2 a.1 k.11 ra.1 rbp)
                            (tmp.3 b.2 a.1 k.11 ra.1 rbp)
                            (b.2 a.1 k.11 ra.1 rbp)
                            (tmp.4 k.11 ra.1 rbp)
                            (k.11 o.15 ra.1 rbp)
                            (tmp.5 ra.1 rbp)
                            (ra.1 rax rbp)
                            (rax rbp)))
                          (conflicts
                           ((ra.1
                             (rax
                              tmp.5
                              o.15
                              tmp.4
                              n.14
                              tmp.3
                              m.13
                              tmp.2
                              f.6
                              e.5
                              d.4
                              c.3
                              b.2
                              a.1
                              k.11
                              rbp))
                            (rbp
                             (rax
                              tmp.5
                              o.15
                              tmp.4
                              n.14
                              tmp.3
                              m.13
                              tmp.2
                              f.6
                              e.5
                              d.4
                              c.3
                              b.2
                              a.1
                              ra.1))
                            (k.11 (o.15 tmp.4 n.14 tmp.3 m.13 tmp.2 f.6 e.5 d.4 c.3 b.2 a.1 ra.1))
                            (a.1 (n.14 tmp.3 m.13 tmp.2 f.6 e.5 d.4 c.3 b.2 k.11 ra.1 rbp))
                            (b.2 (n.14 tmp.3 m.13 tmp.2 f.6 e.5 d.4 c.3 a.1 k.11 ra.1 rbp))
                            (c.3 (m.13 tmp.2 f.6 e.5 d.4 b.2 a.1 k.11 ra.1 rbp))
                            (d.4 (m.13 tmp.2 f.6 e.5 c.3 b.2 a.1 k.11 ra.1 rbp))
                            (e.5 (f.6 d.4 c.3 b.2 a.1 k.11 ra.1 rbp))
                            (f.6 (e.5 d.4 c.3 b.2 a.1 k.11 ra.1 rbp))
                            (tmp.2 (rbp ra.1 k.11 a.1 b.2 c.3 d.4))
                            (m.13 (d.4 c.3 b.2 a.1 k.11 ra.1 rbp))
                            (tmp.3 (rbp ra.1 k.11 a.1 b.2))
                            (n.14 (b.2 a.1 k.11 ra.1 rbp))
                            (tmp.4 (rbp ra.1 k.11))
                            (o.15 (k.11 ra.1 rbp))
                            (tmp.5 (rbp ra.1))
                            (rax (ra.1 rbp))))
                          (assignment
                            ((n.14 r15)
                              (f.6 r15)
                              (o.15 r15)
                              (tmp.4 r15)
                              (tmp.5 r15)
                              (tmp.2 r15)
                              (tmp.3 r15)
                              (m.13 r15))))
                         (begin
                           (set! ra.1 r15)
                           (set! a.1 1)
                           (set! b.2 2)
                           (set! c.3 3)
                           (set! d.4 4)
                           (set! e.5 5)
                           (set! f.6 6)
                           (set! tmp.2 (+ e.5 f.6))
                           (set! m.13 tmp.2)
                           (set! tmp.3 (+ c.3 d.4))
                           (set! n.14 tmp.3)
                           (set! tmp.4 (+ a.1 b.2))
                           (set! o.15 tmp.4)
                           (set! tmp.5 (+ o.15 k.11))
                           (set! rax tmp.5)
                           (jump ra.1 rbp rax)))))
  )
