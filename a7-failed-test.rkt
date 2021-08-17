#lang racket/base

(require
    "a10.rkt"
    "a10-compiler-lib.rkt"
    "a10-graph-lib.rkt"
    "share/util.rkt")

(module+ test
  (require rackunit))

(module+ test

    ; uniquify (Ex. 8)
    (check-match (uniquify '(module
                                (define identity (lambda (x) (- x 0)))
                                (define two (lambda () (identity 2)))
                                (let ((x (two))) (identity x))))
            `(module
                (define ,i (lambda (,x1) (- ,x1 0)))
                (define ,two (lambda () (,i 2)))
                (let ((,x2 (,two))) (,i ,x2))))
    
    (check-match (uniquify '(module
     (define sum
       (lambda (a b c d e f g h)
         (let ((i (+ a b)))
           (let ((j (+ g h))) (+ i j)))))
     (let ((x 10))
       (if (eq? 1 2)
         (let ((j (sum 1 2 3 4 5 6 7 8))) j)
         (let ((x 5)) (sum 1 2 3 4 5 6 7 x))))))
         `(module
      (define ,sum
        (lambda (,a ,b ,c ,d ,e ,f ,g ,h)
          (let ((,i (+ ,a ,b)))
            (let ((,j (+ ,g ,h))) (+ ,i ,j)))))
      (let ((,x 10))
        (if (eq? 1 2)
          (let ((,j2 (,sum 1 2 3 4 5 6 7 8))) ,j2)
          (let ((,x2 5)) (,sum 1 2 3 4 5 6 7 ,x2))))))

    (check-match (uniquify `(module
      (let ((v1 23))
        (let ((w2 46))
          (let ((x3 v1))
            (let ((x4 (+ x3 7)))
              (let ((y5 x4))
                (let ((y6 (+ y5 4)))
                  (let ((z7 x4))
                    (let ((z8 (+ z7 w2)))
                      (let ((t1 y6))
                        (let ((t2 (* t1 -1)))
                          (let ((z9 (+ z8 t2))) z9)))))))))))))
            `(module
      (let ((,v1 23))
        (let ((,w2 46))
          (let ((,x3 ,v1))
            (let ((,x4 (+ ,x3 7)))
              (let ((,y5 ,x4))
                (let ((,y6 (+ ,y5 4)))
                  (let ((,z7 ,x4))
                    (let ((,z8 (+ ,z7 ,w2)))
                      (let ((,t1 ,y6))
                        (let ((,t2 (* ,t1 -1)))
                          (let ((,z9 (+ ,z8 ,t2))) ,z9)))))))))))))

  ; other tests
  (check-equal? 
(pre-assign-frame-variables
  '(module
     (define L.main.3
       ((new-frames ())
        (locals (x.3.6 ra.7))
        (undead-out
         ((ra.7 rbp)
          ((rax ra.7 rbp)
           ((rsi rbp) (rdi rsi rbp) (rdi rsi r15 rbp) (rdi rsi r15 rbp)))
          (x.3.6 ra.7 rbp)
          (x.3.6 ra.7 rsi rbp)
          (ra.7 rdi rsi rbp)
          (rdi rsi r15 rbp)
          (rdi rsi r15 rbp)))
        (call-undead (ra.7))
        (conflicts
         ((ra.7 (rdi rsi x.3.6 rax rbp))
          (rbp (x.3.6 r15 rdi rsi rax ra.7))
          (rax (rbp ra.7))
          (rsi (ra.7 r15 rdi rbp))
          (rdi (ra.7 r15 rsi rbp))
          (r15 (rdi rsi rbp))
          (x.3.6 (ra.7 rbp)))))
       (begin
         (set! ra.7 r15)
         (return-point L.rp.4
           (begin
             (set! rsi 2)
             (set! rdi 1)
             (set! r15 L.rp.4)
             (jump L.L.f1.1.2 rbp r15 rsi rdi)))
         (set! x.3.6 rax)
         (set! rsi x.3.6)
         (set! rdi x.3.6)
         (set! r15 ra.7)
         (jump L.L.f1.1.2 rbp r15 rsi rdi)))
     (define L.L.f1.1.2
       ((new-frames ())
        (locals (tmp.9 y.2.5 x.1.4 ra.8))
        (undead-out
         ((rdi rsi ra.8 rbp)
          (rsi x.1.4 ra.8 rbp)
          (y.2.5 x.1.4 ra.8 rbp)
          (tmp.9 ra.8 rbp)
          (ra.8 rax rbp)
          (rax rbp)))
        (call-undead ())
        (conflicts
         ((ra.8 (rax tmp.9 y.2.5 x.1.4 rdi rsi rbp))
          (rbp (rax tmp.9 y.2.5 x.1.4 ra.8))
          (rsi (x.1.4 ra.8))
          (rdi (ra.8))
          (x.1.4 (y.2.5 rsi ra.8 rbp))
          (y.2.5 (x.1.4 ra.8 rbp))
          (tmp.9 (rbp ra.8))
          (rax (ra.8 rbp)))))
       (begin
         (set! ra.8 r15)
         (set! x.1.4 rdi)
         (set! y.2.5 rsi)
         (set! tmp.9 (+ x.1.4 y.2.5))
         (set! rax tmp.9)
         (jump ra.8 rbp rax)))))
     '(module
    (define L.main.3
      ((new-frames ())
       (locals (x.3.6))
       (undead-out
        ((ra.7 rbp)
         ((rax ra.7 rbp)
          ((rsi rbp) (rdi rsi rbp) (rdi rsi r15 rbp) (rdi rsi r15 rbp)))
         (x.3.6 ra.7 rbp)
         (x.3.6 ra.7 rsi rbp)
         (ra.7 rdi rsi rbp)
         (rdi rsi r15 rbp)
         (rdi rsi r15 rbp)))
       (call-undead (ra.7))
       (conflicts
        ((ra.7 (rdi rsi x.3.6 rax rbp))
         (rbp (x.3.6 r15 rdi rsi rax ra.7))
         (rax (rbp ra.7))
         (rsi (ra.7 r15 rdi rbp))
         (rdi (ra.7 r15 rsi rbp))
         (r15 (rdi rsi rbp))
         (x.3.6 (ra.7 rbp))))
       (assignment ((ra.7 fv0))))
      (begin
        (set! ra.7 r15)
        (return-point L.rp.4
          (begin
            (set! rsi 2)
            (set! rdi 1)
            (set! r15 L.rp.4)
            (jump L.L.f1.1.2 rbp r15 rsi rdi)))
        (set! x.3.6 rax)
        (set! rsi x.3.6)
        (set! rdi x.3.6)
        (set! r15 ra.7)
        (jump L.L.f1.1.2 rbp r15 rsi rdi)))
    (define L.L.f1.1.2
      ((new-frames ())
       (locals (ra.8 x.1.4 y.2.5 tmp.9))
       (undead-out
        ((rdi rsi ra.8 rbp)
         (rsi x.1.4 ra.8 rbp)
         (y.2.5 x.1.4 ra.8 rbp)
         (tmp.9 ra.8 rbp)
         (ra.8 rax rbp)
         (rax rbp)))
       (call-undead ())
       (conflicts
        ((ra.8 (rax tmp.9 y.2.5 x.1.4 rdi rsi rbp))
         (rbp (rax tmp.9 y.2.5 x.1.4 ra.8))
         (rsi (x.1.4 ra.8))
         (rdi (ra.8))
         (x.1.4 (y.2.5 rsi ra.8 rbp))
         (y.2.5 (x.1.4 ra.8 rbp))
         (tmp.9 (rbp ra.8))
         (rax (ra.8 rbp))))
       (assignment ()))
      (begin
        (set! ra.8 r15)
        (set! x.1.4 rdi)
        (set! y.2.5 rsi)
        (set! tmp.9 (+ x.1.4 y.2.5))
        (set! rax tmp.9)
        (jump ra.8 rbp rax)))))

)