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
     ) 3))

(parameterize ([current-pass-list
                  (list
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute 
     ) 3))

(parameterize ([current-pass-list
                  (list
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])

    (check-equal?
     (execute 
     ) 3))

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
     ) 3))

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
     ) 3))

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
     ) 3))



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
     ) 3))



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
     ) 3))

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
     ) 3)

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
     ) 3)

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
     ) 3)

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
    (define L.main.118
      ((new-frames ()))
      (begin
        (set! ra.361 r15)
        (set! tmp.303 (alloc 16))
        (set! tmp.362 (+ tmp.303 2))
        (set! tmp.147 tmp.362)
        (mset! tmp.147 -2 L.unsafe-vector-ref.3.1)
        (mset! tmp.147 6 16)
        (set! unsafe-vector-ref.3 tmp.147)
        (set! tmp.304 (alloc 16))
        (set! tmp.363 (+ tmp.304 2))
        (set! tmp.148 tmp.363)
        (mset! tmp.148 -2 L.unsafe-vector-set!.2.2)
        (mset! tmp.148 6 24)
        (set! unsafe-vector-set!.2 tmp.148)
        (set! tmp.305 (alloc 24))
        (set! tmp.364 (+ tmp.305 2))
        (set! tmp.149 tmp.364)
        (mset! tmp.149 -2 L.vector-init-loop.78.3)
        (mset! tmp.149 6 24)
        (set! vector-init-loop.78 tmp.149)
        (set! tmp.306 (alloc 24))
        (set! tmp.365 (+ tmp.306 2))
        (set! tmp.150 tmp.365)
        (mset! tmp.150 -2 L.make-init-vector.1.4)
        (mset! tmp.150 6 8)
        (set! make-init-vector.1 tmp.150)
        (set! tmp.307 (alloc 16))
        (set! tmp.366 (+ tmp.307 2))
        (set! tmp.151 tmp.366)
        (mset! tmp.151 -2 L.eq?.75.5)
        (mset! tmp.151 6 16)
        (set! eq?.75 tmp.151)
        (set! tmp.308 (alloc 16))
        (set! tmp.367 (+ tmp.308 2))
        (set! tmp.152 tmp.367)
        (mset! tmp.152 -2 L.cons.74.6)
        (mset! tmp.152 6 16)
        (set! cons.74 tmp.152)
        (set! tmp.309 (alloc 16))
        (set! tmp.368 (+ tmp.309 2))
        (set! tmp.153 tmp.368)
        (mset! tmp.153 -2 L.not.73.7)
        (mset! tmp.153 6 8)
        (set! not.73 tmp.153)
        (set! tmp.310 (alloc 16))
        (set! tmp.369 (+ tmp.310 2))
        (set! tmp.154 tmp.369)
        (mset! tmp.154 -2 L.vector?.72.8)
        (mset! tmp.154 6 8)
        (set! vector?.72 tmp.154)
        (set! tmp.311 (alloc 16))
        (set! tmp.370 (+ tmp.311 2))
        (set! tmp.155 tmp.370)
        (mset! tmp.155 -2 L.procedure?.71.9)
        (mset! tmp.155 6 8)
        (set! procedure?.71 tmp.155)
        (set! tmp.312 (alloc 16))
        (set! tmp.371 (+ tmp.312 2))
        (set! tmp.156 tmp.371)
        (mset! tmp.156 -2 L.pair?.70.10)
        (mset! tmp.156 6 8)
        (set! pair?.70 tmp.156)
        (set! tmp.313 (alloc 16))
        (set! tmp.372 (+ tmp.313 2))
        (set! tmp.157 tmp.372)
        (mset! tmp.157 -2 L.error?.69.11)
        (mset! tmp.157 6 8)
        (set! error?.69 tmp.157)
        (set! tmp.314 (alloc 16))
        (set! tmp.373 (+ tmp.314 2))
        (set! tmp.158 tmp.373)
        (mset! tmp.158 -2 L.ascii-char?.68.12)
        (mset! tmp.158 6 8)
        (set! ascii-char?.68 tmp.158)
        (set! tmp.315 (alloc 16))
        (set! tmp.374 (+ tmp.315 2))
        (set! tmp.159 tmp.374)
        (mset! tmp.159 -2 L.void?.67.13)
        (mset! tmp.159 6 8)
        (set! void?.67 tmp.159)
        (set! tmp.316 (alloc 16))
        (set! tmp.375 (+ tmp.316 2))
        (set! tmp.160 tmp.375)
        (mset! tmp.160 -2 L.empty?.66.14)
        (mset! tmp.160 6 8)
        (set! empty?.66 tmp.160)
        (set! tmp.317 (alloc 16))
        (set! tmp.376 (+ tmp.317 2))
        (set! tmp.161 tmp.376)
        (mset! tmp.161 -2 L.boolean?.65.15)
        (mset! tmp.161 6 8)
        (set! boolean?.65 tmp.161)
        (set! tmp.318 (alloc 16))
        (set! tmp.377 (+ tmp.318 2))
        (set! tmp.162 tmp.377)
        (mset! tmp.162 -2 L.fixnum?.64.16)
        (mset! tmp.162 6 8)
        (set! fixnum?.64 tmp.162)
        (set! tmp.319 (alloc 16))
        (set! tmp.378 (+ tmp.319 2))
        (set! tmp.163 tmp.378)
        (mset! tmp.163 -2 L.procedure-arity.63.17)
        (mset! tmp.163 6 8)
        (set! procedure-arity.63 tmp.163)
        (set! tmp.320 (alloc 16))
        (set! tmp.379 (+ tmp.320 2))
        (set! tmp.164 tmp.379)
        (mset! tmp.164 -2 L.cdr.62.18)
        (mset! tmp.164 6 8)
        (set! cdr.62 tmp.164)
        (set! tmp.321 (alloc 16))
        (set! tmp.380 (+ tmp.321 2))
        (set! tmp.165 tmp.380)
        (mset! tmp.165 -2 L.car.61.19)
        (mset! tmp.165 6 8)
        (set! car.61 tmp.165)
        (set! tmp.322 (alloc 24))
        (set! tmp.381 (+ tmp.322 2))
        (set! tmp.166 tmp.381)
        (mset! tmp.166 -2 L.vector-ref.60.20)
        (mset! tmp.166 6 16)
        (set! vector-ref.60 tmp.166)
        (set! tmp.323 (alloc 24))
        (set! tmp.382 (+ tmp.323 2))
        (set! tmp.167 tmp.382)
        (mset! tmp.167 -2 L.vector-set!.59.21)
        (mset! tmp.167 6 24)
        (set! vector-set!.59 tmp.167)
        (set! tmp.324 (alloc 16))
        (set! tmp.383 (+ tmp.324 2))
        (set! tmp.168 tmp.383)
        (mset! tmp.168 -2 L.vector-length.58.22)
        (mset! tmp.168 6 8)
        (set! vector-length.58 tmp.168)
        (set! tmp.325 (alloc 24))
        (set! tmp.384 (+ tmp.325 2))
        (set! tmp.169 tmp.384)
        (mset! tmp.169 -2 L.make-vector.57.23)
        (mset! tmp.169 6 8)
        (set! make-vector.57 tmp.169)
        (set! tmp.326 (alloc 16))
        (set! tmp.385 (+ tmp.326 2))
        (set! tmp.170 tmp.385)
        (mset! tmp.170 -2 L.>=.56.24)
        (mset! tmp.170 6 16)
        (set! >=.56 tmp.170)
        (set! tmp.327 (alloc 16))
        (set! tmp.386 (+ tmp.327 2))
        (set! tmp.171 tmp.386)
        (mset! tmp.171 -2 L.>.55.25)
        (mset! tmp.171 6 16)
        (set! >.55 tmp.171)
        (set! tmp.328 (alloc 16))
        (set! tmp.387 (+ tmp.328 2))
        (set! tmp.172 tmp.387)
        (mset! tmp.172 -2 L.<=.54.26)
        (mset! tmp.172 6 16)
        (set! <=.54 tmp.172)
        (set! tmp.329 (alloc 16))
        (set! tmp.388 (+ tmp.329 2))
        (set! tmp.173 tmp.388)
        (mset! tmp.173 -2 L.<.53.27)
        (mset! tmp.173 6 16)
        (set! <.53 tmp.173)
        (set! tmp.330 (alloc 16))
        (set! tmp.389 (+ tmp.330 2))
        (set! tmp.174 tmp.389)
        (mset! tmp.174 -2 L.-.52.28)
        (mset! tmp.174 6 16)
        (set! |-.52| tmp.174)
        (set! tmp.331 (alloc 16))
        (set! tmp.390 (+ tmp.331 2))
        (set! tmp.175 tmp.390)
        (mset! tmp.175 -2 L.+.51.29)
        (mset! tmp.175 6 16)
        (set! |+.51| tmp.175)
        (set! tmp.332 (alloc 16))
        (set! tmp.391 (+ tmp.332 2))
        (set! tmp.176 tmp.391)
        (mset! tmp.176 -2 L.*.50.30)
        (mset! tmp.176 6 16)
        (set! *.50 tmp.176)
        (mset! vector-init-loop.78 14 vector-init-loop.78)
        (mset! make-init-vector.1 14 vector-init-loop.78)
        (mset! vector-ref.60 14 unsafe-vector-ref.3)
        (mset! vector-set!.59 14 unsafe-vector-set!.2)
        (mset! make-vector.57 14 make-init-vector.1)
        (set! tmp.129 make-vector.57)
        (return-point L.rp.119
          (begin
            (set! rsi 8)
            (set! rdi make-vector.57)
            (set! r15 L.rp.119)
            (jump L.make-vector.57.23 rbp r15 rsi rdi)))
        (set! counter!.4 rax)
        (set! tmp.130 make-vector.57)
        (return-point L.rp.120
          (begin
            (set! rsi 8)
            (set! rdi make-vector.57)
            (set! r15 L.rp.120)
            (jump L.make-vector.57.23 rbp r15 rsi rdi)))
        (set! x.5 rax)
        (set! tmp.333 (alloc 56))
        (set! tmp.392 (+ tmp.333 2))
        (set! tmp.177 tmp.392)
        (mset! tmp.177 -2 L.tmp.11.31)
        (mset! tmp.177 6 0)
        (set! tmp.11 tmp.177)
        (mset! tmp.11 14 vector-ref.60)
        (mset! tmp.11 22 |+.51|)
        (mset! tmp.11 30 x.5)
        (mset! tmp.11 38 vector-set!.59)
        (mset! tmp.11 46 error?.69)
        (set! counter!.4.9 tmp.11)
        (set! tmp.136 vector-set!.59)
        (return-point L.rp.121
          (begin
            (set! rcx counter!.4.9)
            (set! rdx 0)
            (set! rsi counter!.4)
            (set! rdi vector-set!.59)
            (set! r15 L.rp.121)
            (jump L.vector-set!.59.21 rbp r15 rcx rdx rsi rdi)))
        (set! tmp.10 rax)
        (set! tmp.137 vector-ref.60)
        (return-point L.rp.122
          (begin
            (set! rdx 0)
            (set! rsi counter!.4)
            (set! rdi vector-ref.60)
            (set! r15 L.rp.122)
            (jump L.vector-ref.60.20 rbp r15 rdx rsi rdi)))
        (set! tmp.121 rax)
        (set! tmp.142 tmp.121)
        (set! tmp.393 (bitwise-and tmp.142 7))
        (set! tmp.360 tmp.393)
        (if (eq? tmp.360 2)
          (begin
            (set! r9 tmp.121)
            (set! r8 vector-ref.60)
            (set! rcx counter!.4)
            (set! rdx error?.69)
            (set! rsi tmp.142)
            (set! rdi 14)
            (set! r15 ra.361)
            (jump L.jp.117 rbp r15 r9 r8 rcx rdx rsi rdi))
          (begin
            (set! r9 tmp.121)
            (set! r8 vector-ref.60)
            (set! rcx counter!.4)
            (set! rdx error?.69)
            (set! rsi tmp.142)
            (set! rdi 6)
            (set! r15 ra.361)
            (jump L.jp.117 rbp r15 r9 r8 rcx rdx rsi rdi)))))
    (define L.tmp.11.31
      ((new-frames ()))
      (begin
        (set! ra.394 r15)
        (set! c.120 rdi)
        (set! vector-ref.60 (mref c.120 14))
        (set! |+.51| (mref c.120 22))
        (set! x.5 (mref c.120 30))
        (set! vector-set!.59 (mref c.120 38))
        (set! error?.69 (mref c.120 46))
        (set! tmp.131 vector-set!.59)
        (set! tmp.132 |+.51|)
        (set! tmp.133 vector-ref.60)
        (return-point L.rp.123
          (begin
            (set! rdx 0)
            (set! rsi x.5)
            (set! rdi vector-ref.60)
            (set! r15 L.rp.123)
            (jump L.vector-ref.60.20 rbp r15 rdx rsi rdi)))
        (set! tmp.178 rax)
        (return-point L.rp.124
          (begin
            (set! rdx tmp.178)
            (set! rsi 8)
            (set! rdi |+.51|)
            (set! r15 L.rp.124)
            (jump L.+.51.29 rbp r15 rdx rsi rdi)))
        (set! tmp.179 rax)
        (return-point L.rp.125
          (begin
            (set! rcx tmp.179)
            (set! rdx 0)
            (set! rsi x.5)
            (set! rdi vector-set!.59)
            (set! r15 L.rp.125)
            (jump L.vector-set!.59.21 rbp r15 rcx rdx rsi rdi)))
        (set! tmp.6 rax)
        (set! tmp.134 error?.69)
        (return-point L.rp.126
          (begin
            (set! rsi tmp.6)
            (set! rdi error?.69)
            (set! r15 L.rp.126)
            (jump L.error?.69.11 rbp r15 rsi rdi)))
        (set! tmp.181 rax)
        (if (neq? tmp.181 6)
          (begin (set! rax tmp.6) (jump ra.394 rbp rax))
          (begin
            (set! tmp.135 vector-ref.60)
            (set! rdx 0)
            (set! rsi x.5)
            (set! rdi vector-ref.60)
            (set! r15 ra.394)
            (jump L.vector-ref.60.20 rbp r15 rdx rsi rdi)))))
    (define L.*.50.30
      ((new-frames ()))
      (begin
        (set! ra.395 r15)
        (set! c.119 rdi)
        (set! tmp.12 rsi)
        (set! tmp.13 rdx)
        (set! tmp.396 (bitwise-and tmp.13 7))
        (set! tmp.188 tmp.396)
        (if (eq? tmp.188 0)
          (begin
            (set! rdx tmp.13)
            (set! rsi tmp.12)
            (set! rdi 14)
            (set! r15 ra.395)
            (jump L.jp.36 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.13)
            (set! rsi tmp.12)
            (set! rdi 6)
            (set! r15 ra.395)
            (jump L.jp.36 rbp r15 rdx rsi rdi)))))
    (define L.+.51.29
      ((new-frames ()))
      (begin
        (set! ra.397 r15)
        (set! c.118 rdi)
        (set! tmp.14 rsi)
        (set! tmp.15 rdx)
        (set! tmp.398 (bitwise-and tmp.15 7))
        (set! tmp.194 tmp.398)
        (if (eq? tmp.194 0)
          (begin
            (set! rdx tmp.15)
            (set! rsi tmp.14)
            (set! rdi 14)
            (set! r15 ra.397)
            (jump L.jp.40 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.15)
            (set! rsi tmp.14)
            (set! rdi 6)
            (set! r15 ra.397)
            (jump L.jp.40 rbp r15 rdx rsi rdi)))))
    (define L.-.52.28
      ((new-frames ()))
      (begin
        (set! ra.399 r15)
        (set! c.117 rdi)
        (set! tmp.16 rsi)
        (set! tmp.17 rdx)
        (set! tmp.400 (bitwise-and tmp.17 7))
        (set! tmp.200 tmp.400)
        (if (eq? tmp.200 0)
          (begin
            (set! rdx tmp.17)
            (set! rsi tmp.16)
            (set! rdi 14)
            (set! r15 ra.399)
            (jump L.jp.44 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.17)
            (set! rsi tmp.16)
            (set! rdi 6)
            (set! r15 ra.399)
            (jump L.jp.44 rbp r15 rdx rsi rdi)))))
    (define L.<.53.27
      ((new-frames ()))
      (begin
        (set! ra.401 r15)
        (set! c.116 rdi)
        (set! tmp.18 rsi)
        (set! tmp.19 rdx)
        (set! tmp.402 (bitwise-and tmp.19 7))
        (set! tmp.207 tmp.402)
        (if (eq? tmp.207 0)
          (begin
            (set! rdx tmp.19)
            (set! rsi tmp.18)
            (set! rdi 14)
            (set! r15 ra.401)
            (jump L.jp.49 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.19)
            (set! rsi tmp.18)
            (set! rdi 6)
            (set! r15 ra.401)
            (jump L.jp.49 rbp r15 rdx rsi rdi)))))
    (define L.<=.54.26
      ((new-frames ()))
      (begin
        (set! ra.403 r15)
        (set! c.115 rdi)
        (set! tmp.20 rsi)
        (set! tmp.21 rdx)
        (set! tmp.404 (bitwise-and tmp.21 7))
        (set! tmp.214 tmp.404)
        (if (eq? tmp.214 0)
          (begin
            (set! rdx tmp.21)
            (set! rsi tmp.20)
            (set! rdi 14)
            (set! r15 ra.403)
            (jump L.jp.54 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.21)
            (set! rsi tmp.20)
            (set! rdi 6)
            (set! r15 ra.403)
            (jump L.jp.54 rbp r15 rdx rsi rdi)))))
    (define L.>.55.25
      ((new-frames ()))
      (begin
        (set! ra.405 r15)
        (set! c.114 rdi)
        (set! tmp.22 rsi)
        (set! tmp.23 rdx)
        (set! tmp.406 (bitwise-and tmp.23 7))
        (set! tmp.221 tmp.406)
        (if (eq? tmp.221 0)
          (begin
            (set! rdx tmp.23)
            (set! rsi tmp.22)
            (set! rdi 14)
            (set! r15 ra.405)
            (jump L.jp.59 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.23)
            (set! rsi tmp.22)
            (set! rdi 6)
            (set! r15 ra.405)
            (jump L.jp.59 rbp r15 rdx rsi rdi)))))
    (define L.>=.56.24
      ((new-frames ()))
      (begin
        (set! ra.407 r15)
        (set! c.113 rdi)
        (set! tmp.24 rsi)
        (set! tmp.25 rdx)
        (set! tmp.408 (bitwise-and tmp.25 7))
        (set! tmp.228 tmp.408)
        (if (eq? tmp.228 0)
          (begin
            (set! rdx tmp.25)
            (set! rsi tmp.24)
            (set! rdi 14)
            (set! r15 ra.407)
            (jump L.jp.64 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.25)
            (set! rsi tmp.24)
            (set! rdi 6)
            (set! r15 ra.407)
            (jump L.jp.64 rbp r15 rdx rsi rdi)))))
    (define L.make-vector.57.23
      ((new-frames ()))
      (begin
        (set! ra.409 r15)
        (set! c.112 rdi)
        (set! tmp.26 rsi)
        (set! make-init-vector.1 (mref c.112 14))
        (set! tmp.410 (bitwise-and tmp.26 7))
        (set! tmp.231 tmp.410)
        (if (eq? tmp.231 0)
          (begin
            (set! rdx tmp.26)
            (set! rsi make-init-vector.1)
            (set! rdi 14)
            (set! r15 ra.409)
            (jump L.jp.66 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.26)
            (set! rsi make-init-vector.1)
            (set! rdi 6)
            (set! r15 ra.409)
            (jump L.jp.66 rbp r15 rdx rsi rdi)))))
    (define L.vector-length.58.22
      ((new-frames ()))
      (begin
        (set! ra.411 r15)
        (set! c.111 rdi)
        (set! tmp.27 rsi)
        (set! tmp.412 (bitwise-and tmp.27 7))
        (set! tmp.234 tmp.412)
        (if (eq? tmp.234 3)
          (begin
            (set! rsi tmp.27)
            (set! rdi 14)
            (set! r15 ra.411)
            (jump L.jp.68 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.27)
            (set! rdi 6)
            (set! r15 ra.411)
            (jump L.jp.68 rbp r15 rsi rdi)))))
    (define L.vector-set!.59.21
      ((new-frames ()))
      (begin
        (set! ra.413 r15)
        (set! c.110 rdi)
        (set! tmp.28 rsi)
        (set! tmp.29 rdx)
        (set! tmp.30 rcx)
        (set! unsafe-vector-set!.2 (mref c.110 14))
        (set! tmp.414 (bitwise-and tmp.29 7))
        (set! tmp.240 tmp.414)
        (if (eq? tmp.240 0)
          (begin
            (set! r8 tmp.29)
            (set! rcx tmp.30)
            (set! rdx unsafe-vector-set!.2)
            (set! rsi tmp.28)
            (set! rdi 14)
            (set! r15 ra.413)
            (jump L.jp.72 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 tmp.29)
            (set! rcx tmp.30)
            (set! rdx unsafe-vector-set!.2)
            (set! rsi tmp.28)
            (set! rdi 6)
            (set! r15 ra.413)
            (jump L.jp.72 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.vector-ref.60.20
      ((new-frames ()))
      (begin
        (set! ra.415 r15)
        (set! c.109 rdi)
        (set! tmp.31 rsi)
        (set! tmp.32 rdx)
        (set! unsafe-vector-ref.3 (mref c.109 14))
        (set! tmp.416 (bitwise-and tmp.32 7))
        (set! tmp.246 tmp.416)
        (if (eq? tmp.246 0)
          (begin
            (set! rcx tmp.32)
            (set! rdx unsafe-vector-ref.3)
            (set! rsi tmp.31)
            (set! rdi 14)
            (set! r15 ra.415)
            (jump L.jp.76 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx tmp.32)
            (set! rdx unsafe-vector-ref.3)
            (set! rsi tmp.31)
            (set! rdi 6)
            (set! r15 ra.415)
            (jump L.jp.76 rbp r15 rcx rdx rsi rdi)))))
    (define L.car.61.19
      ((new-frames ()))
      (begin
        (set! ra.417 r15)
        (set! c.108 rdi)
        (set! tmp.33 rsi)
        (set! tmp.418 (bitwise-and tmp.33 7))
        (set! tmp.249 tmp.418)
        (if (eq? tmp.249 1)
          (begin
            (set! rsi tmp.33)
            (set! rdi 14)
            (set! r15 ra.417)
            (jump L.jp.78 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.33)
            (set! rdi 6)
            (set! r15 ra.417)
            (jump L.jp.78 rbp r15 rsi rdi)))))
    (define L.cdr.62.18
      ((new-frames ()))
      (begin
        (set! ra.419 r15)
        (set! c.107 rdi)
        (set! tmp.34 rsi)
        (set! tmp.420 (bitwise-and tmp.34 7))
        (set! tmp.252 tmp.420)
        (if (eq? tmp.252 1)
          (begin
            (set! rsi tmp.34)
            (set! rdi 14)
            (set! r15 ra.419)
            (jump L.jp.80 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.34)
            (set! rdi 6)
            (set! r15 ra.419)
            (jump L.jp.80 rbp r15 rsi rdi)))))
    (define L.procedure-arity.63.17
      ((new-frames ()))
      (begin
        (set! ra.421 r15)
        (set! c.106 rdi)
        (set! tmp.35 rsi)
        (set! tmp.422 (bitwise-and tmp.35 7))
        (set! tmp.255 tmp.422)
        (if (eq? tmp.255 2)
          (begin
            (set! rsi tmp.35)
            (set! rdi 14)
            (set! r15 ra.421)
            (jump L.jp.82 rbp r15 rsi rdi))
          (begin
            (set! rsi tmp.35)
            (set! rdi 6)
            (set! r15 ra.421)
            (jump L.jp.82 rbp r15 rsi rdi)))))
    (define L.fixnum?.64.16
      ((new-frames ()))
      (begin
        (set! ra.423 r15)
        (set! c.105 rdi)
        (set! tmp.36 rsi)
        (set! tmp.424 (bitwise-and tmp.36 7))
        (set! tmp.257 tmp.424)
        (if (eq? tmp.257 0)
          (begin (set! rax 14) (jump ra.423 rbp rax))
          (begin (set! rax 6) (jump ra.423 rbp rax)))))
    (define L.boolean?.65.15
      ((new-frames ()))
      (begin
        (set! ra.425 r15)
        (set! c.104 rdi)
        (set! tmp.37 rsi)
        (set! tmp.426 (bitwise-and tmp.37 247))
        (set! tmp.259 tmp.426)
        (if (eq? tmp.259 6)
          (begin (set! rax 14) (jump ra.425 rbp rax))
          (begin (set! rax 6) (jump ra.425 rbp rax)))))
    (define L.empty?.66.14
      ((new-frames ()))
      (begin
        (set! ra.427 r15)
        (set! c.103 rdi)
        (set! tmp.38 rsi)
        (set! tmp.428 (bitwise-and tmp.38 255))
        (set! tmp.261 tmp.428)
        (if (eq? tmp.261 22)
          (begin (set! rax 14) (jump ra.427 rbp rax))
          (begin (set! rax 6) (jump ra.427 rbp rax)))))
    (define L.void?.67.13
      ((new-frames ()))
      (begin
        (set! ra.429 r15)
        (set! c.102 rdi)
        (set! tmp.39 rsi)
        (set! tmp.430 (bitwise-and tmp.39 255))
        (set! tmp.263 tmp.430)
        (if (eq? tmp.263 30)
          (begin (set! rax 14) (jump ra.429 rbp rax))
          (begin (set! rax 6) (jump ra.429 rbp rax)))))
    (define L.ascii-char?.68.12
      ((new-frames ()))
      (begin
        (set! ra.431 r15)
        (set! c.101 rdi)
        (set! tmp.40 rsi)
        (set! tmp.432 (bitwise-and tmp.40 255))
        (set! tmp.265 tmp.432)
        (if (eq? tmp.265 46)
          (begin (set! rax 14) (jump ra.431 rbp rax))
          (begin (set! rax 6) (jump ra.431 rbp rax)))))
    (define L.error?.69.11
      ((new-frames ()))
      (begin
        (set! ra.433 r15)
        (set! c.100 rdi)
        (set! tmp.41 rsi)
        (set! tmp.434 (bitwise-and tmp.41 255))
        (set! tmp.267 tmp.434)
        (if (eq? tmp.267 62)
          (begin (set! rax 14) (jump ra.433 rbp rax))
          (begin (set! rax 6) (jump ra.433 rbp rax)))))
    (define L.pair?.70.10
      ((new-frames ()))
      (begin
        (set! ra.435 r15)
        (set! c.99 rdi)
        (set! tmp.42 rsi)
        (set! tmp.436 (bitwise-and tmp.42 7))
        (set! tmp.269 tmp.436)
        (if (eq? tmp.269 1)
          (begin (set! rax 14) (jump ra.435 rbp rax))
          (begin (set! rax 6) (jump ra.435 rbp rax)))))
    (define L.procedure?.71.9
      ((new-frames ()))
      (begin
        (set! ra.437 r15)
        (set! c.98 rdi)
        (set! tmp.43 rsi)
        (set! tmp.438 (bitwise-and tmp.43 7))
        (set! tmp.271 tmp.438)
        (if (eq? tmp.271 2)
          (begin (set! rax 14) (jump ra.437 rbp rax))
          (begin (set! rax 6) (jump ra.437 rbp rax)))))
    (define L.vector?.72.8
      ((new-frames ()))
      (begin
        (set! ra.439 r15)
        (set! c.97 rdi)
        (set! tmp.44 rsi)
        (set! tmp.440 (bitwise-and tmp.44 7))
        (set! tmp.273 tmp.440)
        (if (eq? tmp.273 3)
          (begin (set! rax 14) (jump ra.439 rbp rax))
          (begin (set! rax 6) (jump ra.439 rbp rax)))))
    (define L.not.73.7
      ((new-frames ()))
      (begin
        (set! ra.441 r15)
        (set! c.96 rdi)
        (set! tmp.45 rsi)
        (if (neq? tmp.45 6)
          (begin (set! rax 6) (jump ra.441 rbp rax))
          (begin (set! rax 14) (jump ra.441 rbp rax)))))
    (define L.cons.74.6
      ((new-frames ()))
      (begin
        (set! ra.442 r15)
        (set! c.95 rdi)
        (set! tmp.46 rsi)
        (set! tmp.47 rdx)
        (set! tmp.275 (alloc 16))
        (set! tmp.443 (+ tmp.275 1))
        (set! tmp.145 tmp.443)
        (mset! tmp.145 -1 tmp.46)
        (mset! tmp.145 7 tmp.47)
        (set! rax tmp.145)
        (jump ra.442 rbp rax)))
    (define L.eq?.75.5
      ((new-frames ()))
      (begin
        (set! ra.444 r15)
        (set! c.94 rdi)
        (set! tmp.48 rsi)
        (set! tmp.49 rdx)
        (if (eq? tmp.48 tmp.49)
          (begin (set! rax 14) (jump ra.444 rbp rax))
          (begin (set! rax 6) (jump ra.444 rbp rax)))))
    (define L.make-init-vector.1.4
      ((new-frames ()))
      (begin
        (set! ra.445 r15)
        (set! c.93 rdi)
        (set! tmp.76 rsi)
        (set! vector-init-loop.78 (mref c.93 14))
        (set! tmp.446 (arithmetic-shift-right tmp.76 3))
        (set! tmp.277 tmp.446)
        (set! tmp.447 1)
        (set! tmp.448 (+ tmp.447 tmp.277))
        (set! tmp.278 tmp.448)
        (set! tmp.449 (* tmp.278 8))
        (set! tmp.279 tmp.449)
        (set! tmp.280 (alloc tmp.279))
        (set! tmp.450 (+ tmp.280 3))
        (set! tmp.146 tmp.450)
        (mset! tmp.146 -3 tmp.76)
        (set! tmp.77 tmp.146)
        (set! tmp.125 vector-init-loop.78)
        (set! rcx tmp.77)
        (set! rdx 0)
        (set! rsi tmp.76)
        (set! rdi vector-init-loop.78)
        (set! r15 ra.445)
        (jump L.vector-init-loop.78.3 rbp r15 rcx rdx rsi rdi)))
    (define L.vector-init-loop.78.3
      ((new-frames ()))
      (begin
        (set! ra.451 r15)
        (set! c.92 rdi)
        (set! len.79 rsi)
        (set! i.81 rdx)
        (set! vec.80 rcx)
        (set! vector-init-loop.78 (mref c.92 14))
        (if (eq? len.79 i.81)
          (begin
            (set! r8 vec.80)
            (set! rcx vector-init-loop.78)
            (set! rdx len.79)
            (set! rsi i.81)
            (set! rdi 14)
            (set! r15 ra.451)
            (jump L.jp.95 rbp r15 r8 rcx rdx rsi rdi))
          (begin
            (set! r8 vec.80)
            (set! rcx vector-init-loop.78)
            (set! rdx len.79)
            (set! rsi i.81)
            (set! rdi 6)
            (set! r15 ra.451)
            (jump L.jp.95 rbp r15 r8 rcx rdx rsi rdi)))))
    (define L.unsafe-vector-set!.2.2
      ((new-frames ()))
      (begin
        (set! ra.452 r15)
        (set! c.91 rdi)
        (set! tmp.87 rsi)
        (set! tmp.88 rdx)
        (set! tmp.89 rcx)
        (set! tmp.294 (mref tmp.87 -3))
        (if (< tmp.88 tmp.294)
          (begin
            (set! rcx tmp.87)
            (set! rdx tmp.89)
            (set! rsi tmp.88)
            (set! rdi 14)
            (set! r15 ra.452)
            (jump L.jp.99 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx tmp.87)
            (set! rdx tmp.89)
            (set! rsi tmp.88)
            (set! rdi 6)
            (set! r15 ra.452)
            (jump L.jp.99 rbp r15 rcx rdx rsi rdi)))))
    (define L.unsafe-vector-ref.3.1
      ((new-frames ()))
      (begin
        (set! ra.453 r15)
        (set! c.90 rdi)
        (set! tmp.84 rsi)
        (set! tmp.85 rdx)
        (set! tmp.302 (mref tmp.84 -3))
        (if (< tmp.85 tmp.302)
          (begin
            (set! rdx tmp.84)
            (set! rsi tmp.85)
            (set! rdi 14)
            (set! r15 ra.453)
            (jump L.jp.103 rbp r15 rdx rsi rdi))
          (begin
            (set! rdx tmp.84)
            (set! rsi tmp.85)
            (set! rdi 6)
            (set! r15 ra.453)
            (jump L.jp.103 rbp r15 rdx rsi rdi)))))
    (define L.jp.117
      ((new-frames ()))
      (begin
        (set! ra.454 r15)
        (set! tmp.354 rdi)
        (set! tmp.142 rsi)
        (set! error?.69 rdx)
        (set! counter!.4 rcx)
        (set! vector-ref.60 r8)
        (set! tmp.121 r9)
        (if (neq? tmp.354 6)
          (begin
            (set! tmp.359 (mref tmp.142 6))
            (if (eq? tmp.359 0)
              (begin
                (set! r9 tmp.121)
                (set! r8 vector-ref.60)
                (set! rcx counter!.4)
                (set! rdx error?.69)
                (set! rsi tmp.142)
                (set! rdi 14)
                (set! r15 ra.454)
                (jump L.jp.116 rbp r15 r9 r8 rcx rdx rsi rdi))
              (begin
                (set! r9 tmp.121)
                (set! r8 vector-ref.60)
                (set! rcx counter!.4)
                (set! rdx error?.69)
                (set! rsi tmp.142)
                (set! rdi 6)
                (set! r15 ra.454)
                (jump L.jp.116 rbp r15 r9 r8 rcx rdx rsi rdi))))
          (begin
            (set! rcx vector-ref.60)
            (set! rdx counter!.4)
            (set! rsi error?.69)
            (set! rdi 11070)
            (set! r15 ra.454)
            (jump L.jp.114 rbp r15 rcx rdx rsi rdi)))))
    (define L.jp.116
      ((new-frames ()))
      (begin
        (set! ra.455 r15)
        (set! tmp.356 rdi)
        (set! tmp.142 rsi)
        (set! error?.69 rdx)
        (set! counter!.4 rcx)
        (set! vector-ref.60 r8)
        (set! tmp.121 r9)
        (if (neq? tmp.356 6)
          (begin
            (set! tmp.357 (mref tmp.142 -2))
            (return-point L.rp.127
              (begin
                (set! rdi tmp.121)
                (set! r15 L.rp.127)
                (jump tmp.357 rbp r15 rdi)))
            (set! tmp.358 rax)
            (set! rcx vector-ref.60)
            (set! rdx counter!.4)
            (set! rsi error?.69)
            (set! rdi tmp.358)
            (set! r15 ra.455)
            (jump L.jp.114 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx vector-ref.60)
            (set! rdx counter!.4)
            (set! rsi error?.69)
            (set! rdi 10814)
            (set! r15 ra.455)
            (jump L.jp.114 rbp r15 rcx rdx rsi rdi)))))
    (define L.jp.114
      ((new-frames ()))
      (begin
        (set! ra.456 r15)
        (set! tmp.334 rdi)
        (set! error?.69 rsi)
        (set! counter!.4 rdx)
        (set! vector-ref.60 rcx)
        (set! tmp.7 tmp.334)
        (set! tmp.138 error?.69)
        (return-point L.rp.128
          (begin
            (set! rsi tmp.7)
            (set! rdi error?.69)
            (set! r15 L.rp.128)
            (jump L.error?.69.11 rbp r15 rsi rdi)))
        (set! tmp.336 rax)
        (if (neq? tmp.336 6)
          (begin (set! rax tmp.7) (jump ra.456 rbp rax))
          (begin
            (set! tmp.139 vector-ref.60)
            (return-point L.rp.129
              (begin
                (set! rdx 0)
                (set! rsi counter!.4)
                (set! rdi vector-ref.60)
                (set! r15 L.rp.129)
                (jump L.vector-ref.60.20 rbp r15 rdx rsi rdi)))
            (set! tmp.122 rax)
            (set! tmp.143 tmp.122)
            (set! tmp.457 (bitwise-and tmp.143 7))
            (set! tmp.353 tmp.457)
            (if (eq? tmp.353 2)
              (begin
                (set! r9 tmp.122)
                (set! r8 vector-ref.60)
                (set! rcx counter!.4)
                (set! rdx error?.69)
                (set! rsi tmp.143)
                (set! rdi 14)
                (set! r15 ra.456)
                (jump L.jp.113 rbp r15 r9 r8 rcx rdx rsi rdi))
              (begin
                (set! r9 tmp.122)
                (set! r8 vector-ref.60)
                (set! rcx counter!.4)
                (set! rdx error?.69)
                (set! rsi tmp.143)
                (set! rdi 6)
                (set! r15 ra.456)
                (jump L.jp.113 rbp r15 r9 r8 rcx rdx rsi rdi)))))))
    (define L.jp.113
      ((new-frames ()))
      (begin
        (set! ra.458 r15)
        (set! tmp.347 rdi)
        (set! tmp.143 rsi)
        (set! error?.69 rdx)
        (set! counter!.4 rcx)
        (set! vector-ref.60 r8)
        (set! tmp.122 r9)
        (if (neq? tmp.347 6)
          (begin
            (set! tmp.352 (mref tmp.143 6))
            (if (eq? tmp.352 0)
              (begin
                (set! r9 tmp.122)
                (set! r8 vector-ref.60)
                (set! rcx counter!.4)
                (set! rdx error?.69)
                (set! rsi tmp.143)
                (set! rdi 14)
                (set! r15 ra.458)
                (jump L.jp.112 rbp r15 r9 r8 rcx rdx rsi rdi))
              (begin
                (set! r9 tmp.122)
                (set! r8 vector-ref.60)
                (set! rcx counter!.4)
                (set! rdx error?.69)
                (set! rsi tmp.143)
                (set! rdi 6)
                (set! r15 ra.458)
                (jump L.jp.112 rbp r15 r9 r8 rcx rdx rsi rdi))))
          (begin
            (set! rcx vector-ref.60)
            (set! rdx counter!.4)
            (set! rsi error?.69)
            (set! rdi 11070)
            (set! r15 ra.458)
            (jump L.jp.110 rbp r15 rcx rdx rsi rdi)))))
    (define L.jp.112
      ((new-frames ()))
      (begin
        (set! ra.459 r15)
        (set! tmp.349 rdi)
        (set! tmp.143 rsi)
        (set! error?.69 rdx)
        (set! counter!.4 rcx)
        (set! vector-ref.60 r8)
        (set! tmp.122 r9)
        (if (neq? tmp.349 6)
          (begin
            (set! tmp.350 (mref tmp.143 -2))
            (return-point L.rp.130
              (begin
                (set! rdi tmp.122)
                (set! r15 L.rp.130)
                (jump tmp.350 rbp r15 rdi)))
            (set! tmp.351 rax)
            (set! rcx vector-ref.60)
            (set! rdx counter!.4)
            (set! rsi error?.69)
            (set! rdi tmp.351)
            (set! r15 ra.459)
            (jump L.jp.110 rbp r15 rcx rdx rsi rdi))
          (begin
            (set! rcx vector-ref.60)
            (set! rdx counter!.4)
            (set! rsi error?.69)
            (set! rdi 10814)
            (set! r15 ra.459)
            (jump L.jp.110 rbp r15 rcx rdx rsi rdi)))))
    (define L.jp.110
      ((new-frames ()))
      (begin
        (set! ra.460 r15)
        (set! tmp.337 rdi)
        (set! error?.69 rsi)
        (set! counter!.4 rdx)
        (set! vector-ref.60 rcx)
        (set! tmp.8 tmp.337)
        (set! tmp.140 error?.69)
        (return-point L.rp.131
          (begin
            (set! rsi tmp.8)
            (set! rdi error?.69)
            (set! r15 L.rp.131)
            (jump L.error?.69.11 rbp r15 rsi rdi)))
        (set! tmp.339 rax)
        (if (neq? tmp.339 6)
          (begin (set! rax tmp.8) (jump ra.460 rbp rax))
          (begin
            (set! tmp.141 vector-ref.60)
            (return-point L.rp.132
              (begin
                (set! rdx 0)
                (set! rsi counter!.4)
                (set! rdi vector-ref.60)
                (set! r15 L.rp.132)
                (jump L.vector-ref.60.20 rbp r15 rdx rsi rdi)))
            (set! tmp.123 rax)
            (set! tmp.144 tmp.123)
            (set! tmp.461 (bitwise-and tmp.144 7))
            (set! tmp.346 tmp.461)
            (if (eq? tmp.346 2)
              (begin
                (set! rdx tmp.123)
                (set! rsi tmp.144)
                (set! rdi 14)
                (set! r15 ra.460)
                (jump L.jp.109 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.123)
                (set! rsi tmp.144)
                (set! rdi 6)
                (set! r15 ra.460)
                (jump L.jp.109 rbp r15 rdx rsi rdi)))))))
    (define L.jp.109
      ((new-frames ()))
      (begin
        (set! ra.462 r15)
        (set! tmp.341 rdi)
        (set! tmp.144 rsi)
        (set! tmp.123 rdx)
        (if (neq? tmp.341 6)
          (begin
            (set! tmp.345 (mref tmp.144 6))
            (if (eq? tmp.345 0)
              (begin
                (set! rdx tmp.123)
                (set! rsi tmp.144)
                (set! rdi 14)
                (set! r15 ra.462)
                (jump L.jp.108 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.123)
                (set! rsi tmp.144)
                (set! rdi 6)
                (set! r15 ra.462)
                (jump L.jp.108 rbp r15 rdx rsi rdi))))
          (begin (set! rax 11070) (jump ra.462 rbp rax)))))
    (define L.jp.108
      ((new-frames ()))
      (begin
        (set! ra.463 r15)
        (set! tmp.343 rdi)
        (set! tmp.144 rsi)
        (set! tmp.123 rdx)
        (if (neq? tmp.343 6)
          (begin
            (set! tmp.344 (mref tmp.144 -2))
            (set! rdi tmp.123)
            (set! r15 ra.463)
            (jump tmp.344 rbp r15 rdi))
          (begin (set! rax 10814) (jump ra.463 rbp rax)))))
    (define L.jp.103
      ((new-frames ()))
      (begin
        (set! ra.464 r15)
        (set! tmp.296 rdi)
        (set! tmp.85 rsi)
        (set! tmp.84 rdx)
        (if (neq? tmp.296 6)
          (if (>= tmp.85 0)
            (begin
              (set! rdx tmp.84)
              (set! rsi tmp.85)
              (set! rdi 14)
              (set! r15 ra.464)
              (jump L.jp.102 rbp r15 rdx rsi rdi))
            (begin
              (set! rdx tmp.84)
              (set! rsi tmp.85)
              (set! rdi 6)
              (set! r15 ra.464)
              (jump L.jp.102 rbp r15 rdx rsi rdi)))
          (begin (set! rax 2622) (jump ra.464 rbp rax)))))
    (define L.jp.102
      ((new-frames ()))
      (begin
        (set! ra.465 r15)
        (set! tmp.298 rdi)
        (set! tmp.85 rsi)
        (set! tmp.84 rdx)
        (if (neq? tmp.298 6)
          (begin
            (set! tmp.466 (arithmetic-shift-right tmp.85 3))
            (set! tmp.299 tmp.466)
            (set! tmp.467 (* tmp.299 8))
            (set! tmp.300 tmp.467)
            (set! tmp.468 (+ tmp.300 5))
            (set! tmp.301 tmp.468)
            (set! rax (mref tmp.84 tmp.301))
            (jump ra.465 rbp rax))
          (begin (set! rax 2622) (jump ra.465 rbp rax)))))
    (define L.jp.99
      ((new-frames ()))
      (begin
        (set! ra.469 r15)
        (set! tmp.288 rdi)
        (set! tmp.88 rsi)
        (set! tmp.89 rdx)
        (set! tmp.87 rcx)
        (if (neq? tmp.288 6)
          (if (>= tmp.88 0)
            (begin
              (set! rcx tmp.89)
              (set! rdx tmp.87)
              (set! rsi tmp.88)
              (set! rdi 14)
              (set! r15 ra.469)
              (jump L.jp.98 rbp r15 rcx rdx rsi rdi))
            (begin
              (set! rcx tmp.89)
              (set! rdx tmp.87)
              (set! rsi tmp.88)
              (set! rdi 6)
              (set! r15 ra.469)
              (jump L.jp.98 rbp r15 rcx rdx rsi rdi)))
          (begin (set! rax 2366) (jump ra.469 rbp rax)))))
    (define L.jp.98
      ((new-frames ()))
      (begin
        (set! ra.470 r15)
        (set! tmp.290 rdi)
        (set! tmp.88 rsi)
        (set! tmp.87 rdx)
        (set! tmp.89 rcx)
        (if (neq? tmp.290 6)
          (begin
            (set! tmp.471 (arithmetic-shift-right tmp.88 3))
            (set! tmp.291 tmp.471)
            (set! tmp.472 (* tmp.291 8))
            (set! tmp.292 tmp.472)
            (set! tmp.473 (+ tmp.292 5))
            (set! tmp.293 tmp.473)
            (mset! tmp.87 tmp.293 tmp.89)
            (set! rax 30)
            (jump ra.470 rbp rax))
          (begin (set! rax 2366) (jump ra.470 rbp rax)))))
    (define L.jp.95
      ((new-frames ()))
      (begin
        (set! ra.474 r15)
        (set! tmp.282 rdi)
        (set! i.81 rsi)
        (set! len.79 rdx)
        (set! vector-init-loop.78 rcx)
        (set! vec.80 r8)
        (if (neq? tmp.282 6)
          (begin (set! rax vec.80) (jump ra.474 rbp rax))
          (begin
            (set! tmp.475 (arithmetic-shift-right i.81 3))
            (set! tmp.283 tmp.475)
            (set! tmp.476 (* tmp.283 8))
            (set! tmp.284 tmp.476)
            (set! tmp.477 (+ tmp.284 5))
            (set! tmp.285 tmp.477)
            (mset! vec.80 tmp.285 0)
            (set! tmp.124 vector-init-loop.78)
            (set! tmp.478 (+ i.81 8))
            (set! tmp.286 tmp.478)
            (set! rcx vec.80)
            (set! rdx tmp.286)
            (set! rsi len.79)
            (set! rdi vector-init-loop.78)
            (set! r15 ra.474)
            (jump L.vector-init-loop.78.3 rbp r15 rcx rdx rsi rdi)))))
    (define L.jp.82
      ((new-frames ()))
      (begin
        (set! ra.479 r15)
        (set! tmp.254 rdi)
        (set! tmp.35 rsi)
        (if (neq? tmp.254 6)
          (begin (set! rax (mref tmp.35 6)) (jump ra.479 rbp rax))
          (begin (set! rax 3390) (jump ra.479 rbp rax)))))
    (define L.jp.80
      ((new-frames ()))
      (begin
        (set! ra.480 r15)
        (set! tmp.251 rdi)
        (set! tmp.34 rsi)
        (if (neq? tmp.251 6)
          (begin (set! rax (mref tmp.34 7)) (jump ra.480 rbp rax))
          (begin (set! rax 3134) (jump ra.480 rbp rax)))))
    (define L.jp.78
      ((new-frames ()))
      (begin
        (set! ra.481 r15)
        (set! tmp.248 rdi)
        (set! tmp.33 rsi)
        (if (neq? tmp.248 6)
          (begin (set! rax (mref tmp.33 -1)) (jump ra.481 rbp rax))
          (begin (set! rax 2878) (jump ra.481 rbp rax)))))
    (define L.jp.76
      ((new-frames ()))
      (begin
        (set! ra.482 r15)
        (set! tmp.242 rdi)
        (set! tmp.31 rsi)
        (set! unsafe-vector-ref.3 rdx)
        (set! tmp.32 rcx)
        (if (neq? tmp.242 6)
          (begin
            (set! tmp.483 (bitwise-and tmp.31 7))
            (set! tmp.245 tmp.483)
            (if (eq? tmp.245 3)
              (begin
                (set! rcx tmp.31)
                (set! rdx tmp.32)
                (set! rsi unsafe-vector-ref.3)
                (set! rdi 14)
                (set! r15 ra.482)
                (jump L.jp.75 rbp r15 rcx rdx rsi rdi))
              (begin
                (set! rcx tmp.31)
                (set! rdx tmp.32)
                (set! rsi unsafe-vector-ref.3)
                (set! rdi 6)
                (set! r15 ra.482)
                (jump L.jp.75 rbp r15 rcx rdx rsi rdi))))
          (begin (set! rax 2622) (jump ra.482 rbp rax)))))
    (define L.jp.75
      ((new-frames ()))
      (begin
        (set! ra.484 r15)
        (set! tmp.244 rdi)
        (set! unsafe-vector-ref.3 rsi)
        (set! tmp.32 rdx)
        (set! tmp.31 rcx)
        (if (neq? tmp.244 6)
          (begin
            (set! tmp.126 unsafe-vector-ref.3)
            (set! rdx tmp.32)
            (set! rsi tmp.31)
            (set! rdi unsafe-vector-ref.3)
            (set! r15 ra.484)
            (jump L.unsafe-vector-ref.3.1 rbp r15 rdx rsi rdi))
          (begin (set! rax 2622) (jump ra.484 rbp rax)))))
    (define L.jp.72
      ((new-frames ()))
      (begin
        (set! ra.485 r15)
        (set! tmp.236 rdi)
        (set! tmp.28 rsi)
        (set! unsafe-vector-set!.2 rdx)
        (set! tmp.30 rcx)
        (set! tmp.29 r8)
        (if (neq? tmp.236 6)
          (begin
            (set! tmp.486 (bitwise-and tmp.28 7))
            (set! tmp.239 tmp.486)
            (if (eq? tmp.239 3)
              (begin
                (set! r8 tmp.28)
                (set! rcx tmp.29)
                (set! rdx tmp.30)
                (set! rsi unsafe-vector-set!.2)
                (set! rdi 14)
                (set! r15 ra.485)
                (jump L.jp.71 rbp r15 r8 rcx rdx rsi rdi))
              (begin
                (set! r8 tmp.28)
                (set! rcx tmp.29)
                (set! rdx tmp.30)
                (set! rsi unsafe-vector-set!.2)
                (set! rdi 6)
                (set! r15 ra.485)
                (jump L.jp.71 rbp r15 r8 rcx rdx rsi rdi))))
          (begin (set! rax 2366) (jump ra.485 rbp rax)))))
    (define L.jp.71
      ((new-frames ()))
      (begin
        (set! ra.487 r15)
        (set! tmp.238 rdi)
        (set! unsafe-vector-set!.2 rsi)
        (set! tmp.30 rdx)
        (set! tmp.29 rcx)
        (set! tmp.28 r8)
        (if (neq? tmp.238 6)
          (begin
            (set! tmp.127 unsafe-vector-set!.2)
            (set! rcx tmp.30)
            (set! rdx tmp.29)
            (set! rsi tmp.28)
            (set! rdi unsafe-vector-set!.2)
            (set! r15 ra.487)
            (jump L.unsafe-vector-set!.2.2 rbp r15 rcx rdx rsi rdi))
          (begin (set! rax 2366) (jump ra.487 rbp rax)))))
    (define L.jp.68
      ((new-frames ()))
      (begin
        (set! ra.488 r15)
        (set! tmp.233 rdi)
        (set! tmp.27 rsi)
        (if (neq? tmp.233 6)
          (begin (set! rax (mref tmp.27 -3)) (jump ra.488 rbp rax))
          (begin (set! rax 2110) (jump ra.488 rbp rax)))))
    (define L.jp.66
      ((new-frames ()))
      (begin
        (set! ra.489 r15)
        (set! tmp.230 rdi)
        (set! make-init-vector.1 rsi)
        (set! tmp.26 rdx)
        (if (neq? tmp.230 6)
          (begin
            (set! tmp.128 make-init-vector.1)
            (set! rsi tmp.26)
            (set! rdi make-init-vector.1)
            (set! r15 ra.489)
            (jump L.make-init-vector.1.4 rbp r15 rsi rdi))
          (begin (set! rax 1854) (jump ra.489 rbp rax)))))
    (define L.jp.64
      ((new-frames ()))
      (begin
        (set! ra.490 r15)
        (set! tmp.223 rdi)
        (set! tmp.24 rsi)
        (set! tmp.25 rdx)
        (if (neq? tmp.223 6)
          (begin
            (set! tmp.491 (bitwise-and tmp.24 7))
            (set! tmp.227 tmp.491)
            (if (eq? tmp.227 0)
              (begin
                (set! rdx tmp.25)
                (set! rsi tmp.24)
                (set! rdi 14)
                (set! r15 ra.490)
                (jump L.jp.63 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.25)
                (set! rsi tmp.24)
                (set! rdi 6)
                (set! r15 ra.490)
                (jump L.jp.63 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1598) (jump ra.490 rbp rax)))))
    (define L.jp.63
      ((new-frames ()))
      (begin
        (set! ra.492 r15)
        (set! tmp.225 rdi)
        (set! tmp.24 rsi)
        (set! tmp.25 rdx)
        (if (neq? tmp.225 6)
          (if (>= tmp.24 tmp.25)
            (begin (set! rax 14) (jump ra.492 rbp rax))
            (begin (set! rax 6) (jump ra.492 rbp rax)))
          (begin (set! rax 1598) (jump ra.492 rbp rax)))))
    (define L.jp.59
      ((new-frames ()))
      (begin
        (set! ra.493 r15)
        (set! tmp.216 rdi)
        (set! tmp.22 rsi)
        (set! tmp.23 rdx)
        (if (neq? tmp.216 6)
          (begin
            (set! tmp.494 (bitwise-and tmp.22 7))
            (set! tmp.220 tmp.494)
            (if (eq? tmp.220 0)
              (begin
                (set! rdx tmp.23)
                (set! rsi tmp.22)
                (set! rdi 14)
                (set! r15 ra.493)
                (jump L.jp.58 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.23)
                (set! rsi tmp.22)
                (set! rdi 6)
                (set! r15 ra.493)
                (jump L.jp.58 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1342) (jump ra.493 rbp rax)))))
    (define L.jp.58
      ((new-frames ()))
      (begin
        (set! ra.495 r15)
        (set! tmp.218 rdi)
        (set! tmp.22 rsi)
        (set! tmp.23 rdx)
        (if (neq? tmp.218 6)
          (if (> tmp.22 tmp.23)
            (begin (set! rax 14) (jump ra.495 rbp rax))
            (begin (set! rax 6) (jump ra.495 rbp rax)))
          (begin (set! rax 1342) (jump ra.495 rbp rax)))))
    (define L.jp.54
      ((new-frames ()))
      (begin
        (set! ra.496 r15)
        (set! tmp.209 rdi)
        (set! tmp.20 rsi)
        (set! tmp.21 rdx)
        (if (neq? tmp.209 6)
          (begin
            (set! tmp.497 (bitwise-and tmp.20 7))
            (set! tmp.213 tmp.497)
            (if (eq? tmp.213 0)
              (begin
                (set! rdx tmp.21)
                (set! rsi tmp.20)
                (set! rdi 14)
                (set! r15 ra.496)
                (jump L.jp.53 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.21)
                (set! rsi tmp.20)
                (set! rdi 6)
                (set! r15 ra.496)
                (jump L.jp.53 rbp r15 rdx rsi rdi))))
          (begin (set! rax 1086) (jump ra.496 rbp rax)))))
    (define L.jp.53
      ((new-frames ()))
      (begin
        (set! ra.498 r15)
        (set! tmp.211 rdi)
        (set! tmp.20 rsi)
        (set! tmp.21 rdx)
        (if (neq? tmp.211 6)
          (if (<= tmp.20 tmp.21)
            (begin (set! rax 14) (jump ra.498 rbp rax))
            (begin (set! rax 6) (jump ra.498 rbp rax)))
          (begin (set! rax 1086) (jump ra.498 rbp rax)))))
    (define L.jp.49
      ((new-frames ()))
      (begin
        (set! ra.499 r15)
        (set! tmp.202 rdi)
        (set! tmp.18 rsi)
        (set! tmp.19 rdx)
        (if (neq? tmp.202 6)
          (begin
            (set! tmp.500 (bitwise-and tmp.18 7))
            (set! tmp.206 tmp.500)
            (if (eq? tmp.206 0)
              (begin
                (set! rdx tmp.19)
                (set! rsi tmp.18)
                (set! rdi 14)
                (set! r15 ra.499)
                (jump L.jp.48 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.19)
                (set! rsi tmp.18)
                (set! rdi 6)
                (set! r15 ra.499)
                (jump L.jp.48 rbp r15 rdx rsi rdi))))
          (begin (set! rax 830) (jump ra.499 rbp rax)))))
    (define L.jp.48
      ((new-frames ()))
      (begin
        (set! ra.501 r15)
        (set! tmp.204 rdi)
        (set! tmp.18 rsi)
        (set! tmp.19 rdx)
        (if (neq? tmp.204 6)
          (if (< tmp.18 tmp.19)
            (begin (set! rax 14) (jump ra.501 rbp rax))
            (begin (set! rax 6) (jump ra.501 rbp rax)))
          (begin (set! rax 830) (jump ra.501 rbp rax)))))
    (define L.jp.44
      ((new-frames ()))
      (begin
        (set! ra.502 r15)
        (set! tmp.196 rdi)
        (set! tmp.16 rsi)
        (set! tmp.17 rdx)
        (if (neq? tmp.196 6)
          (begin
            (set! tmp.503 (bitwise-and tmp.16 7))
            (set! tmp.199 tmp.503)
            (if (eq? tmp.199 0)
              (begin
                (set! rdx tmp.17)
                (set! rsi tmp.16)
                (set! rdi 14)
                (set! r15 ra.502)
                (jump L.jp.43 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.17)
                (set! rsi tmp.16)
                (set! rdi 6)
                (set! r15 ra.502)
                (jump L.jp.43 rbp r15 rdx rsi rdi))))
          (begin (set! rax 574) (jump ra.502 rbp rax)))))
    (define L.jp.43
      ((new-frames ()))
      (begin
        (set! ra.504 r15)
        (set! tmp.198 rdi)
        (set! tmp.16 rsi)
        (set! tmp.17 rdx)
        (if (neq? tmp.198 6)
          (begin
            (set! tmp.505 (- tmp.16 tmp.17))
            (set! rax tmp.505)
            (jump ra.504 rbp rax))
          (begin (set! rax 574) (jump ra.504 rbp rax)))))
    (define L.jp.40
      ((new-frames ()))
      (begin
        (set! ra.506 r15)
        (set! tmp.190 rdi)
        (set! tmp.14 rsi)
        (set! tmp.15 rdx)
        (if (neq? tmp.190 6)
          (begin
            (set! tmp.507 (bitwise-and tmp.14 7))
            (set! tmp.193 tmp.507)
            (if (eq? tmp.193 0)
              (begin
                (set! rdx tmp.15)
                (set! rsi tmp.14)
                (set! rdi 14)
                (set! r15 ra.506)
                (jump L.jp.39 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.15)
                (set! rsi tmp.14)
                (set! rdi 6)
                (set! r15 ra.506)
                (jump L.jp.39 rbp r15 rdx rsi rdi))))
          (begin (set! rax 318) (jump ra.506 rbp rax)))))
    (define L.jp.39
      ((new-frames ()))
      (begin
        (set! ra.508 r15)
        (set! tmp.192 rdi)
        (set! tmp.14 rsi)
        (set! tmp.15 rdx)
        (if (neq? tmp.192 6)
          (begin
            (set! tmp.509 (+ tmp.14 tmp.15))
            (set! rax tmp.509)
            (jump ra.508 rbp rax))
          (begin (set! rax 318) (jump ra.508 rbp rax)))))
    (define L.jp.36
      ((new-frames ()))
      (begin
        (set! ra.510 r15)
        (set! tmp.183 rdi)
        (set! tmp.12 rsi)
        (set! tmp.13 rdx)
        (if (neq? tmp.183 6)
          (begin
            (set! tmp.511 (bitwise-and tmp.12 7))
            (set! tmp.187 tmp.511)
            (if (eq? tmp.187 0)
              (begin
                (set! rdx tmp.12)
                (set! rsi tmp.13)
                (set! rdi 14)
                (set! r15 ra.510)
                (jump L.jp.35 rbp r15 rdx rsi rdi))
              (begin
                (set! rdx tmp.12)
                (set! rsi tmp.13)
                (set! rdi 6)
                (set! r15 ra.510)
                (jump L.jp.35 rbp r15 rdx rsi rdi))))
          (begin (set! rax 62) (jump ra.510 rbp rax)))))
    (define L.jp.35
      ((new-frames ()))
      (begin
        (set! ra.512 r15)
        (set! tmp.185 rdi)
        (set! tmp.13 rsi)
        (set! tmp.12 rdx)
        (if (neq? tmp.185 6)
          (begin
            (set! tmp.513 (arithmetic-shift-right tmp.13 3))
            (set! tmp.186 tmp.513)
            (set! tmp.514 (* tmp.12 tmp.186))
            (set! rax tmp.514)
            (jump ra.512 rbp rax))
          (begin (set! rax 62) (jump ra.512 rbp rax))))))     ) 3)
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
    (define L.tmp.11.31
      (lambda (c.120)
        (let ((vector-ref.60 (mref c.120 14)))
          (let ((|+.51| (mref c.120 22)))
            (let ((x.5 (mref c.120 30)))
              (let ((vector-set!.59 (mref c.120 38)))
                (let ((error?.69 (mref c.120 46)))
                  (let ((tmp.131 vector-set!.59))
                    (let ((tmp.132 |+.51|))
                      (let ((tmp.133 vector-ref.60))
                        (let ((tmp.178
                               (apply L.vector-ref.60.20 vector-ref.60 x.5 0)))
                          (let ((tmp.179 (apply L.+.51.29 |+.51| 8 tmp.178)))
                            (let ((tmp.6
                                   (apply
                                    L.vector-set!.59.21
                                    vector-set!.59
                                    x.5
                                    0
                                    tmp.179)))
                              (let ((tmp.134 error?.69))
                                (let ((tmp.181
                                       (apply L.error?.69.11 error?.69 tmp.6)))
                                  (if (neq? tmp.181 6)
                                    tmp.6
                                    (let ((tmp.135 vector-ref.60))
                                      (apply
                                       L.vector-ref.60.20
                                       vector-ref.60
                                       x.5
                                       0))))))))))))))))))
    (define L.*.50.30
      (lambda (c.119 tmp.12 tmp.13)
        (let ((tmp.188 (bitwise-and tmp.13 7)))
          (if (eq? tmp.188 0)
            (apply L.jp.36 14 tmp.12 tmp.13)
            (apply L.jp.36 6 tmp.12 tmp.13)))))
    (define L.+.51.29
      (lambda (c.118 tmp.14 tmp.15)
        (let ((tmp.194 (bitwise-and tmp.15 7)))
          (if (eq? tmp.194 0)
            (apply L.jp.40 14 tmp.14 tmp.15)
            (apply L.jp.40 6 tmp.14 tmp.15)))))
    (define L.-.52.28
      (lambda (c.117 tmp.16 tmp.17)
        (let ((tmp.200 (bitwise-and tmp.17 7)))
          (if (eq? tmp.200 0)
            (apply L.jp.44 14 tmp.16 tmp.17)
            (apply L.jp.44 6 tmp.16 tmp.17)))))
    (define L.<.53.27
      (lambda (c.116 tmp.18 tmp.19)
        (let ((tmp.207 (bitwise-and tmp.19 7)))
          (if (eq? tmp.207 0)
            (apply L.jp.49 14 tmp.18 tmp.19)
            (apply L.jp.49 6 tmp.18 tmp.19)))))
    (define L.<=.54.26
      (lambda (c.115 tmp.20 tmp.21)
        (let ((tmp.214 (bitwise-and tmp.21 7)))
          (if (eq? tmp.214 0)
            (apply L.jp.54 14 tmp.20 tmp.21)
            (apply L.jp.54 6 tmp.20 tmp.21)))))
    (define L.>.55.25
      (lambda (c.114 tmp.22 tmp.23)
        (let ((tmp.221 (bitwise-and tmp.23 7)))
          (if (eq? tmp.221 0)
            (apply L.jp.59 14 tmp.22 tmp.23)
            (apply L.jp.59 6 tmp.22 tmp.23)))))
    (define L.>=.56.24
      (lambda (c.113 tmp.24 tmp.25)
        (let ((tmp.228 (bitwise-and tmp.25 7)))
          (if (eq? tmp.228 0)
            (apply L.jp.64 14 tmp.24 tmp.25)
            (apply L.jp.64 6 tmp.24 tmp.25)))))
    (define L.make-vector.57.23
      (lambda (c.112 tmp.26)
        (let ((make-init-vector.1 (mref c.112 14)))
          (let ((tmp.231 (bitwise-and tmp.26 7)))
            (if (eq? tmp.231 0)
              (apply L.jp.66 14 make-init-vector.1 tmp.26)
              (apply L.jp.66 6 make-init-vector.1 tmp.26))))))
    (define L.vector-length.58.22
      (lambda (c.111 tmp.27)
        (let ((tmp.234 (bitwise-and tmp.27 7)))
          (if (eq? tmp.234 3)
            (apply L.jp.68 14 tmp.27)
            (apply L.jp.68 6 tmp.27)))))
    (define L.vector-set!.59.21
      (lambda (c.110 tmp.28 tmp.29 tmp.30)
        (let ((unsafe-vector-set!.2 (mref c.110 14)))
          (let ((tmp.240 (bitwise-and tmp.29 7)))
            (if (eq? tmp.240 0)
              (apply L.jp.72 14 tmp.28 unsafe-vector-set!.2 tmp.30 tmp.29)
              (apply L.jp.72 6 tmp.28 unsafe-vector-set!.2 tmp.30 tmp.29))))))
    (define L.vector-ref.60.20
      (lambda (c.109 tmp.31 tmp.32)
        (let ((unsafe-vector-ref.3 (mref c.109 14)))
          (let ((tmp.246 (bitwise-and tmp.32 7)))
            (if (eq? tmp.246 0)
              (apply L.jp.76 14 tmp.31 unsafe-vector-ref.3 tmp.32)
              (apply L.jp.76 6 tmp.31 unsafe-vector-ref.3 tmp.32))))))
    (define L.car.61.19
      (lambda (c.108 tmp.33)
        (let ((tmp.249 (bitwise-and tmp.33 7)))
          (if (eq? tmp.249 1)
            (apply L.jp.78 14 tmp.33)
            (apply L.jp.78 6 tmp.33)))))
    (define L.cdr.62.18
      (lambda (c.107 tmp.34)
        (let ((tmp.252 (bitwise-and tmp.34 7)))
          (if (eq? tmp.252 1)
            (apply L.jp.80 14 tmp.34)
            (apply L.jp.80 6 tmp.34)))))
    (define L.procedure-arity.63.17
      (lambda (c.106 tmp.35)
        (let ((tmp.255 (bitwise-and tmp.35 7)))
          (if (eq? tmp.255 2)
            (apply L.jp.82 14 tmp.35)
            (apply L.jp.82 6 tmp.35)))))
    (define L.fixnum?.64.16
      (lambda (c.105 tmp.36)
        (let ((tmp.257 (bitwise-and tmp.36 7))) (if (eq? tmp.257 0) 14 6))))
    (define L.boolean?.65.15
      (lambda (c.104 tmp.37)
        (let ((tmp.259 (bitwise-and tmp.37 247))) (if (eq? tmp.259 6) 14 6))))
    (define L.empty?.66.14
      (lambda (c.103 tmp.38)
        (let ((tmp.261 (bitwise-and tmp.38 255))) (if (eq? tmp.261 22) 14 6))))
    (define L.void?.67.13
      (lambda (c.102 tmp.39)
        (let ((tmp.263 (bitwise-and tmp.39 255))) (if (eq? tmp.263 30) 14 6))))
    (define L.ascii-char?.68.12
      (lambda (c.101 tmp.40)
        (let ((tmp.265 (bitwise-and tmp.40 255))) (if (eq? tmp.265 46) 14 6))))
    (define L.error?.69.11
      (lambda (c.100 tmp.41)
        (let ((tmp.267 (bitwise-and tmp.41 255))) (if (eq? tmp.267 62) 14 6))))
    (define L.pair?.70.10
      (lambda (c.99 tmp.42)
        (let ((tmp.269 (bitwise-and tmp.42 7))) (if (eq? tmp.269 1) 14 6))))
    (define L.procedure?.71.9
      (lambda (c.98 tmp.43)
        (let ((tmp.271 (bitwise-and tmp.43 7))) (if (eq? tmp.271 2) 14 6))))
    (define L.vector?.72.8
      (lambda (c.97 tmp.44)
        (let ((tmp.273 (bitwise-and tmp.44 7))) (if (eq? tmp.273 3) 14 6))))
    (define L.not.73.7 (lambda (c.96 tmp.45) (if (neq? tmp.45 6) 6 14)))
    (define L.cons.74.6
      (lambda (c.95 tmp.46 tmp.47)
        (let ((tmp.275 (alloc 16)))
          (let ((tmp.145 (+ tmp.275 1)))
            (begin
              (mset! tmp.145 -1 tmp.46)
              (mset! tmp.145 7 tmp.47)
              tmp.145)))))
    (define L.eq?.75.5
      (lambda (c.94 tmp.48 tmp.49) (if (eq? tmp.48 tmp.49) 14 6)))
    (define L.make-init-vector.1.4
      (lambda (c.93 tmp.76)
        (let ((vector-init-loop.78 (mref c.93 14)))
          (let ((tmp.277 (arithmetic-shift-right tmp.76 3)))
            (let ((tmp.278 (+ 1 tmp.277)))
              (let ((tmp.279 (* tmp.278 8)))
                (let ((tmp.280 (alloc tmp.279)))
                  (let ((tmp.146 (+ tmp.280 3)))
                    (begin
                      (mset! tmp.146 -3 tmp.76)
                      (let ((tmp.77 tmp.146))
                        (let ((tmp.125 vector-init-loop.78))
                          (apply
                           L.vector-init-loop.78.3
                           vector-init-loop.78
                           tmp.76
                           0
                           tmp.77))))))))))))
    (define L.vector-init-loop.78.3
      (lambda (c.92 len.79 i.81 vec.80)
        (let ((vector-init-loop.78 (mref c.92 14)))
          (if (eq? len.79 i.81)
            (apply L.jp.95 14 i.81 len.79 vector-init-loop.78 vec.80)
            (apply L.jp.95 6 i.81 len.79 vector-init-loop.78 vec.80)))))
    (define L.unsafe-vector-set!.2.2
      (lambda (c.91 tmp.87 tmp.88 tmp.89)
        (let ((tmp.294 (mref tmp.87 -3)))
          (if (< tmp.88 tmp.294)
            (apply L.jp.99 14 tmp.88 tmp.89 tmp.87)
            (apply L.jp.99 6 tmp.88 tmp.89 tmp.87)))))
    (define L.unsafe-vector-ref.3.1
      (lambda (c.90 tmp.84 tmp.85)
        (let ((tmp.302 (mref tmp.84 -3)))
          (if (< tmp.85 tmp.302)
            (apply L.jp.103 14 tmp.85 tmp.84)
            (apply L.jp.103 6 tmp.85 tmp.84)))))
    (define L.jp.117
      (lambda (tmp.354 tmp.142 error?.69 counter!.4 vector-ref.60 tmp.121)
        (if (neq? tmp.354 6)
          (let ((tmp.359 (mref tmp.142 6)))
            (if (eq? tmp.359 0)
              (apply
               L.jp.116
               14
               tmp.142
               error?.69
               counter!.4
               vector-ref.60
               tmp.121)
              (apply
               L.jp.116
               6
               tmp.142
               error?.69
               counter!.4
               vector-ref.60
               tmp.121)))
          (apply L.jp.114 11070 error?.69 counter!.4 vector-ref.60))))
    (define L.jp.116
      (lambda (tmp.356 tmp.142 error?.69 counter!.4 vector-ref.60 tmp.121)
        (if (neq? tmp.356 6)
          (let ((tmp.357 (mref tmp.142 -2)))
            (let ((tmp.358 (apply tmp.357 tmp.121)))
              (apply L.jp.114 tmp.358 error?.69 counter!.4 vector-ref.60)))
          (apply L.jp.114 10814 error?.69 counter!.4 vector-ref.60))))
    (define L.jp.114
      (lambda (tmp.334 error?.69 counter!.4 vector-ref.60)
        (let ((tmp.7 tmp.334))
          (let ((tmp.138 error?.69))
            (let ((tmp.336 (apply L.error?.69.11 error?.69 tmp.7)))
              (if (neq? tmp.336 6)
                tmp.7
                (let ((tmp.139 vector-ref.60))
                  (let ((tmp.122
                         (apply
                          L.vector-ref.60.20
                          vector-ref.60
                          counter!.4
                          0)))
                    (let ((tmp.143 tmp.122))
                      (let ((tmp.353 (bitwise-and tmp.143 7)))
                        (if (eq? tmp.353 2)
                          (apply
                           L.jp.113
                           14
                           tmp.143
                           error?.69
                           counter!.4
                           vector-ref.60
                           tmp.122)
                          (apply
                           L.jp.113
                           6
                           tmp.143
                           error?.69
                           counter!.4
                           vector-ref.60
                           tmp.122))))))))))))
    (define L.jp.113
      (lambda (tmp.347 tmp.143 error?.69 counter!.4 vector-ref.60 tmp.122)
        (if (neq? tmp.347 6)
          (let ((tmp.352 (mref tmp.143 6)))
            (if (eq? tmp.352 0)
              (apply
               L.jp.112
               14
               tmp.143
               error?.69
               counter!.4
               vector-ref.60
               tmp.122)
              (apply
               L.jp.112
               6
               tmp.143
               error?.69
               counter!.4
               vector-ref.60
               tmp.122)))
          (apply L.jp.110 11070 error?.69 counter!.4 vector-ref.60))))
    (define L.jp.112
      (lambda (tmp.349 tmp.143 error?.69 counter!.4 vector-ref.60 tmp.122)
        (if (neq? tmp.349 6)
          (let ((tmp.350 (mref tmp.143 -2)))
            (let ((tmp.351 (apply tmp.350 tmp.122)))
              (apply L.jp.110 tmp.351 error?.69 counter!.4 vector-ref.60)))
          (apply L.jp.110 10814 error?.69 counter!.4 vector-ref.60))))
    (define L.jp.110
      (lambda (tmp.337 error?.69 counter!.4 vector-ref.60)
        (let ((tmp.8 tmp.337))
          (let ((tmp.140 error?.69))
            (let ((tmp.339 (apply L.error?.69.11 error?.69 tmp.8)))
              (if (neq? tmp.339 6)
                tmp.8
                (let ((tmp.141 vector-ref.60))
                  (let ((tmp.123
                         (apply
                          L.vector-ref.60.20
                          vector-ref.60
                          counter!.4
                          0)))
                    (let ((tmp.144 tmp.123))
                      (let ((tmp.346 (bitwise-and tmp.144 7)))
                        (if (eq? tmp.346 2)
                          (apply L.jp.109 14 tmp.144 tmp.123)
                          (apply L.jp.109 6 tmp.144 tmp.123))))))))))))
    (define L.jp.109
      (lambda (tmp.341 tmp.144 tmp.123)
        (if (neq? tmp.341 6)
          (let ((tmp.345 (mref tmp.144 6)))
            (if (eq? tmp.345 0)
              (apply L.jp.108 14 tmp.144 tmp.123)
              (apply L.jp.108 6 tmp.144 tmp.123)))
          11070)))
    (define L.jp.108
      (lambda (tmp.343 tmp.144 tmp.123)
        (if (neq? tmp.343 6)
          (let ((tmp.344 (mref tmp.144 -2))) (apply tmp.344 tmp.123))
          10814)))
    (define L.jp.103
      (lambda (tmp.296 tmp.85 tmp.84)
        (if (neq? tmp.296 6)
          (if (>= tmp.85 0)
            (apply L.jp.102 14 tmp.85 tmp.84)
            (apply L.jp.102 6 tmp.85 tmp.84))
          2622)))
    (define L.jp.102
      (lambda (tmp.298 tmp.85 tmp.84)
        (if (neq? tmp.298 6)
          (let ((tmp.299 (arithmetic-shift-right tmp.85 3)))
            (let ((tmp.300 (* tmp.299 8)))
              (let ((tmp.301 (+ tmp.300 5))) (mref tmp.84 tmp.301))))
          2622)))
    (define L.jp.99
      (lambda (tmp.288 tmp.88 tmp.89 tmp.87)
        (if (neq? tmp.288 6)
          (if (>= tmp.88 0)
            (apply L.jp.98 14 tmp.88 tmp.87 tmp.89)
            (apply L.jp.98 6 tmp.88 tmp.87 tmp.89))
          2366)))
    (define L.jp.98
      (lambda (tmp.290 tmp.88 tmp.87 tmp.89)
        (if (neq? tmp.290 6)
          (let ((tmp.291 (arithmetic-shift-right tmp.88 3)))
            (let ((tmp.292 (* tmp.291 8)))
              (let ((tmp.293 (+ tmp.292 5)))
                (begin (mset! tmp.87 tmp.293 tmp.89) 30))))
          2366)))
    (define L.jp.95
      (lambda (tmp.282 i.81 len.79 vector-init-loop.78 vec.80)
        (if (neq? tmp.282 6)
          vec.80
          (let ((tmp.283 (arithmetic-shift-right i.81 3)))
            (let ((tmp.284 (* tmp.283 8)))
              (let ((tmp.285 (+ tmp.284 5)))
                (begin
                  (mset! vec.80 tmp.285 0)
                  (let ((tmp.124 vector-init-loop.78))
                    (let ((tmp.286 (+ i.81 8)))
                      (apply
                       L.vector-init-loop.78.3
                       vector-init-loop.78
                       len.79
                       tmp.286
                       vec.80))))))))))
    (define L.jp.82
      (lambda (tmp.254 tmp.35) (if (neq? tmp.254 6) (mref tmp.35 6) 3390)))
    (define L.jp.80
      (lambda (tmp.251 tmp.34) (if (neq? tmp.251 6) (mref tmp.34 7) 3134)))
    (define L.jp.78
      (lambda (tmp.248 tmp.33) (if (neq? tmp.248 6) (mref tmp.33 -1) 2878)))
    (define L.jp.76
      (lambda (tmp.242 tmp.31 unsafe-vector-ref.3 tmp.32)
        (if (neq? tmp.242 6)
          (let ((tmp.245 (bitwise-and tmp.31 7)))
            (if (eq? tmp.245 3)
              (apply L.jp.75 14 unsafe-vector-ref.3 tmp.32 tmp.31)
              (apply L.jp.75 6 unsafe-vector-ref.3 tmp.32 tmp.31)))
          2622)))
    (define L.jp.75
      (lambda (tmp.244 unsafe-vector-ref.3 tmp.32 tmp.31)
        (if (neq? tmp.244 6)
          (let ((tmp.126 unsafe-vector-ref.3))
            (apply L.unsafe-vector-ref.3.1 unsafe-vector-ref.3 tmp.31 tmp.32))
          2622)))
    (define L.jp.72
      (lambda (tmp.236 tmp.28 unsafe-vector-set!.2 tmp.30 tmp.29)
        (if (neq? tmp.236 6)
          (let ((tmp.239 (bitwise-and tmp.28 7)))
            (if (eq? tmp.239 3)
              (apply L.jp.71 14 unsafe-vector-set!.2 tmp.30 tmp.29 tmp.28)
              (apply L.jp.71 6 unsafe-vector-set!.2 tmp.30 tmp.29 tmp.28)))
          2366)))
    (define L.jp.71
      (lambda (tmp.238 unsafe-vector-set!.2 tmp.30 tmp.29 tmp.28)
        (if (neq? tmp.238 6)
          (let ((tmp.127 unsafe-vector-set!.2))
            (apply
             L.unsafe-vector-set!.2.2
             unsafe-vector-set!.2
             tmp.28
             tmp.29
             tmp.30))
          2366)))
    (define L.jp.68
      (lambda (tmp.233 tmp.27) (if (neq? tmp.233 6) (mref tmp.27 -3) 2110)))
    (define L.jp.66
      (lambda (tmp.230 make-init-vector.1 tmp.26)
        (if (neq? tmp.230 6)
          (let ((tmp.128 make-init-vector.1))
            (apply L.make-init-vector.1.4 make-init-vector.1 tmp.26))
          1854)))
    (define L.jp.64
      (lambda (tmp.223 tmp.24 tmp.25)
        (if (neq? tmp.223 6)
          (let ((tmp.227 (bitwise-and tmp.24 7)))
            (if (eq? tmp.227 0)
              (apply L.jp.63 14 tmp.24 tmp.25)
              (apply L.jp.63 6 tmp.24 tmp.25)))
          1598)))
    (define L.jp.63
      (lambda (tmp.225 tmp.24 tmp.25)
        (if (neq? tmp.225 6) (if (>= tmp.24 tmp.25) 14 6) 1598)))
    (define L.jp.59
      (lambda (tmp.216 tmp.22 tmp.23)
        (if (neq? tmp.216 6)
          (let ((tmp.220 (bitwise-and tmp.22 7)))
            (if (eq? tmp.220 0)
              (apply L.jp.58 14 tmp.22 tmp.23)
              (apply L.jp.58 6 tmp.22 tmp.23)))
          1342)))
    (define L.jp.58
      (lambda (tmp.218 tmp.22 tmp.23)
        (if (neq? tmp.218 6) (if (> tmp.22 tmp.23) 14 6) 1342)))
    (define L.jp.54
      (lambda (tmp.209 tmp.20 tmp.21)
        (if (neq? tmp.209 6)
          (let ((tmp.213 (bitwise-and tmp.20 7)))
            (if (eq? tmp.213 0)
              (apply L.jp.53 14 tmp.20 tmp.21)
              (apply L.jp.53 6 tmp.20 tmp.21)))
          1086)))
    (define L.jp.53
      (lambda (tmp.211 tmp.20 tmp.21)
        (if (neq? tmp.211 6) (if (<= tmp.20 tmp.21) 14 6) 1086)))
    (define L.jp.49
      (lambda (tmp.202 tmp.18 tmp.19)
        (if (neq? tmp.202 6)
          (let ((tmp.206 (bitwise-and tmp.18 7)))
            (if (eq? tmp.206 0)
              (apply L.jp.48 14 tmp.18 tmp.19)
              (apply L.jp.48 6 tmp.18 tmp.19)))
          830)))
    (define L.jp.48
      (lambda (tmp.204 tmp.18 tmp.19)
        (if (neq? tmp.204 6) (if (< tmp.18 tmp.19) 14 6) 830)))
    (define L.jp.44
      (lambda (tmp.196 tmp.16 tmp.17)
        (if (neq? tmp.196 6)
          (let ((tmp.199 (bitwise-and tmp.16 7)))
            (if (eq? tmp.199 0)
              (apply L.jp.43 14 tmp.16 tmp.17)
              (apply L.jp.43 6 tmp.16 tmp.17)))
          574)))
    (define L.jp.43
      (lambda (tmp.198 tmp.16 tmp.17)
        (if (neq? tmp.198 6) (- tmp.16 tmp.17) 574)))
    (define L.jp.40
      (lambda (tmp.190 tmp.14 tmp.15)
        (if (neq? tmp.190 6)
          (let ((tmp.193 (bitwise-and tmp.14 7)))
            (if (eq? tmp.193 0)
              (apply L.jp.39 14 tmp.14 tmp.15)
              (apply L.jp.39 6 tmp.14 tmp.15)))
          318)))
    (define L.jp.39
      (lambda (tmp.192 tmp.14 tmp.15)
        (if (neq? tmp.192 6) (+ tmp.14 tmp.15) 318)))
    (define L.jp.36
      (lambda (tmp.183 tmp.12 tmp.13)
        (if (neq? tmp.183 6)
          (let ((tmp.187 (bitwise-and tmp.12 7)))
            (if (eq? tmp.187 0)
              (apply L.jp.35 14 tmp.13 tmp.12)
              (apply L.jp.35 6 tmp.13 tmp.12)))
          62)))
    (define L.jp.35
      (lambda (tmp.185 tmp.13 tmp.12)
        (if (neq? tmp.185 6)
          (let ((tmp.186 (arithmetic-shift-right tmp.13 3)))
            (* tmp.12 tmp.186))
          62)))
    (let ((tmp.303 (alloc 16)))
      (let ((tmp.147 (+ tmp.303 2)))
        (begin
          (mset! tmp.147 -2 L.unsafe-vector-ref.3.1)
          (mset! tmp.147 6 16)
          (let ((unsafe-vector-ref.3 tmp.147))
            (let ((tmp.304 (alloc 16)))
              (let ((tmp.148 (+ tmp.304 2)))
                (begin
                  (mset! tmp.148 -2 L.unsafe-vector-set!.2.2)
                  (mset! tmp.148 6 24)
                  (let ((unsafe-vector-set!.2 tmp.148))
                    (let ((tmp.305 (alloc 24)))
                      (let ((tmp.149 (+ tmp.305 2)))
                        (begin
                          (mset! tmp.149 -2 L.vector-init-loop.78.3)
                          (mset! tmp.149 6 24)
                          (let ((vector-init-loop.78 tmp.149))
                            (let ((tmp.306 (alloc 24)))
                              (let ((tmp.150 (+ tmp.306 2)))
                                (begin
                                  (mset! tmp.150 -2 L.make-init-vector.1.4)
                                  (mset! tmp.150 6 8)
                                  (let ((make-init-vector.1 tmp.150))
                                    (let ((tmp.307 (alloc 16)))
                                      (let ((tmp.151 (+ tmp.307 2)))
                                        (begin
                                          (mset! tmp.151 -2 L.eq?.75.5)
                                          (mset! tmp.151 6 16)
                                          (let ((eq?.75 tmp.151))
                                            (let ((tmp.308 (alloc 16)))
                                              (let ((tmp.152 (+ tmp.308 2)))
                                                (begin
                                                  (mset!
                                                   tmp.152
                                                   -2
                                                   L.cons.74.6)
                                                  (mset! tmp.152 6 16)
                                                  (let ((cons.74 tmp.152))
                                                    (let ((tmp.309 (alloc 16)))
                                                      (let ((tmp.153
                                                             (+ tmp.309 2)))
                                                        (begin
                                                          (mset!
                                                           tmp.153
                                                           -2
                                                           L.not.73.7)
                                                          (mset! tmp.153 6 8)
                                                          (let ((not.73
                                                                 tmp.153))
                                                            (let ((tmp.310
                                                                   (alloc 16)))
                                                              (let ((tmp.154
                                                                     (+
                                                                      tmp.310
                                                                      2)))
                                                                (begin
                                                                  (mset!
                                                                   tmp.154
                                                                   -2
                                                                   L.vector?.72.8)
                                                                  (mset!
                                                                   tmp.154
                                                                   6
                                                                   8)
                                                                  (let ((vector?.72
                                                                         tmp.154))
                                                                    (let ((tmp.311
                                                                           (alloc
                                                                            16)))
                                                                      (let ((tmp.155
                                                                             (+
                                                                              tmp.311
                                                                              2)))
                                                                        (begin
                                                                          (mset!
                                                                           tmp.155
                                                                           -2
                                                                           L.procedure?.71.9)
                                                                          (mset!
                                                                           tmp.155
                                                                           6
                                                                           8)
                                                                          (let ((procedure?.71
                                                                                 tmp.155))
                                                                            (let ((tmp.312
                                                                                   (alloc
                                                                                    16)))
                                                                              (let ((tmp.156
                                                                                     (+
                                                                                      tmp.312
                                                                                      2)))
                                                                                (begin
                                                                                  (mset!
                                                                                   tmp.156
                                                                                   -2
                                                                                   L.pair?.70.10)
                                                                                  (mset!
                                                                                   tmp.156
                                                                                   6
                                                                                   8)
                                                                                  (let ((pair?.70
                                                                                         tmp.156))
                                                                                    (let ((tmp.313
                                                                                           (alloc
                                                                                            16)))
                                                                                      (let ((tmp.157
                                                                                             (+
                                                                                              tmp.313
                                                                                              2)))
                                                                                        (begin
                                                                                          (mset!
                                                                                           tmp.157
                                                                                           -2
                                                                                           L.error?.69.11)
                                                                                          (mset!
                                                                                           tmp.157
                                                                                           6
                                                                                           8)
                                                                                          (let ((error?.69
                                                                                                 tmp.157))
                                                                                            (let ((tmp.314
                                                                                                   (alloc
                                                                                                    16)))
                                                                                              (let ((tmp.158
                                                                                                     (+
                                                                                                      tmp.314
                                                                                                      2)))
                                                                                                (begin
                                                                                                  (mset!
                                                                                                   tmp.158
                                                                                                   -2
                                                                                                   L.ascii-char?.68.12)
                                                                                                  (mset!
                                                                                                   tmp.158
                                                                                                   6
                                                                                                   8)
                                                                                                  (let ((ascii-char?.68
                                                                                                         tmp.158))
                                                                                                    (let ((tmp.315
                                                                                                           (alloc
                                                                                                            16)))
                                                                                                      (let ((tmp.159
                                                                                                             (+
                                                                                                              tmp.315
                                                                                                              2)))
                                                                                                        (begin
                                                                                                          (mset!
                                                                                                           tmp.159
                                                                                                           -2
                                                                                                           L.void?.67.13)
                                                                                                          (mset!
                                                                                                           tmp.159
                                                                                                           6
                                                                                                           8)
                                                                                                          (let ((void?.67
                                                                                                                 tmp.159))
                                                                                                            (let ((tmp.316
                                                                                                                   (alloc
                                                                                                                    16)))
                                                                                                              (let ((tmp.160
                                                                                                                     (+
                                                                                                                      tmp.316
                                                                                                                      2)))
                                                                                                                (begin
                                                                                                                  (mset!
                                                                                                                   tmp.160
                                                                                                                   -2
                                                                                                                   L.empty?.66.14)
                                                                                                                  (mset!
                                                                                                                   tmp.160
                                                                                                                   6
                                                                                                                   8)
                                                                                                                  (let ((empty?.66
                                                                                                                         tmp.160))
                                                                                                                    (let ((tmp.317
                                                                                                                           (alloc
                                                                                                                            16)))
                                                                                                                      (let ((tmp.161
                                                                                                                             (+
                                                                                                                              tmp.317
                                                                                                                              2)))
                                                                                                                        (begin
                                                                                                                          (mset!
                                                                                                                           tmp.161
                                                                                                                           -2
                                                                                                                           L.boolean?.65.15)
                                                                                                                          (mset!
                                                                                                                           tmp.161
                                                                                                                           6
                                                                                                                           8)
                                                                                                                          (let ((boolean?.65
                                                                                                                                 tmp.161))
                                                                                                                            (let ((tmp.318
                                                                                                                                   (alloc
                                                                                                                                    16)))
                                                                                                                              (let ((tmp.162
                                                                                                                                     (+
                                                                                                                                      tmp.318
                                                                                                                                      2)))
                                                                                                                                (begin
                                                                                                                                  (mset!
                                                                                                                                   tmp.162
                                                                                                                                   -2
                                                                                                                                   L.fixnum?.64.16)
                                                                                                                                  (mset!
                                                                                                                                   tmp.162
                                                                                                                                   6
                                                                                                                                   8)
                                                                                                                                  (let ((fixnum?.64
                                                                                                                                         tmp.162))
                                                                                                                                    (let ((tmp.319
                                                                                                                                           (alloc
                                                                                                                                            16)))
                                                                                                                                      (let ((tmp.163
                                                                                                                                             (+
                                                                                                                                              tmp.319
                                                                                                                                              2)))
                                                                                                                                        (begin
                                                                                                                                          (mset!
                                                                                                                                           tmp.163
                                                                                                                                           -2
                                                                                                                                           L.procedure-arity.63.17)
                                                                                                                                          (mset!
                                                                                                                                           tmp.163
                                                                                                                                           6
                                                                                                                                           8)
                                                                                                                                          (let ((procedure-arity.63
                                                                                                                                                 tmp.163))
                                                                                                                                            (let ((tmp.320
                                                                                                                                                   (alloc
                                                                                                                                                    16)))
                                                                                                                                              (let ((tmp.164
                                                                                                                                                     (+
                                                                                                                                                      tmp.320
                                                                                                                                                      2)))
                                                                                                                                                (begin
                                                                                                                                                  (mset!
                                                                                                                                                   tmp.164
                                                                                                                                                   -2
                                                                                                                                                   L.cdr.62.18)
                                                                                                                                                  (mset!
                                                                                                                                                   tmp.164
                                                                                                                                                   6
                                                                                                                                                   8)
                                                                                                                                                  (let ((cdr.62
                                                                                                                                                         tmp.164))
                                                                                                                                                    (let ((tmp.321
                                                                                                                                                           (alloc
                                                                                                                                                            16)))
                                                                                                                                                      (let ((tmp.165
                                                                                                                                                             (+
                                                                                                                                                              tmp.321
                                                                                                                                                              2)))
                                                                                                                                                        (begin
                                                                                                                                                          (mset!
                                                                                                                                                           tmp.165
                                                                                                                                                           -2
                                                                                                                                                           L.car.61.19)
                                                                                                                                                          (mset!
                                                                                                                                                           tmp.165
                                                                                                                                                           6
                                                                                                                                                           8)
                                                                                                                                                          (let ((car.61
                                                                                                                                                                 tmp.165))
                                                                                                                                                            (let ((tmp.322
                                                                                                                                                                   (alloc
                                                                                                                                                                    24)))
                                                                                                                                                              (let ((tmp.166
                                                                                                                                                                     (+
                                                                                                                                                                      tmp.322
                                                                                                                                                                      2)))
                                                                                                                                                                (begin
                                                                                                                                                                  (mset!
                                                                                                                                                                   tmp.166
                                                                                                                                                                   -2
                                                                                                                                                                   L.vector-ref.60.20)
                                                                                                                                                                  (mset!
                                                                                                                                                                   tmp.166
                                                                                                                                                                   6
                                                                                                                                                                   16)
                                                                                                                                                                  (let ((vector-ref.60
                                                                                                                                                                         tmp.166))
                                                                                                                                                                    (let ((tmp.323
                                                                                                                                                                           (alloc
                                                                                                                                                                            24)))
                                                                                                                                                                      (let ((tmp.167
                                                                                                                                                                             (+
                                                                                                                                                                              tmp.323
                                                                                                                                                                              2)))
                                                                                                                                                                        (begin
                                                                                                                                                                          (mset!
                                                                                                                                                                           tmp.167
                                                                                                                                                                           -2
                                                                                                                                                                           L.vector-set!.59.21)
                                                                                                                                                                          (mset!
                                                                                                                                                                           tmp.167
                                                                                                                                                                           6
                                                                                                                                                                           24)
                                                                                                                                                                          (let ((vector-set!.59
                                                                                                                                                                                 tmp.167))
                                                                                                                                                                            (let ((tmp.324
                                                                                                                                                                                   (alloc
                                                                                                                                                                                    16)))
                                                                                                                                                                              (let ((tmp.168
                                                                                                                                                                                     (+
                                                                                                                                                                                      tmp.324
                                                                                                                                                                                      2)))
                                                                                                                                                                                (begin
                                                                                                                                                                                  (mset!
                                                                                                                                                                                   tmp.168
                                                                                                                                                                                   -2
                                                                                                                                                                                   L.vector-length.58.22)
                                                                                                                                                                                  (mset!
                                                                                                                                                                                   tmp.168
                                                                                                                                                                                   6
                                                                                                                                                                                   8)
                                                                                                                                                                                  (let ((vector-length.58
                                                                                                                                                                                         tmp.168))
                                                                                                                                                                                    (let ((tmp.325
                                                                                                                                                                                           (alloc
                                                                                                                                                                                            24)))
                                                                                                                                                                                      (let ((tmp.169
                                                                                                                                                                                             (+
                                                                                                                                                                                              tmp.325
                                                                                                                                                                                              2)))
                                                                                                                                                                                        (begin
                                                                                                                                                                                          (mset!
                                                                                                                                                                                           tmp.169
                                                                                                                                                                                           -2
                                                                                                                                                                                           L.make-vector.57.23)
                                                                                                                                                                                          (mset!
                                                                                                                                                                                           tmp.169
                                                                                                                                                                                           6
                                                                                                                                                                                           8)
                                                                                                                                                                                          (let ((make-vector.57
                                                                                                                                                                                                 tmp.169))
                                                                                                                                                                                            (let ((tmp.326
                                                                                                                                                                                                   (alloc
                                                                                                                                                                                                    16)))
                                                                                                                                                                                              (let ((tmp.170
                                                                                                                                                                                                     (+
                                                                                                                                                                                                      tmp.326
                                                                                                                                                                                                      2)))
                                                                                                                                                                                                (begin
                                                                                                                                                                                                  (mset!
                                                                                                                                                                                                   tmp.170
                                                                                                                                                                                                   -2
                                                                                                                                                                                                   L.>=.56.24)
                                                                                                                                                                                                  (mset!
                                                                                                                                                                                                   tmp.170
                                                                                                                                                                                                   6
                                                                                                                                                                                                   16)
                                                                                                                                                                                                  (let ((>=.56
                                                                                                                                                                                                         tmp.170))
                                                                                                                                                                                                    (let ((tmp.327
                                                                                                                                                                                                           (alloc
                                                                                                                                                                                                            16)))
                                                                                                                                                                                                      (let ((tmp.171
                                                                                                                                                                                                             (+
                                                                                                                                                                                                              tmp.327
                                                                                                                                                                                                              2)))
                                                                                                                                                                                                        (begin
                                                                                                                                                                                                          (mset!
                                                                                                                                                                                                           tmp.171
                                                                                                                                                                                                           -2
                                                                                                                                                                                                           L.>.55.25)
                                                                                                                                                                                                          (mset!
                                                                                                                                                                                                           tmp.171
                                                                                                                                                                                                           6
                                                                                                                                                                                                           16)
                                                                                                                                                                                                          (let ((>.55
                                                                                                                                                                                                                 tmp.171))
                                                                                                                                                                                                            (let ((tmp.328
                                                                                                                                                                                                                   (alloc
                                                                                                                                                                                                                    16)))
                                                                                                                                                                                                              (let ((tmp.172
                                                                                                                                                                                                                     (+
                                                                                                                                                                                                                      tmp.328
                                                                                                                                                                                                                      2)))
                                                                                                                                                                                                                (begin
                                                                                                                                                                                                                  (mset!
                                                                                                                                                                                                                   tmp.172
                                                                                                                                                                                                                   -2
                                                                                                                                                                                                                   L.<=.54.26)
                                                                                                                                                                                                                  (mset!
                                                                                                                                                                                                                   tmp.172
                                                                                                                                                                                                                   6
                                                                                                                                                                                                                   16)
                                                                                                                                                                                                                  (let ((<=.54
                                                                                                                                                                                                                         tmp.172))
                                                                                                                                                                                                                    (let ((tmp.329
                                                                                                                                                                                                                           (alloc
                                                                                                                                                                                                                            16)))
                                                                                                                                                                                                                      (let ((tmp.173
                                                                                                                                                                                                                             (+
                                                                                                                                                                                                                              tmp.329
                                                                                                                                                                                                                              2)))
                                                                                                                                                                                                                        (begin
                                                                                                                                                                                                                          (mset!
                                                                                                                                                                                                                           tmp.173
                                                                                                                                                                                                                           -2
                                                                                                                                                                                                                           L.<.53.27)
                                                                                                                                                                                                                          (mset!
                                                                                                                                                                                                                           tmp.173
                                                                                                                                                                                                                           6
                                                                                                                                                                                                                           16)
                                                                                                                                                                                                                          (let ((<.53
                                                                                                                                                                                                                                 tmp.173))
                                                                                                                                                                                                                            (let ((tmp.330
                                                                                                                                                                                                                                   (alloc
                                                                                                                                                                                                                                    16)))
                                                                                                                                                                                                                              (let ((tmp.174
                                                                                                                                                                                                                                     (+
                                                                                                                                                                                                                                      tmp.330
                                                                                                                                                                                                                                      2)))
                                                                                                                                                                                                                                (begin
                                                                                                                                                                                                                                  (mset!
                                                                                                                                                                                                                                   tmp.174
                                                                                                                                                                                                                                   -2
                                                                                                                                                                                                                                   L.-.52.28)
                                                                                                                                                                                                                                  (mset!
                                                                                                                                                                                                                                   tmp.174
                                                                                                                                                                                                                                   6
                                                                                                                                                                                                                                   16)
                                                                                                                                                                                                                                  (let ((|-.52|
                                                                                                                                                                                                                                         tmp.174))
                                                                                                                                                                                                                                    (let ((tmp.331
                                                                                                                                                                                                                                           (alloc
                                                                                                                                                                                                                                            16)))
                                                                                                                                                                                                                                      (let ((tmp.175
                                                                                                                                                                                                                                             (+
                                                                                                                                                                                                                                              tmp.331
                                                                                                                                                                                                                                              2)))
                                                                                                                                                                                                                                        (begin
                                                                                                                                                                                                                                          (mset!
                                                                                                                                                                                                                                           tmp.175
                                                                                                                                                                                                                                           -2
                                                                                                                                                                                                                                           L.+.51.29)
                                                                                                                                                                                                                                          (mset!
                                                                                                                                                                                                                                           tmp.175
                                                                                                                                                                                                                                           6
                                                                                                                                                                                                                                           16)
                                                                                                                                                                                                                                          (let ((|+.51|
                                                                                                                                                                                                                                                 tmp.175))
                                                                                                                                                                                                                                            (let ((tmp.332
                                                                                                                                                                                                                                                   (alloc
                                                                                                                                                                                                                                                    16)))
                                                                                                                                                                                                                                              (let ((tmp.176
                                                                                                                                                                                                                                                     (+
                                                                                                                                                                                                                                                      tmp.332
                                                                                                                                                                                                                                                      2)))
                                                                                                                                                                                                                                                (begin
                                                                                                                                                                                                                                                  (mset!
                                                                                                                                                                                                                                                   tmp.176
                                                                                                                                                                                                                                                   -2
                                                                                                                                                                                                                                                   L.*.50.30)
                                                                                                                                                                                                                                                  (mset!
                                                                                                                                                                                                                                                   tmp.176
                                                                                                                                                                                                                                                   6
                                                                                                                                                                                                                                                   16)
                                                                                                                                                                                                                                                  (let ((*.50
                                                                                                                                                                                                                                                         tmp.176))
                                                                                                                                                                                                                                                    (begin
                                                                                                                                                                                                                                                      (mset!
                                                                                                                                                                                                                                                       vector-init-loop.78
                                                                                                                                                                                                                                                       14
                                                                                                                                                                                                                                                       vector-init-loop.78)
                                                                                                                                                                                                                                                      (mset!
                                                                                                                                                                                                                                                       make-init-vector.1
                                                                                                                                                                                                                                                       14
                                                                                                                                                                                                                                                       vector-init-loop.78)
                                                                                                                                                                                                                                                      (mset!
                                                                                                                                                                                                                                                       vector-ref.60
                                                                                                                                                                                                                                                       14
                                                                                                                                                                                                                                                       unsafe-vector-ref.3)
                                                                                                                                                                                                                                                      (mset!
                                                                                                                                                                                                                                                       vector-set!.59
                                                                                                                                                                                                                                                       14
                                                                                                                                                                                                                                                       unsafe-vector-set!.2)
                                                                                                                                                                                                                                                      (mset!
                                                                                                                                                                                                                                                       make-vector.57
                                                                                                                                                                                                                                                       14
                                                                                                                                                                                                                                                       make-init-vector.1)
                                                                                                                                                                                                                                                      (let ((tmp.129
                                                                                                                                                                                                                                                             make-vector.57))
                                                                                                                                                                                                                                                        (let ((counter!.4
                                                                                                                                                                                                                                                               (apply
                                                                                                                                                                                                                                                                L.make-vector.57.23
                                                                                                                                                                                                                                                                make-vector.57
                                                                                                                                                                                                                                                                8)))
                                                                                                                                                                                                                                                          (let ((tmp.130
                                                                                                                                                                                                                                                                 make-vector.57))
                                                                                                                                                                                                                                                            (let ((x.5
                                                                                                                                                                                                                                                                   (apply
                                                                                                                                                                                                                                                                    L.make-vector.57.23
                                                                                                                                                                                                                                                                    make-vector.57
                                                                                                                                                                                                                                                                    8)))
                                                                                                                                                                                                                                                              (let ((tmp.333
                                                                                                                                                                                                                                                                     (alloc
                                                                                                                                                                                                                                                                      56)))
                                                                                                                                                                                                                                                                (let ((tmp.177
                                                                                                                                                                                                                                                                       (+
                                                                                                                                                                                                                                                                        tmp.333
                                                                                                                                                                                                                                                                        2)))
                                                                                                                                                                                                                                                                  (begin
                                                                                                                                                                                                                                                                    (mset!
                                                                                                                                                                                                                                                                     tmp.177
                                                                                                                                                                                                                                                                     -2
                                                                                                                                                                                                                                                                     L.tmp.11.31)
                                                                                                                                                                                                                                                                    (mset!
                                                                                                                                                                                                                                                                     tmp.177
                                                                                                                                                                                                                                                                     6
                                                                                                                                                                                                                                                                     0)
                                                                                                                                                                                                                                                                    (let ((tmp.11
                                                                                                                                                                                                                                                                           tmp.177))
                                                                                                                                                                                                                                                                      (begin
                                                                                                                                                                                                                                                                        (mset!
                                                                                                                                                                                                                                                                         tmp.11
                                                                                                                                                                                                                                                                         14
                                                                                                                                                                                                                                                                         vector-ref.60)
                                                                                                                                                                                                                                                                        (mset!
                                                                                                                                                                                                                                                                         tmp.11
                                                                                                                                                                                                                                                                         22
                                                                                                                                                                                                                                                                         |+.51|)
                                                                                                                                                                                                                                                                        (mset!
                                                                                                                                                                                                                                                                         tmp.11
                                                                                                                                                                                                                                                                         30
                                                                                                                                                                                                                                                                         x.5)
                                                                                                                                                                                                                                                                        (mset!
                                                                                                                                                                                                                                                                         tmp.11
                                                                                                                                                                                                                                                                         38
                                                                                                                                                                                                                                                                         vector-set!.59)
                                                                                                                                                                                                                                                                        (mset!
                                                                                                                                                                                                                                                                         tmp.11
                                                                                                                                                                                                                                                                         46
                                                                                                                                                                                                                                                                         error?.69)
                                                                                                                                                                                                                                                                        (let ((counter!.4.9
                                                                                                                                                                                                                                                                               tmp.11))
                                                                                                                                                                                                                                                                          (let ((tmp.136
                                                                                                                                                                                                                                                                                 vector-set!.59))
                                                                                                                                                                                                                                                                            (let ((tmp.10
                                                                                                                                                                                                                                                                                   (apply
                                                                                                                                                                                                                                                                                    L.vector-set!.59.21
                                                                                                                                                                                                                                                                                    vector-set!.59
                                                                                                                                                                                                                                                                                    counter!.4
                                                                                                                                                                                                                                                                                    0
                                                                                                                                                                                                                                                                                    counter!.4.9)))
                                                                                                                                                                                                                                                                              (let ((tmp.137
                                                                                                                                                                                                                                                                                     vector-ref.60))
                                                                                                                                                                                                                                                                                (let ((tmp.121
                                                                                                                                                                                                                                                                                       (apply
                                                                                                                                                                                                                                                                                        L.vector-ref.60.20
                                                                                                                                                                                                                                                                                        vector-ref.60
                                                                                                                                                                                                                                                                                        counter!.4
                                                                                                                                                                                                                                                                                        0)))
                                                                                                                                                                                                                                                                                  (let ((tmp.142
                                                                                                                                                                                                                                                                                         tmp.121))
                                                                                                                                                                                                                                                                                    (let ((tmp.360
                                                                                                                                                                                                                                                                                           (bitwise-and
                                                                                                                                                                                                                                                                                            tmp.142
                                                                                                                                                                                                                                                                                            7)))
                                                                                                                                                                                                                                                                                      (if (eq?
                                                                                                                                                                                                                                                                                           tmp.360
                                                                                                                                                                                                                                                                                           2)
                                                                                                                                                                                                                                                                                        (apply
                                                                                                                                                                                                                                                                                         L.jp.117
                                                                                                                                                                                                                                                                                         14
                                                                                                                                                                                                                                                                                         tmp.142
                                                                                                                                                                                                                                                                                         error?.69
                                                                                                                                                                                                                                                                                         counter!.4
                                                                                                                                                                                                                                                                                         vector-ref.60
                                                                                                                                                                                                                                                                                         tmp.121)
                                                                                                                                                                                                                                                                                        (apply
                                                                                                                                                                                                                                                                                         L.jp.117
                                                                                                                                                                                                                                                                                         6
                                                                                                                                                                                                                                                                                         tmp.142
                                                                                                                                                                                                                                                                                         error?.69
                                                                                                                                                                                                                                                                                         counter!.4
                                                                                                                                                                                                                                                                                         vector-ref.60
                                                                                                                                                                                                                                                                                         tmp.121))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
    ) 3)
  )


    #;(parameterize ([current-pass-list
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
     (execute  '(module
    (define L.tmp.11.31
      (lambda (c.120)
        (let ((vector-ref.60 (mref c.120 14)))
          (let ((|+.51| (mref c.120 22)))
            (let ((x.5 (mref c.120 30)))
              (let ((vector-set!.59 (mref c.120 38)))
                (let ((error?.69 (mref c.120 46)))
                  (let ((tmp.6
                         (let ((tmp.131 vector-set!.59))
                           (apply
                            L.vector-set!.59.21
                            vector-set!.59
                            x.5
                            0
                            (let ((tmp.132 |+.51|))
                              (apply
                               L.+.51.29
                               |+.51|
                               8
                               (let ((tmp.133 vector-ref.60))
                                 (apply
                                  L.vector-ref.60.20
                                  vector-ref.60
                                  x.5
                                  0))))))))
                    (if (neq?
                         (let ((tmp.134 error?.69))
                           (apply L.error?.69.11 error?.69 tmp.6))
                         6)
                      tmp.6
                      (let ((tmp.135 vector-ref.60))
                        (apply
                         L.vector-ref.60.20
                         vector-ref.60
                         x.5
                         0)))))))))))
    (define L.*.50.30
      (lambda (c.119 tmp.12 tmp.13)
        (if (neq? (if (eq? (bitwise-and tmp.13 7) 0) 14 6) 6)
          (if (neq? (if (eq? (bitwise-and tmp.12 7) 0) 14 6) 6)
            (* tmp.12 (arithmetic-shift-right tmp.13 3))
            62)
          62)))
    (define L.+.51.29
      (lambda (c.118 tmp.14 tmp.15)
        (if (neq? (if (eq? (bitwise-and tmp.15 7) 0) 14 6) 6)
          (if (neq? (if (eq? (bitwise-and tmp.14 7) 0) 14 6) 6)
            (+ tmp.14 tmp.15)
            318)
          318)))
    (define L.-.52.28
      (lambda (c.117 tmp.16 tmp.17)
        (if (neq? (if (eq? (bitwise-and tmp.17 7) 0) 14 6) 6)
          (if (neq? (if (eq? (bitwise-and tmp.16 7) 0) 14 6) 6)
            (- tmp.16 tmp.17)
            574)
          574)))
    (define L.<.53.27
      (lambda (c.116 tmp.18 tmp.19)
        (if (neq? (if (eq? (bitwise-and tmp.19 7) 0) 14 6) 6)
          (if (neq? (if (eq? (bitwise-and tmp.18 7) 0) 14 6) 6)
            (if (< tmp.18 tmp.19) 14 6)
            830)
          830)))
    (define L.<=.54.26
      (lambda (c.115 tmp.20 tmp.21)
        (if (neq? (if (eq? (bitwise-and tmp.21 7) 0) 14 6) 6)
          (if (neq? (if (eq? (bitwise-and tmp.20 7) 0) 14 6) 6)
            (if (<= tmp.20 tmp.21) 14 6)
            1086)
          1086)))
    (define L.>.55.25
      (lambda (c.114 tmp.22 tmp.23)
        (if (neq? (if (eq? (bitwise-and tmp.23 7) 0) 14 6) 6)
          (if (neq? (if (eq? (bitwise-and tmp.22 7) 0) 14 6) 6)
            (if (> tmp.22 tmp.23) 14 6)
            1342)
          1342)))
    (define L.>=.56.24
      (lambda (c.113 tmp.24 tmp.25)
        (if (neq? (if (eq? (bitwise-and tmp.25 7) 0) 14 6) 6)
          (if (neq? (if (eq? (bitwise-and tmp.24 7) 0) 14 6) 6)
            (if (>= tmp.24 tmp.25) 14 6)
            1598)
          1598)))
    (define L.make-vector.57.23
      (lambda (c.112 tmp.26)
        (let ((make-init-vector.1 (mref c.112 14)))
          (if (neq? (if (eq? (bitwise-and tmp.26 7) 0) 14 6) 6)
            (let ((tmp.128 make-init-vector.1))
              (apply L.make-init-vector.1.4 make-init-vector.1 tmp.26))
            1854))))
    (define L.vector-length.58.22
      (lambda (c.111 tmp.27)
        (if (neq? (if (eq? (bitwise-and tmp.27 7) 3) 14 6) 6)
          (mref tmp.27 -3)
          2110)))
    (define L.vector-set!.59.21
      (lambda (c.110 tmp.28 tmp.29 tmp.30)
        (let ((unsafe-vector-set!.2 (mref c.110 14)))
          (if (neq? (if (eq? (bitwise-and tmp.29 7) 0) 14 6) 6)
            (if (neq? (if (eq? (bitwise-and tmp.28 7) 3) 14 6) 6)
              (let ((tmp.127 unsafe-vector-set!.2))
                (apply
                 L.unsafe-vector-set!.2.2
                 unsafe-vector-set!.2
                 tmp.28
                 tmp.29
                 tmp.30))
              2366)
            2366))))
    (define L.vector-ref.60.20
      (lambda (c.109 tmp.31 tmp.32)
        (let ((unsafe-vector-ref.3 (mref c.109 14)))
          (if (neq? (if (eq? (bitwise-and tmp.32 7) 0) 14 6) 6)
            (if (neq? (if (eq? (bitwise-and tmp.31 7) 3) 14 6) 6)
              (let ((tmp.126 unsafe-vector-ref.3))
                (apply
                 L.unsafe-vector-ref.3.1
                 unsafe-vector-ref.3
                 tmp.31
                 tmp.32))
              2622)
            2622))))
    (define L.car.61.19
      (lambda (c.108 tmp.33)
        (if (neq? (if (eq? (bitwise-and tmp.33 7) 1) 14 6) 6)
          (mref tmp.33 -1)
          2878)))
    (define L.cdr.62.18
      (lambda (c.107 tmp.34)
        (if (neq? (if (eq? (bitwise-and tmp.34 7) 1) 14 6) 6)
          (mref tmp.34 7)
          3134)))
    (define L.procedure-arity.63.17
      (lambda (c.106 tmp.35)
        (if (neq? (if (eq? (bitwise-and tmp.35 7) 2) 14 6) 6)
          (mref tmp.35 6)
          3390)))
    (define L.fixnum?.64.16
      (lambda (c.105 tmp.36) (if (eq? (bitwise-and tmp.36 7) 0) 14 6)))
    (define L.boolean?.65.15
      (lambda (c.104 tmp.37) (if (eq? (bitwise-and tmp.37 247) 6) 14 6)))
    (define L.empty?.66.14
      (lambda (c.103 tmp.38) (if (eq? (bitwise-and tmp.38 255) 22) 14 6)))
    (define L.void?.67.13
      (lambda (c.102 tmp.39) (if (eq? (bitwise-and tmp.39 255) 30) 14 6)))
    (define L.ascii-char?.68.12
      (lambda (c.101 tmp.40) (if (eq? (bitwise-and tmp.40 255) 46) 14 6)))
    (define L.error?.69.11
      (lambda (c.100 tmp.41) (if (eq? (bitwise-and tmp.41 255) 62) 14 6)))
    (define L.pair?.70.10
      (lambda (c.99 tmp.42) (if (eq? (bitwise-and tmp.42 7) 1) 14 6)))
    (define L.procedure?.71.9
      (lambda (c.98 tmp.43) (if (eq? (bitwise-and tmp.43 7) 2) 14 6)))
    (define L.vector?.72.8
      (lambda (c.97 tmp.44) (if (eq? (bitwise-and tmp.44 7) 3) 14 6)))
    (define L.not.73.7 (lambda (c.96 tmp.45) (if (neq? tmp.45 6) 6 14)))
    (define L.cons.74.6
      (lambda (c.95 tmp.46 tmp.47)
        (let ((tmp.145 (+ (alloc 16) 1)))
          (begin (mset! tmp.145 -1 tmp.46) (mset! tmp.145 7 tmp.47) tmp.145))))
    (define L.eq?.75.5
      (lambda (c.94 tmp.48 tmp.49) (if (eq? tmp.48 tmp.49) 14 6)))
    (define L.make-init-vector.1.4
      (lambda (c.93 tmp.76)
        (let ((vector-init-loop.78 (mref c.93 14)))
          (let ((tmp.77
                 (let ((tmp.146
                        (+
                         (alloc (* (+ 1 (arithmetic-shift-right tmp.76 3)) 8))
                         3)))
                   (begin (mset! tmp.146 -3 tmp.76) tmp.146))))
            (let ((tmp.125 vector-init-loop.78))
              (apply
               L.vector-init-loop.78.3
               vector-init-loop.78
               tmp.76
               0
               tmp.77))))))
    (define L.vector-init-loop.78.3
      (lambda (c.92 len.79 i.81 vec.80)
        (let ((vector-init-loop.78 (mref c.92 14)))
          (if (neq? (if (eq? len.79 i.81) 14 6) 6)
            vec.80
            (begin
              (mset! vec.80 (+ (* (arithmetic-shift-right i.81 3) 8) 5) 0)
              (let ((tmp.124 vector-init-loop.78))
                (apply
                 L.vector-init-loop.78.3
                 vector-init-loop.78
                 len.79
                 (+ i.81 8)
                 vec.80)))))))
    (define L.unsafe-vector-set!.2.2
      (lambda (c.91 tmp.87 tmp.88 tmp.89)
        (if (neq? (if (< tmp.88 (mref tmp.87 -3)) 14 6) 6)
          (if (neq? (if (>= tmp.88 0) 14 6) 6)
            (begin
              (mset!
               tmp.87
               (+ (* (arithmetic-shift-right tmp.88 3) 8) 5)
               tmp.89)
              30)
            2366)
          2366)))
    (define L.unsafe-vector-ref.3.1
      (lambda (c.90 tmp.84 tmp.85)
        (if (neq? (if (< tmp.85 (mref tmp.84 -3)) 14 6) 6)
          (if (neq? (if (>= tmp.85 0) 14 6) 6)
            (mref tmp.84 (+ (* (arithmetic-shift-right tmp.85 3) 8) 5))
            2622)
          2622)))
    (let ((unsafe-vector-ref.3
           (let ((tmp.147 (+ (alloc 16) 2)))
             (begin
               (mset! tmp.147 -2 L.unsafe-vector-ref.3.1)
               (mset! tmp.147 6 16)
               tmp.147))))
      (let ((unsafe-vector-set!.2
             (let ((tmp.148 (+ (alloc 16) 2)))
               (begin
                 (mset! tmp.148 -2 L.unsafe-vector-set!.2.2)
                 (mset! tmp.148 6 24)
                 tmp.148))))
        (let ((vector-init-loop.78
               (let ((tmp.149 (+ (alloc 24) 2)))
                 (begin
                   (mset! tmp.149 -2 L.vector-init-loop.78.3)
                   (mset! tmp.149 6 24)
                   tmp.149))))
          (let ((make-init-vector.1
                 (let ((tmp.150 (+ (alloc 24) 2)))
                   (begin
                     (mset! tmp.150 -2 L.make-init-vector.1.4)
                     (mset! tmp.150 6 8)
                     tmp.150))))
            (let ((eq?.75
                   (let ((tmp.151 (+ (alloc 16) 2)))
                     (begin
                       (mset! tmp.151 -2 L.eq?.75.5)
                       (mset! tmp.151 6 16)
                       tmp.151))))
              (let ((cons.74
                     (let ((tmp.152 (+ (alloc 16) 2)))
                       (begin
                         (mset! tmp.152 -2 L.cons.74.6)
                         (mset! tmp.152 6 16)
                         tmp.152))))
                (let ((not.73
                       (let ((tmp.153 (+ (alloc 16) 2)))
                         (begin
                           (mset! tmp.153 -2 L.not.73.7)
                           (mset! tmp.153 6 8)
                           tmp.153))))
                  (let ((vector?.72
                         (let ((tmp.154 (+ (alloc 16) 2)))
                           (begin
                             (mset! tmp.154 -2 L.vector?.72.8)
                             (mset! tmp.154 6 8)
                             tmp.154))))
                    (let ((procedure?.71
                           (let ((tmp.155 (+ (alloc 16) 2)))
                             (begin
                               (mset! tmp.155 -2 L.procedure?.71.9)
                               (mset! tmp.155 6 8)
                               tmp.155))))
                      (let ((pair?.70
                             (let ((tmp.156 (+ (alloc 16) 2)))
                               (begin
                                 (mset! tmp.156 -2 L.pair?.70.10)
                                 (mset! tmp.156 6 8)
                                 tmp.156))))
                        (let ((error?.69
                               (let ((tmp.157 (+ (alloc 16) 2)))
                                 (begin
                                   (mset! tmp.157 -2 L.error?.69.11)
                                   (mset! tmp.157 6 8)
                                   tmp.157))))
                          (let ((ascii-char?.68
                                 (let ((tmp.158 (+ (alloc 16) 2)))
                                   (begin
                                     (mset! tmp.158 -2 L.ascii-char?.68.12)
                                     (mset! tmp.158 6 8)
                                     tmp.158))))
                            (let ((void?.67
                                   (let ((tmp.159 (+ (alloc 16) 2)))
                                     (begin
                                       (mset! tmp.159 -2 L.void?.67.13)
                                       (mset! tmp.159 6 8)
                                       tmp.159))))
                              (let ((empty?.66
                                     (let ((tmp.160 (+ (alloc 16) 2)))
                                       (begin
                                         (mset! tmp.160 -2 L.empty?.66.14)
                                         (mset! tmp.160 6 8)
                                         tmp.160))))
                                (let ((boolean?.65
                                       (let ((tmp.161 (+ (alloc 16) 2)))
                                         (begin
                                           (mset! tmp.161 -2 L.boolean?.65.15)
                                           (mset! tmp.161 6 8)
                                           tmp.161))))
                                  (let ((fixnum?.64
                                         (let ((tmp.162 (+ (alloc 16) 2)))
                                           (begin
                                             (mset! tmp.162 -2 L.fixnum?.64.16)
                                             (mset! tmp.162 6 8)
                                             tmp.162))))
                                    (let ((procedure-arity.63
                                           (let ((tmp.163 (+ (alloc 16) 2)))
                                             (begin
                                               (mset!
                                                tmp.163
                                                -2
                                                L.procedure-arity.63.17)
                                               (mset! tmp.163 6 8)
                                               tmp.163))))
                                      (let ((cdr.62
                                             (let ((tmp.164 (+ (alloc 16) 2)))
                                               (begin
                                                 (mset! tmp.164 -2 L.cdr.62.18)
                                                 (mset! tmp.164 6 8)
                                                 tmp.164))))
                                        (let ((car.61
                                               (let ((tmp.165
                                                      (+ (alloc 16) 2)))
                                                 (begin
                                                   (mset!
                                                    tmp.165
                                                    -2
                                                    L.car.61.19)
                                                   (mset! tmp.165 6 8)
                                                   tmp.165))))
                                          (let ((vector-ref.60
                                                 (let ((tmp.166
                                                        (+ (alloc 24) 2)))
                                                   (begin
                                                     (mset!
                                                      tmp.166
                                                      -2
                                                      L.vector-ref.60.20)
                                                     (mset! tmp.166 6 16)
                                                     tmp.166))))
                                            (let ((vector-set!.59
                                                   (let ((tmp.167
                                                          (+ (alloc 24) 2)))
                                                     (begin
                                                       (mset!
                                                        tmp.167
                                                        -2
                                                        L.vector-set!.59.21)
                                                       (mset! tmp.167 6 24)
                                                       tmp.167))))
                                              (let ((vector-length.58
                                                     (let ((tmp.168
                                                            (+ (alloc 16) 2)))
                                                       (begin
                                                         (mset!
                                                          tmp.168
                                                          -2
                                                          L.vector-length.58.22)
                                                         (mset! tmp.168 6 8)
                                                         tmp.168))))
                                                (let ((make-vector.57
                                                       (let ((tmp.169
                                                              (+
                                                               (alloc 24)
                                                               2)))
                                                         (begin
                                                           (mset!
                                                            tmp.169
                                                            -2
                                                            L.make-vector.57.23)
                                                           (mset! tmp.169 6 8)
                                                           tmp.169))))
                                                  (let ((>=.56
                                                         (let ((tmp.170
                                                                (+
                                                                 (alloc 16)
                                                                 2)))
                                                           (begin
                                                             (mset!
                                                              tmp.170
                                                              -2
                                                              L.>=.56.24)
                                                             (mset!
                                                              tmp.170
                                                              6
                                                              16)
                                                             tmp.170))))
                                                    (let ((>.55
                                                           (let ((tmp.171
                                                                  (+
                                                                   (alloc 16)
                                                                   2)))
                                                             (begin
                                                               (mset!
                                                                tmp.171
                                                                -2
                                                                L.>.55.25)
                                                               (mset!
                                                                tmp.171
                                                                6
                                                                16)
                                                               tmp.171))))
                                                      (let ((<=.54
                                                             (let ((tmp.172
                                                                    (+
                                                                     (alloc 16)
                                                                     2)))
                                                               (begin
                                                                 (mset!
                                                                  tmp.172
                                                                  -2
                                                                  L.<=.54.26)
                                                                 (mset!
                                                                  tmp.172
                                                                  6
                                                                  16)
                                                                 tmp.172))))
                                                        (let ((<.53
                                                               (let ((tmp.173
                                                                      (+
                                                                       (alloc
                                                                        16)
                                                                       2)))
                                                                 (begin
                                                                   (mset!
                                                                    tmp.173
                                                                    -2
                                                                    L.<.53.27)
                                                                   (mset!
                                                                    tmp.173
                                                                    6
                                                                    16)
                                                                   tmp.173))))
                                                          (let ((|-.52|
                                                                 (let ((tmp.174
                                                                        (+
                                                                         (alloc
                                                                          16)
                                                                         2)))
                                                                   (begin
                                                                     (mset!
                                                                      tmp.174
                                                                      -2
                                                                      L.-.52.28)
                                                                     (mset!
                                                                      tmp.174
                                                                      6
                                                                      16)
                                                                     tmp.174))))
                                                            (let ((|+.51|
                                                                   (let ((tmp.175
                                                                          (+
                                                                           (alloc
                                                                            16)
                                                                           2)))
                                                                     (begin
                                                                       (mset!
                                                                        tmp.175
                                                                        -2
                                                                        L.+.51.29)
                                                                       (mset!
                                                                        tmp.175
                                                                        6
                                                                        16)
                                                                       tmp.175))))
                                                              (let ((*.50
                                                                     (let ((tmp.176
                                                                            (+
                                                                             (alloc
                                                                              16)
                                                                             2)))
                                                                       (begin
                                                                         (mset!
                                                                          tmp.176
                                                                          -2
                                                                          L.*.50.30)
                                                                         (mset!
                                                                          tmp.176
                                                                          6
                                                                          16)
                                                                         tmp.176))))
                                                                (begin
                                                                  (begin)
                                                                  (begin)
                                                                  (begin
                                                                    (mset!
                                                                     vector-init-loop.78
                                                                     14
                                                                     vector-init-loop.78))
                                                                  (begin
                                                                    (mset!
                                                                     make-init-vector.1
                                                                     14
                                                                     vector-init-loop.78))
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
                                                                     vector-ref.60
                                                                     14
                                                                     unsafe-vector-ref.3))
                                                                  (begin
                                                                    (mset!
                                                                     vector-set!.59
                                                                     14
                                                                     unsafe-vector-set!.2))
                                                                  (begin)
                                                                  (begin
                                                                    (mset!
                                                                     make-vector.57
                                                                     14
                                                                     make-init-vector.1))
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (let ((counter!.4
                                                                         (let ((tmp.129
                                                                                make-vector.57))
                                                                           (apply
                                                                            L.make-vector.57.23
                                                                            make-vector.57
                                                                            8))))
                                                                    (begin
                                                                      (let ((counter!.4.9
                                                                             (let ((x.5
                                                                                    (let ((tmp.130
                                                                                           make-vector.57))
                                                                                      (apply
                                                                                       L.make-vector.57.23
                                                                                       make-vector.57
                                                                                       8))))
                                                                               (let ((tmp.11
                                                                                      (let ((tmp.177
                                                                                             (+
                                                                                              (alloc
                                                                                               56)
                                                                                              2)))
                                                                                        (begin
                                                                                          (mset!
                                                                                           tmp.177
                                                                                           -2
                                                                                           L.tmp.11.31)
                                                                                          (mset!
                                                                                           tmp.177
                                                                                           6
                                                                                           0)
                                                                                          tmp.177))))
                                                                                 (begin
                                                                                   (begin
                                                                                     (mset!
                                                                                      tmp.11
                                                                                      14
                                                                                      vector-ref.60)
                                                                                     (mset!
                                                                                      tmp.11
                                                                                      22
                                                                                      |+.51|)
                                                                                     (mset!
                                                                                      tmp.11
                                                                                      30
                                                                                      x.5)
                                                                                     (mset!
                                                                                      tmp.11
                                                                                      38
                                                                                      vector-set!.59)
                                                                                     (mset!
                                                                                      tmp.11
                                                                                      46
                                                                                      error?.69))
                                                                                   tmp.11)))))
                                                                        (let ((tmp.10
                                                                               (let ((tmp.136
                                                                                      vector-set!.59))
                                                                                 (apply
                                                                                  L.vector-set!.59.21
                                                                                  vector-set!.59
                                                                                  counter!.4
                                                                                  0
                                                                                  counter!.4.9))))
                                                                          (let ((tmp.7
                                                                                 (let ((tmp.121
                                                                                        (let ((tmp.137
                                                                                               vector-ref.60))
                                                                                          (apply
                                                                                           L.vector-ref.60.20
                                                                                           vector-ref.60
                                                                                           counter!.4
                                                                                           0))))
                                                                                   (let ((tmp.142
                                                                                          tmp.121))
                                                                                     (if (neq?
                                                                                          (if (eq?
                                                                                               (bitwise-and
                                                                                                tmp.142
                                                                                                7)
                                                                                               2)
                                                                                            14
                                                                                            6)
                                                                                          6)
                                                                                       (if (neq?
                                                                                            (if (eq?
                                                                                                 (mref
                                                                                                  tmp.142
                                                                                                  6)
                                                                                                 0)
                                                                                              14
                                                                                              6)
                                                                                            6)
                                                                                         (apply
                                                                                          (mref
                                                                                           tmp.142
                                                                                           -2)
                                                                                          tmp.121)
                                                                                         10814)
                                                                                       11070)))))
                                                                            (if (neq?
                                                                                 (let ((tmp.138
                                                                                        error?.69))
                                                                                   (apply
                                                                                    L.error?.69.11
                                                                                    error?.69
                                                                                    tmp.7))
                                                                                 6)
                                                                              tmp.7
                                                                              (let ((tmp.8
                                                                                     (let ((tmp.122
                                                                                            (let ((tmp.139
                                                                                                   vector-ref.60))
                                                                                              (apply
                                                                                               L.vector-ref.60.20
                                                                                               vector-ref.60
                                                                                               counter!.4
                                                                                               0))))
                                                                                       (let ((tmp.143
                                                                                              tmp.122))
                                                                                         (if (neq?
                                                                                              (if (eq?
                                                                                                   (bitwise-and
                                                                                                    tmp.143
                                                                                                    7)
                                                                                                   2)
                                                                                                14
                                                                                                6)
                                                                                              6)
                                                                                           (if (neq?
                                                                                                (if (eq?
                                                                                                     (mref
                                                                                                      tmp.143
                                                                                                      6)
                                                                                                     0)
                                                                                                  14
                                                                                                  6)
                                                                                                6)
                                                                                             (apply
                                                                                              (mref
                                                                                               tmp.143
                                                                                               -2)
                                                                                              tmp.122)
                                                                                             10814)
                                                                                           11070)))))
                                                                                (if (neq?
                                                                                     (let ((tmp.140
                                                                                            error?.69))
                                                                                       (apply
                                                                                        L.error?.69.11
                                                                                        error?.69
                                                                                        tmp.8))
                                                                                     6)
                                                                                  tmp.8
                                                                                  (let ((tmp.123
                                                                                         (let ((tmp.141
                                                                                                vector-ref.60))
                                                                                           (apply
                                                                                            L.vector-ref.60.20
                                                                                            vector-ref.60
                                                                                            counter!.4
                                                                                            0))))
                                                                                    (let ((tmp.144
                                                                                           tmp.123))
                                                                                      (if (neq?
                                                                                           (if (eq?
                                                                                                (bitwise-and
                                                                                                 tmp.144
                                                                                                 7)
                                                                                                2)
                                                                                             14
                                                                                             6)
                                                                                           6)
                                                                                        (if (neq?
                                                                                             (if (eq?
                                                                                                  (mref
                                                                                                   tmp.144
                                                                                                   6)
                                                                                                  0)
                                                                                               14
                                                                                               6)
                                                                                             6)
                                                                                          (apply
                                                                                           (mref
                                                                                            tmp.144
                                                                                            -2)
                                                                                           tmp.123)
                                                                                          10814)
                                                                                        11070)))))))))))))))))))))))))))))))))))))))))))
    ) 3)
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
     (execute '(module
    (define L.tmp.11.31
      (lambda (c.120)
        (let ((vector-ref.60 (unsafe-procedure-ref c.120 0)))
          (let ((|+.51| (unsafe-procedure-ref c.120 1)))
            (let ((x.5 (unsafe-procedure-ref c.120 2)))
              (let ((vector-set!.59 (unsafe-procedure-ref c.120 3)))
                (let ((error?.69 (unsafe-procedure-ref c.120 4)))
                  (let ((tmp.6
                         (let ((tmp.131 vector-set!.59))
                           (apply
                            L.vector-set!.59.21
                            vector-set!.59
                            x.5
                            0
                            (let ((tmp.132 |+.51|))
                              (apply
                               L.+.51.29
                               |+.51|
                               1
                               (let ((tmp.133 vector-ref.60))
                                 (apply
                                  L.vector-ref.60.20
                                  vector-ref.60
                                  x.5
                                  0))))))))
                    (if (let ((tmp.134 error?.69))
                          (apply L.error?.69.11 error?.69 tmp.6))
                      tmp.6
                      (let ((tmp.135 vector-ref.60))
                        (apply
                         L.vector-ref.60.20
                         vector-ref.60
                         x.5
                         0)))))))))))
    (define L.*.50.30
      (lambda (c.119 tmp.12 tmp.13)
        (if (fixnum? tmp.13)
          (if (fixnum? tmp.12) (unsafe-fx* tmp.12 tmp.13) (error 0))
          (error 0))))
    (define L.+.51.29
      (lambda (c.118 tmp.14 tmp.15)
        (if (fixnum? tmp.15)
          (if (fixnum? tmp.14) (unsafe-fx+ tmp.14 tmp.15) (error 1))
          (error 1))))
    (define L.-.52.28
      (lambda (c.117 tmp.16 tmp.17)
        (if (fixnum? tmp.17)
          (if (fixnum? tmp.16) (unsafe-fx- tmp.16 tmp.17) (error 2))
          (error 2))))
    (define L.<.53.27
      (lambda (c.116 tmp.18 tmp.19)
        (if (fixnum? tmp.19)
          (if (fixnum? tmp.18) (unsafe-fx< tmp.18 tmp.19) (error 3))
          (error 3))))
    (define L.<=.54.26
      (lambda (c.115 tmp.20 tmp.21)
        (if (fixnum? tmp.21)
          (if (fixnum? tmp.20) (unsafe-fx<= tmp.20 tmp.21) (error 4))
          (error 4))))
    (define L.>.55.25
      (lambda (c.114 tmp.22 tmp.23)
        (if (fixnum? tmp.23)
          (if (fixnum? tmp.22) (unsafe-fx> tmp.22 tmp.23) (error 5))
          (error 5))))
    (define L.>=.56.24
      (lambda (c.113 tmp.24 tmp.25)
        (if (fixnum? tmp.25)
          (if (fixnum? tmp.24) (unsafe-fx>= tmp.24 tmp.25) (error 6))
          (error 6))))
    (define L.make-vector.57.23
      (lambda (c.112 tmp.26)
        (let ((make-init-vector.1 (unsafe-procedure-ref c.112 0)))
          (if (fixnum? tmp.26)
            (let ((tmp.128 make-init-vector.1))
              (apply L.make-init-vector.1.4 make-init-vector.1 tmp.26))
            (error 7)))))
    (define L.vector-length.58.22
      (lambda (c.111 tmp.27)
        (if (vector? tmp.27) (unsafe-vector-length tmp.27) (error 8))))
    (define L.vector-set!.59.21
      (lambda (c.110 tmp.28 tmp.29 tmp.30)
        (let ((unsafe-vector-set!.2 (unsafe-procedure-ref c.110 0)))
          (if (fixnum? tmp.29)
            (if (vector? tmp.28)
              (let ((tmp.127 unsafe-vector-set!.2))
                (apply
                 L.unsafe-vector-set!.2.2
                 unsafe-vector-set!.2
                 tmp.28
                 tmp.29
                 tmp.30))
              (error 9))
            (error 9)))))
    (define L.vector-ref.60.20
      (lambda (c.109 tmp.31 tmp.32)
        (let ((unsafe-vector-ref.3 (unsafe-procedure-ref c.109 0)))
          (if (fixnum? tmp.32)
            (if (vector? tmp.31)
              (let ((tmp.126 unsafe-vector-ref.3))
                (apply
                 L.unsafe-vector-ref.3.1
                 unsafe-vector-ref.3
                 tmp.31
                 tmp.32))
              (error 10))
            (error 10)))))
    (define L.car.61.19
      (lambda (c.108 tmp.33)
        (if (pair? tmp.33) (unsafe-car tmp.33) (error 11))))
    (define L.cdr.62.18
      (lambda (c.107 tmp.34)
        (if (pair? tmp.34) (unsafe-cdr tmp.34) (error 12))))
    (define L.procedure-arity.63.17
      (lambda (c.106 tmp.35)
        (if (procedure? tmp.35) (unsafe-procedure-arity tmp.35) (error 13))))
    (define L.fixnum?.64.16 (lambda (c.105 tmp.36) (fixnum? tmp.36)))
    (define L.boolean?.65.15 (lambda (c.104 tmp.37) (boolean? tmp.37)))
    (define L.empty?.66.14 (lambda (c.103 tmp.38) (empty? tmp.38)))
    (define L.void?.67.13 (lambda (c.102 tmp.39) (void? tmp.39)))
    (define L.ascii-char?.68.12 (lambda (c.101 tmp.40) (ascii-char? tmp.40)))
    (define L.error?.69.11 (lambda (c.100 tmp.41) (error? tmp.41)))
    (define L.pair?.70.10 (lambda (c.99 tmp.42) (pair? tmp.42)))
    (define L.procedure?.71.9 (lambda (c.98 tmp.43) (procedure? tmp.43)))
    (define L.vector?.72.8 (lambda (c.97 tmp.44) (vector? tmp.44)))
    (define L.not.73.7 (lambda (c.96 tmp.45) (not tmp.45)))
    (define L.cons.74.6 (lambda (c.95 tmp.46 tmp.47) (cons tmp.46 tmp.47)))
    (define L.eq?.75.5 (lambda (c.94 tmp.48 tmp.49) (eq? tmp.48 tmp.49)))
    (define L.make-init-vector.1.4
      (lambda (c.93 tmp.76)
        (let ((vector-init-loop.78 (unsafe-procedure-ref c.93 0)))
          (let ((tmp.77 (unsafe-make-vector tmp.76)))
            (let ((tmp.125 vector-init-loop.78))
              (apply
               L.vector-init-loop.78.3
               vector-init-loop.78
               tmp.76
               0
               tmp.77))))))
    (define L.vector-init-loop.78.3
      (lambda (c.92 len.79 i.81 vec.80)
        (let ((vector-init-loop.78 (unsafe-procedure-ref c.92 0)))
          (if (eq? len.79 i.81)
            vec.80
            (begin
              (unsafe-vector-set! vec.80 i.81 0)
              (let ((tmp.124 vector-init-loop.78))
                (apply
                 L.vector-init-loop.78.3
                 vector-init-loop.78
                 len.79
                 (unsafe-fx+ i.81 1)
                 vec.80)))))))
    (define L.unsafe-vector-set!.2.2
      (lambda (c.91 tmp.87 tmp.88 tmp.89)
        (if (unsafe-fx< tmp.88 (unsafe-vector-length tmp.87))
          (if (unsafe-fx>= tmp.88 0)
            (begin (unsafe-vector-set! tmp.87 tmp.88 tmp.89) (void))
            (error 9))
          (error 9))))
    (define L.unsafe-vector-ref.3.1
      (lambda (c.90 tmp.84 tmp.85)
        (if (unsafe-fx< tmp.85 (unsafe-vector-length tmp.84))
          (if (unsafe-fx>= tmp.85 0)
            (unsafe-vector-ref tmp.84 tmp.85)
            (error 10))
          (error 10))))
    (let ((unsafe-vector-ref.3 (make-procedure L.unsafe-vector-ref.3.1 2 0)))
      (let ((unsafe-vector-set!.2
             (make-procedure L.unsafe-vector-set!.2.2 3 0)))
        (let ((vector-init-loop.78
               (make-procedure L.vector-init-loop.78.3 3 1)))
          (let ((make-init-vector.1
                 (make-procedure L.make-init-vector.1.4 1 1)))
            (let ((eq?.75 (make-procedure L.eq?.75.5 2 0)))
              (let ((cons.74 (make-procedure L.cons.74.6 2 0)))
                (let ((not.73 (make-procedure L.not.73.7 1 0)))
                  (let ((vector?.72 (make-procedure L.vector?.72.8 1 0)))
                    (let ((procedure?.71
                           (make-procedure L.procedure?.71.9 1 0)))
                      (let ((pair?.70 (make-procedure L.pair?.70.10 1 0)))
                        (let ((error?.69 (make-procedure L.error?.69.11 1 0)))
                          (let ((ascii-char?.68
                                 (make-procedure L.ascii-char?.68.12 1 0)))
                            (let ((void?.67
                                   (make-procedure L.void?.67.13 1 0)))
                              (let ((empty?.66
                                     (make-procedure L.empty?.66.14 1 0)))
                                (let ((boolean?.65
                                       (make-procedure L.boolean?.65.15 1 0)))
                                  (let ((fixnum?.64
                                         (make-procedure L.fixnum?.64.16 1 0)))
                                    (let ((procedure-arity.63
                                           (make-procedure
                                            L.procedure-arity.63.17
                                            1
                                            0)))
                                      (let ((cdr.62
                                             (make-procedure L.cdr.62.18 1 0)))
                                        (let ((car.61
                                               (make-procedure
                                                L.car.61.19
                                                1
                                                0)))
                                          (let ((vector-ref.60
                                                 (make-procedure
                                                  L.vector-ref.60.20
                                                  2
                                                  1)))
                                            (let ((vector-set!.59
                                                   (make-procedure
                                                    L.vector-set!.59.21
                                                    3
                                                    1)))
                                              (let ((vector-length.58
                                                     (make-procedure
                                                      L.vector-length.58.22
                                                      1
                                                      0)))
                                                (let ((make-vector.57
                                                       (make-procedure
                                                        L.make-vector.57.23
                                                        1
                                                        1)))
                                                  (let ((>=.56
                                                         (make-procedure
                                                          L.>=.56.24
                                                          2
                                                          0)))
                                                    (let ((>.55
                                                           (make-procedure
                                                            L.>.55.25
                                                            2
                                                            0)))
                                                      (let ((<=.54
                                                             (make-procedure
                                                              L.<=.54.26
                                                              2
                                                              0)))
                                                        (let ((<.53
                                                               (make-procedure
                                                                L.<.53.27
                                                                2
                                                                0)))
                                                          (let ((|-.52|
                                                                 (make-procedure
                                                                  L.-.52.28
                                                                  2
                                                                  0)))
                                                            (let ((|+.51|
                                                                   (make-procedure
                                                                    L.+.51.29
                                                                    2
                                                                    0)))
                                                              (let ((*.50
                                                                     (make-procedure
                                                                      L.*.50.30
                                                                      2
                                                                      0)))
                                                                (begin
                                                                  (begin)
                                                                  (begin)
                                                                  (begin
                                                                    (unsafe-procedure-set!
                                                                     vector-init-loop.78
                                                                     0
                                                                     vector-init-loop.78))
                                                                  (begin
                                                                    (unsafe-procedure-set!
                                                                     make-init-vector.1
                                                                     0
                                                                     vector-init-loop.78))
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
                                                                     vector-ref.60
                                                                     0
                                                                     unsafe-vector-ref.3))
                                                                  (begin
                                                                    (unsafe-procedure-set!
                                                                     vector-set!.59
                                                                     0
                                                                     unsafe-vector-set!.2))
                                                                  (begin)
                                                                  (begin
                                                                    (unsafe-procedure-set!
                                                                     make-vector.57
                                                                     0
                                                                     make-init-vector.1))
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (begin)
                                                                  (let ((counter!.4
                                                                         (let ((tmp.129
                                                                                make-vector.57))
                                                                           (apply
                                                                            L.make-vector.57.23
                                                                            make-vector.57
                                                                            1))))
                                                                    (begin
                                                                      (let ((counter!.4.9
                                                                             (let ((x.5
                                                                                    (let ((tmp.130
                                                                                           make-vector.57))
                                                                                      (apply
                                                                                       L.make-vector.57.23
                                                                                       make-vector.57
                                                                                       1))))
                                                                               (let ((tmp.11
                                                                                      (make-procedure
                                                                                       L.tmp.11.31
                                                                                       0
                                                                                       5)))
                                                                                 (begin
                                                                                   (begin
                                                                                     (unsafe-procedure-set!
                                                                                      tmp.11
                                                                                      0
                                                                                      vector-ref.60)
                                                                                     (unsafe-procedure-set!
                                                                                      tmp.11
                                                                                      1
                                                                                      |+.51|)
                                                                                     (unsafe-procedure-set!
                                                                                      tmp.11
                                                                                      2
                                                                                      x.5)
                                                                                     (unsafe-procedure-set!
                                                                                      tmp.11
                                                                                      3
                                                                                      vector-set!.59)
                                                                                     (unsafe-procedure-set!
                                                                                      tmp.11
                                                                                      4
                                                                                      error?.69))
                                                                                   tmp.11)))))
                                                                        (let ((tmp.10
                                                                               (let ((tmp.136
                                                                                      vector-set!.59))
                                                                                 (apply
                                                                                  L.vector-set!.59.21
                                                                                  vector-set!.59
                                                                                  counter!.4
                                                                                  0
                                                                                  counter!.4.9))))
                                                                          (let ((tmp.7
                                                                                 (let ((tmp.121
                                                                                        (let ((tmp.137
                                                                                               vector-ref.60))
                                                                                          (apply
                                                                                           L.vector-ref.60.20
                                                                                           vector-ref.60
                                                                                           counter!.4
                                                                                           0))))
                                                                                   (let ((tmp.142
                                                                                          tmp.121))
                                                                                     (if (procedure?
                                                                                          tmp.142)
                                                                                       (if (eq?
                                                                                            (unsafe-procedure-arity
                                                                                             tmp.142)
                                                                                            0)
                                                                                         (apply
                                                                                          (unsafe-procedure-label
                                                                                           tmp.142)
                                                                                          tmp.121)
                                                                                         (error
                                                                                          42))
                                                                                       (error
                                                                                        43))))))
                                                                            (if (let ((tmp.138
                                                                                       error?.69))
                                                                                  (apply
                                                                                   L.error?.69.11
                                                                                   error?.69
                                                                                   tmp.7))
                                                                              tmp.7
                                                                              (let ((tmp.8
                                                                                     (let ((tmp.122
                                                                                            (let ((tmp.139
                                                                                                   vector-ref.60))
                                                                                              (apply
                                                                                               L.vector-ref.60.20
                                                                                               vector-ref.60
                                                                                               counter!.4
                                                                                               0))))
                                                                                       (let ((tmp.143
                                                                                              tmp.122))
                                                                                         (if (procedure?
                                                                                              tmp.143)
                                                                                           (if (eq?
                                                                                                (unsafe-procedure-arity
                                                                                                 tmp.143)
                                                                                                0)
                                                                                             (apply
                                                                                              (unsafe-procedure-label
                                                                                               tmp.143)
                                                                                              tmp.122)
                                                                                             (error
                                                                                              42))
                                                                                           (error
                                                                                            43))))))
                                                                                (if (let ((tmp.140
                                                                                           error?.69))
                                                                                      (apply
                                                                                       L.error?.69.11
                                                                                       error?.69
                                                                                       tmp.8))
                                                                                  tmp.8
                                                                                  (let ((tmp.123
                                                                                         (let ((tmp.141
                                                                                                vector-ref.60))
                                                                                           (apply
                                                                                            L.vector-ref.60.20
                                                                                            vector-ref.60
                                                                                            counter!.4
                                                                                            0))))
                                                                                    (let ((tmp.144
                                                                                           tmp.123))
                                                                                      (if (procedure?
                                                                                           tmp.144)
                                                                                        (if (eq?
                                                                                             (unsafe-procedure-arity
                                                                                              tmp.144)
                                                                                             0)
                                                                                          (apply
                                                                                           (unsafe-procedure-label
                                                                                            tmp.144)
                                                                                           tmp.123)
                                                                                          (error
                                                                                           42))
                                                                                        (error
                                                                                         43))))))))))))))))))))))))))))))))))))))))))))
          ) 3)

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
     (execute '(module
    (define L.tmp.11.31
      (lambda (c.120)
        (let ((vector-ref.60 (closure-ref c.120 0))
              (|+.51| (closure-ref c.120 1))
              (x.5 (closure-ref c.120 2))
              (vector-set!.59 (closure-ref c.120 3))
              (error?.69 (closure-ref c.120 4)))
          (let ((tmp.6
                 (let ((tmp.131 vector-set!.59))
                   (unsafe-apply
                    L.vector-set!.59.21
                    vector-set!.59
                    x.5
                    0
                    (let ((tmp.132 |+.51|))
                      (unsafe-apply
                       L.+.51.29
                       |+.51|
                       1
                       (let ((tmp.133 vector-ref.60))
                         (unsafe-apply
                          L.vector-ref.60.20
                          vector-ref.60
                          x.5
                          0))))))))
            (if (let ((tmp.134 error?.69))
                  (unsafe-apply L.error?.69.11 error?.69 tmp.6))
              tmp.6
              (let ((tmp.135 vector-ref.60))
                (unsafe-apply L.vector-ref.60.20 vector-ref.60 x.5 0)))))))
    (define L.*.50.30
      (lambda (c.119 tmp.12 tmp.13)
        (let ()
          (if (fixnum? tmp.13)
            (if (fixnum? tmp.12) (unsafe-fx* tmp.12 tmp.13) (error 0))
            (error 0)))))
    (define L.+.51.29
      (lambda (c.118 tmp.14 tmp.15)
        (let ()
          (if (fixnum? tmp.15)
            (if (fixnum? tmp.14) (unsafe-fx+ tmp.14 tmp.15) (error 1))
            (error 1)))))
    (define L.-.52.28
      (lambda (c.117 tmp.16 tmp.17)
        (let ()
          (if (fixnum? tmp.17)
            (if (fixnum? tmp.16) (unsafe-fx- tmp.16 tmp.17) (error 2))
            (error 2)))))
    (define L.<.53.27
      (lambda (c.116 tmp.18 tmp.19)
        (let ()
          (if (fixnum? tmp.19)
            (if (fixnum? tmp.18) (unsafe-fx< tmp.18 tmp.19) (error 3))
            (error 3)))))
    (define L.<=.54.26
      (lambda (c.115 tmp.20 tmp.21)
        (let ()
          (if (fixnum? tmp.21)
            (if (fixnum? tmp.20) (unsafe-fx<= tmp.20 tmp.21) (error 4))
            (error 4)))))
    (define L.>.55.25
      (lambda (c.114 tmp.22 tmp.23)
        (let ()
          (if (fixnum? tmp.23)
            (if (fixnum? tmp.22) (unsafe-fx> tmp.22 tmp.23) (error 5))
            (error 5)))))
    (define L.>=.56.24
      (lambda (c.113 tmp.24 tmp.25)
        (let ()
          (if (fixnum? tmp.25)
            (if (fixnum? tmp.24) (unsafe-fx>= tmp.24 tmp.25) (error 6))
            (error 6)))))
    (define L.make-vector.57.23
      (lambda (c.112 tmp.26)
        (let ((make-init-vector.1 (closure-ref c.112 0)))
          (if (fixnum? tmp.26)
            (let ((tmp.128 make-init-vector.1))
              (unsafe-apply L.make-init-vector.1.4 make-init-vector.1 tmp.26))
            (error 7)))))
    (define L.vector-length.58.22
      (lambda (c.111 tmp.27)
        (let ()
          (if (vector? tmp.27) (unsafe-vector-length tmp.27) (error 8)))))
    (define L.vector-set!.59.21
      (lambda (c.110 tmp.28 tmp.29 tmp.30)
        (let ((unsafe-vector-set!.2 (closure-ref c.110 0)))
          (if (fixnum? tmp.29)
            (if (vector? tmp.28)
              (let ((tmp.127 unsafe-vector-set!.2))
                (unsafe-apply
                 L.unsafe-vector-set!.2.2
                 unsafe-vector-set!.2
                 tmp.28
                 tmp.29
                 tmp.30))
              (error 9))
            (error 9)))))
    (define L.vector-ref.60.20
      (lambda (c.109 tmp.31 tmp.32)
        (let ((unsafe-vector-ref.3 (closure-ref c.109 0)))
          (if (fixnum? tmp.32)
            (if (vector? tmp.31)
              (let ((tmp.126 unsafe-vector-ref.3))
                (unsafe-apply
                 L.unsafe-vector-ref.3.1
                 unsafe-vector-ref.3
                 tmp.31
                 tmp.32))
              (error 10))
            (error 10)))))
    (define L.car.61.19
      (lambda (c.108 tmp.33)
        (let () (if (pair? tmp.33) (unsafe-car tmp.33) (error 11)))))
    (define L.cdr.62.18
      (lambda (c.107 tmp.34)
        (let () (if (pair? tmp.34) (unsafe-cdr tmp.34) (error 12)))))
    (define L.procedure-arity.63.17
      (lambda (c.106 tmp.35)
        (let ()
          (if (procedure? tmp.35)
            (unsafe-procedure-arity tmp.35)
            (error 13)))))
    (define L.fixnum?.64.16 (lambda (c.105 tmp.36) (let () (fixnum? tmp.36))))
    (define L.boolean?.65.15
      (lambda (c.104 tmp.37) (let () (boolean? tmp.37))))
    (define L.empty?.66.14 (lambda (c.103 tmp.38) (let () (empty? tmp.38))))
    (define L.void?.67.13 (lambda (c.102 tmp.39) (let () (void? tmp.39))))
    (define L.ascii-char?.68.12
      (lambda (c.101 tmp.40) (let () (ascii-char? tmp.40))))
    (define L.error?.69.11 (lambda (c.100 tmp.41) (let () (error? tmp.41))))
    (define L.pair?.70.10 (lambda (c.99 tmp.42) (let () (pair? tmp.42))))
    (define L.procedure?.71.9
      (lambda (c.98 tmp.43) (let () (procedure? tmp.43))))
    (define L.vector?.72.8 (lambda (c.97 tmp.44) (let () (vector? tmp.44))))
    (define L.not.73.7 (lambda (c.96 tmp.45) (let () (not tmp.45))))
    (define L.cons.74.6
      (lambda (c.95 tmp.46 tmp.47) (let () (cons tmp.46 tmp.47))))
    (define L.eq?.75.5
      (lambda (c.94 tmp.48 tmp.49) (let () (eq? tmp.48 tmp.49))))
    (define L.make-init-vector.1.4
      (lambda (c.93 tmp.76)
        (let ((vector-init-loop.78 (closure-ref c.93 0)))
          (let ((tmp.77 (unsafe-make-vector tmp.76)))
            (let ((tmp.125 vector-init-loop.78))
              (unsafe-apply
               L.vector-init-loop.78.3
               vector-init-loop.78
               tmp.76
               0
               tmp.77))))))
    (define L.vector-init-loop.78.3
      (lambda (c.92 len.79 i.81 vec.80)
        (let ((vector-init-loop.78 (closure-ref c.92 0)))
          (if (eq? len.79 i.81)
            vec.80
            (begin
              (unsafe-vector-set! vec.80 i.81 0)
              (let ((tmp.124 vector-init-loop.78))
                (unsafe-apply
                 L.vector-init-loop.78.3
                 vector-init-loop.78
                 len.79
                 (unsafe-fx+ i.81 1)
                 vec.80)))))))
    (define L.unsafe-vector-set!.2.2
      (lambda (c.91 tmp.87 tmp.88 tmp.89)
        (let ()
          (if (unsafe-fx< tmp.88 (unsafe-vector-length tmp.87))
            (if (unsafe-fx>= tmp.88 0)
              (begin (unsafe-vector-set! tmp.87 tmp.88 tmp.89) (void))
              (error 9))
            (error 9)))))
    (define L.unsafe-vector-ref.3.1
      (lambda (c.90 tmp.84 tmp.85)
        (let ()
          (if (unsafe-fx< tmp.85 (unsafe-vector-length tmp.84))
            (if (unsafe-fx>= tmp.85 0)
              (unsafe-vector-ref tmp.84 tmp.85)
              (error 10))
            (error 10)))))
    (cletrec
     ((unsafe-vector-ref.3 (make-closure L.unsafe-vector-ref.3.1 2))
      (unsafe-vector-set!.2 (make-closure L.unsafe-vector-set!.2.2 3))
      (vector-init-loop.78
       (make-closure L.vector-init-loop.78.3 3 vector-init-loop.78))
      (make-init-vector.1
       (make-closure L.make-init-vector.1.4 1 vector-init-loop.78))
      (eq?.75 (make-closure L.eq?.75.5 2))
      (cons.74 (make-closure L.cons.74.6 2))
      (not.73 (make-closure L.not.73.7 1))
      (vector?.72 (make-closure L.vector?.72.8 1))
      (procedure?.71 (make-closure L.procedure?.71.9 1))
      (pair?.70 (make-closure L.pair?.70.10 1))
      (error?.69 (make-closure L.error?.69.11 1))
      (ascii-char?.68 (make-closure L.ascii-char?.68.12 1))
      (void?.67 (make-closure L.void?.67.13 1))
      (empty?.66 (make-closure L.empty?.66.14 1))
      (boolean?.65 (make-closure L.boolean?.65.15 1))
      (fixnum?.64 (make-closure L.fixnum?.64.16 1))
      (procedure-arity.63 (make-closure L.procedure-arity.63.17 1))
      (cdr.62 (make-closure L.cdr.62.18 1))
      (car.61 (make-closure L.car.61.19 1))
      (vector-ref.60 (make-closure L.vector-ref.60.20 2 unsafe-vector-ref.3))
      (vector-set!.59
       (make-closure L.vector-set!.59.21 3 unsafe-vector-set!.2))
      (vector-length.58 (make-closure L.vector-length.58.22 1))
      (make-vector.57 (make-closure L.make-vector.57.23 1 make-init-vector.1))
      (>=.56 (make-closure L.>=.56.24 2))
      (>.55 (make-closure L.>.55.25 2))
      (<=.54 (make-closure L.<=.54.26 2))
      (<.53 (make-closure L.<.53.27 2))
      (|-.52| (make-closure L.-.52.28 2))
      (|+.51| (make-closure L.+.51.29 2))
      (*.50 (make-closure L.*.50.30 2)))
     (let ()
       (let ((counter!.4
              (let ((tmp.129 make-vector.57))
                (unsafe-apply L.make-vector.57.23 make-vector.57 1))))
         (cletrec
          ()
          (let ((counter!.4.9
                 (let ((x.5
                        (let ((tmp.130 make-vector.57))
                          (unsafe-apply
                           L.make-vector.57.23
                           make-vector.57
                           1))))
                   (cletrec
                    ((tmp.11
                      (make-closure
                       L.tmp.11.31
                       0
                       vector-ref.60
                       |+.51|
                       x.5
                       vector-set!.59
                       error?.69)))
                    tmp.11))))
            (let ((tmp.10
                   (let ((tmp.136 vector-set!.59))
                     (unsafe-apply
                      L.vector-set!.59.21
                      vector-set!.59
                      counter!.4
                      0
                      counter!.4.9))))
              (let ((tmp.7
                     (let ((tmp.121
                            (let ((tmp.137 vector-ref.60))
                              (unsafe-apply
                               L.vector-ref.60.20
                               vector-ref.60
                               counter!.4
                               0))))
                       (closure-apply tmp.121 tmp.121))))
                (if (let ((tmp.138 error?.69))
                      (unsafe-apply L.error?.69.11 error?.69 tmp.7))
                  tmp.7
                  (let ((tmp.8
                         (let ((tmp.122
                                (let ((tmp.139 vector-ref.60))
                                  (unsafe-apply
                                   L.vector-ref.60.20
                                   vector-ref.60
                                   counter!.4
                                   0))))
                           (closure-apply tmp.122 tmp.122))))
                    (if (let ((tmp.140 error?.69))
                          (unsafe-apply L.error?.69.11 error?.69 tmp.8))
                      tmp.8
                      (let ((tmp.123
                             (let ((tmp.141 vector-ref.60))
                               (unsafe-apply
                                L.vector-ref.60.20
                                vector-ref.60
                                counter!.4
                                0))))
                        (closure-apply tmp.123 tmp.123)))))))))))))
     ) 3)

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
     (execute '(module
    (letrec ((L.unsafe-vector-ref.3.1
              (lambda (c.90 tmp.84 tmp.85)
                (let ()
                  (if (unsafe-fx< tmp.85 (unsafe-vector-length tmp.84))
                    (if (unsafe-fx>= tmp.85 0)
                      (unsafe-vector-ref tmp.84 tmp.85)
                      (error 10))
                    (error 10)))))
             (L.unsafe-vector-set!.2.2
              (lambda (c.91 tmp.87 tmp.88 tmp.89)
                (let ()
                  (if (unsafe-fx< tmp.88 (unsafe-vector-length tmp.87))
                    (if (unsafe-fx>= tmp.88 0)
                      (begin (unsafe-vector-set! tmp.87 tmp.88 tmp.89) (void))
                      (error 9))
                    (error 9)))))
             (L.vector-init-loop.78.3
              (lambda (c.92 len.79 i.81 vec.80)
                (let ((vector-init-loop.78 (closure-ref c.92 0)))
                  (if (eq? len.79 i.81)
                    vec.80
                    (begin
                      (unsafe-vector-set! vec.80 i.81 0)
                      (let ((tmp.124 vector-init-loop.78))
                        (unsafe-apply
                         L.vector-init-loop.78.3
                         vector-init-loop.78
                         len.79
                         (unsafe-fx+ i.81 1)
                         vec.80)))))))
             (L.make-init-vector.1.4
              (lambda (c.93 tmp.76)
                (let ((vector-init-loop.78 (closure-ref c.93 0)))
                  (let ((tmp.77 (unsafe-make-vector tmp.76)))
                    (let ((tmp.125 vector-init-loop.78))
                      (unsafe-apply
                       L.vector-init-loop.78.3
                       vector-init-loop.78
                       tmp.76
                       0
                       tmp.77))))))
             (L.eq?.75.5
              (lambda (c.94 tmp.48 tmp.49) (let () (eq? tmp.48 tmp.49))))
             (L.cons.74.6
              (lambda (c.95 tmp.46 tmp.47) (let () (cons tmp.46 tmp.47))))
             (L.not.73.7 (lambda (c.96 tmp.45) (let () (not tmp.45))))
             (L.vector?.72.8 (lambda (c.97 tmp.44) (let () (vector? tmp.44))))
             (L.procedure?.71.9
              (lambda (c.98 tmp.43) (let () (procedure? tmp.43))))
             (L.pair?.70.10 (lambda (c.99 tmp.42) (let () (pair? tmp.42))))
             (L.error?.69.11 (lambda (c.100 tmp.41) (let () (error? tmp.41))))
             (L.ascii-char?.68.12
              (lambda (c.101 tmp.40) (let () (ascii-char? tmp.40))))
             (L.void?.67.13 (lambda (c.102 tmp.39) (let () (void? tmp.39))))
             (L.empty?.66.14 (lambda (c.103 tmp.38) (let () (empty? tmp.38))))
             (L.boolean?.65.15
              (lambda (c.104 tmp.37) (let () (boolean? tmp.37))))
             (L.fixnum?.64.16
              (lambda (c.105 tmp.36) (let () (fixnum? tmp.36))))
             (L.procedure-arity.63.17
              (lambda (c.106 tmp.35)
                (let ()
                  (if (procedure? tmp.35)
                    (unsafe-procedure-arity tmp.35)
                    (error 13)))))
             (L.cdr.62.18
              (lambda (c.107 tmp.34)
                (let () (if (pair? tmp.34) (unsafe-cdr tmp.34) (error 12)))))
             (L.car.61.19
              (lambda (c.108 tmp.33)
                (let () (if (pair? tmp.33) (unsafe-car tmp.33) (error 11)))))
             (L.vector-ref.60.20
              (lambda (c.109 tmp.31 tmp.32)
                (let ((unsafe-vector-ref.3 (closure-ref c.109 0)))
                  (if (fixnum? tmp.32)
                    (if (vector? tmp.31)
                      (let ((tmp.126 unsafe-vector-ref.3))
                        (unsafe-apply
                         L.unsafe-vector-ref.3.1
                         unsafe-vector-ref.3
                         tmp.31
                         tmp.32))
                      (error 10))
                    (error 10)))))
             (L.vector-set!.59.21
              (lambda (c.110 tmp.28 tmp.29 tmp.30)
                (let ((unsafe-vector-set!.2 (closure-ref c.110 0)))
                  (if (fixnum? tmp.29)
                    (if (vector? tmp.28)
                      (let ((tmp.127 unsafe-vector-set!.2))
                        (unsafe-apply
                         L.unsafe-vector-set!.2.2
                         unsafe-vector-set!.2
                         tmp.28
                         tmp.29
                         tmp.30))
                      (error 9))
                    (error 9)))))
             (L.vector-length.58.22
              (lambda (c.111 tmp.27)
                (let ()
                  (if (vector? tmp.27)
                    (unsafe-vector-length tmp.27)
                    (error 8)))))
             (L.make-vector.57.23
              (lambda (c.112 tmp.26)
                (let ((make-init-vector.1 (closure-ref c.112 0)))
                  (if (fixnum? tmp.26)
                    (let ((tmp.128 make-init-vector.1))
                      (unsafe-apply
                       L.make-init-vector.1.4
                       make-init-vector.1
                       tmp.26))
                    (error 7)))))
             (L.>=.56.24
              (lambda (c.113 tmp.24 tmp.25)
                (let ()
                  (if (fixnum? tmp.25)
                    (if (fixnum? tmp.24) (unsafe-fx>= tmp.24 tmp.25) (error 6))
                    (error 6)))))
             (L.>.55.25
              (lambda (c.114 tmp.22 tmp.23)
                (let ()
                  (if (fixnum? tmp.23)
                    (if (fixnum? tmp.22) (unsafe-fx> tmp.22 tmp.23) (error 5))
                    (error 5)))))
             (L.<=.54.26
              (lambda (c.115 tmp.20 tmp.21)
                (let ()
                  (if (fixnum? tmp.21)
                    (if (fixnum? tmp.20) (unsafe-fx<= tmp.20 tmp.21) (error 4))
                    (error 4)))))
             (L.<.53.27
              (lambda (c.116 tmp.18 tmp.19)
                (let ()
                  (if (fixnum? tmp.19)
                    (if (fixnum? tmp.18) (unsafe-fx< tmp.18 tmp.19) (error 3))
                    (error 3)))))
             (L.-.52.28
              (lambda (c.117 tmp.16 tmp.17)
                (let ()
                  (if (fixnum? tmp.17)
                    (if (fixnum? tmp.16) (unsafe-fx- tmp.16 tmp.17) (error 2))
                    (error 2)))))
             (L.+.51.29
              (lambda (c.118 tmp.14 tmp.15)
                (let ()
                  (if (fixnum? tmp.15)
                    (if (fixnum? tmp.14) (unsafe-fx+ tmp.14 tmp.15) (error 1))
                    (error 1)))))
             (L.*.50.30
              (lambda (c.119 tmp.12 tmp.13)
                (let ()
                  (if (fixnum? tmp.13)
                    (if (fixnum? tmp.12) (unsafe-fx* tmp.12 tmp.13) (error 0))
                    (error 0))))))
      (cletrec
       ((unsafe-vector-ref.3 (make-closure L.unsafe-vector-ref.3.1 2))
        (unsafe-vector-set!.2 (make-closure L.unsafe-vector-set!.2.2 3))
        (vector-init-loop.78
         (make-closure L.vector-init-loop.78.3 3 vector-init-loop.78))
        (make-init-vector.1
         (make-closure L.make-init-vector.1.4 1 vector-init-loop.78))
        (eq?.75 (make-closure L.eq?.75.5 2))
        (cons.74 (make-closure L.cons.74.6 2))
        (not.73 (make-closure L.not.73.7 1))
        (vector?.72 (make-closure L.vector?.72.8 1))
        (procedure?.71 (make-closure L.procedure?.71.9 1))
        (pair?.70 (make-closure L.pair?.70.10 1))
        (error?.69 (make-closure L.error?.69.11 1))
        (ascii-char?.68 (make-closure L.ascii-char?.68.12 1))
        (void?.67 (make-closure L.void?.67.13 1))
        (empty?.66 (make-closure L.empty?.66.14 1))
        (boolean?.65 (make-closure L.boolean?.65.15 1))
        (fixnum?.64 (make-closure L.fixnum?.64.16 1))
        (procedure-arity.63 (make-closure L.procedure-arity.63.17 1))
        (cdr.62 (make-closure L.cdr.62.18 1))
        (car.61 (make-closure L.car.61.19 1))
        (vector-ref.60 (make-closure L.vector-ref.60.20 2 unsafe-vector-ref.3))
        (vector-set!.59
         (make-closure L.vector-set!.59.21 3 unsafe-vector-set!.2))
        (vector-length.58 (make-closure L.vector-length.58.22 1))
        (make-vector.57
         (make-closure L.make-vector.57.23 1 make-init-vector.1))
        (>=.56 (make-closure L.>=.56.24 2))
        (>.55 (make-closure L.>.55.25 2))
        (<=.54 (make-closure L.<=.54.26 2))
        (<.53 (make-closure L.<.53.27 2))
        (|-.52| (make-closure L.-.52.28 2))
        (|+.51| (make-closure L.+.51.29 2))
        (*.50 (make-closure L.*.50.30 2)))
       (let ()
         (let ((counter!.4
                (let ((tmp.129 make-vector.57))
                  (unsafe-apply L.make-vector.57.23 make-vector.57 1))))
           (letrec ()
             (cletrec
              ()
              (let ((counter!.4.9
                     (let ((x.5
                            (let ((tmp.130 make-vector.57))
                              (unsafe-apply
                               L.make-vector.57.23
                               make-vector.57
                               1))))
                       (letrec ((L.tmp.11.31
                                 (lambda (c.120)
                                   (let ((vector-ref.60 (closure-ref c.120 0))
                                         (|+.51| (closure-ref c.120 1))
                                         (x.5 (closure-ref c.120 2))
                                         (vector-set!.59 (closure-ref c.120 3))
                                         (error?.69 (closure-ref c.120 4)))
                                     (let ((tmp.6
                                            (let ((tmp.131 vector-set!.59))
                                              (unsafe-apply
                                               L.vector-set!.59.21
                                               vector-set!.59
                                               x.5
                                               0
                                               (let ((tmp.132 |+.51|))
                                                 (unsafe-apply
                                                  L.+.51.29
                                                  |+.51|
                                                  1
                                                  (let ((tmp.133
                                                         vector-ref.60))
                                                    (unsafe-apply
                                                     L.vector-ref.60.20
                                                     vector-ref.60
                                                     x.5
                                                     0))))))))
                                       (if (let ((tmp.134 error?.69))
                                             (unsafe-apply
                                              L.error?.69.11
                                              error?.69
                                              tmp.6))
                                         tmp.6
                                         (let ((tmp.135 vector-ref.60))
                                           (unsafe-apply
                                            L.vector-ref.60.20
                                            vector-ref.60
                                            x.5
                                            0))))))))
                         (cletrec
                          ((tmp.11
                            (make-closure
                             L.tmp.11.31
                             0
                             vector-ref.60
                             |+.51|
                             x.5
                             vector-set!.59
                             error?.69)))
                          tmp.11)))))
                (let ((tmp.10
                       (let ((tmp.136 vector-set!.59))
                         (unsafe-apply
                          L.vector-set!.59.21
                          vector-set!.59
                          counter!.4
                          0
                          counter!.4.9))))
                  (let ((tmp.7
                         (let ((tmp.121
                                (let ((tmp.137 vector-ref.60))
                                  (unsafe-apply
                                   L.vector-ref.60.20
                                   vector-ref.60
                                   counter!.4
                                   0))))
                           (closure-apply tmp.121 tmp.121))))
                    (if (let ((tmp.138 error?.69))
                          (unsafe-apply L.error?.69.11 error?.69 tmp.7))
                      tmp.7
                      (let ((tmp.8
                             (let ((tmp.122
                                    (let ((tmp.139 vector-ref.60))
                                      (unsafe-apply
                                       L.vector-ref.60.20
                                       vector-ref.60
                                       counter!.4
                                       0))))
                               (closure-apply tmp.122 tmp.122))))
                        (if (let ((tmp.140 error?.69))
                              (unsafe-apply L.error?.69.11 error?.69 tmp.8))
                          tmp.8
                          (let ((tmp.123
                                 (let ((tmp.141 vector-ref.60))
                                   (unsafe-apply
                                    L.vector-ref.60.20
                                    vector-ref.60
                                    counter!.4
                                    0))))
                            (closure-apply tmp.123 tmp.123)))))))))))))))
     ) 3)

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
              (lambda (c.90 tmp.84 tmp.85)
                (let ()
                  (if (unsafe-fx< tmp.85 (unsafe-vector-length tmp.84))
                    (if (unsafe-fx>= tmp.85 0)
                      (unsafe-vector-ref tmp.84 tmp.85)
                      (error 10))
                    (error 10)))))
             (L.unsafe-vector-set!.2.2
              (lambda (c.91 tmp.87 tmp.88 tmp.89)
                (let ()
                  (if (unsafe-fx< tmp.88 (unsafe-vector-length tmp.87))
                    (if (unsafe-fx>= tmp.88 0)
                      (begin (unsafe-vector-set! tmp.87 tmp.88 tmp.89) (void))
                      (error 9))
                    (error 9)))))
             (L.vector-init-loop.78.3
              (lambda (c.92 len.79 i.81 vec.80)
                (let ((vector-init-loop.78 (closure-ref c.92 0)))
                  (if (eq? len.79 i.81)
                    vec.80
                    (begin
                      (unsafe-vector-set! vec.80 i.81 0)
                      (closure-apply
                       vector-init-loop.78
                       vector-init-loop.78
                       len.79
                       (unsafe-fx+ i.81 1)
                       vec.80))))))
             (L.make-init-vector.1.4
              (lambda (c.93 tmp.76)
                (let ((vector-init-loop.78 (closure-ref c.93 0)))
                  (let ((tmp.77 (unsafe-make-vector tmp.76)))
                    (closure-apply
                     vector-init-loop.78
                     vector-init-loop.78
                     tmp.76
                     0
                     tmp.77)))))
             (L.eq?.75.5
              (lambda (c.94 tmp.48 tmp.49) (let () (eq? tmp.48 tmp.49))))
             (L.cons.74.6
              (lambda (c.95 tmp.46 tmp.47) (let () (cons tmp.46 tmp.47))))
             (L.not.73.7 (lambda (c.96 tmp.45) (let () (not tmp.45))))
             (L.vector?.72.8 (lambda (c.97 tmp.44) (let () (vector? tmp.44))))
             (L.procedure?.71.9
              (lambda (c.98 tmp.43) (let () (procedure? tmp.43))))
             (L.pair?.70.10 (lambda (c.99 tmp.42) (let () (pair? tmp.42))))
             (L.error?.69.11 (lambda (c.100 tmp.41) (let () (error? tmp.41))))
             (L.ascii-char?.68.12
              (lambda (c.101 tmp.40) (let () (ascii-char? tmp.40))))
             (L.void?.67.13 (lambda (c.102 tmp.39) (let () (void? tmp.39))))
             (L.empty?.66.14 (lambda (c.103 tmp.38) (let () (empty? tmp.38))))
             (L.boolean?.65.15
              (lambda (c.104 tmp.37) (let () (boolean? tmp.37))))
             (L.fixnum?.64.16
              (lambda (c.105 tmp.36) (let () (fixnum? tmp.36))))
             (L.procedure-arity.63.17
              (lambda (c.106 tmp.35)
                (let ()
                  (if (procedure? tmp.35)
                    (unsafe-procedure-arity tmp.35)
                    (error 13)))))
             (L.cdr.62.18
              (lambda (c.107 tmp.34)
                (let () (if (pair? tmp.34) (unsafe-cdr tmp.34) (error 12)))))
             (L.car.61.19
              (lambda (c.108 tmp.33)
                (let () (if (pair? tmp.33) (unsafe-car tmp.33) (error 11)))))
             (L.vector-ref.60.20
              (lambda (c.109 tmp.31 tmp.32)
                (let ((unsafe-vector-ref.3 (closure-ref c.109 0)))
                  (if (fixnum? tmp.32)
                    (if (vector? tmp.31)
                      (closure-apply
                       unsafe-vector-ref.3
                       unsafe-vector-ref.3
                       tmp.31
                       tmp.32)
                      (error 10))
                    (error 10)))))
             (L.vector-set!.59.21
              (lambda (c.110 tmp.28 tmp.29 tmp.30)
                (let ((unsafe-vector-set!.2 (closure-ref c.110 0)))
                  (if (fixnum? tmp.29)
                    (if (vector? tmp.28)
                      (closure-apply
                       unsafe-vector-set!.2
                       unsafe-vector-set!.2
                       tmp.28
                       tmp.29
                       tmp.30)
                      (error 9))
                    (error 9)))))
             (L.vector-length.58.22
              (lambda (c.111 tmp.27)
                (let ()
                  (if (vector? tmp.27)
                    (unsafe-vector-length tmp.27)
                    (error 8)))))
             (L.make-vector.57.23
              (lambda (c.112 tmp.26)
                (let ((make-init-vector.1 (closure-ref c.112 0)))
                  (if (fixnum? tmp.26)
                    (closure-apply
                     make-init-vector.1
                     make-init-vector.1
                     tmp.26)
                    (error 7)))))
             (L.>=.56.24
              (lambda (c.113 tmp.24 tmp.25)
                (let ()
                  (if (fixnum? tmp.25)
                    (if (fixnum? tmp.24) (unsafe-fx>= tmp.24 tmp.25) (error 6))
                    (error 6)))))
             (L.>.55.25
              (lambda (c.114 tmp.22 tmp.23)
                (let ()
                  (if (fixnum? tmp.23)
                    (if (fixnum? tmp.22) (unsafe-fx> tmp.22 tmp.23) (error 5))
                    (error 5)))))
             (L.<=.54.26
              (lambda (c.115 tmp.20 tmp.21)
                (let ()
                  (if (fixnum? tmp.21)
                    (if (fixnum? tmp.20) (unsafe-fx<= tmp.20 tmp.21) (error 4))
                    (error 4)))))
             (L.<.53.27
              (lambda (c.116 tmp.18 tmp.19)
                (let ()
                  (if (fixnum? tmp.19)
                    (if (fixnum? tmp.18) (unsafe-fx< tmp.18 tmp.19) (error 3))
                    (error 3)))))
             (L.-.52.28
              (lambda (c.117 tmp.16 tmp.17)
                (let ()
                  (if (fixnum? tmp.17)
                    (if (fixnum? tmp.16) (unsafe-fx- tmp.16 tmp.17) (error 2))
                    (error 2)))))
             (L.+.51.29
              (lambda (c.118 tmp.14 tmp.15)
                (let ()
                  (if (fixnum? tmp.15)
                    (if (fixnum? tmp.14) (unsafe-fx+ tmp.14 tmp.15) (error 1))
                    (error 1)))))
             (L.*.50.30
              (lambda (c.119 tmp.12 tmp.13)
                (let ()
                  (if (fixnum? tmp.13)
                    (if (fixnum? tmp.12) (unsafe-fx* tmp.12 tmp.13) (error 0))
                    (error 0))))))
      (cletrec
       ((unsafe-vector-ref.3 (make-closure L.unsafe-vector-ref.3.1 2))
        (unsafe-vector-set!.2 (make-closure L.unsafe-vector-set!.2.2 3))
        (vector-init-loop.78
         (make-closure L.vector-init-loop.78.3 3 vector-init-loop.78))
        (make-init-vector.1
         (make-closure L.make-init-vector.1.4 1 vector-init-loop.78))
        (eq?.75 (make-closure L.eq?.75.5 2))
        (cons.74 (make-closure L.cons.74.6 2))
        (not.73 (make-closure L.not.73.7 1))
        (vector?.72 (make-closure L.vector?.72.8 1))
        (procedure?.71 (make-closure L.procedure?.71.9 1))
        (pair?.70 (make-closure L.pair?.70.10 1))
        (error?.69 (make-closure L.error?.69.11 1))
        (ascii-char?.68 (make-closure L.ascii-char?.68.12 1))
        (void?.67 (make-closure L.void?.67.13 1))
        (empty?.66 (make-closure L.empty?.66.14 1))
        (boolean?.65 (make-closure L.boolean?.65.15 1))
        (fixnum?.64 (make-closure L.fixnum?.64.16 1))
        (procedure-arity.63 (make-closure L.procedure-arity.63.17 1))
        (cdr.62 (make-closure L.cdr.62.18 1))
        (car.61 (make-closure L.car.61.19 1))
        (vector-ref.60 (make-closure L.vector-ref.60.20 2 unsafe-vector-ref.3))
        (vector-set!.59
         (make-closure L.vector-set!.59.21 3 unsafe-vector-set!.2))
        (vector-length.58 (make-closure L.vector-length.58.22 1))
        (make-vector.57
         (make-closure L.make-vector.57.23 1 make-init-vector.1))
        (>=.56 (make-closure L.>=.56.24 2))
        (>.55 (make-closure L.>.55.25 2))
        (<=.54 (make-closure L.<=.54.26 2))
        (<.53 (make-closure L.<.53.27 2))
        (|-.52| (make-closure L.-.52.28 2))
        (|+.51| (make-closure L.+.51.29 2))
        (*.50 (make-closure L.*.50.30 2)))
       (let ()
         (let ((counter!.4 (closure-apply make-vector.57 make-vector.57 1)))
           (letrec ()
             (cletrec
              ()
              (let ((counter!.4.9
                     (let ((x.5
                            (closure-apply make-vector.57 make-vector.57 1)))
                       (letrec ((L.tmp.11.31
                                 (lambda (c.120)
                                   (let ((vector-ref.60 (closure-ref c.120 0))
                                         (|+.51| (closure-ref c.120 1))
                                         (x.5 (closure-ref c.120 2))
                                         (vector-set!.59 (closure-ref c.120 3))
                                         (error?.69 (closure-ref c.120 4)))
                                     (let ((tmp.6
                                            (closure-apply
                                             vector-set!.59
                                             vector-set!.59
                                             x.5
                                             0
                                             (closure-apply
                                              |+.51|
                                              |+.51|
                                              1
                                              (closure-apply
                                               vector-ref.60
                                               vector-ref.60
                                               x.5
                                               0)))))
                                       (if (closure-apply
                                            error?.69
                                            error?.69
                                            tmp.6)
                                         tmp.6
                                         (closure-apply
                                          vector-ref.60
                                          vector-ref.60
                                          x.5
                                          0)))))))
                         (cletrec
                          ((tmp.11
                            (make-closure
                             L.tmp.11.31
                             0
                             vector-ref.60
                             |+.51|
                             x.5
                             vector-set!.59
                             error?.69)))
                          tmp.11)))))
                (let ((tmp.10
                       (closure-apply
                        vector-set!.59
                        vector-set!.59
                        counter!.4
                        0
                        counter!.4.9)))
                  (let ((tmp.7
                         (let ((tmp.121
                                (closure-apply
                                 vector-ref.60
                                 vector-ref.60
                                 counter!.4
                                 0)))
                           (closure-apply tmp.121 tmp.121))))
                    (if (closure-apply error?.69 error?.69 tmp.7)
                      tmp.7
                      (let ((tmp.8
                             (let ((tmp.122
                                    (closure-apply
                                     vector-ref.60
                                     vector-ref.60
                                     counter!.4
                                     0)))
                               (closure-apply tmp.122 tmp.122))))
                        (if (closure-apply error?.69 error?.69 tmp.8)
                          tmp.8
                          (let ((tmp.123
                                 (closure-apply
                                  vector-ref.60
                                  vector-ref.60
                                  counter!.4
                                  0)))
                            (closure-apply tmp.123 tmp.123)))))))))))))))
     ) 3)

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
              (lambda (tmp.84 tmp.85)
                (free ())
                (if (unsafe-fx< tmp.85 (unsafe-vector-length tmp.84))
                  (if (unsafe-fx>= tmp.85 0)
                    (unsafe-vector-ref tmp.84 tmp.85)
                    (error 10))
                  (error 10))))
             (unsafe-vector-set!.2
              (lambda (tmp.87 tmp.88 tmp.89)
                (free ())
                (if (unsafe-fx< tmp.88 (unsafe-vector-length tmp.87))
                  (if (unsafe-fx>= tmp.88 0)
                    (begin (unsafe-vector-set! tmp.87 tmp.88 tmp.89) (void))
                    (error 9))
                  (error 9))))
             (vector-init-loop.78
              (lambda (len.79 i.81 vec.80)
                (free (vector-init-loop.78))
                (if (eq? len.79 i.81)
                  vec.80
                  (begin
                    (unsafe-vector-set! vec.80 i.81 0)
                    (apply
                     vector-init-loop.78
                     len.79
                     (unsafe-fx+ i.81 1)
                     vec.80)))))
             (make-init-vector.1
              (lambda (tmp.76)
                (free (vector-init-loop.78))
                (let ((tmp.77 (unsafe-make-vector tmp.76)))
                  (apply vector-init-loop.78 tmp.76 0 tmp.77))))
             (eq?.75 (lambda (tmp.48 tmp.49) (free ()) (eq? tmp.48 tmp.49)))
             (cons.74 (lambda (tmp.46 tmp.47) (free ()) (cons tmp.46 tmp.47)))
             (not.73 (lambda (tmp.45) (free ()) (not tmp.45)))
             (vector?.72 (lambda (tmp.44) (free ()) (vector? tmp.44)))
             (procedure?.71 (lambda (tmp.43) (free ()) (procedure? tmp.43)))
             (pair?.70 (lambda (tmp.42) (free ()) (pair? tmp.42)))
             (error?.69 (lambda (tmp.41) (free ()) (error? tmp.41)))
             (ascii-char?.68 (lambda (tmp.40) (free ()) (ascii-char? tmp.40)))
             (void?.67 (lambda (tmp.39) (free ()) (void? tmp.39)))
             (empty?.66 (lambda (tmp.38) (free ()) (empty? tmp.38)))
             (boolean?.65 (lambda (tmp.37) (free ()) (boolean? tmp.37)))
             (fixnum?.64 (lambda (tmp.36) (free ()) (fixnum? tmp.36)))
             (procedure-arity.63
              (lambda (tmp.35)
                (free ())
                (if (procedure? tmp.35)
                  (unsafe-procedure-arity tmp.35)
                  (error 13))))
             (cdr.62
              (lambda (tmp.34)
                (free ())
                (if (pair? tmp.34) (unsafe-cdr tmp.34) (error 12))))
             (car.61
              (lambda (tmp.33)
                (free ())
                (if (pair? tmp.33) (unsafe-car tmp.33) (error 11))))
             (vector-ref.60
              (lambda (tmp.31 tmp.32)
                (free (unsafe-vector-ref.3))
                (if (fixnum? tmp.32)
                  (if (vector? tmp.31)
                    (apply unsafe-vector-ref.3 tmp.31 tmp.32)
                    (error 10))
                  (error 10))))
             (vector-set!.59
              (lambda (tmp.28 tmp.29 tmp.30)
                (free (unsafe-vector-set!.2))
                (if (fixnum? tmp.29)
                  (if (vector? tmp.28)
                    (apply unsafe-vector-set!.2 tmp.28 tmp.29 tmp.30)
                    (error 9))
                  (error 9))))
             (vector-length.58
              (lambda (tmp.27)
                (free ())
                (if (vector? tmp.27) (unsafe-vector-length tmp.27) (error 8))))
             (make-vector.57
              (lambda (tmp.26)
                (free (make-init-vector.1))
                (if (fixnum? tmp.26)
                  (apply make-init-vector.1 tmp.26)
                  (error 7))))
             (>=.56
              (lambda (tmp.24 tmp.25)
                (free ())
                (if (fixnum? tmp.25)
                  (if (fixnum? tmp.24) (unsafe-fx>= tmp.24 tmp.25) (error 6))
                  (error 6))))
             (>.55
              (lambda (tmp.22 tmp.23)
                (free ())
                (if (fixnum? tmp.23)
                  (if (fixnum? tmp.22) (unsafe-fx> tmp.22 tmp.23) (error 5))
                  (error 5))))
             (<=.54
              (lambda (tmp.20 tmp.21)
                (free ())
                (if (fixnum? tmp.21)
                  (if (fixnum? tmp.20) (unsafe-fx<= tmp.20 tmp.21) (error 4))
                  (error 4))))
             (<.53
              (lambda (tmp.18 tmp.19)
                (free ())
                (if (fixnum? tmp.19)
                  (if (fixnum? tmp.18) (unsafe-fx< tmp.18 tmp.19) (error 3))
                  (error 3))))
             (|-.52|
              (lambda (tmp.16 tmp.17)
                (free ())
                (if (fixnum? tmp.17)
                  (if (fixnum? tmp.16) (unsafe-fx- tmp.16 tmp.17) (error 2))
                  (error 2))))
             (|+.51|
              (lambda (tmp.14 tmp.15)
                (free ())
                (if (fixnum? tmp.15)
                  (if (fixnum? tmp.14) (unsafe-fx+ tmp.14 tmp.15) (error 1))
                  (error 1))))
             (*.50
              (lambda (tmp.12 tmp.13)
                (free ())
                (if (fixnum? tmp.13)
                  (if (fixnum? tmp.12) (unsafe-fx* tmp.12 tmp.13) (error 0))
                  (error 0)))))
      (let ()
        (let ((counter!.4 (apply make-vector.57 1)))
          (letrec ()
            (let ((counter!.4.9
                   (let ((x.5 (apply make-vector.57 1)))
                     (letrec ((tmp.11
                               (lambda ()
                                 (free
                                  (vector-ref.60
                                   |+.51|
                                   x.5
                                   vector-set!.59
                                   error?.69))
                                 (let ((tmp.6
                                        (apply
                                         vector-set!.59
                                         x.5
                                         0
                                         (apply
                                          |+.51|
                                          1
                                          (apply vector-ref.60 x.5 0)))))
                                   (if (apply error?.69 tmp.6)
                                     tmp.6
                                     (apply vector-ref.60 x.5 0))))))
                       tmp.11))))
              (let ((tmp.10 (apply vector-set!.59 counter!.4 0 counter!.4.9)))
                (let ((tmp.7 (apply (apply vector-ref.60 counter!.4 0))))
                  (if (apply error?.69 tmp.7)
                    tmp.7
                    (let ((tmp.8 (apply (apply vector-ref.60 counter!.4 0))))
                      (if (apply error?.69 tmp.8)
                        tmp.8
                        (apply (apply vector-ref.60 counter!.4 0)))))))))))))
     ) 3))

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
              (lambda (tmp.84 tmp.85)
                (if (unsafe-fx< tmp.85 (unsafe-vector-length tmp.84))
                  (if (unsafe-fx>= tmp.85 0)
                    (unsafe-vector-ref tmp.84 tmp.85)
                    (error 10))
                  (error 10))))
             (unsafe-vector-set!.2
              (lambda (tmp.87 tmp.88 tmp.89)
                (if (unsafe-fx< tmp.88 (unsafe-vector-length tmp.87))
                  (if (unsafe-fx>= tmp.88 0)
                    (begin (unsafe-vector-set! tmp.87 tmp.88 tmp.89) (void))
                    (error 9))
                  (error 9))))
             (vector-init-loop.78
              (lambda (len.79 i.81 vec.80)
                (if (eq? len.79 i.81)
                  vec.80
                  (begin
                    (unsafe-vector-set! vec.80 i.81 0)
                    (apply
                     vector-init-loop.78
                     len.79
                     (unsafe-fx+ i.81 1)
                     vec.80)))))
             (make-init-vector.1
              (lambda (tmp.76)
                (let ((tmp.77 (unsafe-make-vector tmp.76)))
                  (apply vector-init-loop.78 tmp.76 0 tmp.77))))
             (eq?.75 (lambda (tmp.48 tmp.49) (eq? tmp.48 tmp.49)))
             (cons.74 (lambda (tmp.46 tmp.47) (cons tmp.46 tmp.47)))
             (not.73 (lambda (tmp.45) (not tmp.45)))
             (vector?.72 (lambda (tmp.44) (vector? tmp.44)))
             (procedure?.71 (lambda (tmp.43) (procedure? tmp.43)))
             (pair?.70 (lambda (tmp.42) (pair? tmp.42)))
             (error?.69 (lambda (tmp.41) (error? tmp.41)))
             (ascii-char?.68 (lambda (tmp.40) (ascii-char? tmp.40)))
             (void?.67 (lambda (tmp.39) (void? tmp.39)))
             (empty?.66 (lambda (tmp.38) (empty? tmp.38)))
             (boolean?.65 (lambda (tmp.37) (boolean? tmp.37)))
             (fixnum?.64 (lambda (tmp.36) (fixnum? tmp.36)))
             (procedure-arity.63
              (lambda (tmp.35)
                (if (procedure? tmp.35)
                  (unsafe-procedure-arity tmp.35)
                  (error 13))))
             (cdr.62
              (lambda (tmp.34)
                (if (pair? tmp.34) (unsafe-cdr tmp.34) (error 12))))
             (car.61
              (lambda (tmp.33)
                (if (pair? tmp.33) (unsafe-car tmp.33) (error 11))))
             (vector-ref.60
              (lambda (tmp.31 tmp.32)
                (if (fixnum? tmp.32)
                  (if (vector? tmp.31)
                    (apply unsafe-vector-ref.3 tmp.31 tmp.32)
                    (error 10))
                  (error 10))))
             (vector-set!.59
              (lambda (tmp.28 tmp.29 tmp.30)
                (if (fixnum? tmp.29)
                  (if (vector? tmp.28)
                    (apply unsafe-vector-set!.2 tmp.28 tmp.29 tmp.30)
                    (error 9))
                  (error 9))))
             (vector-length.58
              (lambda (tmp.27)
                (if (vector? tmp.27) (unsafe-vector-length tmp.27) (error 8))))
             (make-vector.57
              (lambda (tmp.26)
                (if (fixnum? tmp.26)
                  (apply make-init-vector.1 tmp.26)
                  (error 7))))
             (>=.56
              (lambda (tmp.24 tmp.25)
                (if (fixnum? tmp.25)
                  (if (fixnum? tmp.24) (unsafe-fx>= tmp.24 tmp.25) (error 6))
                  (error 6))))
             (>.55
              (lambda (tmp.22 tmp.23)
                (if (fixnum? tmp.23)
                  (if (fixnum? tmp.22) (unsafe-fx> tmp.22 tmp.23) (error 5))
                  (error 5))))
             (<=.54
              (lambda (tmp.20 tmp.21)
                (if (fixnum? tmp.21)
                  (if (fixnum? tmp.20) (unsafe-fx<= tmp.20 tmp.21) (error 4))
                  (error 4))))
             (<.53
              (lambda (tmp.18 tmp.19)
                (if (fixnum? tmp.19)
                  (if (fixnum? tmp.18) (unsafe-fx< tmp.18 tmp.19) (error 3))
                  (error 3))))
             (|-.52|
              (lambda (tmp.16 tmp.17)
                (if (fixnum? tmp.17)
                  (if (fixnum? tmp.16) (unsafe-fx- tmp.16 tmp.17) (error 2))
                  (error 2))))
             (|+.51|
              (lambda (tmp.14 tmp.15)
                (if (fixnum? tmp.15)
                  (if (fixnum? tmp.14) (unsafe-fx+ tmp.14 tmp.15) (error 1))
                  (error 1))))
             (*.50
              (lambda (tmp.12 tmp.13)
                (if (fixnum? tmp.13)
                  (if (fixnum? tmp.12) (unsafe-fx* tmp.12 tmp.13) (error 0))
                  (error 0)))))
      (let ()
        (let ((counter!.4 (apply make-vector.57 1)))
          (letrec ()
            (let ((counter!.4.9
                   (let ((x.5 (apply make-vector.57 1)))
                     (letrec ((tmp.11
                               (lambda ()
                                 (let ((tmp.6
                                        (apply
                                         vector-set!.59
                                         x.5
                                         0
                                         (apply
                                          |+.51|
                                          1
                                          (apply vector-ref.60 x.5 0)))))
                                   (if (apply error?.69 tmp.6)
                                     tmp.6
                                     (apply vector-ref.60 x.5 0))))))
                       tmp.11))))
              (let ((tmp.10 (apply vector-set!.59 counter!.4 0 counter!.4.9)))
                (let ((tmp.7 (apply (apply vector-ref.60 counter!.4 0))))
                  (if (apply error?.69 tmp.7)
                    tmp.7
                    (let ((tmp.8 (apply (apply vector-ref.60 counter!.4 0))))
                      (if (apply error?.69 tmp.8)
                        tmp.8
                        (apply (apply vector-ref.60 counter!.4 0)))))))))))))
     ) 3))



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
                      (apply (apply vector-ref counter!.4 0))))))))))))
     ) 3)

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
    (define counter!
      (let ((x (make-vector 1)))
        (lambda ()
          (begin (vector-set! x 0 (+ 1 (vector-ref x 0))) (vector-ref x 0)))))
    (begin (counter!) (counter!) (counter!)))
     ) 3)

  )
  
  )