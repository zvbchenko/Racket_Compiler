#lang racket

(require
 racket/set
 racket/format
 "a7-graph-lib.rkt"
 "a7-compiler-lib.rkt"
 "a7-charlie.rkt"
 "a6-charlie.rkt"
 "a7-anton.rkt"
 "a6-anton.rkt")
 

(provide
; uniquify
; implement-safe-primops
;  specify-representation
;  a-normalize
;  select-instructions
;  uncover-locals
;  undead-analysis
;  conflict-analysis
;  pre-assign-frame-variables
;  assign-frames
;  assign-registers
 assign-frame-variables
 discard-call-live
 replace-locations
;  implement-fvars
 expose-basic-blocks
 flatten-program
;  patch-instructions
;  generate-x64
)

; just to run autobot
 (module+ test
  (require rackunit))

#;(module+ main
  (require racket/cmdline)

  (current-pass-list
   (list
    ; check-exprs-lang
    uniquify
    implement-safe-primops
    specify-representation
    ; a-normalize
    ; select-instructions
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
    ; patch-instructions

    generate-x64
    wrap-x64-run-time
    wrap-x64-boilerplate))

  ;; Call your compiler on the command line using:
  ;;   racket a7.rkt fact.a7 /tmp/fact.exe
  (define-values (input output)
    (command-line
     #:args (input-file output-file)
     (values input-file output-file)))

  (with-input-from-file input
    (thunk
     ((nasm-run/observe (curryr copy-directory/files output))
      (compile (read))))))



; (module (define L.main.32 () (begin (set! rsp r15) (set! rdi 40) (set! rsi 8) (set! r15 rsp) (jump L.fact_loop.31))) (define L.L.not.15.16 () (begin (set! rbx r15) (set! rbx rdi) (set! rsp rsp) (if (neq? rsp 6) (jump L.tmp.36) (jump L.tmp.38)))) (define L.L.error?.14.17 () (begin (set! rbx r15) (set! rbx rdi) (set! rsp rsp) (set! rsp (bitwise-and rsp 255)) (set! rsp rsp) (if (eq? rsp 62) (jump L.tmp.40) (jump L.tmp.42)))) (define L.L.ascii-char?.13.18 () (begin (set! rbx r15) (set! rbx rdi) (set! rsp rsp) (set! rsp (bitwise-and rsp 255)) (set! rsp rsp) (if (eq? rsp 46) (jump L.tmp.44) (jump L.tmp.46)))) (define L.L.void?.12.19 () (begin (set! rbx r15) (set! rbx rdi) (set! rsp rsp) (set! rsp (bitwise-and rsp 255)) (set! rsp rsp) (if (eq? rsp 30) (jump L.tmp.48) (jump L.tmp.50)))) (define L.L.empty?.11.20 () (begin (set! rbx r15) (set! rbx rdi) (set! rsp rsp) (set! rsp (bitwise-and rsp 255)) (set! rsp rsp) (if (eq? rsp 22) (jump L.tmp.52) (jump L.tmp.54)))) (define L.L.boolean?.10.21 () (begin (set! rbx r15) (set! rbx rdi) (set! rsp rsp) (set! rsp (bitwise-and rsp 247)) (set! rsp rsp) (if (eq? rsp 6) (jump L.tmp.56) (jump L.tmp.58)))) (define L.L.fixnum?.9.22 () (begin (set! rbx r15) (set! rbx rdi) (set! rsp rsp) (set! rsp (bitwise-and rsp 7)) (set! rsp rsp) (if (eq? rsp 0) (jump L.tmp.60) (jump L.tmp.62)))) (define L.L.>=.8.23 () (begin (set! rcx r15) (set! rsp rsi) (set! rsp rdi) (set! rsp rbx) (set! rsp (bitwise-and rsp 7)) (set! rsp rsp) (if (eq? rsp 0) (jump L.tmp.64) (jump L.tmp.90)))) (define L.L.>.7.24 () (begin (set! rcx r15) (set! rsp rsi) (set! rsp rdi) (set! rsp rbx) (set! rsp (bitwise-and rsp 7)) (set! rsp rsp) (if (eq? rsp 0) (jump L.tmp.116) (jump L.tmp.142)))) (define L.L.<=.6.25 () (begin (set! rcx r15) (set! rsp rsi) (set! rsp rdi) (set! rsp rbx) (set! rsp (bitwise-and rsp 7)) (set! rsp rsp) (if (eq? rsp 0) (jump L.tmp.168) (jump L.tmp.194)))) (define L.L.<.5.26 () (begin (set! rcx r15) (set! rsp rsi) (set! rsp rdi) (set! rsp rbx) (set! rsp (bitwise-and rsp 7)) (set! rsp rsp) (if (eq? rsp 0) (jump L.tmp.220) (jump L.tmp.246)))) (define L.L.-.4.27 () (begin (set! rcx r15) (set! rsp rsi) (set! rsp rdi) (set! rsp rbx) (set! rsp (bitwise-and rsp 7)) (set! rsp rsp) (if (eq? rsp 0) (jump L.tmp.272) (jump L.tmp.290)))) (define L.L.+.3.28 () (begin (set! rcx r15) (set! rsp rsi) (set! rsp rdi) (set! rsp rbx) (set! rsp (bitwise-and rsp 7)) (set! rsp rsp) (if (eq? rsp 0) (jump L.tmp.308) (jump L.tmp.326)))) (define L.L.*.2.29 () (begin (set! rdx r15) (set! rsp rsi) (set! rsp rdi) (set! rsp rcx) (set! rsp (bitwise-and rsp 7)) (set! rsp rsp) (if (eq? rsp 0) (jump L.tmp.344) (jump L.tmp.362)))) (define L.L.eq?.1.30 () (begin (set! rdx r15) (set! rcx rsi) (set! rcx rdi) (set! rsp rsp) (if (eq? rsp rbx) (jump L.tmp.380) (jump L.tmp.382)))) (define L.fact_loop.31 () (begin (set! (rbp + 8) r15) (set! (rbp + 0) rsi) (set! rsp rdi) (set! rbp (+ rbp 16)) (set! rsi rsp) (set! rdi 0) (set! r15 L.rp.33) (jump eq?))) (define L.tmp.37 () (jump rbx)) (define L.tmp.36 () (begin ((set! rax 6)) L.tmp.37)) (define L.tmp.39 () (jump rbx)) (define L.tmp.38 () (begin ((set! rax 14)) L.tmp.39)) (define L.tmp.41 () (jump rbx)) (define L.tmp.40 () (begin ((set! rax 14)) L.tmp.41)) (define L.tmp.43 () (jump rbx)) (define L.tmp.42 () (begin ((set! rax 6)) L.tmp.43)) (define L.tmp.45 () (jump rbx)) (define L.tmp.44 () (begin ((set! rax 14)) L.tmp.45)) (define L.tmp.47 () (jump rbx)) (define L.tmp.46 () (begin ((set! rax 6)) L.tmp.47)) (define L.tmp.49 () (jump rbx)) (define L.tmp.48 () (begin ((set! rax 14)) L.tmp.49)) (define L.tmp.51 () (jump rbx)) (define L.tmp.50 () (begin ((set! rax 6)) L.tmp.51)) (define L.tmp.53 () (jump rbx)) (define L.tmp.52 () (begin ((set! rax 14)) L.tmp.53)) (define L.tmp.55 () (jump rbx)) (define L.tmp.54 () (begin ((set! rax 6)) L.tmp.55)) (define L.tmp.57 () (jump rbx)) (define L.tmp.56 () (begin ((set! rax 14)) L.tmp.57)) (define L.tmp.59 () (jump rbx)) (define L.tmp.58 () (begin ((set! rax 6)) L.tmp.59)) (define L.tmp.61 () (jump rbx)) (define L.tmp.60 () (begin ((set! rax 14)) L.tmp.61)) (define L.tmp.63 () (jump rbx)) (define L.tmp.62 () (begin ((set! rax 6)) L.tmp.63)) (define L.tmp.73 () (jump rcx)) (define L.tmp.72 () (begin ((set! rax 14)) L.tmp.73)) (define L.tmp.75 () (jump rcx)) (define L.tmp.74 () (begin ((set! rax 6)) L.tmp.75)) (define L.tmp.71 () (if (>= rsp rbx) (jump L.tmp.72) (jump L.tmp.74))) (define L.tmp.70 () (begin ((set! rsp rbx)) L.tmp.71)) (define L.tmp.77 () (jump rcx)) (define L.tmp.76 () (begin ((set! rax 3390)) L.tmp.77)) (define L.tmp.69 () (if (neq? rsp 6) (jump L.tmp.70) (jump L.tmp.76))) (define L.tmp.68 () (begin ((set! rsp 14)) L.tmp.69)) (define L.tmp.83 () (jump rcx)) (define L.tmp.82 () (begin ((set! rax 14)) L.tmp.83)) (define L.tmp.85 () (jump rcx)) (define L.tmp.84 () (begin ((set! rax 6)) L.tmp.85)) (define L.tmp.81 () (if (>= rsp rbx) (jump L.tmp.82) (jump L.tmp.84))) (define L.tmp.80 () (begin ((set! rsp rbx)) L.tmp.81)) (define L.tmp.87 () (jump rcx)) (define L.tmp.86 () (begin ((set! rax 3390)) L.tmp.87)) (define L.tmp.79 () (if (neq? rsp 6) (jump L.tmp.80) (jump L.tmp.86))) (define L.tmp.78 () (begin ((set! rsp 6)) L.tmp.79)) (define L.tmp.67 () (if (eq? rsp 0) (jump L.tmp.68) (jump L.tmp.78))) (define L.tmp.66 () (begin ((set! rsp rbx) (set! rsp (bitwise-and rsp 7)) (set! rsp rsp)) L.tmp.67)) (define L.tmp.89 () (jump rcx)) (define L.tmp.88 () (begin ((set! rax 3134)) L.tmp.89)) (define L.tmp.65 () (if (neq? rsp 6) (jump L.tmp.66) (jump L.tmp.88))) (define L.tmp.64 () (begin ((set! rsp 14)) L.tmp.65)) (define L.tmp.99 () (jump rcx)) (define L.tmp.98 () (begin ((set! rax 14)) L.tmp.99)) (define L.tmp.101 () (jump rcx)) (define L.tmp.100 () (begin ((set! rax 6)) L.tmp.101)) (define L.tmp.97 () (if (>= rsp rbx) (jump L.tmp.98) (jump L.tmp.100))) (define L.tmp.96 () (begin ((set! rsp rbx)) L.tmp.97)) (define L.tmp.103 () (jump rcx)) (define L.tmp.102 () (begin ((set! rax 3390)) L.tmp.103)) (define L.tmp.95 () (if (neq? rsp 6) (jump L.tmp.96) (jump L.tmp.102))) (define L.tmp.94 () (begin ((set! rsp 14)) L.tmp.95)) (define L.tmp.109 () (jump rcx)) (define L.tmp.108 () (begin ((set! rax 14)) L.tmp.109)) (define L.tmp.111 () (jump rcx)) (define L.tmp.110 () (begin ((set! rax 6)) L.tmp.111)) (define L.tmp.107 () (if (>= rsp rbx) (jump L.tmp.108) (jump L.tmp.110))) (define L.tmp.106 () (begin ((set! rsp rbx)) L.tmp.107)) (define L.tmp.113 () (jump rcx)) (define L.tmp.112 () (begin ((set! rax 3390)) L.tmp.113)) (define L.tmp.105 () (if (neq? rsp 6) (jump L.tmp.106) (jump L.tmp.112))) (define L.tmp.104 () (begin ((set! rsp 6)) L.tmp.105)) (define L.tmp.93 () (if (eq? rsp 0) (jump L.tmp.94) (jump L.tmp.104))) (define L.tmp.92 () (begin ((set! rsp rbx) (set! rsp (bitwise-and rsp 7)) (set! rsp rsp)) L.tmp.93)) (define L.tmp.115 () (jump rcx)) (define L.tmp.114 () (begin ((set! rax 3134)) L.tmp.115)) (define L.tmp.91 () (if (neq? rsp 6) (jump L.tmp.92) (jump L.tmp.114))) (define L.tmp.90 () (begin ((set! rsp 6)) L.tmp.91

#;(module+ test

(check-equal? 
(generate-x64
(patch-instructions
(flatten-program
(expose-basic-blocks
(implement-fvars
(replace-locations
(discard-call-live
(assign-frame-variables
(assign-registers
(assign-frames
(pre-assign-frame-variables
(conflict-analysis
(undead-analysis
(uncover-locals
(select-instructions
(a-normalize
 (specify-representation
;  (uniquify
    ; (implement-safe-primops 
    `(module (apply cons (if (apply eq? 7 8) (apply * 7 8) (apply * 8 7)) ())))
 ))))))))))))))
 ))
; )))))
 '())


 (generate-x64
 (implement-mops
(patch-instructions
(flatten-program
(expose-basic-blocks
(implement-fvars
(replace-locations
(discard-call-live
(assign-frame-variables
(assign-registers
(assign-frames
(pre-assign-frame-variables
(conflict-analysis
(undead-analysis
(uncover-locals
(expose-allocation-pointer
(select-instructions
(a-normalize
(specify-representation
(implement-safe-primops
    `(module (apply cons (if (apply eq? 7 8) (apply * 7 8) (apply * 8 7)) ())))
 )))))))))))))))))))
 

;  (current-pass-list
;    (list
;     ; check-exprs-lang
;     ; uniquify
;     ; implement-safe-primops
;     specify-representation
;     a-normalize
;     select-instructions
;     uncover-locals
;     undead-analysis
;     conflict-analysis
;     pre-assign-frame-variables
;     assign-frames
;     assign-registers
;     assign-frame-variables
;     discard-call-live
;     replace-locations
;     implement-fvars
;     expose-basic-blocks
;     flatten-program
;     patch-instructions

;     generate-x64
;     wrap-x64-run-time
;     wrap-x64-boilerplate
;     ))

;   ;  (execute `(module (define fact_loop (lambda (n acc) (if (apply eq? n 0) acc (apply fact_loop (apply - n 1) (apply * acc n))))) (apply fact_loop 5 1)))
;    (execute '(module (define L.L.not.15.16 (lambda (x.23.24) (not x.23))) (define L.L.error?.14.17 (lambda (x.22.25) (error? x.22))) (define L.L.ascii-char?.13.18 (lambda (x.21.26) (ascii-char? x.21))) (define L.L.void?.12.19 (lambda (x.20.27) (void? x.20))) (define L.L.empty?.11.20 (lambda (x.19.28) (empty? x.19))) (define L.L.boolean?.10.21 (lambda (x.18.29) (boolean? x.18))) (define L.L.fixnum?.9.22 (lambda (x.17.30) (fixnum? x.17))) (define L.L.>=.8.23 (lambda (x.15.31 y.16.32) (if (fixnum? x.15) (if (fixnum? y.16) (unsafe-fx>= x.15 y.16) (error 13)) (error 12)))) (define L.L.>.7.24 (lambda (x.13.33 y.14.34) (if (fixnum? x.13) (if (fixnum? y.14) (unsafe-fx> x.13 y.14) (error 11)) (error 10)))) (define L.L.<=.6.25 (lambda (x.11.35 y.12.36) (if (fixnum? x.11) (if (fixnum? y.12) (unsafe-fx<= x.11 y.12) (error 9)) (error 8)))) (define L.L.<.5.26 (lambda (x.9.37 y.10.38) (if (fixnum? x.9) (if (fixnum? y.10) (unsafe-fx< x.9 y.10) (error 7)) (error 6)))) (define L.L.-.4.27 (lambda (x.7.39 y.8.40) (if (fixnum? x.7) (if (fixnum? y.8) (unsafe-fx- x.7 y.8) (error 5)) (error 4)))) (define L.L.+.3.28 (lambda (x.5.41 y.6.42) (if (fixnum? x.5) (if (fixnum? y.6) (unsafe-fx+ x.5 y.6) (error 3)) (error 2)))) (define L.L.*.2.29 (lambda (x.3.43 y.4.44) (if (fixnum? x.3) (if (fixnum? y.4) (unsafe-fx* x.3 y.4) (error 1)) (error 0)))) (define L.L.eq?.1.30 (lambda (x.1.45 y.2.46) (eq? x.1 y.2))) (define L.fact_loop.31 (lambda (n.47 acc.48) (if (apply eq? n.47 0) acc.48 (apply L.fact_loop.31 (apply - n.47 1) (apply * acc.48 n.47))))) (apply L.fact_loop.31 5 1))
; )

  
)