#lang racket/base

(require
    "a10.rkt"
    "a10-compiler-lib.rkt"
    "a10-graph-lib.rkt"
    "share/util.rkt")

(module+ test
  (require rackunit))

(module+ test 
    ; Exercise 4 undead-analysis
    (check-match (undead-analysis   '(module
                                        (define L.main.1
                                        ((new-frames ())
                                            (locals (a.1 b.1 b.2 c.1 d.1 e.1 f.1)))
                                        (begin
                                            (set! a.1 1)
                                            (set! b.1 2)
                                            (set! c.1 3)
                                            (set! d.1 (+ b.1 c.1))
                                            (set! e.1 d.1)
                                            (set! f.1 (* d.1 c.1))
                                            (set! b.2 (+ f.1 f.1))
                                            (jump L.main.1 b.2)))))
                        `(module
                            (define L.main.1
                                ,(list-no-order
                                `(undead-out
                                    (()
                                    (b.1)
                                    ,(list-no-order 'b.1 'c.1)
                                    ,(list-no-order 'c.1 'd.1)
                                    ,(list-no-order 'c.1 'd.1)
                                    (f.1)
                                    (b.2)
                                    (b.2)))
                                `(call-undead ())
                                `(new-frames ,_)
                                `(locals ,_))
                                ,_)))

    ; Exercise 9: assign-frame-variables
    (check-match (assign-frame-variables `(module     
    (define L.inc.6.33
      ((locals (ra.383 c.124 x.11 |+.53| tmp.139))
       (undead-out
        ((rdi rsi rdx r15 rbp)))
       (conflicts
        ((ra.383 (rdx tmp.139 |+.53| x.11 c.124 rdi rsi rbp))
         (rbp (r15 rdi rsi rdx tmp.139 |+.53| x.11 c.124 ra.383))
         (rsi (r15 rdi |+.53| rdx rbp c.124 ra.383))
         (rdi (r15 rsi rdx rbp ra.383))
         (c.124 (x.11 rsi ra.383 rbp))
         (x.11 (rdx tmp.139 |+.53| c.124 ra.383 rbp))
         (|+.53| (rsi rdx rbp ra.383 x.11))
         (tmp.139 (x.11 ra.383 rbp))
         (rdx (r15 rdi rsi x.11 |+.53| ra.383 rbp))
         (r15 (rdi rsi rdx rbp))))
       (assignment ()))
      (begin
        (jump L.+.53.29 rbp r15 rdx rsi rdi)))))
    `(module (define L.inc.6.33 ,(list-no-order
                            `(assignment ,(list-no-order `(tmp.139 fv1) `(|+.53| fv1) `(x.11 fv2) `(c.124 fv1) `(ra.383 fv0)))) 
                            ,_)))

    (check-match (assign-frame-variables `(module     
    (define L.inc.6.33
      ((locals ())
       (undead-out
        ((rdi rsi ra.383 rbp)
         (rsi c.124 ra.383 rbp)
         (c.124 x.11 ra.383 rbp)
         (x.11 |+.53| ra.383 rbp)
         (x.11 |+.53| ra.383 rbp)
         (x.11 |+.53| ra.383 rdx rbp)
         (|+.53| ra.383 rsi rdx rbp)
         (ra.383 rdi rsi rdx rbp)
         (rdi rsi rdx r15 rbp)
         (rdi rsi rdx r15 rbp)))
       (conflicts
        ((ra.383 (rdx tmp.139 |+.53| x.11 c.124 rdi rsi rbp))
         (rbp (r15 rdi rsi rdx tmp.139 |+.53| x.11 c.124 ra.383))
         (rsi (r15 rdi |+.53| rdx rbp c.124 ra.383))
         (rdi (r15 rsi rdx rbp ra.383))
         (c.124 (x.11 rsi ra.383 rbp))
         (x.11 (rdx tmp.139 |+.53| c.124 ra.383 rbp))
         (|+.53| (rsi rdx rbp ra.383 x.11))
         (tmp.139 (x.11 ra.383 rbp))
         (rdx (r15 rdi rsi x.11 |+.53| ra.383 rbp))
         (r15 (rdi rsi rdx rbp))))
       (assignment
        ((ra.383 r15) (x.11 r14) (|+.53| r13) (c.124 r13) (tmp.139 r13))))
      (begin
        (set! ra.383 r15)
        (set! c.124 rdi)
        (set! x.11 rsi)
        (set! |+.53| (mref c.124 14))
        (set! tmp.139 |+.53|)
        (set! rdx 8)
        (set! rsi x.11)
        (set! rdi |+.53|)
        (set! r15 ra.383)
        (jump L.+.53.29 rbp r15 rdx rsi rdi)))))
    `(module (define L.inc.6.33 ,(list-no-order
                            `(assignment ,(list-no-order `(ra.383 r15) `(x.11 r14) `(|+.53| r13) `(c.124 r13) `(tmp.139 r13)))) 
                            ,_)))

        (check-match (assign-frame-variables `(module     ;; no undead-out case
    (define L.inc.6.33
      ((locals ())
       (conflicts
        ((ra.383 (rdx tmp.139 |+.53| x.11 c.124 rdi rsi rbp))
         (rbp (r15 rdi rsi rdx tmp.139 |+.53| x.11 c.124 ra.383))
         (rsi (r15 rdi |+.53| rdx rbp c.124 ra.383))
         (rdi (r15 rsi rdx rbp ra.383))
         (c.124 (x.11 rsi ra.383 rbp))
         (x.11 (rdx tmp.139 |+.53| c.124 ra.383 rbp))
         (|+.53| (rsi rdx rbp ra.383 x.11))
         (tmp.139 (x.11 ra.383 rbp))
         (rdx (r15 rdi rsi x.11 |+.53| ra.383 rbp))
         (r15 (rdi rsi rdx rbp))))
       (assignment
        ((ra.383 r15) (x.11 r14) (|+.53| r13) (c.124 r13) (tmp.139 r13))))
      (begin
        (set! ra.383 r15)
        (set! c.124 rdi)
        (set! x.11 rsi)
        (set! |+.53| (mref c.124 14))
        (set! tmp.139 |+.53|)
        (set! rdx 8)
        (set! rsi x.11)
        (set! rdi |+.53|)
        (set! r15 ra.383)
        (jump L.+.53.29 rbp r15 rdx rsi rdi)))))
    `(module (define L.inc.6.33 ,(list-no-order
                            `(assignment ,(list-no-order `(ra.383 r15) `(x.11 r14) `(|+.53| r13) `(c.124 r13) `(tmp.139 r13)))) 
                            ,_)))        

(check-match (assign-frame-variables `(module     ;; diff order case
    (define L.inc.6.33
      ((locals ())
       (conflicts
        ((ra.383 (rdx tmp.139 |+.53| x.11 c.124 rdi rsi rbp))
         (rbp (r15 rdi rsi rdx tmp.139 |+.53| x.11 c.124 ra.383))
         (rsi (r15 rdi |+.53| rdx rbp c.124 ra.383))
         (rdi (r15 rsi rdx rbp ra.383))
         (c.124 (x.11 rsi ra.383 rbp))
         (x.11 (rdx tmp.139 |+.53| c.124 ra.383 rbp))
         (|+.53| (rsi rdx rbp ra.383 x.11))
         (tmp.139 (x.11 ra.383 rbp))
         (rdx (r15 rdi rsi x.11 |+.53| ra.383 rbp))
         (r15 (rdi rsi rdx rbp))))
        (undead-out
            ((rdi rsi ra.383 rbp)
            (rsi c.124 ra.383 rbp)
            (c.124 x.11 ra.383 rbp)
            (x.11 |+.53| ra.383 rbp)
            (x.11 |+.53| ra.383 rbp)
            (x.11 |+.53| ra.383 rdx rbp)
            (|+.53| ra.383 rsi rdx rbp)
            (ra.383 rdi rsi rdx rbp)
            (rdi rsi rdx r15 rbp)
            (rdi rsi rdx r15 rbp)))
       (assignment
        ((ra.383 r15) (x.11 r14) (|+.53| r13) (c.124 r13) (tmp.139 r13))))
      (begin
        (set! ra.383 r15)
        (set! c.124 rdi)
        (set! x.11 rsi)
        (set! |+.53| (mref c.124 14))
        (set! tmp.139 |+.53|)
        (set! rdx 8)
        (set! rsi x.11)
        (set! rdi |+.53|)
        (set! r15 ra.383)
        (jump L.+.53.29 rbp r15 rdx rsi rdi)))))
    `(module (define L.inc.6.33 ,(list-no-order
                            `(assignment ,(list-no-order `(ra.383 r15) `(x.11 r14) `(|+.53| r13) `(c.124 r13) `(tmp.139 r13)))) 
                            ,_)))  

(check-match (assign-frame-variables `(module   
   (define L.main.5 
    ((locals (ra.12)) 
    (undead-out ((ra.12 rbp) (ra.12 fv0 rbp) (fv0 r15 rbp) (fv0 r15 rbp))) 
    (conflicts ((fv0 (ra.12)) (ra.12 (fv0))) (r15 (rbp)) (rbp (r15 ra.12)) (ra.12 (rbp))) 
    (assignment ()))   (begin
                               (set! ra.25 r15)
                               (jump L.s.1 rbp r15 fv0)))))
      `(module
        (define L.main.5
          ((assignment ((ra.12 fv1))))
          ,_)))
                                

#;(check-match (assign-frame-variables `(module     
    (define L.main.111
      ((locals
        (tmp.167
         tmp.372
         tmp.338
         vector-length.60
         tmp.166
         tmp.371
         tmp.337
         tmp.172
         tmp.377
         tmp.343
         <.55
         tmp.171
         tmp.376
         tmp.342
         <=.56
         tmp.170
         tmp.375
         tmp.341
         >.57
         tmp.169
         tmp.374
         tmp.340
         >=.58
         tmp.168
         tmp.373
         tmp.339
         tmp.173
         tmp.378
         tmp.344
         *.52
         tmp.174
         tmp.379
         tmp.345
         |+.53|
         |-.54|
         make-vector.59))
       (undead-out
        ((r12 rbp ra.349)
         (r12 tmp.316 rbp ra.349)
         (tmp.316 r12 rbp ra.349)
         (tmp.350 r12 rbp ra.349)
         (r12 rbp ra.349 tmp.145)
         (ra.349 rbp r12 tmp.145)
         (tmp.145 r12 rbp ra.349)
         (r12 rbp ra.349 unsafe-vector-ref.3)
         (r12 tmp.317 rbp ra.349 unsafe-vector-ref.3)
         (tmp.317 r12 rbp ra.349 unsafe-vector-ref.3)
         (tmp.351 r12 rbp ra.349 unsafe-vector-ref.3)
         (r12 rbp ra.349 unsafe-vector-ref.3 tmp.146)
         (unsafe-vector-ref.3 ra.349 rbp r12 tmp.146)
         (tmp.146 r12 rbp ra.349 unsafe-vector-ref.3)
         (r12 unsafe-vector-set!.2 rbp ra.349 unsafe-vector-ref.3)
         (r12 tmp.318 unsafe-vector-set!.2 rbp ra.349 unsafe-vector-ref.3)
         (tmp.318 r12 unsafe-vector-set!.2 rbp ra.349 unsafe-vector-ref.3)
         (tmp.352 r12 unsafe-vector-set!.2 rbp ra.349 unsafe-vector-ref.3)
         (r12 unsafe-vector-set!.2 rbp ra.349 unsafe-vector-ref.3 tmp.147)
         (unsafe-vector-ref.3 ra.349 rbp unsafe-vector-set!.2 r12 tmp.147)
         (tmp.147 r12 unsafe-vector-set!.2 rbp ra.349 unsafe-vector-ref.3)
         (r12
          unsafe-vector-set!.2
          rbp
          ra.349
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.319
          unsafe-vector-set!.2
          rbp
          ra.349
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.319
          r12
          unsafe-vector-set!.2
          rbp
          ra.349
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.353
          r12
          unsafe-vector-set!.2
          rbp
          ra.349
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          unsafe-vector-set!.2
          rbp
          ra.349
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.148)
         (vector-init-loop.80
          unsafe-vector-ref.3
          ra.349
          rbp
          unsafe-vector-set!.2
          r12
          tmp.148)
         (tmp.148
          r12
          unsafe-vector-set!.2
          rbp
          ra.349
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.349
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.320
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.349
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.320
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.349
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.354
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.349
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.349
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.149)
         (vector-init-loop.80
          unsafe-vector-ref.3
          ra.349
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.149)
         (tmp.149
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.349
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.321
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.321
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.355
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.150)
         (vector-init-loop.80
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.150)
         (tmp.150
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.322
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.322
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.356
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.151)
         (vector-init-loop.80
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          cons.76
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.151)
         (tmp.151
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.323
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.323
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.357
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.152)
         (vector-init-loop.80
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          cons.76
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.152)
         (tmp.152
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.324
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.324
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.358
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.153)
         (vector-init-loop.80
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          cons.76
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.153)
         (tmp.153
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.325
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.325
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.359
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.154)
         (vector-init-loop.80
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          cons.76
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.154)
         (tmp.154
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.326
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.326
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.360
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.155)
         (vector-init-loop.80
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          cons.76
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.155)
         (tmp.155
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.327
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.327
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.361
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.156)
         (vector-init-loop.80
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          cons.76
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.156)
         (tmp.156
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.328
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.328
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.362
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.157)
         (vector-init-loop.80
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          cons.76
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.157)
         (tmp.157
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.329
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.329
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.363
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.158)
         (vector-init-loop.80
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          cons.76
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.158)
         (tmp.158
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.330
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.330
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.364
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.159)
         (vector-init-loop.80
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          empty?.68
          cons.76
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.159)
         (tmp.159
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.331
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.331
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.365
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.160)
         (vector-init-loop.80
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          empty?.68
          cons.76
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.160)
         (tmp.160
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.332
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.332
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.366
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.161)
         (vector-init-loop.80
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          empty?.68
          cons.76
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.161)
         (tmp.161
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.333
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.333
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.367
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.162)
         (vector-init-loop.80
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          empty?.68
          cons.76
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.162)
         (tmp.162
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.334
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.334
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.368
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.163)
         (vector-init-loop.80
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          empty?.68
          cdr.64
          cons.76
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.163)
         (tmp.163
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          tmp.335
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.335
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (tmp.369
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80
          tmp.164)
         (vector-init-loop.80
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.164)
         (tmp.164
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          tmp.336
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.336
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.370
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80
          tmp.165)
         (vector-init-loop.80
          vector-ref.62
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.165)
         (tmp.165
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          tmp.337
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.337
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.371
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80
          tmp.166)
         (vector-init-loop.80
          vector-ref.62
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          unsafe-vector-set!.2
          vector-set!.61
          make-init-vector.1
          r12
          tmp.166)
         (tmp.166
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          tmp.338
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.338
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.372
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80
          tmp.167)
         (vector-init-loop.80
          vector-ref.62
          unsafe-vector-ref.3
          eq?.77
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          unsafe-vector-set!.2
          vector-set!.61
          make-init-vector.1
          r12
          tmp.167)
         (tmp.167
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          tmp.339
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.339
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.373
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80
          tmp.168)
         (vector-init-loop.80
          vector-ref.62
          unsafe-vector-ref.3
          make-vector.59
          eq?.77
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          unsafe-vector-set!.2
          vector-set!.61
          make-init-vector.1
          r12
          tmp.168)
         (tmp.168
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          tmp.340
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.340
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.374
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80
          tmp.169)
         (vector-init-loop.80
          vector-ref.62
          unsafe-vector-ref.3
          make-vector.59
          eq?.77
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          unsafe-vector-set!.2
          vector-set!.61
          make-init-vector.1
          r12
          tmp.169)
         (tmp.169
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          tmp.341
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.341
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.375
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80
          tmp.170)
         (vector-init-loop.80
          vector-ref.62
          unsafe-vector-ref.3
          make-vector.59
          eq?.77
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          unsafe-vector-set!.2
          vector-set!.61
          make-init-vector.1
          r12
          tmp.170)
         (tmp.170
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          tmp.342
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.342
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.376
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80
          tmp.171)
         (vector-init-loop.80
          vector-ref.62
          unsafe-vector-ref.3
          make-vector.59
          eq?.77
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          unsafe-vector-set!.2
          vector-set!.61
          make-init-vector.1
          r12
          tmp.171)
         (tmp.171
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          tmp.343
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.343
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.377
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80
          tmp.172)
         (vector-init-loop.80
          vector-ref.62
          unsafe-vector-ref.3
          make-vector.59
          eq?.77
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          unsafe-vector-set!.2
          vector-set!.61
          make-init-vector.1
          r12
          tmp.172)
         (tmp.172
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          |-.54|
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          tmp.344
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          |-.54|
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.344
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          |-.54|
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.378
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          |-.54|
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          |-.54|
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80
          tmp.173)
         (vector-init-loop.80
          vector-ref.62
          unsafe-vector-ref.3
          make-vector.59
          |-.54|
          eq?.77
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          unsafe-vector-set!.2
          vector-set!.61
          make-init-vector.1
          r12
          tmp.173)
         (tmp.173
          r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          eq?.77
          |-.54|
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          |+.53|
          eq?.77
          |-.54|
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (r12
          tmp.345
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          |+.53|
          eq?.77
          |-.54|
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.345
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          |+.53|
          eq?.77
          |-.54|
          r12
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (tmp.379
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          |+.53|
          eq?.77
          |-.54|
          r12
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          |+.53|
          eq?.77
          |-.54|
          r12
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80
          tmp.174)
         (vector-init-loop.80
          vector-ref.62
          unsafe-vector-ref.3
          make-vector.59
          r12
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          unsafe-vector-set!.2
          vector-set!.61
          make-init-vector.1
          tmp.174)
         (tmp.174
          make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          |+.53|
          eq?.77
          |-.54|
          r12
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (make-init-vector.1
          vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          |+.53|
          eq?.77
          |-.54|
          r12
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62
          vector-init-loop.80)
         (vector-ref.62
          unsafe-vector-ref.3
          make-vector.59
          r12
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          unsafe-vector-set!.2
          vector-set!.61
          vector-init-loop.80
          make-init-vector.1)
         (vector-set!.61
          unsafe-vector-set!.2
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          |+.53|
          eq?.77
          |-.54|
          r12
          make-init-vector.1
          make-vector.59
          unsafe-vector-ref.3
          vector-ref.62)
         (make-vector.59
          make-init-vector.1
          r12
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          unsafe-vector-set!.2
          vector-set!.61)
         (cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          |+.53|
          eq?.77
          |-.54|
          r12
          make-init-vector.1
          make-vector.59)
         (r12 |-.54| eq?.77 |+.53| ra.349 rbp empty?.68 car.63 cdr.64 cons.76)
         (r12
          tmp.346
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76)
         (tmp.346
          r12
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76)
         (tmp.380
          r12
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76)
         (r12
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          tmp.175)
         (cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          |+.53|
          eq?.77
          |-.54|
          r12
          tmp.175)
         (tmp.175
          r12
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76)
         (r12
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          zeros.4)
         (r12
          tmp.347
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          zeros.4)
         (tmp.347
          r12
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          zeros.4)
         (tmp.381
          r12
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          zeros.4)
         (r12
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          zeros.4
          tmp.176)
         (zeros.4
          cons.76
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          |+.53|
          eq?.77
          |-.54|
          r12
          tmp.176)
         (tmp.176
          r12
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          cons.76
          zeros.4)
         (r12
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          map.5
          cons.76
          zeros.4)
         (r12
          tmp.348
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          map.5
          cons.76
          zeros.4)
         (tmp.348
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          map.5
          cons.76
          zeros.4)
         (tmp.382
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          map.5
          cons.76
          zeros.4)
         (|-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          map.5
          cons.76
          zeros.4
          tmp.177)
         (zeros.4
          cons.76
          map.5
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          |+.53|
          eq?.77
          |-.54|
          tmp.177)
         (tmp.177
          |-.54|
          eq?.77
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          map.5
          cons.76
          zeros.4)
         (|-.54|
          eq?.77
          inc.6
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          map.5
          cons.76
          zeros.4)
         (map.5
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          |+.53|
          inc.6
          cons.76
          eq?.77
          |-.54|
          zeros.4)
         (eq?.77
          cons.76
          inc.6
          |+.53|
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          map.5
          zeros.4)
         (map.5
          cdr.64
          car.63
          empty?.68
          rbp
          ra.349
          |+.53|
          inc.6
          cons.76
          eq?.77
          zeros.4)
         (cons.76
          inc.6
          |+.53|
          zeros.4
          ra.349
          rbp
          empty?.68
          car.63
          cdr.64
          map.5)
         (car.63 empty?.68 rbp ra.349 zeros.4 |+.53| inc.6 cons.76 map.5)
         (cons.76 inc.6 |+.53| zeros.4 ra.349 rbp empty?.68 car.63 map.5)
         (empty?.68 rbp ra.349 zeros.4 |+.53| inc.6 cons.76 map.5)
         (inc.6 |+.53| zeros.4 ra.349 rbp empty?.68 map.5)
         (rbp ra.349 map.5 zeros.4 |+.53| inc.6)
         (zeros.4 map.5 inc.6 ra.349 rbp)
         (zeros.4 map.5 inc.6 ra.349 rbp)
         ((rax map.5 inc.6 ra.349 rbp)
          ((zeros.4 rdx rbp)
           (zeros.4 rsi rdx rbp)
           (rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))
         (map.5 inc.6 listofZero.12 ra.349 rbp)
         (map.5 inc.6 listofZero.12 ra.349 rbp)
         ((rax ra.349 rbp)
          ((inc.6 map.5 rdx rbp)
           (map.5 rsi rdx rbp)
           (rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))
         (ones.13 ra.349 rbp)
         (ra.349 rax rbp)
         (rax rbp)))
       (conflicts
        ((ra.349
          (ones.13
           tmp.141
           listofZero.12
           rax
           tmp.140
           inc.6
           tmp.177
           tmp.382
           tmp.348
           map.5
           tmp.176
           tmp.381
           tmp.347
           zeros.4
           tmp.175
           tmp.380
           tmp.346
           *.52
           tmp.174
           tmp.379
           tmp.345
           |+.53|
           tmp.173
           tmp.378
           tmp.344
           |-.54|
           tmp.172
           tmp.377
           tmp.343
           <.55
           tmp.171
           tmp.376
           tmp.342
           <=.56
           tmp.170
           tmp.375
           tmp.341
           >.57
           tmp.169
           tmp.374
           tmp.340
           >=.58
           tmp.168
           tmp.373
           tmp.339
           make-vector.59
           tmp.167
           tmp.372
           tmp.338
           vector-length.60
           tmp.166
           tmp.371
           tmp.337
           vector-set!.61
           tmp.165
           tmp.370
           tmp.336
           vector-ref.62
           tmp.164
           tmp.369
           tmp.335
           car.63
           tmp.163
           tmp.368
           tmp.334
           cdr.64
           tmp.162
           tmp.367
           tmp.333
           procedure-arity.65
           tmp.161
           tmp.366
           tmp.332
           fixnum?.66
           tmp.160
           tmp.365
           tmp.331
           boolean?.67
           tmp.159
           tmp.364
           tmp.330
           empty?.68
           tmp.158
           tmp.363
           tmp.329
           void?.69
           tmp.157
           tmp.362
           tmp.328
           ascii-char?.70
           tmp.156
           tmp.361
           tmp.327
           error?.71
           tmp.155
           tmp.360
           tmp.326
           pair?.72
           tmp.154
           tmp.359
           tmp.325
           procedure?.73
           tmp.153
           tmp.358
           tmp.324
           vector?.74
           tmp.152
           tmp.357
           tmp.323
           not.75
           tmp.151
           tmp.356
           tmp.322
           cons.76
           tmp.150
           tmp.355
           tmp.321
           eq?.77
           tmp.149
           tmp.354
           tmp.320
           make-init-vector.1
           tmp.148
           tmp.353
           tmp.319
           vector-init-loop.80
           tmp.147
           tmp.352
           tmp.318
           unsafe-vector-set!.2
           tmp.146
           tmp.351
           tmp.317
           unsafe-vector-ref.3
           tmp.145
           tmp.350
           tmp.316
           r12
           rbp))
         (rbp
          (ones.13
           tmp.141
           listofZero.12
           r15
           rdi
           rsi
           rdx
           rax
           tmp.140
           inc.6
           tmp.177
           tmp.382
           tmp.348
           map.5
           tmp.176
           tmp.381
           tmp.347
           zeros.4
           tmp.175
           tmp.380
           tmp.346
           *.52
           tmp.174
           tmp.379
           tmp.345
           |+.53|
           tmp.173
           tmp.378
           tmp.344
           |-.54|
           tmp.172
           tmp.377
           tmp.343
           <.55
           tmp.171
           tmp.376
           tmp.342
           <=.56
           tmp.170
           tmp.375
           tmp.341
           >.57
           tmp.169
           tmp.374
           tmp.340
           >=.58
           tmp.168
           tmp.373
           tmp.339
           make-vector.59
           tmp.167
           tmp.372
           tmp.338
           vector-length.60
           tmp.166
           tmp.371
           tmp.337
           vector-set!.61
           tmp.165
           tmp.370
           tmp.336
           vector-ref.62
           tmp.164
           tmp.369
           tmp.335
           car.63
           tmp.163
           tmp.368
           tmp.334
           cdr.64
           tmp.162
           tmp.367
           tmp.333
           procedure-arity.65
           tmp.161
           tmp.366
           tmp.332
           fixnum?.66
           tmp.160
           tmp.365
           tmp.331
           boolean?.67
           tmp.159
           tmp.364
           tmp.330
           empty?.68
           tmp.158
           tmp.363
           tmp.329
           void?.69
           tmp.157
           tmp.362
           tmp.328
           ascii-char?.70
           tmp.156
           tmp.361
           tmp.327
           error?.71
           tmp.155
           tmp.360
           tmp.326
           pair?.72
           tmp.154
           tmp.359
           tmp.325
           procedure?.73
           tmp.153
           tmp.358
           tmp.324
           vector?.74
           tmp.152
           tmp.357
           tmp.323
           not.75
           tmp.151
           tmp.356
           tmp.322
           cons.76
           tmp.150
           tmp.355
           tmp.321
           eq?.77
           tmp.149
           tmp.354
           tmp.320
           make-init-vector.1
           tmp.148
           tmp.353
           tmp.319
           vector-init-loop.80
           tmp.147
           tmp.352
           tmp.318
           unsafe-vector-set!.2
           tmp.146
           tmp.351
           tmp.317
           unsafe-vector-ref.3
           tmp.145
           tmp.350
           r12
           tmp.316
           ra.349))
         (r12
          (tmp.348
           map.5
           tmp.176
           tmp.381
           tmp.347
           zeros.4
           tmp.175
           tmp.380
           tmp.346
           *.52
           tmp.174
           tmp.379
           tmp.345
           |+.53|
           tmp.173
           tmp.378
           tmp.344
           |-.54|
           tmp.172
           tmp.377
           tmp.343
           <.55
           tmp.171
           tmp.376
           tmp.342
           <=.56
           tmp.170
           tmp.375
           tmp.341
           >.57
           tmp.169
           tmp.374
           tmp.340
           >=.58
           tmp.168
           tmp.373
           tmp.339
           make-vector.59
           tmp.167
           tmp.372
           tmp.338
           vector-length.60
           tmp.166
           tmp.371
           tmp.337
           vector-set!.61
           tmp.165
           tmp.370
           tmp.336
           vector-ref.62
           tmp.164
           tmp.369
           tmp.335
           car.63
           tmp.163
           tmp.368
           tmp.334
           cdr.64
           tmp.162
           tmp.367
           tmp.333
           procedure-arity.65
           tmp.161
           tmp.366
           tmp.332
           fixnum?.66
           tmp.160
           tmp.365
           tmp.331
           boolean?.67
           tmp.159
           tmp.364
           tmp.330
           empty?.68
           tmp.158
           tmp.363
           tmp.329
           void?.69
           tmp.157
           tmp.362
           tmp.328
           ascii-char?.70
           tmp.156
           tmp.361
           tmp.327
           error?.71
           tmp.155
           tmp.360
           tmp.326
           pair?.72
           tmp.154
           tmp.359
           tmp.325
           procedure?.73
           tmp.153
           tmp.358
           tmp.324
           vector?.74
           tmp.152
           tmp.357
           tmp.323
           not.75
           tmp.151
           tmp.356
           tmp.322
           cons.76
           tmp.150
           tmp.355
           tmp.321
           eq?.77
           tmp.149
           tmp.354
           tmp.320
           make-init-vector.1
           tmp.148
           tmp.353
           tmp.319
           vector-init-loop.80
           tmp.147
           tmp.352
           tmp.318
           unsafe-vector-set!.2
           tmp.146
           tmp.351
           tmp.317
           unsafe-vector-ref.3
           tmp.145
           tmp.350
           rbp
           tmp.316
           ra.349))
         (tmp.316 (r12 rbp ra.349))
         (tmp.350 (ra.349 rbp r12))
         (tmp.145 (r12 rbp ra.349))
         (unsafe-vector-ref.3
          (*.52
           tmp.174
           tmp.379
           tmp.345
           |+.53|
           tmp.173
           tmp.378
           tmp.344
           |-.54|
           tmp.172
           tmp.377
           tmp.343
           <.55
           tmp.171
           tmp.376
           tmp.342
           <=.56
           tmp.170
           tmp.375
           tmp.341
           >.57
           tmp.169
           tmp.374
           tmp.340
           >=.58
           tmp.168
           tmp.373
           tmp.339
           make-vector.59
           tmp.167
           tmp.372
           tmp.338
           vector-length.60
           tmp.166
           tmp.371
           tmp.337
           vector-set!.61
           tmp.165
           tmp.370
           tmp.336
           vector-ref.62
           tmp.164
           tmp.369
           tmp.335
           car.63
           tmp.163
           tmp.368
           tmp.334
           cdr.64
           tmp.162
           tmp.367
           tmp.333
           procedure-arity.65
           tmp.161
           tmp.366
           tmp.332
           fixnum?.66
           tmp.160
           tmp.365
           tmp.331
           boolean?.67
           tmp.159
           tmp.364
           tmp.330
           empty?.68
           tmp.158
           tmp.363
           tmp.329
           void?.69
           tmp.157
           tmp.362
           tmp.328
           ascii-char?.70
           tmp.156
           tmp.361
           tmp.327
           error?.71
           tmp.155
           tmp.360
           tmp.326
           pair?.72
           tmp.154
           tmp.359
           tmp.325
           procedure?.73
           tmp.153
           tmp.358
           tmp.324
           vector?.74
           tmp.152
           tmp.357
           tmp.323
           not.75
           tmp.151
           tmp.356
           tmp.322
           cons.76
           tmp.150
           tmp.355
           tmp.321
           eq?.77
           tmp.149
           tmp.354
           tmp.320
           make-init-vector.1
           tmp.148
           tmp.353
           tmp.319
           vector-init-loop.80
           tmp.147
           tmp.352
           tmp.318
           unsafe-vector-set!.2
           tmp.146
           tmp.351
           tmp.317
           r12
           rbp
           ra.349))
         (tmp.317 (r12 rbp ra.349 unsafe-vector-ref.3))
         (tmp.351 (unsafe-vector-ref.3 ra.349 rbp r12))
         (tmp.146 (r12 rbp ra.349 unsafe-vector-ref.3))
         (unsafe-vector-set!.2
          (*.52
           tmp.174
           tmp.379
           tmp.345
           |+.53|
           tmp.173
           tmp.378
           tmp.344
           |-.54|
           tmp.172
           tmp.377
           tmp.343
           <.55
           tmp.171
           tmp.376
           tmp.342
           <=.56
           tmp.170
           tmp.375
           tmp.341
           >.57
           tmp.169
           tmp.374
           tmp.340
           >=.58
           tmp.168
           tmp.373
           tmp.339
           make-vector.59
           tmp.167
           tmp.372
           tmp.338
           vector-length.60
           tmp.166
           tmp.371
           tmp.337
           vector-set!.61
           tmp.165
           tmp.370
           tmp.336
           vector-ref.62
           tmp.164
           tmp.369
           tmp.335
           car.63
           tmp.163
           tmp.368
           tmp.334
           cdr.64
           tmp.162
           tmp.367
           tmp.333
           procedure-arity.65
           tmp.161
           tmp.366
           tmp.332
           fixnum?.66
           tmp.160
           tmp.365
           tmp.331
           boolean?.67
           tmp.159
           tmp.364
           tmp.330
           empty?.68
           tmp.158
           tmp.363
           tmp.329
           void?.69
           tmp.157
           tmp.362
           tmp.328
           ascii-char?.70
           tmp.156
           tmp.361
           tmp.327
           error?.71
           tmp.155
           tmp.360
           tmp.326
           pair?.72
           tmp.154
           tmp.359
           tmp.325
           procedure?.73
           tmp.153
           tmp.358
           tmp.324
           vector?.74
           tmp.152
           tmp.357
           tmp.323
           not.75
           tmp.151
           tmp.356
           tmp.322
           cons.76
           tmp.150
           tmp.355
           tmp.321
           eq?.77
           tmp.149
           tmp.354
           tmp.320
           make-init-vector.1
           tmp.148
           tmp.353
           tmp.319
           vector-init-loop.80
           tmp.147
           tmp.352
           tmp.318
           r12
           rbp
           ra.349
           unsafe-vector-ref.3))
         (tmp.318 (r12 unsafe-vector-set!.2 rbp ra.349 unsafe-vector-ref.3))
         (tmp.352 (unsafe-vector-ref.3 ra.349 rbp unsafe-vector-set!.2 r12))
         (tmp.147 (r12 unsafe-vector-set!.2 rbp ra.349 unsafe-vector-ref.3))
         (vector-init-loop.80
          (*.52
           tmp.174
           tmp.379
           tmp.345
           |+.53|
           tmp.173
           tmp.378
           tmp.344
           |-.54|
           tmp.172
           tmp.377
           tmp.343
           <.55
           tmp.171
           tmp.376
           tmp.342
           <=.56
           tmp.170
           tmp.375
           tmp.341
           >.57
           tmp.169
           tmp.374
           tmp.340
           >=.58
           tmp.168
           tmp.373
           tmp.339
           make-vector.59
           tmp.167
           tmp.372
           tmp.338
           vector-length.60
           tmp.166
           tmp.371
           tmp.337
           vector-set!.61
           tmp.165
           tmp.370
           tmp.336
           vector-ref.62
           tmp.164
           tmp.369
           tmp.335
           car.63
           tmp.163
           tmp.368
           tmp.334
           cdr.64
           tmp.162
           tmp.367
           tmp.333
           procedure-arity.65
           tmp.161
           tmp.366
           tmp.332
           fixnum?.66
           tmp.160
           tmp.365
           tmp.331
           boolean?.67
           tmp.159
           tmp.364
           tmp.330
           empty?.68
           tmp.158
           tmp.363
           tmp.329
           void?.69
           tmp.157
           tmp.362
           tmp.328
           ascii-char?.70
           tmp.156
           tmp.361
           tmp.327
           error?.71
           tmp.155
           tmp.360
           tmp.326
           pair?.72
           tmp.154
           tmp.359
           tmp.325
           procedure?.73
           tmp.153
           tmp.358
           tmp.324
           vector?.74
           tmp.152
           tmp.357
           tmp.323
           not.75
           tmp.151
           tmp.356
           tmp.322
           cons.76
           tmp.150
           tmp.355
           tmp.321
           eq?.77
           tmp.149
           tmp.354
           tmp.320
           make-init-vector.1
           tmp.148
           tmp.353
           tmp.319
           r12
           unsafe-vector-set!.2
           rbp
           ra.349
           unsafe-vector-ref.3))
         (tmp.319
          (r12
           unsafe-vector-set!.2
           rbp
           ra.349
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.353
          (vector-init-loop.80
           unsafe-vector-ref.3
           ra.349
           rbp
           unsafe-vector-set!.2
           r12))
         (tmp.148
          (r12
           unsafe-vector-set!.2
           rbp
           ra.349
           unsafe-vector-ref.3
           vector-init-loop.80))
         (make-init-vector.1
          (*.52
           tmp.174
           tmp.379
           tmp.345
           |+.53|
           tmp.173
           tmp.378
           tmp.344
           |-.54|
           tmp.172
           tmp.377
           tmp.343
           <.55
           tmp.171
           tmp.376
           tmp.342
           <=.56
           tmp.170
           tmp.375
           tmp.341
           >.57
           tmp.169
           tmp.374
           tmp.340
           >=.58
           tmp.168
           tmp.373
           tmp.339
           make-vector.59
           tmp.167
           tmp.372
           tmp.338
           vector-length.60
           tmp.166
           tmp.371
           tmp.337
           vector-set!.61
           tmp.165
           tmp.370
           tmp.336
           vector-ref.62
           tmp.164
           tmp.369
           tmp.335
           car.63
           tmp.163
           tmp.368
           tmp.334
           cdr.64
           tmp.162
           tmp.367
           tmp.333
           procedure-arity.65
           tmp.161
           tmp.366
           tmp.332
           fixnum?.66
           tmp.160
           tmp.365
           tmp.331
           boolean?.67
           tmp.159
           tmp.364
           tmp.330
           empty?.68
           tmp.158
           tmp.363
           tmp.329
           void?.69
           tmp.157
           tmp.362
           tmp.328
           ascii-char?.70
           tmp.156
           tmp.361
           tmp.327
           error?.71
           tmp.155
           tmp.360
           tmp.326
           pair?.72
           tmp.154
           tmp.359
           tmp.325
           procedure?.73
           tmp.153
           tmp.358
           tmp.324
           vector?.74
           tmp.152
           tmp.357
           tmp.323
           not.75
           tmp.151
           tmp.356
           tmp.322
           cons.76
           tmp.150
           tmp.355
           tmp.321
           eq?.77
           tmp.149
           tmp.354
           tmp.320
           r12
           unsafe-vector-set!.2
           rbp
           ra.349
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.320
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.349
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.354
          (vector-init-loop.80
           unsafe-vector-ref.3
           ra.349
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.149
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.349
           unsafe-vector-ref.3
           vector-init-loop.80))
         (eq?.77
          (inc.6
           tmp.177
           tmp.382
           tmp.348
           map.5
           tmp.176
           tmp.381
           tmp.347
           zeros.4
           tmp.175
           tmp.380
           tmp.346
           *.52
           tmp.174
           tmp.379
           tmp.345
           |+.53|
           tmp.173
           tmp.378
           tmp.344
           |-.54|
           tmp.172
           tmp.377
           tmp.343
           <.55
           tmp.171
           tmp.376
           tmp.342
           <=.56
           tmp.170
           tmp.375
           tmp.341
           >.57
           tmp.169
           tmp.374
           tmp.340
           >=.58
           tmp.168
           tmp.373
           tmp.339
           make-vector.59
           tmp.167
           tmp.372
           tmp.338
           vector-length.60
           tmp.166
           tmp.371
           tmp.337
           vector-set!.61
           tmp.165
           tmp.370
           tmp.336
           vector-ref.62
           tmp.164
           tmp.369
           tmp.335
           car.63
           tmp.163
           tmp.368
           tmp.334
           cdr.64
           tmp.162
           tmp.367
           tmp.333
           procedure-arity.65
           tmp.161
           tmp.366
           tmp.332
           fixnum?.66
           tmp.160
           tmp.365
           tmp.331
           boolean?.67
           tmp.159
           tmp.364
           tmp.330
           empty?.68
           tmp.158
           tmp.363
           tmp.329
           void?.69
           tmp.157
           tmp.362
           tmp.328
           ascii-char?.70
           tmp.156
           tmp.361
           tmp.327
           error?.71
           tmp.155
           tmp.360
           tmp.326
           pair?.72
           tmp.154
           tmp.359
           tmp.325
           procedure?.73
           tmp.153
           tmp.358
           tmp.324
           vector?.74
           tmp.152
           tmp.357
           tmp.323
           not.75
           tmp.151
           tmp.356
           tmp.322
           cons.76
           tmp.150
           tmp.355
           tmp.321
           r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.349
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.321
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.355
          (vector-init-loop.80
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.150
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (cons.76
          (inc.6
           tmp.177
           tmp.382
           tmp.348
           map.5
           tmp.176
           tmp.381
           tmp.347
           zeros.4
           tmp.175
           tmp.380
           tmp.346
           *.52
           tmp.174
           tmp.379
           tmp.345
           |+.53|
           tmp.173
           tmp.378
           tmp.344
           |-.54|
           tmp.172
           tmp.377
           tmp.343
           <.55
           tmp.171
           tmp.376
           tmp.342
           <=.56
           tmp.170
           tmp.375
           tmp.341
           >.57
           tmp.169
           tmp.374
           tmp.340
           >=.58
           tmp.168
           tmp.373
           tmp.339
           make-vector.59
           tmp.167
           tmp.372
           tmp.338
           vector-length.60
           tmp.166
           tmp.371
           tmp.337
           vector-set!.61
           tmp.165
           tmp.370
           tmp.336
           vector-ref.62
           tmp.164
           tmp.369
           tmp.335
           car.63
           tmp.163
           tmp.368
           tmp.334
           cdr.64
           tmp.162
           tmp.367
           tmp.333
           procedure-arity.65
           tmp.161
           tmp.366
           tmp.332
           fixnum?.66
           tmp.160
           tmp.365
           tmp.331
           boolean?.67
           tmp.159
           tmp.364
           tmp.330
           empty?.68
           tmp.158
           tmp.363
           tmp.329
           void?.69
           tmp.157
           tmp.362
           tmp.328
           ascii-char?.70
           tmp.156
           tmp.361
           tmp.327
           error?.71
           tmp.155
           tmp.360
           tmp.326
           pair?.72
           tmp.154
           tmp.359
           tmp.325
           procedure?.73
           tmp.153
           tmp.358
           tmp.324
           vector?.74
           tmp.152
           tmp.357
           tmp.323
           not.75
           tmp.151
           tmp.356
           tmp.322
           r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.322
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.356
          (vector-init-loop.80
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           cons.76
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.151
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (not.75
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.323
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.357
          (vector-init-loop.80
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           cons.76
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.152
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (vector?.74
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.324
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.358
          (vector-init-loop.80
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           cons.76
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.153
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (procedure?.73
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.325
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.359
          (vector-init-loop.80
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           cons.76
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.154
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (pair?.72
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.326
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.360
          (vector-init-loop.80
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           cons.76
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.155
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (error?.71
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.327
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.361
          (vector-init-loop.80
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           cons.76
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.156
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (ascii-char?.70
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.328
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.362
          (vector-init-loop.80
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           cons.76
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.157
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (void?.69
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.329
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.363
          (vector-init-loop.80
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           cons.76
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.158
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (empty?.68
          (inc.6
           tmp.177
           tmp.382
           tmp.348
           map.5
           tmp.176
           tmp.381
           tmp.347
           zeros.4
           tmp.175
           tmp.380
           tmp.346
           *.52
           tmp.174
           tmp.379
           tmp.345
           |+.53|
           tmp.173
           tmp.378
           tmp.344
           |-.54|
           tmp.172
           tmp.377
           tmp.343
           <.55
           tmp.171
           tmp.376
           tmp.342
           <=.56
           tmp.170
           tmp.375
           tmp.341
           >.57
           tmp.169
           tmp.374
           tmp.340
           >=.58
           tmp.168
           tmp.373
           tmp.339
           make-vector.59
           tmp.167
           tmp.372
           tmp.338
           vector-length.60
           tmp.166
           tmp.371
           tmp.337
           vector-set!.61
           tmp.165
           tmp.370
           tmp.336
           vector-ref.62
           tmp.164
           tmp.369
           tmp.335
           car.63
           tmp.163
           tmp.368
           tmp.334
           cdr.64
           tmp.162
           tmp.367
           tmp.333
           procedure-arity.65
           tmp.161
           tmp.366
           tmp.332
           fixnum?.66
           tmp.160
           tmp.365
           tmp.331
           boolean?.67
           tmp.159
           tmp.364
           tmp.330
           r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.330
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.364
          (vector-init-loop.80
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           empty?.68
           cons.76
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.159
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (boolean?.67
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.331
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.365
          (vector-init-loop.80
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           empty?.68
           cons.76
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.160
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (fixnum?.66
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.332
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.366
          (vector-init-loop.80
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           empty?.68
           cons.76
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.161
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (procedure-arity.65
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.333
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.367
          (vector-init-loop.80
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           empty?.68
           cons.76
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.162
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (cdr.64
          (inc.6
           tmp.177
           tmp.382
           tmp.348
           map.5
           tmp.176
           tmp.381
           tmp.347
           zeros.4
           tmp.175
           tmp.380
           tmp.346
           *.52
           tmp.174
           tmp.379
           tmp.345
           |+.53|
           tmp.173
           tmp.378
           tmp.344
           |-.54|
           tmp.172
           tmp.377
           tmp.343
           <.55
           tmp.171
           tmp.376
           tmp.342
           <=.56
           tmp.170
           tmp.375
           tmp.341
           >.57
           tmp.169
           tmp.374
           tmp.340
           >=.58
           tmp.168
           tmp.373
           tmp.339
           make-vector.59
           tmp.167
           tmp.372
           tmp.338
           vector-length.60
           tmp.166
           tmp.371
           tmp.337
           vector-set!.61
           tmp.165
           tmp.370
           tmp.336
           vector-ref.62
           tmp.164
           tmp.369
           tmp.335
           car.63
           tmp.163
           tmp.368
           tmp.334
           r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.334
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           cdr.64
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.368
          (vector-init-loop.80
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           empty?.68
           cdr.64
           cons.76
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.163
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           cdr.64
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (car.63
          (inc.6
           tmp.177
           tmp.382
           tmp.348
           map.5
           tmp.176
           tmp.381
           tmp.347
           zeros.4
           tmp.175
           tmp.380
           tmp.346
           *.52
           tmp.174
           tmp.379
           tmp.345
           |+.53|
           tmp.173
           tmp.378
           tmp.344
           |-.54|
           tmp.172
           tmp.377
           tmp.343
           <.55
           tmp.171
           tmp.376
           tmp.342
           <=.56
           tmp.170
           tmp.375
           tmp.341
           >.57
           tmp.169
           tmp.374
           tmp.340
           >=.58
           tmp.168
           tmp.373
           tmp.339
           make-vector.59
           tmp.167
           tmp.372
           tmp.338
           vector-length.60
           tmp.166
           tmp.371
           tmp.337
           vector-set!.61
           tmp.165
           tmp.370
           tmp.336
           vector-ref.62
           tmp.164
           tmp.369
           tmp.335
           r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           cdr.64
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.335
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.369
          (vector-init-loop.80
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.164
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (vector-ref.62
          (*.52
           tmp.174
           tmp.379
           tmp.345
           |+.53|
           tmp.173
           tmp.378
           tmp.344
           |-.54|
           tmp.172
           tmp.377
           tmp.343
           <.55
           tmp.171
           tmp.376
           tmp.342
           <=.56
           tmp.170
           tmp.375
           tmp.341
           >.57
           tmp.169
           tmp.374
           tmp.340
           >=.58
           tmp.168
           tmp.373
           tmp.339
           make-vector.59
           tmp.167
           tmp.372
           tmp.338
           vector-length.60
           tmp.166
           tmp.371
           tmp.337
           vector-set!.61
           tmp.165
           tmp.370
           tmp.336
           r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-init-loop.80))
         (tmp.336
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.370
          (vector-init-loop.80
           vector-ref.62
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.165
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (vector-set!.61
          (*.52
           tmp.174
           tmp.379
           tmp.345
           |+.53|
           tmp.173
           tmp.378
           tmp.344
           |-.54|
           tmp.172
           tmp.377
           tmp.343
           <.55
           tmp.171
           tmp.376
           tmp.342
           <=.56
           tmp.170
           tmp.375
           tmp.341
           >.57
           tmp.169
           tmp.374
           tmp.340
           >=.58
           tmp.168
           tmp.373
           tmp.339
           make-vector.59
           tmp.167
           tmp.372
           tmp.338
           vector-length.60
           tmp.166
           tmp.371
           tmp.337
           r12
           make-init-vector.1
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.337
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.371
          (vector-init-loop.80
           vector-ref.62
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76
           unsafe-vector-set!.2
           vector-set!.61
           make-init-vector.1
           r12))
         (tmp.166
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (vector-length.60
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.338
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.372
          (vector-init-loop.80
           vector-ref.62
           unsafe-vector-ref.3
           eq?.77
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76
           unsafe-vector-set!.2
           vector-set!.61
           make-init-vector.1
           r12))
         (tmp.167
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (make-vector.59
          (*.52
           tmp.174
           tmp.379
           tmp.345
           |+.53|
           tmp.173
           tmp.378
           tmp.344
           |-.54|
           tmp.172
           tmp.377
           tmp.343
           <.55
           tmp.171
           tmp.376
           tmp.342
           <=.56
           tmp.170
           tmp.375
           tmp.341
           >.57
           tmp.169
           tmp.374
           tmp.340
           >=.58
           tmp.168
           tmp.373
           tmp.339
           r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.339
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.373
          (vector-init-loop.80
           vector-ref.62
           unsafe-vector-ref.3
           make-vector.59
           eq?.77
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76
           unsafe-vector-set!.2
           vector-set!.61
           make-init-vector.1
           r12))
         (tmp.168
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (>=.58
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.340
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.374
          (vector-init-loop.80
           vector-ref.62
           unsafe-vector-ref.3
           make-vector.59
           eq?.77
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76
           unsafe-vector-set!.2
           vector-set!.61
           make-init-vector.1
           r12))
         (tmp.169
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (>.57
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.341
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.375
          (vector-init-loop.80
           vector-ref.62
           unsafe-vector-ref.3
           make-vector.59
           eq?.77
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76
           unsafe-vector-set!.2
           vector-set!.61
           make-init-vector.1
           r12))
         (tmp.170
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (<=.56
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.342
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.376
          (vector-init-loop.80
           vector-ref.62
           unsafe-vector-ref.3
           make-vector.59
           eq?.77
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76
           unsafe-vector-set!.2
           vector-set!.61
           make-init-vector.1
           r12))
         (tmp.171
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (<.55
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.343
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.377
          (vector-init-loop.80
           vector-ref.62
           unsafe-vector-ref.3
           make-vector.59
           eq?.77
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76
           unsafe-vector-set!.2
           vector-set!.61
           make-init-vector.1
           r12))
         (tmp.172
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (|-.54|
          (inc.6
           tmp.177
           tmp.382
           tmp.348
           map.5
           tmp.176
           tmp.381
           tmp.347
           zeros.4
           tmp.175
           tmp.380
           tmp.346
           *.52
           tmp.174
           tmp.379
           tmp.345
           |+.53|
           tmp.173
           tmp.378
           tmp.344
           r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.344
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           |-.54|
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.378
          (vector-init-loop.80
           vector-ref.62
           unsafe-vector-ref.3
           make-vector.59
           |-.54|
           eq?.77
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76
           unsafe-vector-set!.2
           vector-set!.61
           make-init-vector.1
           r12))
         (tmp.173
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           |-.54|
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (|+.53|
          (inc.6
           tmp.177
           tmp.382
           tmp.348
           map.5
           tmp.176
           tmp.381
           tmp.347
           zeros.4
           tmp.175
           tmp.380
           tmp.346
           *.52
           tmp.174
           tmp.379
           tmp.345
           r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           eq?.77
           |-.54|
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.345
          (r12
           make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           |+.53|
           eq?.77
           |-.54|
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.379
          (vector-init-loop.80
           vector-ref.62
           unsafe-vector-ref.3
           make-vector.59
           r12
           |-.54|
           eq?.77
           |+.53|
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76
           unsafe-vector-set!.2
           vector-set!.61
           make-init-vector.1))
         (tmp.174
          (make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           |+.53|
           eq?.77
           |-.54|
           r12
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (*.52
          (make-init-vector.1
           vector-set!.61
           unsafe-vector-set!.2
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           |+.53|
           eq?.77
           |-.54|
           r12
           make-vector.59
           unsafe-vector-ref.3
           vector-ref.62
           vector-init-loop.80))
         (tmp.346
          (r12
           |-.54|
           eq?.77
           |+.53|
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76))
         (tmp.380
          (cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           |+.53|
           eq?.77
           |-.54|
           r12))
         (tmp.175
          (r12
           |-.54|
           eq?.77
           |+.53|
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76))
         (zeros.4
          (rsi
           rdx
           inc.6
           tmp.177
           tmp.382
           tmp.348
           map.5
           tmp.176
           tmp.381
           tmp.347
           r12
           |-.54|
           eq?.77
           |+.53|
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76))
         (tmp.347
          (r12
           |-.54|
           eq?.77
           |+.53|
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76
           zeros.4))
         (tmp.381
          (zeros.4
           cons.76
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           |+.53|
           eq?.77
           |-.54|
           r12))
         (tmp.176
          (r12
           |-.54|
           eq?.77
           |+.53|
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76
           zeros.4))
         (map.5
          (rsi
           rdx
           listofZero.12
           rax
           tmp.140
           inc.6
           tmp.177
           tmp.382
           tmp.348
           r12
           |-.54|
           eq?.77
           |+.53|
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           cons.76
           zeros.4))
         (tmp.348
          (r12
           |-.54|
           eq?.77
           |+.53|
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           map.5
           cons.76
           zeros.4))
         (tmp.382
          (zeros.4
           cons.76
           map.5
           cdr.64
           car.63
           empty?.68
           rbp
           ra.349
           |+.53|
           eq?.77
           |-.54|))
         (tmp.177
          (|-.54|
           eq?.77
           |+.53|
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           map.5
           cons.76
           zeros.4))
         (inc.6
          (rdx
           tmp.141
           listofZero.12
           rax
           tmp.140
           |-.54|
           eq?.77
           |+.53|
           ra.349
           rbp
           empty?.68
           car.63
           cdr.64
           map.5
           cons.76
           zeros.4))
         (tmp.140 (map.5 inc.6 ra.349 rbp))
         (rax (rbp ra.349 inc.6 map.5))
         (rdx (inc.6 map.5 r15 rdi rsi zeros.4 rbp))
         (rsi (map.5 r15 rdi zeros.4 rdx rbp))
         (rdi (r15 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (listofZero.12 (tmp.141 map.5 inc.6 ra.349 rbp))
         (tmp.141 (inc.6 listofZero.12 ra.349 rbp))
         (ones.13 (ra.349 rbp))))
       (assignment
        ((ra.349 fv0)
         (inc.6 fv1)
         (map.5 fv2)
         (unsafe-vector-ref.3 r15)
         (eq?.77 r14)
         (unsafe-vector-set!.2 r13)
         (cons.76 r9)
         (vector-init-loop.80 r8)
         (make-init-vector.1 rdi)
         (empty?.68 rsi)
         (cdr.64 rdx)
         (car.63 rcx)
         (vector-ref.62 rbx)
         (vector-set!.61 rsp)
         (zeros.4 r15)
         (tmp.336 rsp)
         (tmp.370 rsp)
         (tmp.165 rsp)
         (tmp.335 rbx)
         (tmp.369 rbx)
         (tmp.164 rbx)
         (tmp.348 r13)
         (tmp.334 rcx)
         (tmp.368 rcx)
         (tmp.163 rcx)
         (tmp.347 r13)
         (tmp.381 r13)
         (tmp.176 r13)
         (tmp.382 r13)
         (tmp.177 r13)
         (tmp.330 rdx)
         (tmp.364 rdx)
         (tmp.159 rdx)
         (boolean?.67 rdx)
         (tmp.331 rdx)
         (tmp.365 rdx)
         (tmp.160 rdx)
         (fixnum?.66 rdx)
         (tmp.332 rdx)
         (tmp.366 rdx)
         (tmp.161 rdx)
         (procedure-arity.65 rdx)
         (tmp.333 rdx)
         (tmp.367 rdx)
         (tmp.162 rdx)
         (tmp.346 r15)
         (tmp.380 r15)
         (tmp.175 r15)
         (tmp.322 rsi)
         (tmp.356 rsi)
         (tmp.151 rsi)
         (not.75 rsi)
         (tmp.323 rsi)
         (tmp.357 rsi)
         (tmp.152 rsi)
         (vector?.74 rsi)
         (tmp.324 rsi)
         (tmp.358 rsi)
         (tmp.153 rsi)
         (procedure?.73 rsi)
         (tmp.325 rsi)
         (tmp.359 rsi)
         (tmp.154 rsi)
         (pair?.72 rsi)
         (tmp.326 rsi)
         (tmp.360 rsi)
         (tmp.155 rsi)
         (error?.71 rsi)
         (tmp.327 rsi)
         (tmp.361 rsi)
         (tmp.156 rsi)
         (ascii-char?.70 rsi)
         (tmp.328 rsi)
         (tmp.362 rsi)
         (tmp.157 rsi)
         (void?.69 rsi)
         (tmp.329 rsi)
         (tmp.363 rsi)
         (tmp.158 rsi)
         (tmp.321 r9)
         (tmp.355 r9)
         (tmp.150 r9)
         (tmp.320 r14)
         (tmp.354 r14)
         (tmp.149 r14)
         (tmp.319 r14)
         (tmp.353 r14)
         (tmp.148 r14)
         (tmp.318 r14)
         (tmp.352 r14)
         (tmp.147 r14)
         (listofZero.12 r15)
         (tmp.317 r14)
         (tmp.351 r14)
         (tmp.146 r14)
         (tmp.140 r15)
         (tmp.141 r14)
         (tmp.316 r15)
         (tmp.350 r15)
         (tmp.145 r15)
         (ones.13 r15))))
      (begin
        (set! ra.349 r15)
        (set! tmp.316 r12)
        (set! r12 (+ r12 16))
        (set! tmp.350 (+ tmp.316 2))
        (set! tmp.145 tmp.350)
        (mset! tmp.145 -2 L.unsafe-vector-ref.3.1)
        (mset! tmp.145 6 16)
        (set! unsafe-vector-ref.3 tmp.145)
        (set! tmp.317 r12)
        (set! r12 (+ r12 16))
        (set! tmp.351 (+ tmp.317 2))
        (set! tmp.146 tmp.351)
        (mset! tmp.146 -2 L.unsafe-vector-set!.2.2)
        (mset! tmp.146 6 24)
        (set! unsafe-vector-set!.2 tmp.146)
        (set! tmp.318 r12)
        (set! r12 (+ r12 24))
        (set! tmp.352 (+ tmp.318 2))
        (set! tmp.147 tmp.352)
        (mset! tmp.147 -2 L.vector-init-loop.80.3)
        (mset! tmp.147 6 24)
        (set! vector-init-loop.80 tmp.147)
        (set! tmp.319 r12)
        (set! r12 (+ r12 24))
        (set! tmp.353 (+ tmp.319 2))
        (set! tmp.148 tmp.353)
        (mset! tmp.148 -2 L.make-init-vector.1.4)
        (mset! tmp.148 6 8)
        (set! make-init-vector.1 tmp.148)
        (set! tmp.320 r12)
        (set! r12 (+ r12 16))
        (set! tmp.354 (+ tmp.320 2))
        (set! tmp.149 tmp.354)
        (mset! tmp.149 -2 L.eq?.77.5)
        (mset! tmp.149 6 16)
        (set! eq?.77 tmp.149)
        (set! tmp.321 r12)
        (set! r12 (+ r12 16))
        (set! tmp.355 (+ tmp.321 2))
        (set! tmp.150 tmp.355)
        (mset! tmp.150 -2 L.cons.76.6)
        (mset! tmp.150 6 16)
        (set! cons.76 tmp.150)
        (set! tmp.322 r12)
        (set! r12 (+ r12 16))
        (set! tmp.356 (+ tmp.322 2))
        (set! tmp.151 tmp.356)
        (mset! tmp.151 -2 L.not.75.7)
        (mset! tmp.151 6 8)
        (set! not.75 tmp.151)
        (set! tmp.323 r12)
        (set! r12 (+ r12 16))
        (set! tmp.357 (+ tmp.323 2))
        (set! tmp.152 tmp.357)
        (mset! tmp.152 -2 L.vector?.74.8)
        (mset! tmp.152 6 8)
        (set! vector?.74 tmp.152)
        (set! tmp.324 r12)
        (set! r12 (+ r12 16))
        (set! tmp.358 (+ tmp.324 2))
        (set! tmp.153 tmp.358)
        (mset! tmp.153 -2 L.procedure?.73.9)
        (mset! tmp.153 6 8)
        (set! procedure?.73 tmp.153)
        (set! tmp.325 r12)
        (set! r12 (+ r12 16))
        (set! tmp.359 (+ tmp.325 2))
        (set! tmp.154 tmp.359)
        (mset! tmp.154 -2 L.pair?.72.10)
        (mset! tmp.154 6 8)
        (set! pair?.72 tmp.154)
        (set! tmp.326 r12)
        (set! r12 (+ r12 16))
        (set! tmp.360 (+ tmp.326 2))
        (set! tmp.155 tmp.360)
        (mset! tmp.155 -2 L.error?.71.11)
        (mset! tmp.155 6 8)
        (set! error?.71 tmp.155)
        (set! tmp.327 r12)
        (set! r12 (+ r12 16))
        (set! tmp.361 (+ tmp.327 2))
        (set! tmp.156 tmp.361)
        (mset! tmp.156 -2 L.ascii-char?.70.12)
        (mset! tmp.156 6 8)
        (set! ascii-char?.70 tmp.156)
        (set! tmp.328 r12)
        (set! r12 (+ r12 16))
        (set! tmp.362 (+ tmp.328 2))
        (set! tmp.157 tmp.362)
        (mset! tmp.157 -2 L.void?.69.13)
        (mset! tmp.157 6 8)
        (set! void?.69 tmp.157)
        (set! tmp.329 r12)
        (set! r12 (+ r12 16))
        (set! tmp.363 (+ tmp.329 2))
        (set! tmp.158 tmp.363)
        (mset! tmp.158 -2 L.empty?.68.14)
        (mset! tmp.158 6 8)
        (set! empty?.68 tmp.158)
        (set! tmp.330 r12)
        (set! r12 (+ r12 16))
        (set! tmp.364 (+ tmp.330 2))
        (set! tmp.159 tmp.364)
        (mset! tmp.159 -2 L.boolean?.67.15)
        (mset! tmp.159 6 8)
        (set! boolean?.67 tmp.159)
        (set! tmp.331 r12)
        (set! r12 (+ r12 16))
        (set! tmp.365 (+ tmp.331 2))
        (set! tmp.160 tmp.365)
        (mset! tmp.160 -2 L.fixnum?.66.16)
        (mset! tmp.160 6 8)
        (set! fixnum?.66 tmp.160)
        (set! tmp.332 r12)
        (set! r12 (+ r12 16))
        (set! tmp.366 (+ tmp.332 2))
        (set! tmp.161 tmp.366)
        (mset! tmp.161 -2 L.procedure-arity.65.17)
        (mset! tmp.161 6 8)
        (set! procedure-arity.65 tmp.161)
        (set! tmp.333 r12)
        (set! r12 (+ r12 16))
        (set! tmp.367 (+ tmp.333 2))
        (set! tmp.162 tmp.367)
        (mset! tmp.162 -2 L.cdr.64.18)
        (mset! tmp.162 6 8)
        (set! cdr.64 tmp.162)
        (set! tmp.334 r12)
        (set! r12 (+ r12 16))
        (set! tmp.368 (+ tmp.334 2))
        (set! tmp.163 tmp.368)
        (mset! tmp.163 -2 L.car.63.19)
        (mset! tmp.163 6 8)
        (set! car.63 tmp.163)
        (set! tmp.335 r12)
        (set! r12 (+ r12 24))
        (set! tmp.369 (+ tmp.335 2))
        (set! tmp.164 tmp.369)
        (mset! tmp.164 -2 L.vector-ref.62.20)
        (mset! tmp.164 6 16)
        (set! vector-ref.62 tmp.164)
        (set! tmp.336 r12)
        (set! r12 (+ r12 24))
        (set! tmp.370 (+ tmp.336 2))
        (set! tmp.165 tmp.370)
        (mset! tmp.165 -2 L.vector-set!.61.21)
        (mset! tmp.165 6 24)
        (set! vector-set!.61 tmp.165)
        (set! tmp.337 r12)
        (set! r12 (+ r12 16))
        (set! tmp.371 (+ tmp.337 2))
        (set! tmp.166 tmp.371)
        (mset! tmp.166 -2 L.vector-length.60.22)
        (mset! tmp.166 6 8)
        (set! vector-length.60 tmp.166)
        (set! tmp.338 r12)
        (set! r12 (+ r12 24))
        (set! tmp.372 (+ tmp.338 2))
        (set! tmp.167 tmp.372)
        (mset! tmp.167 -2 L.make-vector.59.23)
        (mset! tmp.167 6 8)
        (set! make-vector.59 tmp.167)
        (set! tmp.339 r12)
        (set! r12 (+ r12 16))
        (set! tmp.373 (+ tmp.339 2))
        (set! tmp.168 tmp.373)
        (mset! tmp.168 -2 L.>=.58.24)
        (mset! tmp.168 6 16)
        (set! >=.58 tmp.168)
        (set! tmp.340 r12)
        (set! r12 (+ r12 16))
        (set! tmp.374 (+ tmp.340 2))
        (set! tmp.169 tmp.374)
        (mset! tmp.169 -2 L.>.57.25)
        (mset! tmp.169 6 16)
        (set! >.57 tmp.169)
        (set! tmp.341 r12)
        (set! r12 (+ r12 16))
        (set! tmp.375 (+ tmp.341 2))
        (set! tmp.170 tmp.375)
        (mset! tmp.170 -2 L.<=.56.26)
        (mset! tmp.170 6 16)
        (set! <=.56 tmp.170)
        (set! tmp.342 r12)
        (set! r12 (+ r12 16))
        (set! tmp.376 (+ tmp.342 2))
        (set! tmp.171 tmp.376)
        (mset! tmp.171 -2 L.<.55.27)
        (mset! tmp.171 6 16)
        (set! <.55 tmp.171)
        (set! tmp.343 r12)
        (set! r12 (+ r12 16))
        (set! tmp.377 (+ tmp.343 2))
        (set! tmp.172 tmp.377)
        (mset! tmp.172 -2 L.-.54.28)
        (mset! tmp.172 6 16)
        (set! |-.54| tmp.172)
        (set! tmp.344 r12)
        (set! r12 (+ r12 16))
        (set! tmp.378 (+ tmp.344 2))
        (set! tmp.173 tmp.378)
        (mset! tmp.173 -2 L.+.53.29)
        (mset! tmp.173 6 16)
        (set! |+.53| tmp.173)
        (set! tmp.345 r12)
        (set! r12 (+ r12 16))
        (set! tmp.379 (+ tmp.345 2))
        (set! tmp.174 tmp.379)
        (mset! tmp.174 -2 L.*.52.30)
        (mset! tmp.174 6 16)
        (set! *.52 tmp.174)
        (mset! vector-init-loop.80 14 vector-init-loop.80)
        (mset! make-init-vector.1 14 vector-init-loop.80)
        (mset! vector-ref.62 14 unsafe-vector-ref.3)
        (mset! vector-set!.61 14 unsafe-vector-set!.2)
        (mset! make-vector.59 14 make-init-vector.1)
        (set! tmp.346 r12)
        (set! r12 (+ r12 48))
        (set! tmp.380 (+ tmp.346 2))
        (set! tmp.175 tmp.380)
        (mset! tmp.175 -2 L.zeros.4.31)
        (mset! tmp.175 6 16)
        (set! zeros.4 tmp.175)
        (set! tmp.347 r12)
        (set! r12 (+ r12 56))
        (set! tmp.381 (+ tmp.347 2))
        (set! tmp.176 tmp.381)
        (mset! tmp.176 -2 L.map.5.32)
        (mset! tmp.176 6 16)
        (set! map.5 tmp.176)
        (set! tmp.348 r12)
        (set! r12 (+ r12 24))
        (set! tmp.382 (+ tmp.348 2))
        (set! tmp.177 tmp.382)
        (mset! tmp.177 -2 L.inc.6.33)
        (mset! tmp.177 6 8)
        (set! inc.6 tmp.177)
        (mset! zeros.4 14 cons.76)
        (mset! zeros.4 22 |-.54|)
        (mset! zeros.4 30 zeros.4)
        (mset! zeros.4 38 eq?.77)
        (mset! map.5 14 cdr.64)
        (mset! map.5 22 map.5)
        (mset! map.5 30 car.63)
        (mset! map.5 38 cons.76)
        (mset! map.5 46 empty?.68)
        (mset! inc.6 14 |+.53|)
        (set! tmp.140 zeros.4)
        (set! rbp (+ rbp 24))
        (return-point L.rp.112
          (begin
            (set! rdx 22)
            (set! rsi 256)
            (set! rdi zeros.4)
            (set! r15 L.rp.112)
            (jump L.zeros.4.31 rbp r15 rdx rsi rdi)))
        (set! rbp (- rbp 24))
        (set! listofZero.12 rax)
        (set! tmp.141 map.5)
        (set! rbp (+ rbp 24))
        (return-point L.rp.113
          (begin
            (set! rdx listofZero.12)
            (set! rsi inc.6)
            (set! rdi map.5)
            (set! r15 L.rp.113)
            (jump L.map.5.32 rbp r15 rdx rsi rdi)))
        (set! rbp (- rbp 24))
        (set! ones.13 rax)
        (set! rax ones.13)
        (jump ra.349 rbp rax)))))
    `(module (define L.main.111 ,(list-no-order
                            `(assignment ,(list-no-order `(ra.349 fv0)
         `(inc.6 fv1)
         `(map.5 fv2)
         `(unsafe-vector-ref.3 r15)
         `(eq?.77 r14)
         `(unsafe-vector-set!.2 r13)
         `(cons.76 r9)
         `(vector-init-loop.80 r8)
         `(make-init-vector.1 rdi)
         `(empty?.68 rsi)
         `(cdr.64 rdx)
         `(car.63 rcx)
         `(vector-ref.62 rbx)
         `(vector-set!.61 rsp)
         `(zeros.4 r15)
         `(tmp.336 rsp)
         `(tmp.370 rsp)
         `(tmp.165 rsp)
         `(tmp.335 rbx)
         `(tmp.369 rbx)
         `(tmp.164 rbx)
         `(tmp.348 r13)
         `(tmp.334 rcx)
         `(tmp.368 rcx)
         `(tmp.163 rcx)
         `(tmp.347 r13)
         `(tmp.381 r13)
         `(tmp.176 r13)
         `(tmp.382 r13)
         `(tmp.177 r13)
         `(tmp.330 rdx)
         `(tmp.364 rdx)
         `(tmp.159 rdx)
         `(boolean?.67 rdx)
         `(tmp.331 rdx)
         `(tmp.365 rdx)
         `(tmp.160 rdx)
         `(fixnum?.66 rdx)
         `(tmp.332 rdx)
         `(tmp.366 rdx)
         `(tmp.161 rdx)
         `(procedure-arity.65 rdx)
         `(tmp.333 rdx)
         `(tmp.367 rdx)
         `(tmp.162 rdx)
         `(tmp.346 r15)
         `(tmp.380 r15)
         `(tmp.175 r15)
         `(tmp.322 rsi)
         `(tmp.356 rsi)
         `(tmp.151 rsi)
         `(not.75 rsi)
         `(tmp.323 rsi)
         `(tmp.357 rsi)
         `(tmp.152 rsi)
         `(vector?.74 rsi)
         `(tmp.324 rsi)
         `(tmp.358 rsi)
         `(tmp.153 rsi)
         `(procedure?.73 rsi)
         `(tmp.325 rsi)
         `(tmp.359 rsi)
         `(tmp.154 rsi)
         `(pair?.72 rsi)
         `(tmp.326 rsi)
         `(tmp.360 rsi)
         `(tmp.155 rsi)
         `(error?.71 rsi)
         `(tmp.327 rsi)
         `(tmp.361 rsi)
         `(tmp.156 rsi)
         `(ascii-char?.70 rsi)
         `(tmp.328 rsi)
         `(tmp.362 rsi)
         `(tmp.157 rsi)
         `(void?.69 rsi)
         `(tmp.329 rsi)
         `(tmp.363 rsi)
         `(tmp.158 rsi)
         `(tmp.321 r9)
         `(tmp.355 r9)
         `(tmp.150 r9)
         `(tmp.320 r14)
         `(tmp.354 r14)
         `(tmp.149 r14)
         `(tmp.319 r14)
         `(tmp.353 r14)
         `(tmp.148 r14)
         `(tmp.318 r14)
         `(tmp.352 r14)
         `(tmp.147 r14)
         `(listofZero.12 r15)
         `(tmp.317 r14)
         `(tmp.351 r14)
         `(tmp.146 r14)
         `(tmp.140 r15)
         `(tmp.141 r14)
         `(tmp.316 r15)
         `(tmp.350 r15)
         `(tmp.145 r15)
         `(ones.13 r15)
         `(make-vector.59 fv1)
         `(|-.54| fv3)
         `(|+.53| fv4)
         `(tmp.345 fv2)
         `(tmp.379 fv2)
         `(tmp.174 fv2)
         `(*.52 fv2)
         `(tmp.344 fv2)
         `(tmp.378 fv2)
         `(tmp.173 fv2)
         `(tmp.339 fv2)
         `(tmp.373 fv2)
         `(tmp.168 fv2)
         `(>=.58 fv2)
         `(tmp.340 fv2)
         `(tmp.374 fv2)
         `(tmp.169 fv2)
         `(>.57 fv2)
         `(tmp.341 fv2)
         `(tmp.375 fv2)
         `(tmp.170 fv2)
         `(<=.56 fv2)
         `(tmp.342 fv2)
         `(tmp.376 fv2)
         `(tmp.171 fv2)
         `(<.55 fv2)
         `(tmp.343 fv2)
         `(tmp.377 fv2)
         `(tmp.172 fv2)
         `(tmp.337 fv1)
         `(tmp.371 fv1)
         `(tmp.166 fv1)
         `(vector-length.60 fv1)
         `(tmp.338 fv1)
         `(tmp.372 fv1)
         `(tmp.167 fv1)))) 
                            ,_)))
; expose-basic-blocks (Ex. 13)
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
            (define L.L.f1.1.2
            ()
            (begin
                (nop)
                (set! r14 rdi)
                (set! r13 rsi)
                (set! r14 (+ r14 r13))
                (set! rax r14)
                (jump r15)))))
         `(module
            (define L.main.3
                ()
                (begin
                (set! (rbp + 0) r15)
                (set! rbp (+ rbp 8))
                (set! rsi 2)
                (set! rdi 1)
                (set! r15 L.rp.4)
                (jump L.L.f1.1.2)))
            (define L.rp.4
                ()
                (begin
                (set! rbp (- rbp 8))
                (set! r15 rax)
                (set! rsi r15)
                (set! rdi r15)
                (set! r15 (rbp + 0))
                (jump L.L.f1.1.2)))
            (define L.L.f1.1.2
                ()
                (begin
                (nop)
                (set! r14 rdi)
                (set! r13 rsi)
                (set! r14 (+ r14 r13))
                (set! rax r14)
                (jump r15)))
            ))

     (parameterize ([current-pass-list
                  (list
                   expose-basic-blocks
                   flatten-program
                   patch-instructions
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute '(module (define L.main.2777 () (begin (nop) (set! rsi 8) (set! rdi 32) (nop) (jump L.fact_loop.2761))) (define L.not.2776 () (begin (nop) (set! r14 rdi) (if (neq? r14 6) (begin (set! rax 6) (jump r15)) (begin (set! rax 14) (jump r15))))) (define L.error?.2775 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 62) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.ascii-char?.2774 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 46) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.void?.2773 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 30) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.empty?.2772 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 22) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.boolean?.2771 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 247)) (nop) (if (eq? r14 6) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fixnum?.2770 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 7)) (nop) (if (eq? r14 0) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.>=.2769 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15))))))) (define L.>.2768 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15))))))) (define L.<=.2767 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15))))))) (define L.<.2766 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15))))))) (define L.-.2765 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15))))))) (define L.+.2764 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15))))))) (define L.*.2763 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15))))))) (define L.eq?.2762 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (if (eq? r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fact_loop.2761 () (begin (set! (rbp + 0) r15) (set! (rbp + 16) rdi) (set! (rbp + 8) rsi) (set! rbp (+ rbp 32)) (return-point L.rp.2778 (begin (set! rsi 0) (set! rdi (rbp + -16)) (set! r15 L.rp.2778) (jump L.eq?.2762))) (set! rbp (- rbp 32)) (set! r15 rax) (if (neq? r15 6) (begin (set! rax (rbp + 8)) (jump (rbp + 0))) (begin (set! rbp (+ rbp 32)) (return-point L.rp.2779 (begin (set! rsi 8) (set! rdi (rbp + -16)) (set! r15 L.rp.2779) (jump L.-.2765))) (set! rbp (- rbp 32)) (set! (rbp + 24) rax) (set! rbp (+ rbp 32)) (return-point L.rp.2780 (begin (set! rsi (rbp + -16)) (set! rdi (rbp + -24)) (set! r15 L.rp.2780) (jump L.*.2763))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rsi r15) (set! rdi (rbp + 24)) (set! r15 (rbp + 0)) (jump L.fact_loop.2761))))))
     ) 24)

    (check-equal?
     (execute '(module (define L.main.6873 () (begin (nop) (set! rsi 8) (set! rdi 48) (nop) (jump L.fact_loop.6857))) (define L.not.6872 () (begin (nop) (set! r14 rdi) (if (neq? r14 6) (begin (set! rax 6) (jump r15)) (begin (set! rax 14) (jump r15))))) (define L.error?.6871 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 62) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.ascii-char?.6870 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 46) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.void?.6869 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 30) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.empty?.6868 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 22) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.boolean?.6867 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 247)) (nop) (if (eq? r14 6) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fixnum?.6866 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 7)) (nop) (if (eq? r14 0) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.>=.6865 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15))))))) (define L.>.6864 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15))))))) (define L.<=.6863 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15))))))) (define L.<.6862 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15))))))) (define L.-.6861 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15))))))) (define L.+.6860 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15))))))) (define L.*.6859 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15))))))) (define L.eq?.6858 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (if (eq? r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fact_loop.6857 () (begin (set! (rbp + 0) r15) (set! (rbp + 16) rdi) (set! (rbp + 8) rsi) (set! rbp (+ rbp 32)) (return-point L.rp.6874 (begin (set! rsi 0) (set! rdi (rbp + -16)) (set! r15 L.rp.6874) (jump L.eq?.6858))) (set! rbp (- rbp 32)) (set! r15 rax) (if (neq? r15 6) (begin (set! rax (rbp + 8)) (jump (rbp + 0))) (begin (set! rbp (+ rbp 32)) (return-point L.rp.6875 (begin (set! rsi 8) (set! rdi (rbp + -16)) (set! r15 L.rp.6875) (jump L.-.6861))) (set! rbp (- rbp 32)) (set! (rbp + 24) rax) (set! rbp (+ rbp 32)) (return-point L.rp.6876 (begin (set! rsi (rbp + -16)) (set! rdi (rbp + -24)) (set! r15 L.rp.6876) (jump L.*.6859))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rsi r15) (set! rdi (rbp + 24)) (set! r15 (rbp + 0)) (jump L.fact_loop.6857))))))
     ) 720)

     (check-equal?
     (execute '(module (define L.main.10969 () (begin (nop) (set! rdi 32) (nop) (jump L.fact.10953))) (define L.not.10968 () (begin (nop) (set! r14 rdi) (if (neq? r14 6) (begin (set! rax 6) (jump r15)) (begin (set! rax 14) (jump r15))))) (define L.error?.10967 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 62) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.ascii-char?.10966 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 46) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.void?.10965 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 30) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.empty?.10964 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 22) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.boolean?.10963 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 247)) (nop) (if (eq? r14 6) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fixnum?.10962 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 7)) (nop) (if (eq? r14 0) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.>=.10961 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15))))))) (define L.>.10960 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15))))))) (define L.<=.10959 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15))))))) (define L.<.10958 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15))))))) (define L.-.10957 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15))))))) (define L.+.10956 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15))))))) (define L.*.10955 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15))))))) (define L.eq?.10954 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (if (eq? r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fact.10953 () (begin (set! (rbp + 0) r15) (set! (rbp + 8) rdi) (set! rbp (+ rbp 16)) (return-point L.rp.10970 (begin (set! rsi 0) (set! rdi (rbp + -8)) (set! r15 L.rp.10970) (jump L.eq?.10954))) (set! rbp (- rbp 16)) (set! r15 rax) (if (neq? r15 6) (begin (set! rax 8) (jump (rbp + 0))) (begin (set! rbp (+ rbp 16)) (return-point L.rp.10971 (begin (set! rsi 8) (set! rdi (rbp + -8)) (set! r15 L.rp.10971) (jump L.-.10957))) (set! rbp (- rbp 16)) (set! r15 rax) (set! rbp (+ rbp 16)) (return-point L.rp.10972 (begin (set! rdi r15) (set! r15 L.rp.10972) (jump L.fact.10953))) (set! rbp (- rbp 16)) (set! r15 rax) (set! rsi r15) (set! rdi (rbp + 8)) (set! r15 (rbp + 0)) (jump L.*.10955))))))
     ) 24)

     (check-equal?
     (execute '(module (define L.main.15065 () (begin (nop) (set! rdi 40) (nop) (jump L.fact.15049))) (define L.not.15064 () (begin (nop) (set! r14 rdi) (if (neq? r14 6) (begin (set! rax 6) (jump r15)) (begin (set! rax 14) (jump r15))))) (define L.error?.15063 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 62) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.ascii-char?.15062 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 46) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.void?.15061 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 30) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.empty?.15060 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 22) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.boolean?.15059 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 247)) (nop) (if (eq? r14 6) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fixnum?.15058 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 7)) (nop) (if (eq? r14 0) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.>=.15057 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15))))))) (define L.>.15056 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15))))))) (define L.<=.15055 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15))))))) (define L.<.15054 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15))))))) (define L.-.15053 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15))))))) (define L.+.15052 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15))))))) (define L.*.15051 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15))))))) (define L.eq?.15050 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (if (eq? r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fact.15049 () (begin (set! (rbp + 0) r15) (set! (rbp + 8) rdi) (set! rbp (+ rbp 16)) (return-point L.rp.15066 (begin (set! rsi 0) (set! rdi (rbp + -8)) (set! r15 L.rp.15066) (jump L.eq?.15050))) (set! rbp (- rbp 16)) (set! r15 rax) (if (neq? r15 6) (begin (set! rax 8) (jump (rbp + 0))) (begin (set! rbp (+ rbp 16)) (return-point L.rp.15067 (begin (set! rsi 8) (set! rdi (rbp + -8)) (set! r15 L.rp.15067) (jump L.-.15053))) (set! rbp (- rbp 16)) (set! r15 rax) (set! rbp (+ rbp 16)) (return-point L.rp.15068 (begin (set! rdi r15) (set! r15 L.rp.15068) (jump L.fact.15049))) (set! rbp (- rbp 16)) (set! r15 rax) (set! rsi r15) (set! rdi (rbp + 8)) (set! r15 (rbp + 0)) (jump L.*.15051))))))
        ) 120)

     (check-equal?
     (execute '(module (define L.main.19020 () (begin (nop) (set! rdx 8) (set! rsi 0) (set! rdi 32) (nop) (jump L.fib_loop.19004))) (define L.not.19019 () (begin (nop) (set! r14 rdi) (if (neq? r14 6) (begin (set! rax 6) (jump r15)) (begin (set! rax 14) (jump r15))))) (define L.error?.19018 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 62) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.ascii-char?.19017 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 46) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.void?.19016 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 30) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.empty?.19015 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 22) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.boolean?.19014 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 247)) (nop) (if (eq? r14 6) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fixnum?.19013 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 7)) (nop) (if (eq? r14 0) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.>=.19012 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15))))))) (define L.>.19011 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15))))))) (define L.<=.19010 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15))))))) (define L.<.19009 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15))))))) (define L.-.19008 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15))))))) (define L.+.19007 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15))))))) (define L.*.19006 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15))))))) (define L.eq?.19005 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (if (eq? r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fib_loop.19004 () (begin (set! (rbp + 0) r15) (set! (rbp + 16) rdi) (set! (rbp + 8) rsi) (set! (rbp + 24) rdx) (set! rbp (+ rbp 32)) (return-point L.rp.19021 (begin (set! rsi 0) (set! rdi (rbp + -16)) (set! r15 L.rp.19021) (jump L.eq?.19005))) (set! rbp (- rbp 32)) (set! r15 rax) (if (neq? r15 6) (begin (set! rax (rbp + 8)) (jump (rbp + 0))) (begin (set! rbp (+ rbp 32)) (return-point L.rp.19022 (begin (set! rsi 8) (set! rdi (rbp + -16)) (set! r15 L.rp.19022) (jump L.eq?.19005))) (set! rbp (- rbp 32)) (set! r15 rax) (if (neq? r15 6) (begin (set! rax (rbp + 24)) (jump (rbp + 0))) (begin (set! rbp (+ rbp 32)) (return-point L.rp.19023 (begin (set! rsi -8) (set! rdi (rbp + -16)) (set! r15 L.rp.19023) (jump L.+.19007))) (set! rbp (- rbp 32)) (set! (rbp + 16) rax) (set! rbp (+ rbp 32)) (return-point L.rp.19024 (begin (set! rsi (rbp + -8)) (set! rdi (rbp + -24)) (set! r15 L.rp.19024) (jump L.+.19007))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rdx r15) (set! rsi (rbp + 24)) (set! rdi (rbp + 16)) (set! r15 (rbp + 0)) (jump L.fib_loop.19004))))))))
     ) 3)

     (check-equal?
     (execute '(module (define L.main.22995 () (begin (nop) (set! rdx 8) (set! rsi 0) (set! rdi 48) (nop) (jump L.fib_loop.22979))) (define L.not.22994 () (begin (nop) (set! r14 rdi) (if (neq? r14 6) (begin (set! rax 6) (jump r15)) (begin (set! rax 14) (jump r15))))) (define L.error?.22993 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 62) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.ascii-char?.22992 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 46) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.void?.22991 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 30) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.empty?.22990 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 22) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.boolean?.22989 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 247)) (nop) (if (eq? r14 6) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fixnum?.22988 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 7)) (nop) (if (eq? r14 0) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.>=.22987 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15))))))) (define L.>.22986 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15))))))) (define L.<=.22985 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15))))))) (define L.<.22984 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15))))))) (define L.-.22983 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15))))))) (define L.+.22982 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15))))))) (define L.*.22981 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15))))))) (define L.eq?.22980 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (if (eq? r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fib_loop.22979 () (begin (set! (rbp + 0) r15) (set! (rbp + 16) rdi) (set! (rbp + 8) rsi) (set! (rbp + 24) rdx) (set! rbp (+ rbp 32)) (return-point L.rp.22996 (begin (set! rsi 0) (set! rdi (rbp + -16)) (set! r15 L.rp.22996) (jump L.eq?.22980))) (set! rbp (- rbp 32)) (set! r15 rax) (if (neq? r15 6) (begin (set! rax (rbp + 8)) (jump (rbp + 0))) (begin (set! rbp (+ rbp 32)) (return-point L.rp.22997 (begin (set! rsi 8) (set! rdi (rbp + -16)) (set! r15 L.rp.22997) (jump L.eq?.22980))) (set! rbp (- rbp 32)) (set! r15 rax) (if (neq? r15 6) (begin (set! rax (rbp + 24)) (jump (rbp + 0))) (begin (set! rbp (+ rbp 32)) (return-point L.rp.22998 (begin (set! rsi -8) (set! rdi (rbp + -16)) (set! r15 L.rp.22998) (jump L.+.22982))) (set! rbp (- rbp 32)) (set! (rbp + 16) rax) (set! rbp (+ rbp 32)) (return-point L.rp.22999 (begin (set! rsi (rbp + -8)) (set! rdi (rbp + -24)) (set! r15 L.rp.22999) (jump L.+.22982))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rdx r15) (set! rsi (rbp + 24)) (set! rdi (rbp + 16)) (set! r15 (rbp + 0)) (jump L.fib_loop.22979))))))))
     ) 8)

     (check-equal?
     (execute '(module (define L.main.27097 () (begin (nop) (set! rsi 16) (set! rdi 8) (nop) (jump L.swap.27081))) (define L.not.27096 () (begin (nop) (set! r14 rdi) (if (neq? r14 6) (begin (set! rax 6) (jump r15)) (begin (set! rax 14) (jump r15))))) (define L.error?.27095 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 62) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.ascii-char?.27094 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 46) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.void?.27093 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 30) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.empty?.27092 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 22) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.boolean?.27091 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 247)) (nop) (if (eq? r14 6) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fixnum?.27090 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 7)) (nop) (if (eq? r14 0) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.>=.27089 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15))))))) (define L.>.27088 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15))))))) (define L.<=.27087 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15))))))) (define L.<.27086 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15))))))) (define L.-.27085 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15))))))) (define L.+.27084 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15))))))) (define L.*.27083 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15))))))) (define L.eq?.27082 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (if (eq? r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.swap.27081 () (begin (set! (rbp + 0) r15) (set! (rbp + 8) rdi) (set! (rbp + 16) rsi) (set! rbp (+ rbp 24)) (return-point L.rp.27098 (begin (set! rsi (rbp + -16)) (set! rdi (rbp + -8)) (set! r15 L.rp.27098) (jump L.<.27086))) (set! rbp (- rbp 24)) (set! r15 rax) (if (neq? r15 6) (begin (set! rax (rbp + 8)) (jump (rbp + 0))) (begin (set! rbp (+ rbp 24)) (return-point L.rp.27099 (begin (set! rsi (rbp + -16)) (set! rdi (rbp + -8)) (set! r15 L.rp.27099) (jump L.swap.27081))) (set! rbp (- rbp 24)) (set! r15 rax) (set! rax r15) (jump (rbp + 0)))))))
        ) 2)

     (check-equal?
     (execute '(module (define L.main.31237 () (begin (nop) (set! rsi 24) (set! rdi 16) (nop) (jump L.mul.31221))) (define L.not.31236 () (begin (nop) (set! r14 rdi) (if (neq? r14 6) (begin (set! rax 6) (jump r15)) (begin (set! rax 14) (jump r15))))) (define L.error?.31235 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 62) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.ascii-char?.31234 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 46) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.void?.31233 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 30) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.empty?.31232 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 22) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.boolean?.31231 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 247)) (nop) (if (eq? r14 6) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fixnum?.31230 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 7)) (nop) (if (eq? r14 0) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.>=.31229 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15))))))) (define L.>.31228 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15))))))) (define L.<=.31227 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15))))))) (define L.<.31226 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15))))))) (define L.-.31225 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15))))))) (define L.+.31224 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15))))))) (define L.*.31223 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15))))))) (define L.eq?.31222 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (if (eq? r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.threeParams.31218 () (begin (set! (rbp + 0) r15) (set! r15 rdi) (set! r14 rsi) (set! (rbp + 8) rdx) (set! rbp (+ rbp 16)) (return-point L.rp.31238 (begin (set! rsi r14) (set! rdi r15) (set! r15 L.rp.31238) (jump L.+.31224))) (set! rbp (- rbp 16)) (set! r15 rax) (set! rsi r15) (set! rdi (rbp + 8)) (set! r15 (rbp + 0)) (jump L.+.31224))) (define L.twoParams.31219 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! rsi r13) (set! rdi r14) (nop) (jump L.+.31224))) (define L.helper.31220 () (begin (set! (rbp + 0) r15) (set! (rbp + 24) rdi) (set! (rbp + 8) rsi) (set! (rbp + 16) rdx) (set! rbp (+ rbp 32)) (return-point L.rp.31239 (begin (set! rsi 8) (set! rdi (rbp + -16)) (set! r15 L.rp.31239) (jump L.eq?.31222))) (set! rbp (- rbp 32)) (set! r15 rax) (if (neq? r15 6) (begin (set! rax (rbp + 8)) (jump (rbp + 0))) (begin (set! rbp (+ rbp 32)) (return-point L.rp.31240 (begin (set! rsi 16) (set! rdi (rbp + -16)) (set! r15 L.rp.31240) (jump L.eq?.31222))) (set! rbp (- rbp 32)) (set! r15 rax) (if (neq? r15 6) (begin (set! rsi (rbp + 8)) (set! rdi (rbp + 8)) (set! r15 (rbp + 0)) (jump (rbp + 24))) (begin (set! rbp (+ rbp 32)) (return-point L.rp.31241 (begin (set! rsi 24) (set! rdi (rbp + -16)) (set! r15 L.rp.31241) (jump L.eq?.31222))) (set! rbp (- rbp 32)) (set! r15 rax) (if (neq? r15 6) (begin (set! rdx (rbp + 8)) (set! rsi (rbp + 8)) (set! rdi (rbp + 8)) (set! r15 (rbp + 0)) (jump (rbp + 24))) (begin (set! rax 8000000000) (jump (rbp + 0)))))))))) (define L.mul.31221 () (begin (set! (rbp + 0) r15) (set! (rbp + 8) rdi) (set! (rbp + 16) rsi) (set! rbp (+ rbp 24)) (return-point L.rp.31242 (begin (set! rsi 8) (set! rdi (rbp + -8)) (set! r15 L.rp.31242) (jump L.eq?.31222))) (set! rbp (- rbp 24)) (set! r15 rax) (if (neq? r15 6) (begin (set! rdx (rbp + 16)) (set! rsi (rbp + 8)) (set! rdi -8) (set! r15 (rbp + 0)) (jump L.helper.31220)) (begin (set! rbp (+ rbp 24)) (return-point L.rp.31243 (begin (set! rsi 16) (set! rdi (rbp + -8)) (set! r15 L.rp.31243) (jump L.eq?.31222))) (set! rbp (- rbp 24)) (set! r15 rax) (if (neq? r15 6) (begin (set! rdx (rbp + 16)) (set! rsi (rbp + 8)) (set! rdi L.twoParams.31219) (set! r15 (rbp + 0)) (jump L.helper.31220)) (begin (set! rbp (+ rbp 24)) (return-point L.rp.31244 (begin (set! rsi 24) (set! rdi (rbp + -8)) (set! r15 L.rp.31244) (jump L.eq?.31222))) (set! rbp (- rbp 24)) (set! r15 rax) (if (neq? r15 6) (begin (set! rdx (rbp + 16)) (set! rsi (rbp + 8)) (set! rdi L.threeParams.31218) (set! r15 (rbp + 0)) (jump L.helper.31220)) (begin (set! rax 8000000) (jump (rbp + 0)))))))))))
         ) 6)

     (check-equal?
     (execute '(module (define L.main.35342 () (begin (nop) (set! (rbp + 0) 56) (set! r9 48) (set! r8 40) (set! rcx 32) (set! rdx 24) (set! rsi 16) (set! rdi 8) (nop) (jump L.F.35324))) (define L.not.35341 () (begin (nop) (set! r14 rdi) (if (neq? r14 6) (begin (set! rax 6) (jump r15)) (begin (set! rax 14) (jump r15))))) (define L.error?.35340 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 62) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.ascii-char?.35339 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 46) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.void?.35338 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 30) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.empty?.35337 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 22) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.boolean?.35336 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 247)) (nop) (if (eq? r14 6) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fixnum?.35335 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 7)) (nop) (if (eq? r14 0) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.>=.35334 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15))))))) (define L.>.35333 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15))))))) (define L.<=.35332 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15))))))) (define L.<.35331 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15))))))) (define L.-.35330 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15))))))) (define L.+.35329 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15))))))) (define L.*.35328 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15))))))) (define L.eq?.35327 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (if (eq? r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.F.35324 () (begin (set! (rbp + 8) r15) (set! r15 rdi) (set! r14 rsi) (set! r13 rdx) (set! r12 rcx) (nop) (nop) (set! rdi (rbp + 0)) (set! rbp (+ rbp 16)) (return-point L.rp.35343 (begin (set! (rbp + 8) 64) (set! (rbp + 0) rdi) (nop) (nop) (set! rcx r12) (set! rdx r13) (set! rsi r14) (set! rdi r15) (set! r15 L.rp.35343) (jump L.G.35325))) (set! rbp (- rbp 16)) (set! r15 rax) (set! rsi 80) (set! rdi r15) (set! r15 (rbp + 8)) (jump L.+.35329))) (define L.G.35325 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 rdx) (set! rdi rcx) (nop) (nop) (set! rsi (rbp + 0)) (set! rdx (rbp + 8)) (set! (rbp + 16) 72) (set! (rbp + 8) rdx) (set! (rbp + 0) rsi) (nop) (nop) (set! rcx rdi) (set! rdx r12) (set! rsi r13) (set! rdi r14) (nop) (jump L.H.35326))) (define L.H.35326 () (begin (set! (rbp + 24) r15) (set! r15 rdi) (set! r14 rsi) (set! (rbp + 64) rdx) (set! (rbp + 56) rcx) (set! (rbp + 48) r8) (set! (rbp + 40) r9) (set! (rbp + 32) (rbp + 0)) (nop) (set! (rbp + 0) (rbp + 16)) (set! rbp (+ rbp 72)) (return-point L.rp.35344 (begin (set! rsi r14) (set! rdi r15) (set! r15 L.rp.35344) (jump L.+.35329))) (set! rbp (- rbp 72)) (set! r15 rax) (set! rbp (+ rbp 72)) (return-point L.rp.35345 (begin (set! rsi (rbp + -8)) (set! rdi r15) (set! r15 L.rp.35345) (jump L.+.35329))) (set! rbp (- rbp 72)) (set! r15 rax) (set! rbp (+ rbp 72)) (return-point L.rp.35346 (begin (set! rsi (rbp + -16)) (set! rdi r15) (set! r15 L.rp.35346) (jump L.+.35329))) (set! rbp (- rbp 72)) (set! r15 rax) (set! rbp (+ rbp 72)) (return-point L.rp.35347 (begin (set! rsi (rbp + -24)) (set! rdi r15) (set! r15 L.rp.35347) (jump L.+.35329))) (set! rbp (- rbp 72)) (set! r15 rax) (set! rbp (+ rbp 72)) (return-point L.rp.35348 (begin (set! rsi (rbp + -32)) (set! rdi r15) (set! r15 L.rp.35348) (jump L.+.35329))) (set! rbp (- rbp 72)) (set! r15 rax) (set! rbp (+ rbp 72)) (return-point L.rp.35349 (begin (set! rsi (rbp + -40)) (set! rdi r15) (set! r15 L.rp.35349) (jump L.+.35329))) (set! rbp (- rbp 72)) (set! r15 rax) (set! rbp (+ rbp 72)) (return-point L.rp.35350 (begin (set! rsi (rbp + -64)) (set! rdi r15) (set! r15 L.rp.35350) (jump L.+.35329))) (set! rbp (- rbp 72)) (set! r15 rax) (set! rsi (rbp + 0)) (set! rdi r15) (set! r15 (rbp + 24)) (jump L.+.35329))))
         ) 55)

     (check-equal?
     (execute '(module (define L.main.39481 () 
                            (begin (set! (rbp + 0) r15) (set! rbp (+ rbp 8)) (return-point L.rp.39482 (begin (set! rsi 16) (set! rdi 8) (set! r15 L.rp.39482) (jump L.eq?.39466))) (set! rbp (- rbp 8)) (set! r15 rax) (if (neq? r15 6) (begin (set! rsi 160) (set! rdi 80) (set! r15 (rbp + 0)) (jump L.big.39464)) (begin (set! rsi 160) (set! rdi 80) (set! r15 (rbp + 0)) (jump L.sum.39465))))) 
                        (define L.not.39480 () (begin (nop) (set! r14 rdi) (if (neq? r14 6) (begin (set! rax 6) (jump r15)) (begin (set! rax 14) (jump r15))))) (define L.error?.39479 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 62) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.ascii-char?.39478 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 46) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.void?.39477 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 30) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.empty?.39476 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 22) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.boolean?.39475 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 247)) (nop) (if (eq? r14 6) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fixnum?.39474 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 7)) (nop) (if (eq? r14 0) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.>=.39473 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15))))))) (define L.>.39472 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15))))))) (define L.<=.39471 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15))))))) (define L.<.39470 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15))))))) (define L.-.39469 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15))))))) (define L.+.39468 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15))))))) (define L.*.39467 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15))))))) (define L.eq?.39466 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (if (eq? r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.big.39464 () (begin (set! (rbp + 0) r15) (set! (rbp + 8) rdi) (set! (rbp + 16) rsi) (set! rbp (+ rbp 32)) (return-point L.rp.39483 (begin (set! rsi (rbp + -24)) (set! rdi -8) (set! r15 L.rp.39483) (jump L.*.39467))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rbp (+ rbp 32)) (return-point L.rp.39484 (begin (set! rsi 0) (set! rdi r15) (set! r15 L.rp.39484) (jump L.-.39469))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rbp (+ rbp 32)) (return-point L.rp.39485 (begin (set! rsi r15) (set! rdi 0) (set! r15 L.rp.39485) (jump L.+.39468))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rbp (+ rbp 32)) (return-point L.rp.39486 (begin (set! rsi r15) (set! rdi -8) (set! r15 L.rp.39486) (jump L.*.39467))) (set! rbp (- rbp 32)) (set! (rbp + 24) rax) (set! rbp (+ rbp 32)) (return-point L.rp.39487 (begin (set! rsi (rbp + -16)) (set! rdi -8) (set! r15 L.rp.39487) (jump L.*.39467))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rbp (+ rbp 32)) (return-point L.rp.39488 (begin (set! rsi 0) (set! rdi r15) (set! r15 L.rp.39488) (jump L.-.39469))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rbp (+ rbp 32)) (return-point L.rp.39489 (begin (set! rsi r15) (set! rdi 0) (set! r15 L.rp.39489) (jump L.+.39468))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rbp (+ rbp 32)) (return-point L.rp.39490 (begin (set! rsi r15) (set! rdi -8) (set! r15 L.rp.39490) (jump L.*.39467))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rbp (+ rbp 32)) (return-point L.rp.39491 (begin (set! rsi r15) (set! rdi (rbp + -8)) (set! r15 L.rp.39491) (jump L.>.39472))) (set! rbp (- rbp 32)) (set! r15 rax) (if (neq? r15 6) (begin (set! rbp (+ rbp 32)) (return-point L.rp.39492 (begin (set! rsi (rbp + -24)) (set! rdi -8) (set! r15 L.rp.39492) (jump L.*.39467))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rbp (+ rbp 32)) (return-point L.rp.39493 (begin (set! rsi 80) (set! rdi r15) (set! r15 L.rp.39493) (jump L.-.39469))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rbp (+ rbp 32)) (return-point L.rp.39494 (begin (set! rsi r15) (set! rdi 80) (set! r15 L.rp.39494) (jump L.+.39468))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rsi r15) (set! rdi -8) (set! r15 (rbp + 0)) (jump L.*.39467)) (begin (set! rbp (+ rbp 32)) (return-point L.rp.39495 (begin (set! rsi (rbp + -16)) (set! rdi -8) (set! r15 L.rp.39495) (jump L.*.39467))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rbp (+ rbp 32)) (return-point L.rp.39496 (begin (set! rsi 80) (set! rdi r15) (set! r15 L.rp.39496) (jump L.-.39469))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rbp (+ rbp 32)) (return-point L.rp.39497 (begin (set! rsi r15) (set! rdi 80) (set! r15 L.rp.39497) (jump L.+.39468))) (set! rbp (- rbp 32)) (set! r15 rax) (set! rsi r15) (set! rdi -8) (set! r15 (rbp + 0)) (jump L.*.39467))))) (define L.sum.39465 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! rsi r13) (set! rdi r14) (nop) (jump L.+.39468))))
         ) 30)

     (check-equal?
     (execute '(module (define L.main.43837 () (begin (nop) (set! rdi 30) (nop) (jump L.label2.43819))) (define L.not.43836 () (begin (nop) (set! r14 rdi) (if (neq? r14 6) (begin (set! rax 6) (jump r15)) (begin (set! rax 14) (jump r15))))) (define L.error?.43835 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 62) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.ascii-char?.43834 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 46) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.void?.43833 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 30) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.empty?.43832 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 22) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.boolean?.43831 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 247)) (nop) (if (eq? r14 6) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fixnum?.43830 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 7)) (nop) (if (eq? r14 0) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.>=.43829 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15))))))) (define L.>.43828 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15))))))) (define L.<=.43827 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15))))))) (define L.<.43826 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15))))))) (define L.-.43825 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15))))))) (define L.+.43824 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15))))))) (define L.*.43823 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15))))))) (define L.eq?.43822 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (if (eq? r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.label1.43818 () (begin (set! (rbp + 0) r15) (set! (rbp + 8) rdi) (set! rbp (+ rbp 24)) (return-point L.rp.43838 (begin (set! rsi 160) (set! rdi 80) (set! r15 L.rp.43838) (jump L.+.43824))) (set! rbp (- rbp 24)) (set! (rbp + 16) rax) (set! rbp (+ rbp 24)) (return-point L.rp.43839 (begin (set! rdi 0) (set! r15 L.rp.43839) (jump L.label1.43818))) (set! rbp (- rbp 24)) (set! r15 rax) (set! rbp (+ rbp 24)) (return-point L.rp.43840 (begin (set! rsi r15) (set! rdi (rbp + -8)) (set! r15 L.rp.43840) (jump L.+.43824))) (set! rbp (- rbp 24)) (set! r15 rax) (set! rbp (+ rbp 24)) (return-point L.rp.43841 (begin (set! rsi (rbp + -16)) (set! rdi r15) (set! r15 L.rp.43841) (jump L.-.43825))) (set! rbp (- rbp 24)) (set! r15 rax) (set! rax r15) (jump (rbp + 0)))) (define L.label2.43819 () (begin (set! (rbp + 0) r15) (set! (rbp + 8) rdi) (set! rbp (+ rbp 16)) (return-point L.rp.43842 (begin (set! rdi (rbp + -8)) (set! r15 L.rp.43842) (jump L.fixnum?.43830))) (set! rbp (- rbp 16)) (set! r15 rax) (if (neq? r15 6) (begin (set! rdi (rbp + 8)) (set! r15 (rbp + 0)) (jump L.fixnumfn.43820)) (begin (set! rbp (+ rbp 16)) (return-point L.rp.43843 (begin (set! rdi (rbp + -8)) (set! r15 L.rp.43843) (jump L.ascii-char?.43834))) (set! rbp (- rbp 16)) (set! r15 rax) (if (neq? r15 6) (begin (set! rdi (rbp + 8)) (set! r15 (rbp + 0)) (jump L.ascii-charfn.43821)) (begin (set! rbp (+ rbp 16)) (return-point L.rp.43844 (begin (set! rdi (rbp + -8)) (set! r15 L.rp.43844) (jump L.error?.43835))) (set! rbp (- rbp 16)) (set! r15 rax) (if (neq? r15 6) (begin (set! rax (rbp + 8)) (jump (rbp + 0))) (begin (set! rax 80) (jump (rbp + 0)))))))))) (define L.fixnumfn.43820 () (begin (nop) (set! r14 rdi) (set! rax r14) (jump r15))) (define L.ascii-charfn.43821 () (begin (nop) (set! r14 rdi) (set! rax r14) (jump r15))))
         ) 10)

     (check-equal? 
     (execute '(module (define L.main.48158 () (begin (set! (rbp + 0) r15) (set! rbp (+ rbp 8)) (return-point L.rp.48159 (begin (set! rdx 6) (set! rsi 31022) (set! rdi 32) (set! r15 L.rp.48159) (jump L.raiseError.48142))) (set! rbp (- rbp 8)) (set! r15 rax) (set! rdi r15) (set! r15 (rbp + 0)) (jump L.error?.48156))) (define L.not.48157 () (begin (nop) (set! r14 rdi) (if (neq? r14 6) (begin (set! rax 6) (jump r15)) (begin (set! rax 14) (jump r15))))) (define L.error?.48156 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 62) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.ascii-char?.48155 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 46) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.void?.48154 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 30) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.empty?.48153 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 22) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.boolean?.48152 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 247)) (nop) (if (eq? r14 6) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fixnum?.48151 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 7)) (nop) (if (eq? r14 0) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.>=.48150 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15))))))) (define L.>.48149 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15))))))) (define L.<=.48148 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15))))))) (define L.<.48147 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15))))))) (define L.-.48146 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15))))))) (define L.+.48145 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15))))))) (define L.*.48144 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15))))))) (define L.eq?.48143 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (if (eq? r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.raiseError.48142 () (begin (set! (rbp + 0) r15) (set! (rbp + 8) rdi) (set! (rbp + 16) rsi) (set! r15 rdx) (set! rbp (+ rbp 24)) (return-point L.rp.48160 (begin (set! rdi r15) (set! r15 L.rp.48160) (jump L.ascii-char?.48155))) (set! rbp (- rbp 24)) (set! r15 rax) (set! rbp (+ rbp 24)) (return-point L.rp.48161 (begin (set! rdi r15) (set! r15 L.rp.48161) (jump L.not.48157))) (set! rbp (- rbp 24)) (set! r15 rax) (if (neq? r15 6) (begin (set! rbp (+ rbp 24)) (return-point L.rp.48162 (begin (set! rsi 0) (set! rdi 112) (set! r15 L.rp.48162) (jump L.*.48144))) (set! rbp (- rbp 24)) (set! r15 rax) (set! rbp (+ rbp 24)) (return-point L.rp.48163 (begin (set! rsi 16) (set! rdi r15) (set! r15 L.rp.48163) (jump L.+.48145))) (set! rbp (- rbp 24)) (set! r15 rax) (set! rbp (+ rbp 24)) (return-point L.rp.48164 (begin (set! rdi r15) (set! r15 L.rp.48164) (jump L.void?.48154))) (set! rbp (- rbp 24)) (set! r15 rax) (if (neq? r15 6) (begin (set! rax 22) (jump (rbp + 0))) (begin (set! rbp (+ rbp 24)) (return-point L.rp.48165 (begin (set! rsi 160) (set! rdi (rbp + -16)) (set! r15 L.rp.48165) (jump L.+.48145))) (set! rbp (- rbp 24)) (set! r15 rax) (set! rbp (+ rbp 24)) (return-point L.rp.48166 (begin (set! rsi 232) (set! rdi r15) (set! r15 L.rp.48166) (jump L.-.48146))) (set! rbp (- rbp 24)) (set! r15 rax) (set! rbp (+ rbp 24)) (return-point L.rp.48167 (begin (set! rsi 0) (set! rdi r15) (set! r15 L.rp.48167) (jump L.-.48146))) (set! rbp (- rbp 24)) (set! r15 rax) (set! rax 17470) (jump (rbp + 0))))) (begin (set! rbp (+ rbp 24)) (return-point L.rp.48168 (begin (set! rdi 14) (set! r15 L.rp.48168) (jump L.not.48157))) (set! rbp (- rbp 24)) (set! r15 rax) (if (neq? r15 6) (begin (set! rax (rbp + 16)) (jump (rbp + 0))) (begin (set! rdx 22) (set! rsi 24878) (set! rdi 96) (set! r15 (rbp + 0)) (jump L.+.48145))))))))
         ) #t)

     (check-equal?
     (execute '(module (define L.main.52455 () (begin (nop) (nop) (jump L.b.52439))) (define L.not.52454 () (begin (nop) (set! r14 rdi) (if (neq? r14 6) (begin (set! rax 6) (jump r15)) (begin (set! rax 14) (jump r15))))) (define L.error?.52453 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 62) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.ascii-char?.52452 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 46) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.void?.52451 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 30) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.empty?.52450 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 255)) (nop) (if (eq? r14 22) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.boolean?.52449 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 247)) (nop) (if (eq? r14 6) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.fixnum?.52448 () (begin (nop) (set! r14 rdi) (set! r14 (bitwise-and r14 7)) (nop) (if (eq? r14 0) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.>=.52447 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (>= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 3390) (jump r15)))))) (begin (set! rax 3134) (jump r15))))))) (define L.>.52446 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (> r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2878) (jump r15)))))) (begin (set! rax 2622) (jump r15))))))) (define L.<=.52445 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (<= r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 2366) (jump r15)))))) (begin (set! rax 2110) (jump r15))))))) (define L.<.52444 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (if (< r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))) (begin (set! rax 1854) (jump r15)))))) (begin (set! rax 1598) (jump r15))))))) (define L.-.52443 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (- r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 1342) (jump r15)))))) (begin (set! rax 1086) (jump r15))))))) (define L.+.52442 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r14 (+ r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 830) (jump r15)))))) (begin (set! rax 574) (jump r15))))))) (define L.*.52441 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (set! r12 (bitwise-and r14 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r12 (bitwise-and r13 7)) (nop) (if (eq? r12 0) (begin (set! r12 14) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))) (begin (set! r12 6) (if (neq? r12 6) (begin (set! r13 (arithmetic-shift-right r13 3)) (nop) (set! r14 (* r14 r13)) (set! rax r14) (jump r15)) (begin (set! rax 318) (jump r15)))))) (begin (set! rax 62) (jump r15))))))) (define L.eq?.52440 () (begin (nop) (set! r14 rdi) (set! r13 rsi) (if (eq? r14 r13) (begin (set! rax 14) (jump r15)) (begin (set! rax 6) (jump r15))))) (define L.b.52439 () (begin (set! (rbp + 0) r15) (set! rbp (+ rbp 8)) (return-point L.rp.52456 (begin (set! rdi 112) (set! r15 L.rp.52456) (jump L.error?.52453))) (set! rbp (- rbp 8)) (set! r15 rax) (if (neq? r15 6) (begin (set! rbp (+ rbp 8)) (return-point L.rp.52457 (begin (set! rdi 14) (set! r15 L.rp.52457) (jump L.not.52454))) (set! rbp (- rbp 8)) (set! r15 rax) (if (neq? r15 6) (begin (set! rax 30766) (jump (rbp + 0))) (begin (set! rdi 31022) (set! r15 (rbp + 0)) (jump L.ascii-char?.52452)))) (begin (set! rbp (+ rbp 8)) (return-point L.rp.52458 (begin (set! rsi 0) (set! rdi 112) (set! r15 L.rp.52458) (jump L.*.52441))) (set! rbp (- rbp 8)) (set! r15 rax) (set! rbp (+ rbp 8)) (return-point L.rp.52459 (begin (set! rsi 16) (set! rdi r15) (set! r15 L.rp.52459) (jump L.+.52442))) (set! rbp (- rbp 8)) (set! r15 rax) (set! rbp (+ rbp 8)) (return-point L.rp.52460 (begin (set! rdi r15) (set! r15 L.rp.52460) (jump L.void?.52451))) (set! rbp (- rbp 8)) (set! r15 rax) (if (neq? r15 6) (begin (set! rax 22) (jump (rbp + 0))) (begin (set! rbp (+ rbp 8)) (return-point L.rp.52461 (begin (set! rsi 160) (set! rdi 80) (set! r15 L.rp.52461) (jump L.+.52442))) (set! rbp (- rbp 8)) (set! r15 rax) (set! rbp (+ rbp 8)) (return-point L.rp.52462 (begin (set! rsi 232) (set! rdi r15) (set! r15 L.rp.52462) (jump L.-.52443))) (set! rbp (- rbp 8)) (set! r15 rax) (set! rbp (+ rbp 8)) (return-point L.rp.52463 (begin (set! rsi 0) (set! rdi r15) (set! r15 L.rp.52463) (jump L.-.52443))) (set! rbp (- rbp 8)) (set! r15 rax) (set! rdi r15) (set! r15 (rbp + 0)) (jump L.fixnum?.52448))))))))
         ) #t)

       
     
     )
)