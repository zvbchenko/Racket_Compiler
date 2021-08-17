#lang racket

(require
 "util.rkt"
 "a9-graph-lib.rkt"
 "a9-compiler-lib.rkt"
;  "share/a8-compiler-lib.rkt"
 )

 (module+ test
  (require rackunit))


(provide 
  specify-representation
  implement-safe-apply
  sequentialize-let
  )

; Exercise 11

(define (specify-representation p) 
    (define (primop? p)
        (member p '(unsafe-fx* unsafe-fx+ unsafe-fx- eq? unsafe-fx< unsafe-fx<= unsafe-fx>
 	 	                unsafe-fx>= fixnum? boolean? empty? void? ascii-char? error? not pair?
 	 	                procedure? vector? cons unsafe-car unsafe-cdr unsafe-make-vector
 	 	                unsafe-vector-length unsafe-vector-set! unsafe-vector-ref make-procedure
 	 	                unsafe-procedure-arity unsafe-procedure-label unsafe-procedure-ref
                        unsafe-procedure-set!)))
    
    (define (specify-representation-b b) 
        (match b
            [`(define ,f (lambda ,vs ,e))
             `(define ,f (lambda ,vs ,(specify-representation-e e)))]))

    (define (specify-representation-c c)
        (match c
            [`(,primop ,es ...) #:when (primop? primop)
             (specify-representation-primop c)]
            [`(begin ,cs ...)
             (append (list 'begin)
                     (map specify-representation-c cs))]
            [_ c]))
        
    (define (specify-representation-e e)
        (match e
            [`(,primop ,es ...) #:when (primop? primop)
             (specify-representation-primop e)]
            [`(apply ,es ...) 
             (append (list 'apply) 
                     (map specify-representation-e es))]
            [`(let ([,aloc ,e1]) ,e2) 
             `(let ([,aloc ,(specify-representation-e e1)]) 
                ,(specify-representation-e e2))]
            [`(if ,e1 ,e2 ,e3) 
             `(if (neq? ,(specify-representation-e e1)
                        ,(current-false-ptr))
                  ,(specify-representation-e e2)
                  ,(specify-representation-e e3))]
            [`(begin ,cs ... ,e1)
             (append (list 'begin)
                     (map specify-representation-c cs)
                     (list (specify-representation-e e1)))]
            [v (specify-representation-v v)]))
    
    (define (specify-representation-v v)
        (match v
            [`(error ,v)
             (+ (* v (expt 2 (current-error-shift)))
                (current-error-tag))]
            [b #:when (boolean? b)
             (if b (current-true-ptr) (current-false-ptr))]
            [`(void) (current-void-ptr)]
            [i #:when (fixnum? i) 
             (* i word-size-bytes)]
            [`() (current-empty-ptr)]
            [c #:when (ascii-char-literal? c)
             (+ (* (char->integer c) (expt 2 (current-ascii-char-shift)))
                (current-ascii-char-tag))]
            [_ v]))

    (define (specify-representation-primop e)
        (match e
            [`(fixnum? ,e1)
             `(if (eq? (bitwise-and ,(specify-representation-e e1) 
                                    ,(current-fixnum-mask)) 
                       ,(current-fixnum-tag))
                  ,(current-true-ptr)
                  ,(current-false-ptr))]
            [`(not ,e1)
             `(if (neq? ,(specify-representation-e e1) 
                        ,(current-true-ptr))
                  ,(current-true-ptr)
                  ,(current-false-ptr))]
            [`(error? ,e1)
             `(if (eq? (bitwise-and ,(specify-representation-e e1)
                                    ,(current-error-mask))
                       ,(current-error-tag))
                  ,(current-true-ptr)
                  ,(current-false-ptr))]
            [`(ascii-char? ,e1)
             `(if (eq? (bitwise-and ,(specify-representation-e e1) 
                                    ,(current-ascii-char-mask))
                       ,(current-ascii-char-tag))
                  ,(current-true-ptr)
                  ,(current-false-ptr))]
            [`(void? ,e1)
             `(if (eq? (bitwise-and ,(specify-representation-e e1)
                                    ,(current-void-mask))
                       ,(current-void-tag))
                  ,(current-true-ptr)
                  ,(current-false-ptr))]
            [`(empty? ,e1)
             `(if (eq? (bitwise-and ,(specify-representation-e e1)
                                    ,(current-empty-mask))
                       ,(current-empty-tag))
                  ,(current-true-ptr)
                  ,(current-false-ptr))]
            [`(boolean? ,e1)
             `(if (eq? (bitwise-and ,(specify-representation-e e1)
                                    ,(current-boolean-mask))
                       ,(current-boolean-tag))
                  ,(current-true-ptr)
                  ,(current-false-ptr))]
            [`(unsafe-fx< ,e1 ,e2)
             `(if (< ,(specify-representation-e e1) 
                     ,(specify-representation-e e2))
                  ,(current-true-ptr)
                  ,(current-false-ptr))]
            [`(unsafe-fx<= ,e1 ,e2)
             `(if (<= ,(specify-representation-e e1) 
                      ,(specify-representation-e e2))
                  ,(current-true-ptr)
                  ,(current-false-ptr))]
            [`(unsafe-fx> ,e1 ,e2)
             `(if (> ,(specify-representation-e e1) 
                     ,(specify-representation-e e2))
                  ,(current-true-ptr)
                  ,(current-false-ptr))]
            [`(unsafe-fx>= ,e1 ,e2)
             `(if (>= ,(specify-representation-e e1) 
                      ,(specify-representation-e e2))
                  ,(current-true-ptr)
                  ,(current-false-ptr))]
            [`(unsafe-fx+ ,e1 ,e2)
             `(+ ,(specify-representation-e e1) 
                 ,(specify-representation-e e2))]
            [`(unsafe-fx- ,e1 ,e2)
             `(- ,(specify-representation-e e1) 
                 ,(specify-representation-e e2))]
            [`(unsafe-fx* ,n1 ,n2)
             #:when (and (fixnum? n1) (fixnum? n2))
             `(* ,n1 ,(* 8 n2))]
            [`(unsafe-fx* ,n1 ,e2)
             #:when (and (fixnum? n1) (not (fixnum? e2)))
             `(* ,n1 ,(specify-representation-e e2))]
            [`(unsafe-fx* ,e1 ,n2)
             #:when (and (fixnum? n2) (not (fixnum? e1)))
             `(* ,(specify-representation-e e1) ,n2)]
            [`(unsafe-fx* ,e1 ,e2)
             `(* ,(specify-representation-e e1) 
                 (arithmetic-shift-right ,(specify-representation-e e2) 
                                         ,(current-fixnum-shift)))]
            [`(eq? ,e1 ,e2)
             `(if (eq? ,(specify-representation-e e1) 
                       ,(specify-representation-e e2))
                  ,(current-true-ptr)
                  ,(current-false-ptr))]
            [`(pair? ,e1)
             `(if (eq? (bitwise-and ,(specify-representation-e e1)
                                    ,(current-pair-mask))
                       ,(current-pair-tag))
                  ,(current-true-ptr)
                  ,(current-false-ptr))]
            [`(procedure? ,e1)
             `(if (eq? (bitwise-and ,(specify-representation-e e1)
                                    ,(current-procedure-mask))
                       ,(current-procedure-tag))
                  ,(current-true-ptr)
                  ,(current-false-ptr))]
            [`(vector? ,e1)
             `(if (eq? (bitwise-and ,(specify-representation-e e1)
                                    ,(current-vector-mask))
                       ,(current-vector-tag))
                  ,(current-true-ptr)
                  ,(current-false-ptr))]
            [`(cons ,e1 ,e2)
             (define tmp (fresh))
             `(let ([,tmp (+ (alloc ,(words->bytes 2)) 1)])
                (begin (mset! ,tmp 
                              -1
                              ,(specify-representation-e e1))
                       (mset! ,tmp 
                              ,(- word-size-bytes 1) 
                              ,(specify-representation-e e2))
                       ,tmp))]
            [`(unsafe-car ,e1)
             `(mref ,(specify-representation-e e1)
                    ,(car-offset))]
            [`(unsafe-cdr ,e1)
             `(mref ,(specify-representation-e e1)
                    ,(cdr-offset))]
            [`(unsafe-procedure-arity ,e1)
             `(mref ,(specify-representation-e e1)
                    ,(- word-size-bytes (current-procedure-tag)))]
            [`(unsafe-vector-length ,e1)
             `(mref ,(specify-representation-e e1)
                    ,(- 0 (current-vector-tag)))]
            [`(unsafe-vector-set! ,e1 ,e2 ,e3)
             `(mset! ,(specify-representation-e e1)
                     (+ (* (arithmetic-shift-right ,(specify-representation-e e2)
                                                   ,(current-vector-shift))
                           ,word-size-bytes)
                        ,(- word-size-bytes (current-vector-tag)))
                      ,(specify-representation-e e3))]
            [`(unsafe-make-vector ,e1)
             (define x (fresh))
             (define e1^ (specify-representation-e e1))
             `(let ([,x (+ (alloc (* (+ 1 
                                        (arithmetic-shift-right ,e1^ 
                                                                ,(current-vector-shift)))
                                     ,word-size-bytes))
                           ,(current-vector-tag))])
                  (begin (mset! ,x ,(- 0 (current-vector-tag)) ,e1^)
                         ,x))]
            [`(unsafe-vector-ref ,e1 ,e2)
             `(mref ,(specify-representation-e e1)
                    (+ (* (arithmetic-shift-right ,(specify-representation-e e2)
                                                  ,(current-vector-shift))
                          ,word-size-bytes)
                       ,(- word-size-bytes (current-vector-tag))))]
            [`(make-procedure ,e1 ,e2 ,n3)
             #:when (fixnum? n3)
             (define x (fresh))
             `(let ([,x (+ (alloc ,(words->bytes (+ n3 2))) 
                           ,(current-procedure-tag))])
                  (begin (mset! ,x 
                                ,(- 0 (current-procedure-tag)) 
                                ,(specify-representation-e e1))
                         (mset! ,x
                                ,(- word-size-bytes (current-procedure-tag))
                                ,(specify-representation-e e2))
                         ,x))]
            [`(unsafe-procedure-label ,e1)
             `(mref ,(specify-representation-e e1) 
                    ,(- 0 (current-procedure-tag)))]
            [`(unsafe-procedure-ref ,e1 ,n2)
             #:when (fixnum? n2)
             `(mref ,(specify-representation-e e1)
                    ,(+ (words->bytes n2)
                        (- (words->bytes 2) (current-procedure-tag))))]
            [`(unsafe-procedure-ref ,e1 ,e2) 
             `(mref ,(specify-representation-e e1)
                    (+ (* (arithmetic-shift-right ,(specify-representation-e e2)
                                                  ,(current-procedure-shift))
                          ,word-size-bytes)
                       ,(- (words->bytes 2) (current-procedure-tag))))]
            [`(unsafe-procedure-set! ,e1 ,n2 ,e3) 
             #:when (fixnum? n2)
             `(mset! ,(specify-representation-e e1)
                     ,(+ (words->bytes n2)
                        (- (words->bytes 2) (current-procedure-tag)))
                     ,(specify-representation-e e3))]
            [`(unsafe-procedure-set! ,e1 ,e2 ,e3)
             `(mset! ,(specify-representation-e e1)
                     (+ (* (arithmetic-shift-right ,(specify-representation-e e2)
                                                  ,(current-procedure-shift))
                          ,word-size-bytes)
                       ,(- (words->bytes 2) (current-procedure-tag)))
                     ,(specify-representation-e e3))]
            ))

    
    (displayln (format "specify-representation ~a" p))

    (match p
        [`(module ,bs ... ,e)
         (append (list 'module)
                 (map specify-representation-b bs) 
                 (list (specify-representation-e e)))]))

; Exercise 10
(define (implement-safe-apply p) 
    (define (implement-safe-apply-b b) 
        (match b
            [`(define ,f (lambda ,vs ,e))
             `(define ,f (lambda ,vs ,(implement-safe-apply-e e)))]))
        
    (define (implement-safe-apply-e e)
        (match e
            [`(unsafe-apply ,es ...) 
             (append (list 'apply) 
                     (map implement-safe-apply-e es))]
            [`(let ([,aloc ,e1]) ,e2) 
             `(let ([,aloc ,(implement-safe-apply-e e1)]) 
                ,(implement-safe-apply-e e2))]
            [`(if ,e1 ,e2 ,e3) 
             `(if ,(implement-safe-apply-e e1)
                  ,(implement-safe-apply-e e2)
                  ,(implement-safe-apply-e e3))]
            [`(begin ,cs ... ,e1)
             (append (list 'begin)
                     (map implement-safe-apply-c cs)
                     (list (implement-safe-apply-e e1)))]
            [`(procedure-apply ,e1 ,es ...)
             (define x (fresh))
             `(let ([,x ,(implement-safe-apply-e e1)])
                 (if (procedure? ,x)
                     (if (eq? (unsafe-procedure-arity ,x) 
                              ,(sub1 (length es)))
                         ,(append (list 'apply)
                                  (list `(unsafe-procedure-label ,x))
                                  (map implement-safe-apply-e es))
                         (error 42))
                     (error 43)))]
            [`(,primop ,es ...)
             (append (list primop)
                     (map implement-safe-apply-e es))]
            [_ e]))

    (define (implement-safe-apply-c c)
        (match c
            [`(begin ,cs ...)
             (append (list 'begin)
                     (map implement-safe-apply-c cs))]
            [`(procedure-apply ,e1 ,es ...)
             (define x (fresh))
             `(let ([,x ,(implement-safe-apply-e e1)])
                 (if (procedure? ,x)
                     (if (eq? (unsafe-procedure-arity ,x) 
                              ,(sub1 (length es)))
                         ,(append (list 'apply)
                                  (list `(unsafe-procedure-label ,x))
                                  (map implement-safe-apply-e es))
                         (error 42))
                     (error 43)))]
            [_ c]))

    
    (displayln (format "implement-safe-apply ~a" p))

    (match p
        [`(module ,bs ... ,e)
         (append (list 'module)
                 (map implement-safe-apply-b bs) 
                 (list (implement-safe-apply-e e)))]))

; Exercise 9
(define (sequentialize-let p) 
    (define (sequentialize-let-b b) 
        (match b
            [`(define ,f (lambda ,vs ,e))
             `(define ,f (lambda ,vs ,(sequentialize-let-e e)))]))
        
    (define (sequentialize-let-e e)
        (match e
            [`(let (,assigns ...) ,e1) 
             (sequentialize-let-build-lets assigns (sequentialize-let-e e1))]
            [`(,op ,es ...)
             (append (list op)
                     (map sequentialize-let-e es))]
            [_ e]))

    (define (sequentialize-let-build-lets assigns end-e)
        (if (empty? assigns)
            end-e
            `(let (,(first assigns))
                ,(sequentialize-let-build-lets (rest assigns) end-e))))

    (displayln (format "sequentialize-let ~a" p))

    (match p
        [`(module ,bs ... ,e)
         (append (list 'module)
                 (map sequentialize-let-b bs) 
                 (list (sequentialize-let-e e)))]))
