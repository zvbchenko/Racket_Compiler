#lang racket

(require 
  "a8-bosco.rkt"
  "a8-compiler-lib.rkt")

(module+ test
  (require rackunit))

; Exercise 5
(module+ test
  (check-equal? (expose-allocation-pointer
                 '(module
                      (define L.main.1
                        ((new-frames ()))
                        (if (< 12 3)
                            (begin
                              (set! ra.1 r15)
                              (return-point L.rp.1
                                (begin (set! rdi a.2) 
                                      (set! r15 L.rp.1) 
                                      (jump L.start.1 rbp r15 rdi)))
                              (set! x.1 (alloc 8))
                              (jump ra.1 rbp))
                            (jump ra.1 rbp)))))
                '(module
                    (define L.main.1
                      ((new-frames ()))
                      (if (< 12 3)
                          (begin
                            (set! ra.1 r15)
                            (return-point L.rp.1
                              (begin (set! rdi a.2) 
                                    (set! r15 L.rp.1) 
                                    (jump L.start.1 rbp r15 rdi)))
                            (set! x.1 r12)
                            (set! r12 (+ r12 8))
                            (jump ra.1 rbp))
                          (jump ra.1 rbp)))))
  )

; Exercise 7
(module+ test
  (check-equal? (a-normalize
                 '(module
                      (define L.unsafe-vector-ref.3
                        (lambda (tmp.44 tmp.45)
                          (if (neq? (if (< tmp.45 (mref tmp.44 -3)) 14 6) 6)
                              (if (neq? (if (>= tmp.45 0) 14 6) 6)
                                  (mref tmp.44 (+ (* (arithmetic-shift-right tmp.45 3) 8) 5))
                                  2622)
                              2622)))
                    (define L.unsafe-vector-set!.2
                      (lambda (tmp.44 tmp.45 tmp.46)
                        (if (neq? (if (< tmp.45 (mref tmp.44 -3)) 14 6) 6)
                            (if (neq? (if (>= tmp.45 0) 14 6) 6)
                                (begin
                                  (mset! tmp.44 (+ (* (arithmetic-shift-right tmp.45 3) 8) 5) tmp.46)
                                  tmp.44)
                                2366)
                            2366)))
                    (define L.vector-init-loop.30
                      (lambda (len.41 i.43 vec.42)
                        (if (neq? (if (eq? len.41 i.43) 14 6) 6)
                            vec.42
                            (begin
                              (mset! vec.42 (+ (* (arithmetic-shift-right i.43 3) 8) 5) 0)
                              (apply L.vector-init-loop.30 len.41 (+ i.43 8) vec.42)))))
                    (define L.make-init-vector.1
                      (lambda (tmp.39)
                        (let ((tmp.40
                               (let ((tmp.49
                                      (+
                                       (alloc (* (+ 1 (arithmetic-shift-right tmp.39 3)) 8))
                                       3)))
                                 (begin (mset! tmp.49 -3 tmp.39) tmp.49))))
                          (apply L.vector-init-loop.30 tmp.39 0 tmp.40))))
                    (define L.eq?.29 (lambda (tmp.37 tmp.38) (if (eq? tmp.37 tmp.38) 14 6)))
                    (define L.cons.28
                      (lambda (tmp.35 tmp.36)
                        (let ((tmp.50 (+ (alloc 16) 1)))
                          (begin (mset! tmp.50 -1 tmp.35) (mset! tmp.50 7 tmp.36) tmp.50))))
                    (define L.not.27 (lambda (tmp.34) (if (neq? tmp.34 14) 14 6)))
                    (define L.vector?.26
                      (lambda (tmp.33) (if (eq? (bitwise-and tmp.33 7) 3) 14 6)))
                    (define L.procedure?.25
                      (lambda (tmp.32) (if (eq? (bitwise-and tmp.32 7) 2) 14 6)))
                    (define L.pair?.24
                      (lambda (tmp.31) (if (eq? (bitwise-and tmp.31 7) 1) 14 6)))
                    (define L.error?.23
                      (lambda (tmp.30) (if (eq? (bitwise-and tmp.30 255) 62) 14 6)))
                    (define L.ascii-char?.22
                      (lambda (tmp.29) (if (eq? (bitwise-and tmp.29 255) 46) 14 6)))
                    (define L.void?.21
                      (lambda (tmp.28) (if (eq? (bitwise-and tmp.28 255) 30) 14 6)))
                    (define L.empty?.20
                      (lambda (tmp.27) (if (eq? (bitwise-and tmp.27 255) 22) 14 6)))
                    (define L.boolean?.19
                      (lambda (tmp.26) (if (eq? (bitwise-and tmp.26 247) 6) 14 6)))
                    (define L.fixnum?.18
                      (lambda (tmp.25) (if (eq? (bitwise-and tmp.25 7) 0) 14 6)))
                    (define L.procedure-arity.17
                      (lambda (tmp.24)
                        (if (neq? (if (eq? (bitwise-and tmp.24 7) 2) 14 6) 6)
                            (mref tmp.24 6)
                            3390)))
                    (define L.cdr.16
                      (lambda (tmp.23)
                        (if (neq? (if (eq? (bitwise-and tmp.23 7) 1) 14 6) 6)
                            (mref tmp.23 7)
                            3134)))
                    (define L.car.15
                      (lambda (tmp.22)
                        (if (neq? (if (eq? (bitwise-and tmp.22 7) 1) 14 6) 6)
                            (mref tmp.22 -1)
                            2878)))
                    (define L.vector-ref.14
                      (lambda (tmp.20 tmp.21)
                        (if (neq? (if (eq? (bitwise-and tmp.21 7) 0) 14 6) 6)
                            (if (neq? (if (eq? (bitwise-and tmp.20 7) 3) 14 6) 6)
                                (apply L.unsafe-vector-ref.3 tmp.20 tmp.21)
                                2622)
                            2622)))
                    (define L.vector-set!.13
                      (lambda (tmp.17 tmp.18 tmp.19)
                        (if (neq? (if (eq? (bitwise-and tmp.18 7) 0) 14 6) 6)
                            (if (neq? (if (eq? (bitwise-and tmp.17 7) 3) 14 6) 6)
                                (apply L.unsafe-vector-set!.2 tmp.17 tmp.18 tmp.19)
                                2366)
                            2366)))
                    (define L.vector-length.12
                      (lambda (tmp.16)
                        (if (neq? (if (eq? (bitwise-and tmp.16 7) 3) 14 6) 6)
                            (mref tmp.16 -3)
                            2110)))
                    (define L.make-vector.11
                      (lambda (tmp.15)
                        (if (neq? (if (eq? (bitwise-and tmp.15 7) 0) 14 6) 6)
                            (apply L.make-init-vector.1 tmp.15)
                            1854)))
                    (define L.>=.10
                      (lambda (tmp.13 tmp.14)
                        (if (neq? (if (eq? (bitwise-and tmp.14 7) 0) 14 6) 6)
                            (if (neq? (if (eq? (bitwise-and tmp.13 7) 0) 14 6) 6)
                                (if (>= tmp.13 tmp.14) 14 6)
                                1598)
                            1598)))
                    (define L.>.9
                      (lambda (tmp.11 tmp.12)
                        (if (neq? (if (eq? (bitwise-and tmp.12 7) 0) 14 6) 6)
                            (if (neq? (if (eq? (bitwise-and tmp.11 7) 0) 14 6) 6)
                                (if (> tmp.11 tmp.12) 14 6)
                                1342)
                            1342)))
                    (define L.<=.8
                      (lambda (tmp.9 tmp.10)
                        (if (neq? (if (eq? (bitwise-and tmp.10 7) 0) 14 6) 6)
                            (if (neq? (if (eq? (bitwise-and tmp.9 7) 0) 14 6) 6)
                                (if (<= tmp.9 tmp.10) 14 6)
                                1086)
                            1086)))
                    (define L.<.7
                      (lambda (tmp.7 tmp.8)
                        (if (neq? (if (eq? (bitwise-and tmp.8 7) 0) 14 6) 6)
                            (if (neq? (if (eq? (bitwise-and tmp.7 7) 0) 14 6) 6)
                                (if (< tmp.7 tmp.8) 14 6)
                                830)
                            830)))
                    (define L.-.6
                      (lambda (tmp.5 tmp.6)
                        (if (neq? (if (eq? (bitwise-and tmp.6 7) 0) 14 6) 6)
                            (if (neq? (if (eq? (bitwise-and tmp.5 7) 0) 14 6) 6)
                                (- tmp.5 tmp.6)
                                574)
                            574)))
                    (define L.+.5
                      (lambda (tmp.3 tmp.4)
                        (if (neq? (if (eq? (bitwise-and tmp.4 7) 0) 14 6) 6)
                            (if (neq? (if (eq? (bitwise-and tmp.3 7) 0) 14 6) 6)
                                (+ tmp.3 tmp.4)
                                318)
                            318)))
                    (define L.*.4
                      (lambda (tmp.1 tmp.2)
                        (if (neq? (if (eq? (bitwise-and tmp.2 7) 0) 14 6) 6)
                            (if (neq? (if (eq? (bitwise-and tmp.1 7) 0) 14 6) 6)
                                (* tmp.1 (arithmetic-shift-right tmp.2 3))
                                62)
                            62)))
                    24878))
                '(module
                  (define L.unsafe-vector-ref.3
                    (lambda (tmp.44 tmp.45)
                      (let ((tmp.1 (mref tmp.44 -3)))
                        (if (< tmp.45 tmp.1)
                          (if (neq? 14 6)
                            (if (>= tmp.45 0)
                              (if (neq? 14 6)
                                (let ((tmp.2 (arithmetic-shift-right tmp.45 3)))
                                  (let ((tmp.3 (* tmp.2 8)))
                                    (let ((tmp.4 (+ tmp.3 5))) (mref tmp.44 tmp.4))))
                                2622)
                              (if (neq? 6 6)
                                (let ((tmp.5 (arithmetic-shift-right tmp.45 3)))
                                  (let ((tmp.6 (* tmp.5 8)))
                                    (let ((tmp.7 (+ tmp.6 5))) (mref tmp.44 tmp.7))))
                                2622))
                            2622)
                          (if (neq? 6 6)
                            (if (>= tmp.45 0)
                              (if (neq? 14 6)
                                (let ((tmp.8 (arithmetic-shift-right tmp.45 3)))
                                  (let ((tmp.9 (* tmp.8 8)))
                                    (let ((tmp.10 (+ tmp.9 5))) (mref tmp.44 tmp.10))))
                                2622)
                              (if (neq? 6 6)
                                (let ((tmp.11 (arithmetic-shift-right tmp.45 3)))
                                  (let ((tmp.12 (* tmp.11 8)))
                                    (let ((tmp.13 (+ tmp.12 5))) (mref tmp.44 tmp.13))))
                                2622))
                            2622)))))
                  (define L.unsafe-vector-set!.2
                    (lambda (tmp.44 tmp.45 tmp.46)
                      (let ((tmp.14 (mref tmp.44 -3)))
                        (if (< tmp.45 tmp.14)
                          (if (neq? 14 6)
                            (if (>= tmp.45 0)
                              (if (neq? 14 6)
                                (let ((tmp.15 (arithmetic-shift-right tmp.45 3)))
                                  (let ((tmp.16 (* tmp.15 8)))
                                    (let ((tmp.17 (+ tmp.16 5)))
                                      (begin (mset! tmp.44 tmp.17 tmp.46) tmp.44))))
                                2366)
                              (if (neq? 6 6)
                                (let ((tmp.18 (arithmetic-shift-right tmp.45 3)))
                                  (let ((tmp.19 (* tmp.18 8)))
                                    (let ((tmp.20 (+ tmp.19 5)))
                                      (begin (mset! tmp.44 tmp.20 tmp.46) tmp.44))))
                                2366))
                            2366)
                          (if (neq? 6 6)
                            (if (>= tmp.45 0)
                              (if (neq? 14 6)
                                (let ((tmp.21 (arithmetic-shift-right tmp.45 3)))
                                  (let ((tmp.22 (* tmp.21 8)))
                                    (let ((tmp.23 (+ tmp.22 5)))
                                      (begin (mset! tmp.44 tmp.23 tmp.46) tmp.44))))
                                2366)
                              (if (neq? 6 6)
                                (let ((tmp.24 (arithmetic-shift-right tmp.45 3)))
                                  (let ((tmp.25 (* tmp.24 8)))
                                    (let ((tmp.26 (+ tmp.25 5)))
                                      (begin (mset! tmp.44 tmp.26 tmp.46) tmp.44))))
                                2366))
                            2366)))))
                  (define L.vector-init-loop.30
                    (lambda (len.41 i.43 vec.42)
                      (if (eq? len.41 i.43)
                        (if (neq? 14 6)
                          vec.42
                          (let ((tmp.27 (arithmetic-shift-right i.43 3)))
                            (let ((tmp.28 (* tmp.27 8)))
                              (let ((tmp.29 (+ tmp.28 5)))
                                (begin
                                  (mset! vec.42 tmp.29 0)
                                  (let ((tmp.30 (+ i.43 8)))
                                    (apply L.vector-init-loop.30 len.41 tmp.30 vec.42)))))))
                        (if (neq? 6 6)
                          vec.42
                          (let ((tmp.31 (arithmetic-shift-right i.43 3)))
                            (let ((tmp.32 (* tmp.31 8)))
                              (let ((tmp.33 (+ tmp.32 5)))
                                (begin
                                  (mset! vec.42 tmp.33 0)
                                  (let ((tmp.34 (+ i.43 8)))
                                    (apply
                                      L.vector-init-loop.30
                                      len.41
                                      tmp.34
                                      vec.42))))))))))
                  (define L.make-init-vector.1
                    (lambda (tmp.39)
                      (let ((tmp.35 (arithmetic-shift-right tmp.39 3)))
                        (let ((tmp.36 (+ 1 tmp.35)))
                          (let ((tmp.37 (* tmp.36 8)))
                            (let ((tmp.38 (alloc tmp.37)))
                              (let ((tmp.49 (+ tmp.38 3)))
                                (begin
                                  (mset! tmp.49 -3 tmp.39)
                                  (let ((tmp.40 tmp.49))
                                    (apply L.vector-init-loop.30 tmp.39 0 tmp.40))))))))))
                  (define L.eq?.29 (lambda (tmp.37 tmp.38) (if (eq? tmp.37 tmp.38) 14 6)))
                  (define L.cons.28
                    (lambda (tmp.35 tmp.36)
                      (let ((tmp.39 (alloc 16)))
                        (let ((tmp.50 (+ tmp.39 1)))
                          (begin
                            (mset! tmp.50 -1 tmp.35)
                            (begin (mset! tmp.50 7 tmp.36) tmp.50))))))
                  (define L.not.27 (lambda (tmp.34) (if (neq? tmp.34 14) 14 6)))
                  (define L.vector?.26
                    (lambda (tmp.33)
                      (let ((tmp.40 (bitwise-and tmp.33 7))) (if (eq? tmp.40 3) 14 6))))
                  (define L.procedure?.25
                    (lambda (tmp.32)
                      (let ((tmp.41 (bitwise-and tmp.32 7))) (if (eq? tmp.41 2) 14 6))))
                  (define L.pair?.24
                    (lambda (tmp.31)
                      (let ((tmp.42 (bitwise-and tmp.31 7))) (if (eq? tmp.42 1) 14 6))))
                  (define L.error?.23
                    (lambda (tmp.30)
                      (let ((tmp.43 (bitwise-and tmp.30 255))) (if (eq? tmp.43 62) 14 6))))
                  (define L.ascii-char?.22
                    (lambda (tmp.29)
                      (let ((tmp.44 (bitwise-and tmp.29 255))) (if (eq? tmp.44 46) 14 6))))
                  (define L.void?.21
                    (lambda (tmp.28)
                      (let ((tmp.45 (bitwise-and tmp.28 255))) (if (eq? tmp.45 30) 14 6))))
                  (define L.empty?.20
                    (lambda (tmp.27)
                      (let ((tmp.46 (bitwise-and tmp.27 255))) (if (eq? tmp.46 22) 14 6))))
                  (define L.boolean?.19
                    (lambda (tmp.26)
                      (let ((tmp.47 (bitwise-and tmp.26 247))) (if (eq? tmp.47 6) 14 6))))
                  (define L.fixnum?.18
                    (lambda (tmp.25)
                      (let ((tmp.48 (bitwise-and tmp.25 7))) (if (eq? tmp.48 0) 14 6))))
                  (define L.procedure-arity.17
                    (lambda (tmp.24)
                      (let ((tmp.49 (bitwise-and tmp.24 7)))
                        (if (eq? tmp.49 2)
                          (if (neq? 14 6) (mref tmp.24 6) 3390)
                          (if (neq? 6 6) (mref tmp.24 6) 3390)))))
                  (define L.cdr.16
                    (lambda (tmp.23)
                      (let ((tmp.50 (bitwise-and tmp.23 7)))
                        (if (eq? tmp.50 1)
                          (if (neq? 14 6) (mref tmp.23 7) 3134)
                          (if (neq? 6 6) (mref tmp.23 7) 3134)))))
                  (define L.car.15
                    (lambda (tmp.22)
                      (let ((tmp.51 (bitwise-and tmp.22 7)))
                        (if (eq? tmp.51 1)
                          (if (neq? 14 6) (mref tmp.22 -1) 2878)
                          (if (neq? 6 6) (mref tmp.22 -1) 2878)))))
                  (define L.vector-ref.14
                    (lambda (tmp.20 tmp.21)
                      (let ((tmp.52 (bitwise-and tmp.21 7)))
                        (if (eq? tmp.52 0)
                          (if (neq? 14 6)
                            (let ((tmp.53 (bitwise-and tmp.20 7)))
                              (if (eq? tmp.53 3)
                                (if (neq? 14 6)
                                  (apply L.unsafe-vector-ref.3 tmp.20 tmp.21)
                                  2622)
                                (if (neq? 6 6)
                                  (apply L.unsafe-vector-ref.3 tmp.20 tmp.21)
                                  2622)))
                            2622)
                          (if (neq? 6 6)
                            (let ((tmp.54 (bitwise-and tmp.20 7)))
                              (if (eq? tmp.54 3)
                                (if (neq? 14 6)
                                  (apply L.unsafe-vector-ref.3 tmp.20 tmp.21)
                                  2622)
                                (if (neq? 6 6)
                                  (apply L.unsafe-vector-ref.3 tmp.20 tmp.21)
                                  2622)))
                            2622)))))
                  (define L.vector-set!.13
                    (lambda (tmp.17 tmp.18 tmp.19)
                      (let ((tmp.55 (bitwise-and tmp.18 7)))
                        (if (eq? tmp.55 0)
                          (if (neq? 14 6)
                            (let ((tmp.56 (bitwise-and tmp.17 7)))
                              (if (eq? tmp.56 3)
                                (if (neq? 14 6)
                                  (apply L.unsafe-vector-set!.2 tmp.17 tmp.18 tmp.19)
                                  2366)
                                (if (neq? 6 6)
                                  (apply L.unsafe-vector-set!.2 tmp.17 tmp.18 tmp.19)
                                  2366)))
                            2366)
                          (if (neq? 6 6)
                            (let ((tmp.57 (bitwise-and tmp.17 7)))
                              (if (eq? tmp.57 3)
                                (if (neq? 14 6)
                                  (apply L.unsafe-vector-set!.2 tmp.17 tmp.18 tmp.19)
                                  2366)
                                (if (neq? 6 6)
                                  (apply L.unsafe-vector-set!.2 tmp.17 tmp.18 tmp.19)
                                  2366)))
                            2366)))))
                  (define L.vector-length.12
                    (lambda (tmp.16)
                      (let ((tmp.58 (bitwise-and tmp.16 7)))
                        (if (eq? tmp.58 3)
                          (if (neq? 14 6) (mref tmp.16 -3) 2110)
                          (if (neq? 6 6) (mref tmp.16 -3) 2110)))))
                  (define L.make-vector.11
                    (lambda (tmp.15)
                      (let ((tmp.59 (bitwise-and tmp.15 7)))
                        (if (eq? tmp.59 0)
                          (if (neq? 14 6) (apply L.make-init-vector.1 tmp.15) 1854)
                          (if (neq? 6 6) (apply L.make-init-vector.1 tmp.15) 1854)))))
                  (define L.>=.10
                    (lambda (tmp.13 tmp.14)
                      (let ((tmp.60 (bitwise-and tmp.14 7)))
                        (if (eq? tmp.60 0)
                          (if (neq? 14 6)
                            (let ((tmp.61 (bitwise-and tmp.13 7)))
                              (if (eq? tmp.61 0)
                                (if (neq? 14 6) (if (>= tmp.13 tmp.14) 14 6) 1598)
                                (if (neq? 6 6) (if (>= tmp.13 tmp.14) 14 6) 1598)))
                            1598)
                          (if (neq? 6 6)
                            (let ((tmp.62 (bitwise-and tmp.13 7)))
                              (if (eq? tmp.62 0)
                                (if (neq? 14 6) (if (>= tmp.13 tmp.14) 14 6) 1598)
                                (if (neq? 6 6) (if (>= tmp.13 tmp.14) 14 6) 1598)))
                            1598)))))
                  (define L.>.9
                    (lambda (tmp.11 tmp.12)
                      (let ((tmp.63 (bitwise-and tmp.12 7)))
                        (if (eq? tmp.63 0)
                          (if (neq? 14 6)
                            (let ((tmp.64 (bitwise-and tmp.11 7)))
                              (if (eq? tmp.64 0)
                                (if (neq? 14 6) (if (> tmp.11 tmp.12) 14 6) 1342)
                                (if (neq? 6 6) (if (> tmp.11 tmp.12) 14 6) 1342)))
                            1342)
                          (if (neq? 6 6)
                            (let ((tmp.65 (bitwise-and tmp.11 7)))
                              (if (eq? tmp.65 0)
                                (if (neq? 14 6) (if (> tmp.11 tmp.12) 14 6) 1342)
                                (if (neq? 6 6) (if (> tmp.11 tmp.12) 14 6) 1342)))
                            1342)))))
                  (define L.<=.8
                    (lambda (tmp.9 tmp.10)
                      (let ((tmp.66 (bitwise-and tmp.10 7)))
                        (if (eq? tmp.66 0)
                          (if (neq? 14 6)
                            (let ((tmp.67 (bitwise-and tmp.9 7)))
                              (if (eq? tmp.67 0)
                                (if (neq? 14 6) (if (<= tmp.9 tmp.10) 14 6) 1086)
                                (if (neq? 6 6) (if (<= tmp.9 tmp.10) 14 6) 1086)))
                            1086)
                          (if (neq? 6 6)
                            (let ((tmp.68 (bitwise-and tmp.9 7)))
                              (if (eq? tmp.68 0)
                                (if (neq? 14 6) (if (<= tmp.9 tmp.10) 14 6) 1086)
                                (if (neq? 6 6) (if (<= tmp.9 tmp.10) 14 6) 1086)))
                            1086)))))
                  (define L.<.7
                    (lambda (tmp.7 tmp.8)
                      (let ((tmp.69 (bitwise-and tmp.8 7)))
                        (if (eq? tmp.69 0)
                          (if (neq? 14 6)
                            (let ((tmp.70 (bitwise-and tmp.7 7)))
                              (if (eq? tmp.70 0)
                                (if (neq? 14 6) (if (< tmp.7 tmp.8) 14 6) 830)
                                (if (neq? 6 6) (if (< tmp.7 tmp.8) 14 6) 830)))
                            830)
                          (if (neq? 6 6)
                            (let ((tmp.71 (bitwise-and tmp.7 7)))
                              (if (eq? tmp.71 0)
                                (if (neq? 14 6) (if (< tmp.7 tmp.8) 14 6) 830)
                                (if (neq? 6 6) (if (< tmp.7 tmp.8) 14 6) 830)))
                            830)))))
                  (define L.-.6
                    (lambda (tmp.5 tmp.6)
                      (let ((tmp.72 (bitwise-and tmp.6 7)))
                        (if (eq? tmp.72 0)
                          (if (neq? 14 6)
                            (let ((tmp.73 (bitwise-and tmp.5 7)))
                              (if (eq? tmp.73 0)
                                (if (neq? 14 6) (- tmp.5 tmp.6) 574)
                                (if (neq? 6 6) (- tmp.5 tmp.6) 574)))
                            574)
                          (if (neq? 6 6)
                            (let ((tmp.74 (bitwise-and tmp.5 7)))
                              (if (eq? tmp.74 0)
                                (if (neq? 14 6) (- tmp.5 tmp.6) 574)
                                (if (neq? 6 6) (- tmp.5 tmp.6) 574)))
                            574)))))
                  (define L.+.5
                    (lambda (tmp.3 tmp.4)
                      (let ((tmp.75 (bitwise-and tmp.4 7)))
                        (if (eq? tmp.75 0)
                          (if (neq? 14 6)
                            (let ((tmp.76 (bitwise-and tmp.3 7)))
                              (if (eq? tmp.76 0)
                                (if (neq? 14 6) (+ tmp.3 tmp.4) 318)
                                (if (neq? 6 6) (+ tmp.3 tmp.4) 318)))
                            318)
                          (if (neq? 6 6)
                            (let ((tmp.77 (bitwise-and tmp.3 7)))
                              (if (eq? tmp.77 0)
                                (if (neq? 14 6) (+ tmp.3 tmp.4) 318)
                                (if (neq? 6 6) (+ tmp.3 tmp.4) 318)))
                            318)))))
                  (define L.*.4
                    (lambda (tmp.1 tmp.2)
                      (let ((tmp.78 (bitwise-and tmp.2 7)))
                        (if (eq? tmp.78 0)
                          (if (neq? 14 6)
                            (let ((tmp.79 (bitwise-and tmp.1 7)))
                              (if (eq? tmp.79 0)
                                (if (neq? 14 6)
                                  (let ((tmp.80 (arithmetic-shift-right tmp.2 3)))
                                    (* tmp.1 tmp.80))
                                  62)
                                (if (neq? 6 6)
                                  (let ((tmp.81 (arithmetic-shift-right tmp.2 3)))
                                    (* tmp.1 tmp.81))
                                  62)))
                            62)
                          (if (neq? 6 6)
                            (let ((tmp.82 (bitwise-and tmp.1 7)))
                              (if (eq? tmp.82 0)
                                (if (neq? 14 6)
                                  (let ((tmp.83 (arithmetic-shift-right tmp.2 3)))
                                    (* tmp.1 tmp.83))
                                  62)
                                (if (neq? 6 6)
                                  (let ((tmp.84 (arithmetic-shift-right tmp.2 3)))
                                    (* tmp.1 tmp.84))
                                  62)))
                            62)))))
                  24878))
    (check-equal? (a-normalize 
                    '(module (begin (begin
                                      (mset! 1 2 3)
                                      (mset! 4 5 6))
                                    (begin
                                      (mset! 1 2 3)
                                      (mset! 4 5 6))
                                    7)))
                  '(module
                    (begin
                      (mset! 1 2 3)
                      (begin (mset! 4 5 6) (begin (mset! 1 2 3) (begin (mset! 4 5 6) 7))))))
    (check-equal? (a-normalize 
                    '(module (begin (begin
                                      (mset! (+ 1 2) (+ 3 4) (+ 5 6))
                                      (mset! (+ 1 2) (+ 3 4) (+ 5 6)))
                                    (begin
                                      (mset! (+ 1 2) (+ 3 4) (+ 5 6))
                                      (mset! (+ 1 2) (+ 3 4) (+ 5 6)))
                                    7)))
                  '(module
                    (let ((tmp.85 (+ 1 2)))
                      (let ((tmp.86 (+ 3 4)))
                        (let ((tmp.87 (+ 5 6)))
                          (begin
                            (mset! (+ 1 2) tmp.86 tmp.87)
                            (let ((tmp.88 (+ 1 2)))
                              (let ((tmp.89 (+ 3 4)))
                                (let ((tmp.90 (+ 5 6)))
                                  (begin
                                    (mset! (+ 1 2) tmp.89 tmp.90)
                                    (let ((tmp.91 (+ 1 2)))
                                      (let ((tmp.92 (+ 3 4)))
                                        (let ((tmp.93 (+ 5 6)))
                                          (begin
                                            (mset! (+ 1 2) tmp.92 tmp.93)
                                            (let ((tmp.94 (+ 1 2)))
                                              (let ((tmp.95 (+ 3 4)))
                                                (let ((tmp.96 (+ 5 6)))
                                                  (begin
                                                    (mset! (+ 1 2) tmp.95 tmp.96)
                                                    7))))))))))))))))))
    (check-equal? (a-normalize 
                    '(module (begin (begin
                                      (mset! 1 2 3)
                                      (mset! (+ 1 2) (+ 3 4) (+ 5 6)))
                                    (begin
                                      (mset! (+ 1 2) (+ 3 4) (+ 5 6))
                                      (mset! 1 2 3))
                                    7)))
                  '(module
                    (begin
                      (mset! 1 2 3)
                      (let ((tmp.97 (+ 1 2)))
                        (let ((tmp.98 (+ 3 4)))
                          (let ((tmp.99 (+ 5 6)))
                            (begin
                              (mset! (+ 1 2) tmp.98 tmp.99)
                              (let ((tmp.100 (+ 1 2)))
                                (let ((tmp.101 (+ 3 4)))
                                  (let ((tmp.102 (+ 5 6)))
                                    (begin
                                      (mset! (+ 1 2) tmp.101 tmp.102)
                                      (begin (mset! 1 2 3) 7))))))))))))
    (check-equal? (a-normalize 
                    '(module (begin (begin
                                      (mset! 1 2 3)
                                      (mset! (+ 1 2) (+ 3 4) (+ 5 6)))
                                    (begin
                                      (mset! (+ 1 2) (+ 3 4) (+ 5 6))
                                      (mset! 1 2 3))
                                    (+ (+ 1 2) 3))))
                  '(module
                    (begin
                      (mset! 1 2 3)
                      (let ((tmp.103 (+ 1 2)))
                        (let ((tmp.104 (+ 3 4)))
                          (let ((tmp.105 (+ 5 6)))
                            (begin
                              (mset! (+ 1 2) tmp.104 tmp.105)
                              (let ((tmp.106 (+ 1 2)))
                                (let ((tmp.107 (+ 3 4)))
                                  (let ((tmp.108 (+ 5 6)))
                                    (begin
                                      (mset! (+ 1 2) tmp.107 tmp.108)
                                      (begin
                                        (mset! 1 2 3)
                                        (let ((tmp.109 (+ 1 2))) (+ tmp.109 3))))))))))))))
    (check-equal? (a-normalize '(module (if (eq? 1 1) (+ (+ 1 2) 3) (+ 1 (+ 2 3)))))
                  '(module
                    (if (eq? 1 1)
                      (let ((tmp.110 (+ 1 2))) (+ tmp.110 3))
                      (let ((tmp.111 (+ 2 3))) (+ 1 tmp.111)))))
    (check-equal? (a-normalize '(module (if (eq? (+ 1 2) 
                                                 (+ 2 1)) 
                                            (+ (+ 1 2) 3) 
                                            (+ 1 (+ 2 3)))))
                  '(module
                    (let ((tmp.112 (+ 1 2)))
                      (let ((tmp.113 (+ 2 1)))
                        (if (eq? tmp.112 tmp.113)
                          (let ((tmp.114 (+ 1 2))) (+ tmp.114 3))
                          (let ((tmp.115 (+ 2 3))) (+ 1 tmp.115)))))))
  )

; Exercise 8
(module+ test
  (check-equal? (specify-representation '(module ())) '(module 22))
  (check-equal? (specify-representation '(module #\a)) '(module 24878))
  (check-equal? (specify-representation '(module 0)) '(module 0))
  (check-equal? (specify-representation '(module #t)) '(module 14))
  (check-equal? (specify-representation '(module #f)) '(module 6))
  (check-equal? (specify-representation '(module (void))) '(module 30))
  (check-equal? (specify-representation '(module (error 0))) '(module 62))
  (check-equal? (specify-representation '(module (error 5))) '(module 1342))
  (check-equal? (specify-representation
                 '(module
                      (define L.unsafe-vector-ref.3
                        (lambda (tmp.48 tmp.49)
                          (if (unsafe-fx< tmp.49 (unsafe-vector-length tmp.48))
                              (if (unsafe-fx>= tmp.49 0)
                                  (unsafe-vector-ref tmp.48 tmp.49)
                                  (error 10))
                              (error 10))))
                    (define L.unsafe-vector-set!.2
                      (lambda (tmp.48 tmp.49 tmp.50)
                        (if (unsafe-fx< tmp.49 (unsafe-vector-length tmp.48))
                            (if (unsafe-fx>= tmp.49 0)
                                (begin (unsafe-vector-set! tmp.48 tmp.49 tmp.50) tmp.48)
                                (error 9))
                            (error 9))))
                    (define L.vector-init-loop.30
                      (lambda (len.45 i.47 vec.46)
                        (if (eq? len.45 i.47)
                            vec.46
                            (begin
                              (unsafe-vector-set! vec.46 i.47 0)
                              (apply L.vector-init-loop.30 len.45 (unsafe-fx+ i.47 1) vec.46)))))
                    (define L.make-init-vector.1
                      (lambda (tmp.43)
                        (let ((tmp.44 (unsafe-make-vector tmp.43)))
                          (apply L.vector-init-loop.30 tmp.43 0 tmp.44))))
                    (define L.eq?.29 (lambda (tmp.41 tmp.42) (eq? tmp.41 tmp.42)))
                    (define L.cons.28 (lambda (tmp.39 tmp.40) (cons tmp.39 tmp.40)))
                    (define L.not.27 (lambda (tmp.38) (not tmp.38)))
                    (define L.vector?.26 (lambda (tmp.37) (vector? tmp.37)))
                    (define L.procedure?.25 (lambda (tmp.36) (procedure? tmp.36)))
                    (define L.pair?.24 (lambda (tmp.35) (pair? tmp.35)))
                    (define L.error?.23 (lambda (tmp.34) (error? tmp.34)))
                    (define L.ascii-char?.22 (lambda (tmp.33) (ascii-char? tmp.33)))
                    (define L.void?.21 (lambda (tmp.32) (void? tmp.32)))
                    (define L.empty?.20 (lambda (tmp.31) (empty? tmp.31)))
                    (define L.boolean?.19 (lambda (tmp.30) (boolean? tmp.30)))
                    (define L.fixnum?.18 (lambda (tmp.29) (fixnum? tmp.29)))
                    (define L.procedure-arity.17
                      (lambda (tmp.28)
                        (if (procedure? tmp.28) (unsafe-procedure-arity tmp.28) (error 13))))
                    (define L.cdr.16
                      (lambda (tmp.27) (if (pair? tmp.27) (unsafe-cdr tmp.27) (error 12))))
                    (define L.car.15
                      (lambda (tmp.26) (if (pair? tmp.26) (unsafe-car tmp.26) (error 11))))
                    (define L.vector-ref.14
                      (lambda (tmp.24 tmp.25)
                        (if (fixnum? tmp.25)
                            (if (vector? tmp.24)
                                (apply L.unsafe-vector-ref.3 tmp.24 tmp.25)
                                (error 10))
                            (error 10))))
                    (define L.vector-set!.13
                      (lambda (tmp.21 tmp.22 tmp.23)
                        (if (fixnum? tmp.22)
                            (if (vector? tmp.21)
                                (apply L.unsafe-vector-set!.2 tmp.21 tmp.22 tmp.23)
                                (error 9))
                            (error 9))))
                    (define L.vector-length.12
                      (lambda (tmp.20)
                        (if (vector? tmp.20) (unsafe-vector-length tmp.20) (error 8))))
                    (define L.make-vector.11
                      (lambda (tmp.19)
                        (if (fixnum? tmp.19) (apply L.make-init-vector.1 tmp.19) (error 7))))
                    (define L.>=.10
                      (lambda (tmp.17 tmp.18)
                        (if (fixnum? tmp.18)
                            (if (fixnum? tmp.17) (unsafe-fx>= tmp.17 tmp.18) (error 6))
                            (error 6))))
                    (define L.>.9
                      (lambda (tmp.15 tmp.16)
                        (if (fixnum? tmp.16)
                            (if (fixnum? tmp.15) (unsafe-fx> tmp.15 tmp.16) (error 5))
                            (error 5))))
                    (define L.<=.8
                      (lambda (tmp.13 tmp.14)
                        (if (fixnum? tmp.14)
                            (if (fixnum? tmp.13) (unsafe-fx<= tmp.13 tmp.14) (error 4))
                            (error 4))))
                    (define L.<.7
                      (lambda (tmp.11 tmp.12)
                        (if (fixnum? tmp.12)
                            (if (fixnum? tmp.11) (unsafe-fx< tmp.11 tmp.12) (error 3))
                            (error 3))))
                    (define L.-.6
                      (lambda (tmp.9 tmp.10)
                        (if (fixnum? tmp.10)
                            (if (fixnum? tmp.9) (unsafe-fx- tmp.9 tmp.10) (error 2))
                            (error 2))))
                    (define L.+.5
                      (lambda (tmp.7 tmp.8)
                        (if (fixnum? tmp.8)
                            (if (fixnum? tmp.7) (unsafe-fx+ tmp.7 tmp.8) (error 1))
                            (error 1))))
                    (define L.*.4
                      (lambda (tmp.5 tmp.6)
                        (if (fixnum? tmp.6)
                            (if (fixnum? tmp.5) (unsafe-fx* tmp.5 tmp.6) (error 0))
                            (error 0))))
                    (let ((x.1 1))
                      (let ((y.2 2))
                        (if (apply L.>.9 x.1 y.2)
                            (let ((a.3 3)) (apply L.+.5 x.1 a.3))
                            (let ((b.4 4)) (apply L.+.5 y.2 b.4)))))))
                '(module
                  (define L.unsafe-vector-ref.3
                    (lambda (tmp.48 tmp.49)
                      (if (neq? (if (< tmp.49 (mref tmp.48 -3)) 14 6) 6)
                        (if (neq? (if (>= tmp.49 0) 14 6) 6)
                          (mref tmp.48 (+ (* (arithmetic-shift-right tmp.49 3) 8) 5))
                          2622)
                        2622)))
                  (define L.unsafe-vector-set!.2
                    (lambda (tmp.48 tmp.49 tmp.50)
                      (if (neq? (if (< tmp.49 (mref tmp.48 -3)) 14 6) 6)
                        (if (neq? (if (>= tmp.49 0) 14 6) 6)
                          (begin
                            (mset!
                              tmp.48
                              (+ (* (arithmetic-shift-right tmp.49 3) 8) 5)
                              tmp.50)
                            tmp.48)
                          2366)
                        2366)))
                  (define L.vector-init-loop.30
                    (lambda (len.45 i.47 vec.46)
                      (if (neq? (if (eq? len.45 i.47) 14 6) 6)
                        vec.46
                        (begin
                          (mset! vec.46 (+ (* (arithmetic-shift-right i.47 3) 8) 5) 0)
                          (apply L.vector-init-loop.30 len.45 (+ i.47 8) vec.46)))))
                  (define L.make-init-vector.1
                    (lambda (tmp.43)
                      (let ((tmp.44
                              (let ((tmp.116
                                    (+
                                      (alloc (* (+ 1 (arithmetic-shift-right tmp.43 3)) 8))
                                      3)))
                                (begin (mset! tmp.116 -3 tmp.43) tmp.116))))
                        (apply L.vector-init-loop.30 tmp.43 0 tmp.44))))
                  (define L.eq?.29 (lambda (tmp.41 tmp.42) (if (eq? tmp.41 tmp.42) 14 6)))
                  (define L.cons.28
                    (lambda (tmp.39 tmp.40)
                      (let ((tmp.117 (+ (alloc 16) 1)))
                        (begin (mset! tmp.117 -1 tmp.39) (mset! tmp.117 7 tmp.40) tmp.117))))
                  (define L.not.27 (lambda (tmp.38) (if (neq? tmp.38 6) 6 14)))
                  (define L.vector?.26
                    (lambda (tmp.37) (if (eq? (bitwise-and tmp.37 7) 3) 14 6)))
                  (define L.procedure?.25
                    (lambda (tmp.36) (if (eq? (bitwise-and tmp.36 7) 2) 14 6)))
                  (define L.pair?.24
                    (lambda (tmp.35) (if (eq? (bitwise-and tmp.35 7) 1) 14 6)))
                  (define L.error?.23
                    (lambda (tmp.34) (if (eq? (bitwise-and tmp.34 255) 62) 14 6)))
                  (define L.ascii-char?.22
                    (lambda (tmp.33) (if (eq? (bitwise-and tmp.33 255) 46) 14 6)))
                  (define L.void?.21
                    (lambda (tmp.32) (if (eq? (bitwise-and tmp.32 255) 30) 14 6)))
                  (define L.empty?.20
                    (lambda (tmp.31) (if (eq? (bitwise-and tmp.31 255) 22) 14 6)))
                  (define L.boolean?.19
                    (lambda (tmp.30) (if (eq? (bitwise-and tmp.30 247) 6) 14 6)))
                  (define L.fixnum?.18
                    (lambda (tmp.29) (if (eq? (bitwise-and tmp.29 7) 0) 14 6)))
                  (define L.procedure-arity.17
                    (lambda (tmp.28)
                      (if (neq? (if (eq? (bitwise-and tmp.28 7) 2) 14 6) 6)
                        (mref tmp.28 6)
                        3390)))
                  (define L.cdr.16
                    (lambda (tmp.27)
                      (if (neq? (if (eq? (bitwise-and tmp.27 7) 1) 14 6) 6)
                        (mref tmp.27 7)
                        3134)))
                  (define L.car.15
                    (lambda (tmp.26)
                      (if (neq? (if (eq? (bitwise-and tmp.26 7) 1) 14 6) 6)
                        (mref tmp.26 -1)
                        2878)))
                  (define L.vector-ref.14
                    (lambda (tmp.24 tmp.25)
                      (if (neq? (if (eq? (bitwise-and tmp.25 7) 0) 14 6) 6)
                        (if (neq? (if (eq? (bitwise-and tmp.24 7) 3) 14 6) 6)
                          (apply L.unsafe-vector-ref.3 tmp.24 tmp.25)
                          2622)
                        2622)))
                  (define L.vector-set!.13
                    (lambda (tmp.21 tmp.22 tmp.23)
                      (if (neq? (if (eq? (bitwise-and tmp.22 7) 0) 14 6) 6)
                        (if (neq? (if (eq? (bitwise-and tmp.21 7) 3) 14 6) 6)
                          (apply L.unsafe-vector-set!.2 tmp.21 tmp.22 tmp.23)
                          2366)
                        2366)))
                  (define L.vector-length.12
                    (lambda (tmp.20)
                      (if (neq? (if (eq? (bitwise-and tmp.20 7) 3) 14 6) 6)
                        (mref tmp.20 -3)
                        2110)))
                  (define L.make-vector.11
                    (lambda (tmp.19)
                      (if (neq? (if (eq? (bitwise-and tmp.19 7) 0) 14 6) 6)
                        (apply L.make-init-vector.1 tmp.19)
                        1854)))
                  (define L.>=.10
                    (lambda (tmp.17 tmp.18)
                      (if (neq? (if (eq? (bitwise-and tmp.18 7) 0) 14 6) 6)
                        (if (neq? (if (eq? (bitwise-and tmp.17 7) 0) 14 6) 6)
                          (if (>= tmp.17 tmp.18) 14 6)
                          1598)
                        1598)))
                  (define L.>.9
                    (lambda (tmp.15 tmp.16)
                      (if (neq? (if (eq? (bitwise-and tmp.16 7) 0) 14 6) 6)
                        (if (neq? (if (eq? (bitwise-and tmp.15 7) 0) 14 6) 6)
                          (if (> tmp.15 tmp.16) 14 6)
                          1342)
                        1342)))
                  (define L.<=.8
                    (lambda (tmp.13 tmp.14)
                      (if (neq? (if (eq? (bitwise-and tmp.14 7) 0) 14 6) 6)
                        (if (neq? (if (eq? (bitwise-and tmp.13 7) 0) 14 6) 6)
                          (if (<= tmp.13 tmp.14) 14 6)
                          1086)
                        1086)))
                  (define L.<.7
                    (lambda (tmp.11 tmp.12)
                      (if (neq? (if (eq? (bitwise-and tmp.12 7) 0) 14 6) 6)
                        (if (neq? (if (eq? (bitwise-and tmp.11 7) 0) 14 6) 6)
                          (if (< tmp.11 tmp.12) 14 6)
                          830)
                        830)))
                  (define L.-.6
                    (lambda (tmp.9 tmp.10)
                      (if (neq? (if (eq? (bitwise-and tmp.10 7) 0) 14 6) 6)
                        (if (neq? (if (eq? (bitwise-and tmp.9 7) 0) 14 6) 6)
                          (- tmp.9 tmp.10)
                          574)
                        574)))
                  (define L.+.5
                    (lambda (tmp.7 tmp.8)
                      (if (neq? (if (eq? (bitwise-and tmp.8 7) 0) 14 6) 6)
                        (if (neq? (if (eq? (bitwise-and tmp.7 7) 0) 14 6) 6)
                          (+ tmp.7 tmp.8)
                          318)
                        318)))
                  (define L.*.4
                    (lambda (tmp.5 tmp.6)
                      (if (neq? (if (eq? (bitwise-and tmp.6 7) 0) 14 6) 6)
                        (if (neq? (if (eq? (bitwise-and tmp.5 7) 0) 14 6) 6)
                          (* tmp.5 (arithmetic-shift-right tmp.6 3))
                          62)
                        62)))
                  (let ((x.1 8))
                    (let ((y.2 16))
                      (if (neq? (apply L.>.9 x.1 y.2) 6)
                        (let ((a.3 24)) (apply L.+.5 x.1 a.3))
                        (let ((b.4 32)) (apply L.+.5 y.2 b.4)))))))
    (check-equal? (specify-representation
                    '(module (let ([x.1 0]) (let ([y.2 1]) (make-procedure x.1 y.2)))))
                  '(module
                    (let ((x.1 0))
                      (let ((y.2 8))
                        (let ((tmp.118 (+ (alloc 16) 2)))
                          (begin (mset! tmp.118 -2 x.1) (mset! tmp.118 6 y.2) tmp.118))))))
    (check-equal? (specify-representation
                    '(module (let ([x.1 0]) (unsafe-procedure-label x.1))))
                  '(module (let ((x.1 0)) (mref x.1 -2))))
    
    (check-equal? (specify-representation `(module (cons (if (eq? 7 8) (unsafe-fx* 7 8) (unsafe-fx* 8 7)) ())))
      '(module
      (let ((tmp.119 (+ (alloc 16) 1)))
        (begin
          (mset! tmp.119 -1 (if (neq? (if (eq? 56 64) 14 6) 6) (* 7 64) (* 8 56)))
          (mset! tmp.119 7 22)
          tmp.119)))
    )

    (check-equal? (specify-representation 
                    `(module (let ([x.1 (unsafe-fx* 7 8)])
                                (let ([x.2 (unsafe-fx* x.1 8)])
                                  (let ([x.3 (unsafe-fx* 8 x.1)])
                                    (cons (unsafe-fx* x.1 x.2) ()))))))
      '(module
        (let ((x.1 (* 7 64)))
          (let ((x.2 (* x.1 8)))
            (let ((x.3 (* 8 x.1)))
              (let ((tmp.120 (+ (alloc 16) 1)))
                (begin
                  (mset! tmp.120 -1 (* x.1 (arithmetic-shift-right x.2 3)))
                  (mset! tmp.120 7 22)
                  tmp.120))))))
    )

    (check-equal? (specify-representation `(module (define L.*.4
                      (lambda (tmp.5 tmp.6)
                        (if (fixnum? tmp.6)
                            (if (fixnum? tmp.5) (unsafe-fx* tmp.5 tmp.6) (error 0))
                            (error 0)))) 7)) 
                  '(module
                      (define L.*.4
                        (lambda (tmp.5 tmp.6)
                          (if (neq? (if (eq? (bitwise-and tmp.6 7) 0) 14 6) 6)
                            (if (neq? (if (eq? (bitwise-and tmp.5 7) 0) 14 6) 6)
                              (* tmp.5 (arithmetic-shift-right tmp.6 3))
                              62)
                            62)))
                      56))
  )

(module+ test
  (check-equal? (uncover-locals
                 '(module
                    (define L.main.1
                      ((new-frames ()))
                      (begin
                        (set! w.1 1)
                        (set! x.2 2)
                        (set! y.3 (mref w.1 x.2))
                        (mset! z.4 w.1 x.2)
                        (jump L.main.1 rbp)))))
                '(module
                  (define L.main.1
                    ((new-frames ())
                     (locals (z.4 y.3 x.2 w.1)))
                    (begin
                      (set! w.1 1)
                      (set! x.2 2)
                      (set! y.3 (mref w.1 x.2))
                      (mset! z.4 w.1 x.2)
                      (jump L.main.1 rbp)))))
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

(module+ test
  (check-equal? (conflict-analysis
                 '(module
                    (define L.main.1
                      ((new-frames ())
                       (locals (c.7 b.6 a.5 z.4 y.3 x.2 w.1))
                       (undead-out
                       ((r12 rbp w.1)
                        (r12 rbp x.2 w.1)
                        (r12 rbp x.2 w.1)
                        (r12 rbp x.2 w.1)
                        (r12 rbp x.2 w.1)
                        (rbp x.2 w.1 z.4)
                        (rbp x.2 w.1 z.4)
                        (rbp)
                        (a.5 rbp)
                        (rbp)
                        (rbp)))
                      (call-undead ()))
                      (begin
                        (set! w.1 1)
                        (set! x.2 2)
                        (set! y.3 (mref w.1 x.2))
                        (set! r10 1)
                        (set! fv0 1)
                        (set! z.4 r12)
                        (set! c.7 (mref x.2 w.1))
                        (mset! z.4 w.1 x.2)
                        (set! a.5 1)
                        (set! b.6 a.5)
                        (jump L.main.1 rbp)))))
                '(module
                  (define L.main.1
                    ((new-frames ())
                      (locals (c.7 b.6 a.5 z.4 y.3 x.2 w.1))
                      (undead-out
                      ((r12 rbp w.1)
                      (r12 rbp x.2 w.1)
                      (r12 rbp x.2 w.1)
                      (r12 rbp x.2 w.1)
                      (r12 rbp x.2 w.1)
                      (rbp x.2 w.1 z.4)
                      (rbp x.2 w.1 z.4)
                      (rbp)
                      (a.5 rbp)
                      (rbp)
                      (rbp)))
                    (call-undead ())
                    (conflicts
                      ((b.6 (rbp))
                      (a.5 (rbp))
                      (c.7 (z.4 w.1 x.2 rbp))
                      (z.4 (c.7 w.1 x.2 rbp))
                      (fv0 (w.1 x.2 rbp r12))
                      (r10 (w.1 x.2 rbp r12))
                      (y.3 (w.1 x.2 rbp r12))
                      (x.2 (c.7 z.4 fv0 r10 y.3 w.1 rbp r12))
                      (rbp (b.6 a.5 c.7 z.4 fv0 r10 y.3 x.2 w.1))
                      (r12 (fv0 r10 y.3 x.2 w.1))
                      (w.1 (c.7 z.4 fv0 r10 y.3 x.2 rbp r12)))))
                    (begin
                      (set! w.1 1)
                      (set! x.2 2)
                      (set! y.3 (mref w.1 x.2))
                      (set! r10 1)
                      (set! fv0 1)
                      (set! z.4 r12)
                      (set! c.7 (mref x.2 w.1))
                      (mset! z.4 w.1 x.2)
                      (set! a.5 1)
                      (set! b.6 a.5)
                      (jump L.main.1 rbp)))))
  (check-match (conflict-analysis  
                '(module
                  (define L.main.1
                    ((new-frames ())
                    (locals (tmp.1 tmp.4 tmp.2 ra.3))
                    (undead-out
                      ((r12 ra.3 rbp)
                      (r12 tmp.2 ra.3 rbp)
                      (tmp.2 ra.3 rbp)
                      (tmp.4 ra.3 rbp)
                      (ra.3 rbp tmp.1)
                      (rbp ra.3 tmp.1)
                      (tmp.1 ra.3 rbp)
                      (ra.3 rax rbp)
                      (rax rbp)))
                    (call-undead ()))
                    (begin
                      (set! ra.3 r15)
                      (set! tmp.2 r12)
                      (set! r12 (+ r12 16))
                      (set! tmp.4 tmp.2)
                      (set! tmp.1 (+ tmp.4 1))
                      (mset! tmp.1 -1 56)
                      (mset! tmp.1 7 22)
                      (set! rax (mref tmp.1 -1))
                      (jump ra.3 rbp rax)))))
              `(module
                (define L.main.1
                  ((new-frames ())
                  (locals (tmp.1 tmp.4 tmp.2 ra.3))
                  (undead-out
                    ((r12 ra.3 rbp)
                    (r12 tmp.2 ra.3 rbp)
                    (tmp.2 ra.3 rbp)
                    (tmp.4 ra.3 rbp)
                    (ra.3 rbp tmp.1)
                    (rbp ra.3 tmp.1)
                    (tmp.1 ra.3 rbp)
                    (ra.3 rax rbp)
                    (rax rbp)))
                  (call-undead ())
                  (conflicts
                    ,(list-no-order
                      `(ra.3 ,(list-no-order 'rax 'tmp.1 'tmp.4 'tmp.2 'r12 'rbp))
                      `(rbp ,(list-no-order 'rax 'tmp.1 'tmp.4 'r12 'tmp.2 'ra.3))
                      `(r12 ,(list-no-order 'rbp 'tmp.2 'ra.3))
                      `(tmp.2 ,(list-no-order 'r12 'ra.3 'rbp))
                      `(tmp.4 ,(list-no-order 'ra.3 'rbp))
                      `(tmp.1 ,(list-no-order 'rbp 'ra.3))
                      `(rax ,(list-no-order 'rbp 'ra.3)))))
                  (begin
                    (set! ra.3 r15)
                    (set! tmp.2 r12)
                    (set! r12 (+ r12 16))
                    (set! tmp.4 tmp.2)
                    (set! tmp.1 (+ tmp.4 1))
                    (mset! tmp.1 -1 56)
                    (mset! tmp.1 7 22)
                    (set! rax (mref tmp.1 -1))
                    (jump ra.3 rbp rax)))))
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

;; undead-analysis
(module+ test
  (check-equal? (undead-analysis
            '(module
    (define L.main.1
      ((new-frames ()) (locals (x.3 tmp.2 x.2 x.1 ra.1)))
      (begin
        (set! ra.1 r15)
        (set! x.1 56)
        (set! x.2 r12)
        (set! r12 (+ r12 16))
        (set! tmp.2 x.2)
        (set! x.3 (+ tmp.2 1))
        (mset! x.3 -1 x.1)
        (mset! x.3 7 22)
        (set! rax x.3)
        (jump ra.1 rbp rax))))
                    )
                    '(module
    (define L.main.1
      ((new-frames ())
      (locals (x.3 tmp.2 x.2 x.1 ra.1))
      (undead-out
       ((rbp ra.1 r12)
        (r12 x.1 ra.1 rbp)
        (r12 rbp ra.1 x.1 x.2)
        (x.2 x.1 ra.1 rbp)
        (tmp.2 rbp ra.1 x.1)
        (x.1 x.3 ra.1 rbp)
        (x.3 rbp ra.1)
        (x.3 ra.1 rbp)
        (rax rbp ra.1)
        (rbp rax)))
      (call-undead ()))
      (begin
        (set! ra.1 r15)
        (set! x.1 56)
        (set! x.2 r12)
        (set! r12 (+ r12 16))
        (set! tmp.2 x.2)
        (set! x.3 (+ tmp.2 1))
        (mset! x.3 -1 x.1)
        (mset! x.3 7 22)
        (set! rax x.3)
        (jump ra.1 rbp rax))))
        ))

#;(module+ test
    (check-equal? (a-normalize '(module
      (let ((tmp.119 (+ (alloc 16) 1)))
        (begin
          (mset! tmp.119 -1 (if (neq? (if (eq? 56 64) 14 6) 6) (* 7 64) (* 8 56)))
          (mset! tmp.119 7 22)
          tmp.119))))
          '(module
        (let ((tmp.1 (alloc 16)))
          (let ((tmp.119 (+ tmp.1 1)))
            (if (eq? 56 64)
              (if (neq? 14 6)
                (let ((tmp.4 (* 7 64)))
                  (begin (mset! tmp.119 -1 tmp.4) (mset! tmp.119 7 22) tmp.119))
                (let ((tmp.5 (* 8 56)))
                  (begin (mset! tmp.119 -1 tmp.5) (mset! tmp.119 7 22) tmp.119)))
              (if (neq? 6 6)
                (let ((tmp.6 (* 7 64)))
                  (begin (mset! tmp.119 -1 tmp.6) (mset! tmp.119 7 22) tmp.119))
                (let ((tmp.7 (* 8 56)))
                  (begin (mset! tmp.119 -1 tmp.7) (mset! tmp.119 7 22) tmp.119))))))))
)