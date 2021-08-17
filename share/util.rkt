#lang racket
(require
  racket/set
  "a9-graph-lib.rkt"
  "a9-compiler-lib.rkt")

(provide (all-defined-out))

(define (aloc? s)
  (and (symbol? s)
       (not (register? s))
       (not (label? s))
       (regexp-match-exact? #rx".+\\.[0-9]+" (symbol->string s))))

  (define (loc? loc)
    (or (aloc? loc) (rloc? loc)))
 
  (define (rloc? loc)
    (or (register? loc) (fvar? loc)))

  (define (triv? triv)
    (or (opand? triv)
        (label? triv)))

  (define (opand? opand)
    (or (int64? opand)
        (loc? opand)))

  ; Any -> Boolean
  ; Return true if the given offset is valid
  (define (dispoffset? n)
    (and (integer? n)
         (zero? (remainder n 8))))

  (define (valid-addr? a)
    (match a
      [`(,rbp ,b ,o) #:when (and (number? o) (register? rbp) (member b '(+ -))) #t]
      [`(,reg1 + ,reg2) #:when (and (register? reg1) (register? reg2)) #t]
      [_ #f]))

  (define (mops-addr? a)
    (match a
      [`(,reg + ,num) #:when (and (number? num) (equal? reg (current-frame-base-pointer-register))) #t]
      [_ #f]))

  ; Any -> Boolean
  ; Return true if the given s is a label
  (define (label? s)
    (and (symbol? s)
        (regexp-match-exact? #rx"L\\..+\\.[0-9]+" (symbol->string s))))

  (define (valid-binop? b)
    (member b '(+ * - bitwise-and bitwise-ior bitwise-xor arithmetic-shift-right)))

  (define (cmp? c)
    (member c '(neq? eq? < <=	>	>=)))

  (define (fbp? r) (eq? r (current-frame-base-pointer-register)))

  (define (ascii-char-literal? x)
    (and (char? x) (<= 40 (char->integer x) 176)))
 
  (define (fixnum? x)
    (int-size? 61 x))
 
  (define (uint8? x)
    (<= 0 255))

  (define (prim-f? x)
    (or (cmp? x) 
        (member x '(vector-set! vector-length make-vector
                          vector-ref procedure-arity
                          cdr car cons vector? procedure? pair?
                          not error? ascii-char? void? empty?
                          boolean? fixnum? * + - eq? < <= > >=))))

  (define (primop? x)
    (or (cmp? x) (prim-f? x) 
        (member x '(closure-ref closure-apply))))

 (define (not-reserved? r) 
      (not (member r '(if let letrec lambda void error))))

  (define (macro-id? m)
    (member m '(and or quote vector begin)))

