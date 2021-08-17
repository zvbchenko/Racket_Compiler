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
     ) 120))

(parameterize ([current-pass-list
                  (list
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute 
     ) 120))

(parameterize ([current-pass-list
                  (list
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute 
     ) 120))

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
     ) 120))

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
     ) 120))

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
     ) 120))



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
     ) 120))



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
     ) 120))

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
     ) 120)

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
     ) 120)

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
     ) 120)

  )
  |#

  (parameterize ([current-pass-list
                  (list
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
    (define L.main.120
      ((new-frames ()))
      (begin
        (set! ra.350 r15)
        (set! tmp.312 (alloc 16))
        (set! tmp.351 (+ tmp.312 2))
        (set! tmp.135 tmp.351)
        (mset! tmp.135 -2 L.unsafe-vector-ref.3.1)
        (mset! tmp.135 6 16)
        (set! unsafe-vector-ref.3 tmp.135)
        (set! tmp.313 (alloc 16))
        (set! tmp.352 (+ tmp.313 2))
        (set! tmp.136 tmp.352)
        (mset! tmp.136 -2 L.unsafe-vector-set!.2.2)
        (mset! tmp.136 6 24)
        (set! unsafe-vector-set!.2 tmp.136)
        (set! tmp.314 (alloc 24))
        (set! tmp.353 (+ tmp.314 2))
        (set! tmp.137 tmp.353)
        (mset! tmp.137 -2 L.vector-init-loop.80.3)
        (mset! tmp.137 6 24)
        (set! vector-init-loop.80 tmp.137)
        (set! tmp.315 (alloc 24))
        (set! tmp.354 (+ tmp.315 2))
        (set! tmp.138 tmp.354)
        (mset! tmp.138 -2 L.make-init-vector.1.4)
        (mset! tmp.138 6 8)
        (set! make-init-vector.1 tmp.138)
        (set! tmp.316 (alloc 16))
        (set! tmp.355 (+ tmp.316 2))
        (set! tmp.139 tmp.355)
        (mset! tmp.139 -2 L.eq?.77.5)
        (mset! tmp.139 6 16)
        (set! eq?.77 tmp.139)
        (set! tmp.317 (alloc 16))
        (set! tmp.356 (+ tmp.317 2))
        (set! tmp.140 tmp.356)
        (mset! tmp.140 -2 L.cons.76.6)
        (mset! tmp.140 6 16)
        (set! cons.76 tmp.140)
        (set! tmp.318 (alloc 16))
        (set! tmp.357 (+ tmp.318 2))
        (set! tmp.141 tmp.357)
        (mset! tmp.141 -2 L.not.75.7)
        (mset! tmp.141 6 8)
        (set! not.75 tmp.141)
        (set! tmp.319 (alloc 16))
        (set! tmp.358 (+ tmp.319 2))
        (set! tmp.142 tmp.358)
        (mset! tmp.142 -2 L.vector?.74.8)
        (mset! tmp.142 6 8)
        (set! vector?.74 tmp.142)
        (set! tmp.320 (alloc 16))
        (set! tmp.359 (+ tmp.320 2))
        (set! tmp.143 tmp.359)
        (mset! tmp.143 -2 L.procedure?.73.9)
        (mset! tmp.143 6 8)
        (set! procedure?.73 tmp.143)
        (set! tmp.321 (alloc 16))
        (set! tmp.360 (+ tmp.321 2))
        (set! tmp.144 tmp.360)
        (mset! tmp.144 -2 L.pair?.72.10)
        (mset! tmp.144 6 8)
        (set! pair?.72 tmp.144)
        (set! tmp.322 (alloc 16))
        (set! tmp.361 (+ tmp.322 2))
        (set! tmp.145 tmp.361)
        (mset! tmp.145 -2 L.error?.71.11)
        (mset! tmp.145 6 8)
        (set! error?.71 tmp.145)
        (set! tmp.323 (alloc 16))
        (set! tmp.362 (+ tmp.323 2))
        (set! tmp.146 tmp.362)
        (mset! tmp.146 -2 L.ascii-char?.70.12)
        (mset! tmp.146 6 8)
        (set! ascii-char?.70 tmp.146)
        (set! tmp.324 (alloc 16))
        (set! tmp.363 (+ tmp.324 2))
        (set! tmp.147 tmp.363)
        (mset! tmp.147 -2 L.void?.69.13)
        (mset! tmp.147 6 8)
        (set! void?.69 tmp.147)
        (set! tmp.325 (alloc 16))
        (set! tmp.364 (+ tmp.325 2))
        (set! tmp.148 tmp.364)
        (mset! tmp.148 -2 L.empty?.68.14)
        (mset! tmp.148 6 8)
        (set! empty?.68 tmp.148)
        (set! tmp.326 (alloc 16))
        (set! tmp.365 (+ tmp.326 2))
        (set! tmp.149 tmp.365)
        (mset! tmp.149 -2 L.boolean?.67.15)
        (mset! tmp.149 6 8)
        (set! boolean?.67 tmp.149)
        (set! tmp.327 (alloc 16))
        (set! tmp.366 (+ tmp.327 2))
        (set! tmp.150 tmp.366)
        (mset! tmp.150 -2 L.fixnum?.66.16)
        (mset! tmp.150 6 8)
        (set! fixnum?.66 tmp.150)
        (set! tmp.328 (alloc 16))
        (set! tmp.367 (+ tmp.328 2))
        (set! tmp.151 tmp.367)
        (mset! tmp.151 -2 L.procedure-arity.65.17)
        (mset! tmp.151 6 8)
        (set! procedure-arity.65 tmp.151)
        (set! tmp.329 (alloc 16))
        (set! tmp.368 (+ tmp.329 2))
        (set! tmp.152 tmp.368)
        (mset! tmp.152 -2 L.cdr.64.18)
        (mset! tmp.152 6 8)
        (set! cdr.64 tmp.152)
        (set! tmp.330 (alloc 16))
        (set! tmp.369 (+ tmp.330 2))
        (set! tmp.153 tmp.369)
        (mset! tmp.153 -2 L.car.63.19)
        (mset! tmp.153 6 8)
        (set! car.63 tmp.153)
        (set! tmp.331 (alloc 24))
        (set! tmp.370 (+ tmp.331 2))
        (set! tmp.154 tmp.370)
        (mset! tmp.154 -2 L.vector-ref.62.20)
        (mset! tmp.154 6 16)
        (set! vector-ref.62 tmp.154)
        (set! tmp.332 (alloc 24))
        (set! tmp.371 (+ tmp.332 2))
        (set! tmp.155 tmp.371)
        (mset! tmp.155 -2 L.vector-set!.61.21)
        (mset! tmp.155 6 24)
        (set! vector-set!.61 tmp.155)
        (set! tmp.333 (alloc 16))
        (set! tmp.372 (+ tmp.333 2))
        (set! tmp.156 tmp.372)
        (mset! tmp.156 -2 L.vector-length.60.22)
        (mset! tmp.156 6 8)
        (set! vector-length.60 tmp.156)
        (set! tmp.334 (alloc 24))
        (set! tmp.373 (+ tmp.334 2))
        (set! tmp.157 tmp.373)
        (mset! tmp.157 -2 L.make-vector.59.23)
        (mset! tmp.157 6 8)
        (set! make-vector.59 tmp.157)
        (set! tmp.335 (alloc 16))
        (set! tmp.374 (+ tmp.335 2))
        (set! tmp.158 tmp.374)
        (mset! tmp.158 -2 L.>=.58.24)
        (mset! tmp.158 6 16)
        (set! >=.58 tmp.158)
        (set! tmp.336 (alloc 16))
        (set! tmp.375 (+ tmp.336 2))
        (set! tmp.159 tmp.375)
        (mset! tmp.159 -2 L.>.57.25)
        (mset! tmp.159 6 16)
        (set! >.57 tmp.159)
        (set! tmp.337 (alloc 16))
        (set! tmp.376 (+ tmp.337 2))
        (set! tmp.160 tmp.376)
        (mset! tmp.160 -2 L.<=.56.26)
        (mset! tmp.160 6 16)
        (set! <=.56 tmp.160)
        (set! tmp.338 (alloc 16))
        (set! tmp.377 (+ tmp.338 2))
        (set! tmp.161 tmp.377)
        (mset! tmp.161 -2 L.<.55.27)
        (mset! tmp.161 6 16)
        (set! <.55 tmp.161)
        (set! tmp.339 (alloc 16))
        (set! tmp.378 (+ tmp.339 2))
        (set! tmp.162 tmp.378)
        (mset! tmp.162 -2 L.-.54.28)
        (mset! tmp.162 6 16)
        (set! |-.54| tmp.162)
        (set! tmp.340 (alloc 16))
        (set! tmp.379 (+ tmp.340 2))
        (set! tmp.163 tmp.379)
        (mset! tmp.163 -2 L.+.53.29)
        (mset! tmp.163 6 16)
        (set! |+.53| tmp.163)
        (set! tmp.341 (alloc 16))
        (set! tmp.380 (+ tmp.341 2))
        (set! tmp.164 tmp.380)
        (mset! tmp.164 -2 L.*.52.30)
        (mset! tmp.164 6 16)
        (set! *.52 tmp.164)
        (mset! vector-init-loop.80 14 vector-init-loop.80)
        (mset! make-init-vector.1 14 vector-init-loop.80)
        (mset! vector-ref.62 14 unsafe-vector-ref.3)
        (mset! vector-set!.61 14 unsafe-vector-set!.2)
        (mset! make-vector.59 14 make-init-vector.1)
        (set! tmp.342 (alloc 48))
        (set! tmp.381 (+ tmp.342 2))
        (set! tmp.165 tmp.381)
        (mset! tmp.165 -2 L.error.4.31)
        (mset! tmp.165 6 8)
        (set! error.4 tmp.165)
        (mset! error.4 14 eq?.77)
        (mset! error.4 22 *.52)
        (mset! error.4 30 error.4)
        (mset! error.4 38 |-.54|)
        (set! let.12 40)
        (set! define.13 error.4)
        (set! tmp.132 define.13)
        (set! tmp.382 (bitwise-and tmp.132 7))
        (set! tmp.349 tmp.382)
        (if (eq? tmp.349 2)
          (begin
            (set! rcx define.13)
            (set! rdx let.12)
            (set! rsi tmp.132)
            (set! rdi 14)
            (set! r15 ra.350)
            (jump L.jp.119 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx define.13)
            (set! rdx let.12)
            (set! rsi tmp.132)
            (set! rdi 6)
            (set! r15 ra.350)
            (jump L.jp.119 rbp r15 rcx rdx rsi rdi)))))
    (define L.error.4.31
      ((new-frames ()))
      (begin
        (set! ra.383 r15)
        (set! c.122 rdi)
        (set! define.5 rsi)
        (set! eq?.77 (mref c.122 14))
        (set! *.52 (mref c.122 22))
        (set! error.4 (mref c.122 30))
        (set! |-.54| (mref c.122 38))
        (set! not.6 eq?.77)
        (set! letrec.7 |-.54|)
        (set! eq?.8 8)
        (set! apply.9 0)
        (set! lambda.10 define.5)
        (set! let.11 *.52)
        (set! tmp.129 not.6)
        (set! tmp.384 (bitwise-and tmp.129 7))
        (set! tmp.190 tmp.384)
        (if (eq? tmp.190 2)
          (begin
            (set! fv3 not.6)
            (set! fv2 define.5)
            (set! fv1 apply.9)
            (set! fv0 eq?.8)
            (set! r9 letrec.7)
            (set! r8 lambda.10)
            (set! rcx error.4)
            (set! rdx let.11)
            (set! rsi tmp.129)
            (set! rdi 14)
            (set! r15 ra.383)
            (jump L.jp.44 rbp r15 fv0 fv1 fv2 fv3 r9 r8 rcx rdx rsi rdi))
          (begin
            (set! fv3 not.6)
            (set! fv2 define.5)
            (set! fv1 apply.9)
            (set! fv0 eq?.8)
            (set! r9 letrec.7)
            (set! r8 lambda.10)
            (set! rcx error.4)
            (set! rdx let.11)
            (set! rsi tmp.129)
            (set! rdi 6)
            (set! r15 ra.383)
            (jump L.jp.44 rbp r15 fv0 fv1 fv2 fv3 r9 r8 rcx rdx rsi rdi)))))
    (define L.*.52.30
      ((new-frames ()))
      (begin
        (set! ra.385 r15)
        (set! c.121 rdi)
        (set! tmp.14 rsi)
        (set! tmp.15 rdx)
        (set! tmp.386 (bitwise-and tmp.15 7))
        (set! tmp.197 tmp.386)
        (if (eq? tmp.197 0)
          (begin
            (set! rdx tmp.15)
            (set! rsi tmp.14)
            (set! rdi 14)
            (set! r15 ra.385)
            (jump L.jp.48 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.15)
            (set! rsi tmp.14)
            (set! rdi 6)
            (set! r15 ra.385)
            (jump L.jp.48 rbp r15 rdx rsi rdi)))))
    (define L.+.53.29
      ((new-frames ()))
      (begin
        (set! ra.387 r15)
        (set! c.120 rdi)
        (set! tmp.16 rsi)
        (set! tmp.17 rdx)
        (set! tmp.388 (bitwise-and tmp.17 7))
        (set! tmp.203 tmp.388)
        (if (eq? tmp.203 0)
          (begin
            (set! rdx tmp.17)
            (set! rsi tmp.16)
            (set! rdi 14)
            (set! r15 ra.387)
            (jump L.jp.52 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.17)
            (set! rsi tmp.16)
            (set! rdi 6)
            (set! r15 ra.387)
            (jump L.jp.52 rbp r15 rdx rsi rdi)))))
    (define L.-.54.28
      ((new-frames ()))
      (begin
        (set! ra.389 r15)
        (set! c.119 rdi)
        (set! tmp.18 rsi)
        (set! tmp.19 rdx)
        (set! tmp.390 (bitwise-and tmp.19 7))
        (set! tmp.209 tmp.390)
        (if (eq? tmp.209 0)
          (begin
            (set! rdx tmp.19)
            (set! rsi tmp.18)
            (set! rdi 14)
            (set! r15 ra.389)
            (jump L.jp.56 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.19)
            (set! rsi tmp.18)
            (set! rdi 6)
            (set! r15 ra.389)
            (jump L.jp.56 rbp r15 rdx rsi rdi)))))
    (define L.<.55.27
      ((new-frames ()))
      (begin
        (set! ra.391 r15)
        (set! c.118 rdi)
        (set! tmp.20 rsi)
        (set! tmp.21 rdx)
        (set! tmp.392 (bitwise-and tmp.21 7))
        (set! tmp.216 tmp.392)
        (if (eq? tmp.216 0)
          (begin
            (set! rdx tmp.21)
            (set! rsi tmp.20)
            (set! rdi 14)
            (set! r15 ra.391)
            (jump L.jp.61 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.21)
            (set! rsi tmp.20)
            (set! rdi 6)
            (set! r15 ra.391)
            (jump L.jp.61 rbp r15 rdx rsi rdi)))))
    (define L.<=.56.26
      ((new-frames ()))
      (begin
        (set! ra.393 r15)
        (set! c.117 rdi)
        (set! tmp.22 rsi)
        (set! tmp.23 rdx)
        (set! tmp.394 (bitwise-and tmp.23 7))
        (set! tmp.223 tmp.394)
        (if (eq? tmp.223 0)
          (begin
            (set! rdx tmp.23)
            (set! rsi tmp.22)
            (set! rdi 14)
            (set! r15 ra.393)
            (jump L.jp.66 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.23)
            (set! rsi tmp.22)
            (set! rdi 6)
            (set! r15 ra.393)
            (jump L.jp.66 rbp r15 rdx rsi rdi)))))
    (define L.>.57.25
      ((new-frames ()))
      (begin
        (set! ra.395 r15)
        (set! c.116 rdi)
        (set! tmp.24 rsi)
        (set! tmp.25 rdx)
        (set! tmp.396 (bitwise-and tmp.25 7))
        (set! tmp.230 tmp.396)
        (if (eq? tmp.230 0)
          (begin
            (set! rdx tmp.25)
            (set! rsi tmp.24)
            (set! rdi 14)
            (set! r15 ra.395)
            (jump L.jp.71 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.25)
            (set! rsi tmp.24)
            (set! rdi 6)
            (set! r15 ra.395)
            (jump L.jp.71 rbp r15 rdx rsi rdi)))))
    (define L.>=.58.24
      ((new-frames ()))
      (begin
        (set! ra.397 r15)
        (set! c.115 rdi)
        (set! tmp.26 rsi)
        (set! tmp.27 rdx)
        (set! tmp.398 (bitwise-and tmp.27 7))
        (set! tmp.237 tmp.398)
        (if (eq? tmp.237 0)
          (begin
            (set! rdx tmp.27)
            (set! rsi tmp.26)
            (set! rdi 14)
            (set! r15 ra.397)
            (jump L.jp.76 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.27)
            (set! rsi tmp.26)
            (set! rdi 6)
            (set! r15 ra.397)
            (jump L.jp.76 rbp r15 rdx rsi rdi)))))
    (define L.make-vector.59.23
      ((new-frames ()))
      (begin
        (set! ra.399 r15)
        (set! c.114 rdi)
        (set! tmp.28 rsi)
        (set! make-init-vector.1 (mref c.114 14))
        (set! tmp.400 (bitwise-and tmp.28 7))
        (set! tmp.240 tmp.400)
        (if (eq? tmp.240 0)
          (begin
            (set! rdx tmp.28)
            (set! rsi make-init-vector.1)
            (set! rdi 14)
            (set! r15 ra.399)
            (jump L.jp.78 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.28)
            (set! rsi make-init-vector.1)
            (set! rdi 6)
            (set! r15 ra.399)
            (jump L.jp.78 rbp r15 rdx rsi rdi)))))
    (define L.vector-length.60.22
      ((new-frames ()))
      (begin
        (set! ra.401 r15)
        (set! c.113 rdi)
        (set! tmp.29 rsi)
        (set! tmp.402 (bitwise-and tmp.29 7))
        (set! tmp.243 tmp.402)
        (if (eq? tmp.243 3)
          (begin
            (set! rsi tmp.29)
            (set! rdi 14)
            (set! r15 ra.401)
            (jump L.jp.80 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.29)
            (set! rdi 6)
            (set! r15 ra.401)
            (jump L.jp.80 rbp r15 rsi rdi)))))
    (define L.vector-set!.61.21
      ((new-frames ()))
      (begin
        (set! ra.403 r15)
        (set! c.112 rdi)
        (set! tmp.30 rsi)
        (set! tmp.31 rdx)
        (set! tmp.32 rcx)
        (set! unsafe-vector-set!.2 (mref c.112 14))
        (set! tmp.404 (bitwise-and tmp.31 7))
        (set! tmp.249 tmp.404)
        (if (eq? tmp.249 0)
          (begin
            (set! r8 tmp.31)
            (set! rcx tmp.32)
            (set! rdx unsafe-vector-set!.2)
            (set! rsi tmp.30)
            (set! rdi 14)
            (set! r15 ra.403)
            (jump L.jp.84 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 tmp.31)
            (set! rcx tmp.32)
            (set! rdx unsafe-vector-set!.2)
            (set! rsi tmp.30)
            (set! rdi 6)
            (set! r15 ra.403)
            (jump L.jp.84 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.vector-ref.62.20
      ((new-frames ()))
      (begin
        (set! ra.405 r15)
        (set! c.111 rdi)
        (set! tmp.33 rsi)
        (set! tmp.34 rdx)
        (set! unsafe-vector-ref.3 (mref c.111 14))
        (set! tmp.406 (bitwise-and tmp.34 7))
        (set! tmp.255 tmp.406)
        (if (eq? tmp.255 0)
          (begin
            (set! rcx tmp.34)
            (set! rdx unsafe-vector-ref.3)
            (set! rsi tmp.33)
            (set! rdi 14)
            (set! r15 ra.405)
            (jump L.jp.88 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx tmp.34)
            (set! rdx unsafe-vector-ref.3)
            (set! rsi tmp.33)
            (set! rdi 6)
            (set! r15 ra.405)
            (jump L.jp.88 rbp r15 rcx rdx rsi rdi)))))
    (define L.car.63.19
      ((new-frames ()))
      (begin
        (set! ra.407 r15)
        (set! c.110 rdi)
        (set! tmp.35 rsi)
        (set! tmp.408 (bitwise-and tmp.35 7))
        (set! tmp.258 tmp.408)
        (if (eq? tmp.258 1)
          (begin
            (set! rsi tmp.35)
            (set! rdi 14)
            (set! r15 ra.407)
            (jump L.jp.90 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.35)
            (set! rdi 6)
            (set! r15 ra.407)
            (jump L.jp.90 rbp r15 rsi rdi)))))
    (define L.cdr.64.18
      ((new-frames ()))
      (begin
        (set! ra.409 r15)
        (set! c.109 rdi)
        (set! tmp.36 rsi)
        (set! tmp.410 (bitwise-and tmp.36 7))
        (set! tmp.261 tmp.410)
        (if (eq? tmp.261 1)
          (begin
            (set! rsi tmp.36)
            (set! rdi 14)
            (set! r15 ra.409)
            (jump L.jp.92 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.36)
            (set! rdi 6)
            (set! r15 ra.409)
            (jump L.jp.92 rbp r15 rsi rdi)))))
    (define L.procedure-arity.65.17
      ((new-frames ()))
      (begin
        (set! ra.411 r15)
        (set! c.108 rdi)
        (set! tmp.37 rsi)
        (set! tmp.412 (bitwise-and tmp.37 7))
        (set! tmp.264 tmp.412)
        (if (eq? tmp.264 2)
          (begin
            (set! rsi tmp.37)
            (set! rdi 14)
            (set! r15 ra.411)
            (jump L.jp.94 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.37)
            (set! rdi 6)
            (set! r15 ra.411)
            (jump L.jp.94 rbp r15 rsi rdi)))))
    (define L.fixnum?.66.16
      ((new-frames ()))
      (begin
        (set! ra.413 r15)
        (set! c.107 rdi)
        (set! tmp.38 rsi)
        (set! tmp.414 (bitwise-and tmp.38 7))
        (set! tmp.266 tmp.414)
        (if (eq? tmp.266 0)
          (begin (set! rax 14) (jump ra.413 rbp rax))
          (begin (set! rax 6) (jump ra.413 rbp rax)))))
    (define L.boolean?.67.15
      ((new-frames ()))
      (begin
        (set! ra.415 r15)
        (set! c.106 rdi)
        (set! tmp.39 rsi)
        (set! tmp.416 (bitwise-and tmp.39 247))
        (set! tmp.268 tmp.416)
        (if (eq? tmp.268 6)
          (begin (set! rax 14) (jump ra.415 rbp rax))
          (begin (set! rax 6) (jump ra.415 rbp rax)))))
    (define L.empty?.68.14
      ((new-frames ()))
      (begin
        (set! ra.417 r15)
        (set! c.105 rdi)
        (set! tmp.40 rsi)
        (set! tmp.418 (bitwise-and tmp.40 255))
        (set! tmp.270 tmp.418)
        (if (eq? tmp.270 22)
          (begin (set! rax 14) (jump ra.417 rbp rax))
          (begin (set! rax 6) (jump ra.417 rbp rax)))))
    (define L.void?.69.13
      ((new-frames ()))
      (begin
        (set! ra.419 r15)
        (set! c.104 rdi)
        (set! tmp.41 rsi)
        (set! tmp.420 (bitwise-and tmp.41 255))
        (set! tmp.272 tmp.420)
        (if (eq? tmp.272 30)
          (begin (set! rax 14) (jump ra.419 rbp rax))
          (begin (set! rax 6) (jump ra.419 rbp rax)))))
    (define L.ascii-char?.70.12
      ((new-frames ()))
      (begin
        (set! ra.421 r15)
        (set! c.103 rdi)
        (set! tmp.42 rsi)
        (set! tmp.422 (bitwise-and tmp.42 255))
        (set! tmp.274 tmp.422)
        (if (eq? tmp.274 46)
          (begin (set! rax 14) (jump ra.421 rbp rax))
          (begin (set! rax 6) (jump ra.421 rbp rax)))))
    (define L.error?.71.11
      ((new-frames ()))
      (begin
        (set! ra.423 r15)
        (set! c.102 rdi)
        (set! tmp.43 rsi)
        (set! tmp.424 (bitwise-and tmp.43 255))
        (set! tmp.276 tmp.424)
        (if (eq? tmp.276 62)
          (begin (set! rax 14) (jump ra.423 rbp rax))
          (begin (set! rax 6) (jump ra.423 rbp rax)))))
    (define L.pair?.72.10
      ((new-frames ()))
      (begin
        (set! ra.425 r15)
        (set! c.101 rdi)
        (set! tmp.44 rsi)
        (set! tmp.426 (bitwise-and tmp.44 7))
        (set! tmp.278 tmp.426)
        (if (eq? tmp.278 1)
          (begin (set! rax 14) (jump ra.425 rbp rax))
          (begin (set! rax 6) (jump ra.425 rbp rax)))))
    (define L.procedure?.73.9
      ((new-frames ()))
      (begin
        (set! ra.427 r15)
        (set! c.100 rdi)
        (set! tmp.45 rsi)
        (set! tmp.428 (bitwise-and tmp.45 7))
        (set! tmp.280 tmp.428)
        (if (eq? tmp.280 2)
          (begin (set! rax 14) (jump ra.427 rbp rax))
          (begin (set! rax 6) (jump ra.427 rbp rax)))))
    (define L.vector?.74.8
      ((new-frames ()))
      (begin
        (set! ra.429 r15)
        (set! c.99 rdi)
        (set! tmp.46 rsi)
        (set! tmp.430 (bitwise-and tmp.46 7))
        (set! tmp.282 tmp.430)
        (if (eq? tmp.282 3)
          (begin (set! rax 14) (jump ra.429 rbp rax))
          (begin (set! rax 6) (jump ra.429 rbp rax)))))
    (define L.not.75.7
      ((new-frames ()))
      (begin
        (set! ra.431 r15)
        (set! c.98 rdi)
        (set! tmp.47 rsi)
        (if (neq? tmp.47 6)
          (begin (set! rax 6) (jump ra.431 rbp rax))
          (begin (set! rax 14) (jump ra.431 rbp rax)))))
    (define L.cons.76.6
      ((new-frames ()))
      (begin
        (set! ra.432 r15)
        (set! c.97 rdi)
        (set! tmp.48 rsi)
        (set! tmp.49 rdx)
        (set! tmp.284 (alloc 16))
        (set! tmp.433 (+ tmp.284 1))
        (set! tmp.133 tmp.433)
        (mset! tmp.133 -1 tmp.48)
        (mset! tmp.133 7 tmp.49)
        (set! rax tmp.133)
        (jump ra.432 rbp rax)))
    (define L.eq?.77.5
      ((new-frames ()))
      (begin
        (set! ra.434 r15)
        (set! c.96 rdi)
        (set! tmp.50 rsi)
        (set! tmp.51 rdx)
        (if (eq? tmp.50 tmp.51)
          (begin (set! rax 14) (jump ra.434 rbp rax))
          (begin (set! rax 6) (jump ra.434 rbp rax)))))
    (define L.make-init-vector.1.4
      ((new-frames ()))
      (begin
        (set! ra.435 r15)
        (set! c.95 rdi)
        (set! tmp.78 rsi)
        (set! vector-init-loop.80 (mref c.95 14))
        (set! tmp.436 (arithmetic-shift-right tmp.78 3))
        (set! tmp.286 tmp.436)
        (set! tmp.437 1)
        (set! tmp.438 (+ tmp.437 tmp.286))
        (set! tmp.287 tmp.438)
        (set! tmp.439 (* tmp.287 8))
        (set! tmp.288 tmp.439)
        (set! tmp.289 (alloc tmp.288))
        (set! tmp.440 (+ tmp.289 3))
        (set! tmp.134 tmp.440)
        (mset! tmp.134 -3 tmp.78)
        (set! tmp.79 tmp.134)
        (set! tmp.124 vector-init-loop.80)
        (set! rcx tmp.79)
        (set! rdx 0)
        (set! rsi tmp.78)
        (set! rdi vector-init-loop.80)
        (set! r15 ra.435)
        (jump L.vector-init-loop.80.3 rbp r15 rcx rdx rsi rdi)))
    (define L.vector-init-loop.80.3
      ((new-frames ()))
      (begin
        (set! ra.441 r15)
        (set! c.94 rdi)
        (set! len.81 rsi)
        (set! i.83 rdx)
        (set! vec.82 rcx)
        (set! vector-init-loop.80 (mref c.94 14))
        (if (eq? len.81 i.83)
          (begin
            (set! r8 vec.82)
            (set! rcx vector-init-loop.80)
            (set! rdx len.81)
            (set! rsi i.83)
            (set! rdi 14)
            (set! r15 ra.441)
            (jump L.jp.107 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 vec.82)
            (set! rcx vector-init-loop.80)
            (set! rdx len.81)
            (set! rsi i.83)
            (set! rdi 6)
            (set! r15 ra.441)
            (jump L.jp.107 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.unsafe-vector-set!.2.2
      ((new-frames ()))
      (begin
        (set! ra.442 r15)
        (set! c.93 rdi)
        (set! tmp.89 rsi)
        (set! tmp.90 rdx)
        (set! tmp.91 rcx)
        (set! tmp.303 (mref tmp.89 -3))
        (if (< tmp.90 tmp.303)
          (begin
            (set! rcx tmp.89)
            (set! rdx tmp.91)
            (set! rsi tmp.90)
            (set! rdi 14)
            (set! r15 ra.442)
            (jump L.jp.111 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx tmp.89)
            (set! rdx tmp.91)
            (set! rsi tmp.90)
            (set! rdi 6)
            (set! r15 ra.442)
            (jump L.jp.111 rbp r15 rcx rdx rsi rdi)))))
    (define L.unsafe-vector-ref.3.1
      ((new-frames ()))
      (begin
        (set! ra.443 r15)
        (set! c.92 rdi)
        (set! tmp.86 rsi)
        (set! tmp.87 rdx)
        (set! tmp.311 (mref tmp.86 -3))
        (if (< tmp.87 tmp.311)
          (begin
            (set! rdx tmp.86)
            (set! rsi tmp.87)
            (set! rdi 14)
            (set! r15 ra.443)
            (jump L.jp.115 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.86)
            (set! rsi tmp.87)
            (set! rdi 6)
            (set! r15 ra.443)
            (jump L.jp.115 rbp r15 rdx rsi rdi)))))
    (define L.jp.119
      ((new-frames ()))
      (begin
        (set! ra.444 r15)
        (set! tmp.344 rdi)
        (set! tmp.132 rsi)
        (set! let.12 rdx)
        (set! define.13 rcx)
        (if (neq? tmp.344 6)
          (begin
            (set! tmp.348 (mref tmp.132 6))
            (if (eq? tmp.348 8)
              (begin
                (set! rcx define.13)
                (set! rdx let.12)
                (set! rsi tmp.132)
                (set! rdi 14)
                (set! r15 ra.444)
                (jump L.jp.118 rbp r15 rcx rdx rsi rdi))
              (begin
                (set! rcx define.13)
                (set! rdx let.12)
                (set! rsi tmp.132)
                (set! rdi 6)
                (set! r15 ra.444)
                (jump L.jp.118 rbp r15 rcx rdx rsi rdi))))
          (begin (set! rax 11070) (jump ra.444 rbp rax)))))
    (define L.jp.118
      ((new-frames ()))
      (begin
        (set! ra.445 r15)
        (set! tmp.346 rdi)
        (set! tmp.132 rsi)
        (set! let.12 rdx)
        (set! define.13 rcx)
        (if (neq? tmp.346 6)
          (begin
            (set! tmp.347 (mref tmp.132 -2))
            (set! rsi let.12)
            (set! rdi define.13)
            (set! r15 ra.445)
            (jump tmp.347 rbp r15 rsi rdi))
          (begin (set! rax 10814) (jump ra.445 rbp rax)))))
    (define L.jp.115
      ((new-frames ()))
      (begin
        (set! ra.446 r15)
        (set! tmp.305 rdi)
        (set! tmp.87 rsi)
        (set! tmp.86 rdx)
        (if (neq? tmp.305 6)
          (if (>= tmp.87 0)
            (begin
              (set! rdx tmp.86)
              (set! rsi tmp.87)
              (set! rdi 14)
              (set! r15 ra.446)
              (jump L.jp.114 rbp r15 rdx rsi rdi))
            (begin
              (set! rdx tmp.86)
              (set! rsi tmp.87)
              (set! rdi 6)
              (set! r15 ra.446)
              (jump L.jp.114 rbp r15 rdx rsi rdi)))
          (begin (set! rax 2622) (jump ra.446 rbp rax)))))
    (define L.jp.114
      ((new-frames ()))
      (begin
        (set! ra.447 r15)
        (set! tmp.307 rdi)
        (set! tmp.87 rsi)
        (set! tmp.86 rdx)
        (if (neq? tmp.307 6)
          (begin
            (set! tmp.448 (arithmetic-shift-right tmp.87 3))
            (set! tmp.308 tmp.448)
            (set! tmp.449 (* tmp.308 8))
            (set! tmp.309 tmp.449)
            (set! tmp.450 (+ tmp.309 5))
            (set! tmp.310 tmp.450)
            (set! rax (mref tmp.86 tmp.310))
            (jump ra.447 rbp rax))
          (begin (set! rax 2622) (jump ra.447 rbp rax)))))
    (define L.jp.111
      ((new-frames ()))
      (begin
        (set! ra.451 r15)
        (set! tmp.297 rdi)
        (set! tmp.90 rsi)
        (set! tmp.91 rdx)
        (set! tmp.89 rcx)
        (if (neq? tmp.297 6)
          (if (>= tmp.90 0)
            (begin
              (set! rcx tmp.91)
              (set! rdx tmp.89)
              (set! rsi tmp.90)
              (set! rdi 14)
              (set! r15 ra.451)
              (jump L.jp.110 rbp r15 rcx rdx rsi rdi))
            (begin
              (set! rcx tmp.91)
              (set! rdx tmp.89)
              (set! rsi tmp.90)
              (set! rdi 6)
              (set! r15 ra.451)
              (jump L.jp.110 rbp r15 rcx rdx rsi rdi)))
          (begin (set! rax 2366) (jump ra.451 rbp rax)))))
    (define L.jp.110
      ((new-frames ()))
      (begin
        (set! ra.452 r15)
        (set! tmp.299 rdi)
        (set! tmp.90 rsi)
        (set! tmp.89 rdx)
        (set! tmp.91 rcx)
        (if (neq? tmp.299 6)
          (begin
            (set! tmp.453 (arithmetic-shift-right tmp.90 3))
            (set! tmp.300 tmp.453)
            (set! tmp.454 (* tmp.300 8))
            (set! tmp.301 tmp.454)
            (set! tmp.455 (+ tmp.301 5))
            (set! tmp.302 tmp.455)
            (mset! tmp.89 tmp.302 tmp.91)
            (set! rax 30)
            (jump ra.452 rbp rax))
          (begin (set! rax 2366) (jump ra.452 rbp rax)))))
    (define L.jp.107
      ((new-frames ()))
      (begin
        (set! ra.456 r15)
        (set! tmp.291 rdi)
        (set! i.83 rsi)
        (set! len.81 rdx)
        (set! vector-init-loop.80 rcx)
        (set! vec.82 r8)
        (if (neq? tmp.291 6)
          (begin (set! rax vec.82) (jump ra.456 rbp rax))
          (begin
            (set! tmp.457 (arithmetic-shift-right i.83 3))
            (set! tmp.292 tmp.457)
            (set! tmp.458 (* tmp.292 8))
            (set! tmp.293 tmp.458)
            (set! tmp.459 (+ tmp.293 5))
            (set! tmp.294 tmp.459)
            (mset! vec.82 tmp.294 0)
            (set! tmp.123 vector-init-loop.80)
            (set! tmp.460 (+ i.83 8))
            (set! tmp.295 tmp.460)
            (set! rcx vec.82)
            (set! rdx tmp.295)
            (set! rsi len.81)
            (set! rdi vector-init-loop.80)
            (set! r15 ra.456)
            (jump L.vector-init-loop.80.3 rbp r15 rcx rdx rsi rdi)))))
    (define L.jp.94
      ((new-frames ()))
      (begin
        (set! ra.461 r15)
        (set! tmp.263 rdi)
        (set! tmp.37 rsi)
        (if (neq? tmp.263 6)
          (begin (set! rax (mref tmp.37 6)) (jump ra.461 rbp rax))
          (begin (set! rax 3390) (jump ra.461 rbp rax)))))
    (define L.jp.92
      ((new-frames ()))
      (begin
        (set! ra.462 r15)
        (set! tmp.260 rdi)
        (set! tmp.36 rsi)
        (if (neq? tmp.260 6)
          (begin (set! rax (mref tmp.36 7)) (jump ra.462 rbp rax))
          (begin (set! rax 3134) (jump ra.462 rbp rax)))))
    (define L.jp.90
      ((new-frames ()))
      (begin
        (set! ra.463 r15)
        (set! tmp.257 rdi)
        (set! tmp.35 rsi)
        (if (neq? tmp.257 6)
          (begin (set! rax (mref tmp.35 -1)) (jump ra.463 rbp rax))
          (begin (set! rax 2878) (jump ra.463 rbp rax)))))
    (define L.jp.88
      ((new-frames ()))
      (begin
        (set! ra.464 r15)
        (set! tmp.251 rdi)
        (set! tmp.33 rsi)
        (set! unsafe-vector-ref.3 rdx)
        (set! tmp.34 rcx)
        (if (neq? tmp.251 6)
          (begin
            (set! tmp.465 (bitwise-and tmp.33 7))
            (set! tmp.254 tmp.465)
            (if (eq? tmp.254 3)
              (begin
                (set! rcx tmp.33)
                (set! rdx tmp.34)
                (set! rsi unsafe-vector-ref.3)
                (set! rdi 14)
                (set! r15 ra.464)
                (jump L.jp.87 rbp r15 rcx rdx rsi rdi))
              (begin
                (set! rcx tmp.33)
                (set! rdx tmp.34)
                (set! rsi unsafe-vector-ref.3)
                (set! rdi 6)
                (set! r15 ra.464)
                (jump L.jp.87 rbp r15 rcx rdx rsi rdi))))
          (begin (set! rax 2622) (jump ra.464 rbp rax)))))
    (define L.jp.87
      ((new-frames ()))
      (begin
        (set! ra.466 r15)
        (set! tmp.253 rdi)
        (set! unsafe-vector-ref.3 rsi)
        (set! tmp.34 rdx)
        (set! tmp.33 rcx)
        (if (neq? tmp.253 6)
          (begin
            (set! tmp.125 unsafe-vector-ref.3)
            (set! rdx tmp.34)
            (set! rsi tmp.33)
            (set! rdi unsafe-vector-ref.3)
            (set! r15 ra.466)
            (jump L.unsafe-vector-ref.3.1 rbp r15 rdx rsi rdi))
          (begin (set! rax 2622) (jump ra.466 rbp rax)))))
    (define L.jp.84
      ((new-frames ()))
      (begin
        (set! ra.467 r15)
        (set! tmp.245 rdi)
        (set! tmp.30 rsi)
        (set! unsafe-vector-set!.2 rdx)
        (set! tmp.32 rcx)
        (set! tmp.31 r8)
        (if (neq? tmp.245 6)
          (begin
            (set! tmp.468 (bitwise-and tmp.30 7))
            (set! tmp.248 tmp.468)
            (if (eq? tmp.248 3)
              (begin
                (set! r8 tmp.30)
                (set! rcx tmp.31)
                (set! rdx tmp.32)
                (set! rsi unsafe-vector-set!.2)
                (set! rdi 14)
                (set! r15 ra.467)
                (jump L.jp.83 rbp r15 r8 rcx rdx rsi rdi))
              (begin
                (set! r8 tmp.30)
                (set! rcx tmp.31)
                (set! rdx tmp.32)
                (set! rsi unsafe-vector-set!.2)
                (set! rdi 6)
                (set! r15 ra.467)
                (jump L.jp.83 rbp r15 r8 rcx rdx rsi rdi))))
          (begin (set! rax 2366) (jump ra.467 rbp rax)))))
    (define L.jp.83
      ((new-frames ()))
      (begin
        (set! ra.469 r15)
        (set! tmp.247 rdi)
        (set! unsafe-vector-set!.2 rsi)
        (set! tmp.32 rdx)
        (set! tmp.31 rcx)
        (set! tmp.30 r8)
        (if (neq? tmp.247 6)
          (begin
            (set! tmp.126 unsafe-vector-set!.2)
            (set! rcx tmp.32)
            (set! rdx tmp.31)
            (set! rsi tmp.30)
            (set! rdi unsafe-vector-set!.2)
            (set! r15 ra.469)
            (jump L.unsafe-vector-set!.2.2 rbp r15 rcx rdx rsi rdi))
          (begin (set! rax 2366) (jump ra.469 rbp rax)))))
    (define L.jp.80
      ((new-frames ()))
      (begin
        (set! ra.470 r15)
        (set! tmp.242 rdi)
        (set! tmp.29 rsi)
        (if (neq? tmp.242 6)
          (begin (set! rax (mref tmp.29 -3)) (jump ra.470 rbp rax))
          (begin (set! rax 2110) (jump ra.470 rbp rax)))))
    (define L.jp.78
      ((new-frames ()))
      (begin
        (set! ra.471 r15)
        (set! tmp.239 rdi)
        (set! make-init-vector.1 rsi)
        (set! tmp.28 rdx)
        (if (neq? tmp.239 6)
          (begin
            (set! tmp.127 make-init-vector.1)
            (set! rsi tmp.28)
            (set! rdi make-init-vector.1)
            (set! r15 ra.471)
            (jump L.make-init-vector.1.4 rbp r15 rsi rdi))
          (begin (set! rax 1854) (jump ra.471 rbp rax)))))
    (define L.jp.76
      ((new-frames ()))
      (begin
        (set! ra.472 r15)
        (set! tmp.232 rdi)
        (set! tmp.26 rsi)
        (set! tmp.27 rdx)
        (if (neq? tmp.232 6)
          (begin
            (set! tmp.473 (bitwise-and tmp.26 7))
            (set! tmp.236 tmp.473)
            (if (eq? tmp.236 0)
              (begin
                (set! rdx tmp.27)
                (set! rsi tmp.26)
                (set! rdi 14)
                (set! r15 ra.472)
                (jump L.jp.75 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.27)
                (set! rsi tmp.26)
                (set! rdi 6)
                (set! r15 ra.472)
                (jump L.jp.75 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1598) (jump ra.472 rbp rax)))))
    (define L.jp.75
      ((new-frames ()))
      (begin
        (set! ra.474 r15)
        (set! tmp.234 rdi)
        (set! tmp.26 rsi)
        (set! tmp.27 rdx)
        (if (neq? tmp.234 6)
          (if (>= tmp.26 tmp.27)
            (begin (set! rax 14) (jump ra.474 rbp rax))
            (begin (set! rax 6) (jump ra.474 rbp rax)))
          (begin (set! rax 1598) (jump ra.474 rbp rax)))))
    (define L.jp.71
      ((new-frames ()))
      (begin
        (set! ra.475 r15)
        (set! tmp.225 rdi)
        (set! tmp.24 rsi)
        (set! tmp.25 rdx)
        (if (neq? tmp.225 6)
          (begin
            (set! tmp.476 (bitwise-and tmp.24 7))
            (set! tmp.229 tmp.476)
            (if (eq? tmp.229 0)
              (begin
                (set! rdx tmp.25)
                (set! rsi tmp.24)
                (set! rdi 14)
                (set! r15 ra.475)
                (jump L.jp.70 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.25)
                (set! rsi tmp.24)
                (set! rdi 6)
                (set! r15 ra.475)
                (jump L.jp.70 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1342) (jump ra.475 rbp rax)))))
    (define L.jp.70
      ((new-frames ()))
      (begin
        (set! ra.477 r15)
        (set! tmp.227 rdi)
        (set! tmp.24 rsi)
        (set! tmp.25 rdx)
        (if (neq? tmp.227 6)
          (if (> tmp.24 tmp.25)
            (begin (set! rax 14) (jump ra.477 rbp rax))
            (begin (set! rax 6) (jump ra.477 rbp rax)))
          (begin (set! rax 1342) (jump ra.477 rbp rax)))))
    (define L.jp.66
      ((new-frames ()))
      (begin
        (set! ra.478 r15)
        (set! tmp.218 rdi)
        (set! tmp.22 rsi)
        (set! tmp.23 rdx)
        (if (neq? tmp.218 6)
          (begin
            (set! tmp.479 (bitwise-and tmp.22 7))
            (set! tmp.222 tmp.479)
            (if (eq? tmp.222 0)
              (begin
                (set! rdx tmp.23)
                (set! rsi tmp.22)
                (set! rdi 14)
                (set! r15 ra.478)
                (jump L.jp.65 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.23)
                (set! rsi tmp.22)
                (set! rdi 6)
                (set! r15 ra.478)
                (jump L.jp.65 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1086) (jump ra.478 rbp rax)))))
    (define L.jp.65
      ((new-frames ()))
      (begin
        (set! ra.480 r15)
        (set! tmp.220 rdi)
        (set! tmp.22 rsi)
        (set! tmp.23 rdx)
        (if (neq? tmp.220 6)
          (if (<= tmp.22 tmp.23)
            (begin (set! rax 14) (jump ra.480 rbp rax))
            (begin (set! rax 6) (jump ra.480 rbp rax)))
          (begin (set! rax 1086) (jump ra.480 rbp rax)))))
    (define L.jp.61
      ((new-frames ()))
      (begin
        (set! ra.481 r15)
        (set! tmp.211 rdi)
        (set! tmp.20 rsi)
        (set! tmp.21 rdx)
        (if (neq? tmp.211 6)
          (begin
            (set! tmp.482 (bitwise-and tmp.20 7))
            (set! tmp.215 tmp.482)
            (if (eq? tmp.215 0)
              (begin
                (set! rdx tmp.21)
                (set! rsi tmp.20)
                (set! rdi 14)
                (set! r15 ra.481)
                (jump L.jp.60 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.21)
                (set! rsi tmp.20)
                (set! rdi 6)
                (set! r15 ra.481)
                (jump L.jp.60 rbp r15 rdx rsi rdi))))
          (begin (set! rax 830) (jump ra.481 rbp rax)))))
    (define L.jp.60
      ((new-frames ()))
      (begin
        (set! ra.483 r15)
        (set! tmp.213 rdi)
        (set! tmp.20 rsi)
        (set! tmp.21 rdx)
        (if (neq? tmp.213 6)
          (if (< tmp.20 tmp.21)
            (begin (set! rax 14) (jump ra.483 rbp rax))
            (begin (set! rax 6) (jump ra.483 rbp rax)))
          (begin (set! rax 830) (jump ra.483 rbp rax)))))
    (define L.jp.56
      ((new-frames ()))
      (begin
        (set! ra.484 r15)
        (set! tmp.205 rdi)
        (set! tmp.18 rsi)
        (set! tmp.19 rdx)
        (if (neq? tmp.205 6)
          (begin
            (set! tmp.485 (bitwise-and tmp.18 7))
            (set! tmp.208 tmp.485)
            (if (eq? tmp.208 0)
              (begin
                (set! rdx tmp.19)
                (set! rsi tmp.18)
                (set! rdi 14)
                (set! r15 ra.484)
                (jump L.jp.55 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.19)
                (set! rsi tmp.18)
                (set! rdi 6)
                (set! r15 ra.484)
                (jump L.jp.55 rbp r15 rdx rsi rdi))))
          (begin (set! rax 574) (jump ra.484 rbp rax)))))
    (define L.jp.55
      ((new-frames ()))
      (begin
        (set! ra.486 r15)
        (set! tmp.207 rdi)
        (set! tmp.18 rsi)
        (set! tmp.19 rdx)
        (if (neq? tmp.207 6)
          (begin
            (set! tmp.487 (- tmp.18 tmp.19))
            (set! rax tmp.487)
            (jump ra.486 rbp rax))
          (begin (set! rax 574) (jump ra.486 rbp rax)))))
    (define L.jp.52
      ((new-frames ()))
      (begin
        (set! ra.488 r15)
        (set! tmp.199 rdi)
        (set! tmp.16 rsi)
        (set! tmp.17 rdx)
        (if (neq? tmp.199 6)
          (begin
            (set! tmp.489 (bitwise-and tmp.16 7))
            (set! tmp.202 tmp.489)
            (if (eq? tmp.202 0)
              (begin
                (set! rdx tmp.17)
                (set! rsi tmp.16)
                (set! rdi 14)
                (set! r15 ra.488)
                (jump L.jp.51 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.17)
                (set! rsi tmp.16)
                (set! rdi 6)
                (set! r15 ra.488)
                (jump L.jp.51 rbp r15 rdx rsi rdi))))
          (begin (set! rax 318) (jump ra.488 rbp rax)))))
    (define L.jp.51
      ((new-frames ()))
      (begin
        (set! ra.490 r15)
        (set! tmp.201 rdi)
        (set! tmp.16 rsi)
        (set! tmp.17 rdx)
        (if (neq? tmp.201 6)
          (begin
            (set! tmp.491 (+ tmp.16 tmp.17))
            (set! rax tmp.491)
            (jump ra.490 rbp rax))
          (begin (set! rax 318) (jump ra.490 rbp rax)))))
    (define L.jp.48
      ((new-frames ()))
      (begin
        (set! ra.492 r15)
        (set! tmp.192 rdi)
        (set! tmp.14 rsi)
        (set! tmp.15 rdx)
        (if (neq? tmp.192 6)
          (begin
            (set! tmp.493 (bitwise-and tmp.14 7))
            (set! tmp.196 tmp.493)
            (if (eq? tmp.196 0)
              (begin
                (set! rdx tmp.14)
                (set! rsi tmp.15)
                (set! rdi 14)
                (set! r15 ra.492)
                (jump L.jp.47 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.14)
                (set! rsi tmp.15)
                (set! rdi 6)
                (set! r15 ra.492)
                (jump L.jp.47 rbp r15 rdx rsi rdi))))
          (begin (set! rax 62) (jump ra.492 rbp rax)))))
    (define L.jp.47
      ((new-frames ()))
      (begin
        (set! ra.494 r15)
        (set! tmp.194 rdi)
        (set! tmp.15 rsi)
        (set! tmp.14 rdx)
        (if (neq? tmp.194 6)
          (begin
            (set! tmp.495 (arithmetic-shift-right tmp.15 3))
            (set! tmp.195 tmp.495)
            (set! tmp.496 (* tmp.14 tmp.195))
            (set! rax tmp.496)
            (jump ra.494 rbp rax))
          (begin (set! rax 62) (jump ra.494 rbp rax)))))
    (define L.jp.44
      ((new-frames ()))
      (begin
        (set! ra.497 r15)
        (set! tmp.184 rdi)
        (set! tmp.129 rsi)
        (set! let.11 rdx)
        (set! error.4 rcx)
        (set! lambda.10 r8)
        (set! letrec.7 r9)
        (set! eq?.8 fv0)
        (set! apply.9 fv1)
        (set! define.5 fv2)
        (set! not.6 fv3)
        (if (neq? tmp.184 6)
          (begin
            (set! tmp.189 (mref tmp.129 6))
            (if (eq? tmp.189 16)
              (begin
                (set! fv3 not.6)
                (set! fv2 define.5)
                (set! fv1 apply.9)
                (set! fv0 eq?.8)
                (set! r9 letrec.7)
                (set! r8 lambda.10)
                (set! rcx error.4)
                (set! rdx let.11)
                (set! rsi tmp.129)
                (set! rdi 14)
                (set! r15 ra.497)
                (jump L.jp.43 rbp r15 fv0 fv1 fv2 fv3 r9 r8 rcx rdx rsi rdi))
              (begin
                (set! fv3 not.6)
                (set! fv2 define.5)
                (set! fv1 apply.9)
                (set! fv0 eq?.8)
                (set! r9 letrec.7)
                (set! r8 lambda.10)
                (set! rcx error.4)
                (set! rdx let.11)
                (set! rsi tmp.129)
                (set! rdi 6)
                (set! r15 ra.497)
                (jump L.jp.43 rbp r15 fv0 fv1 fv2 fv3 r9 r8 rcx rdx rsi rdi))))
          (begin
            (set! fv0 eq?.8)
            (set! r9 letrec.7)
            (set! r8 lambda.10)
            (set! rcx define.5)
            (set! rdx error.4)
            (set! rsi let.11)
            (set! rdi 11070)
            (set! r15 ra.497)
            (jump L.jp.41 rbp r15 fv0 r9 r8 rcx rdx rsi rdi)))))
    (define L.jp.43
      ((new-frames ()))
      (begin
        (set! ra.498 r15)
        (set! tmp.186 rdi)
        (set! tmp.129 rsi)
        (set! let.11 rdx)
        (set! error.4 rcx)
        (set! lambda.10 r8)
        (set! letrec.7 r9)
        (set! eq?.8 fv0)
        (set! apply.9 fv1)
        (set! define.5 fv2)
        (set! not.6 fv3)
        (if (neq? tmp.186 6)
          (begin
            (set! tmp.187 (mref tmp.129 -2))
            (return-point L.rp.121
              (begin
                (set! rdx apply.9)
                (set! rsi define.5)
                (set! rdi not.6)
                (set! r15 L.rp.121)
                (jump tmp.187 rbp r15 rdx rsi rdi)))
            (set! tmp.188 rax)
            (set! fv0 eq?.8)
            (set! r9 letrec.7)
            (set! r8 lambda.10)
            (set! rcx define.5)
            (set! rdx error.4)
            (set! rsi let.11)
            (set! rdi tmp.188)
            (set! r15 ra.498)
            (jump L.jp.41 rbp r15 fv0 r9 r8 rcx rdx rsi rdi))
          (begin
            (set! fv0 eq?.8)
            (set! r9 letrec.7)
            (set! r8 lambda.10)
            (set! rcx define.5)
            (set! rdx error.4)
            (set! rsi let.11)
            (set! rdi 10814)
            (set! r15 ra.498)
            (jump L.jp.41 rbp r15 fv0 r9 r8 rcx rdx rsi rdi)))))
    (define L.jp.41
      ((new-frames ()))
      (begin
        (set! ra.499 r15)
        (set! tmp.167 rdi)
        (set! let.11 rsi)
        (set! error.4 rdx)
        (set! define.5 rcx)
        (set! lambda.10 r8)
        (set! letrec.7 r9)
        (set! eq?.8 fv0)
        (if (neq? tmp.167 6)
          (begin (set! rax eq?.8) (jump ra.499 rbp rax))
          (begin
            (set! tmp.130 let.11)
            (set! tmp.500 (bitwise-and tmp.130 7))
            (set! tmp.183 tmp.500)
            (if (eq? tmp.183 2)
              (begin
                (set! fv1 error.4)
                (set! fv0 let.11)
                (set! r9 define.5)
                (set! r8 eq?.8)
                (set! rcx lambda.10)
                (set! rdx letrec.7)
                (set! rsi tmp.130)
                (set! rdi 14)
                (set! r15 ra.499)
                (jump L.jp.40 rbp r15 fv0 fv1 r9 r8 rcx rdx rsi rdi))
              (begin
                (set! fv1 error.4)
                (set! fv0 let.11)
                (set! r9 define.5)
                (set! r8 eq?.8)
                (set! rcx lambda.10)
                (set! rdx letrec.7)
                (set! rsi tmp.130)
                (set! rdi 6)
                (set! r15 ra.499)
                (jump L.jp.40 rbp r15 fv0 fv1 r9 r8 rcx rdx rsi rdi)))))))
    (define L.jp.40
      ((new-frames ()))
      (begin
        (set! ra.501 r15)
        (set! tmp.169 rdi)
        (set! tmp.130 rsi)
        (set! letrec.7 rdx)
        (set! lambda.10 rcx)
        (set! eq?.8 r8)
        (set! define.5 r9)
        (set! let.11 fv0)
        (set! error.4 fv1)
        (if (neq? tmp.169 6)
          (begin
            (set! tmp.182 (mref tmp.130 6))
            (if (eq? tmp.182 16)
              (begin
                (set! fv1 error.4)
                (set! fv0 let.11)
                (set! r9 define.5)
                (set! r8 eq?.8)
                (set! rcx lambda.10)
                (set! rdx letrec.7)
                (set! rsi tmp.130)
                (set! rdi 14)
                (set! r15 ra.501)
                (jump L.jp.39 rbp r15 fv0 fv1 r9 r8 rcx rdx rsi rdi))
              (begin
                (set! fv1 error.4)
                (set! fv0 let.11)
                (set! r9 define.5)
                (set! r8 eq?.8)
                (set! rcx lambda.10)
                (set! rdx letrec.7)
                (set! rsi tmp.130)
                (set! rdi 6)
                (set! r15 ra.501)
                (jump L.jp.39 rbp r15 fv0 fv1 r9 r8 rcx rdx rsi rdi))))
          (begin (set! rax 11070) (jump ra.501 rbp rax)))))
    (define L.jp.39
      ((new-frames ()))
      (begin
        (set! ra.502 r15)
        (set! tmp.171 rdi)
        (set! tmp.130 rsi)
        (set! letrec.7 rdx)
        (set! lambda.10 rcx)
        (set! eq?.8 r8)
        (set! define.5 r9)
        (set! let.11 fv0)
        (set! error.4 fv1)
        (if (neq? tmp.171 6)
          (begin
            (set! tmp.172 (mref tmp.130 -2))
            (set! tmp.128 error.4)
            (set! tmp.131 letrec.7)
            (set! tmp.503 (bitwise-and tmp.131 7))
            (set! tmp.181 tmp.503)
            (if (eq? tmp.181 2)
              (begin
                (set! fv2 letrec.7)
                (set! fv1 lambda.10)
                (set! fv0 eq?.8)
                (set! r9 error.4)
                (set! r8 define.5)
                (set! rcx let.11)
                (set! rdx tmp.172)
                (set! rsi tmp.131)
                (set! rdi 14)
                (set! r15 ra.502)
                (jump L.jp.38 rbp r15 fv0 fv1 fv2 r9 r8 rcx rdx rsi rdi))
              (begin
                (set! fv2 letrec.7)
                (set! fv1 lambda.10)
                (set! fv0 eq?.8)
                (set! r9 error.4)
                (set! r8 define.5)
                (set! rcx let.11)
                (set! rdx tmp.172)
                (set! rsi tmp.131)
                (set! rdi 6)
                (set! r15 ra.502)
                (jump L.jp.38 rbp r15 fv0 fv1 fv2 r9 r8 rcx rdx rsi rdi))))
          (begin (set! rax 10814) (jump ra.502 rbp rax)))))
    (define L.jp.38
      ((new-frames ()))
      (begin
        (set! ra.504 r15)
        (set! tmp.175 rdi)
        (set! tmp.131 rsi)
        (set! tmp.172 rdx)
        (set! let.11 rcx)
        (set! define.5 r8)
        (set! error.4 r9)
        (set! eq?.8 fv0)
        (set! lambda.10 fv1)
        (set! letrec.7 fv2)
        (if (neq? tmp.175 6)
          (begin
            (set! tmp.180 (mref tmp.131 6))
            (if (eq? tmp.180 16)
              (begin
                (set! fv2 letrec.7)
                (set! fv1 lambda.10)
                (set! fv0 eq?.8)
                (set! r9 error.4)
                (set! r8 define.5)
                (set! rcx let.11)
                (set! rdx tmp.172)
                (set! rsi tmp.131)
                (set! rdi 14)
                (set! r15 ra.504)
                (jump L.jp.37 rbp r15 fv0 fv1 fv2 r9 r8 rcx rdx rsi rdi))
              (begin
                (set! fv2 letrec.7)
                (set! fv1 lambda.10)
                (set! fv0 eq?.8)
                (set! r9 error.4)
                (set! r8 define.5)
                (set! rcx let.11)
                (set! rdx tmp.172)
                (set! rsi tmp.131)
                (set! rdi 6)
                (set! r15 ra.504)
                (jump L.jp.37 rbp r15 fv0 fv1 fv2 r9 r8 rcx rdx rsi rdi))))
          (begin
            (set! r8 error.4)
            (set! rcx define.5)
            (set! rdx let.11)
            (set! rsi tmp.172)
            (set! rdi 11070)
            (set! r15 ra.504)
            (jump L.jp.35 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.jp.37
      ((new-frames ()))
      (begin
        (set! ra.505 r15)
        (set! tmp.177 rdi)
        (set! tmp.131 rsi)
        (set! tmp.172 rdx)
        (set! let.11 rcx)
        (set! define.5 r8)
        (set! error.4 r9)
        (set! eq?.8 fv0)
        (set! lambda.10 fv1)
        (set! letrec.7 fv2)
        (if (neq? tmp.177 6)
          (begin
            (set! tmp.178 (mref tmp.131 -2))
            (return-point L.rp.122
              (begin
                (set! rdx eq?.8)
                (set! rsi lambda.10)
                (set! rdi letrec.7)
                (set! r15 L.rp.122)
                (jump tmp.178 rbp r15 rdx rsi rdi)))
            (set! tmp.179 rax)
            (set! r8 error.4)
            (set! rcx define.5)
            (set! rdx let.11)
            (set! rsi tmp.172)
            (set! rdi tmp.179)
            (set! r15 ra.505)
            (jump L.jp.35 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 error.4)
            (set! rcx define.5)
            (set! rdx let.11)
            (set! rsi tmp.172)
            (set! rdi 10814)
            (set! r15 ra.505)
            (jump L.jp.35 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.jp.35
      ((new-frames ()))
      (begin
        (set! ra.506 r15)
        (set! tmp.173 rdi)
        (set! tmp.172 rsi)
        (set! let.11 rdx)
        (set! define.5 rcx)
        (set! error.4 r8)
        (return-point L.rp.123
          (begin
            (set! rsi tmp.173)
            (set! rdi error.4)
            (set! r15 L.rp.123)
            (jump L.error.4.31 rbp r15 rsi rdi)))
        (set! tmp.174 rax)
        (set! rdx tmp.174)
        (set! rsi define.5)
        (set! rdi let.11)
        (set! r15 ra.506)
        (jump tmp.172 rbp r15 rdx rsi rdi))))     ) 120)
  )

  (parameterize ([current-pass-list
                  (list
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
     (execute  '(module
    (define L.error.4.31
      (lambda (c.122 define.5)
        (let ((eq?.77 (mref c.122 14)))
          (let ((*.52 (mref c.122 22)))
            (let ((error.4 (mref c.122 30)))
              (let ((|-.54| (mref c.122 38)))
                (let ((not.6 eq?.77))
                  (let ((letrec.7 |-.54|))
                    (let ((eq?.8 8))
                      (let ((apply.9 0))
                        (let ((lambda.10 define.5))
                          (let ((let.11 *.52))
                            (let ((tmp.129 not.6))
                              (let ((tmp.190 (bitwise-and tmp.129 7)))
                                (if (eq? tmp.190 2)
                                  (apply
                                   L.jp.44
                                   14
                                   tmp.129
                                   let.11
                                   error.4
                                   lambda.10
                                   letrec.7
                                   eq?.8
                                   apply.9
                                   define.5
                                   not.6)
                                  (apply
                                   L.jp.44
                                   6
                                   tmp.129
                                   let.11
                                   error.4
                                   lambda.10
                                   letrec.7
                                   eq?.8
                                   apply.9
                                   define.5
                                   not.6))))))))))))))))
    (define L.*.52.30
      (lambda (c.121 tmp.14 tmp.15)
        (let ((tmp.197 (bitwise-and tmp.15 7)))
          (if (eq? tmp.197 0)
            (apply L.jp.48 14 tmp.14 tmp.15)
            (apply L.jp.48 6 tmp.14 tmp.15)))))
    (define L.+.53.29
      (lambda (c.120 tmp.16 tmp.17)
        (let ((tmp.203 (bitwise-and tmp.17 7)))
          (if (eq? tmp.203 0)
            (apply L.jp.52 14 tmp.16 tmp.17)
            (apply L.jp.52 6 tmp.16 tmp.17)))))
    (define L.-.54.28
      (lambda (c.119 tmp.18 tmp.19)
        (let ((tmp.209 (bitwise-and tmp.19 7)))
          (if (eq? tmp.209 0)
            (apply L.jp.56 14 tmp.18 tmp.19)
            (apply L.jp.56 6 tmp.18 tmp.19)))))
    (define L.<.55.27
      (lambda (c.118 tmp.20 tmp.21)
        (let ((tmp.216 (bitwise-and tmp.21 7)))
          (if (eq? tmp.216 0)
            (apply L.jp.61 14 tmp.20 tmp.21)
            (apply L.jp.61 6 tmp.20 tmp.21)))))
    (define L.<=.56.26
      (lambda (c.117 tmp.22 tmp.23)
        (let ((tmp.223 (bitwise-and tmp.23 7)))
          (if (eq? tmp.223 0)
            (apply L.jp.66 14 tmp.22 tmp.23)
            (apply L.jp.66 6 tmp.22 tmp.23)))))
    (define L.>.57.25
      (lambda (c.116 tmp.24 tmp.25)
        (let ((tmp.230 (bitwise-and tmp.25 7)))
          (if (eq? tmp.230 0)
            (apply L.jp.71 14 tmp.24 tmp.25)
            (apply L.jp.71 6 tmp.24 tmp.25)))))
    (define L.>=.58.24
      (lambda (c.115 tmp.26 tmp.27)
        (let ((tmp.237 (bitwise-and tmp.27 7)))
          (if (eq? tmp.237 0)
            (apply L.jp.76 14 tmp.26 tmp.27)
            (apply L.jp.76 6 tmp.26 tmp.27)))))
    (define L.make-vector.59.23
      (lambda (c.114 tmp.28)
        (let ((make-init-vector.1 (mref c.114 14)))
          (let ((tmp.240 (bitwise-and tmp.28 7)))
            (if (eq? tmp.240 0)
              (apply L.jp.78 14 make-init-vector.1 tmp.28)
              (apply L.jp.78 6 make-init-vector.1 tmp.28))))))
    (define L.vector-length.60.22
      (lambda (c.113 tmp.29)
        (let ((tmp.243 (bitwise-and tmp.29 7)))
          (if (eq? tmp.243 3)
            (apply L.jp.80 14 tmp.29)
            (apply L.jp.80 6 tmp.29)))))
    (define L.vector-set!.61.21
      (lambda (c.112 tmp.30 tmp.31 tmp.32)
        (let ((unsafe-vector-set!.2 (mref c.112 14)))
          (let ((tmp.249 (bitwise-and tmp.31 7)))
            (if (eq? tmp.249 0)
              (apply L.jp.84 14 tmp.30 unsafe-vector-set!.2 tmp.32 tmp.31)
              (apply L.jp.84 6 tmp.30 unsafe-vector-set!.2 tmp.32 tmp.31))))))
    (define L.vector-ref.62.20
      (lambda (c.111 tmp.33 tmp.34)
        (let ((unsafe-vector-ref.3 (mref c.111 14)))
          (let ((tmp.255 (bitwise-and tmp.34 7)))
            (if (eq? tmp.255 0)
              (apply L.jp.88 14 tmp.33 unsafe-vector-ref.3 tmp.34)
              (apply L.jp.88 6 tmp.33 unsafe-vector-ref.3 tmp.34))))))
    (define L.car.63.19
      (lambda (c.110 tmp.35)
        (let ((tmp.258 (bitwise-and tmp.35 7)))
          (if (eq? tmp.258 1)
            (apply L.jp.90 14 tmp.35)
            (apply L.jp.90 6 tmp.35)))))
    (define L.cdr.64.18
      (lambda (c.109 tmp.36)
        (let ((tmp.261 (bitwise-and tmp.36 7)))
          (if (eq? tmp.261 1)
            (apply L.jp.92 14 tmp.36)
            (apply L.jp.92 6 tmp.36)))))
    (define L.procedure-arity.65.17
      (lambda (c.108 tmp.37)
        (let ((tmp.264 (bitwise-and tmp.37 7)))
          (if (eq? tmp.264 2)
            (apply L.jp.94 14 tmp.37)
            (apply L.jp.94 6 tmp.37)))))
    (define L.fixnum?.66.16
      (lambda (c.107 tmp.38)
        (let ((tmp.266 (bitwise-and tmp.38 7))) (if (eq? tmp.266 0) 14 6))))
    (define L.boolean?.67.15
      (lambda (c.106 tmp.39)
        (let ((tmp.268 (bitwise-and tmp.39 247))) (if (eq? tmp.268 6) 14 6))))
    (define L.empty?.68.14
      (lambda (c.105 tmp.40)
        (let ((tmp.270 (bitwise-and tmp.40 255))) (if (eq? tmp.270 22) 14 6))))
    (define L.void?.69.13
      (lambda (c.104 tmp.41)
        (let ((tmp.272 (bitwise-and tmp.41 255))) (if (eq? tmp.272 30) 14 6))))
    (define L.ascii-char?.70.12
      (lambda (c.103 tmp.42)
        (let ((tmp.274 (bitwise-and tmp.42 255))) (if (eq? tmp.274 46) 14 6))))
    (define L.error?.71.11
      (lambda (c.102 tmp.43)
        (let ((tmp.276 (bitwise-and tmp.43 255))) (if (eq? tmp.276 62) 14 6))))
    (define L.pair?.72.10
      (lambda (c.101 tmp.44)
        (let ((tmp.278 (bitwise-and tmp.44 7))) (if (eq? tmp.278 1) 14 6))))
    (define L.procedure?.73.9
      (lambda (c.100 tmp.45)
        (let ((tmp.280 (bitwise-and tmp.45 7))) (if (eq? tmp.280 2) 14 6))))
    (define L.vector?.74.8
      (lambda (c.99 tmp.46)
        (let ((tmp.282 (bitwise-and tmp.46 7))) (if (eq? tmp.282 3) 14 6))))
    (define L.not.75.7 (lambda (c.98 tmp.47) (if (neq? tmp.47 6) 6 14)))
    (define L.cons.76.6
      (lambda (c.97 tmp.48 tmp.49)
        (let ((tmp.284 (alloc 16)))
          (let ((tmp.133 (+ tmp.284 1)))
            (begin
              (mset! tmp.133 -1 tmp.48)
              (mset! tmp.133 7 tmp.49)
              tmp.133)))))
    (define L.eq?.77.5
      (lambda (c.96 tmp.50 tmp.51) (if (eq? tmp.50 tmp.51) 14 6)))
    (define L.make-init-vector.1.4
      (lambda (c.95 tmp.78)
        (let ((vector-init-loop.80 (mref c.95 14)))
          (let ((tmp.286 (arithmetic-shift-right tmp.78 3)))
            (let ((tmp.287 (+ 1 tmp.286)))
              (let ((tmp.288 (* tmp.287 8)))
                (let ((tmp.289 (alloc tmp.288)))
                  (let ((tmp.134 (+ tmp.289 3)))
                    (begin
                      (mset! tmp.134 -3 tmp.78)
                      (let ((tmp.79 tmp.134))
                        (let ((tmp.124 vector-init-loop.80))
                          (apply
                           L.vector-init-loop.80.3
                           vector-init-loop.80
                           tmp.78
                           0
                           tmp.79))))))))))))
    (define L.vector-init-loop.80.3
      (lambda (c.94 len.81 i.83 vec.82)
        (let ((vector-init-loop.80 (mref c.94 14)))
          (if (eq? len.81 i.83)
            (apply L.jp.107 14 i.83 len.81 vector-init-loop.80 vec.82)
            (apply L.jp.107 6 i.83 len.81 vector-init-loop.80 vec.82)))))
    (define L.unsafe-vector-set!.2.2
      (lambda (c.93 tmp.89 tmp.90 tmp.91)
        (let ((tmp.303 (mref tmp.89 -3)))
          (if (< tmp.90 tmp.303)
            (apply L.jp.111 14 tmp.90 tmp.91 tmp.89)
            (apply L.jp.111 6 tmp.90 tmp.91 tmp.89)))))
    (define L.unsafe-vector-ref.3.1
      (lambda (c.92 tmp.86 tmp.87)
        (let ((tmp.311 (mref tmp.86 -3)))
          (if (< tmp.87 tmp.311)
            (apply L.jp.115 14 tmp.87 tmp.86)
            (apply L.jp.115 6 tmp.87 tmp.86)))))
    (define L.jp.119
      (lambda (tmp.344 tmp.132 let.12 define.13)
        (if (neq? tmp.344 6)
          (let ((tmp.348 (mref tmp.132 6)))
            (if (eq? tmp.348 8)
              (apply L.jp.118 14 tmp.132 let.12 define.13)
              (apply L.jp.118 6 tmp.132 let.12 define.13)))
          11070)))
    (define L.jp.118
      (lambda (tmp.346 tmp.132 let.12 define.13)
        (if (neq? tmp.346 6)
          (let ((tmp.347 (mref tmp.132 -2))) (apply tmp.347 define.13 let.12))
          10814)))
    (define L.jp.115
      (lambda (tmp.305 tmp.87 tmp.86)
        (if (neq? tmp.305 6)
          (if (>= tmp.87 0)
            (apply L.jp.114 14 tmp.87 tmp.86)
            (apply L.jp.114 6 tmp.87 tmp.86))
          2622)))
    (define L.jp.114
      (lambda (tmp.307 tmp.87 tmp.86)
        (if (neq? tmp.307 6)
          (let ((tmp.308 (arithmetic-shift-right tmp.87 3)))
            (let ((tmp.309 (* tmp.308 8)))
              (let ((tmp.310 (+ tmp.309 5))) (mref tmp.86 tmp.310))))
          2622)))
    (define L.jp.111
      (lambda (tmp.297 tmp.90 tmp.91 tmp.89)
        (if (neq? tmp.297 6)
          (if (>= tmp.90 0)
            (apply L.jp.110 14 tmp.90 tmp.89 tmp.91)
            (apply L.jp.110 6 tmp.90 tmp.89 tmp.91))
          2366)))
    (define L.jp.110
      (lambda (tmp.299 tmp.90 tmp.89 tmp.91)
        (if (neq? tmp.299 6)
          (let ((tmp.300 (arithmetic-shift-right tmp.90 3)))
            (let ((tmp.301 (* tmp.300 8)))
              (let ((tmp.302 (+ tmp.301 5)))
                (begin (mset! tmp.89 tmp.302 tmp.91) 30))))
          2366)))
    (define L.jp.107
      (lambda (tmp.291 i.83 len.81 vector-init-loop.80 vec.82)
        (if (neq? tmp.291 6)
          vec.82
          (let ((tmp.292 (arithmetic-shift-right i.83 3)))
            (let ((tmp.293 (* tmp.292 8)))
              (let ((tmp.294 (+ tmp.293 5)))
                (begin
                  (mset! vec.82 tmp.294 0)
                  (let ((tmp.123 vector-init-loop.80))
                    (let ((tmp.295 (+ i.83 8)))
                      (apply
                       L.vector-init-loop.80.3
                       vector-init-loop.80
                       len.81
                       tmp.295
                       vec.82))))))))))
    (define L.jp.94
      (lambda (tmp.263 tmp.37) (if (neq? tmp.263 6) (mref tmp.37 6) 3390)))
    (define L.jp.92
      (lambda (tmp.260 tmp.36) (if (neq? tmp.260 6) (mref tmp.36 7) 3134)))
    (define L.jp.90
      (lambda (tmp.257 tmp.35) (if (neq? tmp.257 6) (mref tmp.35 -1) 2878)))
    (define L.jp.88
      (lambda (tmp.251 tmp.33 unsafe-vector-ref.3 tmp.34)
        (if (neq? tmp.251 6)
          (let ((tmp.254 (bitwise-and tmp.33 7)))
            (if (eq? tmp.254 3)
              (apply L.jp.87 14 unsafe-vector-ref.3 tmp.34 tmp.33)
              (apply L.jp.87 6 unsafe-vector-ref.3 tmp.34 tmp.33)))
          2622)))
    (define L.jp.87
      (lambda (tmp.253 unsafe-vector-ref.3 tmp.34 tmp.33)
        (if (neq? tmp.253 6)
          (let ((tmp.125 unsafe-vector-ref.3))
            (apply L.unsafe-vector-ref.3.1 unsafe-vector-ref.3 tmp.33 tmp.34))
          2622)))
    (define L.jp.84
      (lambda (tmp.245 tmp.30 unsafe-vector-set!.2 tmp.32 tmp.31)
        (if (neq? tmp.245 6)
          (let ((tmp.248 (bitwise-and tmp.30 7)))
            (if (eq? tmp.248 3)
              (apply L.jp.83 14 unsafe-vector-set!.2 tmp.32 tmp.31 tmp.30)
              (apply L.jp.83 6 unsafe-vector-set!.2 tmp.32 tmp.31 tmp.30)))
          2366)))
    (define L.jp.83
      (lambda (tmp.247 unsafe-vector-set!.2 tmp.32 tmp.31 tmp.30)
        (if (neq? tmp.247 6)
          (let ((tmp.126 unsafe-vector-set!.2))
            (apply
             L.unsafe-vector-set!.2.2
             unsafe-vector-set!.2
             tmp.30
             tmp.31
             tmp.32))
          2366)))
    (define L.jp.80
      (lambda (tmp.242 tmp.29) (if (neq? tmp.242 6) (mref tmp.29 -3) 2110)))
    (define L.jp.78
      (lambda (tmp.239 make-init-vector.1 tmp.28)
        (if (neq? tmp.239 6)
          (let ((tmp.127 make-init-vector.1))
            (apply L.make-init-vector.1.4 make-init-vector.1 tmp.28))
          1854)))
    (define L.jp.76
      (lambda (tmp.232 tmp.26 tmp.27)
        (if (neq? tmp.232 6)
          (let ((tmp.236 (bitwise-and tmp.26 7)))
            (if (eq? tmp.236 0)
              (apply L.jp.75 14 tmp.26 tmp.27)
              (apply L.jp.75 6 tmp.26 tmp.27)))
          1598)))
    (define L.jp.75
      (lambda (tmp.234 tmp.26 tmp.27)
        (if (neq? tmp.234 6) (if (>= tmp.26 tmp.27) 14 6) 1598)))
    (define L.jp.71
      (lambda (tmp.225 tmp.24 tmp.25)
        (if (neq? tmp.225 6)
          (let ((tmp.229 (bitwise-and tmp.24 7)))
            (if (eq? tmp.229 0)
              (apply L.jp.70 14 tmp.24 tmp.25)
              (apply L.jp.70 6 tmp.24 tmp.25)))
          1342)))
    (define L.jp.70
      (lambda (tmp.227 tmp.24 tmp.25)
        (if (neq? tmp.227 6) (if (> tmp.24 tmp.25) 14 6) 1342)))
    (define L.jp.66
      (lambda (tmp.218 tmp.22 tmp.23)
        (if (neq? tmp.218 6)
          (let ((tmp.222 (bitwise-and tmp.22 7)))
            (if (eq? tmp.222 0)
              (apply L.jp.65 14 tmp.22 tmp.23)
              (apply L.jp.65 6 tmp.22 tmp.23)))
          1086)))
    (define L.jp.65
      (lambda (tmp.220 tmp.22 tmp.23)
        (if (neq? tmp.220 6) (if (<= tmp.22 tmp.23) 14 6) 1086)))
    (define L.jp.61
      (lambda (tmp.211 tmp.20 tmp.21)
        (if (neq? tmp.211 6)
          (let ((tmp.215 (bitwise-and tmp.20 7)))
            (if (eq? tmp.215 0)
              (apply L.jp.60 14 tmp.20 tmp.21)
              (apply L.jp.60 6 tmp.20 tmp.21)))
          830)))
    (define L.jp.60
      (lambda (tmp.213 tmp.20 tmp.21)
        (if (neq? tmp.213 6) (if (< tmp.20 tmp.21) 14 6) 830)))
    (define L.jp.56
      (lambda (tmp.205 tmp.18 tmp.19)
        (if (neq? tmp.205 6)
          (let ((tmp.208 (bitwise-and tmp.18 7)))
            (if (eq? tmp.208 0)
              (apply L.jp.55 14 tmp.18 tmp.19)
              (apply L.jp.55 6 tmp.18 tmp.19)))
          574)))
    (define L.jp.55
      (lambda (tmp.207 tmp.18 tmp.19)
        (if (neq? tmp.207 6) (- tmp.18 tmp.19) 574)))
    (define L.jp.52
      (lambda (tmp.199 tmp.16 tmp.17)
        (if (neq? tmp.199 6)
          (let ((tmp.202 (bitwise-and tmp.16 7)))
            (if (eq? tmp.202 0)
              (apply L.jp.51 14 tmp.16 tmp.17)
              (apply L.jp.51 6 tmp.16 tmp.17)))
          318)))
    (define L.jp.51
      (lambda (tmp.201 tmp.16 tmp.17)
        (if (neq? tmp.201 6) (+ tmp.16 tmp.17) 318)))
    (define L.jp.48
      (lambda (tmp.192 tmp.14 tmp.15)
        (if (neq? tmp.192 6)
          (let ((tmp.196 (bitwise-and tmp.14 7)))
            (if (eq? tmp.196 0)
              (apply L.jp.47 14 tmp.15 tmp.14)
              (apply L.jp.47 6 tmp.15 tmp.14)))
          62)))
    (define L.jp.47
      (lambda (tmp.194 tmp.15 tmp.14)
        (if (neq? tmp.194 6)
          (let ((tmp.195 (arithmetic-shift-right tmp.15 3)))
            (* tmp.14 tmp.195))
          62)))
    (define L.jp.44
      (lambda (tmp.184
               tmp.129
               let.11
               error.4
               lambda.10
               letrec.7
               eq?.8
               apply.9
               define.5
               not.6)
        (if (neq? tmp.184 6)
          (let ((tmp.189 (mref tmp.129 6)))
            (if (eq? tmp.189 16)
              (apply
               L.jp.43
               14
               tmp.129
               let.11
               error.4
               lambda.10
               letrec.7
               eq?.8
               apply.9
               define.5
               not.6)
              (apply
               L.jp.43
               6
               tmp.129
               let.11
               error.4
               lambda.10
               letrec.7
               eq?.8
               apply.9
               define.5
               not.6)))
          (apply
           L.jp.41
           11070
           let.11
           error.4
           define.5
           lambda.10
           letrec.7
           eq?.8))))
    (define L.jp.43
      (lambda (tmp.186
               tmp.129
               let.11
               error.4
               lambda.10
               letrec.7
               eq?.8
               apply.9
               define.5
               not.6)
        (if (neq? tmp.186 6)
          (let ((tmp.187 (mref tmp.129 -2)))
            (let ((tmp.188 (apply tmp.187 not.6 define.5 apply.9)))
              (apply
               L.jp.41
               tmp.188
               let.11
               error.4
               define.5
               lambda.10
               letrec.7
               eq?.8)))
          (apply
           L.jp.41
           10814
           let.11
           error.4
           define.5
           lambda.10
           letrec.7
           eq?.8))))
    (define L.jp.41
      (lambda (tmp.167 let.11 error.4 define.5 lambda.10 letrec.7 eq?.8)
        (if (neq? tmp.167 6)
          eq?.8
          (let ((tmp.130 let.11))
            (let ((tmp.183 (bitwise-and tmp.130 7)))
              (if (eq? tmp.183 2)
                (apply
                 L.jp.40
                 14
                 tmp.130
                 letrec.7
                 lambda.10
                 eq?.8
                 define.5
                 let.11
                 error.4)
                (apply
                 L.jp.40
                 6
                 tmp.130
                 letrec.7
                 lambda.10
                 eq?.8
                 define.5
                 let.11
                 error.4)))))))
    (define L.jp.40
      (lambda (tmp.169
               tmp.130
               letrec.7
               lambda.10
               eq?.8
               define.5
               let.11
               error.4)
        (if (neq? tmp.169 6)
          (let ((tmp.182 (mref tmp.130 6)))
            (if (eq? tmp.182 16)
              (apply
               L.jp.39
               14
               tmp.130
               letrec.7
               lambda.10
               eq?.8
               define.5
               let.11
               error.4)
              (apply
               L.jp.39
               6
               tmp.130
               letrec.7
               lambda.10
               eq?.8
               define.5
               let.11
               error.4)))
          11070)))
    (define L.jp.39
      (lambda (tmp.171
               tmp.130
               letrec.7
               lambda.10
               eq?.8
               define.5
               let.11
               error.4)
        (if (neq? tmp.171 6)
          (let ((tmp.172 (mref tmp.130 -2)))
            (let ((tmp.128 error.4))
              (let ((tmp.131 letrec.7))
                (let ((tmp.181 (bitwise-and tmp.131 7)))
                  (if (eq? tmp.181 2)
                    (apply
                     L.jp.38
                     14
                     tmp.131
                     tmp.172
                     let.11
                     define.5
                     error.4
                     eq?.8
                     lambda.10
                     letrec.7)
                    (apply
                     L.jp.38
                     6
                     tmp.131
                     tmp.172
                     let.11
                     define.5
                     error.4
                     eq?.8
                     lambda.10
                     letrec.7))))))
          10814)))
    (define L.jp.38
      (lambda (tmp.175
               tmp.131
               tmp.172
               let.11
               define.5
               error.4
               eq?.8
               lambda.10
               letrec.7)
        (if (neq? tmp.175 6)
          (let ((tmp.180 (mref tmp.131 6)))
            (if (eq? tmp.180 16)
              (apply
               L.jp.37
               14
               tmp.131
               tmp.172
               let.11
               define.5
               error.4
               eq?.8
               lambda.10
               letrec.7)
              (apply
               L.jp.37
               6
               tmp.131
               tmp.172
               let.11
               define.5
               error.4
               eq?.8
               lambda.10
               letrec.7)))
          (apply L.jp.35 11070 tmp.172 let.11 define.5 error.4))))
    (define L.jp.37
      (lambda (tmp.177
               tmp.131
               tmp.172
               let.11
               define.5
               error.4
               eq?.8
               lambda.10
               letrec.7)
        (if (neq? tmp.177 6)
          (let ((tmp.178 (mref tmp.131 -2)))
            (let ((tmp.179 (apply tmp.178 letrec.7 lambda.10 eq?.8)))
              (apply L.jp.35 tmp.179 tmp.172 let.11 define.5 error.4)))
          (apply L.jp.35 10814 tmp.172 let.11 define.5 error.4))))
    (define L.jp.35
      (lambda (tmp.173 tmp.172 let.11 define.5 error.4)
        (let ((tmp.174 (apply L.error.4.31 error.4 tmp.173)))
          (apply tmp.172 let.11 define.5 tmp.174))))
    (let ((tmp.312 (alloc 16)))
      (let ((tmp.135 (+ tmp.312 2)))
        (begin
          (mset! tmp.135 -2 L.unsafe-vector-ref.3.1)
          (mset! tmp.135 6 16)
          (let ((unsafe-vector-ref.3 tmp.135))
            (let ((tmp.313 (alloc 16)))
              (let ((tmp.136 (+ tmp.313 2)))
                (begin
                  (mset! tmp.136 -2 L.unsafe-vector-set!.2.2)
                  (mset! tmp.136 6 24)
                  (let ((unsafe-vector-set!.2 tmp.136))
                    (let ((tmp.314 (alloc 24)))
                      (let ((tmp.137 (+ tmp.314 2)))
                        (begin
                          (mset! tmp.137 -2 L.vector-init-loop.80.3)
                          (mset! tmp.137 6 24)
                          (let ((vector-init-loop.80 tmp.137))
                            (let ((tmp.315 (alloc 24)))
                              (let ((tmp.138 (+ tmp.315 2)))
                                (begin
                                  (mset! tmp.138 -2 L.make-init-vector.1.4)
                                  (mset! tmp.138 6 8)
                                  (let ((make-init-vector.1 tmp.138))
                                    (let ((tmp.316 (alloc 16)))
                                      (let ((tmp.139 (+ tmp.316 2)))
                                        (begin
                                          (mset! tmp.139 -2 L.eq?.77.5)
                                          (mset! tmp.139 6 16)
                                          (let ((eq?.77 tmp.139))
                                            (let ((tmp.317 (alloc 16)))
                                              (let ((tmp.140 (+ tmp.317 2)))
                                                (begin
                                                  (mset!
                                                   tmp.140
                                                   -2
                                                   L.cons.76.6)
                                                  (mset! tmp.140 6 16)
                                                  (let ((cons.76 tmp.140))
                                                    (let ((tmp.318 (alloc 16)))
                                                      (let ((tmp.141
                                                             (+ tmp.318 2)))
                                                        (begin
                                                          (mset!
                                                           tmp.141
                                                           -2
                                                           L.not.75.7)
                                                          (mset! tmp.141 6 8)
                                                          (let ((not.75
                                                                 tmp.141))
                                                            (let ((tmp.319
                                                                   (alloc 16)))
                                                              (let ((tmp.142
                                                                     (+
                                                                      tmp.319
                                                                      2)))
                                                                (begin
                                                                  (mset!
                                                                   tmp.142
                                                                   -2
                                                                   L.vector?.74.8)
                                                                  (mset!
                                                                   tmp.142
                                                                   6
                                                                   8)
                                                                  (let ((vector?.74
                                                                         tmp.142))
                                                                    (let ((tmp.320
                                                                           (alloc
                                                                            16)))
                                                                      (let ((tmp.143
                                                                             (+
                                                                              tmp.320
                                                                              2)))
                                                                        (begin
                                                                          (mset!
                                                                           tmp.143
                                                                           -2
                                                                           L.procedure?.73.9)
                                                                          (mset!
                                                                           tmp.143
                                                                           6
                                                                           8)
                                                                          (let ((procedure?.73
                                                                                 tmp.143))
                                                                            (let ((tmp.321
                                                                                   (alloc
                                                                                    16)))
                                                                              (let ((tmp.144
                                                                                     (+
                                                                                      tmp.321
                                                                                      2)))
                                                                                (begin
                                                                                  (mset!
                                                                                   tmp.144
                                                                                   -2
                                                                                   L.pair?.72.10)
                                                                                  (mset!
                                                                                   tmp.144
                                                                                   6
                                                                                   8)
                                                                                  (let ((pair?.72
                                                                                         tmp.144))
                                                                                    (let ((tmp.322
                                                                                           (alloc
                                                                                            16)))
                                                                                      (let ((tmp.145
                                                                                             (+
                                                                                              tmp.322
                                                                                              2)))
                                                                                        (begin
                                                                                          (mset!
                                                                                           tmp.145
                                                                                           -2
                                                                                           L.error?.71.11)
                                                                                          (mset!
                                                                                           tmp.145
                                                                                           6
                                                                                           8)
                                                                                          (let ((error?.71
                                                                                                 tmp.145))
                                                                                            (let ((tmp.323
                                                                                                   (alloc
                                                                                                    16)))
                                                                                              (let ((tmp.146
                                                                                                     (+
                                                                                                      tmp.323
                                                                                                      2)))
                                                                                                (begin
                                                                                                  (mset!
                                                                                                   tmp.146
                                                                                                   -2
                                                                                                   L.ascii-char?.70.12)
                                                                                                  (mset!
                                                                                                   tmp.146
                                                                                                   6
                                                                                                   8)
                                                                                                  (let ((ascii-char?.70
                                                                                                         tmp.146))
                                                                                                    (let ((tmp.324
                                                                                                           (alloc
                                                                                                            16)))
                                                                                                      (let ((tmp.147
                                                                                                             (+
                                                                                                              tmp.324
                                                                                                              2)))
                                                                                                        (begin
                                                                                                          (mset!
                                                                                                           tmp.147
                                                                                                           -2
                                                                                                           L.void?.69.13)
                                                                                                          (mset!
                                                                                                           tmp.147
                                                                                                           6
                                                                                                           8)
                                                                                                          (let ((void?.69
                                                                                                                 tmp.147))
                                                                                                            (let ((tmp.325
                                                                                                                   (alloc
                                                                                                                    16)))
                                                                                                              (let ((tmp.148
                                                                                                                     (+
                                                                                                                      tmp.325
                                                                                                                      2)))
                                                                                                                (begin
                                                                                                                  (mset!
                                                                                                                   tmp.148
                                                                                                                   -2
                                                                                                                   L.empty?.68.14)
                                                                                                                  (mset!
                                                                                                                   tmp.148
                                                                                                                   6
                                                                                                                   8)
                                                                                                                  (let ((empty?.68
                                                                                                                         tmp.148))
                                                                                                                    (let ((tmp.326
                                                                                                                           (alloc
                                                                                                                            16)))
                                                                                                                      (let ((tmp.149
                                                                                                                             (+
                                                                                                                              tmp.326
                                                                                                                              2)))
                                                                                                                        (begin
                                                                                                                          (mset!
                                                                                                                           tmp.149
                                                                                                                           -2
                                                                                                                           L.boolean?.67.15)
                                                                                                                          (mset!
                                                                                                                           tmp.149
                                                                                                                           6
                                                                                                                           8)
                                                                                                                          (let ((boolean?.67
                                                                                                                                 tmp.149))
                                                                                                                            (let ((tmp.327
                                                                                                                                   (alloc
                                                                                                                                    16)))
                                                                                                                              (let ((tmp.150
                                                                                                                                     (+
                                                                                                                                      tmp.327
                                                                                                                                      2)))
                                                                                                                                (begin
                                                                                                                                  (mset!
                                                                                                                                   tmp.150
                                                                                                                                   -2
                                                                                                                                   L.fixnum?.66.16)
                                                                                                                                  (mset!
                                                                                                                                   tmp.150
                                                                                                                                   6
                                                                                                                                   8)
                                                                                                                                  (let ((fixnum?.66
                                                                                                                                         tmp.150))
                                                                                                                                    (let ((tmp.328
                                                                                                                                           (alloc
                                                                                                                                            16)))
                                                                                                                                      (let ((tmp.151
                                                                                                                                             (+
                                                                                                                                              tmp.328
                                                                                                                                              2)))
                                                                                                                                        (begin
                                                                                                                                          (mset!
                                                                                                                                           tmp.151
                                                                                                                                           -2
                                                                                                                                           L.procedure-arity.65.17)
                                                                                                                                          (mset!
                                                                                                                                           tmp.151
                                                                                                                                           6
                                                                                                                                           8)
                                                                                                                                          (let ((procedure-arity.65
                                                                                                                                                 tmp.151))
                                                                                                                                            (let ((tmp.329
                                                                                                                                                   (alloc
                                                                                                                                                    16)))
                                                                                                                                              (let ((tmp.152
                                                                                                                                                     (+
                                                                                                                                                      tmp.329
                                                                                                                                                      2)))
                                                                                                                                                (begin
                                                                                                                                                  (mset!
                                                                                                                                                   tmp.152
                                                                                                                                                   -2
                                                                                                                                                   L.cdr.64.18)
                                                                                                                                                  (mset!
                                                                                                                                                   tmp.152
                                                                                                                                                   6
                                                                                                                                                   8)
                                                                                                                                                  (let ((cdr.64
                                                                                                                                                         tmp.152))
                                                                                                                                                    (let ((tmp.330
                                                                                                                                                           (alloc
                                                                                                                                                            16)))
                                                                                                                                                      (let ((tmp.153
                                                                                                                                                             (+
                                                                                                                                                              tmp.330
                                                                                                                                                              2)))
                                                                                                                                                        (begin
                                                                                                                                                          (mset!
                                                                                                                                                           tmp.153
                                                                                                                                                           -2
                                                                                                                                                           L.car.63.19)
                                                                                                                                                          (mset!
                                                                                                                                                           tmp.153
                                                                                                                                                           6
                                                                                                                                                           8)
                                                                                                                                                          (let ((car.63
                                                                                                                                                                 tmp.153))
                                                                                                                                                            (let ((tmp.331
                                                                                                                                                                   (alloc
                                                                                                                                                                    24)))
                                                                                                                                                              (let ((tmp.154
                                                                                                                                                                     (+
                                                                                                                                                                      tmp.331
                                                                                                                                                                      2)))
                                                                                                                                                                (begin
                                                                                                                                                                  (mset!
                                                                                                                                                                   tmp.154
                                                                                                                                                                   -2
                                                                                                                                                                   L.vector-ref.62.20)
                                                                                                                                                                  (mset!
                                                                                                                                                                   tmp.154
                                                                                                                                                                   6
                                                                                                                                                                   16)
                                                                                                                                                                  (let ((vector-ref.62
                                                                                                                                                                         tmp.154))
                                                                                                                                                                    (let ((tmp.332
                                                                                                                                                                           (alloc
                                                                                                                                                                            24)))
                                                                                                                                                                      (let ((tmp.155
                                                                                                                                                                             (+
                                                                                                                                                                              tmp.332
                                                                                                                                                                              2)))
                                                                                                                                                                        (begin
                                                                                                                                                                          (mset!
                                                                                                                                                                           tmp.155
                                                                                                                                                                           -2
                                                                                                                                                                           L.vector-set!.61.21)
                                                                                                                                                                          (mset!
                                                                                                                                                                           tmp.155
                                                                                                                                                                           6
                                                                                                                                                                           24)
                                                                                                                                                                          (let ((vector-set!.61
                                                                                                                                                                                 tmp.155))
                                                                                                                                                                            (let ((tmp.333
                                                                                                                                                                                   (alloc
                                                                                                                                                                                    16)))
                                                                                                                                                                              (let ((tmp.156
                                                                                                                                                                                     (+
                                                                                                                                                                                      tmp.333
                                                                                                                                                                                      2)))
                                                                                                                                                                                (begin
                                                                                                                                                                                  (mset!
                                                                                                                                                                                   tmp.156
                                                                                                                                                                                   -2
                                                                                                                                                                                   L.vector-length.60.22)
                                                                                                                                                                                  (mset!
                                                                                                                                                                                   tmp.156
                                                                                                                                                                                   6
                                                                                                                                                                                   8)
                                                                                                                                                                                  (let ((vector-length.60
                                                                                                                                                                                         tmp.156))
                                                                                                                                                                                    (let ((tmp.334
                                                                                                                                                                                           (alloc
                                                                                                                                                                                            24)))
                                                                                                                                                                                      (let ((tmp.157
                                                                                                                                                                                             (+
                                                                                                                                                                                              tmp.334
                                                                                                                                                                                              2)))
                                                                                                                                                                                        (begin
                                                                                                                                                                                          (mset!
                                                                                                                                                                                           tmp.157
                                                                                                                                                                                           -2
                                                                                                                                                                                           L.make-vector.59.23)
                                                                                                                                                                                          (mset!
                                                                                                                                                                                           tmp.157
                                                                                                                                                                                           6
                                                                                                                                                                                           8)
                                                                                                                                                                                          (let ((make-vector.59
                                                                                                                                                                                                 tmp.157))
                                                                                                                                                                                            (let ((tmp.335
                                                                                                                                                                                                   (alloc
                                                                                                                                                                                                    16)))
                                                                                                                                                                                              (let ((tmp.158
                                                                                                                                                                                                     (+
                                                                                                                                                                                                      tmp.335
                                                                                                                                                                                                      2)))
                                                                                                                                                                                                (begin
                                                                                                                                                                                                  (mset!
                                                                                                                                                                                                   tmp.158
                                                                                                                                                                                                   -2
                                                                                                                                                                                                   L.>=.58.24)
                                                                                                                                                                                                  (mset!
                                                                                                                                                                                                   tmp.158
                                                                                                                                                                                                   6
                                                                                                                                                                                                   16)
                                                                                                                                                                                                  (let ((>=.58
                                                                                                                                                                                                         tmp.158))
                                                                                                                                                                                                    (let ((tmp.336
                                                                                                                                                                                                           (alloc
                                                                                                                                                                                                            16)))
                                                                                                                                                                                                      (let ((tmp.159
                                                                                                                                                                                                             (+
                                                                                                                                                                                                              tmp.336
                                                                                                                                                                                                              2)))
                                                                                                                                                                                                        (begin
                                                                                                                                                                                                          (mset!
                                                                                                                                                                                                           tmp.159
                                                                                                                                                                                                           -2
                                                                                                                                                                                                           L.>.57.25)
                                                                                                                                                                                                          (mset!
                                                                                                                                                                                                           tmp.159
                                                                                                                                                                                                           6
                                                                                                                                                                                                           16)
                                                                                                                                                                                                          (let ((>.57
                                                                                                                                                                                                                 tmp.159))
                                                                                                                                                                                                            (let ((tmp.337
                                                                                                                                                                                                                   (alloc
                                                                                                                                                                                                                    16)))
                                                                                                                                                                                                              (let ((tmp.160
                                                                                                                                                                                                                     (+
                                                                                                                                                                                                                      tmp.337
                                                                                                                                                                                                                      2)))
                                                                                                                                                                                                                (begin
                                                                                                                                                                                                                  (mset!
                                                                                                                                                                                                                   tmp.160
                                                                                                                                                                                                                   -2
                                                                                                                                                                                                                   L.<=.56.26)
                                                                                                                                                                                                                  (mset!
                                                                                                                                                                                                                   tmp.160
                                                                                                                                                                                                                   6
                                                                                                                                                                                                                   16)
                                                                                                                                                                                                                  (let ((<=.56
                                                                                                                                                                                                                         tmp.160))
                                                                                                                                                                                                                    (let ((tmp.338
                                                                                                                                                                                                                           (alloc
                                                                                                                                                                                                                            16)))
                                                                                                                                                                                                                      (let ((tmp.161
                                                                                                                                                                                                                             (+
                                                                                                                                                                                                                              tmp.338
                                                                                                                                                                                                                              2)))
                                                                                                                                                                                                                        (begin
                                                                                                                                                                                                                          (mset!
                                                                                                                                                                                                                           tmp.161
                                                                                                                                                                                                                           -2
                                                                                                                                                                                                                           L.<.55.27)
                                                                                                                                                                                                                          (mset!
                                                                                                                                                                                                                           tmp.161
                                                                                                                                                                                                                           6
                                                                                                                                                                                                                           16)
                                                                                                                                                                                                                          (let ((<.55
                                                                                                                                                                                                                                 tmp.161))
                                                                                                                                                                                                                            (let ((tmp.339
                                                                                                                                                                                                                                   (alloc
                                                                                                                                                                                                                                    16)))
                                                                                                                                                                                                                              (let ((tmp.162
                                                                                                                                                                                                                                     (+
                                                                                                                                                                                                                                      tmp.339
                                                                                                                                                                                                                                      2)))
                                                                                                                                                                                                                                (begin
                                                                                                                                                                                                                                  (mset!
                                                                                                                                                                                                                                   tmp.162
                                                                                                                                                                                                                                   -2
                                                                                                                                                                                                                                   L.-.54.28)
                                                                                                                                                                                                                                  (mset!
                                                                                                                                                                                                                                   tmp.162
                                                                                                                                                                                                                                   6
                                                                                                                                                                                                                                   16)
                                                                                                                                                                                                                                  (let ((|-.54|
                                                                                                                                                                                                                                         tmp.162))
                                                                                                                                                                                                                                    (let ((tmp.340
                                                                                                                                                                                                                                           (alloc
                                                                                                                                                                                                                                            16)))
                                                                                                                                                                                                                                      (let ((tmp.163
                                                                                                                                                                                                                                             (+
                                                                                                                                                                                                                                              tmp.340
                                                                                                                                                                                                                                              2)))
                                                                                                                                                                                                                                        (begin
                                                                                                                                                                                                                                          (mset!
                                                                                                                                                                                                                                           tmp.163
                                                                                                                                                                                                                                           -2
                                                                                                                                                                                                                                           L.+.53.29)
                                                                                                                                                                                                                                          (mset!
                                                                                                                                                                                                                                           tmp.163
                                                                                                                                                                                                                                           6
                                                                                                                                                                                                                                           16)
                                                                                                                                                                                                                                          (let ((|+.53|
                                                                                                                                                                                                                                                 tmp.163))
                                                                                                                                                                                                                                            (let ((tmp.341
                                                                                                                                                                                                                                                   (alloc
                                                                                                                                                                                                                                                    16)))
                                                                                                                                                                                                                                              (let ((tmp.164
                                                                                                                                                                                                                                                     (+
                                                                                                                                                                                                                                                      tmp.341
                                                                                                                                                                                                                                                      2)))
                                                                                                                                                                                                                                                (begin
                                                                                                                                                                                                                                                  (mset!
                                                                                                                                                                                                                                                   tmp.164
                                                                                                                                                                                                                                                   -2
                                                                                                                                                                                                                                                   L.*.52.30)
                                                                                                                                                                                                                                                  (mset!
                                                                                                                                                                                                                                                   tmp.164
                                                                                                                                                                                                                                                   6
                                                                                                                                                                                                                                                   16)
                                                                                                                                                                                                                                                  (let ((*.52
                                                                                                                                                                                                                                                         tmp.164))
                                                                                                                                                                                                                                                    (begin
                                                                                                                                                                                                                                                      (mset!
                                                                                                                                                                                                                                                       vector-init-loop.80
                                                                                                                                                                                                                                                       14
                                                                                                                                                                                                                                                       vector-init-loop.80)
                                                                                                                                                                                                                                                      (mset!
                                                                                                                                                                                                                                                       make-init-vector.1
                                                                                                                                                                                                                                                       14
                                                                                                                                                                                                                                                       vector-init-loop.80)
                                                                                                                                                                                                                                                      (mset!
                                                                                                                                                                                                                                                       vector-ref.62
                                                                                                                                                                                                                                                       14
                                                                                                                                                                                                                                                       unsafe-vector-ref.3)
                                                                                                                                                                                                                                                      (mset!
                                                                                                                                                                                                                                                       vector-set!.61
                                                                                                                                                                                                                                                       14
                                                                                                                                                                                                                                                       unsafe-vector-set!.2)
                                                                                                                                                                                                                                                      (mset!
                                                                                                                                                                                                                                                       make-vector.59
                                                                                                                                                                                                                                                       14
                                                                                                                                                                                                                                                       make-init-vector.1)
                                                                                                                                                                                                                                                      (let ((tmp.342
                                                                                                                                                                                                                                                             (alloc
                                                                                                                                                                                                                                                              48)))
                                                                                                                                                                                                                                                        (let ((tmp.165
                                                                                                                                                                                                                                                               (+
                                                                                                                                                                                                                                                                tmp.342
                                                                                                                                                                                                                                                                2)))
                                                                                                                                                                                                                                                          (begin
                                                                                                                                                                                                                                                            (mset!
                                                                                                                                                                                                                                                             tmp.165
                                                                                                                                                                                                                                                             -2
                                                                                                                                                                                                                                                             L.error.4.31)
                                                                                                                                                                                                                                                            (mset!
                                                                                                                                                                                                                                                             tmp.165
                                                                                                                                                                                                                                                             6
                                                                                                                                                                                                                                                             8)
                                                                                                                                                                                                                                                            (let ((error.4
                                                                                                                                                                                                                                                                   tmp.165))
                                                                                                                                                                                                                                                              (begin
                                                                                                                                                                                                                                                                (mset!
                                                                                                                                                                                                                                                                 error.4
                                                                                                                                                                                                                                                                 14
                                                                                                                                                                                                                                                                 eq?.77)
                                                                                                                                                                                                                                                                (mset!
                                                                                                                                                                                                                                                                 error.4
                                                                                                                                                                                                                                                                 22
                                                                                                                                                                                                                                                                 *.52)
                                                                                                                                                                                                                                                                (mset!
                                                                                                                                                                                                                                                                 error.4
                                                                                                                                                                                                                                                                 30
                                                                                                                                                                                                                                                                 error.4)
                                                                                                                                                                                                                                                                (mset!
                                                                                                                                                                                                                                                                 error.4
                                                                                                                                                                                                                                                                 38
                                                                                                                                                                                                                                                                 |-.54|)
                                                                                                                                                                                                                                                                (let ((let.12
                                                                                                                                                                                                                                                                       40))
                                                                                                                                                                                                                                                                  (let ((define.13
                                                                                                                                                                                                                                                                         error.4))
                                                                                                                                                                                                                                                                    (let ((tmp.132
                                                                                                                                                                                                                                                                           define.13))
                                                                                                                                                                                                                                                                      (let ((tmp.349
                                                                                                                                                                                                                                                                             (bitwise-and
                                                                                                                                                                                                                                                                              tmp.132
                                                                                                                                                                                                                                                                              7)))
                                                                                                                                                                                                                                                                        (if (eq?
                                                                                                                                                                                                                                                                             tmp.349
                                                                                                                                                                                                                                                                             2)
                                                                                                                                                                                                                                                                          (apply
                                                                                                                                                                                                                                                                           L.jp.119
                                                                                                                                                                                                                                                                           14
                                                                                                                                                                                                                                                                           tmp.132
                                                                                                                                                                                                                                                                           let.12
                                                                                                                                                                                                                                                                           define.13)
                                                                                                                                                                                                                                                                          (apply
                                                                                                                                                                                                                                                                           L.jp.119
                                                                                                                                                                                                                                                                           6
                                                                                                                                                                                                                                                                           tmp.132
                                                                                                                                                                                                                                                                           let.12
                                                                                                                                                                                                                                                                           define.13)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
    ) 120)
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
     (execute '(module
    (define L.error.4.31
      (lambda (c.122 define.5)
        (let ((eq?.77 (mref c.122 14)))
          (let ((*.52 (mref c.122 22)))
            (let ((error.4 (mref c.122 30)))
              (let ((|-.54| (mref c.122 38)))
                (let ((not.6 eq?.77))
                  (let ((letrec.7 |-.54|))
                    (begin
                      (let ((eq?.8 8))
                        (let ((apply.9 0))
                          (let ((lambda.10 define.5))
                            (let ((let.11 *.52))
                              (if (neq?
                                   (let ((tmp.129 not.6))
                                     (if (neq?
                                          (if (eq? (bitwise-and tmp.129 7) 2)
                                            14
                                            6)
                                          6)
                                       (if (neq?
                                            (if (eq? (mref tmp.129 6) 16) 14 6)
                                            6)
                                         (apply
                                          (mref tmp.129 -2)
                                          not.6
                                          define.5
                                          apply.9)
                                         10814)
                                       11070))
                                   6)
                                eq?.8
                                (let ((tmp.130 let.11))
                                  (if (neq?
                                       (if (eq? (bitwise-and tmp.130 7) 2)
                                         14
                                         6)
                                       6)
                                    (if (neq?
                                         (if (eq? (mref tmp.130 6) 16) 14 6)
                                         6)
                                      (apply
                                       (mref tmp.130 -2)
                                       let.11
                                       define.5
                                       (let ((tmp.128 error.4))
                                         (apply
                                          L.error.4.31
                                          error.4
                                          (let ((tmp.131 letrec.7))
                                            (if (neq?
                                                 (if (eq?
                                                      (bitwise-and tmp.131 7)
                                                      2)
                                                   14
                                                   6)
                                                 6)
                                              (if (neq?
                                                   (if (eq?
                                                        (mref tmp.131 6)
                                                        16)
                                                     14
                                                     6)
                                                   6)
                                                (apply
                                                 (mref tmp.131 -2)
                                                 letrec.7
                                                 lambda.10
                                                 eq?.8)
                                                10814)
                                              11070)))))
                                      10814)
                                    11070))))))))))))))))
    (define L.*.52.30
      (lambda (c.121 tmp.14 tmp.15)
        (if (neq? (if (eq? (bitwise-and tmp.15 7) 0) 14 6) 6)
          (if (neq? (if (eq? (bitwise-and tmp.14 7) 0) 14 6) 6)
            (* tmp.14 (arithmetic-shift-right tmp.15 3))
            62)
          62)))
    (define L.+.53.29
      (lambda (c.120 tmp.16 tmp.17)
        (if (neq? (if (eq? (bitwise-and tmp.17 7) 0) 14 6) 6)
          (if (neq? (if (eq? (bitwise-and tmp.16 7) 0) 14 6) 6)
            (+ tmp.16 tmp.17)
            318)
          318)))
    (define L.-.54.28
      (lambda (c.119 tmp.18 tmp.19)
        (if (neq? (if (eq? (bitwise-and tmp.19 7) 0) 14 6) 6)
          (if (neq? (if (eq? (bitwise-and tmp.18 7) 0) 14 6) 6)
            (- tmp.18 tmp.19)
            574)
          574)))
    (define L.<.55.27
      (lambda (c.118 tmp.20 tmp.21)
        (if (neq? (if (eq? (bitwise-and tmp.21 7) 0) 14 6) 6)
          (if (neq? (if (eq? (bitwise-and tmp.20 7) 0) 14 6) 6)
            (if (< tmp.20 tmp.21) 14 6)
            830)
          830)))
    (define L.<=.56.26
      (lambda (c.117 tmp.22 tmp.23)
        (if (neq? (if (eq? (bitwise-and tmp.23 7) 0) 14 6) 6)
          (if (neq? (if (eq? (bitwise-and tmp.22 7) 0) 14 6) 6)
            (if (<= tmp.22 tmp.23) 14 6)
            1086)
          1086)))
    (define L.>.57.25
      (lambda (c.116 tmp.24 tmp.25)
        (if (neq? (if (eq? (bitwise-and tmp.25 7) 0) 14 6) 6)
          (if (neq? (if (eq? (bitwise-and tmp.24 7) 0) 14 6) 6)
            (if (> tmp.24 tmp.25) 14 6)
            1342)
          1342)))
    (define L.>=.58.24
      (lambda (c.115 tmp.26 tmp.27)
        (if (neq? (if (eq? (bitwise-and tmp.27 7) 0) 14 6) 6)
          (if (neq? (if (eq? (bitwise-and tmp.26 7) 0) 14 6) 6)
            (if (>= tmp.26 tmp.27) 14 6)
            1598)
          1598)))
    (define L.make-vector.59.23
      (lambda (c.114 tmp.28)
        (let ((make-init-vector.1 (mref c.114 14)))
          (if (neq? (if (eq? (bitwise-and tmp.28 7) 0) 14 6) 6)
            (let ((tmp.127 make-init-vector.1))
              (apply L.make-init-vector.1.4 make-init-vector.1 tmp.28))
            1854))))
    (define L.vector-length.60.22
      (lambda (c.113 tmp.29)
        (if (neq? (if (eq? (bitwise-and tmp.29 7) 3) 14 6) 6)
          (mref tmp.29 -3)
          2110)))
    (define L.vector-set!.61.21
      (lambda (c.112 tmp.30 tmp.31 tmp.32)
        (let ((unsafe-vector-set!.2 (mref c.112 14)))
          (if (neq? (if (eq? (bitwise-and tmp.31 7) 0) 14 6) 6)
            (if (neq? (if (eq? (bitwise-and tmp.30 7) 3) 14 6) 6)
              (let ((tmp.126 unsafe-vector-set!.2))
                (apply
                 L.unsafe-vector-set!.2.2
                 unsafe-vector-set!.2
                 tmp.30
                 tmp.31
                 tmp.32))
              2366)
            2366))))
    (define L.vector-ref.62.20
      (lambda (c.111 tmp.33 tmp.34)
        (let ((unsafe-vector-ref.3 (mref c.111 14)))
          (if (neq? (if (eq? (bitwise-and tmp.34 7) 0) 14 6) 6)
            (if (neq? (if (eq? (bitwise-and tmp.33 7) 3) 14 6) 6)
              (let ((tmp.125 unsafe-vector-ref.3))
                (apply
                 L.unsafe-vector-ref.3.1
                 unsafe-vector-ref.3
                 tmp.33
                 tmp.34))
              2622)
            2622))))
    (define L.car.63.19
      (lambda (c.110 tmp.35)
        (if (neq? (if (eq? (bitwise-and tmp.35 7) 1) 14 6) 6)
          (mref tmp.35 -1)
          2878)))
    (define L.cdr.64.18
      (lambda (c.109 tmp.36)
        (if (neq? (if (eq? (bitwise-and tmp.36 7) 1) 14 6) 6)
          (mref tmp.36 7)
          3134)))
    (define L.procedure-arity.65.17
      (lambda (c.108 tmp.37)
        (if (neq? (if (eq? (bitwise-and tmp.37 7) 2) 14 6) 6)
          (mref tmp.37 6)
          3390)))
    (define L.fixnum?.66.16
      (lambda (c.107 tmp.38) (if (eq? (bitwise-and tmp.38 7) 0) 14 6)))
    (define L.boolean?.67.15
      (lambda (c.106 tmp.39) (if (eq? (bitwise-and tmp.39 247) 6) 14 6)))
    (define L.empty?.68.14
      (lambda (c.105 tmp.40) (if (eq? (bitwise-and tmp.40 255) 22) 14 6)))
    (define L.void?.69.13
      (lambda (c.104 tmp.41) (if (eq? (bitwise-and tmp.41 255) 30) 14 6)))
    (define L.ascii-char?.70.12
      (lambda (c.103 tmp.42) (if (eq? (bitwise-and tmp.42 255) 46) 14 6)))
    (define L.error?.71.11
      (lambda (c.102 tmp.43) (if (eq? (bitwise-and tmp.43 255) 62) 14 6)))
    (define L.pair?.72.10
      (lambda (c.101 tmp.44) (if (eq? (bitwise-and tmp.44 7) 1) 14 6)))
    (define L.procedure?.73.9
      (lambda (c.100 tmp.45) (if (eq? (bitwise-and tmp.45 7) 2) 14 6)))
    (define L.vector?.74.8
      (lambda (c.99 tmp.46) (if (eq? (bitwise-and tmp.46 7) 3) 14 6)))
    (define L.not.75.7 (lambda (c.98 tmp.47) (if (neq? tmp.47 6) 6 14)))
    (define L.cons.76.6
      (lambda (c.97 tmp.48 tmp.49)
        (let ((tmp.133 (+ (alloc 16) 1)))
          (begin (mset! tmp.133 -1 tmp.48) (mset! tmp.133 7 tmp.49) tmp.133))))
    (define L.eq?.77.5
      (lambda (c.96 tmp.50 tmp.51) (if (eq? tmp.50 tmp.51) 14 6)))
    (define L.make-init-vector.1.4
      (lambda (c.95 tmp.78)
        (let ((vector-init-loop.80 (mref c.95 14)))
          (let ((tmp.79
                 (let ((tmp.134
                        (+
                         (alloc (* (+ 1 (arithmetic-shift-right tmp.78 3)) 8))
                         3)))
                   (begin (mset! tmp.134 -3 tmp.78) tmp.134))))
            (let ((tmp.124 vector-init-loop.80))
              (apply
               L.vector-init-loop.80.3
               vector-init-loop.80
               tmp.78
               0
               tmp.79))))))
    (define L.vector-init-loop.80.3
      (lambda (c.94 len.81 i.83 vec.82)
        (let ((vector-init-loop.80 (mref c.94 14)))
          (if (neq? (if (eq? len.81 i.83) 14 6) 6)
            vec.82
            (begin
              (mset! vec.82 (+ (* (arithmetic-shift-right i.83 3) 8) 5) 0)
              (let ((tmp.123 vector-init-loop.80))
                (apply
                 L.vector-init-loop.80.3
                 vector-init-loop.80
                 len.81
                 (+ i.83 8)
                 vec.82)))))))
    (define L.unsafe-vector-set!.2.2
      (lambda (c.93 tmp.89 tmp.90 tmp.91)
        (if (neq? (if (< tmp.90 (mref tmp.89 -3)) 14 6) 6)
          (if (neq? (if (>= tmp.90 0) 14 6) 6)
            (begin
              (mset!
               tmp.89
               (+ (* (arithmetic-shift-right tmp.90 3) 8) 5)
               tmp.91)
              30)
            2366)
          2366)))
    (define L.unsafe-vector-ref.3.1
      (lambda (c.92 tmp.86 tmp.87)
        (if (neq? (if (< tmp.87 (mref tmp.86 -3)) 14 6) 6)
          (if (neq? (if (>= tmp.87 0) 14 6) 6)
            (mref tmp.86 (+ (* (arithmetic-shift-right tmp.87 3) 8) 5))
            2622)
          2622)))
    (let ((unsafe-vector-ref.3
           (let ((tmp.135 (+ (alloc 16) 2)))
             (begin
               (mset! tmp.135 -2 L.unsafe-vector-ref.3.1)
               (mset! tmp.135 6 16)
               tmp.135))))
      (let ((unsafe-vector-set!.2
             (let ((tmp.136 (+ (alloc 16) 2)))
               (begin
                 (mset! tmp.136 -2 L.unsafe-vector-set!.2.2)
                 (mset! tmp.136 6 24)
                 tmp.136))))
        (let ((vector-init-loop.80
               (let ((tmp.137 (+ (alloc 24) 2)))
                 (begin
                   (mset! tmp.137 -2 L.vector-init-loop.80.3)
                   (mset! tmp.137 6 24)
                   tmp.137))))
          (let ((make-init-vector.1
                 (let ((tmp.138 (+ (alloc 24) 2)))
                   (begin
                     (mset! tmp.138 -2 L.make-init-vector.1.4)
                     (mset! tmp.138 6 8)
                     tmp.138))))
            (let ((eq?.77
                   (let ((tmp.139 (+ (alloc 16) 2)))
                     (begin
                       (mset! tmp.139 -2 L.eq?.77.5)
                       (mset! tmp.139 6 16)
                       tmp.139))))
              (let ((cons.76
                     (let ((tmp.140 (+ (alloc 16) 2)))
                       (begin
                         (mset! tmp.140 -2 L.cons.76.6)
                         (mset! tmp.140 6 16)
                         tmp.140))))
                (let ((not.75
                       (let ((tmp.141 (+ (alloc 16) 2)))
                         (begin
                           (mset! tmp.141 -2 L.not.75.7)
                           (mset! tmp.141 6 8)
                           tmp.141))))
                  (let ((vector?.74
                         (let ((tmp.142 (+ (alloc 16) 2)))
                           (begin
                             (mset! tmp.142 -2 L.vector?.74.8)
                             (mset! tmp.142 6 8)
                             tmp.142))))
                    (let ((procedure?.73
                           (let ((tmp.143 (+ (alloc 16) 2)))
                             (begin
                               (mset! tmp.143 -2 L.procedure?.73.9)
                               (mset! tmp.143 6 8)
                               tmp.143))))
                      (let ((pair?.72
                             (let ((tmp.144 (+ (alloc 16) 2)))
                               (begin
                                 (mset! tmp.144 -2 L.pair?.72.10)
                                 (mset! tmp.144 6 8)
                                 tmp.144))))
                        (let ((error?.71
                               (let ((tmp.145 (+ (alloc 16) 2)))
                                 (begin
                                   (mset! tmp.145 -2 L.error?.71.11)
                                   (mset! tmp.145 6 8)
                                   tmp.145))))
                          (let ((ascii-char?.70
                                 (let ((tmp.146 (+ (alloc 16) 2)))
                                   (begin
                                     (mset! tmp.146 -2 L.ascii-char?.70.12)
                                     (mset! tmp.146 6 8)
                                     tmp.146))))
                            (let ((void?.69
                                   (let ((tmp.147 (+ (alloc 16) 2)))
                                     (begin
                                       (mset! tmp.147 -2 L.void?.69.13)
                                       (mset! tmp.147 6 8)
                                       tmp.147))))
                              (let ((empty?.68
                                     (let ((tmp.148 (+ (alloc 16) 2)))
                                       (begin
                                         (mset! tmp.148 -2 L.empty?.68.14)
                                         (mset! tmp.148 6 8)
                                         tmp.148))))
                                (let ((boolean?.67
                                       (let ((tmp.149 (+ (alloc 16) 2)))
                                         (begin
                                           (mset! tmp.149 -2 L.boolean?.67.15)
                                           (mset! tmp.149 6 8)
                                           tmp.149))))
                                  (let ((fixnum?.66
                                         (let ((tmp.150 (+ (alloc 16) 2)))
                                           (begin
                                             (mset! tmp.150 -2 L.fixnum?.66.16)
                                             (mset! tmp.150 6 8)
                                             tmp.150))))
                                    (let ((procedure-arity.65
                                           (let ((tmp.151 (+ (alloc 16) 2)))
                                             (begin
                                               (mset!
                                                tmp.151
                                                -2
                                                L.procedure-arity.65.17)
                                               (mset! tmp.151 6 8)
                                               tmp.151))))
                                      (let ((cdr.64
                                             (let ((tmp.152 (+ (alloc 16) 2)))
                                               (begin
                                                 (mset! tmp.152 -2 L.cdr.64.18)
                                                 (mset! tmp.152 6 8)
                                                 tmp.152))))
                                        (let ((car.63
                                               (let ((tmp.153
                                                      (+ (alloc 16) 2)))
                                                 (begin
                                                   (mset!
                                                    tmp.153
                                                    -2
                                                    L.car.63.19)
                                                   (mset! tmp.153 6 8)
                                                   tmp.153))))
                                          (let ((vector-ref.62
                                                 (let ((tmp.154
                                                        (+ (alloc 24) 2)))
                                                   (begin
                                                     (mset!
                                                      tmp.154
                                                      -2
                                                      L.vector-ref.62.20)
                                                     (mset! tmp.154 6 16)
                                                     tmp.154))))
                                            (let ((vector-set!.61
                                                   (let ((tmp.155
                                                          (+ (alloc 24) 2)))
                                                     (begin
                                                       (mset!
                                                        tmp.155
                                                        -2
                                                        L.vector-set!.61.21)
                                                       (mset! tmp.155 6 24)
                                                       tmp.155))))
                                              (let ((vector-length.60
                                                     (let ((tmp.156
                                                            (+ (alloc 16) 2)))
                                                       (begin
                                                         (mset!
                                                          tmp.156
                                                          -2
                                                          L.vector-length.60.22)
                                                         (mset! tmp.156 6 8)
                                                         tmp.156))))
                                                (let ((make-vector.59
                                                       (let ((tmp.157
                                                              (+
                                                               (alloc 24)
                                                               2)))
                                                         (begin
                                                           (mset!
                                                            tmp.157
                                                            -2
                                                            L.make-vector.59.23)
                                                           (mset! tmp.157 6 8)
                                                           tmp.157))))
                                                  (let ((>=.58
                                                         (let ((tmp.158
                                                                (+
                                                                 (alloc 16)
                                                                 2)))
                                                           (begin
                                                             (mset!
                                                              tmp.158
                                                              -2
                                                              L.>=.58.24)
                                                             (mset!
                                                              tmp.158
                                                              6
                                                              16)
                                                             tmp.158))))
                                                    (let ((>.57
                                                           (let ((tmp.159
                                                                  (+
                                                                   (alloc 16)
                                                                   2)))
                                                             (begin
                                                               (mset!
                                                                tmp.159
                                                                -2
                                                                L.>.57.25)
                                                               (mset!
                                                                tmp.159
                                                                6
                                                                16)
                                                               tmp.159))))
                                                      (let ((<=.56
                                                             (let ((tmp.160
                                                                    (+
                                                                     (alloc 16)
                                                                     2)))
                                                               (begin
                                                                 (mset!
                                                                  tmp.160
                                                                  -2
                                                                  L.<=.56.26)
                                                                 (mset!
                                                                  tmp.160
                                                                  6
                                                                  16)
                                                                 tmp.160))))
                                                        (let ((<.55
                                                               (let ((tmp.161
                                                                      (+
                                                                       (alloc
                                                                        16)
                                                                       2)))
                                                                 (begin
                                                                   (mset!
                                                                    tmp.161
                                                                    -2
                                                                    L.<.55.27)
                                                                   (mset!
                                                                    tmp.161
                                                                    6
                                                                    16)
                                                                   tmp.161))))
                                                          (let ((|-.54|
                                                                 (let ((tmp.162
                                                                        (+
                                                                         (alloc
                                                                          16)
                                                                         2)))
                                                                   (begin
                                                                     (mset!
                                                                      tmp.162
                                                                      -2
                                                                      L.-.54.28)
                                                                     (mset!
                                                                      tmp.162
                                                                      6
                                                                      16)
                                                                     tmp.162))))
                                                            (let ((|+.53|
                                                                   (let ((tmp.163
                                                                          (+
                                                                           (alloc
                                                                            16)
                                                                           2)))
                                                                     (begin
                                                                       (mset!
                                                                        tmp.163
                                                                        -2
                                                                        L.+.53.29)
                                                                       (mset!
                                                                        tmp.163
                                                                        6
                                                                        16)
                                                                       tmp.163))))
                                                              (let ((*.52
                                                                     (let ((tmp.164
                                                                            (+
                                                                             (alloc
                                                                              16)
                                                                             2)))
                                                                       (begin
                                                                         (mset!
                                                                          tmp.164
                                                                          -2
                                                                          L.*.52.30)
                                                                         (mset!
                                                                          tmp.164
                                                                          6
                                                                          16)
                                                                         tmp.164))))
                                                                (begin
                                                                  (begin)
                                                                  (begin)
                                                                  (begin
                                                                    (mset!
                                                                     vector-init-loop.80
                                                                     14
                                                                     vector-init-loop.80))
                                                                  (begin
                                                                    (mset!
                                                                     make-init-vector.1
                                                                     14
                                                                     vector-init-loop.80))
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
                                                                    (mset!
                                                                     vector-ref.62
                                                                     14
                                                                     unsafe-vector-ref.3))
                                                                  (begin
                                                                    (mset!
                                                                     vector-set!.61
                                                                     14
                                                                     unsafe-vector-set!.2))
                                                                  (begin)
                                                                  (begin
                                                                    (mset!
                                                                     make-vector.59
                                                                     14
                                                                     make-init-vector.1))
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (let ((error.4
                                                                         (let ((tmp.165
                                                                                (+
                                                                                 (alloc
                                                                                  48)
                                                                                 2)))
                                                                           (begin
                                                                             (mset!
                                                                              tmp.165
                                                                              -2
                                                                              L.error.4.31)
                                                                             (mset!
                                                                              tmp.165
                                                                              6
                                                                              8)
                                                                             tmp.165))))
                                                                    (begin
                                                                      (begin
                                                                        (mset!
                                                                         error.4
                                                                         14
                                                                         eq?.77)
                                                                        (mset!
                                                                         error.4
                                                                         22
                                                                         *.52)
                                                                        (mset!
                                                                         error.4
                                                                         30
                                                                         error.4)
                                                                        (mset!
                                                                         error.4
                                                                         38
                                                                         |-.54|))
                                                                      (let ((let.12
                                                                             40))
                                                                        (let ((define.13
                                                                               error.4))
                                                                          (begin
                                                                            (let ((tmp.132
                                                                                   define.13))
                                                                              (if (neq?
                                                                                   (if (eq?
                                                                                        (bitwise-and
                                                                                         tmp.132
                                                                                         7)
                                                                                        2)
                                                                                     14
                                                                                     6)
                                                                                   6)
                                                                                (if (neq?
                                                                                     (if (eq?
                                                                                          (mref
                                                                                           tmp.132
                                                                                           6)
                                                                                          8)
                                                                                       14
                                                                                       6)
                                                                                     6)
                                                                                  (apply
                                                                                   (mref
                                                                                    tmp.132
                                                                                    -2)
                                                                                   define.13
                                                                                   let.12)
                                                                                  10814)
                                                                                11070)))))))))))))))))))))))))))))))))))))))
     ) 120)
  )

  #|
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
          ) 120)

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
     ) 120)

  )
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
     (execute 
     ) 120)

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
     (execute 
     ) 120)

  )
   |#

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
              (lambda (tmp.86 tmp.87)
                (if (unsafe-fx< tmp.87 (unsafe-vector-length tmp.86))
                  (if (unsafe-fx>= tmp.87 0)
                    (unsafe-vector-ref tmp.86 tmp.87)
                    (error 10))
                  (error 10))))
             (unsafe-vector-set!.2
              (lambda (tmp.89 tmp.90 tmp.91)
                (if (unsafe-fx< tmp.90 (unsafe-vector-length tmp.89))
                  (if (unsafe-fx>= tmp.90 0)
                    (begin (unsafe-vector-set! tmp.89 tmp.90 tmp.91) (void))
                    (error 9))
                  (error 9))))
             (vector-init-loop.80
              (lambda (len.81 i.83 vec.82)
                (if (eq? len.81 i.83)
                  vec.82
                  (begin
                    (unsafe-vector-set! vec.82 i.83 0)
                    (apply
                     vector-init-loop.80
                     len.81
                     (unsafe-fx+ i.83 1)
                     vec.82)))))
             (make-init-vector.1
              (lambda (tmp.78)
                (let ((tmp.79 (unsafe-make-vector tmp.78)))
                  (apply vector-init-loop.80 tmp.78 0 tmp.79))))
             (eq?.77 (lambda (tmp.50 tmp.51) (eq? tmp.50 tmp.51)))
             (cons.76 (lambda (tmp.48 tmp.49) (cons tmp.48 tmp.49)))
             (not.75 (lambda (tmp.47) (not tmp.47)))
             (vector?.74 (lambda (tmp.46) (vector? tmp.46)))
             (procedure?.73 (lambda (tmp.45) (procedure? tmp.45)))
             (pair?.72 (lambda (tmp.44) (pair? tmp.44)))
             (error?.71 (lambda (tmp.43) (error? tmp.43)))
             (ascii-char?.70 (lambda (tmp.42) (ascii-char? tmp.42)))
             (void?.69 (lambda (tmp.41) (void? tmp.41)))
             (empty?.68 (lambda (tmp.40) (empty? tmp.40)))
             (boolean?.67 (lambda (tmp.39) (boolean? tmp.39)))
             (fixnum?.66 (lambda (tmp.38) (fixnum? tmp.38)))
             (procedure-arity.65
              (lambda (tmp.37)
                (if (procedure? tmp.37)
                  (unsafe-procedure-arity tmp.37)
                  (error 13))))
             (cdr.64
              (lambda (tmp.36)
                (if (pair? tmp.36) (unsafe-cdr tmp.36) (error 12))))
             (car.63
              (lambda (tmp.35)
                (if (pair? tmp.35) (unsafe-car tmp.35) (error 11))))
             (vector-ref.62
              (lambda (tmp.33 tmp.34)
                (if (fixnum? tmp.34)
                  (if (vector? tmp.33)
                    (apply unsafe-vector-ref.3 tmp.33 tmp.34)
                    (error 10))
                  (error 10))))
             (vector-set!.61
              (lambda (tmp.30 tmp.31 tmp.32)
                (if (fixnum? tmp.31)
                  (if (vector? tmp.30)
                    (apply unsafe-vector-set!.2 tmp.30 tmp.31 tmp.32)
                    (error 9))
                  (error 9))))
             (vector-length.60
              (lambda (tmp.29)
                (if (vector? tmp.29) (unsafe-vector-length tmp.29) (error 8))))
             (make-vector.59
              (lambda (tmp.28)
                (if (fixnum? tmp.28)
                  (apply make-init-vector.1 tmp.28)
                  (error 7))))
             (>=.58
              (lambda (tmp.26 tmp.27)
                (if (fixnum? tmp.27)
                  (if (fixnum? tmp.26) (unsafe-fx>= tmp.26 tmp.27) (error 6))
                  (error 6))))
             (>.57
              (lambda (tmp.24 tmp.25)
                (if (fixnum? tmp.25)
                  (if (fixnum? tmp.24) (unsafe-fx> tmp.24 tmp.25) (error 5))
                  (error 5))))
             (<=.56
              (lambda (tmp.22 tmp.23)
                (if (fixnum? tmp.23)
                  (if (fixnum? tmp.22) (unsafe-fx<= tmp.22 tmp.23) (error 4))
                  (error 4))))
             (<.55
              (lambda (tmp.20 tmp.21)
                (if (fixnum? tmp.21)
                  (if (fixnum? tmp.20) (unsafe-fx< tmp.20 tmp.21) (error 3))
                  (error 3))))
             (|-.54|
              (lambda (tmp.18 tmp.19)
                (if (fixnum? tmp.19)
                  (if (fixnum? tmp.18) (unsafe-fx- tmp.18 tmp.19) (error 2))
                  (error 2))))
             (|+.53|
              (lambda (tmp.16 tmp.17)
                (if (fixnum? tmp.17)
                  (if (fixnum? tmp.16) (unsafe-fx+ tmp.16 tmp.17) (error 1))
                  (error 1))))
             (*.52
              (lambda (tmp.14 tmp.15)
                (if (fixnum? tmp.15)
                  (if (fixnum? tmp.14) (unsafe-fx* tmp.14 tmp.15) (error 0))
                  (error 0)))))
      (let ()
        (let ()
          (letrec ((error.4
                    (lambda (define.5)
                      (let ((not.6 eq?.77))
                        (let ((letrec.7 |-.54|))
                          (let ()
                            (letrec ()
                              (let ()
                                (let ((eq?.8 1))
                                  (let ((apply.9 0))
                                    (let ((lambda.10 define.5))
                                      (let ((let.11 *.52))
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
                  (let ()
                    (letrec () (let () (apply define.13 let.12))))))))))))
     ) 120)

  )

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
                (let () (letrec () (let () (apply define.13 let.12)))))))))))
     ) 120)

  )


 (parameterize ([current-pass-list
                  (list
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
    (letrec ((error.4
              (lambda (define.5)
                (let ((not.6 eq?))
                  (letrec ((letrec.7 -))
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
                                (apply letrec.7 lambda.10 eq?.8)))))))))))))
      (let ((let.12 5))
        (letrec ((define.13 error.4)) (apply define.13 let.12)))))
     ) 120)

  )


 (parameterize ([current-pass-list
                  (list
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
    (define error.4
      (lambda (define.5)
        (let ((not.6 eq?))
          (letrec ((letrec.7 -))
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
                        (apply letrec.7 lambda.10 eq?.8))))))))))))
    (let ((let.12 5)) (letrec ((define.13 error.4)) (apply define.13 let.12))))
     ) 120)

  )

 (parameterize ([current-pass-list
                  (list
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
    (let ((let.12 5)) (letrec ((define.13 error.4)) (define.13 let.12))))
     ) 120)

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
     (execute '(module
    (define error
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
    (let ((let 5)) (letrec ((define error)) (define let))))
     ) 120)

  )
 
  
  )