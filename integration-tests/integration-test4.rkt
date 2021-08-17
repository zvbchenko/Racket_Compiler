#lang racket
(require
  "a10.rkt"
  "a10-implement-safe-primops.rkt"
  "a10-compiler-lib.rkt"
  "a10-graph-lib.rkt")
(module+ test
  (require rackunit))


(module+ test

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
     (execute '(module
    (define L.main.104
      ((assignment
        ((ra.311 fv0)
         (i.4 fv1)
         (unsafe-vector-ref.3 r15)
         (unsafe-vector-set!.2 r14)
         (vector-init-loop.74 r13)
         (make-init-vector.1 r9)
         (vector-ref.56 r8)
         (vector-set!.55 rdi)
         (make-vector.53 rsi)
         (|-.48| rdx)
         (tmp.307 rcx)
         (tmp.340 rcx)
         (tmp.154 rcx)
         (|+.47| rcx)
         (tmp.308 rcx)
         (tmp.341 rcx)
         (tmp.155 rcx)
         (*.46 rcx)
         (tmp.302 rdx)
         (tmp.335 rdx)
         (tmp.149 rdx)
         (>=.52 rdx)
         (tmp.303 rdx)
         (tmp.336 rdx)
         (tmp.150 rdx)
         (>.51 rdx)
         (tmp.304 rdx)
         (tmp.337 rdx)
         (tmp.151 rdx)
         (<=.50 rdx)
         (tmp.305 rdx)
         (tmp.338 rdx)
         (tmp.152 rdx)
         (<.49 rdx)
         (tmp.306 rdx)
         (tmp.339 rdx)
         (tmp.153 rdx)
         (tmp.300 rsi)
         (tmp.333 rsi)
         (tmp.147 rsi)
         (vector-length.54 rsi)
         (tmp.301 rsi)
         (tmp.334 rsi)
         (tmp.148 rsi)
         (tmp.299 rdi)
         (tmp.332 rdi)
         (tmp.146 rdi)
         (tmp.283 r8)
         (tmp.316 r8)
         (tmp.130 r8)
         (eq?.71 r8)
         (tmp.284 r8)
         (tmp.317 r8)
         (tmp.131 r8)
         (cons.70 r8)
         (tmp.285 r8)
         (tmp.318 r8)
         (tmp.132 r8)
         (not.69 r8)
         (tmp.286 r8)
         (tmp.319 r8)
         (tmp.133 r8)
         (vector?.68 r8)
         (tmp.287 r8)
         (tmp.320 r8)
         (tmp.134 r8)
         (procedure?.67 r8)
         (tmp.288 r8)
         (tmp.321 r8)
         (tmp.135 r8)
         (pair?.66 r8)
         (tmp.289 r8)
         (tmp.322 r8)
         (tmp.136 r8)
         (error?.65 r8)
         (tmp.290 r8)
         (tmp.323 r8)
         (tmp.137 r8)
         (ascii-char?.64 r8)
         (tmp.291 r8)
         (tmp.324 r8)
         (tmp.138 r8)
         (void?.63 r8)
         (tmp.292 r8)
         (tmp.325 r8)
         (tmp.139 r8)
         (empty?.62 r8)
         (tmp.293 r8)
         (tmp.326 r8)
         (tmp.140 r8)
         (boolean?.61 r8)
         (tmp.294 r8)
         (tmp.327 r8)
         (tmp.141 r8)
         (fixnum?.60 r8)
         (tmp.295 r8)
         (tmp.328 r8)
         (tmp.142 r8)
         (procedure-arity.59 r8)
         (tmp.296 r8)
         (tmp.329 r8)
         (tmp.143 r8)
         (cdr.58 r8)
         (tmp.297 r8)
         (tmp.330 r8)
         (tmp.144 r8)
         (car.57 r8)
         (tmp.298 r8)
         (tmp.331 r8)
         (tmp.145 r8)
         (tmp.282 r9)
         (tmp.315 r9)
         (tmp.129 r9)
         (tmp.281 r13)
         (tmp.314 r13)
         (tmp.128 r13)
         (tmp.310 r15)
         (tmp.280 r14)
         (tmp.313 r14)
         (tmp.127 r14)
         (tmp.309 r15)
         (tmp.342 r15)
         (tmp.156 r15)
         (tmp.343 r15)
         (tmp.157 r15)
         (two.5 r15)
         (x.7 r15)
         (tmp.279 r15)
         (tmp.312 r15)
         (tmp.126 r15)
         (tmp.122 r15)
         (tmp.123 r14))))
      (begin
        (set! ra.311 r15)
        (set! tmp.279 r12)
        (set! r12 (+ r12 16))
        (set! tmp.312 (+ tmp.279 2))
        (set! tmp.126 tmp.312)
        (mset! tmp.126 -2 L.unsafe-vector-ref.3.1)
        (mset! tmp.126 6 16)
        (set! unsafe-vector-ref.3 tmp.126)
        (set! tmp.280 r12)
        (set! r12 (+ r12 16))
        (set! tmp.313 (+ tmp.280 2))
        (set! tmp.127 tmp.313)
        (mset! tmp.127 -2 L.unsafe-vector-set!.2.2)
        (mset! tmp.127 6 24)
        (set! unsafe-vector-set!.2 tmp.127)
        (set! tmp.281 r12)
        (set! r12 (+ r12 80))
        (set! tmp.314 (+ tmp.281 2))
        (set! tmp.128 tmp.314)
        (mset! tmp.128 -2 L.vector-init-loop.74.3)
        (mset! tmp.128 6 24)
        (set! vector-init-loop.74 tmp.128)
        (set! tmp.282 r12)
        (set! r12 (+ r12 80))
        (set! tmp.315 (+ tmp.282 2))
        (set! tmp.129 tmp.315)
        (mset! tmp.129 -2 L.make-init-vector.1.4)
        (mset! tmp.129 6 8)
        (set! make-init-vector.1 tmp.129)
        (set! tmp.283 r12)
        (set! r12 (+ r12 16))
        (set! tmp.316 (+ tmp.283 2))
        (set! tmp.130 tmp.316)
        (mset! tmp.130 -2 L.eq?.71.5)
        (mset! tmp.130 6 16)
        (set! eq?.71 tmp.130)
        (set! tmp.284 r12)
        (set! r12 (+ r12 16))
        (set! tmp.317 (+ tmp.284 2))
        (set! tmp.131 tmp.317)
        (mset! tmp.131 -2 L.cons.70.6)
        (mset! tmp.131 6 16)
        (set! cons.70 tmp.131)
        (set! tmp.285 r12)
        (set! r12 (+ r12 16))
        (set! tmp.318 (+ tmp.285 2))
        (set! tmp.132 tmp.318)
        (mset! tmp.132 -2 L.not.69.7)
        (mset! tmp.132 6 8)
        (set! not.69 tmp.132)
        (set! tmp.286 r12)
        (set! r12 (+ r12 16))
        (set! tmp.319 (+ tmp.286 2))
        (set! tmp.133 tmp.319)
        (mset! tmp.133 -2 L.vector?.68.8)
        (mset! tmp.133 6 8)
        (set! vector?.68 tmp.133)
        (set! tmp.287 r12)
        (set! r12 (+ r12 16))
        (set! tmp.320 (+ tmp.287 2))
        (set! tmp.134 tmp.320)
        (mset! tmp.134 -2 L.procedure?.67.9)
        (mset! tmp.134 6 8)
        (set! procedure?.67 tmp.134)
        (set! tmp.288 r12)
        (set! r12 (+ r12 16))
        (set! tmp.321 (+ tmp.288 2))
        (set! tmp.135 tmp.321)
        (mset! tmp.135 -2 L.pair?.66.10)
        (mset! tmp.135 6 8)
        (set! pair?.66 tmp.135)
        (set! tmp.289 r12)
        (set! r12 (+ r12 16))
        (set! tmp.322 (+ tmp.289 2))
        (set! tmp.136 tmp.322)
        (mset! tmp.136 -2 L.error?.65.11)
        (mset! tmp.136 6 8)
        (set! error?.65 tmp.136)
        (set! tmp.290 r12)
        (set! r12 (+ r12 16))
        (set! tmp.323 (+ tmp.290 2))
        (set! tmp.137 tmp.323)
        (mset! tmp.137 -2 L.ascii-char?.64.12)
        (mset! tmp.137 6 8)
        (set! ascii-char?.64 tmp.137)
        (set! tmp.291 r12)
        (set! r12 (+ r12 16))
        (set! tmp.324 (+ tmp.291 2))
        (set! tmp.138 tmp.324)
        (mset! tmp.138 -2 L.void?.63.13)
        (mset! tmp.138 6 8)
        (set! void?.63 tmp.138)
        (set! tmp.292 r12)
        (set! r12 (+ r12 16))
        (set! tmp.325 (+ tmp.292 2))
        (set! tmp.139 tmp.325)
        (mset! tmp.139 -2 L.empty?.62.14)
        (mset! tmp.139 6 8)
        (set! empty?.62 tmp.139)
        (set! tmp.293 r12)
        (set! r12 (+ r12 16))
        (set! tmp.326 (+ tmp.293 2))
        (set! tmp.140 tmp.326)
        (mset! tmp.140 -2 L.boolean?.61.15)
        (mset! tmp.140 6 8)
        (set! boolean?.61 tmp.140)
        (set! tmp.294 r12)
        (set! r12 (+ r12 16))
        (set! tmp.327 (+ tmp.294 2))
        (set! tmp.141 tmp.327)
        (mset! tmp.141 -2 L.fixnum?.60.16)
        (mset! tmp.141 6 8)
        (set! fixnum?.60 tmp.141)
        (set! tmp.295 r12)
        (set! r12 (+ r12 16))
        (set! tmp.328 (+ tmp.295 2))
        (set! tmp.142 tmp.328)
        (mset! tmp.142 -2 L.procedure-arity.59.17)
        (mset! tmp.142 6 8)
        (set! procedure-arity.59 tmp.142)
        (set! tmp.296 r12)
        (set! r12 (+ r12 16))
        (set! tmp.329 (+ tmp.296 2))
        (set! tmp.143 tmp.329)
        (mset! tmp.143 -2 L.cdr.58.18)
        (mset! tmp.143 6 8)
        (set! cdr.58 tmp.143)
        (set! tmp.297 r12)
        (set! r12 (+ r12 16))
        (set! tmp.330 (+ tmp.297 2))
        (set! tmp.144 tmp.330)
        (mset! tmp.144 -2 L.car.57.19)
        (mset! tmp.144 6 8)
        (set! car.57 tmp.144)
        (set! tmp.298 r12)
        (set! r12 (+ r12 80))
        (set! tmp.331 (+ tmp.298 2))
        (set! tmp.145 tmp.331)
        (mset! tmp.145 -2 L.vector-ref.56.20)
        (mset! tmp.145 6 16)
        (set! vector-ref.56 tmp.145)
        (set! tmp.299 r12)
        (set! r12 (+ r12 80))
        (set! tmp.332 (+ tmp.299 2))
        (set! tmp.146 tmp.332)
        (mset! tmp.146 -2 L.vector-set!.55.21)
        (mset! tmp.146 6 24)
        (set! vector-set!.55 tmp.146)
        (set! tmp.300 r12)
        (set! r12 (+ r12 16))
        (set! tmp.333 (+ tmp.300 2))
        (set! tmp.147 tmp.333)
        (mset! tmp.147 -2 L.vector-length.54.22)
        (mset! tmp.147 6 8)
        (set! vector-length.54 tmp.147)
        (set! tmp.301 r12)
        (set! r12 (+ r12 80))
        (set! tmp.334 (+ tmp.301 2))
        (set! tmp.148 tmp.334)
        (mset! tmp.148 -2 L.make-vector.53.23)
        (mset! tmp.148 6 8)
        (set! make-vector.53 tmp.148)
        (set! tmp.302 r12)
        (set! r12 (+ r12 16))
        (set! tmp.335 (+ tmp.302 2))
        (set! tmp.149 tmp.335)
        (mset! tmp.149 -2 L.>=.52.24)
        (mset! tmp.149 6 16)
        (set! >=.52 tmp.149)
        (set! tmp.303 r12)
        (set! r12 (+ r12 16))
        (set! tmp.336 (+ tmp.303 2))
        (set! tmp.150 tmp.336)
        (mset! tmp.150 -2 L.>.51.25)
        (mset! tmp.150 6 16)
        (set! >.51 tmp.150)
        (set! tmp.304 r12)
        (set! r12 (+ r12 16))
        (set! tmp.337 (+ tmp.304 2))
        (set! tmp.151 tmp.337)
        (mset! tmp.151 -2 L.<=.50.26)
        (mset! tmp.151 6 16)
        (set! <=.50 tmp.151)
        (set! tmp.305 r12)
        (set! r12 (+ r12 16))
        (set! tmp.338 (+ tmp.305 2))
        (set! tmp.152 tmp.338)
        (mset! tmp.152 -2 L.<.49.27)
        (mset! tmp.152 6 16)
        (set! <.49 tmp.152)
        (set! tmp.306 r12)
        (set! r12 (+ r12 16))
        (set! tmp.339 (+ tmp.306 2))
        (set! tmp.153 tmp.339)
        (mset! tmp.153 -2 L.-.48.28)
        (mset! tmp.153 6 16)
        (set! |-.48| tmp.153)
        (set! tmp.307 r12)
        (set! r12 (+ r12 16))
        (set! tmp.340 (+ tmp.307 2))
        (set! tmp.154 tmp.340)
        (mset! tmp.154 -2 L.+.47.29)
        (mset! tmp.154 6 16)
        (set! |+.47| tmp.154)
        (set! tmp.308 r12)
        (set! r12 (+ r12 16))
        (set! tmp.341 (+ tmp.308 2))
        (set! tmp.155 tmp.341)
        (mset! tmp.155 -2 L.*.46.30)
        (mset! tmp.155 6 16)
        (set! *.46 tmp.155)
        (mset! vector-init-loop.74 14 vector-init-loop.74)
        (mset! make-init-vector.1 14 vector-init-loop.74)
        (mset! vector-ref.56 14 unsafe-vector-ref.3)
        (mset! vector-set!.55 14 unsafe-vector-set!.2)
        (mset! make-vector.53 14 make-init-vector.1)
        (set! tmp.309 r12)
        (set! r12 (+ r12 80))
        (set! tmp.342 (+ tmp.309 2))
        (set! tmp.156 tmp.342)
        (mset! tmp.156 -2 L.i.4.31)
        (mset! tmp.156 6 8)
        (set! i.4 tmp.156)
        (set! tmp.310 r12)
        (set! r12 (+ r12 80))
        (set! tmp.343 (+ tmp.310 2))
        (set! tmp.157 tmp.343)
        (mset! tmp.157 -2 L.two.5.32)
        (mset! tmp.157 6 0)
        (set! two.5 tmp.157)
        (mset! i.4 14 |-.48|)
        (mset! two.5 14 i.4)
        (set! tmp.122 two.5)
        (set! rbp (+ rbp 16))
        (return-point L.rp.105
          (begin
            (set! rdi two.5)
            (set! r15 L.rp.105)
            (jump L.two.5.32 rbp r15 rdi)))
        (set! rbp (- rbp 16))
        (set! x.7 rax)
        (set! tmp.123 i.4)
        (set! rsi x.7)
        (set! rdi i.4)
        (set! r15 ra.311)
        (jump L.i.4.31 rbp r15 rsi rdi)))
    (define L.two.5.32
      ((assignment ((ra.344 r15) (i.4 r14) (c.114 r14) (tmp.121 r14))))
      (begin
        (set! ra.344 r15)
        (set! c.114 rdi)
        (set! i.4 (mref c.114 14))
        (set! tmp.121 i.4)
        (set! rsi 16)
        (set! rdi i.4)
        (set! r15 ra.344)
        (jump L.i.4.31 rbp r15 rsi rdi)))
    (define L.i.4.31
      ((assignment
        ((ra.345 r15) (x.6 r14) (|-.48| r13) (c.113 r13) (tmp.120 r13))))
      (begin
        (set! ra.345 r15)
        (set! c.113 rdi)
        (set! x.6 rsi)
        (set! |-.48| (mref c.113 14))
        (set! tmp.120 |-.48|)
        (set! rdx 0)
        (set! rsi x.6)
        (set! rdi |-.48|)
        (set! r15 ra.345)
        (jump L.-.48.28 rbp r15 rdx rsi rdi)))
    (define L.*.46.30
      ((assignment
        ((ra.346 r15)
         (tmp.8 r14)
         (tmp.9 r13)
         (tmp.164 r9)
         (c.112 r14)
         (tmp.347 r9))))
      (begin
        (set! ra.346 r15)
        (set! c.112 rdi)
        (set! tmp.8 rsi)
        (set! tmp.9 rdx)
        (set! tmp.347 (bitwise-and tmp.9 7))
        (set! tmp.164 tmp.347)
        (if (eq? tmp.164 0)
          (begin
            (set! rdx tmp.9)
            (set! rsi tmp.8)
            (set! rdi 14)
            (set! r15 ra.346)
            (jump L.jp.36 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.9)
            (set! rsi tmp.8)
            (set! rdi 6)
            (set! r15 ra.346)
            (jump L.jp.36 rbp r15 rdx rsi rdi)))))
    (define L.+.47.29
      ((assignment
        ((ra.348 r15)
         (tmp.10 r14)
         (tmp.11 r13)
         (tmp.170 r9)
         (c.111 r14)
         (tmp.349 r9))))
      (begin
        (set! ra.348 r15)
        (set! c.111 rdi)
        (set! tmp.10 rsi)
        (set! tmp.11 rdx)
        (set! tmp.349 (bitwise-and tmp.11 7))
        (set! tmp.170 tmp.349)
        (if (eq? tmp.170 0)
          (begin
            (set! rdx tmp.11)
            (set! rsi tmp.10)
            (set! rdi 14)
            (set! r15 ra.348)
            (jump L.jp.40 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.11)
            (set! rsi tmp.10)
            (set! rdi 6)
            (set! r15 ra.348)
            (jump L.jp.40 rbp r15 rdx rsi rdi)))))
    (define L.-.48.28
      ((assignment
        ((ra.350 r15)
         (tmp.12 r14)
         (tmp.13 r13)
         (tmp.176 r9)
         (c.110 r14)
         (tmp.351 r9))))
      (begin
        (set! ra.350 r15)
        (set! c.110 rdi)
        (set! tmp.12 rsi)
        (set! tmp.13 rdx)
        (set! tmp.351 (bitwise-and tmp.13 7))
        (set! tmp.176 tmp.351)
        (if (eq? tmp.176 0)
          (begin
            (set! rdx tmp.13)
            (set! rsi tmp.12)
            (set! rdi 14)
            (set! r15 ra.350)
            (jump L.jp.44 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.13)
            (set! rsi tmp.12)
            (set! rdi 6)
            (set! r15 ra.350)
            (jump L.jp.44 rbp r15 rdx rsi rdi)))))
    (define L.<.49.27
      ((assignment
        ((ra.352 r15)
         (tmp.14 r14)
         (tmp.15 r13)
         (tmp.183 r9)
         (c.109 r14)
         (tmp.353 r9))))
      (begin
        (set! ra.352 r15)
        (set! c.109 rdi)
        (set! tmp.14 rsi)
        (set! tmp.15 rdx)
        (set! tmp.353 (bitwise-and tmp.15 7))
        (set! tmp.183 tmp.353)
        (if (eq? tmp.183 0)
          (begin
            (set! rdx tmp.15)
            (set! rsi tmp.14)
            (set! rdi 14)
            (set! r15 ra.352)
            (jump L.jp.49 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.15)
            (set! rsi tmp.14)
            (set! rdi 6)
            (set! r15 ra.352)
            (jump L.jp.49 rbp r15 rdx rsi rdi)))))
    (define L.<=.50.26
      ((assignment
        ((ra.354 r15)
         (tmp.16 r14)
         (tmp.17 r13)
         (tmp.190 r9)
         (c.108 r14)
         (tmp.355 r9))))
      (begin
        (set! ra.354 r15)
        (set! c.108 rdi)
        (set! tmp.16 rsi)
        (set! tmp.17 rdx)
        (set! tmp.355 (bitwise-and tmp.17 7))
        (set! tmp.190 tmp.355)
        (if (eq? tmp.190 0)
          (begin
            (set! rdx tmp.17)
            (set! rsi tmp.16)
            (set! rdi 14)
            (set! r15 ra.354)
            (jump L.jp.54 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.17)
            (set! rsi tmp.16)
            (set! rdi 6)
            (set! r15 ra.354)
            (jump L.jp.54 rbp r15 rdx rsi rdi)))))
    (define L.>.51.25
      ((assignment
        ((ra.356 r15)
         (tmp.18 r14)
         (tmp.19 r13)
         (tmp.197 r9)
         (c.107 r14)
         (tmp.357 r9))))
      (begin
        (set! ra.356 r15)
        (set! c.107 rdi)
        (set! tmp.18 rsi)
        (set! tmp.19 rdx)
        (set! tmp.357 (bitwise-and tmp.19 7))
        (set! tmp.197 tmp.357)
        (if (eq? tmp.197 0)
          (begin
            (set! rdx tmp.19)
            (set! rsi tmp.18)
            (set! rdi 14)
            (set! r15 ra.356)
            (jump L.jp.59 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.19)
            (set! rsi tmp.18)
            (set! rdi 6)
            (set! r15 ra.356)
            (jump L.jp.59 rbp r15 rdx rsi rdi)))))
    (define L.>=.52.24
      ((assignment
        ((ra.358 r15)
         (tmp.20 r14)
         (tmp.21 r13)
         (tmp.204 r9)
         (c.106 r14)
         (tmp.359 r9))))
      (begin
        (set! ra.358 r15)
        (set! c.106 rdi)
        (set! tmp.20 rsi)
        (set! tmp.21 rdx)
        (set! tmp.359 (bitwise-and tmp.21 7))
        (set! tmp.204 tmp.359)
        (if (eq? tmp.204 0)
          (begin
            (set! rdx tmp.21)
            (set! rsi tmp.20)
            (set! rdi 14)
            (set! r15 ra.358)
            (jump L.jp.64 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.21)
            (set! rsi tmp.20)
            (set! rdi 6)
            (set! r15 ra.358)
            (jump L.jp.64 rbp r15 rdx rsi rdi)))))
    (define L.make-vector.53.23
      ((assignment
        ((ra.360 r15)
         (tmp.22 r14)
         (make-init-vector.1 r13)
         (tmp.207 r9)
         (c.105 r13)
         (tmp.361 r9))))
      (begin
        (set! ra.360 r15)
        (set! c.105 rdi)
        (set! tmp.22 rsi)
        (set! make-init-vector.1 (mref c.105 14))
        (set! tmp.361 (bitwise-and tmp.22 7))
        (set! tmp.207 tmp.361)
        (if (eq? tmp.207 0)
          (begin
            (set! rdx tmp.22)
            (set! rsi make-init-vector.1)
            (set! rdi 14)
            (set! r15 ra.360)
            (jump L.jp.66 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.22)
            (set! rsi make-init-vector.1)
            (set! rdi 6)
            (set! r15 ra.360)
            (jump L.jp.66 rbp r15 rdx rsi rdi)))))
    (define L.vector-length.54.22
      ((assignment
        ((ra.362 r15) (tmp.23 r14) (tmp.210 r13) (c.104 r14) (tmp.363 r13))))
      (begin
        (set! ra.362 r15)
        (set! c.104 rdi)
        (set! tmp.23 rsi)
        (set! tmp.363 (bitwise-and tmp.23 7))
        (set! tmp.210 tmp.363)
        (if (eq? tmp.210 3)
          (begin
            (set! rsi tmp.23)
            (set! rdi 14)
            (set! r15 ra.362)
            (jump L.jp.68 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.23)
            (set! rdi 6)
            (set! r15 ra.362)
            (jump L.jp.68 rbp r15 rsi rdi)))))
    (define L.vector-set!.55.21
      ((assignment
        ((ra.364 r15)
         (tmp.24 r14)
         (tmp.25 r13)
         (tmp.26 r9)
         (unsafe-vector-set!.2 rdi)
         (c.103 r8)
         (tmp.216 r8)
         (tmp.365 r8))))
      (begin
        (set! ra.364 r15)
        (set! c.103 rdi)
        (set! tmp.24 rsi)
        (set! tmp.25 rdx)
        (set! tmp.26 rcx)
        (set! unsafe-vector-set!.2 (mref c.103 14))
        (set! tmp.365 (bitwise-and tmp.25 7))
        (set! tmp.216 tmp.365)
        (if (eq? tmp.216 0)
          (begin
            (set! r8 tmp.25)
            (set! rcx tmp.26)
            (set! rdx unsafe-vector-set!.2)
            (set! rsi tmp.24)
            (set! rdi 14)
            (set! r15 ra.364)
            (jump L.jp.72 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 tmp.25)
            (set! rcx tmp.26)
            (set! rdx unsafe-vector-set!.2)
            (set! rsi tmp.24)
            (set! rdi 6)
            (set! r15 ra.364)
            (jump L.jp.72 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.vector-ref.56.20
      ((assignment
        ((ra.366 r15)
         (tmp.27 r14)
         (tmp.28 r13)
         (unsafe-vector-ref.3 r9)
         (c.102 r9)
         (tmp.222 r8)
         (tmp.367 r8))))
      (begin
        (set! ra.366 r15)
        (set! c.102 rdi)
        (set! tmp.27 rsi)
        (set! tmp.28 rdx)
        (set! unsafe-vector-ref.3 (mref c.102 14))
        (set! tmp.367 (bitwise-and tmp.28 7))
        (set! tmp.222 tmp.367)
        (if (eq? tmp.222 0)
          (begin
            (set! rcx tmp.28)
            (set! rdx unsafe-vector-ref.3)
            (set! rsi tmp.27)
            (set! rdi 14)
            (set! r15 ra.366)
            (jump L.jp.76 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx tmp.28)
            (set! rdx unsafe-vector-ref.3)
            (set! rsi tmp.27)
            (set! rdi 6)
            (set! r15 ra.366)
            (jump L.jp.76 rbp r15 rcx rdx rsi rdi)))))
    (define L.car.57.19
      ((assignment
        ((ra.368 r15) (tmp.29 r14) (tmp.225 r13) (c.101 r14) (tmp.369 r13))))
      (begin
        (set! ra.368 r15)
        (set! c.101 rdi)
        (set! tmp.29 rsi)
        (set! tmp.369 (bitwise-and tmp.29 7))
        (set! tmp.225 tmp.369)
        (if (eq? tmp.225 1)
          (begin
            (set! rsi tmp.29)
            (set! rdi 14)
            (set! r15 ra.368)
            (jump L.jp.78 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.29)
            (set! rdi 6)
            (set! r15 ra.368)
            (jump L.jp.78 rbp r15 rsi rdi)))))
    (define L.cdr.58.18
      ((assignment
        ((ra.370 r15) (tmp.30 r14) (tmp.228 r13) (c.100 r14) (tmp.371 r13))))
      (begin
        (set! ra.370 r15)
        (set! c.100 rdi)
        (set! tmp.30 rsi)
        (set! tmp.371 (bitwise-and tmp.30 7))
        (set! tmp.228 tmp.371)
        (if (eq? tmp.228 1)
          (begin
            (set! rsi tmp.30)
            (set! rdi 14)
            (set! r15 ra.370)
            (jump L.jp.80 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.30)
            (set! rdi 6)
            (set! r15 ra.370)
            (jump L.jp.80 rbp r15 rsi rdi)))))
    (define L.procedure-arity.59.17
      ((assignment
        ((ra.372 r15) (tmp.31 r14) (tmp.231 r13) (c.99 r14) (tmp.373 r13))))
      (begin
        (set! ra.372 r15)
        (set! c.99 rdi)
        (set! tmp.31 rsi)
        (set! tmp.373 (bitwise-and tmp.31 7))
        (set! tmp.231 tmp.373)
        (if (eq? tmp.231 2)
          (begin
            (set! rsi tmp.31)
            (set! rdi 14)
            (set! r15 ra.372)
            (jump L.jp.82 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.31)
            (set! rdi 6)
            (set! r15 ra.372)
            (jump L.jp.82 rbp r15 rsi rdi)))))
    (define L.fixnum?.60.16
      ((assignment
        ((ra.374 r15) (c.98 r14) (tmp.233 r14) (tmp.32 r14) (tmp.375 r14))))
      (begin
        (set! ra.374 r15)
        (set! c.98 rdi)
        (set! tmp.32 rsi)
        (set! tmp.375 (bitwise-and tmp.32 7))
        (set! tmp.233 tmp.375)
        (if (eq? tmp.233 0)
          (begin (set! rax 14) (jump ra.374 rbp rax))
          (begin (set! rax 6) (jump ra.374 rbp rax)))))
    (define L.boolean?.61.15
      ((assignment
        ((ra.376 r15) (c.97 r14) (tmp.235 r14) (tmp.33 r14) (tmp.377 r14))))
      (begin
        (set! ra.376 r15)
        (set! c.97 rdi)
        (set! tmp.33 rsi)
        (set! tmp.377 (bitwise-and tmp.33 247))
        (set! tmp.235 tmp.377)
        (if (eq? tmp.235 6)
          (begin (set! rax 14) (jump ra.376 rbp rax))
          (begin (set! rax 6) (jump ra.376 rbp rax)))))
    (define L.empty?.62.14
      ((assignment
        ((ra.378 r15) (c.96 r14) (tmp.237 r14) (tmp.34 r14) (tmp.379 r14))))
      (begin
        (set! ra.378 r15)
        (set! c.96 rdi)
        (set! tmp.34 rsi)
        (set! tmp.379 (bitwise-and tmp.34 255))
        (set! tmp.237 tmp.379)
        (if (eq? tmp.237 22)
          (begin (set! rax 14) (jump ra.378 rbp rax))
          (begin (set! rax 6) (jump ra.378 rbp rax)))))
    (define L.void?.63.13
      ((assignment
        ((ra.380 r15) (c.95 r14) (tmp.239 r14) (tmp.35 r14) (tmp.381 r14))))
      (begin
        (set! ra.380 r15)
        (set! c.95 rdi)
        (set! tmp.35 rsi)
        (set! tmp.381 (bitwise-and tmp.35 255))
        (set! tmp.239 tmp.381)
        (if (eq? tmp.239 30)
          (begin (set! rax 14) (jump ra.380 rbp rax))
          (begin (set! rax 6) (jump ra.380 rbp rax)))))
    (define L.ascii-char?.64.12
      ((assignment
        ((ra.382 r15) (c.94 r14) (tmp.241 r14) (tmp.36 r14) (tmp.383 r14))))
      (begin
        (set! ra.382 r15)
        (set! c.94 rdi)
        (set! tmp.36 rsi)
        (set! tmp.383 (bitwise-and tmp.36 255))
        (set! tmp.241 tmp.383)
        (if (eq? tmp.241 46)
          (begin (set! rax 14) (jump ra.382 rbp rax))
          (begin (set! rax 6) (jump ra.382 rbp rax)))))
    (define L.error?.65.11
      ((assignment
        ((ra.384 r15) (c.93 r14) (tmp.243 r14) (tmp.37 r14) (tmp.385 r14))))
      (begin
        (set! ra.384 r15)
        (set! c.93 rdi)
        (set! tmp.37 rsi)
        (set! tmp.385 (bitwise-and tmp.37 255))
        (set! tmp.243 tmp.385)
        (if (eq? tmp.243 62)
          (begin (set! rax 14) (jump ra.384 rbp rax))
          (begin (set! rax 6) (jump ra.384 rbp rax)))))
    (define L.pair?.66.10
      ((assignment
        ((ra.386 r15) (c.92 r14) (tmp.245 r14) (tmp.38 r14) (tmp.387 r14))))
      (begin
        (set! ra.386 r15)
        (set! c.92 rdi)
        (set! tmp.38 rsi)
        (set! tmp.387 (bitwise-and tmp.38 7))
        (set! tmp.245 tmp.387)
        (if (eq? tmp.245 1)
          (begin (set! rax 14) (jump ra.386 rbp rax))
          (begin (set! rax 6) (jump ra.386 rbp rax)))))
    (define L.procedure?.67.9
      ((assignment
        ((ra.388 r15) (c.91 r14) (tmp.247 r14) (tmp.39 r14) (tmp.389 r14))))
      (begin
        (set! ra.388 r15)
        (set! c.91 rdi)
        (set! tmp.39 rsi)
        (set! tmp.389 (bitwise-and tmp.39 7))
        (set! tmp.247 tmp.389)
        (if (eq? tmp.247 2)
          (begin (set! rax 14) (jump ra.388 rbp rax))
          (begin (set! rax 6) (jump ra.388 rbp rax)))))
    (define L.vector?.68.8
      ((assignment
        ((ra.390 r15) (c.90 r14) (tmp.249 r14) (tmp.40 r14) (tmp.391 r14))))
      (begin
        (set! ra.390 r15)
        (set! c.90 rdi)
        (set! tmp.40 rsi)
        (set! tmp.391 (bitwise-and tmp.40 7))
        (set! tmp.249 tmp.391)
        (if (eq? tmp.249 3)
          (begin (set! rax 14) (jump ra.390 rbp rax))
          (begin (set! rax 6) (jump ra.390 rbp rax)))))
    (define L.not.69.7
      ((assignment ((ra.392 r15) (c.89 r14) (tmp.41 r14))))
      (begin
        (set! ra.392 r15)
        (set! c.89 rdi)
        (set! tmp.41 rsi)
        (if (neq? tmp.41 6)
          (begin (set! rax 6) (jump ra.392 rbp rax))
          (begin (set! rax 14) (jump ra.392 rbp rax)))))
    (define L.cons.70.6
      ((assignment
        ((ra.393 r15)
         (tmp.42 r14)
         (tmp.43 r13)
         (c.88 r14)
         (tmp.251 r9)
         (tmp.394 r9)
         (tmp.124 r9))))
      (begin
        (set! ra.393 r15)
        (set! c.88 rdi)
        (set! tmp.42 rsi)
        (set! tmp.43 rdx)
        (set! tmp.251 r12)
        (set! r12 (+ r12 16))
        (set! tmp.394 (+ tmp.251 1))
        (set! tmp.124 tmp.394)
        (mset! tmp.124 -1 tmp.42)
        (mset! tmp.124 7 tmp.43)
        (set! rax tmp.124)
        (jump ra.393 rbp rax)))
    (define L.eq?.71.5
      ((assignment ((ra.395 r15) (tmp.44 r14) (c.87 r14) (tmp.45 r13))))
      (begin
        (set! ra.395 r15)
        (set! c.87 rdi)
        (set! tmp.44 rsi)
        (set! tmp.45 rdx)
        (if (eq? tmp.44 tmp.45)
          (begin (set! rax 14) (jump ra.395 rbp rax))
          (begin (set! rax 6) (jump ra.395 rbp rax)))))
    (define L.make-init-vector.1.4
      ((assignment
        ((ra.396 r15)
         (tmp.72 r14)
         (vector-init-loop.74 r13)
         (tmp.253 r9)
         (tmp.398 r8)
         (tmp.489 r9)
         (tmp.256 r8)
         (c.86 r13)
         (tmp.397 r9)
         (tmp.399 r9)
         (tmp.254 r9)
         (tmp.400 r9)
         (tmp.255 r9)
         (tmp.73 r9)
         (tmp.401 r9)
         (tmp.125 r9)
         (tmp.116 r13))))
      (begin
        (set! ra.396 r15)
        (set! c.86 rdi)
        (set! tmp.72 rsi)
        (set! vector-init-loop.74 (mref c.86 14))
        (set! tmp.397 (arithmetic-shift-right tmp.72 3))
        (set! tmp.253 tmp.397)
        (set! tmp.398 1)
        (set! tmp.399 (+ tmp.398 tmp.253))
        (set! tmp.254 tmp.399)
        (set! tmp.400 (* tmp.254 8))
        (set! tmp.255 tmp.400)
        (set! tmp.489 tmp.255)
        (set! tmp.256 r12)
        (set! r12 (+ r12 tmp.489))
        (set! tmp.401 (+ tmp.256 3))
        (set! tmp.125 tmp.401)
        (mset! tmp.125 -3 tmp.72)
        (set! tmp.73 tmp.125)
        (set! tmp.116 vector-init-loop.74)
        (set! rcx tmp.73)
        (set! rdx 0)
        (set! rsi tmp.72)
        (set! rdi vector-init-loop.74)
        (set! r15 ra.396)
        (jump L.vector-init-loop.74.3 rbp r15 rcx rdx rsi rdi)))
    (define L.vector-init-loop.74.3
      ((assignment
        ((ra.402 r15)
         (len.75 r14)
         (i.77 r13)
         (c.85 r9)
         (vec.76 r8)
         (vector-init-loop.74 r9))))
      (begin
        (set! ra.402 r15)
        (set! c.85 rdi)
        (set! len.75 rsi)
        (set! i.77 rdx)
        (set! vec.76 rcx)
        (set! vector-init-loop.74 (mref c.85 14))
        (if (eq? len.75 i.77)
          (begin
            (set! r8 vec.76)
            (set! rcx vector-init-loop.74)
            (set! rdx len.75)
            (set! rsi i.77)
            (set! rdi 14)
            (set! r15 ra.402)
            (jump L.jp.95 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 vec.76)
            (set! rcx vector-init-loop.74)
            (set! rdx len.75)
            (set! rsi i.77)
            (set! rdi 6)
            (set! r15 ra.402)
            (jump L.jp.95 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.unsafe-vector-set!.2.2
      ((assignment
        ((ra.403 r15)
         (tmp.78 r14)
         (tmp.79 r13)
         (tmp.80 r9)
         (tmp.270 r8)
         (c.84 r14))))
      (begin
        (set! ra.403 r15)
        (set! c.84 rdi)
        (set! tmp.78 rsi)
        (set! tmp.79 rdx)
        (set! tmp.80 rcx)
        (set! tmp.270 (mref tmp.78 -3))
        (if (< tmp.79 tmp.270)
          (begin
            (set! rcx tmp.80)
            (set! rdx tmp.78)
            (set! rsi tmp.79)
            (set! rdi 14)
            (set! r15 ra.403)
            (jump L.jp.99 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx tmp.80)
            (set! rdx tmp.78)
            (set! rsi tmp.79)
            (set! rdi 6)
            (set! r15 ra.403)
            (jump L.jp.99 rbp r15 rcx rdx rsi rdi)))))
    (define L.unsafe-vector-ref.3.1
      ((assignment
        ((ra.404 r15) (tmp.78 r14) (tmp.79 r13) (tmp.278 r9) (c.83 r14))))
      (begin
        (set! ra.404 r15)
        (set! c.83 rdi)
        (set! tmp.78 rsi)
        (set! tmp.79 rdx)
        (set! tmp.278 (mref tmp.78 -3))
        (if (< tmp.79 tmp.278)
          (begin
            (set! rdx tmp.78)
            (set! rsi tmp.79)
            (set! rdi 14)
            (set! r15 ra.404)
            (jump L.jp.103 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.78)
            (set! rsi tmp.79)
            (set! rdi 6)
            (set! r15 ra.404)
            (jump L.jp.103 rbp r15 rdx rsi rdi)))))
    (define L.jp.103
      ((assignment ((ra.405 r15) (tmp.272 r14) (tmp.79 r13) (tmp.78 r9))))
      (begin
        (set! ra.405 r15)
        (set! tmp.272 rdi)
        (set! tmp.79 rsi)
        (set! tmp.78 rdx)
        (if (neq? tmp.272 6)
          (if (>= tmp.79 0)
            (begin
              (set! rdx tmp.78)
              (set! rsi tmp.79)
              (set! rdi 14)
              (set! r15 ra.405)
              (jump L.jp.102 rbp r15 rdx rsi rdi))
            (begin
              (set! rdx tmp.78)
              (set! rsi tmp.79)
              (set! rdi 6)
              (set! r15 ra.405)
              (jump L.jp.102 rbp r15 rdx rsi rdi)))
          (begin (set! rax 2622) (jump ra.405 rbp rax)))))
    (define L.jp.102
      ((assignment
        ((ra.406 r15)
         (tmp.78 r14)
         (tmp.274 r13)
         (tmp.79 r9)
         (tmp.407 r13)
         (tmp.275 r13)
         (tmp.408 r13)
         (tmp.276 r13)
         (tmp.409 r13)
         (tmp.277 r13))))
      (begin
        (set! ra.406 r15)
        (set! tmp.274 rdi)
        (set! tmp.79 rsi)
        (set! tmp.78 rdx)
        (if (neq? tmp.274 6)
          (begin
            (set! tmp.407 (arithmetic-shift-right tmp.79 3))
            (set! tmp.275 tmp.407)
            (set! tmp.408 (* tmp.275 8))
            (set! tmp.276 tmp.408)
            (set! tmp.409 (+ tmp.276 5))
            (set! tmp.277 tmp.409)
            (set! rax (mref tmp.78 tmp.277))
            (jump ra.406 rbp rax))
          (begin (set! rax 2622) (jump ra.406 rbp rax)))))
    (define L.jp.99
      ((assignment
        ((ra.410 r15) (tmp.264 r14) (tmp.79 r13) (tmp.78 r9) (tmp.80 r8))))
      (begin
        (set! ra.410 r15)
        (set! tmp.264 rdi)
        (set! tmp.79 rsi)
        (set! tmp.78 rdx)
        (set! tmp.80 rcx)
        (if (neq? tmp.264 6)
          (if (>= tmp.79 0)
            (begin
              (set! rcx tmp.78)
              (set! rdx tmp.80)
              (set! rsi tmp.79)
              (set! rdi 14)
              (set! r15 ra.410)
              (jump L.jp.98 rbp r15 rcx rdx rsi rdi))
            (begin
              (set! rcx tmp.78)
              (set! rdx tmp.80)
              (set! rsi tmp.79)
              (set! rdi 6)
              (set! r15 ra.410)
              (jump L.jp.98 rbp r15 rcx rdx rsi rdi)))
          (begin (set! rax 2366) (jump ra.410 rbp rax)))))
    (define L.jp.98
      ((assignment
        ((ra.411 r15)
         (tmp.80 r14)
         (tmp.78 r13)
         (tmp.266 r9)
         (tmp.79 r8)
         (tmp.412 r9)
         (tmp.267 r9)
         (tmp.413 r9)
         (tmp.268 r9)
         (tmp.414 r9)
         (tmp.269 r9))))
      (begin
        (set! ra.411 r15)
        (set! tmp.266 rdi)
        (set! tmp.79 rsi)
        (set! tmp.80 rdx)
        (set! tmp.78 rcx)
        (if (neq? tmp.266 6)
          (begin
            (set! tmp.412 (arithmetic-shift-right tmp.79 3))
            (set! tmp.267 tmp.412)
            (set! tmp.413 (* tmp.267 8))
            (set! tmp.268 tmp.413)
            (set! tmp.414 (+ tmp.268 5))
            (set! tmp.269 tmp.414)
            (mset! tmp.78 tmp.269 tmp.80)
            (set! rax tmp.78)
            (jump ra.411 rbp rax))
          (begin (set! rax 2366) (jump ra.411 rbp rax)))))
    (define L.jp.95
      ((assignment
        ((ra.415 r15)
         (len.75 r14)
         (vector-init-loop.74 r13)
         (i.77 r9)
         (vec.76 r8)
         (tmp.258 rdi)
         (tmp.262 r9)
         (tmp.261 rdi)
         (tmp.418 rdi)
         (tmp.260 rdi)
         (tmp.417 rdi)
         (tmp.259 rdi)
         (tmp.416 rdi)
         (tmp.419 r9)
         (tmp.115 r13))))
      (begin
        (set! ra.415 r15)
        (set! tmp.258 rdi)
        (set! i.77 rsi)
        (set! len.75 rdx)
        (set! vector-init-loop.74 rcx)
        (set! vec.76 r8)
        (if (neq? tmp.258 6)
          (begin (set! rax vec.76) (jump ra.415 rbp rax))
          (begin
            (set! tmp.416 (arithmetic-shift-right i.77 3))
            (set! tmp.259 tmp.416)
            (set! tmp.417 (* tmp.259 8))
            (set! tmp.260 tmp.417)
            (set! tmp.418 (+ tmp.260 5))
            (set! tmp.261 tmp.418)
            (mset! vec.76 tmp.261 0)
            (set! tmp.115 vector-init-loop.74)
            (set! tmp.419 (+ i.77 8))
            (set! tmp.262 tmp.419)
            (set! rcx vec.76)
            (set! rdx tmp.262)
            (set! rsi len.75)
            (set! rdi vector-init-loop.74)
            (set! r15 ra.415)
            (jump L.vector-init-loop.74.3 rbp r15 rcx rdx rsi rdi)))))
    (define L.jp.82
      ((assignment ((ra.420 r15) (tmp.230 r14) (tmp.31 r13))))
      (begin
        (set! ra.420 r15)
        (set! tmp.230 rdi)
        (set! tmp.31 rsi)
        (if (neq? tmp.230 6)
          (begin (set! rax (mref tmp.31 6)) (jump ra.420 rbp rax))
          (begin (set! rax 3390) (jump ra.420 rbp rax)))))
    (define L.jp.80
      ((assignment ((ra.421 r15) (tmp.227 r14) (tmp.30 r13))))
      (begin
        (set! ra.421 r15)
        (set! tmp.227 rdi)
        (set! tmp.30 rsi)
        (if (neq? tmp.227 6)
          (begin (set! rax (mref tmp.30 7)) (jump ra.421 rbp rax))
          (begin (set! rax 3134) (jump ra.421 rbp rax)))))
    (define L.jp.78
      ((assignment ((ra.422 r15) (tmp.224 r14) (tmp.29 r13))))
      (begin
        (set! ra.422 r15)
        (set! tmp.224 rdi)
        (set! tmp.29 rsi)
        (if (neq? tmp.224 6)
          (begin (set! rax (mref tmp.29 -1)) (jump ra.422 rbp rax))
          (begin (set! rax 2878) (jump ra.422 rbp rax)))))
    (define L.jp.76
      ((assignment
        ((ra.423 r15)
         (tmp.27 r14)
         (unsafe-vector-ref.3 r13)
         (tmp.28 r9)
         (tmp.218 r8)
         (tmp.221 r8)
         (tmp.424 r8))))
      (begin
        (set! ra.423 r15)
        (set! tmp.218 rdi)
        (set! tmp.27 rsi)
        (set! unsafe-vector-ref.3 rdx)
        (set! tmp.28 rcx)
        (if (neq? tmp.218 6)
          (begin
            (set! tmp.424 (bitwise-and tmp.27 7))
            (set! tmp.221 tmp.424)
            (if (eq? tmp.221 3)
              (begin
                (set! rcx tmp.27)
                (set! rdx tmp.28)
                (set! rsi unsafe-vector-ref.3)
                (set! rdi 14)
                (set! r15 ra.423)
                (jump L.jp.75 rbp r15 rcx rdx rsi rdi))
              (begin
                (set! rcx tmp.27)
                (set! rdx tmp.28)
                (set! rsi unsafe-vector-ref.3)
                (set! rdi 6)
                (set! r15 ra.423)
                (jump L.jp.75 rbp r15 rcx rdx rsi rdi))))
          (begin (set! rax 2622) (jump ra.423 rbp rax)))))
    (define L.jp.75
      ((assignment
        ((ra.425 r15)
         (unsafe-vector-ref.3 r14)
         (tmp.220 r13)
         (tmp.28 r9)
         (tmp.27 r8)
         (tmp.117 r14))))
      (begin
        (set! ra.425 r15)
        (set! tmp.220 rdi)
        (set! unsafe-vector-ref.3 rsi)
        (set! tmp.28 rdx)
        (set! tmp.27 rcx)
        (if (neq? tmp.220 6)
          (begin
            (set! tmp.117 unsafe-vector-ref.3)
            (set! rdx tmp.28)
            (set! rsi tmp.27)
            (set! rdi unsafe-vector-ref.3)
            (set! r15 ra.425)
            (jump L.unsafe-vector-ref.3.1 rbp r15 rdx rsi rdi))
          (begin (set! rax 2622) (jump ra.425 rbp rax)))))
    (define L.jp.72
      ((assignment
        ((ra.426 r15)
         (tmp.24 r14)
         (unsafe-vector-set!.2 r13)
         (tmp.26 r9)
         (tmp.212 rdi)
         (tmp.25 rsi)
         (tmp.215 r8)
         (tmp.427 r8))))
      (begin
        (set! ra.426 r15)
        (set! tmp.212 rdi)
        (set! tmp.24 rsi)
        (set! unsafe-vector-set!.2 rdx)
        (set! tmp.26 rcx)
        (set! tmp.25 r8)
        (if (neq? tmp.212 6)
          (begin
            (set! tmp.427 (bitwise-and tmp.24 7))
            (set! tmp.215 tmp.427)
            (if (eq? tmp.215 3)
              (begin
                (set! r8 tmp.24)
                (set! rcx tmp.25)
                (set! rdx tmp.26)
                (set! rsi unsafe-vector-set!.2)
                (set! rdi 14)
                (set! r15 ra.426)
                (jump L.jp.71 rbp r15 r8 rcx rdx rsi rdi))
              (begin
                (set! r8 tmp.24)
                (set! rcx tmp.25)
                (set! rdx tmp.26)
                (set! rsi unsafe-vector-set!.2)
                (set! rdi 6)
                (set! r15 ra.426)
                (jump L.jp.71 rbp r15 r8 rcx rdx rsi rdi))))
          (begin (set! rax 2366) (jump ra.426 rbp rax)))))
    (define L.jp.71
      ((assignment
        ((ra.428 r15)
         (unsafe-vector-set!.2 r14)
         (tmp.214 r13)
         (tmp.26 r9)
         (tmp.25 rdi)
         (tmp.24 r8)
         (tmp.118 r14))))
      (begin
        (set! ra.428 r15)
        (set! tmp.214 rdi)
        (set! unsafe-vector-set!.2 rsi)
        (set! tmp.26 rdx)
        (set! tmp.25 rcx)
        (set! tmp.24 r8)
        (if (neq? tmp.214 6)
          (begin
            (set! tmp.118 unsafe-vector-set!.2)
            (set! rcx tmp.26)
            (set! rdx tmp.25)
            (set! rsi tmp.24)
            (set! rdi unsafe-vector-set!.2)
            (set! r15 ra.428)
            (jump L.unsafe-vector-set!.2.2 rbp r15 rcx rdx rsi rdi))
          (begin (set! rax 2366) (jump ra.428 rbp rax)))))
    (define L.jp.68
      ((assignment ((ra.429 r15) (tmp.209 r14) (tmp.23 r13))))
      (begin
        (set! ra.429 r15)
        (set! tmp.209 rdi)
        (set! tmp.23 rsi)
        (if (neq? tmp.209 6)
          (begin (set! rax (mref tmp.23 -3)) (jump ra.429 rbp rax))
          (begin (set! rax 2110) (jump ra.429 rbp rax)))))
    (define L.jp.66
      ((assignment
        ((ra.430 r15)
         (make-init-vector.1 r14)
         (tmp.206 r13)
         (tmp.22 r9)
         (tmp.119 r14))))
      (begin
        (set! ra.430 r15)
        (set! tmp.206 rdi)
        (set! make-init-vector.1 rsi)
        (set! tmp.22 rdx)
        (if (neq? tmp.206 6)
          (begin
            (set! tmp.119 make-init-vector.1)
            (set! rsi tmp.22)
            (set! rdi make-init-vector.1)
            (set! r15 ra.430)
            (jump L.make-init-vector.1.4 rbp r15 rsi rdi))
          (begin (set! rax 1854) (jump ra.430 rbp rax)))))
    (define L.jp.64
      ((assignment
        ((ra.431 r15)
         (tmp.20 r14)
         (tmp.21 r13)
         (tmp.199 r9)
         (tmp.203 r9)
         (tmp.432 r9))))
      (begin
        (set! ra.431 r15)
        (set! tmp.199 rdi)
        (set! tmp.20 rsi)
        (set! tmp.21 rdx)
        (if (neq? tmp.199 6)
          (begin
            (set! tmp.432 (bitwise-and tmp.20 7))
            (set! tmp.203 tmp.432)
            (if (eq? tmp.203 0)
              (begin
                (set! rdx tmp.21)
                (set! rsi tmp.20)
                (set! rdi 14)
                (set! r15 ra.431)
                (jump L.jp.63 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.21)
                (set! rsi tmp.20)
                (set! rdi 6)
                (set! r15 ra.431)
                (jump L.jp.63 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1598) (jump ra.431 rbp rax)))))
    (define L.jp.63
      ((assignment ((ra.433 r15) (tmp.201 r14) (tmp.20 r13) (tmp.21 r9))))
      (begin
        (set! ra.433 r15)
        (set! tmp.201 rdi)
        (set! tmp.20 rsi)
        (set! tmp.21 rdx)
        (if (neq? tmp.201 6)
          (if (>= tmp.20 tmp.21)
            (begin (set! rax 14) (jump ra.433 rbp rax))
            (begin (set! rax 6) (jump ra.433 rbp rax)))
          (begin (set! rax 1598) (jump ra.433 rbp rax)))))
    (define L.jp.59
      ((assignment
        ((ra.434 r15)
         (tmp.18 r14)
         (tmp.19 r13)
         (tmp.192 r9)
         (tmp.196 r9)
         (tmp.435 r9))))
      (begin
        (set! ra.434 r15)
        (set! tmp.192 rdi)
        (set! tmp.18 rsi)
        (set! tmp.19 rdx)
        (if (neq? tmp.192 6)
          (begin
            (set! tmp.435 (bitwise-and tmp.18 7))
            (set! tmp.196 tmp.435)
            (if (eq? tmp.196 0)
              (begin
                (set! rdx tmp.19)
                (set! rsi tmp.18)
                (set! rdi 14)
                (set! r15 ra.434)
                (jump L.jp.58 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.19)
                (set! rsi tmp.18)
                (set! rdi 6)
                (set! r15 ra.434)
                (jump L.jp.58 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1342) (jump ra.434 rbp rax)))))
    (define L.jp.58
      ((assignment ((ra.436 r15) (tmp.194 r14) (tmp.18 r13) (tmp.19 r9))))
      (begin
        (set! ra.436 r15)
        (set! tmp.194 rdi)
        (set! tmp.18 rsi)
        (set! tmp.19 rdx)
        (if (neq? tmp.194 6)
          (if (> tmp.18 tmp.19)
            (begin (set! rax 14) (jump ra.436 rbp rax))
            (begin (set! rax 6) (jump ra.436 rbp rax)))
          (begin (set! rax 1342) (jump ra.436 rbp rax)))))
    (define L.jp.54
      ((assignment
        ((ra.437 r15)
         (tmp.16 r14)
         (tmp.17 r13)
         (tmp.185 r9)
         (tmp.189 r9)
         (tmp.438 r9))))
      (begin
        (set! ra.437 r15)
        (set! tmp.185 rdi)
        (set! tmp.16 rsi)
        (set! tmp.17 rdx)
        (if (neq? tmp.185 6)
          (begin
            (set! tmp.438 (bitwise-and tmp.16 7))
            (set! tmp.189 tmp.438)
            (if (eq? tmp.189 0)
              (begin
                (set! rdx tmp.17)
                (set! rsi tmp.16)
                (set! rdi 14)
                (set! r15 ra.437)
                (jump L.jp.53 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.17)
                (set! rsi tmp.16)
                (set! rdi 6)
                (set! r15 ra.437)
                (jump L.jp.53 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1086) (jump ra.437 rbp rax)))))
    (define L.jp.53
      ((assignment ((ra.439 r15) (tmp.187 r14) (tmp.16 r13) (tmp.17 r9))))
      (begin
        (set! ra.439 r15)
        (set! tmp.187 rdi)
        (set! tmp.16 rsi)
        (set! tmp.17 rdx)
        (if (neq? tmp.187 6)
          (if (<= tmp.16 tmp.17)
            (begin (set! rax 14) (jump ra.439 rbp rax))
            (begin (set! rax 6) (jump ra.439 rbp rax)))
          (begin (set! rax 1086) (jump ra.439 rbp rax)))))
    (define L.jp.49
      ((assignment
        ((ra.440 r15)
         (tmp.14 r14)
         (tmp.15 r13)
         (tmp.178 r9)
         (tmp.182 r9)
         (tmp.441 r9))))
      (begin
        (set! ra.440 r15)
        (set! tmp.178 rdi)
        (set! tmp.14 rsi)
        (set! tmp.15 rdx)
        (if (neq? tmp.178 6)
          (begin
            (set! tmp.441 (bitwise-and tmp.14 7))
            (set! tmp.182 tmp.441)
            (if (eq? tmp.182 0)
              (begin
                (set! rdx tmp.15)
                (set! rsi tmp.14)
                (set! rdi 14)
                (set! r15 ra.440)
                (jump L.jp.48 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.15)
                (set! rsi tmp.14)
                (set! rdi 6)
                (set! r15 ra.440)
                (jump L.jp.48 rbp r15 rdx rsi rdi))))
          (begin (set! rax 830) (jump ra.440 rbp rax)))))
    (define L.jp.48
      ((assignment ((ra.442 r15) (tmp.180 r14) (tmp.14 r13) (tmp.15 r9))))
      (begin
        (set! ra.442 r15)
        (set! tmp.180 rdi)
        (set! tmp.14 rsi)
        (set! tmp.15 rdx)
        (if (neq? tmp.180 6)
          (if (< tmp.14 tmp.15)
            (begin (set! rax 14) (jump ra.442 rbp rax))
            (begin (set! rax 6) (jump ra.442 rbp rax)))
          (begin (set! rax 830) (jump ra.442 rbp rax)))))
    (define L.jp.44
      ((assignment
        ((ra.443 r15)
         (tmp.12 r14)
         (tmp.13 r13)
         (tmp.172 r9)
         (tmp.175 r9)
         (tmp.444 r9))))
      (begin
        (set! ra.443 r15)
        (set! tmp.172 rdi)
        (set! tmp.12 rsi)
        (set! tmp.13 rdx)
        (if (neq? tmp.172 6)
          (begin
            (set! tmp.444 (bitwise-and tmp.12 7))
            (set! tmp.175 tmp.444)
            (if (eq? tmp.175 0)
              (begin
                (set! rdx tmp.13)
                (set! rsi tmp.12)
                (set! rdi 14)
                (set! r15 ra.443)
                (jump L.jp.43 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.13)
                (set! rsi tmp.12)
                (set! rdi 6)
                (set! r15 ra.443)
                (jump L.jp.43 rbp r15 rdx rsi rdi))))
          (begin (set! rax 574) (jump ra.443 rbp rax)))))
    (define L.jp.43
      ((assignment
        ((ra.445 r15) (tmp.174 r14) (tmp.12 r13) (tmp.13 r9) (tmp.446 r14))))
      (begin
        (set! ra.445 r15)
        (set! tmp.174 rdi)
        (set! tmp.12 rsi)
        (set! tmp.13 rdx)
        (if (neq? tmp.174 6)
          (begin
            (set! tmp.446 (- tmp.12 tmp.13))
            (set! rax tmp.446)
            (jump ra.445 rbp rax))
          (begin (set! rax 574) (jump ra.445 rbp rax)))))
    (define L.jp.40
      ((assignment
        ((ra.447 r15)
         (tmp.10 r14)
         (tmp.11 r13)
         (tmp.166 r9)
         (tmp.169 r9)
         (tmp.448 r9))))
      (begin
        (set! ra.447 r15)
        (set! tmp.166 rdi)
        (set! tmp.10 rsi)
        (set! tmp.11 rdx)
        (if (neq? tmp.166 6)
          (begin
            (set! tmp.448 (bitwise-and tmp.10 7))
            (set! tmp.169 tmp.448)
            (if (eq? tmp.169 0)
              (begin
                (set! rdx tmp.11)
                (set! rsi tmp.10)
                (set! rdi 14)
                (set! r15 ra.447)
                (jump L.jp.39 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.11)
                (set! rsi tmp.10)
                (set! rdi 6)
                (set! r15 ra.447)
                (jump L.jp.39 rbp r15 rdx rsi rdi))))
          (begin (set! rax 318) (jump ra.447 rbp rax)))))
    (define L.jp.39
      ((assignment
        ((ra.449 r15) (tmp.168 r14) (tmp.10 r13) (tmp.11 r9) (tmp.450 r14))))
      (begin
        (set! ra.449 r15)
        (set! tmp.168 rdi)
        (set! tmp.10 rsi)
        (set! tmp.11 rdx)
        (if (neq? tmp.168 6)
          (begin
            (set! tmp.450 (+ tmp.10 tmp.11))
            (set! rax tmp.450)
            (jump ra.449 rbp rax))
          (begin (set! rax 318) (jump ra.449 rbp rax)))))
    (define L.jp.36
      ((assignment
        ((ra.451 r15)
         (tmp.8 r14)
         (tmp.9 r13)
         (tmp.159 r9)
         (tmp.163 r9)
         (tmp.452 r9))))
      (begin
        (set! ra.451 r15)
        (set! tmp.159 rdi)
        (set! tmp.8 rsi)
        (set! tmp.9 rdx)
        (if (neq? tmp.159 6)
          (begin
            (set! tmp.452 (bitwise-and tmp.8 7))
            (set! tmp.163 tmp.452)
            (if (eq? tmp.163 0)
              (begin
                (set! rdx tmp.8)
                (set! rsi tmp.9)
                (set! rdi 14)
                (set! r15 ra.451)
                (jump L.jp.35 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.8)
                (set! rsi tmp.9)
                (set! rdi 6)
                (set! r15 ra.451)
                (jump L.jp.35 rbp r15 rdx rsi rdi))))
          (begin (set! rax 62) (jump ra.451 rbp rax)))))
    (define L.jp.35
      ((assignment
        ((ra.453 r15)
         (tmp.8 r14)
         (tmp.161 r13)
         (tmp.9 r9)
         (tmp.454 r13)
         (tmp.162 r13)
         (tmp.455 r14))))
      (begin
        (set! ra.453 r15)
        (set! tmp.161 rdi)
        (set! tmp.9 rsi)
        (set! tmp.8 rdx)
        (if (neq? tmp.161 6)
          (begin
            (set! tmp.454 (arithmetic-shift-right tmp.9 3))
            (set! tmp.162 tmp.454)
            (set! tmp.455 (* tmp.8 tmp.162))
            (set! rax tmp.455)
            (jump ra.453 rbp rax))
          (begin (set! rax 62) (jump ra.453 rbp rax))))))
     ) 2))

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
     (execute '(module
    (define L.main.104
      ((new-frames ())
       (locals
        (tmp.123
         x.7
         tmp.122
         two.5
         tmp.157
         tmp.343
         tmp.310
         i.4
         tmp.156
         tmp.342
         tmp.309
         *.46
         tmp.155
         tmp.341
         tmp.308
         |+.47|
         tmp.154
         tmp.340
         tmp.307
         |-.48|
         tmp.153
         tmp.339
         tmp.306
         <.49
         tmp.152
         tmp.338
         tmp.305
         <=.50
         tmp.151
         tmp.337
         tmp.304
         >.51
         tmp.150
         tmp.336
         tmp.303
         >=.52
         tmp.149
         tmp.335
         tmp.302
         make-vector.53
         tmp.148
         tmp.334
         tmp.301
         vector-length.54
         tmp.147
         tmp.333
         tmp.300
         vector-set!.55
         tmp.146
         tmp.332
         tmp.299
         vector-ref.56
         tmp.145
         tmp.331
         tmp.298
         car.57
         tmp.144
         tmp.330
         tmp.297
         cdr.58
         tmp.143
         tmp.329
         tmp.296
         procedure-arity.59
         tmp.142
         tmp.328
         tmp.295
         fixnum?.60
         tmp.141
         tmp.327
         tmp.294
         boolean?.61
         tmp.140
         tmp.326
         tmp.293
         empty?.62
         tmp.139
         tmp.325
         tmp.292
         void?.63
         tmp.138
         tmp.324
         tmp.291
         ascii-char?.64
         tmp.137
         tmp.323
         tmp.290
         error?.65
         tmp.136
         tmp.322
         tmp.289
         pair?.66
         tmp.135
         tmp.321
         tmp.288
         procedure?.67
         tmp.134
         tmp.320
         tmp.287
         vector?.68
         tmp.133
         tmp.319
         tmp.286
         not.69
         tmp.132
         tmp.318
         tmp.285
         cons.70
         tmp.131
         tmp.317
         tmp.284
         eq?.71
         tmp.130
         tmp.316
         tmp.283
         make-init-vector.1
         tmp.129
         tmp.315
         tmp.282
         vector-init-loop.74
         tmp.128
         tmp.314
         tmp.281
         unsafe-vector-set!.2
         tmp.127
         tmp.313
         tmp.280
         unsafe-vector-ref.3
         tmp.126
         tmp.312
         tmp.279
         ra.311))
       (undead-out
        ((r12 rbp ra.311)
         (r12 tmp.279 rbp ra.311)
         (tmp.279 r12 rbp ra.311)
         (tmp.312 r12 rbp ra.311)
         (r12 rbp ra.311 tmp.126)
         (ra.311 rbp r12 tmp.126)
         (tmp.126 r12 rbp ra.311)
         (r12 rbp ra.311 unsafe-vector-ref.3)
         (r12 tmp.280 rbp ra.311 unsafe-vector-ref.3)
         (tmp.280 r12 rbp ra.311 unsafe-vector-ref.3)
         (tmp.313 r12 rbp ra.311 unsafe-vector-ref.3)
         (r12 rbp ra.311 unsafe-vector-ref.3 tmp.127)
         (unsafe-vector-ref.3 ra.311 rbp r12 tmp.127)
         (tmp.127 r12 rbp ra.311 unsafe-vector-ref.3)
         (r12 unsafe-vector-set!.2 rbp ra.311 unsafe-vector-ref.3)
         (r12 tmp.281 unsafe-vector-set!.2 rbp ra.311 unsafe-vector-ref.3)
         (tmp.281 r12 unsafe-vector-set!.2 rbp ra.311 unsafe-vector-ref.3)
         (tmp.314 r12 unsafe-vector-set!.2 rbp ra.311 unsafe-vector-ref.3)
         (r12 unsafe-vector-set!.2 rbp ra.311 unsafe-vector-ref.3 tmp.128)
         (unsafe-vector-ref.3 ra.311 rbp unsafe-vector-set!.2 r12 tmp.128)
         (tmp.128 r12 unsafe-vector-set!.2 rbp ra.311 unsafe-vector-ref.3)
         (r12
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.282
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.282
          r12
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.315
          r12
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.129)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
          rbp
          unsafe-vector-set!.2
          r12
          tmp.129)
         (tmp.129
          r12
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.283
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.283
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.316
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.130)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
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
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.284
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.284
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.317
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.131)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
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
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.285
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.285
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.318
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.132)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
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
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.286
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.286
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.319
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.133)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
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
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.287
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.287
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.320
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.134)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
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
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.288
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.288
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.321
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.135)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
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
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.289
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.289
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.322
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.136)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
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
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.290
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.290
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.323
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.137)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
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
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.291
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.291
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.324
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.138)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
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
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.292
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.292
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.325
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.139)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
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
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.293
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.293
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.326
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.140)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
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
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.294
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.294
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.327
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.141)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
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
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.295
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.295
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.328
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.142)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
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
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.296
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.296
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.329
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.143)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
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
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.297
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.297
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.330
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.144)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
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
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          tmp.298
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.298
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (tmp.331
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74
          tmp.145)
         (vector-init-loop.74
          unsafe-vector-ref.3
          ra.311
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
          ra.311
          unsafe-vector-ref.3
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          tmp.299
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.299
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.332
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74
          tmp.146)
         (vector-init-loop.74
          vector-ref.56
          unsafe-vector-ref.3
          ra.311
          rbp
          unsafe-vector-set!.2
          make-init-vector.1
          r12
          tmp.146)
         (tmp.146
          r12
          make-init-vector.1
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          tmp.300
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.300
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.333
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74
          tmp.147)
         (vector-init-loop.74
          vector-ref.56
          unsafe-vector-ref.3
          ra.311
          rbp
          unsafe-vector-set!.2
          vector-set!.55
          make-init-vector.1
          r12
          tmp.147)
         (tmp.147
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          tmp.301
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.301
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.334
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74
          tmp.148)
         (vector-init-loop.74
          vector-ref.56
          unsafe-vector-ref.3
          ra.311
          rbp
          unsafe-vector-set!.2
          vector-set!.55
          make-init-vector.1
          r12
          tmp.148)
         (tmp.148
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          tmp.302
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.302
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.335
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74
          tmp.149)
         (vector-init-loop.74
          vector-ref.56
          unsafe-vector-ref.3
          make-vector.53
          ra.311
          rbp
          unsafe-vector-set!.2
          vector-set!.55
          make-init-vector.1
          r12
          tmp.149)
         (tmp.149
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          tmp.303
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.303
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.336
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74
          tmp.150)
         (vector-init-loop.74
          vector-ref.56
          unsafe-vector-ref.3
          make-vector.53
          ra.311
          rbp
          unsafe-vector-set!.2
          vector-set!.55
          make-init-vector.1
          r12
          tmp.150)
         (tmp.150
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          tmp.304
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.304
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.337
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74
          tmp.151)
         (vector-init-loop.74
          vector-ref.56
          unsafe-vector-ref.3
          make-vector.53
          ra.311
          rbp
          unsafe-vector-set!.2
          vector-set!.55
          make-init-vector.1
          r12
          tmp.151)
         (tmp.151
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          tmp.305
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.305
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.338
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74
          tmp.152)
         (vector-init-loop.74
          vector-ref.56
          unsafe-vector-ref.3
          make-vector.53
          ra.311
          rbp
          unsafe-vector-set!.2
          vector-set!.55
          make-init-vector.1
          r12
          tmp.152)
         (tmp.152
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          tmp.306
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.306
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.339
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74
          tmp.153)
         (vector-init-loop.74
          vector-ref.56
          unsafe-vector-ref.3
          make-vector.53
          ra.311
          rbp
          unsafe-vector-set!.2
          vector-set!.55
          make-init-vector.1
          r12
          tmp.153)
         (tmp.153
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          |-.48|
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          tmp.307
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          |-.48|
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.307
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          |-.48|
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.340
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          |-.48|
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          |-.48|
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74
          tmp.154)
         (vector-init-loop.74
          vector-ref.56
          unsafe-vector-ref.3
          make-vector.53
          ra.311
          rbp
          |-.48|
          unsafe-vector-set!.2
          vector-set!.55
          make-init-vector.1
          r12
          tmp.154)
         (tmp.154
          r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          |-.48|
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          |-.48|
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (r12
          tmp.308
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          |-.48|
          rbp
          ra.311
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.308
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          |-.48|
          rbp
          ra.311
          r12
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (tmp.341
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          |-.48|
          rbp
          ra.311
          r12
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          |-.48|
          rbp
          ra.311
          r12
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74
          tmp.155)
         (vector-init-loop.74
          vector-ref.56
          unsafe-vector-ref.3
          make-vector.53
          r12
          ra.311
          rbp
          |-.48|
          unsafe-vector-set!.2
          vector-set!.55
          make-init-vector.1
          tmp.155)
         (tmp.155
          make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          |-.48|
          rbp
          ra.311
          r12
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (make-init-vector.1
          vector-set!.55
          unsafe-vector-set!.2
          |-.48|
          rbp
          ra.311
          r12
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56
          vector-init-loop.74)
         (vector-ref.56
          unsafe-vector-ref.3
          make-vector.53
          r12
          ra.311
          rbp
          |-.48|
          unsafe-vector-set!.2
          vector-set!.55
          vector-init-loop.74
          make-init-vector.1)
         (vector-set!.55
          unsafe-vector-set!.2
          |-.48|
          rbp
          ra.311
          r12
          make-init-vector.1
          make-vector.53
          unsafe-vector-ref.3
          vector-ref.56)
         (make-vector.53
          make-init-vector.1
          r12
          ra.311
          rbp
          |-.48|
          unsafe-vector-set!.2
          vector-set!.55)
         (|-.48| rbp ra.311 r12 make-init-vector.1 make-vector.53)
         (r12 ra.311 rbp |-.48|)
         (r12 tmp.309 ra.311 rbp |-.48|)
         (tmp.309 r12 ra.311 rbp |-.48|)
         (tmp.342 r12 ra.311 rbp |-.48|)
         (r12 ra.311 rbp |-.48| tmp.156)
         (|-.48| rbp ra.311 r12 tmp.156)
         (tmp.156 r12 ra.311 rbp |-.48|)
         (r12 ra.311 rbp |-.48| i.4)
         (r12 tmp.310 ra.311 rbp |-.48| i.4)
         (tmp.310 ra.311 rbp |-.48| i.4)
         (tmp.343 ra.311 rbp |-.48| i.4)
         (ra.311 rbp |-.48| i.4 tmp.157)
         (i.4 |-.48| rbp ra.311 tmp.157)
         (tmp.157 ra.311 rbp |-.48| i.4)
         (two.5 ra.311 rbp |-.48| i.4)
         (rbp ra.311 i.4 two.5)
         (two.5 i.4 ra.311 rbp)
         (two.5 i.4 ra.311 rbp)
         ((rax i.4 ra.311 rbp) ((rdi rbp) (rdi r15 rbp) (rdi r15 rbp)))
         (x.7 i.4 ra.311 rbp)
         (x.7 i.4 ra.311 rbp)
         (i.4 ra.311 rsi rbp)
         (ra.311 rdi rsi rbp)
         (rdi rsi r15 rbp)
         (rdi rsi r15 rbp)))
       (call-undead (i.4 ra.311))
       (conflicts
        ((ra.311
          (rdi
           rsi
           tmp.123
           x.7
           rax
           tmp.122
           two.5
           tmp.157
           tmp.343
           tmp.310
           i.4
           tmp.156
           tmp.342
           tmp.309
           *.46
           tmp.155
           tmp.341
           tmp.308
           |+.47|
           tmp.154
           tmp.340
           tmp.307
           |-.48|
           tmp.153
           tmp.339
           tmp.306
           <.49
           tmp.152
           tmp.338
           tmp.305
           <=.50
           tmp.151
           tmp.337
           tmp.304
           >.51
           tmp.150
           tmp.336
           tmp.303
           >=.52
           tmp.149
           tmp.335
           tmp.302
           make-vector.53
           tmp.148
           tmp.334
           tmp.301
           vector-length.54
           tmp.147
           tmp.333
           tmp.300
           vector-set!.55
           tmp.146
           tmp.332
           tmp.299
           vector-ref.56
           tmp.145
           tmp.331
           tmp.298
           car.57
           tmp.144
           tmp.330
           tmp.297
           cdr.58
           tmp.143
           tmp.329
           tmp.296
           procedure-arity.59
           tmp.142
           tmp.328
           tmp.295
           fixnum?.60
           tmp.141
           tmp.327
           tmp.294
           boolean?.61
           tmp.140
           tmp.326
           tmp.293
           empty?.62
           tmp.139
           tmp.325
           tmp.292
           void?.63
           tmp.138
           tmp.324
           tmp.291
           ascii-char?.64
           tmp.137
           tmp.323
           tmp.290
           error?.65
           tmp.136
           tmp.322
           tmp.289
           pair?.66
           tmp.135
           tmp.321
           tmp.288
           procedure?.67
           tmp.134
           tmp.320
           tmp.287
           vector?.68
           tmp.133
           tmp.319
           tmp.286
           not.69
           tmp.132
           tmp.318
           tmp.285
           cons.70
           tmp.131
           tmp.317
           tmp.284
           eq?.71
           tmp.130
           tmp.316
           tmp.283
           make-init-vector.1
           tmp.129
           tmp.315
           tmp.282
           vector-init-loop.74
           tmp.128
           tmp.314
           tmp.281
           unsafe-vector-set!.2
           tmp.127
           tmp.313
           tmp.280
           unsafe-vector-ref.3
           tmp.126
           tmp.312
           tmp.279
           r12
           rbp))
         (rbp
          (rsi
           tmp.123
           x.7
           r15
           rdi
           rax
           tmp.122
           two.5
           tmp.157
           tmp.343
           tmp.310
           i.4
           tmp.156
           tmp.342
           tmp.309
           *.46
           tmp.155
           tmp.341
           tmp.308
           |+.47|
           tmp.154
           tmp.340
           tmp.307
           |-.48|
           tmp.153
           tmp.339
           tmp.306
           <.49
           tmp.152
           tmp.338
           tmp.305
           <=.50
           tmp.151
           tmp.337
           tmp.304
           >.51
           tmp.150
           tmp.336
           tmp.303
           >=.52
           tmp.149
           tmp.335
           tmp.302
           make-vector.53
           tmp.148
           tmp.334
           tmp.301
           vector-length.54
           tmp.147
           tmp.333
           tmp.300
           vector-set!.55
           tmp.146
           tmp.332
           tmp.299
           vector-ref.56
           tmp.145
           tmp.331
           tmp.298
           car.57
           tmp.144
           tmp.330
           tmp.297
           cdr.58
           tmp.143
           tmp.329
           tmp.296
           procedure-arity.59
           tmp.142
           tmp.328
           tmp.295
           fixnum?.60
           tmp.141
           tmp.327
           tmp.294
           boolean?.61
           tmp.140
           tmp.326
           tmp.293
           empty?.62
           tmp.139
           tmp.325
           tmp.292
           void?.63
           tmp.138
           tmp.324
           tmp.291
           ascii-char?.64
           tmp.137
           tmp.323
           tmp.290
           error?.65
           tmp.136
           tmp.322
           tmp.289
           pair?.66
           tmp.135
           tmp.321
           tmp.288
           procedure?.67
           tmp.134
           tmp.320
           tmp.287
           vector?.68
           tmp.133
           tmp.319
           tmp.286
           not.69
           tmp.132
           tmp.318
           tmp.285
           cons.70
           tmp.131
           tmp.317
           tmp.284
           eq?.71
           tmp.130
           tmp.316
           tmp.283
           make-init-vector.1
           tmp.129
           tmp.315
           tmp.282
           vector-init-loop.74
           tmp.128
           tmp.314
           tmp.281
           unsafe-vector-set!.2
           tmp.127
           tmp.313
           tmp.280
           unsafe-vector-ref.3
           tmp.126
           tmp.312
           r12
           tmp.279
           ra.311))
         (r12
          (tmp.310
           i.4
           tmp.156
           tmp.342
           tmp.309
           *.46
           tmp.155
           tmp.341
           tmp.308
           |+.47|
           tmp.154
           tmp.340
           tmp.307
           |-.48|
           tmp.153
           tmp.339
           tmp.306
           <.49
           tmp.152
           tmp.338
           tmp.305
           <=.50
           tmp.151
           tmp.337
           tmp.304
           >.51
           tmp.150
           tmp.336
           tmp.303
           >=.52
           tmp.149
           tmp.335
           tmp.302
           make-vector.53
           tmp.148
           tmp.334
           tmp.301
           vector-length.54
           tmp.147
           tmp.333
           tmp.300
           vector-set!.55
           tmp.146
           tmp.332
           tmp.299
           vector-ref.56
           tmp.145
           tmp.331
           tmp.298
           car.57
           tmp.144
           tmp.330
           tmp.297
           cdr.58
           tmp.143
           tmp.329
           tmp.296
           procedure-arity.59
           tmp.142
           tmp.328
           tmp.295
           fixnum?.60
           tmp.141
           tmp.327
           tmp.294
           boolean?.61
           tmp.140
           tmp.326
           tmp.293
           empty?.62
           tmp.139
           tmp.325
           tmp.292
           void?.63
           tmp.138
           tmp.324
           tmp.291
           ascii-char?.64
           tmp.137
           tmp.323
           tmp.290
           error?.65
           tmp.136
           tmp.322
           tmp.289
           pair?.66
           tmp.135
           tmp.321
           tmp.288
           procedure?.67
           tmp.134
           tmp.320
           tmp.287
           vector?.68
           tmp.133
           tmp.319
           tmp.286
           not.69
           tmp.132
           tmp.318
           tmp.285
           cons.70
           tmp.131
           tmp.317
           tmp.284
           eq?.71
           tmp.130
           tmp.316
           tmp.283
           make-init-vector.1
           tmp.129
           tmp.315
           tmp.282
           vector-init-loop.74
           tmp.128
           tmp.314
           tmp.281
           unsafe-vector-set!.2
           tmp.127
           tmp.313
           tmp.280
           unsafe-vector-ref.3
           tmp.126
           tmp.312
           rbp
           tmp.279
           ra.311))
         (tmp.279 (r12 rbp ra.311))
         (tmp.312 (ra.311 rbp r12))
         (tmp.126 (r12 rbp ra.311))
         (unsafe-vector-ref.3
          (*.46
           tmp.155
           tmp.341
           tmp.308
           |+.47|
           tmp.154
           tmp.340
           tmp.307
           |-.48|
           tmp.153
           tmp.339
           tmp.306
           <.49
           tmp.152
           tmp.338
           tmp.305
           <=.50
           tmp.151
           tmp.337
           tmp.304
           >.51
           tmp.150
           tmp.336
           tmp.303
           >=.52
           tmp.149
           tmp.335
           tmp.302
           make-vector.53
           tmp.148
           tmp.334
           tmp.301
           vector-length.54
           tmp.147
           tmp.333
           tmp.300
           vector-set!.55
           tmp.146
           tmp.332
           tmp.299
           vector-ref.56
           tmp.145
           tmp.331
           tmp.298
           car.57
           tmp.144
           tmp.330
           tmp.297
           cdr.58
           tmp.143
           tmp.329
           tmp.296
           procedure-arity.59
           tmp.142
           tmp.328
           tmp.295
           fixnum?.60
           tmp.141
           tmp.327
           tmp.294
           boolean?.61
           tmp.140
           tmp.326
           tmp.293
           empty?.62
           tmp.139
           tmp.325
           tmp.292
           void?.63
           tmp.138
           tmp.324
           tmp.291
           ascii-char?.64
           tmp.137
           tmp.323
           tmp.290
           error?.65
           tmp.136
           tmp.322
           tmp.289
           pair?.66
           tmp.135
           tmp.321
           tmp.288
           procedure?.67
           tmp.134
           tmp.320
           tmp.287
           vector?.68
           tmp.133
           tmp.319
           tmp.286
           not.69
           tmp.132
           tmp.318
           tmp.285
           cons.70
           tmp.131
           tmp.317
           tmp.284
           eq?.71
           tmp.130
           tmp.316
           tmp.283
           make-init-vector.1
           tmp.129
           tmp.315
           tmp.282
           vector-init-loop.74
           tmp.128
           tmp.314
           tmp.281
           unsafe-vector-set!.2
           tmp.127
           tmp.313
           tmp.280
           r12
           rbp
           ra.311))
         (tmp.280 (r12 rbp ra.311 unsafe-vector-ref.3))
         (tmp.313 (unsafe-vector-ref.3 ra.311 rbp r12))
         (tmp.127 (r12 rbp ra.311 unsafe-vector-ref.3))
         (unsafe-vector-set!.2
          (*.46
           tmp.155
           tmp.341
           tmp.308
           |+.47|
           tmp.154
           tmp.340
           tmp.307
           |-.48|
           tmp.153
           tmp.339
           tmp.306
           <.49
           tmp.152
           tmp.338
           tmp.305
           <=.50
           tmp.151
           tmp.337
           tmp.304
           >.51
           tmp.150
           tmp.336
           tmp.303
           >=.52
           tmp.149
           tmp.335
           tmp.302
           make-vector.53
           tmp.148
           tmp.334
           tmp.301
           vector-length.54
           tmp.147
           tmp.333
           tmp.300
           vector-set!.55
           tmp.146
           tmp.332
           tmp.299
           vector-ref.56
           tmp.145
           tmp.331
           tmp.298
           car.57
           tmp.144
           tmp.330
           tmp.297
           cdr.58
           tmp.143
           tmp.329
           tmp.296
           procedure-arity.59
           tmp.142
           tmp.328
           tmp.295
           fixnum?.60
           tmp.141
           tmp.327
           tmp.294
           boolean?.61
           tmp.140
           tmp.326
           tmp.293
           empty?.62
           tmp.139
           tmp.325
           tmp.292
           void?.63
           tmp.138
           tmp.324
           tmp.291
           ascii-char?.64
           tmp.137
           tmp.323
           tmp.290
           error?.65
           tmp.136
           tmp.322
           tmp.289
           pair?.66
           tmp.135
           tmp.321
           tmp.288
           procedure?.67
           tmp.134
           tmp.320
           tmp.287
           vector?.68
           tmp.133
           tmp.319
           tmp.286
           not.69
           tmp.132
           tmp.318
           tmp.285
           cons.70
           tmp.131
           tmp.317
           tmp.284
           eq?.71
           tmp.130
           tmp.316
           tmp.283
           make-init-vector.1
           tmp.129
           tmp.315
           tmp.282
           vector-init-loop.74
           tmp.128
           tmp.314
           tmp.281
           r12
           rbp
           ra.311
           unsafe-vector-ref.3))
         (tmp.281 (r12 unsafe-vector-set!.2 rbp ra.311 unsafe-vector-ref.3))
         (tmp.314 (unsafe-vector-ref.3 ra.311 rbp unsafe-vector-set!.2 r12))
         (tmp.128 (r12 unsafe-vector-set!.2 rbp ra.311 unsafe-vector-ref.3))
         (vector-init-loop.74
          (*.46
           tmp.155
           tmp.341
           tmp.308
           |+.47|
           tmp.154
           tmp.340
           tmp.307
           |-.48|
           tmp.153
           tmp.339
           tmp.306
           <.49
           tmp.152
           tmp.338
           tmp.305
           <=.50
           tmp.151
           tmp.337
           tmp.304
           >.51
           tmp.150
           tmp.336
           tmp.303
           >=.52
           tmp.149
           tmp.335
           tmp.302
           make-vector.53
           tmp.148
           tmp.334
           tmp.301
           vector-length.54
           tmp.147
           tmp.333
           tmp.300
           vector-set!.55
           tmp.146
           tmp.332
           tmp.299
           vector-ref.56
           tmp.145
           tmp.331
           tmp.298
           car.57
           tmp.144
           tmp.330
           tmp.297
           cdr.58
           tmp.143
           tmp.329
           tmp.296
           procedure-arity.59
           tmp.142
           tmp.328
           tmp.295
           fixnum?.60
           tmp.141
           tmp.327
           tmp.294
           boolean?.61
           tmp.140
           tmp.326
           tmp.293
           empty?.62
           tmp.139
           tmp.325
           tmp.292
           void?.63
           tmp.138
           tmp.324
           tmp.291
           ascii-char?.64
           tmp.137
           tmp.323
           tmp.290
           error?.65
           tmp.136
           tmp.322
           tmp.289
           pair?.66
           tmp.135
           tmp.321
           tmp.288
           procedure?.67
           tmp.134
           tmp.320
           tmp.287
           vector?.68
           tmp.133
           tmp.319
           tmp.286
           not.69
           tmp.132
           tmp.318
           tmp.285
           cons.70
           tmp.131
           tmp.317
           tmp.284
           eq?.71
           tmp.130
           tmp.316
           tmp.283
           make-init-vector.1
           tmp.129
           tmp.315
           tmp.282
           r12
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3))
         (tmp.282
          (r12
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.315
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           r12))
         (tmp.129
          (r12
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (make-init-vector.1
          (*.46
           tmp.155
           tmp.341
           tmp.308
           |+.47|
           tmp.154
           tmp.340
           tmp.307
           |-.48|
           tmp.153
           tmp.339
           tmp.306
           <.49
           tmp.152
           tmp.338
           tmp.305
           <=.50
           tmp.151
           tmp.337
           tmp.304
           >.51
           tmp.150
           tmp.336
           tmp.303
           >=.52
           tmp.149
           tmp.335
           tmp.302
           make-vector.53
           tmp.148
           tmp.334
           tmp.301
           vector-length.54
           tmp.147
           tmp.333
           tmp.300
           vector-set!.55
           tmp.146
           tmp.332
           tmp.299
           vector-ref.56
           tmp.145
           tmp.331
           tmp.298
           car.57
           tmp.144
           tmp.330
           tmp.297
           cdr.58
           tmp.143
           tmp.329
           tmp.296
           procedure-arity.59
           tmp.142
           tmp.328
           tmp.295
           fixnum?.60
           tmp.141
           tmp.327
           tmp.294
           boolean?.61
           tmp.140
           tmp.326
           tmp.293
           empty?.62
           tmp.139
           tmp.325
           tmp.292
           void?.63
           tmp.138
           tmp.324
           tmp.291
           ascii-char?.64
           tmp.137
           tmp.323
           tmp.290
           error?.65
           tmp.136
           tmp.322
           tmp.289
           pair?.66
           tmp.135
           tmp.321
           tmp.288
           procedure?.67
           tmp.134
           tmp.320
           tmp.287
           vector?.68
           tmp.133
           tmp.319
           tmp.286
           not.69
           tmp.132
           tmp.318
           tmp.285
           cons.70
           tmp.131
           tmp.317
           tmp.284
           eq?.71
           tmp.130
           tmp.316
           tmp.283
           r12
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.283
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.316
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.130
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (eq?.71
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.284
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.317
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.131
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (cons.70
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.285
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.318
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.132
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (not.69
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.286
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.319
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.133
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (vector?.68
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.287
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.320
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.134
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (procedure?.67
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.288
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.321
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.135
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (pair?.66
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.289
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.322
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.136
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (error?.65
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.290
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.323
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.137
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (ascii-char?.64
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.291
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.324
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.138
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (void?.63
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.292
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.325
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.139
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (empty?.62
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.293
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.326
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.140
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (boolean?.61
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.294
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.327
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.141
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (fixnum?.60
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.295
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.328
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.142
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (procedure-arity.59
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.296
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.329
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.143
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (cdr.58
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.297
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.330
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.144
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (car.57
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.298
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.331
          (vector-init-loop.74
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.145
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (vector-ref.56
          (*.46
           tmp.155
           tmp.341
           tmp.308
           |+.47|
           tmp.154
           tmp.340
           tmp.307
           |-.48|
           tmp.153
           tmp.339
           tmp.306
           <.49
           tmp.152
           tmp.338
           tmp.305
           <=.50
           tmp.151
           tmp.337
           tmp.304
           >.51
           tmp.150
           tmp.336
           tmp.303
           >=.52
           tmp.149
           tmp.335
           tmp.302
           make-vector.53
           tmp.148
           tmp.334
           tmp.301
           vector-length.54
           tmp.147
           tmp.333
           tmp.300
           vector-set!.55
           tmp.146
           tmp.332
           tmp.299
           r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-init-loop.74))
         (tmp.299
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.332
          (vector-init-loop.74
           vector-ref.56
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           make-init-vector.1
           r12))
         (tmp.146
          (r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (vector-set!.55
          (*.46
           tmp.155
           tmp.341
           tmp.308
           |+.47|
           tmp.154
           tmp.340
           tmp.307
           |-.48|
           tmp.153
           tmp.339
           tmp.306
           <.49
           tmp.152
           tmp.338
           tmp.305
           <=.50
           tmp.151
           tmp.337
           tmp.304
           >.51
           tmp.150
           tmp.336
           tmp.303
           >=.52
           tmp.149
           tmp.335
           tmp.302
           make-vector.53
           tmp.148
           tmp.334
           tmp.301
           vector-length.54
           tmp.147
           tmp.333
           tmp.300
           r12
           make-init-vector.1
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.300
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.333
          (vector-init-loop.74
           vector-ref.56
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           vector-set!.55
           make-init-vector.1
           r12))
         (tmp.147
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (vector-length.54
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.301
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.334
          (vector-init-loop.74
           vector-ref.56
           unsafe-vector-ref.3
           ra.311
           rbp
           unsafe-vector-set!.2
           vector-set!.55
           make-init-vector.1
           r12))
         (tmp.148
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (make-vector.53
          (*.46
           tmp.155
           tmp.341
           tmp.308
           |+.47|
           tmp.154
           tmp.340
           tmp.307
           |-.48|
           tmp.153
           tmp.339
           tmp.306
           <.49
           tmp.152
           tmp.338
           tmp.305
           <=.50
           tmp.151
           tmp.337
           tmp.304
           >.51
           tmp.150
           tmp.336
           tmp.303
           >=.52
           tmp.149
           tmp.335
           tmp.302
           r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.302
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.335
          (vector-init-loop.74
           vector-ref.56
           unsafe-vector-ref.3
           make-vector.53
           ra.311
           rbp
           unsafe-vector-set!.2
           vector-set!.55
           make-init-vector.1
           r12))
         (tmp.149
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (>=.52
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.303
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.336
          (vector-init-loop.74
           vector-ref.56
           unsafe-vector-ref.3
           make-vector.53
           ra.311
           rbp
           unsafe-vector-set!.2
           vector-set!.55
           make-init-vector.1
           r12))
         (tmp.150
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (>.51
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.304
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.337
          (vector-init-loop.74
           vector-ref.56
           unsafe-vector-ref.3
           make-vector.53
           ra.311
           rbp
           unsafe-vector-set!.2
           vector-set!.55
           make-init-vector.1
           r12))
         (tmp.151
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (<=.50
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.305
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.338
          (vector-init-loop.74
           vector-ref.56
           unsafe-vector-ref.3
           make-vector.53
           ra.311
           rbp
           unsafe-vector-set!.2
           vector-set!.55
           make-init-vector.1
           r12))
         (tmp.152
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (<.49
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.306
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.339
          (vector-init-loop.74
           vector-ref.56
           unsafe-vector-ref.3
           make-vector.53
           ra.311
           rbp
           unsafe-vector-set!.2
           vector-set!.55
           make-init-vector.1
           r12))
         (tmp.153
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (|-.48|
          (two.5
           tmp.157
           tmp.343
           tmp.310
           i.4
           tmp.156
           tmp.342
           tmp.309
           *.46
           tmp.155
           tmp.341
           tmp.308
           |+.47|
           tmp.154
           tmp.340
           tmp.307
           r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.307
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           |-.48|
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.340
          (vector-init-loop.74
           vector-ref.56
           unsafe-vector-ref.3
           make-vector.53
           ra.311
           rbp
           |-.48|
           unsafe-vector-set!.2
           vector-set!.55
           make-init-vector.1
           r12))
         (tmp.154
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           |-.48|
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (|+.47|
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           |-.48|
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.308
          (r12
           make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           |-.48|
           rbp
           ra.311
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.341
          (vector-init-loop.74
           vector-ref.56
           unsafe-vector-ref.3
           make-vector.53
           r12
           ra.311
           rbp
           |-.48|
           unsafe-vector-set!.2
           vector-set!.55
           make-init-vector.1))
         (tmp.155
          (make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           |-.48|
           rbp
           ra.311
           r12
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (*.46
          (make-init-vector.1
           vector-set!.55
           unsafe-vector-set!.2
           |-.48|
           rbp
           ra.311
           r12
           make-vector.53
           unsafe-vector-ref.3
           vector-ref.56
           vector-init-loop.74))
         (tmp.309 (r12 ra.311 rbp |-.48|))
         (tmp.342 (|-.48| rbp ra.311 r12))
         (tmp.156 (r12 ra.311 rbp |-.48|))
         (i.4
          (rsi
           x.7
           rax
           tmp.122
           two.5
           tmp.157
           tmp.343
           tmp.310
           r12
           ra.311
           rbp
           |-.48|))
         (tmp.310 (r12 ra.311 rbp |-.48| i.4))
         (tmp.343 (i.4 |-.48| rbp ra.311))
         (tmp.157 (ra.311 rbp |-.48| i.4))
         (two.5 (ra.311 rbp |-.48| i.4))
         (tmp.122 (i.4 ra.311 rbp))
         (rax (rbp ra.311 i.4))
         (rdi (ra.311 rsi r15 rbp))
         (r15 (rsi rdi rbp))
         (x.7 (tmp.123 i.4 ra.311 rbp))
         (tmp.123 (x.7 ra.311 rbp))
         (rsi (r15 rdi i.4 ra.311 rbp)))))
      (begin
        (set! ra.311 r15)
        (set! tmp.279 r12)
        (set! r12 (+ r12 16))
        (set! tmp.312 (+ tmp.279 2))
        (set! tmp.126 tmp.312)
        (mset! tmp.126 -2 L.unsafe-vector-ref.3.1)
        (mset! tmp.126 6 16)
        (set! unsafe-vector-ref.3 tmp.126)
        (set! tmp.280 r12)
        (set! r12 (+ r12 16))
        (set! tmp.313 (+ tmp.280 2))
        (set! tmp.127 tmp.313)
        (mset! tmp.127 -2 L.unsafe-vector-set!.2.2)
        (mset! tmp.127 6 24)
        (set! unsafe-vector-set!.2 tmp.127)
        (set! tmp.281 r12)
        (set! r12 (+ r12 80))
        (set! tmp.314 (+ tmp.281 2))
        (set! tmp.128 tmp.314)
        (mset! tmp.128 -2 L.vector-init-loop.74.3)
        (mset! tmp.128 6 24)
        (set! vector-init-loop.74 tmp.128)
        (set! tmp.282 r12)
        (set! r12 (+ r12 80))
        (set! tmp.315 (+ tmp.282 2))
        (set! tmp.129 tmp.315)
        (mset! tmp.129 -2 L.make-init-vector.1.4)
        (mset! tmp.129 6 8)
        (set! make-init-vector.1 tmp.129)
        (set! tmp.283 r12)
        (set! r12 (+ r12 16))
        (set! tmp.316 (+ tmp.283 2))
        (set! tmp.130 tmp.316)
        (mset! tmp.130 -2 L.eq?.71.5)
        (mset! tmp.130 6 16)
        (set! eq?.71 tmp.130)
        (set! tmp.284 r12)
        (set! r12 (+ r12 16))
        (set! tmp.317 (+ tmp.284 2))
        (set! tmp.131 tmp.317)
        (mset! tmp.131 -2 L.cons.70.6)
        (mset! tmp.131 6 16)
        (set! cons.70 tmp.131)
        (set! tmp.285 r12)
        (set! r12 (+ r12 16))
        (set! tmp.318 (+ tmp.285 2))
        (set! tmp.132 tmp.318)
        (mset! tmp.132 -2 L.not.69.7)
        (mset! tmp.132 6 8)
        (set! not.69 tmp.132)
        (set! tmp.286 r12)
        (set! r12 (+ r12 16))
        (set! tmp.319 (+ tmp.286 2))
        (set! tmp.133 tmp.319)
        (mset! tmp.133 -2 L.vector?.68.8)
        (mset! tmp.133 6 8)
        (set! vector?.68 tmp.133)
        (set! tmp.287 r12)
        (set! r12 (+ r12 16))
        (set! tmp.320 (+ tmp.287 2))
        (set! tmp.134 tmp.320)
        (mset! tmp.134 -2 L.procedure?.67.9)
        (mset! tmp.134 6 8)
        (set! procedure?.67 tmp.134)
        (set! tmp.288 r12)
        (set! r12 (+ r12 16))
        (set! tmp.321 (+ tmp.288 2))
        (set! tmp.135 tmp.321)
        (mset! tmp.135 -2 L.pair?.66.10)
        (mset! tmp.135 6 8)
        (set! pair?.66 tmp.135)
        (set! tmp.289 r12)
        (set! r12 (+ r12 16))
        (set! tmp.322 (+ tmp.289 2))
        (set! tmp.136 tmp.322)
        (mset! tmp.136 -2 L.error?.65.11)
        (mset! tmp.136 6 8)
        (set! error?.65 tmp.136)
        (set! tmp.290 r12)
        (set! r12 (+ r12 16))
        (set! tmp.323 (+ tmp.290 2))
        (set! tmp.137 tmp.323)
        (mset! tmp.137 -2 L.ascii-char?.64.12)
        (mset! tmp.137 6 8)
        (set! ascii-char?.64 tmp.137)
        (set! tmp.291 r12)
        (set! r12 (+ r12 16))
        (set! tmp.324 (+ tmp.291 2))
        (set! tmp.138 tmp.324)
        (mset! tmp.138 -2 L.void?.63.13)
        (mset! tmp.138 6 8)
        (set! void?.63 tmp.138)
        (set! tmp.292 r12)
        (set! r12 (+ r12 16))
        (set! tmp.325 (+ tmp.292 2))
        (set! tmp.139 tmp.325)
        (mset! tmp.139 -2 L.empty?.62.14)
        (mset! tmp.139 6 8)
        (set! empty?.62 tmp.139)
        (set! tmp.293 r12)
        (set! r12 (+ r12 16))
        (set! tmp.326 (+ tmp.293 2))
        (set! tmp.140 tmp.326)
        (mset! tmp.140 -2 L.boolean?.61.15)
        (mset! tmp.140 6 8)
        (set! boolean?.61 tmp.140)
        (set! tmp.294 r12)
        (set! r12 (+ r12 16))
        (set! tmp.327 (+ tmp.294 2))
        (set! tmp.141 tmp.327)
        (mset! tmp.141 -2 L.fixnum?.60.16)
        (mset! tmp.141 6 8)
        (set! fixnum?.60 tmp.141)
        (set! tmp.295 r12)
        (set! r12 (+ r12 16))
        (set! tmp.328 (+ tmp.295 2))
        (set! tmp.142 tmp.328)
        (mset! tmp.142 -2 L.procedure-arity.59.17)
        (mset! tmp.142 6 8)
        (set! procedure-arity.59 tmp.142)
        (set! tmp.296 r12)
        (set! r12 (+ r12 16))
        (set! tmp.329 (+ tmp.296 2))
        (set! tmp.143 tmp.329)
        (mset! tmp.143 -2 L.cdr.58.18)
        (mset! tmp.143 6 8)
        (set! cdr.58 tmp.143)
        (set! tmp.297 r12)
        (set! r12 (+ r12 16))
        (set! tmp.330 (+ tmp.297 2))
        (set! tmp.144 tmp.330)
        (mset! tmp.144 -2 L.car.57.19)
        (mset! tmp.144 6 8)
        (set! car.57 tmp.144)
        (set! tmp.298 r12)
        (set! r12 (+ r12 80))
        (set! tmp.331 (+ tmp.298 2))
        (set! tmp.145 tmp.331)
        (mset! tmp.145 -2 L.vector-ref.56.20)
        (mset! tmp.145 6 16)
        (set! vector-ref.56 tmp.145)
        (set! tmp.299 r12)
        (set! r12 (+ r12 80))
        (set! tmp.332 (+ tmp.299 2))
        (set! tmp.146 tmp.332)
        (mset! tmp.146 -2 L.vector-set!.55.21)
        (mset! tmp.146 6 24)
        (set! vector-set!.55 tmp.146)
        (set! tmp.300 r12)
        (set! r12 (+ r12 16))
        (set! tmp.333 (+ tmp.300 2))
        (set! tmp.147 tmp.333)
        (mset! tmp.147 -2 L.vector-length.54.22)
        (mset! tmp.147 6 8)
        (set! vector-length.54 tmp.147)
        (set! tmp.301 r12)
        (set! r12 (+ r12 80))
        (set! tmp.334 (+ tmp.301 2))
        (set! tmp.148 tmp.334)
        (mset! tmp.148 -2 L.make-vector.53.23)
        (mset! tmp.148 6 8)
        (set! make-vector.53 tmp.148)
        (set! tmp.302 r12)
        (set! r12 (+ r12 16))
        (set! tmp.335 (+ tmp.302 2))
        (set! tmp.149 tmp.335)
        (mset! tmp.149 -2 L.>=.52.24)
        (mset! tmp.149 6 16)
        (set! >=.52 tmp.149)
        (set! tmp.303 r12)
        (set! r12 (+ r12 16))
        (set! tmp.336 (+ tmp.303 2))
        (set! tmp.150 tmp.336)
        (mset! tmp.150 -2 L.>.51.25)
        (mset! tmp.150 6 16)
        (set! >.51 tmp.150)
        (set! tmp.304 r12)
        (set! r12 (+ r12 16))
        (set! tmp.337 (+ tmp.304 2))
        (set! tmp.151 tmp.337)
        (mset! tmp.151 -2 L.<=.50.26)
        (mset! tmp.151 6 16)
        (set! <=.50 tmp.151)
        (set! tmp.305 r12)
        (set! r12 (+ r12 16))
        (set! tmp.338 (+ tmp.305 2))
        (set! tmp.152 tmp.338)
        (mset! tmp.152 -2 L.<.49.27)
        (mset! tmp.152 6 16)
        (set! <.49 tmp.152)
        (set! tmp.306 r12)
        (set! r12 (+ r12 16))
        (set! tmp.339 (+ tmp.306 2))
        (set! tmp.153 tmp.339)
        (mset! tmp.153 -2 L.-.48.28)
        (mset! tmp.153 6 16)
        (set! |-.48| tmp.153)
        (set! tmp.307 r12)
        (set! r12 (+ r12 16))
        (set! tmp.340 (+ tmp.307 2))
        (set! tmp.154 tmp.340)
        (mset! tmp.154 -2 L.+.47.29)
        (mset! tmp.154 6 16)
        (set! |+.47| tmp.154)
        (set! tmp.308 r12)
        (set! r12 (+ r12 16))
        (set! tmp.341 (+ tmp.308 2))
        (set! tmp.155 tmp.341)
        (mset! tmp.155 -2 L.*.46.30)
        (mset! tmp.155 6 16)
        (set! *.46 tmp.155)
        (mset! vector-init-loop.74 14 vector-init-loop.74)
        (mset! make-init-vector.1 14 vector-init-loop.74)
        (mset! vector-ref.56 14 unsafe-vector-ref.3)
        (mset! vector-set!.55 14 unsafe-vector-set!.2)
        (mset! make-vector.53 14 make-init-vector.1)
        (set! tmp.309 r12)
        (set! r12 (+ r12 80))
        (set! tmp.342 (+ tmp.309 2))
        (set! tmp.156 tmp.342)
        (mset! tmp.156 -2 L.i.4.31)
        (mset! tmp.156 6 8)
        (set! i.4 tmp.156)
        (set! tmp.310 r12)
        (set! r12 (+ r12 80))
        (set! tmp.343 (+ tmp.310 2))
        (set! tmp.157 tmp.343)
        (mset! tmp.157 -2 L.two.5.32)
        (mset! tmp.157 6 0)
        (set! two.5 tmp.157)
        (mset! i.4 14 |-.48|)
        (mset! two.5 14 i.4)
        (set! tmp.122 two.5)
        (return-point L.rp.105
          (begin
            (set! rdi two.5)
            (set! r15 L.rp.105)
            (jump L.two.5.32 rbp r15 rdi)))
        (set! x.7 rax)
        (set! tmp.123 i.4)
        (set! rsi x.7)
        (set! rdi i.4)
        (set! r15 ra.311)
        (jump L.i.4.31 rbp r15 rsi rdi)))
    (define L.two.5.32
      ((new-frames ())
       (locals (tmp.121 i.4 c.114 ra.344))
       (undead-out
        ((rdi ra.344 rbp)
         (c.114 ra.344 rbp)
         (i.4 ra.344 rbp)
         (i.4 ra.344 rbp)
         (i.4 ra.344 rsi rbp)
         (ra.344 rdi rsi rbp)
         (rdi rsi r15 rbp)
         (rdi rsi r15 rbp)))
       (call-undead ())
       (conflicts
        ((ra.344 (rsi tmp.121 i.4 c.114 rdi rbp))
         (rbp (r15 rdi rsi tmp.121 i.4 c.114 ra.344))
         (rdi (r15 rsi rbp ra.344))
         (c.114 (ra.344 rbp))
         (i.4 (rsi rbp ra.344))
         (tmp.121 (ra.344 rbp))
         (rsi (r15 rdi i.4 ra.344 rbp))
         (r15 (rdi rsi rbp)))))
      (begin
        (set! ra.344 r15)
        (set! c.114 rdi)
        (set! i.4 (mref c.114 14))
        (set! tmp.121 i.4)
        (set! rsi 16)
        (set! rdi i.4)
        (set! r15 ra.344)
        (jump L.i.4.31 rbp r15 rsi rdi)))
    (define L.i.4.31
      ((new-frames ())
       (locals (tmp.120 |-.48| x.6 c.113 ra.345))
       (undead-out
        ((rdi rsi ra.345 rbp)
         (rsi c.113 ra.345 rbp)
         (c.113 x.6 ra.345 rbp)
         (x.6 |-.48| ra.345 rbp)
         (x.6 |-.48| ra.345 rbp)
         (x.6 |-.48| ra.345 rdx rbp)
         (|-.48| ra.345 rsi rdx rbp)
         (ra.345 rdi rsi rdx rbp)
         (rdi rsi rdx r15 rbp)
         (rdi rsi rdx r15 rbp)))
       (call-undead ())
       (conflicts
        ((ra.345 (rdx tmp.120 |-.48| x.6 c.113 rdi rsi rbp))
         (rbp (r15 rdi rsi rdx tmp.120 |-.48| x.6 c.113 ra.345))
         (rsi (r15 rdi |-.48| rdx rbp c.113 ra.345))
         (rdi (r15 rsi rdx rbp ra.345))
         (c.113 (x.6 rsi ra.345 rbp))
         (x.6 (rdx tmp.120 |-.48| c.113 ra.345 rbp))
         (|-.48| (rsi rdx rbp ra.345 x.6))
         (tmp.120 (x.6 ra.345 rbp))
         (rdx (r15 rdi rsi x.6 |-.48| ra.345 rbp))
         (r15 (rdi rsi rdx rbp)))))
      (begin
        (set! ra.345 r15)
        (set! c.113 rdi)
        (set! x.6 rsi)
        (set! |-.48| (mref c.113 14))
        (set! tmp.120 |-.48|)
        (set! rdx 0)
        (set! rsi x.6)
        (set! rdi |-.48|)
        (set! r15 ra.345)
        (jump L.-.48.28 rbp r15 rdx rsi rdi)))
    (define L.*.46.30
      ((new-frames ())
       (locals (tmp.347 c.112 tmp.164 ra.346 tmp.8 tmp.9))
       (undead-out
        ((rdi rsi rdx ra.346 rbp)
         (rsi rdx ra.346 rbp)
         (rdx tmp.8 ra.346 rbp)
         (tmp.9 tmp.8 ra.346 rbp)
         (tmp.347 tmp.9 tmp.8 ra.346 rbp)
         (tmp.164 tmp.9 tmp.8 ra.346 rbp)
         ((tmp.9 tmp.8 ra.346 rbp)
          ((tmp.8 ra.346 rdx rbp)
           (ra.346 rsi rdx rbp)
           (ra.346 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.8 ra.346 rdx rbp)
           (ra.346 rsi rdx rbp)
           (ra.346 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.112 r15 rdi rsi tmp.8 ra.346 rbp))
         (rbp (tmp.164 tmp.347 tmp.9 tmp.8 c.112 ra.346 r15 rdi rsi rdx))
         (ra.346 (tmp.164 tmp.347 tmp.9 tmp.8 c.112 rbp rdi rsi rdx))
         (tmp.8 (tmp.164 tmp.347 tmp.9 ra.346 rbp rdx))
         (rsi (c.112 r15 rdi ra.346 rdx rbp))
         (rdi (r15 ra.346 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.112 (rsi rdx ra.346 rbp))
         (tmp.9 (tmp.164 tmp.347 tmp.8 ra.346 rbp))
         (tmp.347 (rbp ra.346 tmp.8 tmp.9))
         (tmp.164 (tmp.9 tmp.8 ra.346 rbp)))))
      (begin
        (set! ra.346 r15)
        (set! c.112 rdi)
        (set! tmp.8 rsi)
        (set! tmp.9 rdx)
        (set! tmp.347 (bitwise-and tmp.9 7))
        (set! tmp.164 tmp.347)
        (if (eq? tmp.164 0)
          (begin
            (set! rdx tmp.9)
            (set! rsi tmp.8)
            (set! rdi 14)
            (set! r15 ra.346)
            (jump L.jp.36 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.9)
            (set! rsi tmp.8)
            (set! rdi 6)
            (set! r15 ra.346)
            (jump L.jp.36 rbp r15 rdx rsi rdi)))))
    (define L.+.47.29
      ((new-frames ())
       (locals (tmp.349 c.111 tmp.170 ra.348 tmp.10 tmp.11))
       (undead-out
        ((rdi rsi rdx ra.348 rbp)
         (rsi rdx ra.348 rbp)
         (rdx tmp.10 ra.348 rbp)
         (tmp.11 tmp.10 ra.348 rbp)
         (tmp.349 tmp.11 tmp.10 ra.348 rbp)
         (tmp.170 tmp.11 tmp.10 ra.348 rbp)
         ((tmp.11 tmp.10 ra.348 rbp)
          ((tmp.10 ra.348 rdx rbp)
           (ra.348 rsi rdx rbp)
           (ra.348 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.10 ra.348 rdx rbp)
           (ra.348 rsi rdx rbp)
           (ra.348 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.111 r15 rdi rsi tmp.10 ra.348 rbp))
         (rbp (tmp.170 tmp.349 tmp.11 tmp.10 c.111 ra.348 r15 rdi rsi rdx))
         (ra.348 (tmp.170 tmp.349 tmp.11 tmp.10 c.111 rbp rdi rsi rdx))
         (tmp.10 (tmp.170 tmp.349 tmp.11 ra.348 rbp rdx))
         (rsi (c.111 r15 rdi ra.348 rdx rbp))
         (rdi (r15 ra.348 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.111 (rsi rdx ra.348 rbp))
         (tmp.11 (tmp.170 tmp.349 tmp.10 ra.348 rbp))
         (tmp.349 (rbp ra.348 tmp.10 tmp.11))
         (tmp.170 (tmp.11 tmp.10 ra.348 rbp)))))
      (begin
        (set! ra.348 r15)
        (set! c.111 rdi)
        (set! tmp.10 rsi)
        (set! tmp.11 rdx)
        (set! tmp.349 (bitwise-and tmp.11 7))
        (set! tmp.170 tmp.349)
        (if (eq? tmp.170 0)
          (begin
            (set! rdx tmp.11)
            (set! rsi tmp.10)
            (set! rdi 14)
            (set! r15 ra.348)
            (jump L.jp.40 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.11)
            (set! rsi tmp.10)
            (set! rdi 6)
            (set! r15 ra.348)
            (jump L.jp.40 rbp r15 rdx rsi rdi)))))
    (define L.-.48.28
      ((new-frames ())
       (locals (tmp.351 c.110 tmp.176 ra.350 tmp.12 tmp.13))
       (undead-out
        ((rdi rsi rdx ra.350 rbp)
         (rsi rdx ra.350 rbp)
         (rdx tmp.12 ra.350 rbp)
         (tmp.13 tmp.12 ra.350 rbp)
         (tmp.351 tmp.13 tmp.12 ra.350 rbp)
         (tmp.176 tmp.13 tmp.12 ra.350 rbp)
         ((tmp.13 tmp.12 ra.350 rbp)
          ((tmp.12 ra.350 rdx rbp)
           (ra.350 rsi rdx rbp)
           (ra.350 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.12 ra.350 rdx rbp)
           (ra.350 rsi rdx rbp)
           (ra.350 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.110 r15 rdi rsi tmp.12 ra.350 rbp))
         (rbp (tmp.176 tmp.351 tmp.13 tmp.12 c.110 ra.350 r15 rdi rsi rdx))
         (ra.350 (tmp.176 tmp.351 tmp.13 tmp.12 c.110 rbp rdi rsi rdx))
         (tmp.12 (tmp.176 tmp.351 tmp.13 ra.350 rbp rdx))
         (rsi (c.110 r15 rdi ra.350 rdx rbp))
         (rdi (r15 ra.350 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.110 (rsi rdx ra.350 rbp))
         (tmp.13 (tmp.176 tmp.351 tmp.12 ra.350 rbp))
         (tmp.351 (rbp ra.350 tmp.12 tmp.13))
         (tmp.176 (tmp.13 tmp.12 ra.350 rbp)))))
      (begin
        (set! ra.350 r15)
        (set! c.110 rdi)
        (set! tmp.12 rsi)
        (set! tmp.13 rdx)
        (set! tmp.351 (bitwise-and tmp.13 7))
        (set! tmp.176 tmp.351)
        (if (eq? tmp.176 0)
          (begin
            (set! rdx tmp.13)
            (set! rsi tmp.12)
            (set! rdi 14)
            (set! r15 ra.350)
            (jump L.jp.44 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.13)
            (set! rsi tmp.12)
            (set! rdi 6)
            (set! r15 ra.350)
            (jump L.jp.44 rbp r15 rdx rsi rdi)))))
    (define L.<.49.27
      ((new-frames ())
       (locals (tmp.353 c.109 tmp.183 ra.352 tmp.14 tmp.15))
       (undead-out
        ((rdi rsi rdx ra.352 rbp)
         (rsi rdx ra.352 rbp)
         (rdx tmp.14 ra.352 rbp)
         (tmp.15 tmp.14 ra.352 rbp)
         (tmp.353 tmp.15 tmp.14 ra.352 rbp)
         (tmp.183 tmp.15 tmp.14 ra.352 rbp)
         ((tmp.15 tmp.14 ra.352 rbp)
          ((tmp.14 ra.352 rdx rbp)
           (ra.352 rsi rdx rbp)
           (ra.352 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.14 ra.352 rdx rbp)
           (ra.352 rsi rdx rbp)
           (ra.352 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.109 r15 rdi rsi tmp.14 ra.352 rbp))
         (rbp (tmp.183 tmp.353 tmp.15 tmp.14 c.109 ra.352 r15 rdi rsi rdx))
         (ra.352 (tmp.183 tmp.353 tmp.15 tmp.14 c.109 rbp rdi rsi rdx))
         (tmp.14 (tmp.183 tmp.353 tmp.15 ra.352 rbp rdx))
         (rsi (c.109 r15 rdi ra.352 rdx rbp))
         (rdi (r15 ra.352 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.109 (rsi rdx ra.352 rbp))
         (tmp.15 (tmp.183 tmp.353 tmp.14 ra.352 rbp))
         (tmp.353 (rbp ra.352 tmp.14 tmp.15))
         (tmp.183 (tmp.15 tmp.14 ra.352 rbp)))))
      (begin
        (set! ra.352 r15)
        (set! c.109 rdi)
        (set! tmp.14 rsi)
        (set! tmp.15 rdx)
        (set! tmp.353 (bitwise-and tmp.15 7))
        (set! tmp.183 tmp.353)
        (if (eq? tmp.183 0)
          (begin
            (set! rdx tmp.15)
            (set! rsi tmp.14)
            (set! rdi 14)
            (set! r15 ra.352)
            (jump L.jp.49 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.15)
            (set! rsi tmp.14)
            (set! rdi 6)
            (set! r15 ra.352)
            (jump L.jp.49 rbp r15 rdx rsi rdi)))))
    (define L.<=.50.26
      ((new-frames ())
       (locals (tmp.355 c.108 tmp.190 ra.354 tmp.16 tmp.17))
       (undead-out
        ((rdi rsi rdx ra.354 rbp)
         (rsi rdx ra.354 rbp)
         (rdx tmp.16 ra.354 rbp)
         (tmp.17 tmp.16 ra.354 rbp)
         (tmp.355 tmp.17 tmp.16 ra.354 rbp)
         (tmp.190 tmp.17 tmp.16 ra.354 rbp)
         ((tmp.17 tmp.16 ra.354 rbp)
          ((tmp.16 ra.354 rdx rbp)
           (ra.354 rsi rdx rbp)
           (ra.354 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.16 ra.354 rdx rbp)
           (ra.354 rsi rdx rbp)
           (ra.354 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.108 r15 rdi rsi tmp.16 ra.354 rbp))
         (rbp (tmp.190 tmp.355 tmp.17 tmp.16 c.108 ra.354 r15 rdi rsi rdx))
         (ra.354 (tmp.190 tmp.355 tmp.17 tmp.16 c.108 rbp rdi rsi rdx))
         (tmp.16 (tmp.190 tmp.355 tmp.17 ra.354 rbp rdx))
         (rsi (c.108 r15 rdi ra.354 rdx rbp))
         (rdi (r15 ra.354 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.108 (rsi rdx ra.354 rbp))
         (tmp.17 (tmp.190 tmp.355 tmp.16 ra.354 rbp))
         (tmp.355 (rbp ra.354 tmp.16 tmp.17))
         (tmp.190 (tmp.17 tmp.16 ra.354 rbp)))))
      (begin
        (set! ra.354 r15)
        (set! c.108 rdi)
        (set! tmp.16 rsi)
        (set! tmp.17 rdx)
        (set! tmp.355 (bitwise-and tmp.17 7))
        (set! tmp.190 tmp.355)
        (if (eq? tmp.190 0)
          (begin
            (set! rdx tmp.17)
            (set! rsi tmp.16)
            (set! rdi 14)
            (set! r15 ra.354)
            (jump L.jp.54 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.17)
            (set! rsi tmp.16)
            (set! rdi 6)
            (set! r15 ra.354)
            (jump L.jp.54 rbp r15 rdx rsi rdi)))))
    (define L.>.51.25
      ((new-frames ())
       (locals (tmp.357 c.107 tmp.197 ra.356 tmp.18 tmp.19))
       (undead-out
        ((rdi rsi rdx ra.356 rbp)
         (rsi rdx ra.356 rbp)
         (rdx tmp.18 ra.356 rbp)
         (tmp.19 tmp.18 ra.356 rbp)
         (tmp.357 tmp.19 tmp.18 ra.356 rbp)
         (tmp.197 tmp.19 tmp.18 ra.356 rbp)
         ((tmp.19 tmp.18 ra.356 rbp)
          ((tmp.18 ra.356 rdx rbp)
           (ra.356 rsi rdx rbp)
           (ra.356 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.18 ra.356 rdx rbp)
           (ra.356 rsi rdx rbp)
           (ra.356 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.107 r15 rdi rsi tmp.18 ra.356 rbp))
         (rbp (tmp.197 tmp.357 tmp.19 tmp.18 c.107 ra.356 r15 rdi rsi rdx))
         (ra.356 (tmp.197 tmp.357 tmp.19 tmp.18 c.107 rbp rdi rsi rdx))
         (tmp.18 (tmp.197 tmp.357 tmp.19 ra.356 rbp rdx))
         (rsi (c.107 r15 rdi ra.356 rdx rbp))
         (rdi (r15 ra.356 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.107 (rsi rdx ra.356 rbp))
         (tmp.19 (tmp.197 tmp.357 tmp.18 ra.356 rbp))
         (tmp.357 (rbp ra.356 tmp.18 tmp.19))
         (tmp.197 (tmp.19 tmp.18 ra.356 rbp)))))
      (begin
        (set! ra.356 r15)
        (set! c.107 rdi)
        (set! tmp.18 rsi)
        (set! tmp.19 rdx)
        (set! tmp.357 (bitwise-and tmp.19 7))
        (set! tmp.197 tmp.357)
        (if (eq? tmp.197 0)
          (begin
            (set! rdx tmp.19)
            (set! rsi tmp.18)
            (set! rdi 14)
            (set! r15 ra.356)
            (jump L.jp.59 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.19)
            (set! rsi tmp.18)
            (set! rdi 6)
            (set! r15 ra.356)
            (jump L.jp.59 rbp r15 rdx rsi rdi)))))
    (define L.>=.52.24
      ((new-frames ())
       (locals (tmp.359 c.106 tmp.204 ra.358 tmp.20 tmp.21))
       (undead-out
        ((rdi rsi rdx ra.358 rbp)
         (rsi rdx ra.358 rbp)
         (rdx tmp.20 ra.358 rbp)
         (tmp.21 tmp.20 ra.358 rbp)
         (tmp.359 tmp.21 tmp.20 ra.358 rbp)
         (tmp.204 tmp.21 tmp.20 ra.358 rbp)
         ((tmp.21 tmp.20 ra.358 rbp)
          ((tmp.20 ra.358 rdx rbp)
           (ra.358 rsi rdx rbp)
           (ra.358 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.20 ra.358 rdx rbp)
           (ra.358 rsi rdx rbp)
           (ra.358 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (c.106 r15 rdi rsi tmp.20 ra.358 rbp))
         (rbp (tmp.204 tmp.359 tmp.21 tmp.20 c.106 ra.358 r15 rdi rsi rdx))
         (ra.358 (tmp.204 tmp.359 tmp.21 tmp.20 c.106 rbp rdi rsi rdx))
         (tmp.20 (tmp.204 tmp.359 tmp.21 ra.358 rbp rdx))
         (rsi (c.106 r15 rdi ra.358 rdx rbp))
         (rdi (r15 ra.358 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.106 (rsi rdx ra.358 rbp))
         (tmp.21 (tmp.204 tmp.359 tmp.20 ra.358 rbp))
         (tmp.359 (rbp ra.358 tmp.20 tmp.21))
         (tmp.204 (tmp.21 tmp.20 ra.358 rbp)))))
      (begin
        (set! ra.358 r15)
        (set! c.106 rdi)
        (set! tmp.20 rsi)
        (set! tmp.21 rdx)
        (set! tmp.359 (bitwise-and tmp.21 7))
        (set! tmp.204 tmp.359)
        (if (eq? tmp.204 0)
          (begin
            (set! rdx tmp.21)
            (set! rsi tmp.20)
            (set! rdi 14)
            (set! r15 ra.358)
            (jump L.jp.64 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.21)
            (set! rsi tmp.20)
            (set! rdi 6)
            (set! r15 ra.358)
            (jump L.jp.64 rbp r15 rdx rsi rdi)))))
    (define L.make-vector.53.23
      ((new-frames ())
       (locals (tmp.361 c.105 tmp.207 ra.360 make-init-vector.1 tmp.22))
       (undead-out
        ((rdi rsi ra.360 rbp)
         (rsi c.105 ra.360 rbp)
         (c.105 tmp.22 ra.360 rbp)
         (tmp.22 make-init-vector.1 ra.360 rbp)
         (tmp.361 tmp.22 make-init-vector.1 ra.360 rbp)
         (tmp.207 tmp.22 make-init-vector.1 ra.360 rbp)
         ((tmp.22 make-init-vector.1 ra.360 rbp)
          ((make-init-vector.1 ra.360 rdx rbp)
           (ra.360 rsi rdx rbp)
           (ra.360 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((make-init-vector.1 ra.360 rdx rbp)
           (ra.360 rsi rdx rbp)
           (ra.360 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (r15 rdi rsi make-init-vector.1 ra.360 rbp))
         (rbp
          (tmp.207
           tmp.361
           make-init-vector.1
           tmp.22
           c.105
           ra.360
           r15
           rdi
           rsi
           rdx))
         (ra.360
          (tmp.207 tmp.361 make-init-vector.1 tmp.22 c.105 rbp rdi rsi rdx))
         (make-init-vector.1 (tmp.207 tmp.361 rbp ra.360 tmp.22 rdx))
         (rsi (c.105 r15 rdi ra.360 rdx rbp))
         (rdi (r15 ra.360 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.105 (tmp.22 rsi ra.360 rbp))
         (tmp.22 (tmp.207 tmp.361 make-init-vector.1 c.105 ra.360 rbp))
         (tmp.361 (rbp ra.360 make-init-vector.1 tmp.22))
         (tmp.207 (tmp.22 make-init-vector.1 ra.360 rbp)))))
      (begin
        (set! ra.360 r15)
        (set! c.105 rdi)
        (set! tmp.22 rsi)
        (set! make-init-vector.1 (mref c.105 14))
        (set! tmp.361 (bitwise-and tmp.22 7))
        (set! tmp.207 tmp.361)
        (if (eq? tmp.207 0)
          (begin
            (set! rdx tmp.22)
            (set! rsi make-init-vector.1)
            (set! rdi 14)
            (set! r15 ra.360)
            (jump L.jp.66 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.22)
            (set! rsi make-init-vector.1)
            (set! rdi 6)
            (set! r15 ra.360)
            (jump L.jp.66 rbp r15 rdx rsi rdi)))))
    (define L.vector-length.54.22
      ((new-frames ())
       (locals (tmp.363 c.104 tmp.210 ra.362 tmp.23))
       (undead-out
        ((rdi rsi ra.362 rbp)
         (rsi ra.362 rbp)
         (tmp.23 ra.362 rbp)
         (tmp.363 tmp.23 ra.362 rbp)
         (tmp.210 tmp.23 ra.362 rbp)
         ((tmp.23 ra.362 rbp)
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
        ((rsi (c.104 r15 rdi ra.362 rbp))
         (rbp (tmp.210 tmp.363 tmp.23 c.104 ra.362 r15 rdi rsi))
         (ra.362 (tmp.210 tmp.363 tmp.23 c.104 rbp rdi rsi))
         (rdi (r15 ra.362 rsi rbp))
         (r15 (rdi rsi rbp))
         (c.104 (rsi ra.362 rbp))
         (tmp.23 (tmp.210 tmp.363 ra.362 rbp))
         (tmp.363 (rbp ra.362 tmp.23))
         (tmp.210 (tmp.23 ra.362 rbp)))))
      (begin
        (set! ra.362 r15)
        (set! c.104 rdi)
        (set! tmp.23 rsi)
        (set! tmp.363 (bitwise-and tmp.23 7))
        (set! tmp.210 tmp.363)
        (if (eq? tmp.210 3)
          (begin
            (set! rsi tmp.23)
            (set! rdi 14)
            (set! r15 ra.362)
            (jump L.jp.68 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.23)
            (set! rdi 6)
            (set! r15 ra.362)
            (jump L.jp.68 rbp r15 rsi rdi)))))
    (define L.vector-set!.55.21
      ((new-frames ())
       (locals
        (tmp.365
         c.103
         tmp.216
         ra.364
         tmp.24
         unsafe-vector-set!.2
         tmp.26
         tmp.25))
       (undead-out
        ((rdi rsi rdx rcx ra.364 rbp)
         (rsi rdx rcx c.103 ra.364 rbp)
         (rdx rcx c.103 tmp.24 ra.364 rbp)
         (rcx c.103 tmp.25 tmp.24 ra.364 rbp)
         (c.103 tmp.25 tmp.26 tmp.24 ra.364 rbp)
         (tmp.25 tmp.26 unsafe-vector-set!.2 tmp.24 ra.364 rbp)
         (tmp.365 tmp.25 tmp.26 unsafe-vector-set!.2 tmp.24 ra.364 rbp)
         (tmp.216 tmp.25 tmp.26 unsafe-vector-set!.2 tmp.24 ra.364 rbp)
         ((tmp.25 tmp.26 unsafe-vector-set!.2 tmp.24 ra.364 rbp)
          ((tmp.26 unsafe-vector-set!.2 tmp.24 ra.364 r8 rbp)
           (unsafe-vector-set!.2 tmp.24 ra.364 rcx r8 rbp)
           (tmp.24 ra.364 rdx rcx r8 rbp)
           (ra.364 rsi rdx rcx r8 rbp)
           (ra.364 rdi rsi rdx rcx r8 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)
           (rdi rsi rdx rcx r8 r15 rbp))
          ((tmp.26 unsafe-vector-set!.2 tmp.24 ra.364 r8 rbp)
           (unsafe-vector-set!.2 tmp.24 ra.364 rcx r8 rbp)
           (tmp.24 ra.364 rdx rcx r8 rbp)
           (ra.364 rsi rdx rcx r8 rbp)
           (ra.364 rdi rsi rdx rcx r8 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)))))
       (call-undead ())
       (conflicts
        ((r8
          (r15 rdi rsi rdx rcx tmp.26 unsafe-vector-set!.2 tmp.24 ra.364 rbp))
         (rbp
          (tmp.216
           tmp.365
           unsafe-vector-set!.2
           tmp.26
           tmp.25
           tmp.24
           c.103
           ra.364
           r15
           rdi
           rsi
           rdx
           rcx
           r8))
         (ra.364
          (tmp.216
           tmp.365
           unsafe-vector-set!.2
           tmp.26
           tmp.25
           tmp.24
           c.103
           rbp
           rdi
           rsi
           rdx
           rcx
           r8))
         (tmp.24
          (tmp.216
           tmp.365
           unsafe-vector-set!.2
           tmp.26
           tmp.25
           c.103
           ra.364
           rbp
           rdx
           rcx
           r8))
         (unsafe-vector-set!.2
          (tmp.216 tmp.365 rbp ra.364 tmp.24 tmp.26 tmp.25 rcx r8))
         (tmp.26
          (tmp.216
           tmp.365
           unsafe-vector-set!.2
           c.103
           tmp.25
           tmp.24
           ra.364
           rbp
           r8))
         (rcx
          (tmp.25
           c.103
           r15
           rdi
           rsi
           rdx
           unsafe-vector-set!.2
           tmp.24
           ra.364
           r8
           rbp))
         (rdx (c.103 r15 rdi rsi tmp.24 ra.364 rcx r8 rbp))
         (rsi (c.103 r15 rdi ra.364 rdx rcx r8 rbp))
         (rdi (r15 ra.364 rsi rdx rcx r8 rbp))
         (r15 (rdi rsi rdx rcx r8 rbp))
         (c.103 (tmp.26 tmp.25 tmp.24 rsi rdx rcx ra.364 rbp))
         (tmp.25
          (tmp.216
           tmp.365
           unsafe-vector-set!.2
           tmp.26
           rcx
           c.103
           tmp.24
           ra.364
           rbp))
         (tmp.365 (rbp ra.364 tmp.24 unsafe-vector-set!.2 tmp.26 tmp.25))
         (tmp.216 (tmp.25 tmp.26 unsafe-vector-set!.2 tmp.24 ra.364 rbp)))))
      (begin
        (set! ra.364 r15)
        (set! c.103 rdi)
        (set! tmp.24 rsi)
        (set! tmp.25 rdx)
        (set! tmp.26 rcx)
        (set! unsafe-vector-set!.2 (mref c.103 14))
        (set! tmp.365 (bitwise-and tmp.25 7))
        (set! tmp.216 tmp.365)
        (if (eq? tmp.216 0)
          (begin
            (set! r8 tmp.25)
            (set! rcx tmp.26)
            (set! rdx unsafe-vector-set!.2)
            (set! rsi tmp.24)
            (set! rdi 14)
            (set! r15 ra.364)
            (jump L.jp.72 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 tmp.25)
            (set! rcx tmp.26)
            (set! rdx unsafe-vector-set!.2)
            (set! rsi tmp.24)
            (set! rdi 6)
            (set! r15 ra.364)
            (jump L.jp.72 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.vector-ref.56.20
      ((new-frames ())
       (locals
        (tmp.367 c.102 tmp.222 ra.366 tmp.27 unsafe-vector-ref.3 tmp.28))
       (undead-out
        ((rdi rsi rdx ra.366 rbp)
         (rsi rdx c.102 ra.366 rbp)
         (rdx c.102 tmp.27 ra.366 rbp)
         (c.102 tmp.28 tmp.27 ra.366 rbp)
         (tmp.28 unsafe-vector-ref.3 tmp.27 ra.366 rbp)
         (tmp.367 tmp.28 unsafe-vector-ref.3 tmp.27 ra.366 rbp)
         (tmp.222 tmp.28 unsafe-vector-ref.3 tmp.27 ra.366 rbp)
         ((tmp.28 unsafe-vector-ref.3 tmp.27 ra.366 rbp)
          ((unsafe-vector-ref.3 tmp.27 ra.366 rcx rbp)
           (tmp.27 ra.366 rdx rcx rbp)
           (ra.366 rsi rdx rcx rbp)
           (ra.366 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp))
          ((unsafe-vector-ref.3 tmp.27 ra.366 rcx rbp)
           (tmp.27 ra.366 rdx rcx rbp)
           (ra.366 rsi rdx rcx rbp)
           (ra.366 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rcx (r15 rdi rsi rdx unsafe-vector-ref.3 tmp.27 ra.366 rbp))
         (rbp
          (tmp.222
           tmp.367
           unsafe-vector-ref.3
           tmp.28
           tmp.27
           c.102
           ra.366
           r15
           rdi
           rsi
           rdx
           rcx))
         (ra.366
          (tmp.222
           tmp.367
           unsafe-vector-ref.3
           tmp.28
           tmp.27
           c.102
           rbp
           rdi
           rsi
           rdx
           rcx))
         (tmp.27
          (tmp.222
           tmp.367
           unsafe-vector-ref.3
           tmp.28
           c.102
           ra.366
           rbp
           rdx
           rcx))
         (unsafe-vector-ref.3 (tmp.222 tmp.367 rbp ra.366 tmp.27 tmp.28 rcx))
         (rdx (c.102 r15 rdi rsi tmp.27 ra.366 rcx rbp))
         (rsi (c.102 r15 rdi ra.366 rdx rcx rbp))
         (rdi (r15 ra.366 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (c.102 (tmp.28 tmp.27 rsi rdx ra.366 rbp))
         (tmp.28 (tmp.222 tmp.367 unsafe-vector-ref.3 c.102 tmp.27 ra.366 rbp))
         (tmp.367 (rbp ra.366 tmp.27 unsafe-vector-ref.3 tmp.28))
         (tmp.222 (tmp.28 unsafe-vector-ref.3 tmp.27 ra.366 rbp)))))
      (begin
        (set! ra.366 r15)
        (set! c.102 rdi)
        (set! tmp.27 rsi)
        (set! tmp.28 rdx)
        (set! unsafe-vector-ref.3 (mref c.102 14))
        (set! tmp.367 (bitwise-and tmp.28 7))
        (set! tmp.222 tmp.367)
        (if (eq? tmp.222 0)
          (begin
            (set! rcx tmp.28)
            (set! rdx unsafe-vector-ref.3)
            (set! rsi tmp.27)
            (set! rdi 14)
            (set! r15 ra.366)
            (jump L.jp.76 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx tmp.28)
            (set! rdx unsafe-vector-ref.3)
            (set! rsi tmp.27)
            (set! rdi 6)
            (set! r15 ra.366)
            (jump L.jp.76 rbp r15 rcx rdx rsi rdi)))))
    (define L.car.57.19
      ((new-frames ())
       (locals (tmp.369 c.101 tmp.225 ra.368 tmp.29))
       (undead-out
        ((rdi rsi ra.368 rbp)
         (rsi ra.368 rbp)
         (tmp.29 ra.368 rbp)
         (tmp.369 tmp.29 ra.368 rbp)
         (tmp.225 tmp.29 ra.368 rbp)
         ((tmp.29 ra.368 rbp)
          ((ra.368 rsi rbp)
           (ra.368 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp))
          ((ra.368 rsi rbp)
           (ra.368 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rsi (c.101 r15 rdi ra.368 rbp))
         (rbp (tmp.225 tmp.369 tmp.29 c.101 ra.368 r15 rdi rsi))
         (ra.368 (tmp.225 tmp.369 tmp.29 c.101 rbp rdi rsi))
         (rdi (r15 ra.368 rsi rbp))
         (r15 (rdi rsi rbp))
         (c.101 (rsi ra.368 rbp))
         (tmp.29 (tmp.225 tmp.369 ra.368 rbp))
         (tmp.369 (rbp ra.368 tmp.29))
         (tmp.225 (tmp.29 ra.368 rbp)))))
      (begin
        (set! ra.368 r15)
        (set! c.101 rdi)
        (set! tmp.29 rsi)
        (set! tmp.369 (bitwise-and tmp.29 7))
        (set! tmp.225 tmp.369)
        (if (eq? tmp.225 1)
          (begin
            (set! rsi tmp.29)
            (set! rdi 14)
            (set! r15 ra.368)
            (jump L.jp.78 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.29)
            (set! rdi 6)
            (set! r15 ra.368)
            (jump L.jp.78 rbp r15 rsi rdi)))))
    (define L.cdr.58.18
      ((new-frames ())
       (locals (tmp.371 c.100 tmp.228 ra.370 tmp.30))
       (undead-out
        ((rdi rsi ra.370 rbp)
         (rsi ra.370 rbp)
         (tmp.30 ra.370 rbp)
         (tmp.371 tmp.30 ra.370 rbp)
         (tmp.228 tmp.30 ra.370 rbp)
         ((tmp.30 ra.370 rbp)
          ((ra.370 rsi rbp)
           (ra.370 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp))
          ((ra.370 rsi rbp)
           (ra.370 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rsi (c.100 r15 rdi ra.370 rbp))
         (rbp (tmp.228 tmp.371 tmp.30 c.100 ra.370 r15 rdi rsi))
         (ra.370 (tmp.228 tmp.371 tmp.30 c.100 rbp rdi rsi))
         (rdi (r15 ra.370 rsi rbp))
         (r15 (rdi rsi rbp))
         (c.100 (rsi ra.370 rbp))
         (tmp.30 (tmp.228 tmp.371 ra.370 rbp))
         (tmp.371 (rbp ra.370 tmp.30))
         (tmp.228 (tmp.30 ra.370 rbp)))))
      (begin
        (set! ra.370 r15)
        (set! c.100 rdi)
        (set! tmp.30 rsi)
        (set! tmp.371 (bitwise-and tmp.30 7))
        (set! tmp.228 tmp.371)
        (if (eq? tmp.228 1)
          (begin
            (set! rsi tmp.30)
            (set! rdi 14)
            (set! r15 ra.370)
            (jump L.jp.80 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.30)
            (set! rdi 6)
            (set! r15 ra.370)
            (jump L.jp.80 rbp r15 rsi rdi)))))
    (define L.procedure-arity.59.17
      ((new-frames ())
       (locals (tmp.373 c.99 tmp.231 ra.372 tmp.31))
       (undead-out
        ((rdi rsi ra.372 rbp)
         (rsi ra.372 rbp)
         (tmp.31 ra.372 rbp)
         (tmp.373 tmp.31 ra.372 rbp)
         (tmp.231 tmp.31 ra.372 rbp)
         ((tmp.31 ra.372 rbp)
          ((ra.372 rsi rbp)
           (ra.372 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp))
          ((ra.372 rsi rbp)
           (ra.372 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rsi (c.99 r15 rdi ra.372 rbp))
         (rbp (tmp.231 tmp.373 tmp.31 c.99 ra.372 r15 rdi rsi))
         (ra.372 (tmp.231 tmp.373 tmp.31 c.99 rbp rdi rsi))
         (rdi (r15 ra.372 rsi rbp))
         (r15 (rdi rsi rbp))
         (c.99 (rsi ra.372 rbp))
         (tmp.31 (tmp.231 tmp.373 ra.372 rbp))
         (tmp.373 (rbp ra.372 tmp.31))
         (tmp.231 (tmp.31 ra.372 rbp)))))
      (begin
        (set! ra.372 r15)
        (set! c.99 rdi)
        (set! tmp.31 rsi)
        (set! tmp.373 (bitwise-and tmp.31 7))
        (set! tmp.231 tmp.373)
        (if (eq? tmp.231 2)
          (begin
            (set! rsi tmp.31)
            (set! rdi 14)
            (set! r15 ra.372)
            (jump L.jp.82 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.31)
            (set! rdi 6)
            (set! r15 ra.372)
            (jump L.jp.82 rbp r15 rsi rdi)))))
    (define L.fixnum?.60.16
      ((new-frames ())
       (locals (tmp.375 tmp.32 c.98 ra.374 tmp.233))
       (undead-out
        ((rdi rsi ra.374 rbp)
         (rsi ra.374 rbp)
         (tmp.32 ra.374 rbp)
         (tmp.375 ra.374 rbp)
         (tmp.233 ra.374 rbp)
         ((ra.374 rbp)
          ((ra.374 rax rbp) (rax rbp))
          ((ra.374 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.374 rbp))
         (rbp (tmp.233 tmp.375 tmp.32 c.98 ra.374 rax))
         (ra.374 (tmp.233 tmp.375 tmp.32 c.98 rdi rsi rbp rax))
         (rsi (c.98 ra.374))
         (rdi (ra.374))
         (c.98 (rsi ra.374 rbp))
         (tmp.32 (ra.374 rbp))
         (tmp.375 (rbp ra.374))
         (tmp.233 (ra.374 rbp)))))
      (begin
        (set! ra.374 r15)
        (set! c.98 rdi)
        (set! tmp.32 rsi)
        (set! tmp.375 (bitwise-and tmp.32 7))
        (set! tmp.233 tmp.375)
        (if (eq? tmp.233 0)
          (begin (set! rax 14) (jump ra.374 rbp rax))
          (begin (set! rax 6) (jump ra.374 rbp rax)))))
    (define L.boolean?.61.15
      ((new-frames ())
       (locals (tmp.377 tmp.33 c.97 ra.376 tmp.235))
       (undead-out
        ((rdi rsi ra.376 rbp)
         (rsi ra.376 rbp)
         (tmp.33 ra.376 rbp)
         (tmp.377 ra.376 rbp)
         (tmp.235 ra.376 rbp)
         ((ra.376 rbp)
          ((ra.376 rax rbp) (rax rbp))
          ((ra.376 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.376 rbp))
         (rbp (tmp.235 tmp.377 tmp.33 c.97 ra.376 rax))
         (ra.376 (tmp.235 tmp.377 tmp.33 c.97 rdi rsi rbp rax))
         (rsi (c.97 ra.376))
         (rdi (ra.376))
         (c.97 (rsi ra.376 rbp))
         (tmp.33 (ra.376 rbp))
         (tmp.377 (rbp ra.376))
         (tmp.235 (ra.376 rbp)))))
      (begin
        (set! ra.376 r15)
        (set! c.97 rdi)
        (set! tmp.33 rsi)
        (set! tmp.377 (bitwise-and tmp.33 247))
        (set! tmp.235 tmp.377)
        (if (eq? tmp.235 6)
          (begin (set! rax 14) (jump ra.376 rbp rax))
          (begin (set! rax 6) (jump ra.376 rbp rax)))))
    (define L.empty?.62.14
      ((new-frames ())
       (locals (tmp.379 tmp.34 c.96 ra.378 tmp.237))
       (undead-out
        ((rdi rsi ra.378 rbp)
         (rsi ra.378 rbp)
         (tmp.34 ra.378 rbp)
         (tmp.379 ra.378 rbp)
         (tmp.237 ra.378 rbp)
         ((ra.378 rbp)
          ((ra.378 rax rbp) (rax rbp))
          ((ra.378 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.378 rbp))
         (rbp (tmp.237 tmp.379 tmp.34 c.96 ra.378 rax))
         (ra.378 (tmp.237 tmp.379 tmp.34 c.96 rdi rsi rbp rax))
         (rsi (c.96 ra.378))
         (rdi (ra.378))
         (c.96 (rsi ra.378 rbp))
         (tmp.34 (ra.378 rbp))
         (tmp.379 (rbp ra.378))
         (tmp.237 (ra.378 rbp)))))
      (begin
        (set! ra.378 r15)
        (set! c.96 rdi)
        (set! tmp.34 rsi)
        (set! tmp.379 (bitwise-and tmp.34 255))
        (set! tmp.237 tmp.379)
        (if (eq? tmp.237 22)
          (begin (set! rax 14) (jump ra.378 rbp rax))
          (begin (set! rax 6) (jump ra.378 rbp rax)))))
    (define L.void?.63.13
      ((new-frames ())
       (locals (tmp.381 tmp.35 c.95 ra.380 tmp.239))
       (undead-out
        ((rdi rsi ra.380 rbp)
         (rsi ra.380 rbp)
         (tmp.35 ra.380 rbp)
         (tmp.381 ra.380 rbp)
         (tmp.239 ra.380 rbp)
         ((ra.380 rbp)
          ((ra.380 rax rbp) (rax rbp))
          ((ra.380 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.380 rbp))
         (rbp (tmp.239 tmp.381 tmp.35 c.95 ra.380 rax))
         (ra.380 (tmp.239 tmp.381 tmp.35 c.95 rdi rsi rbp rax))
         (rsi (c.95 ra.380))
         (rdi (ra.380))
         (c.95 (rsi ra.380 rbp))
         (tmp.35 (ra.380 rbp))
         (tmp.381 (rbp ra.380))
         (tmp.239 (ra.380 rbp)))))
      (begin
        (set! ra.380 r15)
        (set! c.95 rdi)
        (set! tmp.35 rsi)
        (set! tmp.381 (bitwise-and tmp.35 255))
        (set! tmp.239 tmp.381)
        (if (eq? tmp.239 30)
          (begin (set! rax 14) (jump ra.380 rbp rax))
          (begin (set! rax 6) (jump ra.380 rbp rax)))))
    (define L.ascii-char?.64.12
      ((new-frames ())
       (locals (tmp.383 tmp.36 c.94 ra.382 tmp.241))
       (undead-out
        ((rdi rsi ra.382 rbp)
         (rsi ra.382 rbp)
         (tmp.36 ra.382 rbp)
         (tmp.383 ra.382 rbp)
         (tmp.241 ra.382 rbp)
         ((ra.382 rbp)
          ((ra.382 rax rbp) (rax rbp))
          ((ra.382 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.382 rbp))
         (rbp (tmp.241 tmp.383 tmp.36 c.94 ra.382 rax))
         (ra.382 (tmp.241 tmp.383 tmp.36 c.94 rdi rsi rbp rax))
         (rsi (c.94 ra.382))
         (rdi (ra.382))
         (c.94 (rsi ra.382 rbp))
         (tmp.36 (ra.382 rbp))
         (tmp.383 (rbp ra.382))
         (tmp.241 (ra.382 rbp)))))
      (begin
        (set! ra.382 r15)
        (set! c.94 rdi)
        (set! tmp.36 rsi)
        (set! tmp.383 (bitwise-and tmp.36 255))
        (set! tmp.241 tmp.383)
        (if (eq? tmp.241 46)
          (begin (set! rax 14) (jump ra.382 rbp rax))
          (begin (set! rax 6) (jump ra.382 rbp rax)))))
    (define L.error?.65.11
      ((new-frames ())
       (locals (tmp.385 tmp.37 c.93 ra.384 tmp.243))
       (undead-out
        ((rdi rsi ra.384 rbp)
         (rsi ra.384 rbp)
         (tmp.37 ra.384 rbp)
         (tmp.385 ra.384 rbp)
         (tmp.243 ra.384 rbp)
         ((ra.384 rbp)
          ((ra.384 rax rbp) (rax rbp))
          ((ra.384 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.384 rbp))
         (rbp (tmp.243 tmp.385 tmp.37 c.93 ra.384 rax))
         (ra.384 (tmp.243 tmp.385 tmp.37 c.93 rdi rsi rbp rax))
         (rsi (c.93 ra.384))
         (rdi (ra.384))
         (c.93 (rsi ra.384 rbp))
         (tmp.37 (ra.384 rbp))
         (tmp.385 (rbp ra.384))
         (tmp.243 (ra.384 rbp)))))
      (begin
        (set! ra.384 r15)
        (set! c.93 rdi)
        (set! tmp.37 rsi)
        (set! tmp.385 (bitwise-and tmp.37 255))
        (set! tmp.243 tmp.385)
        (if (eq? tmp.243 62)
          (begin (set! rax 14) (jump ra.384 rbp rax))
          (begin (set! rax 6) (jump ra.384 rbp rax)))))
    (define L.pair?.66.10
      ((new-frames ())
       (locals (tmp.387 tmp.38 c.92 ra.386 tmp.245))
       (undead-out
        ((rdi rsi ra.386 rbp)
         (rsi ra.386 rbp)
         (tmp.38 ra.386 rbp)
         (tmp.387 ra.386 rbp)
         (tmp.245 ra.386 rbp)
         ((ra.386 rbp)
          ((ra.386 rax rbp) (rax rbp))
          ((ra.386 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.386 rbp))
         (rbp (tmp.245 tmp.387 tmp.38 c.92 ra.386 rax))
         (ra.386 (tmp.245 tmp.387 tmp.38 c.92 rdi rsi rbp rax))
         (rsi (c.92 ra.386))
         (rdi (ra.386))
         (c.92 (rsi ra.386 rbp))
         (tmp.38 (ra.386 rbp))
         (tmp.387 (rbp ra.386))
         (tmp.245 (ra.386 rbp)))))
      (begin
        (set! ra.386 r15)
        (set! c.92 rdi)
        (set! tmp.38 rsi)
        (set! tmp.387 (bitwise-and tmp.38 7))
        (set! tmp.245 tmp.387)
        (if (eq? tmp.245 1)
          (begin (set! rax 14) (jump ra.386 rbp rax))
          (begin (set! rax 6) (jump ra.386 rbp rax)))))
    (define L.procedure?.67.9
      ((new-frames ())
       (locals (tmp.389 tmp.39 c.91 ra.388 tmp.247))
       (undead-out
        ((rdi rsi ra.388 rbp)
         (rsi ra.388 rbp)
         (tmp.39 ra.388 rbp)
         (tmp.389 ra.388 rbp)
         (tmp.247 ra.388 rbp)
         ((ra.388 rbp)
          ((ra.388 rax rbp) (rax rbp))
          ((ra.388 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.388 rbp))
         (rbp (tmp.247 tmp.389 tmp.39 c.91 ra.388 rax))
         (ra.388 (tmp.247 tmp.389 tmp.39 c.91 rdi rsi rbp rax))
         (rsi (c.91 ra.388))
         (rdi (ra.388))
         (c.91 (rsi ra.388 rbp))
         (tmp.39 (ra.388 rbp))
         (tmp.389 (rbp ra.388))
         (tmp.247 (ra.388 rbp)))))
      (begin
        (set! ra.388 r15)
        (set! c.91 rdi)
        (set! tmp.39 rsi)
        (set! tmp.389 (bitwise-and tmp.39 7))
        (set! tmp.247 tmp.389)
        (if (eq? tmp.247 2)
          (begin (set! rax 14) (jump ra.388 rbp rax))
          (begin (set! rax 6) (jump ra.388 rbp rax)))))
    (define L.vector?.68.8
      ((new-frames ())
       (locals (tmp.391 tmp.40 c.90 ra.390 tmp.249))
       (undead-out
        ((rdi rsi ra.390 rbp)
         (rsi ra.390 rbp)
         (tmp.40 ra.390 rbp)
         (tmp.391 ra.390 rbp)
         (tmp.249 ra.390 rbp)
         ((ra.390 rbp)
          ((ra.390 rax rbp) (rax rbp))
          ((ra.390 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.390 rbp))
         (rbp (tmp.249 tmp.391 tmp.40 c.90 ra.390 rax))
         (ra.390 (tmp.249 tmp.391 tmp.40 c.90 rdi rsi rbp rax))
         (rsi (c.90 ra.390))
         (rdi (ra.390))
         (c.90 (rsi ra.390 rbp))
         (tmp.40 (ra.390 rbp))
         (tmp.391 (rbp ra.390))
         (tmp.249 (ra.390 rbp)))))
      (begin
        (set! ra.390 r15)
        (set! c.90 rdi)
        (set! tmp.40 rsi)
        (set! tmp.391 (bitwise-and tmp.40 7))
        (set! tmp.249 tmp.391)
        (if (eq? tmp.249 3)
          (begin (set! rax 14) (jump ra.390 rbp rax))
          (begin (set! rax 6) (jump ra.390 rbp rax)))))
    (define L.not.69.7
      ((new-frames ())
       (locals (c.89 ra.392 tmp.41))
       (undead-out
        ((rdi rsi ra.392 rbp)
         (rsi ra.392 rbp)
         (tmp.41 ra.392 rbp)
         ((ra.392 rbp)
          ((ra.392 rax rbp) (rax rbp))
          ((ra.392 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.392 rbp))
         (rbp (tmp.41 c.89 ra.392 rax))
         (ra.392 (tmp.41 c.89 rdi rsi rbp rax))
         (rsi (c.89 ra.392))
         (rdi (ra.392))
         (c.89 (rsi ra.392 rbp))
         (tmp.41 (ra.392 rbp)))))
      (begin
        (set! ra.392 r15)
        (set! c.89 rdi)
        (set! tmp.41 rsi)
        (if (neq? tmp.41 6)
          (begin (set! rax 6) (jump ra.392 rbp rax))
          (begin (set! rax 14) (jump ra.392 rbp rax)))))
    (define L.cons.70.6
      ((new-frames ())
       (locals (tmp.124 tmp.394 tmp.251 tmp.43 tmp.42 c.88 ra.393))
       (undead-out
        ((rdi rsi rdx r12 ra.393 rbp)
         (rsi rdx r12 ra.393 rbp)
         (rdx r12 ra.393 rbp tmp.42)
         (r12 tmp.43 ra.393 rbp tmp.42)
         (r12 tmp.251 tmp.43 ra.393 rbp tmp.42)
         (tmp.251 tmp.43 ra.393 rbp tmp.42)
         (tmp.394 tmp.43 ra.393 rbp tmp.42)
         (tmp.43 ra.393 rbp tmp.42 tmp.124)
         (rbp ra.393 tmp.43 tmp.124)
         (tmp.124 ra.393 rbp)
         (ra.393 rax rbp)
         (rax rbp)))
       (call-undead ())
       (conflicts
        ((ra.393
          (rax tmp.124 tmp.394 tmp.251 tmp.43 tmp.42 c.88 rdi rsi rdx r12 rbp))
         (rbp (rax tmp.124 tmp.394 r12 tmp.251 tmp.43 tmp.42 c.88 ra.393))
         (r12 (rbp tmp.251 tmp.43 tmp.42 c.88 ra.393))
         (rdx (tmp.42 c.88 ra.393))
         (rsi (c.88 ra.393))
         (rdi (ra.393))
         (c.88 (rsi rdx r12 ra.393 rbp))
         (tmp.42 (tmp.124 tmp.394 tmp.251 tmp.43 rdx r12 ra.393 rbp))
         (tmp.43 (tmp.124 tmp.394 tmp.251 r12 ra.393 rbp tmp.42))
         (tmp.251 (r12 tmp.43 ra.393 rbp tmp.42))
         (tmp.394 (tmp.42 rbp ra.393 tmp.43))
         (tmp.124 (tmp.43 ra.393 rbp tmp.42))
         (rax (ra.393 rbp)))))
      (begin
        (set! ra.393 r15)
        (set! c.88 rdi)
        (set! tmp.42 rsi)
        (set! tmp.43 rdx)
        (set! tmp.251 r12)
        (set! r12 (+ r12 16))
        (set! tmp.394 (+ tmp.251 1))
        (set! tmp.124 tmp.394)
        (mset! tmp.124 -1 tmp.42)
        (mset! tmp.124 7 tmp.43)
        (set! rax tmp.124)
        (jump ra.393 rbp rax)))
    (define L.eq?.71.5
      ((new-frames ())
       (locals (c.87 ra.395 tmp.45 tmp.44))
       (undead-out
        ((rdi rsi rdx ra.395 rbp)
         (rsi rdx ra.395 rbp)
         (rdx tmp.44 ra.395 rbp)
         (tmp.44 tmp.45 ra.395 rbp)
         ((ra.395 rbp)
          ((ra.395 rax rbp) (rax rbp))
          ((ra.395 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.395 rbp))
         (rbp (tmp.45 tmp.44 c.87 ra.395 rax))
         (ra.395 (tmp.45 tmp.44 c.87 rdi rsi rdx rbp rax))
         (rdx (tmp.44 c.87 ra.395))
         (rsi (c.87 ra.395))
         (rdi (ra.395))
         (c.87 (rsi rdx ra.395 rbp))
         (tmp.44 (tmp.45 rdx ra.395 rbp))
         (tmp.45 (tmp.44 ra.395 rbp)))))
      (begin
        (set! ra.395 r15)
        (set! c.87 rdi)
        (set! tmp.44 rsi)
        (set! tmp.45 rdx)
        (if (eq? tmp.44 tmp.45)
          (begin (set! rax 14) (jump ra.395 rbp rax))
          (begin (set! rax 6) (jump ra.395 rbp rax)))))
    (define L.make-init-vector.1.4
      ((new-frames ())
       (locals
        (tmp.116
         tmp.73
         tmp.125
         tmp.401
         tmp.256
         tmp.489
         tmp.255
         tmp.400
         tmp.254
         tmp.399
         tmp.398
         tmp.253
         tmp.397
         vector-init-loop.74
         tmp.72
         c.86
         ra.396))
       (undead-out
        ((rdi rsi r12 rbp ra.396)
         (rsi c.86 r12 rbp ra.396)
         (c.86 r12 rbp ra.396 tmp.72)
         (r12 rbp ra.396 vector-init-loop.74 tmp.72)
         (tmp.397 r12 rbp ra.396 vector-init-loop.74 tmp.72)
         (tmp.253 r12 rbp ra.396 vector-init-loop.74 tmp.72)
         (tmp.253 tmp.398 r12 rbp ra.396 vector-init-loop.74 tmp.72)
         (tmp.399 r12 rbp ra.396 vector-init-loop.74 tmp.72)
         (tmp.254 r12 rbp ra.396 vector-init-loop.74 tmp.72)
         (tmp.400 r12 rbp ra.396 vector-init-loop.74 tmp.72)
         (tmp.255 r12 rbp ra.396 vector-init-loop.74 tmp.72)
         (tmp.489 r12 rbp ra.396 vector-init-loop.74 tmp.72)
         (tmp.489 r12 tmp.256 rbp ra.396 vector-init-loop.74 tmp.72)
         (tmp.256 rbp ra.396 vector-init-loop.74 tmp.72)
         (tmp.401 rbp ra.396 vector-init-loop.74 tmp.72)
         (rbp ra.396 vector-init-loop.74 tmp.72 tmp.125)
         (tmp.125 tmp.72 vector-init-loop.74 ra.396 rbp)
         (tmp.73 tmp.72 vector-init-loop.74 ra.396 rbp)
         (tmp.73 tmp.72 vector-init-loop.74 ra.396 rbp)
         (tmp.72 vector-init-loop.74 ra.396 rcx rbp)
         (tmp.72 vector-init-loop.74 ra.396 rdx rcx rbp)
         (vector-init-loop.74 ra.396 rsi rdx rcx rbp)
         (ra.396 rdi rsi rdx rcx rbp)
         (rdi rsi rdx rcx r15 rbp)
         (rdi rsi rdx rcx r15 rbp)))
       (call-undead ())
       (conflicts
        ((ra.396
          (rdx
           rcx
           tmp.116
           tmp.73
           tmp.125
           tmp.401
           tmp.256
           tmp.489
           tmp.255
           tmp.400
           tmp.254
           tmp.399
           tmp.398
           tmp.253
           tmp.397
           vector-init-loop.74
           tmp.72
           c.86
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
           tmp.116
           tmp.73
           tmp.125
           tmp.401
           r12
           tmp.256
           tmp.489
           tmp.255
           tmp.400
           tmp.254
           tmp.399
           tmp.398
           tmp.253
           tmp.397
           vector-init-loop.74
           tmp.72
           c.86
           ra.396))
         (r12
          (rbp
           tmp.256
           tmp.489
           tmp.255
           tmp.400
           tmp.254
           tmp.399
           tmp.398
           tmp.253
           tmp.397
           vector-init-loop.74
           tmp.72
           c.86
           ra.396))
         (rsi (r15 rdi vector-init-loop.74 rdx rcx rbp c.86 ra.396))
         (rdi (r15 rsi rdx rcx rbp ra.396))
         (c.86 (tmp.72 rsi r12 rbp ra.396))
         (tmp.72
          (rdx
           rcx
           tmp.116
           tmp.73
           tmp.125
           tmp.401
           tmp.256
           tmp.489
           tmp.255
           tmp.400
           tmp.254
           tmp.399
           tmp.398
           tmp.253
           tmp.397
           vector-init-loop.74
           c.86
           r12
           rbp
           ra.396))
         (vector-init-loop.74
          (rsi
           rdx
           rcx
           tmp.73
           tmp.125
           tmp.401
           tmp.256
           tmp.489
           tmp.255
           tmp.400
           tmp.254
           tmp.399
           tmp.398
           tmp.253
           tmp.397
           tmp.72
           ra.396
           rbp
           r12))
         (tmp.397 (tmp.72 vector-init-loop.74 ra.396 rbp r12))
         (tmp.253 (tmp.398 r12 rbp ra.396 vector-init-loop.74 tmp.72))
         (tmp.398 (tmp.253 r12 rbp ra.396 vector-init-loop.74 tmp.72))
         (tmp.399 (tmp.72 vector-init-loop.74 ra.396 rbp r12))
         (tmp.254 (r12 rbp ra.396 vector-init-loop.74 tmp.72))
         (tmp.400 (tmp.72 vector-init-loop.74 ra.396 rbp r12))
         (tmp.255 (r12 rbp ra.396 vector-init-loop.74 tmp.72))
         (tmp.489 (tmp.256 r12 rbp ra.396 vector-init-loop.74 tmp.72))
         (tmp.256 (r12 tmp.489 rbp ra.396 vector-init-loop.74 tmp.72))
         (tmp.401 (tmp.72 vector-init-loop.74 ra.396 rbp))
         (tmp.125 (rbp ra.396 vector-init-loop.74 tmp.72))
         (tmp.73 (tmp.116 tmp.72 vector-init-loop.74 ra.396 rbp))
         (tmp.116 (tmp.73 tmp.72 ra.396 rbp))
         (rcx (r15 rdi rsi rdx tmp.72 vector-init-loop.74 ra.396 rbp))
         (rdx (r15 rdi rsi tmp.72 vector-init-loop.74 ra.396 rcx rbp))
         (r15 (rdi rsi rdx rcx rbp)))))
      (begin
        (set! ra.396 r15)
        (set! c.86 rdi)
        (set! tmp.72 rsi)
        (set! vector-init-loop.74 (mref c.86 14))
        (set! tmp.397 (arithmetic-shift-right tmp.72 3))
        (set! tmp.253 tmp.397)
        (set! tmp.398 1)
        (set! tmp.399 (+ tmp.398 tmp.253))
        (set! tmp.254 tmp.399)
        (set! tmp.400 (* tmp.254 8))
        (set! tmp.255 tmp.400)
        (set! tmp.489 tmp.255)
        (set! tmp.256 r12)
        (set! r12 (+ r12 tmp.489))
        (set! tmp.401 (+ tmp.256 3))
        (set! tmp.125 tmp.401)
        (mset! tmp.125 -3 tmp.72)
        (set! tmp.73 tmp.125)
        (set! tmp.116 vector-init-loop.74)
        (set! rcx tmp.73)
        (set! rdx 0)
        (set! rsi tmp.72)
        (set! rdi vector-init-loop.74)
        (set! r15 ra.396)
        (jump L.vector-init-loop.74.3 rbp r15 rcx rdx rsi rdi)))
    (define L.vector-init-loop.74.3
      ((new-frames ())
       (locals (c.85 ra.402 i.77 len.75 vector-init-loop.74 vec.76))
       (undead-out
        ((rdi rsi rdx rcx ra.402 rbp)
         (rsi rdx rcx c.85 ra.402 rbp)
         (rdx rcx c.85 len.75 ra.402 rbp)
         (rcx c.85 len.75 i.77 ra.402 rbp)
         (c.85 vec.76 len.75 i.77 ra.402 rbp)
         (vec.76 vector-init-loop.74 len.75 i.77 ra.402 rbp)
         ((vec.76 vector-init-loop.74 len.75 i.77 ra.402 rbp)
          ((vector-init-loop.74 len.75 i.77 ra.402 r8 rbp)
           (len.75 i.77 ra.402 rcx r8 rbp)
           (i.77 ra.402 rdx rcx r8 rbp)
           (ra.402 rsi rdx rcx r8 rbp)
           (ra.402 rdi rsi rdx rcx r8 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)
           (rdi rsi rdx rcx r8 r15 rbp))
          ((vector-init-loop.74 len.75 i.77 ra.402 r8 rbp)
           (len.75 i.77 ra.402 rcx r8 rbp)
           (i.77 ra.402 rdx rcx r8 rbp)
           (ra.402 rsi rdx rcx r8 rbp)
           (ra.402 rdi rsi rdx rcx r8 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)
           (rdi rsi rdx rcx r8 r15 rbp)))))
       (call-undead ())
       (conflicts
        ((r8 (r15 rdi rsi rdx rcx vector-init-loop.74 len.75 i.77 ra.402 rbp))
         (rbp
          (vector-init-loop.74
           vec.76
           i.77
           len.75
           c.85
           ra.402
           r15
           rdi
           rsi
           rdx
           rcx
           r8))
         (ra.402
          (vector-init-loop.74 vec.76 i.77 len.75 c.85 rbp rdi rsi rdx rcx r8))
         (i.77 (vector-init-loop.74 vec.76 c.85 len.75 ra.402 rbp rdx rcx r8))
         (len.75 (vector-init-loop.74 vec.76 i.77 rdx c.85 ra.402 rbp rcx r8))
         (vector-init-loop.74 (rbp ra.402 i.77 len.75 vec.76 r8))
         (rcx (c.85 r15 rdi rsi rdx len.75 i.77 ra.402 r8 rbp))
         (rdx (len.75 c.85 r15 rdi rsi i.77 ra.402 rcx r8 rbp))
         (rsi (c.85 r15 rdi ra.402 rdx rcx r8 rbp))
         (rdi (r15 ra.402 rsi rdx rcx r8 rbp))
         (r15 (rdi rsi rdx rcx r8 rbp))
         (c.85 (vec.76 i.77 len.75 rsi rdx rcx ra.402 rbp))
         (vec.76 (vector-init-loop.74 c.85 len.75 i.77 ra.402 rbp)))))
      (begin
        (set! ra.402 r15)
        (set! c.85 rdi)
        (set! len.75 rsi)
        (set! i.77 rdx)
        (set! vec.76 rcx)
        (set! vector-init-loop.74 (mref c.85 14))
        (if (eq? len.75 i.77)
          (begin
            (set! r8 vec.76)
            (set! rcx vector-init-loop.74)
            (set! rdx len.75)
            (set! rsi i.77)
            (set! rdi 14)
            (set! r15 ra.402)
            (jump L.jp.95 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 vec.76)
            (set! rcx vector-init-loop.74)
            (set! rdx len.75)
            (set! rsi i.77)
            (set! rdi 6)
            (set! r15 ra.402)
            (jump L.jp.95 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.unsafe-vector-set!.2.2
      ((new-frames ())
       (locals (c.84 tmp.270 ra.403 tmp.79 tmp.78 tmp.80))
       (undead-out
        ((rdi rsi rdx rcx ra.403 rbp)
         (rsi rdx rcx ra.403 rbp)
         (rdx rcx tmp.78 ra.403 rbp)
         (rcx tmp.78 tmp.79 ra.403 rbp)
         (tmp.80 tmp.78 tmp.79 ra.403 rbp)
         (tmp.270 tmp.80 tmp.78 tmp.79 ra.403 rbp)
         ((tmp.80 tmp.78 tmp.79 ra.403 rbp)
          ((tmp.78 tmp.79 ra.403 rcx rbp)
           (tmp.79 ra.403 rdx rcx rbp)
           (ra.403 rsi rdx rcx rbp)
           (ra.403 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp))
          ((tmp.78 tmp.79 ra.403 rcx rbp)
           (tmp.79 ra.403 rdx rcx rbp)
           (ra.403 rsi rdx rcx rbp)
           (ra.403 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rcx (c.84 r15 rdi rsi rdx tmp.78 tmp.79 ra.403 rbp))
         (rbp (tmp.270 tmp.80 tmp.79 tmp.78 c.84 ra.403 r15 rdi rsi rdx rcx))
         (ra.403 (tmp.270 tmp.80 tmp.79 tmp.78 c.84 rbp rdi rsi rdx rcx))
         (tmp.79 (tmp.270 tmp.80 tmp.78 ra.403 rbp rdx rcx))
         (tmp.78 (tmp.270 tmp.80 tmp.79 rdx ra.403 rbp rcx))
         (rdx (tmp.78 c.84 r15 rdi rsi tmp.79 ra.403 rcx rbp))
         (rsi (c.84 r15 rdi ra.403 rdx rcx rbp))
         (rdi (r15 ra.403 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (c.84 (rsi rdx rcx ra.403 rbp))
         (tmp.80 (tmp.270 tmp.78 tmp.79 ra.403 rbp))
         (tmp.270 (rbp ra.403 tmp.79 tmp.78 tmp.80)))))
      (begin
        (set! ra.403 r15)
        (set! c.84 rdi)
        (set! tmp.78 rsi)
        (set! tmp.79 rdx)
        (set! tmp.80 rcx)
        (set! tmp.270 (mref tmp.78 -3))
        (if (< tmp.79 tmp.270)
          (begin
            (set! rcx tmp.80)
            (set! rdx tmp.78)
            (set! rsi tmp.79)
            (set! rdi 14)
            (set! r15 ra.403)
            (jump L.jp.99 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx tmp.80)
            (set! rdx tmp.78)
            (set! rsi tmp.79)
            (set! rdi 6)
            (set! r15 ra.403)
            (jump L.jp.99 rbp r15 rcx rdx rsi rdi)))))
    (define L.unsafe-vector-ref.3.1
      ((new-frames ())
       (locals (c.83 tmp.278 ra.404 tmp.79 tmp.78))
       (undead-out
        ((rdi rsi rdx ra.404 rbp)
         (rsi rdx ra.404 rbp)
         (rdx tmp.78 ra.404 rbp)
         (tmp.78 tmp.79 ra.404 rbp)
         (tmp.278 tmp.78 tmp.79 ra.404 rbp)
         ((tmp.78 tmp.79 ra.404 rbp)
          ((tmp.79 ra.404 rdx rbp)
           (ra.404 rsi rdx rbp)
           (ra.404 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((tmp.79 ra.404 rdx rbp)
           (ra.404 rsi rdx rbp)
           (ra.404 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((rdx (tmp.78 c.83 r15 rdi rsi tmp.79 ra.404 rbp))
         (rbp (tmp.278 tmp.79 tmp.78 c.83 ra.404 r15 rdi rsi rdx))
         (ra.404 (tmp.278 tmp.79 tmp.78 c.83 rbp rdi rsi rdx))
         (tmp.79 (tmp.278 tmp.78 ra.404 rbp rdx))
         (rsi (c.83 r15 rdi ra.404 rdx rbp))
         (rdi (r15 ra.404 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (c.83 (rsi rdx ra.404 rbp))
         (tmp.78 (tmp.278 tmp.79 rdx ra.404 rbp))
         (tmp.278 (rbp ra.404 tmp.79 tmp.78)))))
      (begin
        (set! ra.404 r15)
        (set! c.83 rdi)
        (set! tmp.78 rsi)
        (set! tmp.79 rdx)
        (set! tmp.278 (mref tmp.78 -3))
        (if (< tmp.79 tmp.278)
          (begin
            (set! rdx tmp.78)
            (set! rsi tmp.79)
            (set! rdi 14)
            (set! r15 ra.404)
            (jump L.jp.103 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.78)
            (set! rsi tmp.79)
            (set! rdi 6)
            (set! r15 ra.404)
            (jump L.jp.103 rbp r15 rdx rsi rdi)))))
    (define L.jp.103
      ((new-frames ())
       (locals (tmp.272 ra.405 tmp.79 tmp.78))
       (undead-out
        ((rdi rsi rdx ra.405 rbp)
         (rsi rdx tmp.272 ra.405 rbp)
         (rdx tmp.272 tmp.79 ra.405 rbp)
         (tmp.272 tmp.78 tmp.79 ra.405 rbp)
         ((tmp.78 tmp.79 ra.405 rbp)
          ((tmp.78 tmp.79 ra.405 rbp)
           ((tmp.79 ra.405 rdx rbp)
            (ra.405 rsi rdx rbp)
            (ra.405 rdi rsi rdx rbp)
            (rdi rsi rdx r15 rbp)
            (rdi rsi rdx r15 rbp))
           ((tmp.79 ra.405 rdx rbp)
            (ra.405 rsi rdx rbp)
            (ra.405 rdi rsi rdx rbp)
            (rdi rsi rdx r15 rbp)
            (rdi rsi rdx r15 rbp)))
          ((ra.405 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.405 rbp))
         (rbp (tmp.78 tmp.79 tmp.272 ra.405 r15 rdi rsi rdx rax))
         (ra.405 (tmp.78 tmp.79 tmp.272 rbp rdi rsi rdx rax))
         (rdx (tmp.272 r15 rdi rsi tmp.79 ra.405 rbp))
         (tmp.79 (tmp.78 tmp.272 ra.405 rbp rdx))
         (rsi (tmp.272 r15 rdi ra.405 rdx rbp))
         (rdi (r15 ra.405 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.272 (tmp.78 tmp.79 rsi rdx ra.405 rbp))
         (tmp.78 (tmp.272 tmp.79 ra.405 rbp)))))
      (begin
        (set! ra.405 r15)
        (set! tmp.272 rdi)
        (set! tmp.79 rsi)
        (set! tmp.78 rdx)
        (if (neq? tmp.272 6)
          (if (>= tmp.79 0)
            (begin
              (set! rdx tmp.78)
              (set! rsi tmp.79)
              (set! rdi 14)
              (set! r15 ra.405)
              (jump L.jp.102 rbp r15 rdx rsi rdi))
            (begin
              (set! rdx tmp.78)
              (set! rsi tmp.79)
              (set! rdi 6)
              (set! r15 ra.405)
              (jump L.jp.102 rbp r15 rdx rsi rdi)))
          (begin (set! rax 2622) (jump ra.405 rbp rax)))))
    (define L.jp.102
      ((new-frames ())
       (locals
        (ra.406
         tmp.274
         tmp.78
         tmp.277
         tmp.409
         tmp.276
         tmp.408
         tmp.275
         tmp.407
         tmp.79))
       (undead-out
        ((rdi rsi rdx ra.406 rbp)
         (rsi rdx tmp.274 ra.406 rbp)
         (rdx tmp.274 tmp.79 ra.406 rbp)
         (tmp.274 tmp.79 tmp.78 ra.406 rbp)
         ((tmp.79 tmp.78 ra.406 rbp)
          ((tmp.407 tmp.78 ra.406 rbp)
           (tmp.275 tmp.78 ra.406 rbp)
           (tmp.408 tmp.78 ra.406 rbp)
           (tmp.276 tmp.78 ra.406 rbp)
           (tmp.409 tmp.78 ra.406 rbp)
           (tmp.277 tmp.78 ra.406 rbp)
           (ra.406 rax rbp)
           (rax rbp))
          ((ra.406 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.406 rbp))
         (rbp
          (tmp.78
           tmp.79
           tmp.274
           ra.406
           tmp.277
           tmp.409
           tmp.276
           tmp.408
           tmp.275
           tmp.407
           rax))
         (ra.406
          (tmp.78
           tmp.79
           tmp.274
           rdi
           rsi
           rdx
           rbp
           tmp.277
           tmp.409
           tmp.276
           tmp.408
           tmp.275
           tmp.407
           rax))
         (tmp.407 (rbp ra.406 tmp.78))
         (tmp.78
          (tmp.274
           tmp.79
           ra.406
           rbp
           tmp.277
           tmp.409
           tmp.276
           tmp.408
           tmp.275
           tmp.407))
         (tmp.275 (tmp.78 ra.406 rbp))
         (tmp.408 (rbp ra.406 tmp.78))
         (tmp.276 (tmp.78 ra.406 rbp))
         (tmp.409 (rbp ra.406 tmp.78))
         (tmp.277 (tmp.78 ra.406 rbp))
         (rdx (tmp.79 tmp.274 ra.406))
         (rsi (tmp.274 ra.406))
         (rdi (ra.406))
         (tmp.274 (tmp.78 tmp.79 rsi rdx ra.406 rbp))
         (tmp.79 (tmp.78 rdx tmp.274 ra.406 rbp)))))
      (begin
        (set! ra.406 r15)
        (set! tmp.274 rdi)
        (set! tmp.79 rsi)
        (set! tmp.78 rdx)
        (if (neq? tmp.274 6)
          (begin
            (set! tmp.407 (arithmetic-shift-right tmp.79 3))
            (set! tmp.275 tmp.407)
            (set! tmp.408 (* tmp.275 8))
            (set! tmp.276 tmp.408)
            (set! tmp.409 (+ tmp.276 5))
            (set! tmp.277 tmp.409)
            (set! rax (mref tmp.78 tmp.277))
            (jump ra.406 rbp rax))
          (begin (set! rax 2622) (jump ra.406 rbp rax)))))
    (define L.jp.99
      ((new-frames ())
       (locals (tmp.264 ra.410 tmp.79 tmp.80 tmp.78))
       (undead-out
        ((rdi rsi rdx rcx ra.410 rbp)
         (rsi rdx rcx tmp.264 ra.410 rbp)
         (rdx rcx tmp.264 tmp.79 ra.410 rbp)
         (rcx tmp.264 tmp.78 tmp.79 ra.410 rbp)
         (tmp.264 tmp.78 tmp.80 tmp.79 ra.410 rbp)
         ((tmp.78 tmp.80 tmp.79 ra.410 rbp)
          ((tmp.78 tmp.80 tmp.79 ra.410 rbp)
           ((tmp.80 tmp.79 ra.410 rcx rbp)
            (tmp.79 ra.410 rdx rcx rbp)
            (ra.410 rsi rdx rcx rbp)
            (ra.410 rdi rsi rdx rcx rbp)
            (rdi rsi rdx rcx r15 rbp)
            (rdi rsi rdx rcx r15 rbp))
           ((tmp.80 tmp.79 ra.410 rcx rbp)
            (tmp.79 ra.410 rdx rcx rbp)
            (ra.410 rsi rdx rcx rbp)
            (ra.410 rdi rsi rdx rcx rbp)
            (rdi rsi rdx rcx r15 rbp)
            (rdi rsi rdx rcx r15 rbp)))
          ((ra.410 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.410 rbp))
         (rbp (tmp.80 tmp.78 tmp.79 tmp.264 ra.410 r15 rdi rsi rdx rcx rax))
         (ra.410 (tmp.80 tmp.78 tmp.79 tmp.264 rbp rdi rsi rdx rcx rax))
         (rcx (tmp.78 tmp.264 r15 rdi rsi rdx tmp.80 tmp.79 ra.410 rbp))
         (tmp.79 (tmp.80 tmp.78 tmp.264 ra.410 rbp rdx rcx))
         (tmp.80 (tmp.264 tmp.78 tmp.79 ra.410 rbp rcx))
         (rdx (tmp.264 r15 rdi rsi tmp.79 ra.410 rcx rbp))
         (rsi (tmp.264 r15 rdi ra.410 rdx rcx rbp))
         (rdi (r15 ra.410 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (tmp.264 (tmp.80 tmp.78 tmp.79 rsi rdx rcx ra.410 rbp))
         (tmp.78 (tmp.80 rcx tmp.264 tmp.79 ra.410 rbp)))))
      (begin
        (set! ra.410 r15)
        (set! tmp.264 rdi)
        (set! tmp.79 rsi)
        (set! tmp.78 rdx)
        (set! tmp.80 rcx)
        (if (neq? tmp.264 6)
          (if (>= tmp.79 0)
            (begin
              (set! rcx tmp.78)
              (set! rdx tmp.80)
              (set! rsi tmp.79)
              (set! rdi 14)
              (set! r15 ra.410)
              (jump L.jp.98 rbp r15 rcx rdx rsi rdi))
            (begin
              (set! rcx tmp.78)
              (set! rdx tmp.80)
              (set! rsi tmp.79)
              (set! rdi 6)
              (set! r15 ra.410)
              (jump L.jp.98 rbp r15 rcx rdx rsi rdi)))
          (begin (set! rax 2366) (jump ra.410 rbp rax)))))
    (define L.jp.98
      ((new-frames ())
       (locals
        (ra.411
         tmp.266
         tmp.78
         tmp.80
         tmp.269
         tmp.414
         tmp.268
         tmp.413
         tmp.267
         tmp.412
         tmp.79))
       (undead-out
        ((rdi rsi rdx rcx rbp ra.411)
         (rsi rdx rcx tmp.266 rbp ra.411)
         (rdx rcx tmp.266 tmp.79 rbp ra.411)
         (rcx tmp.266 tmp.79 rbp ra.411 tmp.80)
         (tmp.266 tmp.79 rbp ra.411 tmp.80 tmp.78)
         ((tmp.79 rbp ra.411 tmp.80 tmp.78)
          ((tmp.412 rbp ra.411 tmp.80 tmp.78)
           (tmp.267 rbp ra.411 tmp.80 tmp.78)
           (tmp.413 rbp ra.411 tmp.80 tmp.78)
           (tmp.268 rbp ra.411 tmp.80 tmp.78)
           (tmp.414 rbp ra.411 tmp.80 tmp.78)
           (rbp ra.411 tmp.80 tmp.269 tmp.78)
           (tmp.78 ra.411 rbp)
           (ra.411 rax rbp)
           (rax rbp))
          ((ra.411 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.411 rbp))
         (rbp
          (tmp.78
           tmp.80
           tmp.79
           tmp.266
           ra.411
           tmp.269
           tmp.414
           tmp.268
           tmp.413
           tmp.267
           tmp.412
           rax))
         (ra.411
          (tmp.78
           tmp.80
           tmp.79
           tmp.266
           rdi
           rsi
           rdx
           rcx
           rbp
           tmp.269
           tmp.414
           tmp.268
           tmp.413
           tmp.267
           tmp.412
           rax))
         (tmp.412 (tmp.78 tmp.80 ra.411 rbp))
         (tmp.80
          (tmp.78
           rcx
           tmp.266
           tmp.79
           rbp
           ra.411
           tmp.269
           tmp.414
           tmp.268
           tmp.413
           tmp.267
           tmp.412))
         (tmp.78
          (tmp.266
           tmp.79
           rbp
           ra.411
           tmp.80
           tmp.269
           tmp.414
           tmp.268
           tmp.413
           tmp.267
           tmp.412))
         (tmp.267 (rbp ra.411 tmp.80 tmp.78))
         (tmp.413 (tmp.78 tmp.80 ra.411 rbp))
         (tmp.268 (rbp ra.411 tmp.80 tmp.78))
         (tmp.414 (tmp.78 tmp.80 ra.411 rbp))
         (tmp.269 (rbp ra.411 tmp.80 tmp.78))
         (rcx (tmp.80 tmp.79 tmp.266 ra.411))
         (rdx (tmp.79 tmp.266 ra.411))
         (rsi (tmp.266 ra.411))
         (rdi (ra.411))
         (tmp.266 (tmp.78 tmp.80 tmp.79 rsi rdx rcx rbp ra.411))
         (tmp.79 (tmp.78 tmp.80 rdx rcx tmp.266 rbp ra.411)))))
      (begin
        (set! ra.411 r15)
        (set! tmp.266 rdi)
        (set! tmp.79 rsi)
        (set! tmp.80 rdx)
        (set! tmp.78 rcx)
        (if (neq? tmp.266 6)
          (begin
            (set! tmp.412 (arithmetic-shift-right tmp.79 3))
            (set! tmp.267 tmp.412)
            (set! tmp.413 (* tmp.267 8))
            (set! tmp.268 tmp.413)
            (set! tmp.414 (+ tmp.268 5))
            (set! tmp.269 tmp.414)
            (mset! tmp.78 tmp.269 tmp.80)
            (set! rax tmp.78)
            (jump ra.411 rbp rax))
          (begin (set! rax 2366) (jump ra.411 rbp rax)))))
    (define L.jp.95
      ((new-frames ())
       (locals
        (tmp.258
         i.77
         tmp.416
         tmp.259
         tmp.417
         tmp.260
         tmp.418
         tmp.261
         vector-init-loop.74
         tmp.115
         tmp.419
         tmp.262
         len.75
         ra.415
         vec.76))
       (undead-out
        ((rdi rsi rdx rcx r8 ra.415 rbp)
         (rsi rdx rcx r8 tmp.258 ra.415 rbp)
         (rdx rcx r8 tmp.258 i.77 ra.415 rbp)
         (rcx r8 tmp.258 i.77 len.75 ra.415 rbp)
         (r8 tmp.258 i.77 len.75 vector-init-loop.74 ra.415 rbp)
         (tmp.258 i.77 len.75 vector-init-loop.74 vec.76 ra.415 rbp)
         ((i.77 len.75 vector-init-loop.74 vec.76 ra.415 rbp)
          ((ra.415 rax rbp) (rax rbp))
          ((tmp.416 rbp ra.415 vector-init-loop.74 len.75 i.77 vec.76)
           (tmp.259 rbp ra.415 vector-init-loop.74 len.75 i.77 vec.76)
           (tmp.417 rbp ra.415 vector-init-loop.74 len.75 i.77 vec.76)
           (tmp.260 rbp ra.415 vector-init-loop.74 len.75 i.77 vec.76)
           (tmp.418 rbp ra.415 vector-init-loop.74 len.75 i.77 vec.76)
           (rbp ra.415 vector-init-loop.74 len.75 i.77 tmp.261 vec.76)
           (i.77 vec.76 len.75 vector-init-loop.74 ra.415 rbp)
           (i.77 vec.76 len.75 vector-init-loop.74 ra.415 rbp)
           (tmp.419 vec.76 len.75 vector-init-loop.74 ra.415 rbp)
           (vec.76 tmp.262 len.75 vector-init-loop.74 ra.415 rbp)
           (tmp.262 len.75 vector-init-loop.74 ra.415 rcx rbp)
           (len.75 vector-init-loop.74 ra.415 rdx rcx rbp)
           (vector-init-loop.74 ra.415 rsi rdx rcx rbp)
           (ra.415 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp)))))
       (call-undead ())
       (conflicts
        ((tmp.416 (vec.76 i.77 len.75 vector-init-loop.74 ra.415 rbp))
         (rbp
          (vec.76
           vector-init-loop.74
           len.75
           i.77
           tmp.258
           ra.415
           rax
           r15
           rdi
           rsi
           rdx
           rcx
           tmp.262
           tmp.419
           tmp.115
           tmp.261
           tmp.418
           tmp.260
           tmp.417
           tmp.259
           tmp.416))
         (ra.415
          (vec.76
           vector-init-loop.74
           len.75
           i.77
           tmp.258
           r8
           rbp
           rax
           rdi
           rsi
           rdx
           rcx
           tmp.262
           tmp.419
           tmp.115
           tmp.261
           tmp.418
           tmp.260
           tmp.417
           tmp.259
           tmp.416))
         (vector-init-loop.74
          (vec.76
           r8
           tmp.258
           i.77
           len.75
           ra.415
           rbp
           rsi
           rdx
           rcx
           tmp.262
           tmp.419
           tmp.261
           tmp.418
           tmp.260
           tmp.417
           tmp.259
           tmp.416))
         (len.75
          (vec.76
           vector-init-loop.74
           r8
           tmp.258
           i.77
           ra.415
           rbp
           rdx
           rcx
           tmp.262
           tmp.419
           tmp.115
           tmp.261
           tmp.418
           tmp.260
           tmp.417
           tmp.259
           tmp.416))
         (i.77
          (vec.76
           vector-init-loop.74
           len.75
           rdx
           rcx
           r8
           tmp.258
           ra.415
           rbp
           tmp.115
           tmp.261
           tmp.418
           tmp.260
           tmp.417
           tmp.259
           tmp.416))
         (vec.76
          (tmp.258
           i.77
           len.75
           vector-init-loop.74
           ra.415
           rbp
           tmp.262
           tmp.419
           tmp.115
           tmp.261
           tmp.418
           tmp.260
           tmp.417
           tmp.259
           tmp.416))
         (tmp.259 (rbp ra.415 vector-init-loop.74 len.75 i.77 vec.76))
         (tmp.417 (vec.76 i.77 len.75 vector-init-loop.74 ra.415 rbp))
         (tmp.260 (rbp ra.415 vector-init-loop.74 len.75 i.77 vec.76))
         (tmp.418 (vec.76 i.77 len.75 vector-init-loop.74 ra.415 rbp))
         (tmp.261 (rbp ra.415 vector-init-loop.74 len.75 i.77 vec.76))
         (tmp.115 (i.77 vec.76 len.75 ra.415 rbp))
         (tmp.419 (rbp ra.415 vector-init-loop.74 len.75 vec.76))
         (tmp.262 (rcx vec.76 len.75 vector-init-loop.74 ra.415 rbp))
         (rcx
          (i.77
           tmp.258
           r15
           rdi
           rsi
           rdx
           tmp.262
           len.75
           vector-init-loop.74
           ra.415
           rbp))
         (rdx
          (i.77 tmp.258 r15 rdi rsi len.75 vector-init-loop.74 ra.415 rcx rbp))
         (rsi (tmp.258 r15 rdi vector-init-loop.74 ra.415 rdx rcx rbp))
         (rdi (r15 ra.415 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (rax (ra.415 rbp))
         (r8 (vector-init-loop.74 len.75 i.77 tmp.258 ra.415))
         (tmp.258
          (vec.76
           vector-init-loop.74
           len.75
           i.77
           rsi
           rdx
           rcx
           r8
           ra.415
           rbp)))))
      (begin
        (set! ra.415 r15)
        (set! tmp.258 rdi)
        (set! i.77 rsi)
        (set! len.75 rdx)
        (set! vector-init-loop.74 rcx)
        (set! vec.76 r8)
        (if (neq? tmp.258 6)
          (begin (set! rax vec.76) (jump ra.415 rbp rax))
          (begin
            (set! tmp.416 (arithmetic-shift-right i.77 3))
            (set! tmp.259 tmp.416)
            (set! tmp.417 (* tmp.259 8))
            (set! tmp.260 tmp.417)
            (set! tmp.418 (+ tmp.260 5))
            (set! tmp.261 tmp.418)
            (mset! vec.76 tmp.261 0)
            (set! tmp.115 vector-init-loop.74)
            (set! tmp.419 (+ i.77 8))
            (set! tmp.262 tmp.419)
            (set! rcx vec.76)
            (set! rdx tmp.262)
            (set! rsi len.75)
            (set! rdi vector-init-loop.74)
            (set! r15 ra.415)
            (jump L.vector-init-loop.74.3 rbp r15 rcx rdx rsi rdi)))))
    (define L.jp.82
      ((new-frames ())
       (locals (ra.420 tmp.230 tmp.31))
       (undead-out
        ((rdi rsi ra.420 rbp)
         (rsi tmp.230 ra.420 rbp)
         (tmp.230 tmp.31 ra.420 rbp)
         ((tmp.31 ra.420 rbp)
          ((ra.420 rax rbp) (rax rbp))
          ((ra.420 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.420 rbp))
         (rbp (tmp.31 tmp.230 ra.420 rax))
         (ra.420 (tmp.31 tmp.230 rdi rsi rbp rax))
         (rsi (tmp.230 ra.420))
         (rdi (ra.420))
         (tmp.230 (tmp.31 rsi ra.420 rbp))
         (tmp.31 (tmp.230 ra.420 rbp)))))
      (begin
        (set! ra.420 r15)
        (set! tmp.230 rdi)
        (set! tmp.31 rsi)
        (if (neq? tmp.230 6)
          (begin (set! rax (mref tmp.31 6)) (jump ra.420 rbp rax))
          (begin (set! rax 3390) (jump ra.420 rbp rax)))))
    (define L.jp.80
      ((new-frames ())
       (locals (ra.421 tmp.227 tmp.30))
       (undead-out
        ((rdi rsi ra.421 rbp)
         (rsi tmp.227 ra.421 rbp)
         (tmp.227 tmp.30 ra.421 rbp)
         ((tmp.30 ra.421 rbp)
          ((ra.421 rax rbp) (rax rbp))
          ((ra.421 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.421 rbp))
         (rbp (tmp.30 tmp.227 ra.421 rax))
         (ra.421 (tmp.30 tmp.227 rdi rsi rbp rax))
         (rsi (tmp.227 ra.421))
         (rdi (ra.421))
         (tmp.227 (tmp.30 rsi ra.421 rbp))
         (tmp.30 (tmp.227 ra.421 rbp)))))
      (begin
        (set! ra.421 r15)
        (set! tmp.227 rdi)
        (set! tmp.30 rsi)
        (if (neq? tmp.227 6)
          (begin (set! rax (mref tmp.30 7)) (jump ra.421 rbp rax))
          (begin (set! rax 3134) (jump ra.421 rbp rax)))))
    (define L.jp.78
      ((new-frames ())
       (locals (ra.422 tmp.224 tmp.29))
       (undead-out
        ((rdi rsi ra.422 rbp)
         (rsi tmp.224 ra.422 rbp)
         (tmp.224 tmp.29 ra.422 rbp)
         ((tmp.29 ra.422 rbp)
          ((ra.422 rax rbp) (rax rbp))
          ((ra.422 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.422 rbp))
         (rbp (tmp.29 tmp.224 ra.422 rax))
         (ra.422 (tmp.29 tmp.224 rdi rsi rbp rax))
         (rsi (tmp.224 ra.422))
         (rdi (ra.422))
         (tmp.224 (tmp.29 rsi ra.422 rbp))
         (tmp.29 (tmp.224 ra.422 rbp)))))
      (begin
        (set! ra.422 r15)
        (set! tmp.224 rdi)
        (set! tmp.29 rsi)
        (if (neq? tmp.224 6)
          (begin (set! rax (mref tmp.29 -1)) (jump ra.422 rbp rax))
          (begin (set! rax 2878) (jump ra.422 rbp rax)))))
    (define L.jp.76
      ((new-frames ())
       (locals
        (tmp.218 tmp.424 tmp.221 ra.423 unsafe-vector-ref.3 tmp.28 tmp.27))
       (undead-out
        ((rdi rsi rdx rcx ra.423 rbp)
         (rsi rdx rcx tmp.218 ra.423 rbp)
         (rdx rcx tmp.218 tmp.27 ra.423 rbp)
         (rcx tmp.218 tmp.27 unsafe-vector-ref.3 ra.423 rbp)
         (tmp.218 tmp.27 tmp.28 unsafe-vector-ref.3 ra.423 rbp)
         ((tmp.27 tmp.28 unsafe-vector-ref.3 ra.423 rbp)
          ((tmp.424 tmp.27 tmp.28 unsafe-vector-ref.3 ra.423 rbp)
           (tmp.221 tmp.27 tmp.28 unsafe-vector-ref.3 ra.423 rbp)
           ((tmp.27 tmp.28 unsafe-vector-ref.3 ra.423 rbp)
            ((tmp.28 unsafe-vector-ref.3 ra.423 rcx rbp)
             (unsafe-vector-ref.3 ra.423 rdx rcx rbp)
             (ra.423 rsi rdx rcx rbp)
             (ra.423 rdi rsi rdx rcx rbp)
             (rdi rsi rdx rcx r15 rbp)
             (rdi rsi rdx rcx r15 rbp))
            ((tmp.28 unsafe-vector-ref.3 ra.423 rcx rbp)
             (unsafe-vector-ref.3 ra.423 rdx rcx rbp)
             (ra.423 rsi rdx rcx rbp)
             (ra.423 rdi rsi rdx rcx rbp)
             (rdi rsi rdx rcx r15 rbp)
             (rdi rsi rdx rcx r15 rbp))))
          ((ra.423 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.423 rbp))
         (rbp
          (tmp.28
           unsafe-vector-ref.3
           tmp.27
           tmp.218
           ra.423
           tmp.221
           tmp.424
           r15
           rdi
           rsi
           rdx
           rcx
           rax))
         (ra.423
          (tmp.28
           unsafe-vector-ref.3
           tmp.27
           tmp.218
           rbp
           tmp.221
           tmp.424
           rdi
           rsi
           rdx
           rcx
           rax))
         (rcx
          (tmp.27
           tmp.218
           r15
           rdi
           rsi
           rdx
           tmp.28
           unsafe-vector-ref.3
           ra.423
           rbp))
         (unsafe-vector-ref.3
          (tmp.28 tmp.218 tmp.27 ra.423 rbp tmp.221 tmp.424 rdx rcx))
         (tmp.28
          (tmp.218 tmp.27 unsafe-vector-ref.3 ra.423 rbp tmp.221 tmp.424 rcx))
         (rdx (tmp.27 tmp.218 r15 rdi rsi unsafe-vector-ref.3 ra.423 rcx rbp))
         (rsi (tmp.218 r15 rdi ra.423 rdx rcx rbp))
         (rdi (r15 ra.423 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (tmp.424 (rbp ra.423 unsafe-vector-ref.3 tmp.28 tmp.27))
         (tmp.27
          (tmp.28
           unsafe-vector-ref.3
           rdx
           rcx
           tmp.218
           ra.423
           rbp
           tmp.221
           tmp.424))
         (tmp.221 (tmp.27 tmp.28 unsafe-vector-ref.3 ra.423 rbp))
         (tmp.218
          (tmp.28 unsafe-vector-ref.3 tmp.27 rsi rdx rcx ra.423 rbp)))))
      (begin
        (set! ra.423 r15)
        (set! tmp.218 rdi)
        (set! tmp.27 rsi)
        (set! unsafe-vector-ref.3 rdx)
        (set! tmp.28 rcx)
        (if (neq? tmp.218 6)
          (begin
            (set! tmp.424 (bitwise-and tmp.27 7))
            (set! tmp.221 tmp.424)
            (if (eq? tmp.221 3)
              (begin
                (set! rcx tmp.27)
                (set! rdx tmp.28)
                (set! rsi unsafe-vector-ref.3)
                (set! rdi 14)
                (set! r15 ra.423)
                (jump L.jp.75 rbp r15 rcx rdx rsi rdi))
              (begin
                (set! rcx tmp.27)
                (set! rdx tmp.28)
                (set! rsi unsafe-vector-ref.3)
                (set! rdi 6)
                (set! r15 ra.423)
                (jump L.jp.75 rbp r15 rcx rdx rsi rdi))))
          (begin (set! rax 2622) (jump ra.423 rbp rax)))))
    (define L.jp.75
      ((new-frames ())
       (locals (tmp.220 ra.425 tmp.27 tmp.28 tmp.117 unsafe-vector-ref.3))
       (undead-out
        ((rdi rsi rdx rcx ra.425 rbp)
         (rsi rdx rcx tmp.220 ra.425 rbp)
         (rdx rcx tmp.220 unsafe-vector-ref.3 ra.425 rbp)
         (rcx tmp.220 tmp.28 unsafe-vector-ref.3 ra.425 rbp)
         (tmp.220 tmp.28 tmp.27 unsafe-vector-ref.3 ra.425 rbp)
         ((tmp.28 tmp.27 unsafe-vector-ref.3 ra.425 rbp)
          ((tmp.28 tmp.27 unsafe-vector-ref.3 ra.425 rbp)
           (tmp.27 unsafe-vector-ref.3 ra.425 rdx rbp)
           (unsafe-vector-ref.3 ra.425 rsi rdx rbp)
           (ra.425 rdi rsi rdx rbp)
           (rdi rsi rdx r15 rbp)
           (rdi rsi rdx r15 rbp))
          ((ra.425 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.425 rbp))
         (rbp
          (tmp.27
           tmp.28
           unsafe-vector-ref.3
           tmp.220
           ra.425
           r15
           rdi
           rsi
           rdx
           tmp.117
           rax))
         (ra.425
          (tmp.27
           tmp.28
           unsafe-vector-ref.3
           tmp.220
           rcx
           rbp
           rdi
           rsi
           rdx
           tmp.117
           rax))
         (tmp.117 (tmp.28 tmp.27 ra.425 rbp))
         (tmp.27 (tmp.220 tmp.28 unsafe-vector-ref.3 ra.425 rbp rdx tmp.117))
         (tmp.28 (tmp.27 rcx tmp.220 unsafe-vector-ref.3 ra.425 rbp tmp.117))
         (rdx (tmp.220 r15 rdi rsi tmp.27 unsafe-vector-ref.3 ra.425 rbp))
         (unsafe-vector-ref.3 (tmp.27 tmp.28 rcx tmp.220 ra.425 rbp rsi rdx))
         (rsi (tmp.220 r15 rdi unsafe-vector-ref.3 ra.425 rdx rbp))
         (rdi (r15 ra.425 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (rcx (tmp.28 unsafe-vector-ref.3 tmp.220 ra.425))
         (tmp.220
          (tmp.27 tmp.28 unsafe-vector-ref.3 rsi rdx rcx ra.425 rbp)))))
      (begin
        (set! ra.425 r15)
        (set! tmp.220 rdi)
        (set! unsafe-vector-ref.3 rsi)
        (set! tmp.28 rdx)
        (set! tmp.27 rcx)
        (if (neq? tmp.220 6)
          (begin
            (set! tmp.117 unsafe-vector-ref.3)
            (set! rdx tmp.28)
            (set! rsi tmp.27)
            (set! rdi unsafe-vector-ref.3)
            (set! r15 ra.425)
            (jump L.unsafe-vector-ref.3.1 rbp r15 rdx rsi rdi))
          (begin (set! rax 2622) (jump ra.425 rbp rax)))))
    (define L.jp.72
      ((new-frames ())
       (locals
        (tmp.212
         tmp.427
         tmp.215
         ra.426
         unsafe-vector-set!.2
         tmp.26
         tmp.25
         tmp.24))
       (undead-out
        ((rdi rsi rdx rcx r8 ra.426 rbp)
         (rsi rdx rcx r8 tmp.212 ra.426 rbp)
         (rdx rcx r8 tmp.212 tmp.24 ra.426 rbp)
         (rcx r8 tmp.212 tmp.24 unsafe-vector-set!.2 ra.426 rbp)
         (r8 tmp.212 tmp.24 tmp.26 unsafe-vector-set!.2 ra.426 rbp)
         (tmp.212 tmp.24 tmp.25 tmp.26 unsafe-vector-set!.2 ra.426 rbp)
         ((tmp.24 tmp.25 tmp.26 unsafe-vector-set!.2 ra.426 rbp)
          ((tmp.427 tmp.24 tmp.25 tmp.26 unsafe-vector-set!.2 ra.426 rbp)
           (tmp.215 tmp.24 tmp.25 tmp.26 unsafe-vector-set!.2 ra.426 rbp)
           ((tmp.24 tmp.25 tmp.26 unsafe-vector-set!.2 ra.426 rbp)
            ((tmp.25 tmp.26 unsafe-vector-set!.2 ra.426 r8 rbp)
             (tmp.26 unsafe-vector-set!.2 ra.426 rcx r8 rbp)
             (unsafe-vector-set!.2 ra.426 rdx rcx r8 rbp)
             (ra.426 rsi rdx rcx r8 rbp)
             (ra.426 rdi rsi rdx rcx r8 rbp)
             (rdi rsi rdx rcx r8 r15 rbp)
             (rdi rsi rdx rcx r8 r15 rbp))
            ((tmp.25 tmp.26 unsafe-vector-set!.2 ra.426 r8 rbp)
             (tmp.26 unsafe-vector-set!.2 ra.426 rcx r8 rbp)
             (unsafe-vector-set!.2 ra.426 rdx rcx r8 rbp)
             (ra.426 rsi rdx rcx r8 rbp)
             (ra.426 rdi rsi rdx rcx r8 rbp)
             (rdi rsi rdx rcx r8 r15 rbp)
             (rdi rsi rdx rcx r8 r15 rbp))))
          ((ra.426 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.426 rbp))
         (rbp
          (tmp.25
           tmp.26
           unsafe-vector-set!.2
           tmp.24
           tmp.212
           ra.426
           tmp.215
           tmp.427
           r15
           rdi
           rsi
           rdx
           rcx
           r8
           rax))
         (ra.426
          (tmp.25
           tmp.26
           unsafe-vector-set!.2
           tmp.24
           tmp.212
           rbp
           tmp.215
           tmp.427
           rdi
           rsi
           rdx
           rcx
           r8
           rax))
         (r8
          (tmp.24
           tmp.212
           r15
           rdi
           rsi
           rdx
           rcx
           tmp.25
           tmp.26
           unsafe-vector-set!.2
           ra.426
           rbp))
         (unsafe-vector-set!.2
          (tmp.25 tmp.26 tmp.212 tmp.24 ra.426 rbp tmp.215 tmp.427 rdx rcx r8))
         (tmp.26
          (tmp.25
           tmp.212
           tmp.24
           unsafe-vector-set!.2
           ra.426
           rbp
           tmp.215
           tmp.427
           rcx
           r8))
         (tmp.25
          (tmp.212
           tmp.24
           tmp.26
           unsafe-vector-set!.2
           ra.426
           rbp
           tmp.215
           tmp.427
           r8))
         (rcx
          (tmp.24
           tmp.212
           r15
           rdi
           rsi
           rdx
           tmp.26
           unsafe-vector-set!.2
           ra.426
           r8
           rbp))
         (rdx
          (tmp.24 tmp.212 r15 rdi rsi unsafe-vector-set!.2 ra.426 rcx r8 rbp))
         (rsi (tmp.212 r15 rdi ra.426 rdx rcx r8 rbp))
         (rdi (r15 ra.426 rsi rdx rcx r8 rbp))
         (r15 (rdi rsi rdx rcx r8 rbp))
         (tmp.427 (rbp ra.426 unsafe-vector-set!.2 tmp.26 tmp.25 tmp.24))
         (tmp.24
          (tmp.25
           tmp.26
           unsafe-vector-set!.2
           rdx
           rcx
           r8
           tmp.212
           ra.426
           rbp
           tmp.215
           tmp.427))
         (tmp.215 (tmp.24 tmp.25 tmp.26 unsafe-vector-set!.2 ra.426 rbp))
         (tmp.212
          (tmp.25
           tmp.26
           unsafe-vector-set!.2
           tmp.24
           rsi
           rdx
           rcx
           r8
           ra.426
           rbp)))))
      (begin
        (set! ra.426 r15)
        (set! tmp.212 rdi)
        (set! tmp.24 rsi)
        (set! unsafe-vector-set!.2 rdx)
        (set! tmp.26 rcx)
        (set! tmp.25 r8)
        (if (neq? tmp.212 6)
          (begin
            (set! tmp.427 (bitwise-and tmp.24 7))
            (set! tmp.215 tmp.427)
            (if (eq? tmp.215 3)
              (begin
                (set! r8 tmp.24)
                (set! rcx tmp.25)
                (set! rdx tmp.26)
                (set! rsi unsafe-vector-set!.2)
                (set! rdi 14)
                (set! r15 ra.426)
                (jump L.jp.71 rbp r15 r8 rcx rdx rsi rdi))
              (begin
                (set! r8 tmp.24)
                (set! rcx tmp.25)
                (set! rdx tmp.26)
                (set! rsi unsafe-vector-set!.2)
                (set! rdi 6)
                (set! r15 ra.426)
                (jump L.jp.71 rbp r15 r8 rcx rdx rsi rdi))))
          (begin (set! rax 2366) (jump ra.426 rbp rax)))))
    (define L.jp.71
      ((new-frames ())
       (locals
        (tmp.214 ra.428 tmp.24 tmp.25 tmp.26 tmp.118 unsafe-vector-set!.2))
       (undead-out
        ((rdi rsi rdx rcx r8 ra.428 rbp)
         (rsi rdx rcx r8 tmp.214 ra.428 rbp)
         (rdx rcx r8 tmp.214 unsafe-vector-set!.2 ra.428 rbp)
         (rcx r8 tmp.214 tmp.26 unsafe-vector-set!.2 ra.428 rbp)
         (r8 tmp.214 tmp.26 tmp.25 unsafe-vector-set!.2 ra.428 rbp)
         (tmp.214 tmp.26 tmp.25 tmp.24 unsafe-vector-set!.2 ra.428 rbp)
         ((tmp.26 tmp.25 tmp.24 unsafe-vector-set!.2 ra.428 rbp)
          ((tmp.26 tmp.25 tmp.24 unsafe-vector-set!.2 ra.428 rbp)
           (tmp.25 tmp.24 unsafe-vector-set!.2 ra.428 rcx rbp)
           (tmp.24 unsafe-vector-set!.2 ra.428 rdx rcx rbp)
           (unsafe-vector-set!.2 ra.428 rsi rdx rcx rbp)
           (ra.428 rdi rsi rdx rcx rbp)
           (rdi rsi rdx rcx r15 rbp)
           (rdi rsi rdx rcx r15 rbp))
          ((ra.428 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.428 rbp))
         (rbp
          (tmp.24
           tmp.25
           tmp.26
           unsafe-vector-set!.2
           tmp.214
           ra.428
           r15
           rdi
           rsi
           rdx
           rcx
           tmp.118
           rax))
         (ra.428
          (tmp.24
           tmp.25
           tmp.26
           unsafe-vector-set!.2
           tmp.214
           r8
           rbp
           rdi
           rsi
           rdx
           rcx
           tmp.118
           rax))
         (tmp.118 (tmp.26 tmp.25 tmp.24 ra.428 rbp))
         (tmp.24
          (tmp.214
           tmp.26
           tmp.25
           unsafe-vector-set!.2
           ra.428
           rbp
           rdx
           rcx
           tmp.118))
         (tmp.25
          (tmp.24
           r8
           tmp.214
           tmp.26
           unsafe-vector-set!.2
           ra.428
           rbp
           rcx
           tmp.118))
         (tmp.26
          (tmp.24
           tmp.25
           rcx
           r8
           tmp.214
           unsafe-vector-set!.2
           ra.428
           rbp
           tmp.118))
         (rcx
          (tmp.26
           tmp.214
           r15
           rdi
           rsi
           rdx
           tmp.25
           tmp.24
           unsafe-vector-set!.2
           ra.428
           rbp))
         (unsafe-vector-set!.2
          (tmp.24 tmp.25 tmp.26 r8 tmp.214 ra.428 rbp rsi rdx rcx))
         (rdx (tmp.214 r15 rdi rsi tmp.24 unsafe-vector-set!.2 ra.428 rcx rbp))
         (rsi (tmp.214 r15 rdi unsafe-vector-set!.2 ra.428 rdx rcx rbp))
         (rdi (r15 ra.428 rsi rdx rcx rbp))
         (r15 (rdi rsi rdx rcx rbp))
         (r8 (tmp.25 tmp.26 unsafe-vector-set!.2 tmp.214 ra.428))
         (tmp.214
          (tmp.24
           tmp.25
           tmp.26
           unsafe-vector-set!.2
           rsi
           rdx
           rcx
           r8
           ra.428
           rbp)))))
      (begin
        (set! ra.428 r15)
        (set! tmp.214 rdi)
        (set! unsafe-vector-set!.2 rsi)
        (set! tmp.26 rdx)
        (set! tmp.25 rcx)
        (set! tmp.24 r8)
        (if (neq? tmp.214 6)
          (begin
            (set! tmp.118 unsafe-vector-set!.2)
            (set! rcx tmp.26)
            (set! rdx tmp.25)
            (set! rsi tmp.24)
            (set! rdi unsafe-vector-set!.2)
            (set! r15 ra.428)
            (jump L.unsafe-vector-set!.2.2 rbp r15 rcx rdx rsi rdi))
          (begin (set! rax 2366) (jump ra.428 rbp rax)))))
    (define L.jp.68
      ((new-frames ())
       (locals (ra.429 tmp.209 tmp.23))
       (undead-out
        ((rdi rsi ra.429 rbp)
         (rsi tmp.209 ra.429 rbp)
         (tmp.209 tmp.23 ra.429 rbp)
         ((tmp.23 ra.429 rbp)
          ((ra.429 rax rbp) (rax rbp))
          ((ra.429 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.429 rbp))
         (rbp (tmp.23 tmp.209 ra.429 rax))
         (ra.429 (tmp.23 tmp.209 rdi rsi rbp rax))
         (rsi (tmp.209 ra.429))
         (rdi (ra.429))
         (tmp.209 (tmp.23 rsi ra.429 rbp))
         (tmp.23 (tmp.209 ra.429 rbp)))))
      (begin
        (set! ra.429 r15)
        (set! tmp.209 rdi)
        (set! tmp.23 rsi)
        (if (neq? tmp.209 6)
          (begin (set! rax (mref tmp.23 -3)) (jump ra.429 rbp rax))
          (begin (set! rax 2110) (jump ra.429 rbp rax)))))
    (define L.jp.66
      ((new-frames ())
       (locals (tmp.206 ra.430 tmp.22 tmp.119 make-init-vector.1))
       (undead-out
        ((rdi rsi rdx ra.430 rbp)
         (rsi rdx tmp.206 ra.430 rbp)
         (rdx tmp.206 make-init-vector.1 ra.430 rbp)
         (tmp.206 tmp.22 make-init-vector.1 ra.430 rbp)
         ((tmp.22 make-init-vector.1 ra.430 rbp)
          ((tmp.22 make-init-vector.1 ra.430 rbp)
           (make-init-vector.1 ra.430 rsi rbp)
           (ra.430 rdi rsi rbp)
           (rdi rsi r15 rbp)
           (rdi rsi r15 rbp))
          ((ra.430 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.430 rbp))
         (rbp
          (tmp.22 make-init-vector.1 tmp.206 ra.430 r15 rdi rsi tmp.119 rax))
         (ra.430
          (tmp.22 make-init-vector.1 tmp.206 rdx rbp rdi rsi tmp.119 rax))
         (tmp.119 (tmp.22 ra.430 rbp))
         (tmp.22 (tmp.206 make-init-vector.1 ra.430 rbp tmp.119))
         (rsi (tmp.206 r15 rdi make-init-vector.1 ra.430 rbp))
         (make-init-vector.1 (tmp.22 rdx tmp.206 ra.430 rbp rsi))
         (rdi (r15 ra.430 rsi rbp))
         (r15 (rdi rsi rbp))
         (rdx (make-init-vector.1 tmp.206 ra.430))
         (tmp.206 (tmp.22 make-init-vector.1 rsi rdx ra.430 rbp)))))
      (begin
        (set! ra.430 r15)
        (set! tmp.206 rdi)
        (set! make-init-vector.1 rsi)
        (set! tmp.22 rdx)
        (if (neq? tmp.206 6)
          (begin
            (set! tmp.119 make-init-vector.1)
            (set! rsi tmp.22)
            (set! rdi make-init-vector.1)
            (set! r15 ra.430)
            (jump L.make-init-vector.1.4 rbp r15 rsi rdi))
          (begin (set! rax 1854) (jump ra.430 rbp rax)))))
    (define L.jp.64
      ((new-frames ())
       (locals (tmp.199 tmp.432 tmp.203 ra.431 tmp.20 tmp.21))
       (undead-out
        ((rdi rsi rdx ra.431 rbp)
         (rsi rdx tmp.199 ra.431 rbp)
         (rdx tmp.199 tmp.20 ra.431 rbp)
         (tmp.199 tmp.21 tmp.20 ra.431 rbp)
         ((tmp.21 tmp.20 ra.431 rbp)
          ((tmp.432 tmp.21 tmp.20 ra.431 rbp)
           (tmp.203 tmp.21 tmp.20 ra.431 rbp)
           ((tmp.21 tmp.20 ra.431 rbp)
            ((tmp.20 ra.431 rdx rbp)
             (ra.431 rsi rdx rbp)
             (ra.431 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.20 ra.431 rdx rbp)
             (ra.431 rsi rdx rbp)
             (ra.431 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.431 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.431 rbp))
         (rbp
          (tmp.21 tmp.20 tmp.199 ra.431 tmp.203 tmp.432 r15 rdi rsi rdx rax))
         (ra.431 (tmp.21 tmp.20 tmp.199 rbp tmp.203 tmp.432 rdi rsi rdx rax))
         (rdx (tmp.199 r15 rdi rsi tmp.20 ra.431 rbp))
         (tmp.20 (tmp.21 tmp.199 ra.431 rbp tmp.203 tmp.432 rdx))
         (rsi (tmp.199 r15 rdi ra.431 rdx rbp))
         (rdi (r15 ra.431 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.432 (rbp ra.431 tmp.20 tmp.21))
         (tmp.21 (tmp.199 tmp.20 ra.431 rbp tmp.203 tmp.432))
         (tmp.203 (tmp.21 tmp.20 ra.431 rbp))
         (tmp.199 (tmp.21 tmp.20 rsi rdx ra.431 rbp)))))
      (begin
        (set! ra.431 r15)
        (set! tmp.199 rdi)
        (set! tmp.20 rsi)
        (set! tmp.21 rdx)
        (if (neq? tmp.199 6)
          (begin
            (set! tmp.432 (bitwise-and tmp.20 7))
            (set! tmp.203 tmp.432)
            (if (eq? tmp.203 0)
              (begin
                (set! rdx tmp.21)
                (set! rsi tmp.20)
                (set! rdi 14)
                (set! r15 ra.431)
                (jump L.jp.63 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.21)
                (set! rsi tmp.20)
                (set! rdi 6)
                (set! r15 ra.431)
                (jump L.jp.63 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1598) (jump ra.431 rbp rax)))))
    (define L.jp.63
      ((new-frames ())
       (locals (ra.433 tmp.201 tmp.21 tmp.20))
       (undead-out
        ((rdi rsi rdx ra.433 rbp)
         (rsi rdx tmp.201 ra.433 rbp)
         (rdx tmp.201 tmp.20 ra.433 rbp)
         (tmp.201 tmp.20 tmp.21 ra.433 rbp)
         ((tmp.20 tmp.21 ra.433 rbp)
          ((ra.433 rbp)
           ((ra.433 rax rbp) (rax rbp))
           ((ra.433 rax rbp) (rax rbp)))
          ((ra.433 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.433 rbp))
         (rbp (tmp.21 tmp.20 tmp.201 ra.433 rax))
         (ra.433 (tmp.21 tmp.20 tmp.201 rdi rsi rdx rbp rax))
         (rdx (tmp.20 tmp.201 ra.433))
         (rsi (tmp.201 ra.433))
         (rdi (ra.433))
         (tmp.201 (tmp.21 tmp.20 rsi rdx ra.433 rbp))
         (tmp.20 (tmp.21 rdx tmp.201 ra.433 rbp))
         (tmp.21 (tmp.201 tmp.20 ra.433 rbp)))))
      (begin
        (set! ra.433 r15)
        (set! tmp.201 rdi)
        (set! tmp.20 rsi)
        (set! tmp.21 rdx)
        (if (neq? tmp.201 6)
          (if (>= tmp.20 tmp.21)
            (begin (set! rax 14) (jump ra.433 rbp rax))
            (begin (set! rax 6) (jump ra.433 rbp rax)))
          (begin (set! rax 1598) (jump ra.433 rbp rax)))))
    (define L.jp.59
      ((new-frames ())
       (locals (tmp.192 tmp.435 tmp.196 ra.434 tmp.18 tmp.19))
       (undead-out
        ((rdi rsi rdx ra.434 rbp)
         (rsi rdx tmp.192 ra.434 rbp)
         (rdx tmp.192 tmp.18 ra.434 rbp)
         (tmp.192 tmp.19 tmp.18 ra.434 rbp)
         ((tmp.19 tmp.18 ra.434 rbp)
          ((tmp.435 tmp.19 tmp.18 ra.434 rbp)
           (tmp.196 tmp.19 tmp.18 ra.434 rbp)
           ((tmp.19 tmp.18 ra.434 rbp)
            ((tmp.18 ra.434 rdx rbp)
             (ra.434 rsi rdx rbp)
             (ra.434 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.18 ra.434 rdx rbp)
             (ra.434 rsi rdx rbp)
             (ra.434 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.434 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.434 rbp))
         (rbp
          (tmp.19 tmp.18 tmp.192 ra.434 tmp.196 tmp.435 r15 rdi rsi rdx rax))
         (ra.434 (tmp.19 tmp.18 tmp.192 rbp tmp.196 tmp.435 rdi rsi rdx rax))
         (rdx (tmp.192 r15 rdi rsi tmp.18 ra.434 rbp))
         (tmp.18 (tmp.19 tmp.192 ra.434 rbp tmp.196 tmp.435 rdx))
         (rsi (tmp.192 r15 rdi ra.434 rdx rbp))
         (rdi (r15 ra.434 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.435 (rbp ra.434 tmp.18 tmp.19))
         (tmp.19 (tmp.192 tmp.18 ra.434 rbp tmp.196 tmp.435))
         (tmp.196 (tmp.19 tmp.18 ra.434 rbp))
         (tmp.192 (tmp.19 tmp.18 rsi rdx ra.434 rbp)))))
      (begin
        (set! ra.434 r15)
        (set! tmp.192 rdi)
        (set! tmp.18 rsi)
        (set! tmp.19 rdx)
        (if (neq? tmp.192 6)
          (begin
            (set! tmp.435 (bitwise-and tmp.18 7))
            (set! tmp.196 tmp.435)
            (if (eq? tmp.196 0)
              (begin
                (set! rdx tmp.19)
                (set! rsi tmp.18)
                (set! rdi 14)
                (set! r15 ra.434)
                (jump L.jp.58 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.19)
                (set! rsi tmp.18)
                (set! rdi 6)
                (set! r15 ra.434)
                (jump L.jp.58 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1342) (jump ra.434 rbp rax)))))
    (define L.jp.58
      ((new-frames ())
       (locals (ra.436 tmp.194 tmp.19 tmp.18))
       (undead-out
        ((rdi rsi rdx ra.436 rbp)
         (rsi rdx tmp.194 ra.436 rbp)
         (rdx tmp.194 tmp.18 ra.436 rbp)
         (tmp.194 tmp.18 tmp.19 ra.436 rbp)
         ((tmp.18 tmp.19 ra.436 rbp)
          ((ra.436 rbp)
           ((ra.436 rax rbp) (rax rbp))
           ((ra.436 rax rbp) (rax rbp)))
          ((ra.436 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.436 rbp))
         (rbp (tmp.19 tmp.18 tmp.194 ra.436 rax))
         (ra.436 (tmp.19 tmp.18 tmp.194 rdi rsi rdx rbp rax))
         (rdx (tmp.18 tmp.194 ra.436))
         (rsi (tmp.194 ra.436))
         (rdi (ra.436))
         (tmp.194 (tmp.19 tmp.18 rsi rdx ra.436 rbp))
         (tmp.18 (tmp.19 rdx tmp.194 ra.436 rbp))
         (tmp.19 (tmp.194 tmp.18 ra.436 rbp)))))
      (begin
        (set! ra.436 r15)
        (set! tmp.194 rdi)
        (set! tmp.18 rsi)
        (set! tmp.19 rdx)
        (if (neq? tmp.194 6)
          (if (> tmp.18 tmp.19)
            (begin (set! rax 14) (jump ra.436 rbp rax))
            (begin (set! rax 6) (jump ra.436 rbp rax)))
          (begin (set! rax 1342) (jump ra.436 rbp rax)))))
    (define L.jp.54
      ((new-frames ())
       (locals (tmp.185 tmp.438 tmp.189 ra.437 tmp.16 tmp.17))
       (undead-out
        ((rdi rsi rdx ra.437 rbp)
         (rsi rdx tmp.185 ra.437 rbp)
         (rdx tmp.185 tmp.16 ra.437 rbp)
         (tmp.185 tmp.17 tmp.16 ra.437 rbp)
         ((tmp.17 tmp.16 ra.437 rbp)
          ((tmp.438 tmp.17 tmp.16 ra.437 rbp)
           (tmp.189 tmp.17 tmp.16 ra.437 rbp)
           ((tmp.17 tmp.16 ra.437 rbp)
            ((tmp.16 ra.437 rdx rbp)
             (ra.437 rsi rdx rbp)
             (ra.437 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.16 ra.437 rdx rbp)
             (ra.437 rsi rdx rbp)
             (ra.437 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.437 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.437 rbp))
         (rbp
          (tmp.17 tmp.16 tmp.185 ra.437 tmp.189 tmp.438 r15 rdi rsi rdx rax))
         (ra.437 (tmp.17 tmp.16 tmp.185 rbp tmp.189 tmp.438 rdi rsi rdx rax))
         (rdx (tmp.185 r15 rdi rsi tmp.16 ra.437 rbp))
         (tmp.16 (tmp.17 tmp.185 ra.437 rbp tmp.189 tmp.438 rdx))
         (rsi (tmp.185 r15 rdi ra.437 rdx rbp))
         (rdi (r15 ra.437 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.438 (rbp ra.437 tmp.16 tmp.17))
         (tmp.17 (tmp.185 tmp.16 ra.437 rbp tmp.189 tmp.438))
         (tmp.189 (tmp.17 tmp.16 ra.437 rbp))
         (tmp.185 (tmp.17 tmp.16 rsi rdx ra.437 rbp)))))
      (begin
        (set! ra.437 r15)
        (set! tmp.185 rdi)
        (set! tmp.16 rsi)
        (set! tmp.17 rdx)
        (if (neq? tmp.185 6)
          (begin
            (set! tmp.438 (bitwise-and tmp.16 7))
            (set! tmp.189 tmp.438)
            (if (eq? tmp.189 0)
              (begin
                (set! rdx tmp.17)
                (set! rsi tmp.16)
                (set! rdi 14)
                (set! r15 ra.437)
                (jump L.jp.53 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.17)
                (set! rsi tmp.16)
                (set! rdi 6)
                (set! r15 ra.437)
                (jump L.jp.53 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1086) (jump ra.437 rbp rax)))))
    (define L.jp.53
      ((new-frames ())
       (locals (ra.439 tmp.187 tmp.17 tmp.16))
       (undead-out
        ((rdi rsi rdx ra.439 rbp)
         (rsi rdx tmp.187 ra.439 rbp)
         (rdx tmp.187 tmp.16 ra.439 rbp)
         (tmp.187 tmp.16 tmp.17 ra.439 rbp)
         ((tmp.16 tmp.17 ra.439 rbp)
          ((ra.439 rbp)
           ((ra.439 rax rbp) (rax rbp))
           ((ra.439 rax rbp) (rax rbp)))
          ((ra.439 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.439 rbp))
         (rbp (tmp.17 tmp.16 tmp.187 ra.439 rax))
         (ra.439 (tmp.17 tmp.16 tmp.187 rdi rsi rdx rbp rax))
         (rdx (tmp.16 tmp.187 ra.439))
         (rsi (tmp.187 ra.439))
         (rdi (ra.439))
         (tmp.187 (tmp.17 tmp.16 rsi rdx ra.439 rbp))
         (tmp.16 (tmp.17 rdx tmp.187 ra.439 rbp))
         (tmp.17 (tmp.187 tmp.16 ra.439 rbp)))))
      (begin
        (set! ra.439 r15)
        (set! tmp.187 rdi)
        (set! tmp.16 rsi)
        (set! tmp.17 rdx)
        (if (neq? tmp.187 6)
          (if (<= tmp.16 tmp.17)
            (begin (set! rax 14) (jump ra.439 rbp rax))
            (begin (set! rax 6) (jump ra.439 rbp rax)))
          (begin (set! rax 1086) (jump ra.439 rbp rax)))))
    (define L.jp.49
      ((new-frames ())
       (locals (tmp.178 tmp.441 tmp.182 ra.440 tmp.14 tmp.15))
       (undead-out
        ((rdi rsi rdx ra.440 rbp)
         (rsi rdx tmp.178 ra.440 rbp)
         (rdx tmp.178 tmp.14 ra.440 rbp)
         (tmp.178 tmp.15 tmp.14 ra.440 rbp)
         ((tmp.15 tmp.14 ra.440 rbp)
          ((tmp.441 tmp.15 tmp.14 ra.440 rbp)
           (tmp.182 tmp.15 tmp.14 ra.440 rbp)
           ((tmp.15 tmp.14 ra.440 rbp)
            ((tmp.14 ra.440 rdx rbp)
             (ra.440 rsi rdx rbp)
             (ra.440 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.14 ra.440 rdx rbp)
             (ra.440 rsi rdx rbp)
             (ra.440 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.440 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.440 rbp))
         (rbp
          (tmp.15 tmp.14 tmp.178 ra.440 tmp.182 tmp.441 r15 rdi rsi rdx rax))
         (ra.440 (tmp.15 tmp.14 tmp.178 rbp tmp.182 tmp.441 rdi rsi rdx rax))
         (rdx (tmp.178 r15 rdi rsi tmp.14 ra.440 rbp))
         (tmp.14 (tmp.15 tmp.178 ra.440 rbp tmp.182 tmp.441 rdx))
         (rsi (tmp.178 r15 rdi ra.440 rdx rbp))
         (rdi (r15 ra.440 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.441 (rbp ra.440 tmp.14 tmp.15))
         (tmp.15 (tmp.178 tmp.14 ra.440 rbp tmp.182 tmp.441))
         (tmp.182 (tmp.15 tmp.14 ra.440 rbp))
         (tmp.178 (tmp.15 tmp.14 rsi rdx ra.440 rbp)))))
      (begin
        (set! ra.440 r15)
        (set! tmp.178 rdi)
        (set! tmp.14 rsi)
        (set! tmp.15 rdx)
        (if (neq? tmp.178 6)
          (begin
            (set! tmp.441 (bitwise-and tmp.14 7))
            (set! tmp.182 tmp.441)
            (if (eq? tmp.182 0)
              (begin
                (set! rdx tmp.15)
                (set! rsi tmp.14)
                (set! rdi 14)
                (set! r15 ra.440)
                (jump L.jp.48 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.15)
                (set! rsi tmp.14)
                (set! rdi 6)
                (set! r15 ra.440)
                (jump L.jp.48 rbp r15 rdx rsi rdi))))
          (begin (set! rax 830) (jump ra.440 rbp rax)))))
    (define L.jp.48
      ((new-frames ())
       (locals (ra.442 tmp.180 tmp.15 tmp.14))
       (undead-out
        ((rdi rsi rdx ra.442 rbp)
         (rsi rdx tmp.180 ra.442 rbp)
         (rdx tmp.180 tmp.14 ra.442 rbp)
         (tmp.180 tmp.14 tmp.15 ra.442 rbp)
         ((tmp.14 tmp.15 ra.442 rbp)
          ((ra.442 rbp)
           ((ra.442 rax rbp) (rax rbp))
           ((ra.442 rax rbp) (rax rbp)))
          ((ra.442 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.442 rbp))
         (rbp (tmp.15 tmp.14 tmp.180 ra.442 rax))
         (ra.442 (tmp.15 tmp.14 tmp.180 rdi rsi rdx rbp rax))
         (rdx (tmp.14 tmp.180 ra.442))
         (rsi (tmp.180 ra.442))
         (rdi (ra.442))
         (tmp.180 (tmp.15 tmp.14 rsi rdx ra.442 rbp))
         (tmp.14 (tmp.15 rdx tmp.180 ra.442 rbp))
         (tmp.15 (tmp.180 tmp.14 ra.442 rbp)))))
      (begin
        (set! ra.442 r15)
        (set! tmp.180 rdi)
        (set! tmp.14 rsi)
        (set! tmp.15 rdx)
        (if (neq? tmp.180 6)
          (if (< tmp.14 tmp.15)
            (begin (set! rax 14) (jump ra.442 rbp rax))
            (begin (set! rax 6) (jump ra.442 rbp rax)))
          (begin (set! rax 830) (jump ra.442 rbp rax)))))
    (define L.jp.44
      ((new-frames ())
       (locals (tmp.172 tmp.444 tmp.175 ra.443 tmp.12 tmp.13))
       (undead-out
        ((rdi rsi rdx ra.443 rbp)
         (rsi rdx tmp.172 ra.443 rbp)
         (rdx tmp.172 tmp.12 ra.443 rbp)
         (tmp.172 tmp.13 tmp.12 ra.443 rbp)
         ((tmp.13 tmp.12 ra.443 rbp)
          ((tmp.444 tmp.13 tmp.12 ra.443 rbp)
           (tmp.175 tmp.13 tmp.12 ra.443 rbp)
           ((tmp.13 tmp.12 ra.443 rbp)
            ((tmp.12 ra.443 rdx rbp)
             (ra.443 rsi rdx rbp)
             (ra.443 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.12 ra.443 rdx rbp)
             (ra.443 rsi rdx rbp)
             (ra.443 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.443 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.443 rbp))
         (rbp
          (tmp.13 tmp.12 tmp.172 ra.443 tmp.175 tmp.444 r15 rdi rsi rdx rax))
         (ra.443 (tmp.13 tmp.12 tmp.172 rbp tmp.175 tmp.444 rdi rsi rdx rax))
         (rdx (tmp.172 r15 rdi rsi tmp.12 ra.443 rbp))
         (tmp.12 (tmp.13 tmp.172 ra.443 rbp tmp.175 tmp.444 rdx))
         (rsi (tmp.172 r15 rdi ra.443 rdx rbp))
         (rdi (r15 ra.443 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.444 (rbp ra.443 tmp.12 tmp.13))
         (tmp.13 (tmp.172 tmp.12 ra.443 rbp tmp.175 tmp.444))
         (tmp.175 (tmp.13 tmp.12 ra.443 rbp))
         (tmp.172 (tmp.13 tmp.12 rsi rdx ra.443 rbp)))))
      (begin
        (set! ra.443 r15)
        (set! tmp.172 rdi)
        (set! tmp.12 rsi)
        (set! tmp.13 rdx)
        (if (neq? tmp.172 6)
          (begin
            (set! tmp.444 (bitwise-and tmp.12 7))
            (set! tmp.175 tmp.444)
            (if (eq? tmp.175 0)
              (begin
                (set! rdx tmp.13)
                (set! rsi tmp.12)
                (set! rdi 14)
                (set! r15 ra.443)
                (jump L.jp.43 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.13)
                (set! rsi tmp.12)
                (set! rdi 6)
                (set! r15 ra.443)
                (jump L.jp.43 rbp r15 rdx rsi rdi))))
          (begin (set! rax 574) (jump ra.443 rbp rax)))))
    (define L.jp.43
      ((new-frames ())
       (locals (ra.445 tmp.174 tmp.446 tmp.12 tmp.13))
       (undead-out
        ((rdi rsi rdx ra.445 rbp)
         (rsi rdx tmp.174 ra.445 rbp)
         (rdx tmp.174 tmp.12 ra.445 rbp)
         (tmp.174 tmp.13 tmp.12 ra.445 rbp)
         ((tmp.13 tmp.12 ra.445 rbp)
          ((tmp.446 ra.445 rbp) (ra.445 rax rbp) (rax rbp))
          ((ra.445 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.445 rbp))
         (rbp (tmp.13 tmp.12 tmp.174 ra.445 tmp.446 rax))
         (ra.445 (tmp.13 tmp.12 tmp.174 rdi rsi rdx rbp tmp.446 rax))
         (tmp.446 (rbp ra.445))
         (rdx (tmp.12 tmp.174 ra.445))
         (rsi (tmp.174 ra.445))
         (rdi (ra.445))
         (tmp.174 (tmp.13 tmp.12 rsi rdx ra.445 rbp))
         (tmp.12 (tmp.13 rdx tmp.174 ra.445 rbp))
         (tmp.13 (tmp.174 tmp.12 ra.445 rbp)))))
      (begin
        (set! ra.445 r15)
        (set! tmp.174 rdi)
        (set! tmp.12 rsi)
        (set! tmp.13 rdx)
        (if (neq? tmp.174 6)
          (begin
            (set! tmp.446 (- tmp.12 tmp.13))
            (set! rax tmp.446)
            (jump ra.445 rbp rax))
          (begin (set! rax 574) (jump ra.445 rbp rax)))))
    (define L.jp.40
      ((new-frames ())
       (locals (tmp.166 tmp.448 tmp.169 ra.447 tmp.10 tmp.11))
       (undead-out
        ((rdi rsi rdx ra.447 rbp)
         (rsi rdx tmp.166 ra.447 rbp)
         (rdx tmp.166 tmp.10 ra.447 rbp)
         (tmp.166 tmp.11 tmp.10 ra.447 rbp)
         ((tmp.11 tmp.10 ra.447 rbp)
          ((tmp.448 tmp.11 tmp.10 ra.447 rbp)
           (tmp.169 tmp.11 tmp.10 ra.447 rbp)
           ((tmp.11 tmp.10 ra.447 rbp)
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
          (tmp.11 tmp.10 tmp.166 ra.447 tmp.169 tmp.448 r15 rdi rsi rdx rax))
         (ra.447 (tmp.11 tmp.10 tmp.166 rbp tmp.169 tmp.448 rdi rsi rdx rax))
         (rdx (tmp.166 r15 rdi rsi tmp.10 ra.447 rbp))
         (tmp.10 (tmp.11 tmp.166 ra.447 rbp tmp.169 tmp.448 rdx))
         (rsi (tmp.166 r15 rdi ra.447 rdx rbp))
         (rdi (r15 ra.447 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.448 (rbp ra.447 tmp.10 tmp.11))
         (tmp.11 (tmp.166 tmp.10 ra.447 rbp tmp.169 tmp.448))
         (tmp.169 (tmp.11 tmp.10 ra.447 rbp))
         (tmp.166 (tmp.11 tmp.10 rsi rdx ra.447 rbp)))))
      (begin
        (set! ra.447 r15)
        (set! tmp.166 rdi)
        (set! tmp.10 rsi)
        (set! tmp.11 rdx)
        (if (neq? tmp.166 6)
          (begin
            (set! tmp.448 (bitwise-and tmp.10 7))
            (set! tmp.169 tmp.448)
            (if (eq? tmp.169 0)
              (begin
                (set! rdx tmp.11)
                (set! rsi tmp.10)
                (set! rdi 14)
                (set! r15 ra.447)
                (jump L.jp.39 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.11)
                (set! rsi tmp.10)
                (set! rdi 6)
                (set! r15 ra.447)
                (jump L.jp.39 rbp r15 rdx rsi rdi))))
          (begin (set! rax 318) (jump ra.447 rbp rax)))))
    (define L.jp.39
      ((new-frames ())
       (locals (ra.449 tmp.168 tmp.450 tmp.10 tmp.11))
       (undead-out
        ((rdi rsi rdx ra.449 rbp)
         (rsi rdx tmp.168 ra.449 rbp)
         (rdx tmp.168 tmp.10 ra.449 rbp)
         (tmp.168 tmp.11 tmp.10 ra.449 rbp)
         ((tmp.11 tmp.10 ra.449 rbp)
          ((tmp.450 ra.449 rbp) (ra.449 rax rbp) (rax rbp))
          ((ra.449 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.449 rbp))
         (rbp (tmp.11 tmp.10 tmp.168 ra.449 tmp.450 rax))
         (ra.449 (tmp.11 tmp.10 tmp.168 rdi rsi rdx rbp tmp.450 rax))
         (tmp.450 (rbp ra.449))
         (rdx (tmp.10 tmp.168 ra.449))
         (rsi (tmp.168 ra.449))
         (rdi (ra.449))
         (tmp.168 (tmp.11 tmp.10 rsi rdx ra.449 rbp))
         (tmp.10 (tmp.11 rdx tmp.168 ra.449 rbp))
         (tmp.11 (tmp.168 tmp.10 ra.449 rbp)))))
      (begin
        (set! ra.449 r15)
        (set! tmp.168 rdi)
        (set! tmp.10 rsi)
        (set! tmp.11 rdx)
        (if (neq? tmp.168 6)
          (begin
            (set! tmp.450 (+ tmp.10 tmp.11))
            (set! rax tmp.450)
            (jump ra.449 rbp rax))
          (begin (set! rax 318) (jump ra.449 rbp rax)))))
    (define L.jp.36
      ((new-frames ())
       (locals (tmp.159 tmp.452 tmp.163 ra.451 tmp.9 tmp.8))
       (undead-out
        ((rdi rsi rdx ra.451 rbp)
         (rsi rdx tmp.159 ra.451 rbp)
         (rdx tmp.159 tmp.8 ra.451 rbp)
         (tmp.159 tmp.8 tmp.9 ra.451 rbp)
         ((tmp.8 tmp.9 ra.451 rbp)
          ((tmp.452 tmp.8 tmp.9 ra.451 rbp)
           (tmp.163 tmp.8 tmp.9 ra.451 rbp)
           ((tmp.8 tmp.9 ra.451 rbp)
            ((tmp.9 ra.451 rdx rbp)
             (ra.451 rsi rdx rbp)
             (ra.451 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))
            ((tmp.9 ra.451 rdx rbp)
             (ra.451 rsi rdx rbp)
             (ra.451 rdi rsi rdx rbp)
             (rdi rsi rdx r15 rbp)
             (rdi rsi rdx r15 rbp))))
          ((ra.451 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.451 rbp))
         (rbp (tmp.9 tmp.8 tmp.159 ra.451 tmp.163 tmp.452 r15 rdi rsi rdx rax))
         (ra.451 (tmp.9 tmp.8 tmp.159 rbp tmp.163 tmp.452 rdi rsi rdx rax))
         (rdx (tmp.8 tmp.159 r15 rdi rsi tmp.9 ra.451 rbp))
         (tmp.9 (tmp.159 tmp.8 ra.451 rbp tmp.163 tmp.452 rdx))
         (rsi (tmp.159 r15 rdi ra.451 rdx rbp))
         (rdi (r15 ra.451 rsi rdx rbp))
         (r15 (rdi rsi rdx rbp))
         (tmp.452 (rbp ra.451 tmp.9 tmp.8))
         (tmp.8 (tmp.9 rdx tmp.159 ra.451 rbp tmp.163 tmp.452))
         (tmp.163 (tmp.8 tmp.9 ra.451 rbp))
         (tmp.159 (tmp.9 tmp.8 rsi rdx ra.451 rbp)))))
      (begin
        (set! ra.451 r15)
        (set! tmp.159 rdi)
        (set! tmp.8 rsi)
        (set! tmp.9 rdx)
        (if (neq? tmp.159 6)
          (begin
            (set! tmp.452 (bitwise-and tmp.8 7))
            (set! tmp.163 tmp.452)
            (if (eq? tmp.163 0)
              (begin
                (set! rdx tmp.8)
                (set! rsi tmp.9)
                (set! rdi 14)
                (set! r15 ra.451)
                (jump L.jp.35 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.8)
                (set! rsi tmp.9)
                (set! rdi 6)
                (set! r15 ra.451)
                (jump L.jp.35 rbp r15 rdx rsi rdi))))
          (begin (set! rax 62) (jump ra.451 rbp rax)))))
    (define L.jp.35
      ((new-frames ())
       (locals (ra.453 tmp.161 tmp.455 tmp.8 tmp.162 tmp.454 tmp.9))
       (undead-out
        ((rdi rsi rdx ra.453 rbp)
         (rsi rdx tmp.161 ra.453 rbp)
         (rdx tmp.161 tmp.9 ra.453 rbp)
         (tmp.161 tmp.9 tmp.8 ra.453 rbp)
         ((tmp.9 tmp.8 ra.453 rbp)
          ((tmp.454 tmp.8 ra.453 rbp)
           (tmp.162 tmp.8 ra.453 rbp)
           (tmp.455 ra.453 rbp)
           (ra.453 rax rbp)
           (rax rbp))
          ((ra.453 rax rbp) (rax rbp)))))
       (call-undead ())
       (conflicts
        ((rax (ra.453 rbp))
         (rbp (tmp.8 tmp.9 tmp.161 ra.453 tmp.455 tmp.162 tmp.454 rax))
         (ra.453
          (tmp.8 tmp.9 tmp.161 rdi rsi rdx rbp tmp.455 tmp.162 tmp.454 rax))
         (tmp.454 (rbp ra.453 tmp.8))
         (tmp.8 (tmp.161 tmp.9 ra.453 rbp tmp.162 tmp.454))
         (tmp.162 (tmp.8 ra.453 rbp))
         (tmp.455 (rbp ra.453))
         (rdx (tmp.9 tmp.161 ra.453))
         (rsi (tmp.161 ra.453))
         (rdi (ra.453))
         (tmp.161 (tmp.8 tmp.9 rsi rdx ra.453 rbp))
         (tmp.9 (tmp.8 rdx tmp.161 ra.453 rbp)))))
      (begin
        (set! ra.453 r15)
        (set! tmp.161 rdi)
        (set! tmp.9 rsi)
        (set! tmp.8 rdx)
        (if (neq? tmp.161 6)
          (begin
            (set! tmp.454 (arithmetic-shift-right tmp.9 3))
            (set! tmp.162 tmp.454)
            (set! tmp.455 (* tmp.8 tmp.162))
            (set! rax tmp.455)
            (jump ra.453 rbp rax))
          (begin (set! rax 62) (jump ra.453 rbp rax))))))
     ) 2))


(parameterize ([current-pass-list
                  (list
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
    (define L.main.104
      ((new-frames ())
       (locals
        (tmp.123
         x.7
         tmp.122
         two.5
         tmp.157
         tmp.343
         tmp.310
         i.4
         tmp.156
         tmp.342
         tmp.309
         *.46
         tmp.155
         tmp.341
         tmp.308
         |+.47|
         tmp.154
         tmp.340
         tmp.307
         |-.48|
         tmp.153
         tmp.339
         tmp.306
         <.49
         tmp.152
         tmp.338
         tmp.305
         <=.50
         tmp.151
         tmp.337
         tmp.304
         >.51
         tmp.150
         tmp.336
         tmp.303
         >=.52
         tmp.149
         tmp.335
         tmp.302
         make-vector.53
         tmp.148
         tmp.334
         tmp.301
         vector-length.54
         tmp.147
         tmp.333
         tmp.300
         vector-set!.55
         tmp.146
         tmp.332
         tmp.299
         vector-ref.56
         tmp.145
         tmp.331
         tmp.298
         car.57
         tmp.144
         tmp.330
         tmp.297
         cdr.58
         tmp.143
         tmp.329
         tmp.296
         procedure-arity.59
         tmp.142
         tmp.328
         tmp.295
         fixnum?.60
         tmp.141
         tmp.327
         tmp.294
         boolean?.61
         tmp.140
         tmp.326
         tmp.293
         empty?.62
         tmp.139
         tmp.325
         tmp.292
         void?.63
         tmp.138
         tmp.324
         tmp.291
         ascii-char?.64
         tmp.137
         tmp.323
         tmp.290
         error?.65
         tmp.136
         tmp.322
         tmp.289
         pair?.66
         tmp.135
         tmp.321
         tmp.288
         procedure?.67
         tmp.134
         tmp.320
         tmp.287
         vector?.68
         tmp.133
         tmp.319
         tmp.286
         not.69
         tmp.132
         tmp.318
         tmp.285
         cons.70
         tmp.131
         tmp.317
         tmp.284
         eq?.71
         tmp.130
         tmp.316
         tmp.283
         make-init-vector.1
         tmp.129
         tmp.315
         tmp.282
         vector-init-loop.74
         tmp.128
         tmp.314
         tmp.281
         unsafe-vector-set!.2
         tmp.127
         tmp.313
         tmp.280
         unsafe-vector-ref.3
         tmp.126
         tmp.312
         tmp.279
         ra.311)))
      (begin
        (set! ra.311 r15)
        (set! tmp.279 r12)
        (set! r12 (+ r12 16))
        (set! tmp.312 (+ tmp.279 2))
        (set! tmp.126 tmp.312)
        (mset! tmp.126 -2 L.unsafe-vector-ref.3.1)
        (mset! tmp.126 6 16)
        (set! unsafe-vector-ref.3 tmp.126)
        (set! tmp.280 r12)
        (set! r12 (+ r12 16))
        (set! tmp.313 (+ tmp.280 2))
        (set! tmp.127 tmp.313)
        (mset! tmp.127 -2 L.unsafe-vector-set!.2.2)
        (mset! tmp.127 6 24)
        (set! unsafe-vector-set!.2 tmp.127)
        (set! tmp.281 r12)
        (set! r12 (+ r12 80))
        (set! tmp.314 (+ tmp.281 2))
        (set! tmp.128 tmp.314)
        (mset! tmp.128 -2 L.vector-init-loop.74.3)
        (mset! tmp.128 6 24)
        (set! vector-init-loop.74 tmp.128)
        (set! tmp.282 r12)
        (set! r12 (+ r12 80))
        (set! tmp.315 (+ tmp.282 2))
        (set! tmp.129 tmp.315)
        (mset! tmp.129 -2 L.make-init-vector.1.4)
        (mset! tmp.129 6 8)
        (set! make-init-vector.1 tmp.129)
        (set! tmp.283 r12)
        (set! r12 (+ r12 16))
        (set! tmp.316 (+ tmp.283 2))
        (set! tmp.130 tmp.316)
        (mset! tmp.130 -2 L.eq?.71.5)
        (mset! tmp.130 6 16)
        (set! eq?.71 tmp.130)
        (set! tmp.284 r12)
        (set! r12 (+ r12 16))
        (set! tmp.317 (+ tmp.284 2))
        (set! tmp.131 tmp.317)
        (mset! tmp.131 -2 L.cons.70.6)
        (mset! tmp.131 6 16)
        (set! cons.70 tmp.131)
        (set! tmp.285 r12)
        (set! r12 (+ r12 16))
        (set! tmp.318 (+ tmp.285 2))
        (set! tmp.132 tmp.318)
        (mset! tmp.132 -2 L.not.69.7)
        (mset! tmp.132 6 8)
        (set! not.69 tmp.132)
        (set! tmp.286 r12)
        (set! r12 (+ r12 16))
        (set! tmp.319 (+ tmp.286 2))
        (set! tmp.133 tmp.319)
        (mset! tmp.133 -2 L.vector?.68.8)
        (mset! tmp.133 6 8)
        (set! vector?.68 tmp.133)
        (set! tmp.287 r12)
        (set! r12 (+ r12 16))
        (set! tmp.320 (+ tmp.287 2))
        (set! tmp.134 tmp.320)
        (mset! tmp.134 -2 L.procedure?.67.9)
        (mset! tmp.134 6 8)
        (set! procedure?.67 tmp.134)
        (set! tmp.288 r12)
        (set! r12 (+ r12 16))
        (set! tmp.321 (+ tmp.288 2))
        (set! tmp.135 tmp.321)
        (mset! tmp.135 -2 L.pair?.66.10)
        (mset! tmp.135 6 8)
        (set! pair?.66 tmp.135)
        (set! tmp.289 r12)
        (set! r12 (+ r12 16))
        (set! tmp.322 (+ tmp.289 2))
        (set! tmp.136 tmp.322)
        (mset! tmp.136 -2 L.error?.65.11)
        (mset! tmp.136 6 8)
        (set! error?.65 tmp.136)
        (set! tmp.290 r12)
        (set! r12 (+ r12 16))
        (set! tmp.323 (+ tmp.290 2))
        (set! tmp.137 tmp.323)
        (mset! tmp.137 -2 L.ascii-char?.64.12)
        (mset! tmp.137 6 8)
        (set! ascii-char?.64 tmp.137)
        (set! tmp.291 r12)
        (set! r12 (+ r12 16))
        (set! tmp.324 (+ tmp.291 2))
        (set! tmp.138 tmp.324)
        (mset! tmp.138 -2 L.void?.63.13)
        (mset! tmp.138 6 8)
        (set! void?.63 tmp.138)
        (set! tmp.292 r12)
        (set! r12 (+ r12 16))
        (set! tmp.325 (+ tmp.292 2))
        (set! tmp.139 tmp.325)
        (mset! tmp.139 -2 L.empty?.62.14)
        (mset! tmp.139 6 8)
        (set! empty?.62 tmp.139)
        (set! tmp.293 r12)
        (set! r12 (+ r12 16))
        (set! tmp.326 (+ tmp.293 2))
        (set! tmp.140 tmp.326)
        (mset! tmp.140 -2 L.boolean?.61.15)
        (mset! tmp.140 6 8)
        (set! boolean?.61 tmp.140)
        (set! tmp.294 r12)
        (set! r12 (+ r12 16))
        (set! tmp.327 (+ tmp.294 2))
        (set! tmp.141 tmp.327)
        (mset! tmp.141 -2 L.fixnum?.60.16)
        (mset! tmp.141 6 8)
        (set! fixnum?.60 tmp.141)
        (set! tmp.295 r12)
        (set! r12 (+ r12 16))
        (set! tmp.328 (+ tmp.295 2))
        (set! tmp.142 tmp.328)
        (mset! tmp.142 -2 L.procedure-arity.59.17)
        (mset! tmp.142 6 8)
        (set! procedure-arity.59 tmp.142)
        (set! tmp.296 r12)
        (set! r12 (+ r12 16))
        (set! tmp.329 (+ tmp.296 2))
        (set! tmp.143 tmp.329)
        (mset! tmp.143 -2 L.cdr.58.18)
        (mset! tmp.143 6 8)
        (set! cdr.58 tmp.143)
        (set! tmp.297 r12)
        (set! r12 (+ r12 16))
        (set! tmp.330 (+ tmp.297 2))
        (set! tmp.144 tmp.330)
        (mset! tmp.144 -2 L.car.57.19)
        (mset! tmp.144 6 8)
        (set! car.57 tmp.144)
        (set! tmp.298 r12)
        (set! r12 (+ r12 80))
        (set! tmp.331 (+ tmp.298 2))
        (set! tmp.145 tmp.331)
        (mset! tmp.145 -2 L.vector-ref.56.20)
        (mset! tmp.145 6 16)
        (set! vector-ref.56 tmp.145)
        (set! tmp.299 r12)
        (set! r12 (+ r12 80))
        (set! tmp.332 (+ tmp.299 2))
        (set! tmp.146 tmp.332)
        (mset! tmp.146 -2 L.vector-set!.55.21)
        (mset! tmp.146 6 24)
        (set! vector-set!.55 tmp.146)
        (set! tmp.300 r12)
        (set! r12 (+ r12 16))
        (set! tmp.333 (+ tmp.300 2))
        (set! tmp.147 tmp.333)
        (mset! tmp.147 -2 L.vector-length.54.22)
        (mset! tmp.147 6 8)
        (set! vector-length.54 tmp.147)
        (set! tmp.301 r12)
        (set! r12 (+ r12 80))
        (set! tmp.334 (+ tmp.301 2))
        (set! tmp.148 tmp.334)
        (mset! tmp.148 -2 L.make-vector.53.23)
        (mset! tmp.148 6 8)
        (set! make-vector.53 tmp.148)
        (set! tmp.302 r12)
        (set! r12 (+ r12 16))
        (set! tmp.335 (+ tmp.302 2))
        (set! tmp.149 tmp.335)
        (mset! tmp.149 -2 L.>=.52.24)
        (mset! tmp.149 6 16)
        (set! >=.52 tmp.149)
        (set! tmp.303 r12)
        (set! r12 (+ r12 16))
        (set! tmp.336 (+ tmp.303 2))
        (set! tmp.150 tmp.336)
        (mset! tmp.150 -2 L.>.51.25)
        (mset! tmp.150 6 16)
        (set! >.51 tmp.150)
        (set! tmp.304 r12)
        (set! r12 (+ r12 16))
        (set! tmp.337 (+ tmp.304 2))
        (set! tmp.151 tmp.337)
        (mset! tmp.151 -2 L.<=.50.26)
        (mset! tmp.151 6 16)
        (set! <=.50 tmp.151)
        (set! tmp.305 r12)
        (set! r12 (+ r12 16))
        (set! tmp.338 (+ tmp.305 2))
        (set! tmp.152 tmp.338)
        (mset! tmp.152 -2 L.<.49.27)
        (mset! tmp.152 6 16)
        (set! <.49 tmp.152)
        (set! tmp.306 r12)
        (set! r12 (+ r12 16))
        (set! tmp.339 (+ tmp.306 2))
        (set! tmp.153 tmp.339)
        (mset! tmp.153 -2 L.-.48.28)
        (mset! tmp.153 6 16)
        (set! |-.48| tmp.153)
        (set! tmp.307 r12)
        (set! r12 (+ r12 16))
        (set! tmp.340 (+ tmp.307 2))
        (set! tmp.154 tmp.340)
        (mset! tmp.154 -2 L.+.47.29)
        (mset! tmp.154 6 16)
        (set! |+.47| tmp.154)
        (set! tmp.308 r12)
        (set! r12 (+ r12 16))
        (set! tmp.341 (+ tmp.308 2))
        (set! tmp.155 tmp.341)
        (mset! tmp.155 -2 L.*.46.30)
        (mset! tmp.155 6 16)
        (set! *.46 tmp.155)
        (mset! vector-init-loop.74 14 vector-init-loop.74)
        (mset! make-init-vector.1 14 vector-init-loop.74)
        (mset! vector-ref.56 14 unsafe-vector-ref.3)
        (mset! vector-set!.55 14 unsafe-vector-set!.2)
        (mset! make-vector.53 14 make-init-vector.1)
        (set! tmp.309 r12)
        (set! r12 (+ r12 80))
        (set! tmp.342 (+ tmp.309 2))
        (set! tmp.156 tmp.342)
        (mset! tmp.156 -2 L.i.4.31)
        (mset! tmp.156 6 8)
        (set! i.4 tmp.156)
        (set! tmp.310 r12)
        (set! r12 (+ r12 80))
        (set! tmp.343 (+ tmp.310 2))
        (set! tmp.157 tmp.343)
        (mset! tmp.157 -2 L.two.5.32)
        (mset! tmp.157 6 0)
        (set! two.5 tmp.157)
        (mset! i.4 14 |-.48|)
        (mset! two.5 14 i.4)
        (set! tmp.122 two.5)
        (return-point L.rp.105
          (begin
            (set! rdi two.5)
            (set! r15 L.rp.105)
            (jump L.two.5.32 rbp r15 rdi)))
        (set! x.7 rax)
        (set! tmp.123 i.4)
        (set! rsi x.7)
        (set! rdi i.4)
        (set! r15 ra.311)
        (jump L.i.4.31 rbp r15 rsi rdi)))
    (define L.two.5.32
      ((new-frames ()) (locals (tmp.121 i.4 c.114 ra.344)))
      (begin
        (set! ra.344 r15)
        (set! c.114 rdi)
        (set! i.4 (mref c.114 14))
        (set! tmp.121 i.4)
        (set! rsi 16)
        (set! rdi i.4)
        (set! r15 ra.344)
        (jump L.i.4.31 rbp r15 rsi rdi)))
    (define L.i.4.31
      ((new-frames ()) (locals (tmp.120 |-.48| x.6 c.113 ra.345)))
      (begin
        (set! ra.345 r15)
        (set! c.113 rdi)
        (set! x.6 rsi)
        (set! |-.48| (mref c.113 14))
        (set! tmp.120 |-.48|)
        (set! rdx 0)
        (set! rsi x.6)
        (set! rdi |-.48|)
        (set! r15 ra.345)
        (jump L.-.48.28 rbp r15 rdx rsi rdi)))
    (define L.*.46.30
      ((new-frames ()) (locals (tmp.347 c.112 tmp.164 ra.346 tmp.8 tmp.9)))
      (begin
        (set! ra.346 r15)
        (set! c.112 rdi)
        (set! tmp.8 rsi)
        (set! tmp.9 rdx)
        (set! tmp.347 (bitwise-and tmp.9 7))
        (set! tmp.164 tmp.347)
        (if (eq? tmp.164 0)
          (begin
            (set! rdx tmp.9)
            (set! rsi tmp.8)
            (set! rdi 14)
            (set! r15 ra.346)
            (jump L.jp.36 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.9)
            (set! rsi tmp.8)
            (set! rdi 6)
            (set! r15 ra.346)
            (jump L.jp.36 rbp r15 rdx rsi rdi)))))
    (define L.+.47.29
      ((new-frames ()) (locals (tmp.349 c.111 tmp.170 ra.348 tmp.10 tmp.11)))
      (begin
        (set! ra.348 r15)
        (set! c.111 rdi)
        (set! tmp.10 rsi)
        (set! tmp.11 rdx)
        (set! tmp.349 (bitwise-and tmp.11 7))
        (set! tmp.170 tmp.349)
        (if (eq? tmp.170 0)
          (begin
            (set! rdx tmp.11)
            (set! rsi tmp.10)
            (set! rdi 14)
            (set! r15 ra.348)
            (jump L.jp.40 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.11)
            (set! rsi tmp.10)
            (set! rdi 6)
            (set! r15 ra.348)
            (jump L.jp.40 rbp r15 rdx rsi rdi)))))
    (define L.-.48.28
      ((new-frames ()) (locals (tmp.351 c.110 tmp.176 ra.350 tmp.12 tmp.13)))
      (begin
        (set! ra.350 r15)
        (set! c.110 rdi)
        (set! tmp.12 rsi)
        (set! tmp.13 rdx)
        (set! tmp.351 (bitwise-and tmp.13 7))
        (set! tmp.176 tmp.351)
        (if (eq? tmp.176 0)
          (begin
            (set! rdx tmp.13)
            (set! rsi tmp.12)
            (set! rdi 14)
            (set! r15 ra.350)
            (jump L.jp.44 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.13)
            (set! rsi tmp.12)
            (set! rdi 6)
            (set! r15 ra.350)
            (jump L.jp.44 rbp r15 rdx rsi rdi)))))
    (define L.<.49.27
      ((new-frames ()) (locals (tmp.353 c.109 tmp.183 ra.352 tmp.14 tmp.15)))
      (begin
        (set! ra.352 r15)
        (set! c.109 rdi)
        (set! tmp.14 rsi)
        (set! tmp.15 rdx)
        (set! tmp.353 (bitwise-and tmp.15 7))
        (set! tmp.183 tmp.353)
        (if (eq? tmp.183 0)
          (begin
            (set! rdx tmp.15)
            (set! rsi tmp.14)
            (set! rdi 14)
            (set! r15 ra.352)
            (jump L.jp.49 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.15)
            (set! rsi tmp.14)
            (set! rdi 6)
            (set! r15 ra.352)
            (jump L.jp.49 rbp r15 rdx rsi rdi)))))
    (define L.<=.50.26
      ((new-frames ()) (locals (tmp.355 c.108 tmp.190 ra.354 tmp.16 tmp.17)))
      (begin
        (set! ra.354 r15)
        (set! c.108 rdi)
        (set! tmp.16 rsi)
        (set! tmp.17 rdx)
        (set! tmp.355 (bitwise-and tmp.17 7))
        (set! tmp.190 tmp.355)
        (if (eq? tmp.190 0)
          (begin
            (set! rdx tmp.17)
            (set! rsi tmp.16)
            (set! rdi 14)
            (set! r15 ra.354)
            (jump L.jp.54 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.17)
            (set! rsi tmp.16)
            (set! rdi 6)
            (set! r15 ra.354)
            (jump L.jp.54 rbp r15 rdx rsi rdi)))))
    (define L.>.51.25
      ((new-frames ()) (locals (tmp.357 c.107 tmp.197 ra.356 tmp.18 tmp.19)))
      (begin
        (set! ra.356 r15)
        (set! c.107 rdi)
        (set! tmp.18 rsi)
        (set! tmp.19 rdx)
        (set! tmp.357 (bitwise-and tmp.19 7))
        (set! tmp.197 tmp.357)
        (if (eq? tmp.197 0)
          (begin
            (set! rdx tmp.19)
            (set! rsi tmp.18)
            (set! rdi 14)
            (set! r15 ra.356)
            (jump L.jp.59 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.19)
            (set! rsi tmp.18)
            (set! rdi 6)
            (set! r15 ra.356)
            (jump L.jp.59 rbp r15 rdx rsi rdi)))))
    (define L.>=.52.24
      ((new-frames ()) (locals (tmp.359 c.106 tmp.204 ra.358 tmp.20 tmp.21)))
      (begin
        (set! ra.358 r15)
        (set! c.106 rdi)
        (set! tmp.20 rsi)
        (set! tmp.21 rdx)
        (set! tmp.359 (bitwise-and tmp.21 7))
        (set! tmp.204 tmp.359)
        (if (eq? tmp.204 0)
          (begin
            (set! rdx tmp.21)
            (set! rsi tmp.20)
            (set! rdi 14)
            (set! r15 ra.358)
            (jump L.jp.64 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.21)
            (set! rsi tmp.20)
            (set! rdi 6)
            (set! r15 ra.358)
            (jump L.jp.64 rbp r15 rdx rsi rdi)))))
    (define L.make-vector.53.23
      ((new-frames ())
       (locals (tmp.361 c.105 tmp.207 ra.360 make-init-vector.1 tmp.22)))
      (begin
        (set! ra.360 r15)
        (set! c.105 rdi)
        (set! tmp.22 rsi)
        (set! make-init-vector.1 (mref c.105 14))
        (set! tmp.361 (bitwise-and tmp.22 7))
        (set! tmp.207 tmp.361)
        (if (eq? tmp.207 0)
          (begin
            (set! rdx tmp.22)
            (set! rsi make-init-vector.1)
            (set! rdi 14)
            (set! r15 ra.360)
            (jump L.jp.66 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.22)
            (set! rsi make-init-vector.1)
            (set! rdi 6)
            (set! r15 ra.360)
            (jump L.jp.66 rbp r15 rdx rsi rdi)))))
    (define L.vector-length.54.22
      ((new-frames ()) (locals (tmp.363 c.104 tmp.210 ra.362 tmp.23)))
      (begin
        (set! ra.362 r15)
        (set! c.104 rdi)
        (set! tmp.23 rsi)
        (set! tmp.363 (bitwise-and tmp.23 7))
        (set! tmp.210 tmp.363)
        (if (eq? tmp.210 3)
          (begin
            (set! rsi tmp.23)
            (set! rdi 14)
            (set! r15 ra.362)
            (jump L.jp.68 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.23)
            (set! rdi 6)
            (set! r15 ra.362)
            (jump L.jp.68 rbp r15 rsi rdi)))))
    (define L.vector-set!.55.21
      ((new-frames ())
       (locals
        (tmp.365
         c.103
         tmp.216
         ra.364
         tmp.24
         unsafe-vector-set!.2
         tmp.26
         tmp.25)))
      (begin
        (set! ra.364 r15)
        (set! c.103 rdi)
        (set! tmp.24 rsi)
        (set! tmp.25 rdx)
        (set! tmp.26 rcx)
        (set! unsafe-vector-set!.2 (mref c.103 14))
        (set! tmp.365 (bitwise-and tmp.25 7))
        (set! tmp.216 tmp.365)
        (if (eq? tmp.216 0)
          (begin
            (set! r8 tmp.25)
            (set! rcx tmp.26)
            (set! rdx unsafe-vector-set!.2)
            (set! rsi tmp.24)
            (set! rdi 14)
            (set! r15 ra.364)
            (jump L.jp.72 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 tmp.25)
            (set! rcx tmp.26)
            (set! rdx unsafe-vector-set!.2)
            (set! rsi tmp.24)
            (set! rdi 6)
            (set! r15 ra.364)
            (jump L.jp.72 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.vector-ref.56.20
      ((new-frames ())
       (locals
        (tmp.367 c.102 tmp.222 ra.366 tmp.27 unsafe-vector-ref.3 tmp.28)))
      (begin
        (set! ra.366 r15)
        (set! c.102 rdi)
        (set! tmp.27 rsi)
        (set! tmp.28 rdx)
        (set! unsafe-vector-ref.3 (mref c.102 14))
        (set! tmp.367 (bitwise-and tmp.28 7))
        (set! tmp.222 tmp.367)
        (if (eq? tmp.222 0)
          (begin
            (set! rcx tmp.28)
            (set! rdx unsafe-vector-ref.3)
            (set! rsi tmp.27)
            (set! rdi 14)
            (set! r15 ra.366)
            (jump L.jp.76 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx tmp.28)
            (set! rdx unsafe-vector-ref.3)
            (set! rsi tmp.27)
            (set! rdi 6)
            (set! r15 ra.366)
            (jump L.jp.76 rbp r15 rcx rdx rsi rdi)))))
    (define L.car.57.19
      ((new-frames ()) (locals (tmp.369 c.101 tmp.225 ra.368 tmp.29)))
      (begin
        (set! ra.368 r15)
        (set! c.101 rdi)
        (set! tmp.29 rsi)
        (set! tmp.369 (bitwise-and tmp.29 7))
        (set! tmp.225 tmp.369)
        (if (eq? tmp.225 1)
          (begin
            (set! rsi tmp.29)
            (set! rdi 14)
            (set! r15 ra.368)
            (jump L.jp.78 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.29)
            (set! rdi 6)
            (set! r15 ra.368)
            (jump L.jp.78 rbp r15 rsi rdi)))))
    (define L.cdr.58.18
      ((new-frames ()) (locals (tmp.371 c.100 tmp.228 ra.370 tmp.30)))
      (begin
        (set! ra.370 r15)
        (set! c.100 rdi)
        (set! tmp.30 rsi)
        (set! tmp.371 (bitwise-and tmp.30 7))
        (set! tmp.228 tmp.371)
        (if (eq? tmp.228 1)
          (begin
            (set! rsi tmp.30)
            (set! rdi 14)
            (set! r15 ra.370)
            (jump L.jp.80 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.30)
            (set! rdi 6)
            (set! r15 ra.370)
            (jump L.jp.80 rbp r15 rsi rdi)))))
    (define L.procedure-arity.59.17
      ((new-frames ()) (locals (tmp.373 c.99 tmp.231 ra.372 tmp.31)))
      (begin
        (set! ra.372 r15)
        (set! c.99 rdi)
        (set! tmp.31 rsi)
        (set! tmp.373 (bitwise-and tmp.31 7))
        (set! tmp.231 tmp.373)
        (if (eq? tmp.231 2)
          (begin
            (set! rsi tmp.31)
            (set! rdi 14)
            (set! r15 ra.372)
            (jump L.jp.82 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.31)
            (set! rdi 6)
            (set! r15 ra.372)
            (jump L.jp.82 rbp r15 rsi rdi)))))
    (define L.fixnum?.60.16
      ((new-frames ()) (locals (tmp.375 tmp.32 c.98 ra.374 tmp.233)))
      (begin
        (set! ra.374 r15)
        (set! c.98 rdi)
        (set! tmp.32 rsi)
        (set! tmp.375 (bitwise-and tmp.32 7))
        (set! tmp.233 tmp.375)
        (if (eq? tmp.233 0)
          (begin (set! rax 14) (jump ra.374 rbp rax))
          (begin (set! rax 6) (jump ra.374 rbp rax)))))
    (define L.boolean?.61.15
      ((new-frames ()) (locals (tmp.377 tmp.33 c.97 ra.376 tmp.235)))
      (begin
        (set! ra.376 r15)
        (set! c.97 rdi)
        (set! tmp.33 rsi)
        (set! tmp.377 (bitwise-and tmp.33 247))
        (set! tmp.235 tmp.377)
        (if (eq? tmp.235 6)
          (begin (set! rax 14) (jump ra.376 rbp rax))
          (begin (set! rax 6) (jump ra.376 rbp rax)))))
    (define L.empty?.62.14
      ((new-frames ()) (locals (tmp.379 tmp.34 c.96 ra.378 tmp.237)))
      (begin
        (set! ra.378 r15)
        (set! c.96 rdi)
        (set! tmp.34 rsi)
        (set! tmp.379 (bitwise-and tmp.34 255))
        (set! tmp.237 tmp.379)
        (if (eq? tmp.237 22)
          (begin (set! rax 14) (jump ra.378 rbp rax))
          (begin (set! rax 6) (jump ra.378 rbp rax)))))
    (define L.void?.63.13
      ((new-frames ()) (locals (tmp.381 tmp.35 c.95 ra.380 tmp.239)))
      (begin
        (set! ra.380 r15)
        (set! c.95 rdi)
        (set! tmp.35 rsi)
        (set! tmp.381 (bitwise-and tmp.35 255))
        (set! tmp.239 tmp.381)
        (if (eq? tmp.239 30)
          (begin (set! rax 14) (jump ra.380 rbp rax))
          (begin (set! rax 6) (jump ra.380 rbp rax)))))
    (define L.ascii-char?.64.12
      ((new-frames ()) (locals (tmp.383 tmp.36 c.94 ra.382 tmp.241)))
      (begin
        (set! ra.382 r15)
        (set! c.94 rdi)
        (set! tmp.36 rsi)
        (set! tmp.383 (bitwise-and tmp.36 255))
        (set! tmp.241 tmp.383)
        (if (eq? tmp.241 46)
          (begin (set! rax 14) (jump ra.382 rbp rax))
          (begin (set! rax 6) (jump ra.382 rbp rax)))))
    (define L.error?.65.11
      ((new-frames ()) (locals (tmp.385 tmp.37 c.93 ra.384 tmp.243)))
      (begin
        (set! ra.384 r15)
        (set! c.93 rdi)
        (set! tmp.37 rsi)
        (set! tmp.385 (bitwise-and tmp.37 255))
        (set! tmp.243 tmp.385)
        (if (eq? tmp.243 62)
          (begin (set! rax 14) (jump ra.384 rbp rax))
          (begin (set! rax 6) (jump ra.384 rbp rax)))))
    (define L.pair?.66.10
      ((new-frames ()) (locals (tmp.387 tmp.38 c.92 ra.386 tmp.245)))
      (begin
        (set! ra.386 r15)
        (set! c.92 rdi)
        (set! tmp.38 rsi)
        (set! tmp.387 (bitwise-and tmp.38 7))
        (set! tmp.245 tmp.387)
        (if (eq? tmp.245 1)
          (begin (set! rax 14) (jump ra.386 rbp rax))
          (begin (set! rax 6) (jump ra.386 rbp rax)))))
    (define L.procedure?.67.9
      ((new-frames ()) (locals (tmp.389 tmp.39 c.91 ra.388 tmp.247)))
      (begin
        (set! ra.388 r15)
        (set! c.91 rdi)
        (set! tmp.39 rsi)
        (set! tmp.389 (bitwise-and tmp.39 7))
        (set! tmp.247 tmp.389)
        (if (eq? tmp.247 2)
          (begin (set! rax 14) (jump ra.388 rbp rax))
          (begin (set! rax 6) (jump ra.388 rbp rax)))))
    (define L.vector?.68.8
      ((new-frames ()) (locals (tmp.391 tmp.40 c.90 ra.390 tmp.249)))
      (begin
        (set! ra.390 r15)
        (set! c.90 rdi)
        (set! tmp.40 rsi)
        (set! tmp.391 (bitwise-and tmp.40 7))
        (set! tmp.249 tmp.391)
        (if (eq? tmp.249 3)
          (begin (set! rax 14) (jump ra.390 rbp rax))
          (begin (set! rax 6) (jump ra.390 rbp rax)))))
    (define L.not.69.7
      ((new-frames ()) (locals (c.89 ra.392 tmp.41)))
      (begin
        (set! ra.392 r15)
        (set! c.89 rdi)
        (set! tmp.41 rsi)
        (if (neq? tmp.41 6)
          (begin (set! rax 6) (jump ra.392 rbp rax))
          (begin (set! rax 14) (jump ra.392 rbp rax)))))
    (define L.cons.70.6
      ((new-frames ())
       (locals (tmp.124 tmp.394 tmp.251 tmp.43 tmp.42 c.88 ra.393)))
      (begin
        (set! ra.393 r15)
        (set! c.88 rdi)
        (set! tmp.42 rsi)
        (set! tmp.43 rdx)
        (set! tmp.251 r12)
        (set! r12 (+ r12 16))
        (set! tmp.394 (+ tmp.251 1))
        (set! tmp.124 tmp.394)
        (mset! tmp.124 -1 tmp.42)
        (mset! tmp.124 7 tmp.43)
        (set! rax tmp.124)
        (jump ra.393 rbp rax)))
    (define L.eq?.71.5
      ((new-frames ()) (locals (c.87 ra.395 tmp.45 tmp.44)))
      (begin
        (set! ra.395 r15)
        (set! c.87 rdi)
        (set! tmp.44 rsi)
        (set! tmp.45 rdx)
        (if (eq? tmp.44 tmp.45)
          (begin (set! rax 14) (jump ra.395 rbp rax))
          (begin (set! rax 6) (jump ra.395 rbp rax)))))
    (define L.make-init-vector.1.4
      ((new-frames ())
       (locals
        (tmp.116
         tmp.73
         tmp.125
         tmp.401
         tmp.256
         tmp.489
         tmp.255
         tmp.400
         tmp.254
         tmp.399
         tmp.398
         tmp.253
         tmp.397
         vector-init-loop.74
         tmp.72
         c.86
         ra.396)))
      (begin
        (set! ra.396 r15)
        (set! c.86 rdi)
        (set! tmp.72 rsi)
        (set! vector-init-loop.74 (mref c.86 14))
        (set! tmp.397 (arithmetic-shift-right tmp.72 3))
        (set! tmp.253 tmp.397)
        (set! tmp.398 1)
        (set! tmp.399 (+ tmp.398 tmp.253))
        (set! tmp.254 tmp.399)
        (set! tmp.400 (* tmp.254 8))
        (set! tmp.255 tmp.400)
        (set! tmp.489 tmp.255)
        (set! tmp.256 r12)
        (set! r12 (+ r12 tmp.489))
        (set! tmp.401 (+ tmp.256 3))
        (set! tmp.125 tmp.401)
        (mset! tmp.125 -3 tmp.72)
        (set! tmp.73 tmp.125)
        (set! tmp.116 vector-init-loop.74)
        (set! rcx tmp.73)
        (set! rdx 0)
        (set! rsi tmp.72)
        (set! rdi vector-init-loop.74)
        (set! r15 ra.396)
        (jump L.vector-init-loop.74.3 rbp r15 rcx rdx rsi rdi)))
    (define L.vector-init-loop.74.3
      ((new-frames ())
       (locals (c.85 ra.402 i.77 len.75 vector-init-loop.74 vec.76)))
      (begin
        (set! ra.402 r15)
        (set! c.85 rdi)
        (set! len.75 rsi)
        (set! i.77 rdx)
        (set! vec.76 rcx)
        (set! vector-init-loop.74 (mref c.85 14))
        (if (eq? len.75 i.77)
          (begin
            (set! r8 vec.76)
            (set! rcx vector-init-loop.74)
            (set! rdx len.75)
            (set! rsi i.77)
            (set! rdi 14)
            (set! r15 ra.402)
            (jump L.jp.95 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 vec.76)
            (set! rcx vector-init-loop.74)
            (set! rdx len.75)
            (set! rsi i.77)
            (set! rdi 6)
            (set! r15 ra.402)
            (jump L.jp.95 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.unsafe-vector-set!.2.2
      ((new-frames ()) (locals (c.84 tmp.270 ra.403 tmp.79 tmp.78 tmp.80)))
      (begin
        (set! ra.403 r15)
        (set! c.84 rdi)
        (set! tmp.78 rsi)
        (set! tmp.79 rdx)
        (set! tmp.80 rcx)
        (set! tmp.270 (mref tmp.78 -3))
        (if (< tmp.79 tmp.270)
          (begin
            (set! rcx tmp.80)
            (set! rdx tmp.78)
            (set! rsi tmp.79)
            (set! rdi 14)
            (set! r15 ra.403)
            (jump L.jp.99 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx tmp.80)
            (set! rdx tmp.78)
            (set! rsi tmp.79)
            (set! rdi 6)
            (set! r15 ra.403)
            (jump L.jp.99 rbp r15 rcx rdx rsi rdi)))))
    (define L.unsafe-vector-ref.3.1
      ((new-frames ()) (locals (c.83 tmp.278 ra.404 tmp.79 tmp.78)))
      (begin
        (set! ra.404 r15)
        (set! c.83 rdi)
        (set! tmp.78 rsi)
        (set! tmp.79 rdx)
        (set! tmp.278 (mref tmp.78 -3))
        (if (< tmp.79 tmp.278)
          (begin
            (set! rdx tmp.78)
            (set! rsi tmp.79)
            (set! rdi 14)
            (set! r15 ra.404)
            (jump L.jp.103 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.78)
            (set! rsi tmp.79)
            (set! rdi 6)
            (set! r15 ra.404)
            (jump L.jp.103 rbp r15 rdx rsi rdi)))))
    (define L.jp.103
      ((new-frames ()) (locals (tmp.272 ra.405 tmp.79 tmp.78)))
      (begin
        (set! ra.405 r15)
        (set! tmp.272 rdi)
        (set! tmp.79 rsi)
        (set! tmp.78 rdx)
        (if (neq? tmp.272 6)
          (if (>= tmp.79 0)
            (begin
              (set! rdx tmp.78)
              (set! rsi tmp.79)
              (set! rdi 14)
              (set! r15 ra.405)
              (jump L.jp.102 rbp r15 rdx rsi rdi))
            (begin
              (set! rdx tmp.78)
              (set! rsi tmp.79)
              (set! rdi 6)
              (set! r15 ra.405)
              (jump L.jp.102 rbp r15 rdx rsi rdi)))
          (begin (set! rax 2622) (jump ra.405 rbp rax)))))
    (define L.jp.102
      ((new-frames ())
       (locals
        (ra.406
         tmp.274
         tmp.78
         tmp.277
         tmp.409
         tmp.276
         tmp.408
         tmp.275
         tmp.407
         tmp.79)))
      (begin
        (set! ra.406 r15)
        (set! tmp.274 rdi)
        (set! tmp.79 rsi)
        (set! tmp.78 rdx)
        (if (neq? tmp.274 6)
          (begin
            (set! tmp.407 (arithmetic-shift-right tmp.79 3))
            (set! tmp.275 tmp.407)
            (set! tmp.408 (* tmp.275 8))
            (set! tmp.276 tmp.408)
            (set! tmp.409 (+ tmp.276 5))
            (set! tmp.277 tmp.409)
            (set! rax (mref tmp.78 tmp.277))
            (jump ra.406 rbp rax))
          (begin (set! rax 2622) (jump ra.406 rbp rax)))))
    (define L.jp.99
      ((new-frames ()) (locals (tmp.264 ra.410 tmp.79 tmp.80 tmp.78)))
      (begin
        (set! ra.410 r15)
        (set! tmp.264 rdi)
        (set! tmp.79 rsi)
        (set! tmp.78 rdx)
        (set! tmp.80 rcx)
        (if (neq? tmp.264 6)
          (if (>= tmp.79 0)
            (begin
              (set! rcx tmp.78)
              (set! rdx tmp.80)
              (set! rsi tmp.79)
              (set! rdi 14)
              (set! r15 ra.410)
              (jump L.jp.98 rbp r15 rcx rdx rsi rdi))
            (begin
              (set! rcx tmp.78)
              (set! rdx tmp.80)
              (set! rsi tmp.79)
              (set! rdi 6)
              (set! r15 ra.410)
              (jump L.jp.98 rbp r15 rcx rdx rsi rdi)))
          (begin (set! rax 2366) (jump ra.410 rbp rax)))))
    (define L.jp.98
      ((new-frames ())
       (locals
        (ra.411
         tmp.266
         tmp.78
         tmp.80
         tmp.269
         tmp.414
         tmp.268
         tmp.413
         tmp.267
         tmp.412
         tmp.79)))
      (begin
        (set! ra.411 r15)
        (set! tmp.266 rdi)
        (set! tmp.79 rsi)
        (set! tmp.80 rdx)
        (set! tmp.78 rcx)
        (if (neq? tmp.266 6)
          (begin
            (set! tmp.412 (arithmetic-shift-right tmp.79 3))
            (set! tmp.267 tmp.412)
            (set! tmp.413 (* tmp.267 8))
            (set! tmp.268 tmp.413)
            (set! tmp.414 (+ tmp.268 5))
            (set! tmp.269 tmp.414)
            (mset! tmp.78 tmp.269 tmp.80)
            (set! rax tmp.78)
            (jump ra.411 rbp rax))
          (begin (set! rax 2366) (jump ra.411 rbp rax)))))
    (define L.jp.95
      ((new-frames ())
       (locals
        (tmp.258
         i.77
         tmp.416
         tmp.259
         tmp.417
         tmp.260
         tmp.418
         tmp.261
         vector-init-loop.74
         tmp.115
         tmp.419
         tmp.262
         len.75
         ra.415
         vec.76)))
      (begin
        (set! ra.415 r15)
        (set! tmp.258 rdi)
        (set! i.77 rsi)
        (set! len.75 rdx)
        (set! vector-init-loop.74 rcx)
        (set! vec.76 r8)
        (if (neq? tmp.258 6)
          (begin (set! rax vec.76) (jump ra.415 rbp rax))
          (begin
            (set! tmp.416 (arithmetic-shift-right i.77 3))
            (set! tmp.259 tmp.416)
            (set! tmp.417 (* tmp.259 8))
            (set! tmp.260 tmp.417)
            (set! tmp.418 (+ tmp.260 5))
            (set! tmp.261 tmp.418)
            (mset! vec.76 tmp.261 0)
            (set! tmp.115 vector-init-loop.74)
            (set! tmp.419 (+ i.77 8))
            (set! tmp.262 tmp.419)
            (set! rcx vec.76)
            (set! rdx tmp.262)
            (set! rsi len.75)
            (set! rdi vector-init-loop.74)
            (set! r15 ra.415)
            (jump L.vector-init-loop.74.3 rbp r15 rcx rdx rsi rdi)))))
    (define L.jp.82
      ((new-frames ()) (locals (ra.420 tmp.230 tmp.31)))
      (begin
        (set! ra.420 r15)
        (set! tmp.230 rdi)
        (set! tmp.31 rsi)
        (if (neq? tmp.230 6)
          (begin (set! rax (mref tmp.31 6)) (jump ra.420 rbp rax))
          (begin (set! rax 3390) (jump ra.420 rbp rax)))))
    (define L.jp.80
      ((new-frames ()) (locals (ra.421 tmp.227 tmp.30)))
      (begin
        (set! ra.421 r15)
        (set! tmp.227 rdi)
        (set! tmp.30 rsi)
        (if (neq? tmp.227 6)
          (begin (set! rax (mref tmp.30 7)) (jump ra.421 rbp rax))
          (begin (set! rax 3134) (jump ra.421 rbp rax)))))
    (define L.jp.78
      ((new-frames ()) (locals (ra.422 tmp.224 tmp.29)))
      (begin
        (set! ra.422 r15)
        (set! tmp.224 rdi)
        (set! tmp.29 rsi)
        (if (neq? tmp.224 6)
          (begin (set! rax (mref tmp.29 -1)) (jump ra.422 rbp rax))
          (begin (set! rax 2878) (jump ra.422 rbp rax)))))
    (define L.jp.76
      ((new-frames ())
       (locals
        (tmp.218 tmp.424 tmp.221 ra.423 unsafe-vector-ref.3 tmp.28 tmp.27)))
      (begin
        (set! ra.423 r15)
        (set! tmp.218 rdi)
        (set! tmp.27 rsi)
        (set! unsafe-vector-ref.3 rdx)
        (set! tmp.28 rcx)
        (if (neq? tmp.218 6)
          (begin
            (set! tmp.424 (bitwise-and tmp.27 7))
            (set! tmp.221 tmp.424)
            (if (eq? tmp.221 3)
              (begin
                (set! rcx tmp.27)
                (set! rdx tmp.28)
                (set! rsi unsafe-vector-ref.3)
                (set! rdi 14)
                (set! r15 ra.423)
                (jump L.jp.75 rbp r15 rcx rdx rsi rdi))
              (begin
                (set! rcx tmp.27)
                (set! rdx tmp.28)
                (set! rsi unsafe-vector-ref.3)
                (set! rdi 6)
                (set! r15 ra.423)
                (jump L.jp.75 rbp r15 rcx rdx rsi rdi))))
          (begin (set! rax 2622) (jump ra.423 rbp rax)))))
    (define L.jp.75
      ((new-frames ())
       (locals (tmp.220 ra.425 tmp.27 tmp.28 tmp.117 unsafe-vector-ref.3)))
      (begin
        (set! ra.425 r15)
        (set! tmp.220 rdi)
        (set! unsafe-vector-ref.3 rsi)
        (set! tmp.28 rdx)
        (set! tmp.27 rcx)
        (if (neq? tmp.220 6)
          (begin
            (set! tmp.117 unsafe-vector-ref.3)
            (set! rdx tmp.28)
            (set! rsi tmp.27)
            (set! rdi unsafe-vector-ref.3)
            (set! r15 ra.425)
            (jump L.unsafe-vector-ref.3.1 rbp r15 rdx rsi rdi))
          (begin (set! rax 2622) (jump ra.425 rbp rax)))))
    (define L.jp.72
      ((new-frames ())
       (locals
        (tmp.212
         tmp.427
         tmp.215
         ra.426
         unsafe-vector-set!.2
         tmp.26
         tmp.25
         tmp.24)))
      (begin
        (set! ra.426 r15)
        (set! tmp.212 rdi)
        (set! tmp.24 rsi)
        (set! unsafe-vector-set!.2 rdx)
        (set! tmp.26 rcx)
        (set! tmp.25 r8)
        (if (neq? tmp.212 6)
          (begin
            (set! tmp.427 (bitwise-and tmp.24 7))
            (set! tmp.215 tmp.427)
            (if (eq? tmp.215 3)
              (begin
                (set! r8 tmp.24)
                (set! rcx tmp.25)
                (set! rdx tmp.26)
                (set! rsi unsafe-vector-set!.2)
                (set! rdi 14)
                (set! r15 ra.426)
                (jump L.jp.71 rbp r15 r8 rcx rdx rsi rdi))
              (begin
                (set! r8 tmp.24)
                (set! rcx tmp.25)
                (set! rdx tmp.26)
                (set! rsi unsafe-vector-set!.2)
                (set! rdi 6)
                (set! r15 ra.426)
                (jump L.jp.71 rbp r15 r8 rcx rdx rsi rdi))))
          (begin (set! rax 2366) (jump ra.426 rbp rax)))))
    (define L.jp.71
      ((new-frames ())
       (locals
        (tmp.214 ra.428 tmp.24 tmp.25 tmp.26 tmp.118 unsafe-vector-set!.2)))
      (begin
        (set! ra.428 r15)
        (set! tmp.214 rdi)
        (set! unsafe-vector-set!.2 rsi)
        (set! tmp.26 rdx)
        (set! tmp.25 rcx)
        (set! tmp.24 r8)
        (if (neq? tmp.214 6)
          (begin
            (set! tmp.118 unsafe-vector-set!.2)
            (set! rcx tmp.26)
            (set! rdx tmp.25)
            (set! rsi tmp.24)
            (set! rdi unsafe-vector-set!.2)
            (set! r15 ra.428)
            (jump L.unsafe-vector-set!.2.2 rbp r15 rcx rdx rsi rdi))
          (begin (set! rax 2366) (jump ra.428 rbp rax)))))
    (define L.jp.68
      ((new-frames ()) (locals (ra.429 tmp.209 tmp.23)))
      (begin
        (set! ra.429 r15)
        (set! tmp.209 rdi)
        (set! tmp.23 rsi)
        (if (neq? tmp.209 6)
          (begin (set! rax (mref tmp.23 -3)) (jump ra.429 rbp rax))
          (begin (set! rax 2110) (jump ra.429 rbp rax)))))
    (define L.jp.66
      ((new-frames ())
       (locals (tmp.206 ra.430 tmp.22 tmp.119 make-init-vector.1)))
      (begin
        (set! ra.430 r15)
        (set! tmp.206 rdi)
        (set! make-init-vector.1 rsi)
        (set! tmp.22 rdx)
        (if (neq? tmp.206 6)
          (begin
            (set! tmp.119 make-init-vector.1)
            (set! rsi tmp.22)
            (set! rdi make-init-vector.1)
            (set! r15 ra.430)
            (jump L.make-init-vector.1.4 rbp r15 rsi rdi))
          (begin (set! rax 1854) (jump ra.430 rbp rax)))))
    (define L.jp.64
      ((new-frames ()) (locals (tmp.199 tmp.432 tmp.203 ra.431 tmp.20 tmp.21)))
      (begin
        (set! ra.431 r15)
        (set! tmp.199 rdi)
        (set! tmp.20 rsi)
        (set! tmp.21 rdx)
        (if (neq? tmp.199 6)
          (begin
            (set! tmp.432 (bitwise-and tmp.20 7))
            (set! tmp.203 tmp.432)
            (if (eq? tmp.203 0)
              (begin
                (set! rdx tmp.21)
                (set! rsi tmp.20)
                (set! rdi 14)
                (set! r15 ra.431)
                (jump L.jp.63 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.21)
                (set! rsi tmp.20)
                (set! rdi 6)
                (set! r15 ra.431)
                (jump L.jp.63 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1598) (jump ra.431 rbp rax)))))
    (define L.jp.63
      ((new-frames ()) (locals (ra.433 tmp.201 tmp.21 tmp.20)))
      (begin
        (set! ra.433 r15)
        (set! tmp.201 rdi)
        (set! tmp.20 rsi)
        (set! tmp.21 rdx)
        (if (neq? tmp.201 6)
          (if (>= tmp.20 tmp.21)
            (begin (set! rax 14) (jump ra.433 rbp rax))
            (begin (set! rax 6) (jump ra.433 rbp rax)))
          (begin (set! rax 1598) (jump ra.433 rbp rax)))))
    (define L.jp.59
      ((new-frames ()) (locals (tmp.192 tmp.435 tmp.196 ra.434 tmp.18 tmp.19)))
      (begin
        (set! ra.434 r15)
        (set! tmp.192 rdi)
        (set! tmp.18 rsi)
        (set! tmp.19 rdx)
        (if (neq? tmp.192 6)
          (begin
            (set! tmp.435 (bitwise-and tmp.18 7))
            (set! tmp.196 tmp.435)
            (if (eq? tmp.196 0)
              (begin
                (set! rdx tmp.19)
                (set! rsi tmp.18)
                (set! rdi 14)
                (set! r15 ra.434)
                (jump L.jp.58 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.19)
                (set! rsi tmp.18)
                (set! rdi 6)
                (set! r15 ra.434)
                (jump L.jp.58 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1342) (jump ra.434 rbp rax)))))
    (define L.jp.58
      ((new-frames ()) (locals (ra.436 tmp.194 tmp.19 tmp.18)))
      (begin
        (set! ra.436 r15)
        (set! tmp.194 rdi)
        (set! tmp.18 rsi)
        (set! tmp.19 rdx)
        (if (neq? tmp.194 6)
          (if (> tmp.18 tmp.19)
            (begin (set! rax 14) (jump ra.436 rbp rax))
            (begin (set! rax 6) (jump ra.436 rbp rax)))
          (begin (set! rax 1342) (jump ra.436 rbp rax)))))
    (define L.jp.54
      ((new-frames ()) (locals (tmp.185 tmp.438 tmp.189 ra.437 tmp.16 tmp.17)))
      (begin
        (set! ra.437 r15)
        (set! tmp.185 rdi)
        (set! tmp.16 rsi)
        (set! tmp.17 rdx)
        (if (neq? tmp.185 6)
          (begin
            (set! tmp.438 (bitwise-and tmp.16 7))
            (set! tmp.189 tmp.438)
            (if (eq? tmp.189 0)
              (begin
                (set! rdx tmp.17)
                (set! rsi tmp.16)
                (set! rdi 14)
                (set! r15 ra.437)
                (jump L.jp.53 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.17)
                (set! rsi tmp.16)
                (set! rdi 6)
                (set! r15 ra.437)
                (jump L.jp.53 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1086) (jump ra.437 rbp rax)))))
    (define L.jp.53
      ((new-frames ()) (locals (ra.439 tmp.187 tmp.17 tmp.16)))
      (begin
        (set! ra.439 r15)
        (set! tmp.187 rdi)
        (set! tmp.16 rsi)
        (set! tmp.17 rdx)
        (if (neq? tmp.187 6)
          (if (<= tmp.16 tmp.17)
            (begin (set! rax 14) (jump ra.439 rbp rax))
            (begin (set! rax 6) (jump ra.439 rbp rax)))
          (begin (set! rax 1086) (jump ra.439 rbp rax)))))
    (define L.jp.49
      ((new-frames ()) (locals (tmp.178 tmp.441 tmp.182 ra.440 tmp.14 tmp.15)))
      (begin
        (set! ra.440 r15)
        (set! tmp.178 rdi)
        (set! tmp.14 rsi)
        (set! tmp.15 rdx)
        (if (neq? tmp.178 6)
          (begin
            (set! tmp.441 (bitwise-and tmp.14 7))
            (set! tmp.182 tmp.441)
            (if (eq? tmp.182 0)
              (begin
                (set! rdx tmp.15)
                (set! rsi tmp.14)
                (set! rdi 14)
                (set! r15 ra.440)
                (jump L.jp.48 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.15)
                (set! rsi tmp.14)
                (set! rdi 6)
                (set! r15 ra.440)
                (jump L.jp.48 rbp r15 rdx rsi rdi))))
          (begin (set! rax 830) (jump ra.440 rbp rax)))))
    (define L.jp.48
      ((new-frames ()) (locals (ra.442 tmp.180 tmp.15 tmp.14)))
      (begin
        (set! ra.442 r15)
        (set! tmp.180 rdi)
        (set! tmp.14 rsi)
        (set! tmp.15 rdx)
        (if (neq? tmp.180 6)
          (if (< tmp.14 tmp.15)
            (begin (set! rax 14) (jump ra.442 rbp rax))
            (begin (set! rax 6) (jump ra.442 rbp rax)))
          (begin (set! rax 830) (jump ra.442 rbp rax)))))
    (define L.jp.44
      ((new-frames ()) (locals (tmp.172 tmp.444 tmp.175 ra.443 tmp.12 tmp.13)))
      (begin
        (set! ra.443 r15)
        (set! tmp.172 rdi)
        (set! tmp.12 rsi)
        (set! tmp.13 rdx)
        (if (neq? tmp.172 6)
          (begin
            (set! tmp.444 (bitwise-and tmp.12 7))
            (set! tmp.175 tmp.444)
            (if (eq? tmp.175 0)
              (begin
                (set! rdx tmp.13)
                (set! rsi tmp.12)
                (set! rdi 14)
                (set! r15 ra.443)
                (jump L.jp.43 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.13)
                (set! rsi tmp.12)
                (set! rdi 6)
                (set! r15 ra.443)
                (jump L.jp.43 rbp r15 rdx rsi rdi))))
          (begin (set! rax 574) (jump ra.443 rbp rax)))))
    (define L.jp.43
      ((new-frames ()) (locals (ra.445 tmp.174 tmp.446 tmp.12 tmp.13)))
      (begin
        (set! ra.445 r15)
        (set! tmp.174 rdi)
        (set! tmp.12 rsi)
        (set! tmp.13 rdx)
        (if (neq? tmp.174 6)
          (begin
            (set! tmp.446 (- tmp.12 tmp.13))
            (set! rax tmp.446)
            (jump ra.445 rbp rax))
          (begin (set! rax 574) (jump ra.445 rbp rax)))))
    (define L.jp.40
      ((new-frames ()) (locals (tmp.166 tmp.448 tmp.169 ra.447 tmp.10 tmp.11)))
      (begin
        (set! ra.447 r15)
        (set! tmp.166 rdi)
        (set! tmp.10 rsi)
        (set! tmp.11 rdx)
        (if (neq? tmp.166 6)
          (begin
            (set! tmp.448 (bitwise-and tmp.10 7))
            (set! tmp.169 tmp.448)
            (if (eq? tmp.169 0)
              (begin
                (set! rdx tmp.11)
                (set! rsi tmp.10)
                (set! rdi 14)
                (set! r15 ra.447)
                (jump L.jp.39 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.11)
                (set! rsi tmp.10)
                (set! rdi 6)
                (set! r15 ra.447)
                (jump L.jp.39 rbp r15 rdx rsi rdi))))
          (begin (set! rax 318) (jump ra.447 rbp rax)))))
    (define L.jp.39
      ((new-frames ()) (locals (ra.449 tmp.168 tmp.450 tmp.10 tmp.11)))
      (begin
        (set! ra.449 r15)
        (set! tmp.168 rdi)
        (set! tmp.10 rsi)
        (set! tmp.11 rdx)
        (if (neq? tmp.168 6)
          (begin
            (set! tmp.450 (+ tmp.10 tmp.11))
            (set! rax tmp.450)
            (jump ra.449 rbp rax))
          (begin (set! rax 318) (jump ra.449 rbp rax)))))
    (define L.jp.36
      ((new-frames ()) (locals (tmp.159 tmp.452 tmp.163 ra.451 tmp.9 tmp.8)))
      (begin
        (set! ra.451 r15)
        (set! tmp.159 rdi)
        (set! tmp.8 rsi)
        (set! tmp.9 rdx)
        (if (neq? tmp.159 6)
          (begin
            (set! tmp.452 (bitwise-and tmp.8 7))
            (set! tmp.163 tmp.452)
            (if (eq? tmp.163 0)
              (begin
                (set! rdx tmp.8)
                (set! rsi tmp.9)
                (set! rdi 14)
                (set! r15 ra.451)
                (jump L.jp.35 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.8)
                (set! rsi tmp.9)
                (set! rdi 6)
                (set! r15 ra.451)
                (jump L.jp.35 rbp r15 rdx rsi rdi))))
          (begin (set! rax 62) (jump ra.451 rbp rax)))))
    (define L.jp.35
      ((new-frames ())
       (locals (ra.453 tmp.161 tmp.455 tmp.8 tmp.162 tmp.454 tmp.9)))
      (begin
        (set! ra.453 r15)
        (set! tmp.161 rdi)
        (set! tmp.9 rsi)
        (set! tmp.8 rdx)
        (if (neq? tmp.161 6)
          (begin
            (set! tmp.454 (arithmetic-shift-right tmp.9 3))
            (set! tmp.162 tmp.454)
            (set! tmp.455 (* tmp.8 tmp.162))
            (set! rax tmp.455)
            (jump ra.453 rbp rax))
          (begin (set! rax 62) (jump ra.453 rbp rax))))))
     ) 2))


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
     (execute '(module (letrec (
    (|-.184| (lambda (x.331 y.332) (if (fixnum? y.332) (if (fixnum? x.331) (unsafe-fx- x.331 y.332) (error 2)) (error 2))))) 
    (let () (let () (letrec ((two.140 (lambda () (apply i.139 2))) (i.139 (lambda (x.141) (apply |-.184| x.141 0)))) (let () (let ((x.142 (apply two.140))) (apply i.139 x.142))))))))
     ) 2))


#;(parameterize ([current-pass-list
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
  (define L.two.5.32
    (lambda (c.114)
      (let ((i.4 (unsafe-procedure-ref c.114 0)))
        (let ((tmp.121 i.4)) (apply L.i.4.31 i.4 2)))))
  (define L.i.4.31
    (lambda (c.113 x.6)
      (let ((|-.48| (unsafe-procedure-ref c.113 0)))
        (let ((tmp.120 |-.48|)) (apply L.-.48.28 |-.48| x.6 0)))))
  (define L.*.46.30
    (lambda (c.112 tmp.8 tmp.9)
      (if (fixnum? tmp.9)
        (if (fixnum? tmp.8) (unsafe-fx* tmp.8 tmp.9) (error 0))
        (error 0))))
  (define L.+.47.29
    (lambda (c.111 tmp.10 tmp.11)
      (if (fixnum? tmp.11)
        (if (fixnum? tmp.10) (unsafe-fx+ tmp.10 tmp.11) (error 1))
        (error 1))))
  (define L.-.48.28
    (lambda (c.110 tmp.12 tmp.13)
      (if (fixnum? tmp.13)
        (if (fixnum? tmp.12) (unsafe-fx- tmp.12 tmp.13) (error 2))
        (error 2))))
  (define L.<.49.27
    (lambda (c.109 tmp.14 tmp.15)
      (if (fixnum? tmp.15)
        (if (fixnum? tmp.14) (unsafe-fx< tmp.14 tmp.15) (error 3))
        (error 3))))
  (define L.<=.50.26
    (lambda (c.108 tmp.16 tmp.17)
      (if (fixnum? tmp.17)
        (if (fixnum? tmp.16) (unsafe-fx<= tmp.16 tmp.17) (error 4))
        (error 4))))
  (define L.>.51.25
    (lambda (c.107 tmp.18 tmp.19)
      (if (fixnum? tmp.19)
        (if (fixnum? tmp.18) (unsafe-fx> tmp.18 tmp.19) (error 5))
        (error 5))))
  (define L.>=.52.24
    (lambda (c.106 tmp.20 tmp.21)
      (if (fixnum? tmp.21)
        (if (fixnum? tmp.20) (unsafe-fx>= tmp.20 tmp.21) (error 6))
        (error 6))))
  (define L.make-vector.53.23
    (lambda (c.105 tmp.22)
      (let ((make-init-vector.1 (unsafe-procedure-ref c.105 0)))
        (if (fixnum? tmp.22)
          (let ((tmp.119 make-init-vector.1))
            (apply L.make-init-vector.1.4 make-init-vector.1 tmp.22))
          (error 7)))))
  (define L.vector-length.54.22
    (lambda (c.104 tmp.23)
      (if (vector? tmp.23) (unsafe-vector-length tmp.23) (error 8))))
  (define L.vector-set!.55.21
    (lambda (c.103 tmp.24 tmp.25 tmp.26)
      (let ((unsafe-vector-set!.2 (unsafe-procedure-ref c.103 0)))
        (if (fixnum? tmp.25)
          (if (vector? tmp.24)
            (let ((tmp.118 unsafe-vector-set!.2))
              (apply
               L.unsafe-vector-set!.2.2
               unsafe-vector-set!.2
               tmp.24
               tmp.25
               tmp.26))
            (error 9))
          (error 9)))))
  (define L.vector-ref.56.20
    (lambda (c.102 tmp.27 tmp.28)
      (let ((unsafe-vector-ref.3 (unsafe-procedure-ref c.102 0)))
        (if (fixnum? tmp.28)
          (if (vector? tmp.27)
            (let ((tmp.117 unsafe-vector-ref.3))
              (apply
               L.unsafe-vector-ref.3.1
               unsafe-vector-ref.3
               tmp.27
               tmp.28))
            (error 10))
          (error 10)))))
  (define L.car.57.19
    (lambda (c.101 tmp.29) (if (pair? tmp.29) (unsafe-car tmp.29) (error 11))))
  (define L.cdr.58.18
    (lambda (c.100 tmp.30) (if (pair? tmp.30) (unsafe-cdr tmp.30) (error 12))))
  (define L.procedure-arity.59.17
    (lambda (c.99 tmp.31)
      (if (procedure? tmp.31) (unsafe-procedure-arity tmp.31) (error 13))))
  (define L.fixnum?.60.16 (lambda (c.98 tmp.32) (fixnum? tmp.32)))
  (define L.boolean?.61.15 (lambda (c.97 tmp.33) (boolean? tmp.33)))
  (define L.empty?.62.14 (lambda (c.96 tmp.34) (empty? tmp.34)))
  (define L.void?.63.13 (lambda (c.95 tmp.35) (void? tmp.35)))
  (define L.ascii-char?.64.12 (lambda (c.94 tmp.36) (ascii-char? tmp.36)))
  (define L.error?.65.11 (lambda (c.93 tmp.37) (error? tmp.37)))
  (define L.pair?.66.10 (lambda (c.92 tmp.38) (pair? tmp.38)))
  (define L.procedure?.67.9 (lambda (c.91 tmp.39) (procedure? tmp.39)))
  (define L.vector?.68.8 (lambda (c.90 tmp.40) (vector? tmp.40)))
  (define L.not.69.7 (lambda (c.89 tmp.41) (not tmp.41)))
  (define L.cons.70.6 (lambda (c.88 tmp.42 tmp.43) (cons tmp.42 tmp.43)))
  (define L.eq?.71.5 (lambda (c.87 tmp.44 tmp.45) (eq? tmp.44 tmp.45)))
  (define L.make-init-vector.1.4
    (lambda (c.86 tmp.72)
      (let ((vector-init-loop.74 (unsafe-procedure-ref c.86 0)))
        (let ((tmp.73 (unsafe-make-vector tmp.72)))
          (let ((tmp.116 vector-init-loop.74))
            (apply
             L.vector-init-loop.74.3
             vector-init-loop.74
             tmp.72
             0
             tmp.73))))))
  (define L.vector-init-loop.74.3
    (lambda (c.85 len.75 i.77 vec.76)
      (let ((vector-init-loop.74 (unsafe-procedure-ref c.85 0)))
        (if (eq? len.75 i.77)
          vec.76
          (begin
            (unsafe-vector-set! vec.76 i.77 0)
            (let ((tmp.115 vector-init-loop.74))
              (apply
               L.vector-init-loop.74.3
               vector-init-loop.74
               len.75
               (unsafe-fx+ i.77 1)
               vec.76)))))))
  (define L.unsafe-vector-set!.2.2
    (lambda (c.84 tmp.78 tmp.79 tmp.80)
      (if (unsafe-fx< tmp.79 (unsafe-vector-length tmp.78))
        (if (unsafe-fx>= tmp.79 0)
          (begin (unsafe-vector-set! tmp.78 tmp.79 tmp.80) tmp.78)
          (error 9))
        (error 9))))
  (define L.unsafe-vector-ref.3.1
    (lambda (c.83 tmp.78 tmp.79)
      (if (unsafe-fx< tmp.79 (unsafe-vector-length tmp.78))
        (if (unsafe-fx>= tmp.79 0)
          (unsafe-vector-ref tmp.78 tmp.79)
          (error 10))
        (error 10))))
  (let ((unsafe-vector-ref.3 (make-procedure L.unsafe-vector-ref.3.1 2 0)))
    (let ((unsafe-vector-set!.2 (make-procedure L.unsafe-vector-set!.2.2 3 0)))
      (let ((vector-init-loop.74 (make-procedure L.vector-init-loop.74.3 3 1)))
        (let ((make-init-vector.1 (make-procedure L.make-init-vector.1.4 1 1)))
          (let ((eq?.71 (make-procedure L.eq?.71.5 2 0)))
            (let ((cons.70 (make-procedure L.cons.70.6 2 0)))
              (let ((not.69 (make-procedure L.not.69.7 1 0)))
                (let ((vector?.68 (make-procedure L.vector?.68.8 1 0)))
                  (let ((procedure?.67 (make-procedure L.procedure?.67.9 1 0)))
                    (let ((pair?.66 (make-procedure L.pair?.66.10 1 0)))
                      (let ((error?.65 (make-procedure L.error?.65.11 1 0)))
                        (let ((ascii-char?.64
                               (make-procedure L.ascii-char?.64.12 1 0)))
                          (let ((void?.63 (make-procedure L.void?.63.13 1 0)))
                            (let ((empty?.62
                                   (make-procedure L.empty?.62.14 1 0)))
                              (let ((boolean?.61
                                     (make-procedure L.boolean?.61.15 1 0)))
                                (let ((fixnum?.60
                                       (make-procedure L.fixnum?.60.16 1 0)))
                                  (let ((procedure-arity.59
                                         (make-procedure
                                          L.procedure-arity.59.17
                                          1
                                          0)))
                                    (let ((cdr.58
                                           (make-procedure L.cdr.58.18 1 0)))
                                      (let ((car.57
                                             (make-procedure L.car.57.19 1 0)))
                                        (let ((vector-ref.56
                                               (make-procedure
                                                L.vector-ref.56.20
                                                2
                                                1)))
                                          (let ((vector-set!.55
                                                 (make-procedure
                                                  L.vector-set!.55.21
                                                  3
                                                  1)))
                                            (let ((vector-length.54
                                                   (make-procedure
                                                    L.vector-length.54.22
                                                    1
                                                    0)))
                                              (let ((make-vector.53
                                                     (make-procedure
                                                      L.make-vector.53.23
                                                      1
                                                      1)))
                                                (let ((>=.52
                                                       (make-procedure
                                                        L.>=.52.24
                                                        2
                                                        0)))
                                                  (let ((>.51
                                                         (make-procedure
                                                          L.>.51.25
                                                          2
                                                          0)))
                                                    (let ((<=.50
                                                           (make-procedure
                                                            L.<=.50.26
                                                            2
                                                            0)))
                                                      (let ((<.49
                                                             (make-procedure
                                                              L.<.49.27
                                                              2
                                                              0)))
                                                        (let ((|-.48|
                                                               (make-procedure
                                                                L.-.48.28
                                                                2
                                                                0)))
                                                          (let ((+.47
                                                                 (make-procedure
                                                                  L.+.47.29
                                                                  2
                                                                  0)))
                                                            (let ((*.46
                                                                   (make-procedure
                                                                    L.*.46.30
                                                                    2
                                                                    0)))
                                                              (begin
                                                                (begin)
                                                                (begin)
                                                                (begin
                                                                  (unsafe-procedure-set!
                                                                   vector-init-loop.74
                                                                   0
                                                                   vector-init-loop.74))
                                                                (begin
                                                                  (unsafe-procedure-set!
                                                                   make-init-vector.1
                                                                   0
                                                                   vector-init-loop.74))
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
                                                                   vector-ref.56
                                                                   0
                                                                   unsafe-vector-ref.3))
                                                                (begin
                                                                  (unsafe-procedure-set!
                                                                   vector-set!.55
                                                                   0
                                                                   unsafe-vector-set!.2))
                                                                (begin)
                                                                (begin
                                                                  (unsafe-procedure-set!
                                                                   make-vector.53
                                                                   0
                                                                   make-init-vector.1))
                                                                (begin)
                                                                (begin)
                                                                (begin)
                                                                (begin)
                                                                (begin)
                                                                (begin)
                                                                (begin)
                                                                (let ((i.4
                                                                       (make-procedure
                                                                        L.i.4.31
                                                                        1
                                                                        1)))
                                                                  (let ((two.5
                                                                         (make-procedure
                                                                          L.two.5.32
                                                                          0
                                                                          1)))
                                                                    (begin
                                                                      (begin
                                                                        (unsafe-procedure-set!
                                                                         i.4
                                                                         0
                                                                         |-.48|))
                                                                      (begin
                                                                        (unsafe-procedure-set!
                                                                         two.5
                                                                         0
                                                                         i.4))
                                                                      (let ((x.7
                                                                             (let ((tmp.122
                                                                                    two.5))
                                                                               (apply
                                                                                L.two.5.32
                                                                                two.5))))
                                                                        (let ((tmp.123
                                                                               i.4))
                                                                          (apply
                                                                           L.i.4.31
                                                                           i.4
                                                                           x.7))))))))))))))))))))))))))))))))))))))
     ) 2))

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
     (execute '(module
                              (define i (lambda (x) (- x 0)))
                              (define two (lambda () (i 2)))
                              (let ((x (two))) (i x)))
     ) 2))

)


#|
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
     (execute
     ) 2))
|#