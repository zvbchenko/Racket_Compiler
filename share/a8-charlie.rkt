#lang racket

(require
 racket/set
 "util.rkt"
 "a8-graph-lib.rkt"
 "a8-compiler-lib.rkt"
 )

(provide 
    generate-x64
    implement-mops
    patch-instructions
    select-instructions
    implement-fvars)


(module+ test
  (require rackunit))

(require racket/syntax)
; Exercise 1
; Paren-x64-v8 -> x64
; Redesign and extend the implementation of generate-x64 to support index-mode operands.
; The source language is Paren-x64 v8, and output is a sequence of x64 instructions represented as a string.
(define (generate-x64 p) 
  (define label-env (make-hash))

  ; Any -> Boolean
  ; Return true if the given location is valid
  (define (valid-loc? loc)
    (or (register? loc) (valid-addr? loc)))

  (define (valid-register? r)
    (register? r))
  ; (Paren-x64-v3 Program) -> x64
  (define (program->x64 p)
    (match p
      [`(begin ,s ...)
        (map init-label s)
       (string-join (map statement->x64 s) "")]
      [_ (error "Invalid Paren-x64-v3")]))

  (define (init-label s)
    (match s
      [`(define ,label ,sl) #:when (label? label)
        (let ([nl (second (string-split (symbol->string label) "."))])
          (dict-set! label-env label (fresh-label nl)))
        (init-label sl)]
      [else (void)]))

  (define (sanitizer l)
    (if (label? l)
    (let* ([newl (dict-ref label-env l)]
        [ls (string-split (symbol->string newl) ".")])
      (format-symbol "L~a" (last ls))
      )
    l))

  ; (Paren-x64-v3 Statement) -> x64
  (define (statement->x64 s)
  ; (displayln (format "to x64 statement: ~a" s))
    (match s
      [`(set! ,loc ,v)
       #:when (and (valid-loc? loc) (not (list? v)))
       (format "mov ~a, ~a\n  " (loc->x64 loc) (sanitizer v))]
      [`(set! ,reg ,loc)
       #:when (and (valid-register? reg) (valid-loc? loc))
       (format "mov ~a, ~a\n  " reg (loc->x64 loc))]
      [`(set! ,reg (,binop ,reg ,v))
       #:when (and (valid-binop? binop) (int32? v))
       (format "~a ~a, ~a\n  " (binop->ins binop) reg v)]
      [`(set! ,reg (,binop ,reg ,loc))
       #:when (and (valid-binop? binop) (valid-loc? loc))
       (format "~a ~a, ~a\n  " (binop->ins binop) reg (loc->x64 loc))]
      [`(define ,label ,s)
       (format "~a:\n  ~a" (sanitizer label) (statement->x64 s))]
      [`(jump ,trg)
       (format "jmp ~a\n" (sanitizer trg))]
      [`(compare ,reg ,opand)
       (format "cmp ~a, ~a\n  " reg opand)] ;; missing , in cmp
      [`(jump-if ,cmp ,trg)
       (format "~a ~a\n  " (cmp->jmp cmp) (sanitizer trg))]
      [`(nop) ""]
      [_ (error "Invalid Paren-x64-v3 statement" s)]
      ))

  ; (Paren-x64-v3 loc) -> string
  (define (loc->x64 loc)
    (match loc
      [`,reg #:when (valid-register? reg) reg]
      [`(,rbp ,binop ,o) (format "QWORD [~a ~a ~a]" rbp binop o)]
      [_ (error "Invalid loc")])) 

  ; (Paren-x64-v3 binop) -> string
  (define (binop->ins b)
    (match b
      ['+ "add"]
      ['* "imul"]
      ['- "sub"]
      ['arithmetic-shift-right "sar"]
      ['bitwise-and "and"]
      ['bitwise-ior "or"]
      ['bitwise-xor "xor"]
      [_ (error "Invalid binop")]))
  
  ; cmp -> (x64 jump)
  (define (cmp->jmp cmp)
    (match cmp
      ['neq? "jne"]
      ['eq? "je"]
      ['< "jl"]
      ['<= "jle"]
      ['> "jg"]
      ['>= "jge"]
      [_ (error "Invalid cmp")]))


  (string-trim (program->x64 p) "  "))

(module+ test 
 (check-equal? (generate-x64 '(begin (set! r11 (r13 + r10))))
                    "mov r11, QWORD [r13 + r10]\n")

 (check-equal? (generate-x64 '(begin (set! rbx (* rbx (rax + 8)))
                                     (set! rcx (bitwise-and rcx (rcx + rcx)))
                                     (set! rdx (bitwise-xor rdx (rbp + 0)))))
                    "imul rbx, QWORD [rax + 8]\n  and rcx, QWORD [rcx + rcx]\n  xor rdx, QWORD [rbp + 0]\n")

 (check-equal? (generate-x64 '(begin (set! (rsp + rsp) L1)
                                     (set! (r10 + 16) r13)
                                     (set! rcx (bitwise-and rcx (rcx + rcx)))
                                     (set! rdx (bitwise-xor rdx (rbp + 0)))))
                    "mov QWORD [rsp + rsp], L1\n  mov QWORD [r10 + 16], r13\n  and rcx, QWORD [rcx + rcx]\n  xor rdx, QWORD [rbp + 0]\n")
  (check-equal? (generate-x64 '(begin (set! rax (bitwise-and rax 64))
                                         (set! rbx (bitwise-ior rbx rax))
                                         (set! rcx (bitwise-xor rcx (rbp + 8)))
                                         (set! r13 (arithmetic-shift-right r13 (rbp + 16)))))
                                         "and rax, 64\n  or rbx, rax\n  xor rcx, QWORD [rbp + 8]\n  sar r13, QWORD [rbp + 16]\n"
                                         )

  (check-equal? 
    (parameterize ([current-frame-base-pointer-register 'rdi]) (generate-x64 '(begin (set! (rdi + 8) rax))))
    "mov QWORD [rdi + 8], rax\n")

  (check-equal? (generate-x64
  '(begin
     (define L.main.5 (nop))
     (set! rdi 100)
     (nop)
     (jump L.L.f.1.3)
     (define L.L.g.2.4 (nop))
     (set! r14 rdi)
     (set! r13 rsi)
     (set! r14 (+ r14 r13))
     (nop)
     (set! rdi r14)
     (nop)
     (jump L.L.f.1.3)
     (define L.L.f.1.3 (nop))
     (set! r14 rdi)
     (compare r14 10)
     (jump-if > L.nest_t.6)
     (jump L.nest_f.7)
     (define L.nest_t.6 (set! r13 1))
     (set! r14 (- r14 r13))
     (set! rax r14)
     (jump r15)
     (define L.nest_f.7 (set! rsi 1))
     (set! rdi r14)
     (nop)
     (jump L.L.g.2.4)))
 "L.main.5:\n  mov rdi, 100\n  jmp L.L.f.1.3\nL.L.g.2.4:\n  mov r14, rdi\n  mov r13, rsi\n  add r14, r13\n  mov rdi, r14\n  jmp L.L.f.1.3\nL.L.f.1.3:\n  mov r14, rdi\n  cmp r14, 10\n  jg L.nest_t.6\n  jmp L.nest_f.7\nL.nest_t.6:\n  mov r13, 1\n  sub r14, r13\n  mov rax, r14\n  jmp r15\nL.nest_f.7:\n  mov rsi, 1\n  mov rdi, r14\n  jmp L.L.g.2.4\n"
)

  (check-equal? (generate-x64
  '(begin
     (define L.main.5 (nop))
     (set! rdi 100)
     (nop)
     (jump L.L.f.1.3)
     (define L.L.g.2.4 (nop))
     (set! r14 rdi)
     (set! r13 rsi)
     (set! r14 (+ r14 r13))
     (nop)
     (set! rdi r14)
     (nop)
     (jump L.L.f.1.3)
     (define L.L.f.1.3 (nop))
     (set! r14 rdi)
     (compare r14 10)
     (jump-if > L.nest_t.6)
     (jump L.nest_f.7)
     (define L.nest_t.6 (set! r13 1))
     (set! r14 (- r14 r13))
     (set! rax r14)
     (jump r15)
     (define L.nest_f.7 (set! rsi 1))
     (set! rdi r14)
     (nop)
     (jump L.L.g.2.4)))
  "L.main.5:\n  mov rdi, 100\n  jmp L.L.f.1.3\nL.L.g.2.4:\n  mov r14, rdi\n  mov r13, rsi\n  add r14, r13\n  mov rdi, r14\n  jmp L.L.f.1.3\nL.L.f.1.3:\n  mov r14, rdi\n  cmp r14, 10\n  jg L.nest_t.6\n  jmp L.nest_f.7\nL.nest_t.6:\n  mov r13, 1\n  sub r14, r13\n  mov rax, r14\n  jmp r15\nL.nest_f.7:\n  mov rsi, 1\n  mov rdi, r14\n  jmp L.L.g.2.4\n"
  )

  (check-equal?
  (generate-x64
  '(begin
     (define L.main.1 (nop))
     (set! r14 13)
     (set! r13 3)
     (set! r14 (- r14 r13))
     (nop)
     (compare r14 10)
     (jump-if > L.nest_t.2)
     (jump L.nest_f.3)
     (define L.nest_t.2 (set! r14 (+ r14 r14)))
     (set! rax r14)
     (jump r15)
     (define L.nest_f.3 (set! r14 (- r14 r14)))
     (set! rax r14)
     (jump r15)))
    "L.main.1:\n  mov r14, 13\n  mov r13, 3\n  sub r14, r13\n  cmp r14, 10\n  jg L.nest_t.2\n  jmp L.nest_f.3\nL.nest_t.2:\n  add r14, r14\n  mov rax, r14\n  jmp r15\nL.nest_f.3:\n  sub r14, r14\n  mov rax, r14\n  jmp r15\n"
  )

  (check-equal? 
    (generate-x64
    '(begin
      (define L.main.1 (nop))
      (set! r14 13)
      (set! r13 3)
      (set! r14 (- r14 r13))
      (nop)
      (set! rax r14)
      (jump r15)))
  "L.main.1:\n  mov r14, 13\n  mov r13, 3\n  sub r14, r13\n  mov rax, r14\n  jmp r15\n")

  (check-equal? 
    (generate-x64
    '(begin
      (define L.main.3 (set! (rbp + 0) r15))
      (set! rbp (+ rbp 8))
      (set! rsi 2)
      (set! rdi 1)
      (set! r15 L.rp.4)
      (jump L.L.f1.1.2)
      (define L.L.f1.1.2 (nop))
      (set! r14 rdi)
      (set! r13 rsi)
      (set! r14 (+ r14 r13))
      (set! rax r14)
      (jump r15)
      (define L.rp.4 (set! rbp (- rbp 8)))
      (set! r15 rax)
      (set! rsi r15)
      (set! rdi r15)
      (set! r15 (rbp + 0))
      (jump L.L.f1.1.2)))
    "L.main.3:\n  mov QWORD [rbp + 0], r15\n  add rbp, 8\n  mov rsi, 2\n  mov rdi, 1\n  mov r15, L.rp.4\n  jmp L.L.f1.1.2\nL.L.f1.1.2:\n  mov r14, rdi\n  mov r13, rsi\n  add r14, r13\n  mov rax, r14\n  jmp r15\nL.rp.4:\n  sub rbp, 8\n  mov r15, rax\n  mov rsi, r15\n  mov rdi, r15\n  mov r15, QWORD [rbp + 0]\n  jmp L.L.f1.1.2\n"
  )

  (check-equal? (generate-x64
  '(begin
     (define L.main.1 (nop))
     (set! r14 1)
     (set! r13 3)
     (set! r14 (+ r14 r13))
     (set! rax r14)
     (jump r15)))
  "L.main.1:\n  mov r14, 1\n  mov r13, 3\n  add r14, r13\n  mov rax, r14\n  jmp r15\n")
)

; exercise 2
; Paren-x64-mops v8 -> Paren-x64 v8
; implement primitive memory operations, mops, to simplify working with heap addresses.
; reimpose the restriction that an addr must be a displacement-mode operand using the 
; current-frame-base-pointer-register, fbp, as the base.
; default current-frame-base-pointer-register is rbp
(define (implement-mops p) 
    (define (valid-triv? triv)
        (if (or (register? triv) (label? triv) (int64? triv))
            #t 
            #f))
    
    (define (index? index)
        (or (register? index) (number? index)))

    (define (implement-s s) 
  ; (displayln (format "implement-s: ~a" s))
        (match s
            [`(set! ,reg ,triv) #:when (and (register? reg) (or (register? triv) (label? triv) (int64? triv))) s]
            [`(set! ,addr ,triv) #:when (and (mops-addr? addr) (valid-triv? triv)) s]
            [`(set! ,reg1 (,binop ,reg1 ,num)) #:when (and (valid-binop? binop) (register? reg1) (int32? num)) s]
            [`(set! ,reg1 (,binop ,reg1 ,loc)) #:when (and (register? reg1) (valid-binop? binop) (or (mops-addr? loc) (register? loc)))
                s]
            [`(set! ,reg1 (mref ,reg2 ,index))
                 #:when (and (register? reg1) (register? reg2) (or (register? index) (number? index)))
              `(set! ,reg1 (,reg2 + ,index))]
            [`(mset! ,reg ,index ,triv) #:when (and (register? reg) (index? index) (valid-triv? triv))
                `(set! (,reg + ,index) ,triv)]
            [`(define ,label ,s) #:when (label? label)
                `(define ,label ,(implement-s s))]
            [`(jump ,trg) #:when (or (register? trg) (label? trg))
                s]
            [`(compare ,reg ,opand) #:when (and (register? reg) (or (register? opand) (int64? opand))) s]
            [else s]))

      ; (displayln (format "impl mops ~a" p))
    (match p 
        [`(begin ,s ...) `(begin ,@(map implement-s s))])
)

(module+ test
    (check-equal? (implement-mops '(begin (set! r10 10)
                                          (set! r10 L.start.1)
                                          (set! (rbp + 8) 10)
                                          (set! (rbp + 16) L.start.1)))
                `(begin
                    (set! r10 10)
                    (set! r10 L.start.1)
                    (set! (rbp + 8) 10)
                    (set! (rbp + 16) L.start.1)))
    
    (check-equal? (implement-mops '(begin (set! r10 (rbp + 16))
                                          (set! r10 L.start.1)
                                          (set! r10 r11)))
                `(begin (set! r10 (rbp + 16)) (set! r10 L.start.1) (set! r10 r11)))

    (check-equal? (implement-mops '(begin (set! r10 (+ r10 32))
                                          (set! r10 (+ r10 r12))
                                          (set! r10 (* r10 (rbp + 32)))))
                `(begin
                    (set! r10 (+ r10 32))
                    (set! r10 (+ r10 r12))
                    (set! r10 (* r10 (rbp + 32)))))    

    (check-equal? (implement-mops '(begin (set! r10 (rbp + 16))
                                          (set! r10 (mref rbx 8))
                                          (set! r10 (mref rbx rcx))
                                          (mset! rbx 8 123)
                                          (mset! rcx 8 L.start.1)
                                          (mset! rcx 16 rdi)
                                          ))
                `(begin
                    (set! r10 (rbp + 16))
                    (set! r10 (rbx + 8))
                    (set! r10 (rbx + rcx))
                    (set! (rbx + 8) 123)
                    (set! (rcx + 8) L.start.1)
                    (set! (rcx + 16) rdi)))

    (check-equal? (implement-mops '(begin (mset! rbx rdi 123)
                                          (mset! rcx rdi L.start.1)
                                          (mset! rcx rdi rdi)))
                `(begin
                    (set! (rbx + rdi) 123)
                    (set! (rcx + rdi) L.start.1)
                    (set! (rcx + rdi) rdi)))

    (check-equal? (implement-mops '(begin (define L.start.1 (set! rax (mref rbx rdi)))
                                          (define L.start.2 (define L.start.1 (mset! rcx rcx L.start.1)))
                                          (set! r10 r11)))
                `(begin
                    (define L.start.1 (set! rax (rbx + rdi)))
                    (define L.start.2 (define L.start.1 (set! (rcx + rcx) L.start.1)))
                    (set! r10 r11)))

    (check-equal? (implement-mops '(begin (define L.start.1 (set! rax (mref rbx rdi)))
                                          (define L.start.2 (define L.start.1 (mset! rcx rcx L.start.1)))
                                          (jump rax)
                                          (jump L.start.1)
                                          (compare rax 128)
                                          (compare rbx rax)
                                          (jump-if eq? L.start.2)
                                          (set! r10 r11)))
                `(begin
                    (define L.start.1 (set! rax (rbx + rdi)))
                    (define L.start.2 (define L.start.1 (set! (rcx + rcx) L.start.1)))
                    (jump rax)
                    (jump L.start.1)
                    (compare rax 128)
                    (compare rbx rax)
                    (jump-if eq? L.start.2)
                    (set! r10 r11)))

    (check-equal?  (parameterize ([current-frame-base-pointer-register 'rsp])
                        (implement-mops `(begin (set! r10 10)
                                          (set! r10 L.start.1)
                                          (set! (rsp + 8) 10)
                                          (set! (rsp + 16) L.start.1))))
                        '(begin
                            (set! r10 10)
                            (set! r10 L.start.1)
                            (set! (rsp + 8) 10)
                            (set! (rsp + 16) L.start.1)))                    
)


; Exercise 3
; Paren-asm v8 -> Paren-x64-mops v8
; Redesign and extend the implementation of patch-instructions to support mops
; By introducing mops, we implicitly restrict how heap addresses appear in the language and simplify the job of patch-instructions.
; The mops implicitly restrict heap addresses to being part of a move instruction, so we do not have to patch binary operation 
; instructions despite apparently adding a new form of physical location. By making them separate forms, we only need to patch the new
; instructions, and leave old code untouched.
(define (patch-instructions p)

  (define tmp1 (first (current-patch-instructions-registers)))
  (define tmp2 (second (current-patch-instructions-registers)))

  (define (prloc? r)
    (or (mops-addr? r) (register? r)))

  (define (nOrR? r)
    (or (int64? r) (register? r)))

  (define (nORrORl? r)
    (or (int64? r) (register? r) (label? r)))
  
  (define (patch-jump trg)
    (cond 
      [(label? trg) (list `(jump ,trg))]
      [(register? trg) (list `(jump ,trg))]
      [(valid-addr? trg) (list `(set! ,tmp1 ,trg) `(jump ,tmp1))]
      [else (error "patch jump clause error: no matching trg " trg)]))
  
  (define (patch-cmp s)
   (match s 
    [`(compare ,addr1 ,addr2) #:when (and (mops-addr? addr1) (mops-addr? addr2))
      (list `(set! ,tmp1 ,addr2)
            `(set! ,tmp1 (* ,tmp1 -1))
            `(set! ,tmp1 (+ ,tmp1 ,addr1))
            `(compare ,tmp1 0))]
    [`(compare ,addr1 ,v2) #:when (mops-addr? addr1)
      (list `(set! ,tmp1 ,addr1)
            `(compare ,tmp1 ,v2))]
    [`(compare ,v1 ,addr2) #:when (mops-addr? addr2)
      (list `(set! ,tmp1 ,addr2)
            `(compare ,v1 ,tmp1))]
    [`(compare ,v1 ,v2)
      (list s)]))
  

  (define (patch-binop s)
    (match s
      [`(set! ,reg (,binop ,reg ,num)) #:when (and (or (int32? num) (prloc? num)) (register? reg))
        (list s)] 
      [`(set! ,reg (,binop ,reg ,num)) #:when (and (number? num) (register? reg))
        (list `(set! ,tmp1 ,num) `(set! ,reg (,binop ,reg ,tmp1)))] 
      [`(set! ,addr1 (,binop ,addr2 ,num)) #:when (and (or (int32? num) (mops-addr? num) (register? num)) (valid-binop? binop) (prloc? addr1) (prloc? addr2))
        (list `(set! ,tmp1 ,addr2)
              `(set! ,tmp1 (,binop ,tmp1 ,num))
              `(set! ,addr1 ,tmp1))]
      [`(set! ,addr1 (,binop ,addr2 ,num)) #:when (and (int64? num) (valid-binop? binop) (prloc? addr1) (prloc? addr2))
        (list `(set! ,tmp1 ,addr2)
              `(set! ,tmp2 ,num)
              `(set! ,tmp1 (,binop ,tmp1 ,tmp2))
              `(set! ,addr1 ,tmp1))]
      ))

  (define (patch-mref s)
   (match s 
    [`(set! ,r1 (mref ,r2 ,r3)) #:when (and (register? r1) (nOrR? r2) (nOrR? r3))
        (list s)]
    [`(set! ,r1 (mref ,r2 ,r3)) #:when (and (register? r1) (mops-addr? r2) (nOrR? r3))
        (list `(set! ,tmp1 ,r2) `(set! ,r1 (mref ,tmp1 ,r3)))]
    [`(set! ,r1 (mref ,r2 ,r3)) #:when (and (register? r1) (mops-addr? r3) (nOrR? r2))
        (list `(set! ,tmp1 ,r3) `(set! ,r1 (mref ,r2 ,tmp1)))]
    [`(set! ,r1 (mref ,r2 ,r3)) #:when (and (register? r1) (mops-addr? r2) (mops-addr? r3))
        (list `(set! ,tmp1 ,r2) `(set! ,tmp2 ,r3) `(set! ,r1 (mref ,tmp1 ,tmp2)))]
    [`(set! ,r1 (mref ,r2 ,r3)) #:when (and (mops-addr? r1) (nOrR? r2) (nOrR? r3))
        (list `(set! ,tmp1 (mref ,r2 ,r3)) `(set! ,r1 ,tmp1))]
    [`(set! ,r1 (mref ,r2 ,r3)) #:when (and (mops-addr? r1) (mops-addr? r2) (nOrR? r3))
        (list `(set! ,tmp1 ,r2) `(set! ,tmp1 (mref ,tmp1 ,r3)) `(set! ,r1 ,tmp1))]
    [`(set! ,r1 (mref ,r2 ,r3)) #:when (and (mops-addr? r1) (mops-addr? r3) (nOrR? r2))
        (list `(set! ,tmp1 ,r3) `(set! ,tmp1 (mref ,r2 ,tmp1)) `(set! ,r1 ,tmp1))]
    [`(set! ,r1 (mref ,r2 ,r3)) #:when (and (mops-addr? r1) (mops-addr? r2) (mops-addr? r3))
        (list `(set! ,tmp1 ,r2) `(set! ,tmp2 ,r3) `(set! ,tmp1 (mref ,tmp1 ,tmp2)) `(set! ,r1 ,tmp1))]))

  (define (patch-mset s) 
    (match s
      [`(mset! ,v1 ,v2 ,v3) #:when (and (nOrR? v1) (nOrR? v2) (nORrORl? v3)) 
        (list s)]
      [`(mset! ,v1 ,v2 ,v3) #:when (and (nOrR? v1) (mops-addr? v2) (nORrORl? v3))
        (list `(set! ,tmp1 ,v2) `(mset! ,v1 ,tmp1 ,v3))]
      [`(mset! ,v1 ,v2 ,v3) #:when (and (nOrR? v1) (mops-addr? v3) (nOrR? v2))
        (list `(set! ,tmp1 ,v3) `(mset! ,v1 ,v2 ,tmp1))]
      [`(mset! ,v1 ,v2 ,v3) #:when (and (register? v1) (mops-addr? v2) (mops-addr? v3))
        (list `(set! ,tmp1 ,v3) `(set! ,tmp2 ,v2) `(mset! ,v1 ,tmp2 ,tmp1))]
      [`(mset! ,v1 ,v2 ,v3) #:when (and (mops-addr? v1) (nOrR? v2) (nORrORl? v3))
        (list `(set! ,tmp1 ,v1) `(mset! ,tmp1 ,v2 ,v3) )]
      [`(mset! ,v1 ,v2 ,v3) #:when (and (mops-addr? v1) (mops-addr? v2) (nORrORl? v3))
        (list `(set! ,tmp1 ,v1) `(set! ,tmp2 ,v2) `(mset! ,tmp1 ,tmp2 ,v3))]
      [`(mset! ,v1 ,v2 ,v3) #:when (and (mops-addr? v1) (mops-addr? v3) (nOrR? v2))
        (list `(set! ,tmp1 ,v3) `(set! ,tmp2 ,v1) `(mset! ,tmp2 ,v2 ,tmp1))]
      [`(mset! ,v1 ,v2 ,v3) #:when (and (mops-addr? v1) (mops-addr? v2) (mops-addr? v3))
        (list `(set! ,tmp1 ,v1) `(set! ,tmp2 ,v2) `(set! ,tmp1 (+ ,tmp1 ,tmp2)) `(set! ,tmp2 ,v3) `(mset! ,tmp1 0 ,tmp2))]))

  (define (patch-s s) 
    (match s 
      [`(define ,label ,s) 
        (let ([res (patch-s s)])
           (if (> (length res) 1)
            (append `((define ,label ,(first res))) (rest res))
            (list `(define ,label ,(first res)))))]
      [`(jump ,trg) (patch-jump trg)]   
      [`(compare ,rloc ,v2) ; rloc can be addr or reg
        (patch-cmp s)]
      [`(jump-if ,cmp ,label) #:when (and (cmp? cmp) (label? label))
        (list `(jump-if ,cmp ,label))]
      [`(set! ,v1 (,binop ,v2 ,v3)) #:when (valid-binop? binop)
        (patch-binop s)]
      [`(set! ,v1 (mref ,v2 ,v3)) (patch-mref s)]
      [`(mset! ,v1 ,v2 ,v3) (patch-mset s)]
      [`(set! ,addr1 ,addr2) #:when (and (mops-addr? addr1) (mops-addr? addr2))
          (list `(set! ,tmp1 ,addr2) `(set! ,addr1 ,tmp1))]
      [`(set! ,v1 ,v2)
        (list s)]
      [`(nop) (list s)]))
(displayln (format " patch ~a" p))
  (match p 
    [`(begin ,s ...) `(begin ,@(append-map patch-s s))]))

(module+ test
    (check-equal? (patch-instructions `(begin (set! rbx (mref rcx 8))
                                              (set! rbx (mref (rbp + 8) 16))
                                              (set! rbx (mref rcx rdi))
                                              (set! rbx (mref rcx (rbp + 32)))
                                              (set! rcx (mref (rbp + 0) rdi))
                                              (set! rbx (mref (rbp + 8) (rbp + 8)))))
                                    '(begin
                                        (set! rbx (mref rcx 8))
                                        (set! r10 (rbp + 8))
                                        (set! rbx (mref r10 16))
                                        (set! rbx (mref rcx rdi))
                                        (set! r10 (rbp + 32))
                                        (set! rbx (mref rcx r10))
                                        (set! r10 (rbp + 0))
                                        (set! rcx (mref r10 rdi))
                                        (set! r10 (rbp + 8))
                                        (set! r11 (rbp + 8))
                                        (set! rbx (mref r10 r11))))

    (check-equal? (patch-instructions `(begin (set! (rbp + 8) (mref rcx 8))
                                              (set! (rbp + 8) (mref (rbp + 8) 16))
                                              (set! (rbp + 8) (mref rcx rdi))
                                              (set! (rbp + 8) (mref rcx (rbp + 32)))
                                              (set! (rbp + 8) (mref (rbp + 0) rdi))
                                              (set! (rbp + 8) (mref (rbp + 8) (rbp + 8)))))
                                    '(begin
                                            (set! r10 (mref rcx 8))
                                            (set! (rbp + 8) r10)
                                            (set! r10 (rbp + 8))
                                            (set! r10 (mref r10 16))
                                            (set! (rbp + 8) r10)
                                            (set! r10 (mref rcx rdi))
                                            (set! (rbp + 8) r10)
                                            (set! r10 (rbp + 32))
                                            (set! r10 (mref rcx r10))
                                            (set! (rbp + 8) r10)
                                            (set! r10 (rbp + 0))
                                            (set! r10 (mref r10 rdi))
                                            (set! (rbp + 8) r10)
                                            (set! r10 (rbp + 8))
                                            (set! r11 (rbp + 8))
                                            (set! r10 (mref r10 r11))
                                            (set! (rbp + 8) r10)))

    (check-equal? (patch-instructions '(begin (mset! rbx 8 16)
                                              (mset! rbx 8 rcx)
                                              (mset! rbx 8 (rbp + 8))
                                              (mset! rbx rax 16)
                                              (mset! rbx rax rcx)
                                              (mset! rbx rax (rbp + 8))
                                              (mset! rbx (rbp + 16) 16)
                                              (mset! rbx (rbp + 16) rcx)
                                              (mset! rbx (rbp + 16) (rbp + 8)) ))
                                        '(begin
                                            (mset! rbx 8 16)
                                            (mset! rbx 8 rcx)
                                            (set! r10 (rbp + 8))
                                            (mset! rbx 8 r10)
                                            (mset! rbx rax 16)
                                            (mset! rbx rax rcx)
                                            (set! r10 (rbp + 8))
                                            (mset! rbx rax r10)
                                            (set! r10 (rbp + 16))
                                            (mset! rbx r10 16)
                                            (set! r10 (rbp + 16))
                                            (mset! rbx r10 rcx)
                                            (set! r10 (rbp + 8))
                                            (set! r11 (rbp + 16))
                                            (mset! rbx r11 r10)))

    (check-equal? (patch-instructions '(begin (mset! (rbp + 8) 8 16)
                                              (mset! (rbp + 8) 8 rcx)
                                              (mset! (rbp + 8) 8 (rbp + 16))
                                              (mset! (rbp + 8) rax 16)
                                              (mset! (rbp + 8) rax rcx)
                                              (mset! (rbp + 8) rax (rbp + 8))
                                              (mset! (rbp + 8) (rbp + 16) 16)
                                              (mset! (rbp + 8) (rbp + 16) rcx)
                                              (mset! (rbp + 8) (rbp + 16) (rbp + 8)) ))
                                        '(begin
                                            (set! r10 (rbp + 8))
                                            (mset! r10 8 16)
                                            (set! r10 (rbp + 8))
                                            (mset! r10 8 rcx)
                                            (set! r10 (rbp + 16))
                                            (set! r11 (rbp + 8))
                                            (mset! r11 8 r10)
                                            (set! r10 (rbp + 8))
                                            (mset! r10 rax 16)
                                            (set! r10 (rbp + 8))
                                            (mset! r10 rax rcx)
                                            (set! r10 (rbp + 8))
                                            (set! r11 (rbp + 8))
                                            (mset! r11 rax r10)
                                            (set! r10 (rbp + 8))
                                            (set! r11 (rbp + 16))
                                            (mset! r10 r11 16)
                                            (set! r10 (rbp + 8))
                                            (set! r11 (rbp + 16))
                                            (mset! r10 r11 rcx)
                                            (set! r10 (rbp + 8))
                                            (set! r11 (rbp + 16))
                                            (set! r10 (+ r10 r11))
                                            (set! r11 (rbp + 8))
                                            (mset! r10 0 r11)))                                                                              
  
  (check-equal? (patch-instructions `(begin (mset! r11 8 L.start.1)
                                            (mset! (rbp + 8) (rbp + 16) L.start.1)
                                            (mset! rax (rbp + 0) L.start.1)
                                            (mset! (rbp + 16) 32 L.start.1)))
                                       '(begin
                                          (mset! r11 8 L.start.1)
                                          (set! r10 (rbp + 8))
                                          (set! r11 (rbp + 16))
                                          (mset! r10 r11 L.start.1)
                                          (set! r10 (rbp + 0))
                                          (mset! rax r10 L.start.1)
                                          (set! r10 (rbp + 16))
                                          (mset! r10 32 L.start.1)))

(check-equal? (patch-instructions `(begin 
                                       (set! (rbp + 0) (bitwise-and (rbp + 8) 64))
                                       (set! (rbp + 0) (bitwise-ior (rbp + 8) r11))
                                       (set! (rbp + 0) (bitwise-and  (rbp + 8) (rbp + 16)))
                                       (set! (rbp + 0) (bitwise-xor r12 64))
                                       (set! (rbp + 0) (bitwise-ior r12 r13))
                                       (set! (rbp + 0) (bitwise-xor r12 (rbp + 8)))
                                       ))
                                    `(begin
                                        (set! r10 (rbp + 8))
                                        (set! r10 (bitwise-and r10 64))
                                        (set! (rbp + 0) r10)
                                        (set! r10 (rbp + 8))
                                        (set! r10 (bitwise-ior r10 r11))
                                        (set! (rbp + 0) r10)
                                        (set! r10 (rbp + 8))
                                        (set! r10 (bitwise-and r10 (rbp + 16)))
                                        (set! (rbp + 0) r10)
                                        (set! r10 r12)
                                        (set! r10 (bitwise-xor r10 64))
                                        (set! (rbp + 0) r10)
                                        (set! r10 r12)
                                        (set! r10 (bitwise-ior r10 r13))
                                        (set! (rbp + 0) r10)
                                        (set! r10 r12)
                                        (set! r10 (bitwise-xor r10 (rbp + 8)))
                                        (set! (rbp + 0) r10))
                                           "patch bitwise test 1" )
 
      (check-equal? (patch-instructions `(begin 
                                       (set! rcx (bitwise-and (rbp + 8) 64))
                                       (set! rcx (bitwise-ior (rbp + 8) r11))
                                       (set! rcx (bitwise-xor (rbp + 8) (rbp + 16)))
                                       (set! rcx (bitwise-and r12 64))
                                       (set! rcx (bitwise-ior r12 r13))
                                       (set! rcx (bitwise-xor r12 (rbp + 8)))
                                       ))
                                    `(begin
                                        (set! r10 (rbp + 8))
                                        (set! r10 (bitwise-and r10 64))
                                        (set! rcx r10)
                                        (set! r10 (rbp + 8))
                                        (set! r10 (bitwise-ior r10 r11))
                                        (set! rcx r10)
                                        (set! r10 (rbp + 8))
                                        (set! r10 (bitwise-xor r10 (rbp + 16)))
                                        (set! rcx r10)
                                        (set! r10 r12)
                                        (set! r10 (bitwise-and r10 64))
                                        (set! rcx r10)
                                        (set! r10 r12)
                                        (set! r10 (bitwise-ior r10 r13))
                                        (set! rcx r10)
                                        (set! r10 r12)
                                        (set! r10 (bitwise-xor r10 (rbp + 8)))
                                        (set! rcx r10))
                                           "patch bitwise test 2" )

 (check-equal? (patch-instructions `(begin 
                                      (set! (rbp + 0) (bitwise-and (rbp + 8) 2147483648))
                                      ))
                                    `(begin
                                        (set! r10 (rbp + 8))
                                        (set! r11 2147483648)
                                        (set! r10 (bitwise-and r10 r11))
                                        (set! (rbp + 0) r10))
                                           "patch bitwise test int64" )  
  (check-equal? (patch-instructions `(begin 
                                      (set! rax (bitwise-ior rax 2147483648))
                                      ))
                                    `(begin (set! r10 2147483648) (set! rax (bitwise-ior rax r10)))
                                           "patch test int64 2" )  

  (check-equal? (patch-instructions `(begin 
                                      (set! rax (arithmetic-shift-right rax 2147483648))
                                      (set! rax (arithmetic-shift-right (rbp + 16) 0))
                                      (set! rax (arithmetic-shift-right r11 9223372036854775807))
                                      ))
                                    `(begin
                                        (set! r10 2147483648)
                                        (set! rax (arithmetic-shift-right rax r10))
                                        (set! r10 (rbp + 16))
                                        (set! r10 (arithmetic-shift-right r10 0))
                                        (set! rax r10)
                                        (set! r10 r11)
                                        (set! r11 9223372036854775807)
                                        (set! r10 (arithmetic-shift-right r10 r11))
                                        (set! rax r10))
                                           "patch test shift right test" )  

  (check-equal? (patch-instructions `(begin (define L.start.1 (jump rax))))
    '(begin (define L.start.1 (jump rax))))
  
  (check-equal? (patch-instructions `(begin (define L.start.1 (jump L.start.1))))
    '(begin (define L.start.1 (jump L.start.1))))
  
  (check-equal? (patch-instructions `(begin (define L.start.1 (jump (rbp + 800)))))
    `(begin (define L.start.1 (set! r10 (rbp + 800))) (jump r10)))

  (check-equal? (patch-instructions `(begin (define L.start.1 (set! rax 10)) (compare (rbp + 16) (rbp + 32)) (jump-if < L.start.1)
        (jump L.start.2)))
    `(begin
  (define L.start.1 (set! rax 10))
  (set! r10 (rbp + 32))
  (set! r10 (* r10 -1))
  (set! r10 (+ r10 (rbp + 16)))
  (compare r10 0)
  (jump-if < L.start.1)
  (jump L.start.2)))

  (check-equal? (patch-instructions `(begin (define L.start.1 (set! rax 10)) (compare (rbp + 16) r13) (jump-if < L.start.1)
        (jump L.start.2)))
    `(begin
      (define L.start.1 (set! rax 10))
      (set! r10 (rbp + 16))
      (compare r10 r13)
      (jump-if < L.start.1)
      (jump L.start.2)))

  (check-equal? (patch-instructions `(begin (define L.start.1 (set! rax 10)) (compare (rbp + 16) r10) (jump-if < L.start.1)
        (jump L.start.2)))
    `(begin
      (define L.start.1 (set! rax 10))
      (set! r10 (rbp + 16))
      (compare r10 r10)
      (jump-if < L.start.1)
      (jump L.start.2)))

  (check-equal? (patch-instructions `(begin (define L.start.1 (set! r8 1))
                                      (compare r8 0)
                                      (jump-if >= L.start.1)))
                                    `(begin (define L.start.1 (set! r8 1)) (compare r8 0) (jump-if >= L.start.1))
                                           "patch test 1" )

  (check-equal? (patch-instructions `(begin (define L.start.1 (set! r8 1))
                                      (jump (rbp - 8))
                                      (compare r8 0)
                                      (jump-if >= L.start.1)))
                                    `(begin
                                      (define L.start.1 (set! r8 1))
                                      (set! r10 (rbp - 8))
                                      (jump r10)
                                      (compare r8 0)
                                      (jump-if >= L.start.1))
                                           "patch test 2" )

  (check-equal? (patch-instructions `(begin (define L.start.1 (set! r8 1))
                                      (compare r8 (rbp + 8))
                                      (compare (rbp + 16) r10)
                                      (compare (rbp + 8) 66)
                                      (compare (rbp + 16) (rbp + 16))
                                      (compare (rbp + 16) (rbp + 24))
                                      (jump-if >= L.start.1)))
                                    `(begin
                                      (define L.start.1 (set! r8 1))
                                      (set! r10 (rbp + 8))
                                      (compare r8 r10)
                                      (set! r10 (rbp + 16))
                                      (compare r10 r10)
                                      (set! r10 (rbp + 8))
                                      (compare r10 66)
                                      (set! r10 (rbp + 16))
                                      (set! r10 (* r10 -1))
                                      (set! r10 (+ r10 (rbp + 16)))
                                      (compare r10 0)
                                      (set! r10 (rbp + 24))
                                      (set! r10 (* r10 -1))
                                      (set! r10 (+ r10 (rbp + 16)))
                                      (compare r10 0)
                                      (jump-if >= L.start.1))
                                           "patch test 3" )

  (check-equal? (patch-instructions `(begin 
                                       (set! (rbp + 0) (+ (rbp + 8) 64))
                                       (set! (rbp + 0) (+ (rbp + 8) r11))
                                       (set! (rbp + 0) (+ (rbp + 8) (rbp + 16)))
                                       (set! (rbp + 0) (* r12 64))
                                       (set! (rbp + 0) (* r12 r13))
                                       (set! (rbp + 0) (* r12 (rbp + 8)))
                                       ))
                                    `(begin
                                      (set! r10 (rbp + 8))
                                      (set! r10 (+ r10 64))
                                      (set! (rbp + 0) r10)
                                      (set! r10 (rbp + 8))
                                      (set! r10 (+ r10 r11))
                                      (set! (rbp + 0) r10)
                                      (set! r10 (rbp + 8))
                                      (set! r10 (+ r10 (rbp + 16)))
                                      (set! (rbp + 0) r10)
                                      (set! r10 r12)
                                      (set! r10 (* r10 64))
                                      (set! (rbp + 0) r10)
                                      (set! r10 r12)
                                      (set! r10 (* r10 r13))
                                      (set! (rbp + 0) r10)
                                      (set! r10 r12)
                                      (set! r10 (* r10 (rbp + 8)))
                                      (set! (rbp + 0) r10))
                                           "patch test 4" )

  (check-equal? (patch-instructions `(begin 
                                       (set! rcx (+ (rbp + 8) 64))
                                       (set! rcx (+ (rbp + 8) r11))
                                       (set! rcx (+ (rbp + 8) (rbp + 16)))
                                       (set! rcx (* r12 64))
                                       (set! rcx (* r12 r13))
                                       (set! rcx (* r12 (rbp + 8)))
                                       ))
                                    `(begin
                                      (set! r10 (rbp + 8))
                                      (set! r10 (+ r10 64))
                                      (set! rcx r10)
                                      (set! r10 (rbp + 8))
                                      (set! r10 (+ r10 r11))
                                      (set! rcx r10)
                                      (set! r10 (rbp + 8))
                                      (set! r10 (+ r10 (rbp + 16)))
                                      (set! rcx r10)
                                      (set! r10 r12)
                                      (set! r10 (* r10 64))
                                      (set! rcx r10)
                                      (set! r10 r12)
                                      (set! r10 (* r10 r13))
                                      (set! rcx r10)
                                      (set! r10 r12)
                                      (set! r10 (* r10 (rbp + 8)))
                                      (set! rcx r10))
                                           "patch test 5" )

  (check-equal? (patch-instructions `(begin 
                                      (set! (rbp + 0) (+ (rbp + 8) 2147483648))
                                      ))
                                    `(begin
                                        (set! r10 (rbp + 8))
                                        (set! r11 2147483648)
                                        (set! r10 (+ r10 r11))
                                        (set! (rbp + 0) r10))
                                           "patch test int64" )  

  (check-equal? (patch-instructions `(begin 
                                      (set! rax (+ rax 2147483648))
                                      ))
                                    `(begin (set! r10 2147483648) (set! rax (+ rax r10)))
                                           "patch test int64 2" )  
  
  (check-equal? (patch-instructions `(begin 
                                      (set! rax (+ rax 7))
                                      ))
                                    `(begin (set! rax (+ rax 7)))
                                           "patch test int64 2" ) 

  (check-equal? (patch-instructions `(begin 
                                      (define L.z.1 (set! rbx rcx))
                                      (define L.z.2 (set! r11 (+ (rbp + 0) rcx)))
                                      ))
                                    `(begin
                                      (define L.z.1 (set! rbx rcx))
                                      (define L.z.2 (set! r10 (rbp + 0)))
                                      (set! r10 (+ r10 rcx))
                                      (set! r11 r10))
                                           "patch test 7" )   
  (check-equal? (patch-instructions
  '(begin
     (define L.main.3 (set! (rbp + 0) r15))
     (set! rbp (+ rbp 8))
     (set! rsi 2)
     (set! rdi 1)
     (set! r15 L.rp.4)
     (jump L.L.f1.1.2)
     (define L.L.f1.1.2 (nop))
     (set! r14 rdi)
     (set! r13 rsi)
     (set! r14 (+ r14 r13))
     (set! rax r14)
     (jump r15)
     (define L.rp.4 (set! rbp (- rbp 8)))
     (set! r15 rax)
     (set! rsi r15)
     (set! rdi r15)
     (set! r15 (rbp + 0))
     (jump L.L.f1.1.2)))
  '(begin
    (define L.main.3 (set! (rbp + 0) r15))
    (set! rbp (+ rbp 8))
    (set! rsi 2)
    (set! rdi 1)
    (set! r15 L.rp.4)
    (jump L.L.f1.1.2)
    (define L.L.f1.1.2 (nop))
    (set! r14 rdi)
    (set! r13 rsi)
    (set! r14 (+ r14 r13))
    (set! rax r14)
    (jump r15)
    (define L.rp.4 (set! rbp (- rbp 8)))
    (set! r15 rax)
    (set! rsi r15)
    (set! rdi r15)
    (set! r15 (rbp + 0))
    (jump L.L.f1.1.2)))

  (check-equal? (patch-instructions
  '(begin
     (define L.main.1 (nop))
     (set! r14 1)
     (set! r13 3)
     (set! r14 (+ r14 r13))
     (set! rax r14)
     (jump r15)))
 '(begin
    (define L.main.1 (nop))
    (set! r14 1)
    (set! r13 3)
    (set! r14 (+ r14 r13))
    (set! rax r14)
    (jump r15)))

  (check-equal? (patch-instructions
  '(begin
     (define L.main.1 (nop))
     (set! r14 13)
     (set! r13 3)
     (set! r14 (- r14 r13))
     (nop)
     (set! rax r14)
     (jump r15)))
 '(begin
    (define L.main.1 (nop))
    (set! r14 13)
    (set! r13 3)
    (set! r14 (- r14 r13))
    (nop)
    (set! rax r14)
    (jump r15)))
  
  (check-equal? (patch-instructions
  '(begin
     (define L.main.1 (nop))
     (set! r14 13)
     (set! r13 3)
     (set! r14 (- r14 r13))
     (nop)
     (compare r14 10)
     (jump-if > L.nest_t.2)
     (jump L.nest_f.3)
     (define L.nest_t.2 (set! r14 (+ r14 r14)))
     (set! rax r14)
     (jump r15)
     (define L.nest_f.3 (set! r14 (- r14 r14)))
     (set! rax r14)
     (jump r15)))
 '(begin
    (define L.main.1 (nop))
    (set! r14 13)
    (set! r13 3)
    (set! r14 (- r14 r13))
    (nop)
    (compare r14 10)
    (jump-if > L.nest_t.2)
    (jump L.nest_f.3)
    (define L.nest_t.2 (set! r14 (+ r14 r14)))
    (set! rax r14)
    (jump r15)
    (define L.nest_f.3 (set! r14 (- r14 r14)))
    (set! rax r14)
    (jump r15)))

  (check-equal? (patch-instructions
  '(begin
     (define L.main.5 (nop))
     (set! rdi 100)
     (nop)
     (jump L.L.f.1.3)
     (define L.L.g.2.4 (nop))
     (set! r14 rdi)
     (set! r13 rsi)
     (set! r14 (+ r14 r13))
     (nop)
     (set! rdi r14)
     (nop)
     (jump L.L.f.1.3)
     (define L.L.f.1.3 (nop))
     (set! r14 rdi)
     (compare r14 10)
     (jump-if > L.nest_t.6)
     (jump L.nest_f.7)
     (define L.nest_t.6 (set! r13 1))
     (set! r14 (- r14 r13))
     (set! rax r14)
     (jump r15)
     (define L.nest_f.7 (set! rsi 1))
     (set! rdi r14)
     (nop)
     (jump L.L.g.2.4)))
 '(begin
    (define L.main.5 (nop))
    (set! rdi 100)
    (nop)
    (jump L.L.f.1.3)
    (define L.L.g.2.4 (nop))
    (set! r14 rdi)
    (set! r13 rsi)
    (set! r14 (+ r14 r13))
    (nop)
    (set! rdi r14)
    (nop)
    (jump L.L.f.1.3)
    (define L.L.f.1.3 (nop))
    (set! r14 rdi)
    (compare r14 10)
    (jump-if > L.nest_t.6)
    (jump L.nest_f.7)
    (define L.nest_t.6 (set! r13 1))
    (set! r14 (- r14 r13))
    (set! rax r14)
    (jump r15)
    (define L.nest_f.7 (set! rsi 1))
    (set! rdi r14)
    (nop)
    (jump L.L.g.2.4)))

    (check-equal? (patch-instructions
  '(begin
     (define L.main.5 (nop))
     (set! rdi 100)
     (nop)
     (jump L.L.f.1.3)
     (define L.L.g.2.4 (nop))
     (set! r14 rdi)
     (set! r13 rsi)
     (set! r14 (+ r14 r13))
     (nop)
     (set! rdi r14)
     (nop)
     (jump L.L.f.1.3)
     (define L.L.f.1.3 (nop))
     (set! r14 rdi)
     (compare r14 10)
     (jump-if > L.nest_t.6)
     (jump L.nest_f.7)
     (define L.nest_t.6 (set! r13 1))
     (set! r14 (- r14 r13))
     (set! rax r14)
     (jump r15)
     (define L.nest_f.7 (set! rsi 1))
     (set! rdi r14)
     (nop)
     (jump L.L.g.2.4)))
 '(begin
    (define L.main.5 (nop))
    (set! rdi 100)
    (nop)
    (jump L.L.f.1.3)
    (define L.L.g.2.4 (nop))
    (set! r14 rdi)
    (set! r13 rsi)
    (set! r14 (+ r14 r13))
    (nop)
    (set! rdi r14)
    (nop)
    (jump L.L.f.1.3)
    (define L.L.f.1.3 (nop))
    (set! r14 rdi)
    (compare r14 10)
    (jump-if > L.nest_t.6)
    (jump L.nest_f.7)
    (define L.nest_t.6 (set! r13 1))
    (set! r14 (- r14 r13))
    (set! rax r14)
    (jump r15)
    (define L.nest_f.7 (set! rsi 1))
    (set! rdi r14)
    (nop)
    (jump L.L.g.2.4)))

  (check-equal? (parameterize ([current-patch-instructions-registers '(rdi rsi)]) (patch-instructions
  '(begin
     (define L.main.5 (nop))
     (set! rdi 100)
     (nop)
     (jump L.L.f.1.3)
     (define L.L.g.2.4 (nop))
     (set! r14 rdi)
     (set! r13 rsi)
     (set! r14 (+ r14 r13))
     (nop)
     (set! rdi r14)
     (nop)
     (jump L.L.f.1.3)
     (define L.L.f.1.3 (nop))
     (set! r14 rdi)
     (compare r14 10)
     (jump-if > L.nest_t.6)
     (jump L.nest_f.7)
     (define L.nest_t.6 (set! r13 1))
     (set! r14 (- r14 r13))
     (set! rax r14)
     (jump r15)
     (define L.nest_f.7 (set! rsi 1))
     (set! rdi r14)
     (nop)
     (jump L.L.g.2.4))) )
    `(begin
      (define L.main.5 (nop))
      (set! rdi 100)
      (nop)
      (jump L.L.f.1.3)
      (define L.L.g.2.4 (nop))
      (set! r14 rdi)
      (set! r13 rsi)
      (set! r14 (+ r14 r13))
      (nop)
      (set! rdi r14)
      (nop)
      (jump L.L.f.1.3)
      (define L.L.f.1.3 (nop))
      (set! r14 rdi)
      (compare r14 10)
      (jump-if > L.nest_t.6)
      (jump L.nest_f.7)
      (define L.nest_t.6 (set! r13 1))
      (set! r14 (- r14 r13))
      (set! rax r14)
      (jump r15)
      (define L.nest_f.7 (set! rsi 1))
      (set! rdi r14)
      (nop)
      (jump L.L.g.2.4)))

  (check-equal? (patch-instructions '(begin (define L.main.1 (set! rsp r15)) (set! rdi 56) (set! rsi 22) (set! r15 rsp) (jump cons)))
     '(begin
  (define L.main.1 (set! r10 r15))
  (set! rsp r10)
  (set! rdi 56)
  (set! rsi 22)
  (set! r10 rsp)
  (set! r15 r10)
  (set! r10 cons)
  (jump r10)))


  (check-equal? (patch-instructions '(begin (define L.main.1 (set! rsp r15)) (set! rdi 56) (set! rsi 22) (set! r15 rsp) (jump cons) 
(define L.nest_f.17 (set! rax 14)) (jump rsp) 
(define L.nest_t.16 (set! rax 6)) (jump rsp) 
(define L.not.15 (set! rsp r15)) (set! rsp rdi) (set! rsp rsp) (compare rsp 6) (jump-if neq? L.nest_t.16) (jump L.nest_f.17) 
(define L.nest_f.19 (set! rax 6)) (jump rsp) 
(define L.nest_t.18 (set! rax 14)) (jump rsp) 
(define L.error?.14 (set! rsp r15)) (set! rsp rdi) (set! rsp rsp) (set! rsp (bitwise-and rsp 255)) (set! rsp rsp) (compare rsp 62) (jump-if eq? L.nest_t.18) (jump L.nest_f.19) 
(define L.nest_f.21 (set! rax 6)) (jump rsp) 
   ))
   '(begin
  (define L.main.1 (set! r10 r15))
  (set! rsp r10)
  (set! rdi 56)
  (set! rsi 22)
  (set! r10 rsp)
  (set! r15 r10)
  (set! r10 cons)
  (jump r10)
  (define L.nest_f.17 (set! rax 14))
  (jump rsp)
  (define L.nest_t.16 (set! rax 6))
  (jump rsp)
  (define L.not.15 (set! r10 r15))
  (set! rsp r10)
  (set! r10 rdi)
  (set! rsp r10)
  (set! r10 rsp)
  (set! rsp r10)
  (compare rsp 6)
  (jump-if neq? L.nest_t.16)
  (jump L.nest_f.17)
  (define L.nest_f.19 (set! rax 6))
  (jump rsp)
  (define L.nest_t.18 (set! rax 14))
  (jump rsp)
  (define L.error?.14 (set! r10 r15))
  (set! rsp r10)
  (set! r10 rdi)
  (set! rsp r10)
  (set! r10 rsp)
  (set! rsp r10)
  (set! rsp (bitwise-and rsp 255))
  (set! r10 rsp)
  (set! rsp r10)
  (compare rsp 62)
  (jump-if eq? L.nest_t.18)
  (jump L.nest_f.19)
  (define L.nest_f.21 (set! rax 6))
  (jump rsp))
  )

  (check-equal? (patch-instructions '(begin (define L.nest_t.20 (set! rax 14)) (jump rsp) 
(define L.ascii-char?.13 (set! rsp r15)) (set! rsp rdi) (set! rsp rsp) (set! rsp (bitwise-and rsp 255)) (set! rsp rsp) (compare rsp 46) (jump-if eq? L.nest_t.20) (jump L.nest_f.21) 
(define L.nest_f.23 (set! rax 6)) (jump rsp) 
(define L.nest_t.22 (set! rax 14)) (jump rsp) 
(define L.void?.12 (set! rsp r15)) (set! rsp rdi) (set! rsp rsp) (set! rsp (bitwise-and rsp 255)) (set! rsp rsp) (compare rsp 30) (jump-if eq? L.nest_t.22) (jump L.nest_f.23) 
  ))
  '(begin
  (define L.nest_t.20 (set! rax 14))
  (jump rsp)
  (define L.ascii-char?.13 (set! r10 r15))
  (set! rsp r10)
  (set! r10 rdi)
  (set! rsp r10)
  (set! r10 rsp)
  (set! rsp r10)
  (set! rsp (bitwise-and rsp 255))
  (set! r10 rsp)
  (set! rsp r10)
  (compare rsp 46)
  (jump-if eq? L.nest_t.20)
  (jump L.nest_f.21)
  (define L.nest_f.23 (set! rax 6))
  (jump rsp)
  (define L.nest_t.22 (set! rax 14))
  (jump rsp)
  (define L.void?.12 (set! r10 r15))
  (set! rsp r10)
  (set! r10 rdi)
  (set! rsp r10)
  (set! r10 rsp)
  (set! rsp r10)
  (set! rsp (bitwise-and rsp 255))
  (set! r10 rsp)
  (set! rsp r10)
  (compare rsp 30)
  (jump-if eq? L.nest_t.22)
  (jump L.nest_f.23))
  )


  (check-equal? (patch-instructions '(begin (define L.nest_f.25 (set! rax 6)) (jump rsp) 
(define L.nest_t.24 (set! rax 14)) (jump rsp) 
(define L.empty?.11 (set! rsp r15)) (set! rsp rdi) (set! rsp rsp) (set! rsp (bitwise-and rsp 255)) (set! rsp rsp) (compare rsp 22) (jump-if eq? L.nest_t.24) (jump L.nest_f.25) 
(define L.nest_f.27 (set! rax 6)) (jump rsp) 
(define L.nest_t.26 (set! rax 14)) (jump rsp) 
(define L.boolean?.10 (set! rsp r15)) (set! rsp rdi) (set! rsp rsp) (set! rsp (bitwise-and rsp 247)) (set! rsp rsp) (compare rsp 6) (jump-if eq? L.nest_t.26) (jump L.nest_f.27) 
  ))
  '(begin
  (define L.nest_f.25 (set! rax 6))
  (jump rsp)
  (define L.nest_t.24 (set! rax 14))
  (jump rsp)
  (define L.empty?.11 (set! r10 r15))
  (set! rsp r10)
  (set! r10 rdi)
  (set! rsp r10)
  (set! r10 rsp)
  (set! rsp r10)
  (set! rsp (bitwise-and rsp 255))
  (set! r10 rsp)
  (set! rsp r10)
  (compare rsp 22)
  (jump-if eq? L.nest_t.24)
  (jump L.nest_f.25)
  (define L.nest_f.27 (set! rax 6))
  (jump rsp)
  (define L.nest_t.26 (set! rax 14))
  (jump rsp)
  (define L.boolean?.10 (set! r10 r15))
  (set! rsp r10)
  (set! r10 rdi)
  (set! rsp r10)
  (set! r10 rsp)
  (set! rsp r10)
  (set! rsp (bitwise-and rsp 247))
  (set! r10 rsp)
  (set! rsp r10)
  (compare rsp 6)
  (jump-if eq? L.nest_t.26)
  (jump L.nest_f.27))
  )

    (check-equal? (patch-instructions '(begin (define L.nest_f.29 (set! rax 6)) (jump rsp) 
(define L.nest_t.28 (set! rax 14)) (jump rsp) 
(define L.fixnum?.9 (set! rsp r15)) (set! rsp rdi) (set! rsp rsp) (set! rsp (bitwise-and rsp 7)) (set! rsp rsp) (compare rsp 0) (jump-if eq? L.nest_t.28) (jump L.nest_f.29) 
(define L.nest_f.45 (set! rax 3134)) (jump rcx) 
(define L.nest_f.53 (set! rax 3390)) (jump rcx) 
(define L.nest_f.55 (set! rax 6)) (jump rcx) 
(define L.nest_t.54 (set! rax 14)) (jump rcx) 
  ))
  '(begin
  (define L.nest_f.29 (set! rax 6))
  (jump rsp)
  (define L.nest_t.28 (set! rax 14))
  (jump rsp)
  (define L.fixnum?.9 (set! r10 r15))
  (set! rsp r10)
  (set! r10 rdi)
  (set! rsp r10)
  (set! r10 rsp)
  (set! rsp r10)
  (set! rsp (bitwise-and rsp 7))
  (set! r10 rsp)
  (set! rsp r10)
  (compare rsp 0)
  (jump-if eq? L.nest_t.28)
  (jump L.nest_f.29)
  (define L.nest_f.45 (set! rax 3134))
  (jump rcx)
  (define L.nest_f.53 (set! rax 3390))
  (jump rcx)
  (define L.nest_f.55 (set! rax 6))
  (jump rcx)
  (define L.nest_t.54 (set! rax 14))
  (jump rcx))
  )

    (check-equal? (patch-instructions '(begin (define L.nest_t.52 (set! rsp rbx)) (compare rsp rdx) (jump-if >= L.nest_t.54) (jump L.nest_f.55) 
(define L.nest_f.47 (set! rsp 6)) (compare rsp 6) (jump-if neq? L.nest_t.52) (jump L.nest_f.53) 
(define L.nest_f.49 (set! rax 3390)) (jump rcx) 
(define L.nest_f.51 (set! rax 6)) (jump rcx) 
(define L.nest_t.50 (set! rax 14)) (jump rcx) 
(define L.nest_t.48 (set! rsp rbx)) (compare rsp rdx) (jump-if >= L.nest_t.50) (jump L.nest_f.51) 
(define L.nest_t.46 (set! rsp 14)) (compare rsp 6) (jump-if neq? L.nest_t.48) (jump L.nest_f.49) 
  ))
  '(begin
  (define L.nest_t.52 (set! r10 rbx))
  (set! rsp r10)
  (compare rsp rdx)
  (jump-if >= L.nest_t.54)
  (jump L.nest_f.55)
  (define L.nest_f.47 (set! rsp 6))
  (compare rsp 6)
  (jump-if neq? L.nest_t.52)
  (jump L.nest_f.53)
  (define L.nest_f.49 (set! rax 3390))
  (jump rcx)
  (define L.nest_f.51 (set! rax 6))
  (jump rcx)
  (define L.nest_t.50 (set! rax 14))
  (jump rcx)
  (define L.nest_t.48 (set! r10 rbx))
  (set! rsp r10)
  (compare rsp rdx)
  (jump-if >= L.nest_t.50)
  (jump L.nest_f.51)
  (define L.nest_t.46 (set! rsp 14))
  (compare rsp 6)
  (jump-if neq? L.nest_t.48)
  (jump L.nest_f.49))
  )

    (check-equal? (patch-instructions '(begin (define L.nest_t.44 (set! rsp rdx)) (set! rsp (bitwise-and rsp 7)) (set! rsp rsp) (compare rsp 0) (jump-if eq? L.nest_t.46) (jump L.nest_f.47) 
(define L.nest_f.31 (set! rsp 6)) (compare rsp 6) (jump-if neq? L.nest_t.44) (jump L.nest_f.45) 
(define L.nest_f.33 (set! rax 3134)) (jump rcx) 
(define L.nest_f.41 (set! rax 3390)) (jump rcx) 
(define L.nest_f.43 (set! rax 6)) (jump rcx) 
  ))
  '(begin
  (define L.nest_t.44 (set! r10 rdx))
  (set! rsp r10)
  (set! rsp (bitwise-and rsp 7))
  (set! r10 rsp)
  (set! rsp r10)
  (compare rsp 0)
  (jump-if eq? L.nest_t.46)
  (jump L.nest_f.47)
  (define L.nest_f.31 (set! rsp 6))
  (compare rsp 6)
  (jump-if neq? L.nest_t.44)
  (jump L.nest_f.45)
  (define L.nest_f.33 (set! rax 3134))
  (jump rcx)
  (define L.nest_f.41 (set! rax 3390))
  (jump rcx)
  (define L.nest_f.43 (set! rax 6))
  (jump rcx))
  )

    (check-equal? (patch-instructions '(begin (define L.nest_t.42 (set! rax 14)) (jump rcx) 
(define L.nest_t.40 (set! rsp rbx)) (compare rsp rdx) (jump-if >= L.nest_t.42) (jump L.nest_f.43) 
(define L.nest_f.35 (set! rsp 6)) (compare rsp 6) (jump-if neq? L.nest_t.40) (jump L.nest_f.41) 
(define L.nest_f.37 (set! rax 3390)) (jump rcx) 
(define L.nest_f.39 (set! rax 6)) (jump rcx) 
(define L.nest_t.38 (set! rax 14)) (jump rcx) 
  ))
  '(begin
  (define L.nest_t.42 (set! rax 14))
  (jump rcx)
  (define L.nest_t.40 (set! r10 rbx))
  (set! rsp r10)
  (compare rsp rdx)
  (jump-if >= L.nest_t.42)
  (jump L.nest_f.43)
  (define L.nest_f.35 (set! rsp 6))
  (compare rsp 6)
  (jump-if neq? L.nest_t.40)
  (jump L.nest_f.41)
  (define L.nest_f.37 (set! rax 3390))
  (jump rcx)
  (define L.nest_f.39 (set! rax 6))
  (jump rcx)
  (define L.nest_t.38 (set! rax 14))
  (jump rcx))
  )

    (check-equal? (patch-instructions '(begin (define L.nest_t.36 (set! rsp rbx)) (compare rsp rdx) (jump-if >= L.nest_t.38) (jump L.nest_f.39) 
(define L.nest_t.34 (set! rsp 14)) (compare rsp 6) (jump-if neq? L.nest_t.36) (jump L.nest_f.37) 
(define L.nest_t.32 (set! rsp rdx)) (set! rsp (bitwise-and rsp 7)) (set! rsp rsp) (compare rsp 0) (jump-if eq? L.nest_t.34) (jump L.nest_f.35) 
(define L.nest_t.30 (set! rsp 14)) (compare rsp 6) (jump-if neq? L.nest_t.32) (jump L.nest_f.33) 
  ))
  '(begin
  (define L.nest_t.36 (set! r10 rbx))
  (set! rsp r10)
  (compare rsp rdx)
  (jump-if >= L.nest_t.38)
  (jump L.nest_f.39)
  (define L.nest_t.34 (set! rsp 14))
  (compare rsp 6)
  (jump-if neq? L.nest_t.36)
  (jump L.nest_f.37)
  (define L.nest_t.32 (set! r10 rdx))
  (set! rsp r10)
  (set! rsp (bitwise-and rsp 7))
  (set! r10 rsp)
  (set! rsp r10)
  (compare rsp 0)
  (jump-if eq? L.nest_t.34)
  (jump L.nest_f.35)
  (define L.nest_t.30 (set! rsp 14))
  (compare rsp 6)
  (jump-if neq? L.nest_t.32)
  (jump L.nest_f.33))
  )

    (check-equal? (patch-instructions '(begin (define L.>=.8 (set! rcx r15)) (set! rdx rsi) (set! rbx rdi) (set! rsp rbx) (set! rsp (bitwise-and rsp 7)) (set! rsp rsp) (compare rsp 0) (jump-if eq? L.nest_t.30) (jump L.nest_f.31) 
(define L.nest_f.71 (set! rax 2622)) (jump rcx) 
(define L.nest_f.79 (set! rax 2878)) (jump rcx) 
(define L.nest_f.81 (set! rax 6)) (jump rcx) 
(define L.nest_t.80 (set! rax 14)) (jump rcx) 
  ))
  '(begin
  (define L.>=.8 (set! r10 r15))
  (set! rcx r10)
  (set! r10 rsi)
  (set! rdx r10)
  (set! r10 rdi)
  (set! rbx r10)
  (set! r10 rbx)
  (set! rsp r10)
  (set! rsp (bitwise-and rsp 7))
  (set! r10 rsp)
  (set! rsp r10)
  (compare rsp 0)
  (jump-if eq? L.nest_t.30)
  (jump L.nest_f.31)
  (define L.nest_f.71 (set! rax 2622))
  (jump rcx)
  (define L.nest_f.79 (set! rax 2878))
  (jump rcx)
  (define L.nest_f.81 (set! rax 6))
  (jump rcx)
  (define L.nest_t.80 (set! rax 14))
  (jump rcx))
  )

    (check-equal? (patch-instructions '(begin (define L.nest_t.78 (set! rsp rbx)) (compare rsp rdx) (jump-if > L.nest_t.80) (jump L.nest_f.81) 
(define L.nest_f.73 (set! rsp 6)) (compare rsp 6) (jump-if neq? L.nest_t.78) (jump L.nest_f.79) 
(define L.nest_f.75 (set! rax 2878)) (jump rcx) 
(define L.nest_f.77 (set! rax 6)) (jump rcx) 
(define L.nest_t.76 (set! rax 14)) (jump rcx) 
(define L.nest_t.74 (set! rsp rbx)) (compare rsp rdx) (jump-if > L.nest_t.76) (jump L.nest_f.77) 
  ))
  '(begin
  (define L.nest_t.78 (set! r10 rbx))
  (set! rsp r10)
  (compare rsp rdx)
  (jump-if > L.nest_t.80)
  (jump L.nest_f.81)
  (define L.nest_f.73 (set! rsp 6))
  (compare rsp 6)
  (jump-if neq? L.nest_t.78)
  (jump L.nest_f.79)
  (define L.nest_f.75 (set! rax 2878))
  (jump rcx)
  (define L.nest_f.77 (set! rax 6))
  (jump rcx)
  (define L.nest_t.76 (set! rax 14))
  (jump rcx)
  (define L.nest_t.74 (set! r10 rbx))
  (set! rsp r10)
  (compare rsp rdx)
  (jump-if > L.nest_t.76)
  (jump L.nest_f.77))
  )

    (check-equal? (patch-instructions '(begin (define L.nest_t.72 (set! rsp 14)) (compare rsp 6) (jump-if neq? L.nest_t.74) (jump L.nest_f.75) 
(define L.nest_t.70 (set! rsp rdx)) (set! rsp (bitwise-and rsp 7)) (set! rsp rsp) (compare rsp 0) (jump-if eq? L.nest_t.72) (jump L.nest_f.73) 
(define L.nest_f.57 (set! rsp 6)) (compare rsp 6) (jump-if neq? L.nest_t.70) (jump L.nest_f.71) 
(define L.nest_f.59 (set! rax 2622)) (jump rcx) 
(define L.nest_f.67 (set! rax 2878)) (jump rcx) 
  ))
  '(begin
  (define L.nest_t.72 (set! rsp 14))
  (compare rsp 6)
  (jump-if neq? L.nest_t.74)
  (jump L.nest_f.75)
  (define L.nest_t.70 (set! r10 rdx))
  (set! rsp r10)
  (set! rsp (bitwise-and rsp 7))
  (set! r10 rsp)
  (set! rsp r10)
  (compare rsp 0)
  (jump-if eq? L.nest_t.72)
  (jump L.nest_f.73)
  (define L.nest_f.57 (set! rsp 6))
  (compare rsp 6)
  (jump-if neq? L.nest_t.70)
  (jump L.nest_f.71)
  (define L.nest_f.59 (set! rax 2622))
  (jump rcx)
  (define L.nest_f.67 (set! rax 2878))
  (jump rcx))
  )

    (check-equal? (patch-instructions '(begin 
    (define L.nest_f.69 (set! rax 6)) (jump rcx) 
(define L.nest_t.68 (set! rax 14)) (jump rcx) 
(define L.nest_t.66 (set! rsp rbx)) (compare rsp rdx) (jump-if > L.nest_t.68) (jump L.nest_f.69) 
(define L.nest_f.61 (set! rsp 6)) (compare rsp 6) (jump-if neq? L.nest_t.66) (jump L.nest_f.67) 
(define L.nest_f.63 (set! rax 2878)) (jump rcx) 
(define L.nest_f.65 (set! rax 6)) (jump rcx) 
(define L.nest_t.64 (set! rax 14)) (jump rcx) 
  ))
  '(begin
  (define L.nest_f.69 (set! rax 6))
  (jump rcx)
  (define L.nest_t.68 (set! rax 14))
  (jump rcx)
  (define L.nest_t.66 (set! r10 rbx))
  (set! rsp r10)
  (compare rsp rdx)
  (jump-if > L.nest_t.68)
  (jump L.nest_f.69)
  (define L.nest_f.61 (set! rsp 6))
  (compare rsp 6)
  (jump-if neq? L.nest_t.66)
  (jump L.nest_f.67)
  (define L.nest_f.63 (set! rax 2878))
  (jump rcx)
  (define L.nest_f.65 (set! rax 6))
  (jump rcx)
  (define L.nest_t.64 (set! rax 14))
  (jump rcx))
  )
)

; Exercise 4
;; TODO  minor changes to support mops. Note that we assume the fbp is not modified by mops.
(define (implement-fvars p)
  (define rbp-offset 0)

  (define (eval-binop b)
    (match b 
      ['+ +]
      ['- -]
      ))

;  we requires that current-frame-base-pointer-register is assigned only by 
;  incrementing or decrementing it by an integer literal
  (define (implement-s s)
    (match s
      [`(return-point ,label ,tail)
          `(return-point ,(to-addr label) ,(implement-tail tail))]
      [`(set! ,rbp (,binop ,rbp ,num)) #:when (and (valid-binop? binop) (int64? num) (equal? rbp (current-frame-base-pointer-register)))
        (set! rbp-offset ((eval-binop binop) rbp-offset num))
        s]
      [`(set! ,v1 (,binop ,v2 ,v3)) #:when (valid-binop? binop)
        `(set! ,(to-addr v1) (,binop ,(to-addr v2) ,(to-addr v3)))]
      [`(set! ,v1 (mref ,v2 ,v3)) `(set! ,(to-addr v1) (mref ,(to-addr v2) ,(to-addr v3)))]
      [`(set! ,v1 ,v2) 
        `(set! ,(to-addr v1) ,(to-addr v2))]
      [`(mset! ,v1 ,v2 ,v3)
          `(mset! ,(to-addr v1) ,(to-addr v2) ,(to-addr v3))]
        
      [else s]))

  (define (implement-tail t)
    (match t 
      [`(begin ,s ... ,tail)
          `(begin ,@(map implement-s s) ,(implement-tail tail))]
      [`(jump ,fv)
          `(jump ,(to-addr fv))]
      [`(if (,cmp ,v1 ,v2) ,t1 ,t2) #:when (cmp? cmp)
          `(if (,cmp ,(to-addr v1) ,(to-addr v2)) ,(implement-tail t1) ,(implement-tail t2))]
    ))

  (define (to-addr v)
    (if (fvar? v)
        (fvar->addr rbp-offset v)
        v))

  (define (implement-b b)
    (match b
      [`(define ,label ,info ,tail)
          `(define ,label ,info ,(implement-tail tail))])
  )

  (match p
    [`(module ,bs ...)
        `(module ,@(map implement-b bs))])
)

(module+ test
  (check-equal? (implement-fvars '(module
  (define L.main.4
    ()
    (begin
      (nop)
      (set! r14 56)
      (set! r13 r12)
      (set! r12 (+ r12 16))
      (set! r13 (+ r13 1))
      (nop)
      (mset! r13 -1 r14)
      (mset! r13 7 22)
      (set! rax r13)
      (jump r15)))))
      '(module
  (define L.main.4
    ()
    (begin
      (nop)
      (set! r14 56)
      (set! r13 r12)
      (set! r12 (+ r12 16))
      (set! r13 (+ r13 1))
      (nop)
      (mset! r13 -1 r14)
      (mset! r13 7 22)
      (set! rax r13)
      (jump r15)))))
      
  (check-equal? (implement-fvars '(module
  (define L.main.4
    ()
    (begin
      (set! fv1 r15)
      (set! r15 12)
      (mset! r15 15 4)
      (set! rbp (+ rbp 16))
      (return-point L.rp.5
        (begin (set! rdi r14) (set! r15 L.rp.5) (jump L.start.1)))
      (set! rbp (- rbp 16))
      (set! r14 rax)
      (mset! r14 14 3)
      (set! rbp (+ rbp 16))
      (return-point L.rp.6
        (begin (set! rdi fv0) (set! r15 L.rp.6) (jump L.start.2)))
      (set! rbp (- rbp 16))
      (set! fv0 rax)
      (set! r15 (+ fv0 4))
      (set! rax r15)
      (jump fv1)))))
      '(module
  (define L.main.4
    ()
    (begin
      (set! (rbp + 8) r15)
      (set! r15 12)
      (mset! r15 15 4)
      (set! rbp (+ rbp 16))
      (return-point L.rp.5
        (begin (set! rdi r14) (set! r15 L.rp.5) (jump L.start.1)))
      (set! rbp (- rbp 16))
      (set! r14 rax)
      (mset! r14 14 3)
      (set! rbp (+ rbp 16))
      (return-point L.rp.6
        (begin (set! rdi (rbp + -16)) (set! r15 L.rp.6) (jump L.start.2)))
      (set! rbp (- rbp 16))
      (set! (rbp + 0) rax)
      (set! r15 (+ (rbp + 0) 4))
      (set! rax r15)
      (jump (rbp + 8))))))

  (check-equal? (implement-fvars '(module
  (define L.main.4
    ()
    (begin
      (set! fv1 r15)
      (set! r15 12)
      (mset! r15 15 4)
      (set! rbp (+ rbp 16))
      (return-point L.rp.5
        (begin (set! rdi r14) (set! r15 L.rp.5) (jump L.start.1)))
      (set! rbp (- rbp 16))
      (set! r14 rax)
      (mset! r14 14 3)
      (set! rbp (+ rbp 16))
      (return-point L.rp.6
        (begin (set! rdi fv0) (set! r15 L.rp.6) (jump L.start.2)))
      (set! rbp (- rbp 16))
      (set! fv0 rax)
      (set! r15 (+ fv0 4))
      (set! rax r15)
      (jump fv1)))))
      `(module
  (define L.main.4
    ()
    (begin
      (set! (rbp + 8) r15)
      (set! r15 12)
      (mset! r15 15 4)
      (set! rbp (+ rbp 16))
      (return-point L.rp.5
        (begin (set! rdi r14) (set! r15 L.rp.5) (jump L.start.1)))
      (set! rbp (- rbp 16))
      (set! r14 rax)
      (mset! r14 14 3)
      (set! rbp (+ rbp 16))
      (return-point L.rp.6
        (begin (set! rdi (rbp + -16)) (set! r15 L.rp.6) (jump L.start.2)))
      (set! rbp (- rbp 16))
      (set! (rbp + 0) rax)
      (set! r15 (+ (rbp + 0) 4))
      (set! rax r15)
      (jump (rbp + 8))))))

  (check-equal? (implement-fvars '(module
  (define L.main.4
    ()
    (begin
      (set! fv0 r15)
      (set! r15 12)
      (mset! r15 15 4)
      (set! fv1 (mref fv1 8))
      (mset! fv1 14 3)
      (set! rbp (+ rbp 16))
      (return-point L.rp.5
        (begin (set! rdi r14) (set! r15 L.rp.5) (jump L.start.2)))
      (set! rbp (- rbp 16))
      (set! r14 rax)
      (set! r15 fv1)
      (set! rax r12)
      (set! r12 (+ r12 r15))
      (jump fv0)))))
      '(module
  (define L.main.4
    ()
    (begin
      (set! (rbp + 0) r15)
      (set! r15 12)
      (mset! r15 15 4)
      (set! (rbp + 8) (mref (rbp + 8) 8))
      (mset! (rbp + 8) 14 3)
      (set! rbp (+ rbp 16))
      (return-point L.rp.5
        (begin (set! rdi r14) (set! r15 L.rp.5) (jump L.start.2)))
      (set! rbp (- rbp 16))
      (set! r14 rax)
      (set! r15 (rbp + 8))
      (set! rax r12)
      (set! r12 (+ r12 r15))
      (jump (rbp + 0))))))



)


;; Exercise 6
;  Impure-Values-bits-lang v8 -> Block-lang v8
; Redesign and extend the implementation of the function select-instructions.
; we introduce a notion of effectful, or impure, computation into the language.
;  Previously, all expressions in the Values-lang languages were pure—they evaluated and produced
;  the same value regardless of in which order expressions were evaluated. 
; introduce a contextual distinction in the language. We add the nonterminal c to represent an impure computation.
;  A c represents an expression that does not have a value, and is executed only for its effect
(define (select-instructions p)
    (define return-loc (fresh 'ra))
    ;  fv_0 ... fv_k-1 are the first k frame variables, i.e., locations on this function’s frame. 
    (define frames empty)
    
    (define (valid-v? v) (or (aloc? v) (int64? v) (label? v)) )
    ; The info field records all the new frames created in the block

    (define (select-n n res-loc)
      (match n 
        [`,num #:when (int64? num) (list `(set! ,res-loc ,num))]
        [`,v #:when (aloc? v) (list `(set! ,res-loc ,v))]
        [`,v #:when (or (prim-f? v) (valid-binop? v)) (list `(set! ,res-loc ,v))] ; TODO might be error here
        [`(alloc ,v) #:when (or (aloc? v) (int64? v) (label? v)) 
            (list `(set! ,res-loc ,n))]
        [`(mref ,v1 ,v2) #:when (and (valid-v? v1) (valid-v? v2))
          (list `(set! ,res-loc ,n))]
        [`(,binop ,v1 ,v2) #:when (and (valid-binop? binop) (aloc? v1))
          (let ([new-loc (fresh)])
              (append (list `(set! ,new-loc (,binop ,v1 ,v2)) `(set! ,res-loc ,new-loc))))]
        [`(,binop ,v1 ,v2) #:when (valid-binop? binop)
          (let* ([res1 (fresh)])
              (append (select-n v1 res1) (list `(set! ,res-loc (,binop ,res1 ,v2)))))]
        [`(apply ,f ,vs ...) 
          (let* ([rp (fresh-label 'rp)]
                 [reglist (current-parameter-registers)]
                 [assigned-list (assign-n vs reglist)])
            (list `(return-point ,rp
                      (begin 
                        ,@(map (lambda (x y) `(set! ,x ,y)) assigned-list (reverse vs))
                         (set! ,(current-return-address-register) ,rp)
                         (jump ,f ,(current-frame-base-pointer-register) ,(current-return-address-register) ,@assigned-list))
                         )
                  `(set! ,res-loc ,(current-return-value-register))))]
        [`,c #:when (ascii-char-literal? c) (list `(set! ,res-loc ,c))]
      ))

    (define (assign-n vs regs)
      (define (apply-assign-loc vs res)
        (if (empty? vs)
            res
            (apply-assign-loc (rest vs) (cons (fresh 'nfv) res)))
      )

      (if (<= (length vs) (length regs))
          (apply-assign-reg vs regs)
          (let ([ass-reg (apply-assign-reg (take vs (length regs)) regs)]
                [ass-loc (apply-assign-loc (take-right vs (- (length vs) (length regs))) empty)])
              (set! frames (cons ass-loc frames))
              (append ass-loc ass-reg)))
          )
    
    (define (select-b b)
      (local [
        (define return-loc (fresh 'ra))

        (define counter -1)

        (define (make-args-impl args regs res)
          (if (empty? args)
              res
              (if (empty? regs)
                  (begin
                    (set! counter (add1 counter))
                    (make-args-impl (rest args) regs (cons `(set! ,(first args) ,(make-fvar counter)) res)))
                  (make-args-impl (rest args) (rest regs) (cons `(set! ,(first args) ,(first regs)) res)))))
      ]
      (set! frames empty)
      (match b
        [`(define ,func (lambda (,args ...) ,e)) #:when (label? func)
          (let ([cont (select-e-impl e return-loc)]
                [reglist (current-parameter-registers)]
                [cframe (if (empty? frames)
                              frames
                              (reverse (append frames)))])
          `(define ,func ((new-frames  ,cframe)) 
            (begin (set! ,return-loc ,(current-return-address-register)) ,@(reverse (make-args-impl args reglist empty)) ,@cont) ))])
      ))


    (define (select-c c) 
      (match c 
        [`(let ([,a ,n]) ,c2) #:when (aloc? a)
          `(,@(select-n n a)
            ,@(select-c c2))]
        [`(begin ,cs ...) `(,@(apply append (map select-c cs)))]
        [`(mset! ,v1 ,v2 ,v3) (list c)]))

    (define (select-e-impl e tmp-rp)
      (match e 
       [`,num #:when (int64? num) 
            `((set! ,(current-return-value-register) ,num)
              (jump ,tmp-rp,(current-frame-base-pointer-register) ,(current-return-value-register)))]
       [`,v #:when (aloc? v) 
            `((set! ,(current-return-value-register) ,v)
              (jump ,tmp-rp ,(current-frame-base-pointer-register) ,(current-return-value-register)))]
       [`(alloc ,v) #:when (or (aloc? v) (int64? v) (label? v))
          `((set! ,(current-return-value-register) ,e)
              (jump ,tmp-rp ,(current-frame-base-pointer-register) ,(current-return-value-register)))]
       [`(mref ,v1 ,v2) #:when (and (valid-v? v1) (valid-v? v2))
        `((set! ,(current-return-value-register) ,e)
              (jump ,tmp-rp ,(current-frame-base-pointer-register) ,(current-return-value-register)))]
       [`(,binop ,v1 ,v2) #:when (valid-binop? binop)
          (let ([res-loc (fresh)])
               `(,@(select-n e res-loc)
                (set! ,(current-return-value-register) ,res-loc)
                (jump ,tmp-rp ,(current-frame-base-pointer-register) ,(current-return-value-register)))
          )]
       [`(let ([,x ,n]) ,e) ;#:when (aloc? x)
          `(,@(select-n n x)
            ,@(select-e-impl e tmp-rp))]
        [`(if (,cmp ,v1 ,v2) ,e1 ,e2) #:when (and (cmp? cmp) (aloc? v1))
            `((if (,cmp ,v1 ,v2)
                  (begin ,@(select-e-impl e1 tmp-rp))
                  (begin ,@(select-e-impl e2 tmp-rp))))]
       [`(if (,cmp ,v1 ,v2) ,e1 ,e2) #:when (cmp? cmp)
            (let ([tmp (fresh)])
              `((set! ,tmp ,v1)
                (if (,cmp ,tmp ,v2)
                  (begin ,@(select-e-impl e1 tmp-rp))
                  (begin ,@(select-e-impl e2 tmp-rp)))))]
       [`(begin ,cs ... ,e) 
          `(,@(apply append (map select-c cs)) ,@(select-e-impl e tmp-rp))]
    ;  We want limit the live ranges of registers to help the register allocator makes better use of registers, 
    ; we should generate accesses to registers last to limit their live ranges. Loading the return address register 
    ; last can also help limit its live range for simple functions.
        [`(apply ,f ,vs ...)
          (let* ([reglist (current-parameter-registers)]
                 [assigned-reg (reverse (apply-assign-reg vs reglist))]
                 [assigned-frame (reverse (apply-assign-frame vs reglist))])
                ;  (displayln (format "assigned: ~a" assigned))
            `(,@(reverse (map (lambda (x y) `(set! ,x ,y)) assigned-frame (take-right vs (length assigned-frame))))
              ,@(reverse (map (lambda (x y) `(set! ,x ,y)) assigned-reg (take vs (length assigned-reg))))
                (set! ,(current-return-address-register) ,tmp-rp)
                (jump ,f ,(current-frame-base-pointer-register) ,(current-return-address-register) ,@assigned-frame ,@(reverse assigned-reg))))]
       ))
    
    (define (apply-assign-reg vs regs)
      (local [(define (apply-impl vs regs res)
                (if (empty? regs)
                    res
                    (apply-impl (rest vs) (rest regs) (cons (first regs) res))))]
        (if (> (length vs) (length regs))
          (apply-impl (take-right vs (length regs)) regs empty)
          (apply-impl vs (take regs (length vs)) empty))
        )
    )


    (define (apply-assign-frame vs regs)
      (local [(define counter -1)
        (define (assign-impl vs res)
           (if (empty? vs)
              res
              (begin (set! counter (add1 counter))
                (assign-impl (rest vs) (cons (make-fvar counter) res)))
                  ))
      ]
      (if (> (length vs) (length regs))
          (assign-impl (take vs (- (length vs) (length regs))) empty)
          empty))
     )

    (define (select-e e)
      (set! frames empty)
      (match e 
        [`,num #:when (int64? num) 
            `(begin
                (set! ,return-loc ,(current-return-address-register))
                (set! ,(current-return-value-register) ,num)
                (jump ,return-loc ,(current-frame-base-pointer-register) ,(current-return-value-register)))]
        [`,v #:when (symbol? v)
            `(begin
                (set! ,return-loc ,(current-return-address-register))
                (set! ,(current-return-value-register) ,v)
                (jump ,return-loc ,(current-frame-base-pointer-register) ,(current-return-value-register)))]
        [`(alloc ,v) #:when (or (aloc? v) (int64? v) (label? v))
          `(begin
                (set! ,return-loc ,(current-return-address-register))
                (set! ,(current-return-value-register) ,e)
                (jump ,return-loc ,(current-frame-base-pointer-register) ,(current-return-value-register)))]
        [`(mref ,v1 ,v2) #:when (and (valid-v? v1) (valid-v? v2))
          `(begin
                (set! ,return-loc ,(current-return-address-register))
                (set! ,(current-return-value-register) ,e)
                (jump ,return-loc ,(current-frame-base-pointer-register) ,(current-return-value-register)))]
        [`(,binop ,v1 ,v2) #:when (valid-binop? binop)
          (let* ([res-loc (fresh)])
            `(begin
                (set! ,return-loc ,(current-return-address-register))
                ,@(select-n e res-loc)
                (set! ,(current-return-value-register) ,res-loc)
                (jump ,return-loc ,(current-frame-base-pointer-register) ,(current-return-value-register)))
          )]
        [`(let ([,x ,n]) ,e) #:when (aloc? x)
          `(begin
                (set! ,return-loc ,(current-return-address-register))
                ,@(select-n n x)
                ,@(select-e-impl e return-loc))
        ]
        [`(if (,cmp ,v1 ,v2) ,e1 ,e2) #:when (and (cmp? cmp) (aloc? v1))
           `(begin
                (set! ,return-loc ,(current-return-address-register))
                (if (,cmp ,v1 ,v2)
                  (begin ,@(select-e-impl e1 return-loc))
                  (begin ,@(select-e-impl e2 return-loc))))]
        [`(if (,cmp ,v1 ,v2) ,e1 ,e2) #:when (cmp? cmp)
          (let ([tmp (fresh)])
           `(begin
                (set! ,return-loc ,(current-return-address-register))
                (set! ,tmp ,v1)
                (if (,cmp ,tmp ,v2)
                  (begin ,@(select-e-impl e1 return-loc))
                  (begin ,@(select-e-impl e2 return-loc)))))]
        [`(apply ,f ,vs ...)
          `(begin (set! ,return-loc ,(current-return-address-register))
                  ,@(select-e-impl e return-loc))]
        [`(begin ,cs ... ,e)
          `(begin 
              (set! ,return-loc ,(current-return-address-register))
              ,@(apply append (map select-c cs))
              ,@(select-e-impl e return-loc))]                             
      ))


    (displayln (format "select intr: ~a" p))
    (match p 
      [`(module ,bs ... ,e)
        (let ([e-res (select-e e)])
          `(module (define ,(fresh-label 'main) ((new-frames ,frames)) ,e-res) ,@(map select-b bs)))]
    )
)

(module+ test 
  (check-equal? (select-instructions `(module (begin (let ([a.1 12]) (mset! a.1 15 4)) 
                                                     (let ([a.2 (apply L.start.1 a.2)]) (mset! a.2 14 3))
                                                     (let ([a.3 (apply L.start.2 a.3)]) (+ a.3 4)))))
                                     '(module
                                        (define L.main.3
                                          ((new-frames ()))
                                          (begin
                                            (set! ra.1 r15)
                                            (set! a.1 12)
                                            (mset! a.1 15 4)
                                            (return-point L.rp.1
                                              (begin (set! rdi a.2) (set! r15 L.rp.1) (jump L.start.1 rbp r15 rdi)))
                                            (set! a.2 rax)
                                            (mset! a.2 14 3)
                                            (return-point L.rp.2
                                              (begin (set! rdi a.3) (set! r15 L.rp.2) (jump L.start.2 rbp r15 rdi)))
                                            (set! a.3 rax)
                                            (set! tmp.3 a.3)
                                            (set! tmp.2 (+ tmp.3 4))
                                            (set! rax tmp.2)
                                            (jump ra.1 rbp rax))))
    )

  (check-equal? (select-instructions `(module (if (< 12 3) 
                                                  (+ 1 2)
                                                  (if (> 12 3)
                                                      1
                                                      2))))
                                    	'(module	
   (define L.main.4	
     ((new-frames ()))	
     (begin	
       (set! ra.4 r15)	
       (set! tmp.5 12)	
       (if (< tmp.5 3)	
         (begin	
           (set! tmp.7 1)	
           (set! tmp.6 (+ tmp.7 2))	
           (set! rax tmp.6)	
           (jump ra.4 rbp rax))	
         (begin	
           (set! tmp.8 12)	
           (if (> tmp.8 3)	
             (begin (set! rax 1) (jump ra.4 rbp rax))	
             (begin (set! rax 2) (jump ra.4 rbp rax)))))))))

  (check-equal? (select-instructions `(module (let ([b.1 99])
                                                (if (neq? 12 b.1)
                                                    (begin (apply L.start.1 b.1 9))
                                                    (if (eq? b.1 9)
                                                        (apply L.start.1 9 9)
                                                        (apply L.start.1 b.1 b.1))))))
                                      '(module
   (define L.main.5
     ((new-frames ()))
     (begin
       (set! ra.9 r15)
       (set! b.1 99)
       (set! tmp.10 12)
       (if (neq? tmp.10 b.1)
         (begin
           (set! rdi b.1)
           (set! rsi 9)
           (set! r15 ra.9)
           (jump L.start.1 rbp r15 rdi rsi))
         (begin
           (set! tmp.11 b.1)
           (if (eq? tmp.11 9)
             (begin
               (set! rdi 9)
               (set! rsi 9)
               (set! r15 ra.9)
               (jump L.start.1 rbp r15 rdi rsi))
             (begin
               (set! rdi b.1)
               (set! rsi b.1)
               (set! r15 ra.9)
               (jump L.start.1 rbp r15 rdi rsi))))))))
)


  (check-equal? (select-instructions `(module (define L.start.1 (lambda (a.1 a.2) 
                                                                          (begin (mset! a.1 a.2 8)
                                                                                 (begin (let ([a.1 (apply L.start.1 12 3)])
                                                                                          (begin (mset! a.1 a.1 a.2))))
                                                                                  (+ a.1 a.2))))
                                              (let ([b.1 99])
                                                (if (neq? 12 b.1)
                                                    (begin (apply L.start.1 b.1 9))
                                                    (if (eq? b.1 9)
                                                        (apply L.start.1 9 9)
                                                        (apply L.start.1 b.1 b.1))))))
                                      '(module
   (define L.main.6
     ((new-frames ()))
     (begin
       (set! ra.12 r15)
       (set! b.1 99)
       (set! tmp.13 12)
       (if (neq? tmp.13 b.1)
         (begin
           (set! rdi b.1)
           (set! rsi 9)
           (set! r15 ra.12)
           (jump L.start.1 rbp r15 rdi rsi))
         (begin
           (set! tmp.14 b.1)
           (if (eq? tmp.14 9)
             (begin
               (set! rdi 9)
               (set! rsi 9)
               (set! r15 ra.12)
               (jump L.start.1 rbp r15 rdi rsi))
             (begin
               (set! rdi b.1)
               (set! rsi b.1)
               (set! r15 ra.12)
               (jump L.start.1 rbp r15 rdi rsi)))))))
   (define L.start.1
     ((new-frames ()))
     (begin
       (set! ra.15 r15)
       (set! a.2 rsi)
       (set! a.1 rdi)
       (mset! a.1 a.2 8)
       (return-point L.rp.7
         (begin
           (set! rdi 12)
           (set! rsi 3)
           (set! r15 L.rp.7)
           (jump L.start.1 rbp r15 rsi rdi)))
       (set! a.1 rax)
       (mset! a.1 a.1 a.2)
       (set! tmp.17 a.1)
       (set! tmp.16 (+ tmp.17 a.2))
       (set! rax tmp.16)
       (jump ra.15 rbp rax))))
)
  
  (check-equal? (select-instructions '(module (begin (begin (begin (+ 1 2))))))
                 '(module
   (define L.main.8
     ((new-frames ()))
     (begin
       (set! ra.18 r15)
       (set! tmp.20 1)
       (set! tmp.19 (+ tmp.20 2))
       (set! rax tmp.19)
       (jump ra.18 rbp rax)))) )
  
  (check-equal? (select-instructions '(module (begin (let ([a.1 12]) (mset! a.1 8 8))
                                                (begin (let ([a.2 13]) (mset! a.2 9 9))
                                                  (begin (let ([a.3 14]) (mset! a.3 10 10))) (mset! a.2 11 11))
                                                    (apply L.start.2 14))))
                '(module
   (define L.main.9
     ((new-frames ()))
     (begin
       (set! ra.21 r15)
       (set! a.1 12)
       (mset! a.1 8 8)
       (set! a.2 13)
       (mset! a.2 9 9)
       (set! a.3 14)
       (mset! a.3 10 10)
       (mset! a.2 11 11)
       (set! rdi 14)
       (set! r15 ra.21)
       (jump L.start.2 rbp r15 rdi)))))

  (check-equal? (select-instructions `(module (begin (begin (mset! a.1 8 8)) (begin (+ 8 8))))) 
      '(module
   (define L.main.10
     ((new-frames ()))
     (begin
       (set! ra.22 r15)
       (mset! a.1 8 8)
       (set! tmp.24 8)
       (set! tmp.23 (+ tmp.24 8))
       (set! rax tmp.23)
       (jump ra.22 rbp rax)))))

   (check-equal? (parameterize ([current-parameter-registers '(rdi)]) 
                  (select-instructions
                  `(module (define L.start.1 (lambda (a.1 a.2) (begin (begin) (begin (let ([a.1 (apply L.start.1 12 3)])
                                                                                          (begin (mset! a.1 a.1 a.2))))
                                                                                  (+ a.1 a.2))))
                                              (let ([b.1 99])
                                                (if (neq? 12 b.1)
                                                    (begin (apply L.start.1 b.1 9))
                                                    (if (eq? b.1 9)
                                                        (apply L.start.1 9 9)
                                                        (apply L.start.1 b.1 b.1)))))))
        '(module
   (define L.main.11
     ((new-frames ()))
     (begin
       (set! ra.25 r15)
       (set! b.1 99)
       (set! tmp.26 12)
       (if (neq? tmp.26 b.1)
         (begin
           (set! fv0 9)
           (set! rdi b.1)
           (set! r15 ra.25)
           (jump L.start.1 rbp r15 rdi fv0))
         (begin
           (set! tmp.27 b.1)
           (if (eq? tmp.27 9)
             (begin
               (set! fv0 9)
               (set! rdi 9)
               (set! r15 ra.25)
               (jump L.start.1 rbp r15 rdi fv0))
             (begin
               (set! fv0 b.1)
               (set! rdi b.1)
               (set! r15 ra.25)
               (jump L.start.1 rbp r15 rdi fv0)))))))
   (define L.start.1
     ((new-frames ((nfv.29))))
     (begin
       (set! ra.28 r15)
       (set! a.2 fv0)
       (set! a.1 rdi)
       (return-point L.rp.12
         (begin
           (set! nfv.29 12)
           (set! rdi 3)
           (set! r15 L.rp.12)
           (jump L.start.1 rbp r15 rdi nfv.29)))
       (set! a.1 rax)
       (mset! a.1 a.1 a.2)
       (set! tmp.31 a.1)
       (set! tmp.30 (+ tmp.31 a.2))
       (set! rax tmp.30)
       (jump ra.28 rbp rax))))
) 

(check-equal? (select-instructions '(module (alloc 2)))
             '(module
   (define L.main.13
     ((new-frames ()))
     (begin (set! ra.32 r15) (set! rax (alloc 2)) (jump ra.32 rbp rax))))
)

(check-equal? (select-instructions '(module (alloc L.start.1)))
            '(module
   (define L.main.14
     ((new-frames ()))
     (begin
       (set! ra.33 r15)
       (set! rax (alloc L.start.1))
       (jump ra.33 rbp rax))))
)

(check-equal? (select-instructions '(module (alloc a.2)))
             '(module
   (define L.main.15
     ((new-frames ()))
     (begin (set! ra.34 r15) (set! rax (alloc a.2)) (jump ra.34 rbp rax))))
)

 (check-equal? (select-instructions '(module (let ([a.1 (alloc a.2)]) a.1)))
  '(module
   (define L.main.16
     ((new-frames ()))
     (begin
       (set! ra.35 r15)
       (set! a.1 (alloc a.2))
       (set! rax a.1)
       (jump ra.35 rbp rax)))))

  (check-equal? (select-instructions '(module (mref 2 4)))
              '(module
   (define L.main.17
     ((new-frames ()))
     (begin (set! ra.36 r15) (set! rax (mref 2 4)) (jump ra.36 rbp rax))))
)
; mref tests
(check-equal? (select-instructions '(module (mref 3 L.start.1)))
             '(module
   (define L.main.18
     ((new-frames ()))
     (begin
       (set! ra.37 r15)
       (set! rax (mref 3 L.start.1))
       (jump ra.37 rbp rax))))
)

(check-equal? (select-instructions '(module (mref L.start.1 a.2)))
              '(module
   (define L.main.19
     ((new-frames ()))
     (begin
       (set! ra.38 r15)
       (set! rax (mref L.start.1 a.2))
       (jump ra.38 rbp rax))))
)

 (check-equal? (select-instructions '(module (let ([a.1 (mref a.2 8)]) a.1)))
  '(module
   (define L.main.20
     ((new-frames ()))
     (begin
       (set! ra.39 r15)
       (set! a.1 (mref a.2 8))
       (set! rax a.1)
       (jump ra.39 rbp rax))))
)


)