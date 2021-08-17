(check-equal? 
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
     '(module
    (define L.main.3
      ()
      (begin
        (set! (rbp + 0) r15)
        (set! rbp (+ rbp 8))
        (set! rsi 2)
        (set! rdi 1)
        (set! r15 L.rp.4)
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
    (define L.rp.4
      ()
      (begin
        (set! rbp (- rbp 8))
        (set! r15 rax)
        (set! rsi r15)
        (set! rdi r15)
        (set! r15 (rbp + 0))
        (jump L.L.f1.1.2)))))


(check-equal? 
(assign-registers
  '(module
     (define L.main.3
       ((locals (x.3.6))
        (undead-out
         ((ra.7 rbp)
          ((rax ra.7 rbp)
           ((rsi rbp) (rdi rsi rbp) (rdi rsi r15 rbp) (rdi rsi r15 rbp)))
          (x.3.6 ra.7 rbp)
          (x.3.6 ra.7 rsi rbp)
          (ra.7 rdi rsi rbp)
          (rdi rsi r15 rbp)
          (rdi rsi r15 rbp)))
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
         (set! rbp (+ rbp 8))
         (return-point L.rp.4
           (begin
             (set! rsi 2)
             (set! rdi 1)
             (set! r15 L.rp.4)
             (jump L.L.f1.1.2 rbp r15 rsi rdi)))
         (set! rbp (- rbp 8))
         (set! x.3.6 rax)
         (set! rsi x.3.6)
         (set! rdi x.3.6)
         (set! r15 ra.7)
         (jump L.L.f1.1.2 rbp r15 rsi rdi)))
     (define L.L.f1.1.2
       ((locals (tmp.9 y.2.5 x.1.4 ra.8))
        (undead-out
         ((rdi rsi ra.8 rbp)
          (rsi x.1.4 ra.8 rbp)
          (y.2.5 x.1.4 ra.8 rbp)
          (tmp.9 ra.8 rbp)
          (ra.8 rax rbp)
          (rax rbp)))
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
     '(module
    (define L.main.3
      ((locals ())
       (undead-out
        ((ra.7 rbp)
         ((rax ra.7 rbp)
          ((rsi rbp) (rdi rsi rbp) (rdi rsi r15 rbp) (rdi rsi r15 rbp)))
         (x.3.6 ra.7 rbp)
         (x.3.6 ra.7 rsi rbp)
         (ra.7 rdi rsi rbp)
         (rdi rsi r15 rbp)
         (rdi rsi r15 rbp)))
       (conflicts
        ((ra.7 (rdi rsi x.3.6 rax rbp))
         (rbp (x.3.6 r15 rdi rsi rax ra.7))
         (rax (rbp ra.7))
         (rsi (ra.7 r15 rdi rbp))
         (rdi (ra.7 r15 rsi rbp))
         (r15 (rdi rsi rbp))
         (x.3.6 (ra.7 rbp))))
       (assignment ((ra.7 fv0) (x.3.6 r15))))
      (begin
        (set! ra.7 r15)
        (set! rbp (+ rbp 8))
        (return-point L.rp.4
          (begin
            (set! rsi 2)
            (set! rdi 1)
            (set! r15 L.rp.4)
            (jump L.L.f1.1.2 rbp r15 rsi rdi)))
        (set! rbp (- rbp 8))
        (set! x.3.6 rax)
        (set! rsi x.3.6)
        (set! rdi x.3.6)
        (set! r15 ra.7)
        (jump L.L.f1.1.2 rbp r15 rsi rdi)))
    (define L.L.f1.1.2
      ((locals ())
       (undead-out
        ((rdi rsi ra.8 rbp)
         (rsi x.1.4 ra.8 rbp)
         (y.2.5 x.1.4 ra.8 rbp)
         (tmp.9 ra.8 rbp)
         (ra.8 rax rbp)
         (rax rbp)))
       (conflicts
        ((ra.8 (rax tmp.9 y.2.5 x.1.4 rdi rsi rbp))
         (rbp (rax tmp.9 y.2.5 x.1.4 ra.8))
         (rsi (x.1.4 ra.8))
         (rdi (ra.8))
         (x.1.4 (y.2.5 rsi ra.8 rbp))
         (y.2.5 (x.1.4 ra.8 rbp))
         (tmp.9 (rbp ra.8))
         (rax (ra.8 rbp))))
       (assignment ((ra.8 r15) (x.1.4 r14) (y.2.5 r13) (tmp.9 r14))))
      (begin
        (set! ra.8 r15)
        (set! x.1.4 rdi)
        (set! y.2.5 rsi)
        (set! tmp.9 (+ x.1.4 y.2.5))
        (set! rax tmp.9)
        (jump ra.8 rbp rax)))))

(check-equal? 
(assign-frames
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
     '(module
    (define L.main.3
      ((locals (x.3.6))
       (undead-out
        ((ra.7 rbp)
         ((rax ra.7 rbp)
          ((rsi rbp) (rdi rsi rbp) (rdi rsi r15 rbp) (rdi rsi r15 rbp)))
         (x.3.6 ra.7 rbp)
         (x.3.6 ra.7 rsi rbp)
         (ra.7 rdi rsi rbp)
         (rdi rsi r15 rbp)
         (rdi rsi r15 rbp)))
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
        (set! rbp (+ rbp 8))
        (return-point L.rp.4
          (begin
            (set! rsi 2)
            (set! rdi 1)
            (set! r15 L.rp.4)
            (jump L.L.f1.1.2 rbp r15 rsi rdi)))
        (set! rbp (- rbp 8))
        (set! x.3.6 rax)
        (set! rsi x.3.6)
        (set! rdi x.3.6)
        (set! r15 ra.7)
        (jump L.L.f1.1.2 rbp r15 rsi rdi)))
    (define L.L.f1.1.2
      ((locals (tmp.9 y.2.5 x.1.4 ra.8))
       (undead-out
        ((rdi rsi ra.8 rbp)
         (rsi x.1.4 ra.8 rbp)
         (y.2.5 x.1.4 ra.8 rbp)
         (tmp.9 ra.8 rbp)
         (ra.8 rax rbp)
         (rax rbp)))
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

(check-equal? 
(conflict-analysis
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
        (call-undead (ra.7)))
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
        (call-undead ()))
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

(check-equal? 
(undead-analysis
  '(module
     (define L.main.3
       ((new-frames ()) (locals (x.3.6 ra.7)))
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
       ((new-frames ()) (locals (tmp.9 y.2.5 x.1.4 ra.8)))
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
       (call-undead (ra.7)))
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
       (call-undead ()))
      (begin
        (set! ra.8 r15)
        (set! x.1.4 rdi)
        (set! y.2.5 rsi)
        (set! tmp.9 (+ x.1.4 y.2.5))
        (set! rax tmp.9)
        (jump ra.8 rbp rax)))))