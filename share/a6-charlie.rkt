#lang racket

(require
 racket/set
 "util.rkt"
 "a7-graph-lib.rkt"
 "a7-compiler-lib.rkt"
 )

(provide 
  ; uniquify
  ;select-instructions
  ; implement-fvars
  ;flatten-program
  ;patch-instructions
  ;generate-x64
  )

(module+ test
  (require rackunit))

; Exercise 1
; Values-lang v6 -> Values-unique-lang v6
; redesign uniquefy to support Values-lang v6
; what uniquify does isdischarge the last assumption, we know which names refer to which abstract locations,
; and thus introduce the last abstraction.
; uniquify replace variables to alocs
(define (uniquify p)

    ;; Var -> Value
    (define (empty-env x)
        (error "Unbound variable:" x))

    ;; Var Value Env -> (Var -> Value)
    ; extend environment with x0 and v0
    (define (extend-env x0 v0 env)
        (λ (x)
        (if (eq? x0 x)
            v0
            (env x))))

    (define (init-function bs env)
        (if (empty? bs)
            env
            (match (first bs)
                [`(define ,x ,lams) 
                    (init-function (rest bs) (extend-env x (fresh-label x) env))]    
            )))

    (define (list-extend-env args env)
        (if (empty? args)
            env
            (list-extend-env (rest args) (extend-env (first args) (fresh (first args)) env))))

    (define (uniquify-b b env) 
        (match b 
            [`(define ,x (lambda (,args ...) ,e))
                (let ([b-env (list-extend-env args env)])
                    `(define ,(b-env x) (lambda ,(map (lambda (x) (b-env x)) args) ,(uniquify-e e b-env))))]))

    (define (uniquify-e e env) 
        (match e 
            [`,num #:when (int64? num) num]
            [`,v #:when (symbol? v) (env v)]
            [`(,binop ,v1 ,v2) #:when (valid-binop? binop)
                `(,binop ,(uniquify-e v1 env) ,(uniquify-e v2 env))]
            [`(apply ,v1 ,vs ...) 
                `(apply ,(uniquify-e v1 env) ,@(map (lambda (x) (uniquify-e x env)) vs))]
            [`(let ([,x ,n]) ,e1)
                (let* ([new-x (fresh x)]
                    [e-env (extend-env x new-x env)]) 
                `(let ([,new-x ,(uniquify-e n env)]) ,(uniquify-e e1 e-env)))]
            [`(if (,cmp ,v1 ,v2) ,e1 ,e2) #:when (cmp? cmp)
                `(if (,cmp ,(uniquify-e v1 env) ,(uniquify-e v2 env)) 
                    ,(uniquify-e e1 env)
                    ,(uniquify-e e2 env))]))   

    (displayln (format "uniquify ~a" p))
    (match p
        [`(module ,b ... ,e)
           (let ([new-env (init-function b empty-env)])
            `(module ,@(map (lambda (x) (uniquify-b x new-env)) b) ,(uniquify-e e new-env)))])
)

(module+ test
  (require rackunit)
  ; Values-lang p -> Values-lang p -> void
  ; Checks that p1 and p2 are alpha-equivalent Values-lang programs.
  ; Also worked for Values-unique-lang.
  ; Returns nothing useful, or raises a test failure.
  (define-check (check-Values-lang-alpha-equal? p1 p2)
    ; Env is a dictionary mapping a Values-lang name to a Values-lang name.

    ; Env -> Values-lang x -> Values-lang x -> void
    ; Check that two variables are equal under env.
    (define (check-var env v1 v2)
      (unless (equal? (dict-ref env v1) v2)
        (fail-check (format "Expected ~a for ~a, but found ~a" v2
                            v1
                            (dict-ref env v1)))))

    ; Env -> Values-lang b -> Values-lang b -> Env
    ; Checks that the Values-lang blocks b1 and b2 are alpha-equivalent.
    ; Returns an environment mapping all definitions from b1 to their
    ; counterparts in b2, or raises a test failure.
    (define (check-b env b1 b2)
      (match (cons b1 b2)
        ;; NOTE: Since I assume the input is a valid Values-lang program (this
        ;; assumption is stated in the signature), I can safely assume both b1
        ;; and b2 are valid Paren-lang bs, and there are no other cases.
        [(cons `(define ,x1 (lambda (,ys1 ...) ,e1))
               `(define ,x2 (lambda (,ys2 ...) ,e2)))
         (define new-env (dict-set env x1 x2))
         (unless (equal? (length ys1) (length ys2))
           (fail-check
            "Expected ~a arguments (in function ~a) but found ~a in (in ~a)."
            (length ys2) x2 (length ys1) x1))
         ;; NOTE: The for/fold construct allows you to loop over one or more
         ;; lists while accumulating data.
         ;; This is convenient short hand for simple recursive functions.
         ;; This one loops of ys1 and ys2, adding each to the dictionary env,
         ;; which is initially set to new-end.
         (check-e (for/fold ([env new-env])
                            ([y1 ys1]
                             [y2 ys2])
                    (dict-set env y1 y2)) e1 e2)
         new-env]))

    ; Env -> Values-lang e1 -> Values-lang e2 -> void
    (define (check-e env e1 e2)
      (match (cons e1 e2)
        [(cons `(let ([,x1 ,n1]) ,e1)
               `(let ([,x2 ,n2]) ,e2))
         (let ([env (dict-set env x1 x2)])
           (check-n env n1 n2)
           (check-e env e1 e2))]
        [(cons `(if (,cmp ,v1 ,v2) ,e1 ,e2)
               `(if (,cmp ,v12 ,v22) ,e12 ,e22))
         (check-v env v1 v12)
         (check-v env v2 v22)
         (check-e env e1 e12)
         (check-e env e2 e22)]
        ;; NOTE: Since I assume the input is a valid Values-lang program (this
        ;; assumption is stated in the signature), I can assume all other cases
        ;; MUST be valid tails.
        [_ (check-tail env e1 e2)]))

    ; Env -> Values-lang tail -> Values-lang tail -> void
    (define (check-tail env tail1 tail2)
      (match (cons tail1 tail2)
        [(cons `(apply ,x1 ,vs1 ...)
               `(apply ,x2 ,vs2 ...))
         (check-var env x1 x2)
         ;; NOTE: (curry check-v env) partially applies check-v to only env,
         ;; returning a function expecting the rest of the arguments.
         ;; This is short-hand for:
         ;;   (lambda (v1 v2) (check-v env v1 v2))
         ;; It's good to avoid curry, but sometimes it useful and not much less
         ;; clear.
         ;; I often use it like below, in a map or for-each.
         ;; For anything more complex, it's usually good to use a for/list,
         ;; for/fold, etc.
         (for-each (curry check-v env) vs1 vs2)]
        ;; NOTE: Since I assume the input is a valid Values-lang program (this
        ;; assumption is stated in the signature), I can assume all other cases
        ;; MUST be valid ns.
        [_ (check-n env tail1 tail2)]))

    ; Env -> Values-lang n -> Values-lang n -> void
    (define (check-n env n1 n2)
      (match (cons n1 n2)
        [(cons `(,binop ,vs1 ...)
               `(,binop ,vs2 ...))
         (for-each (curry check-v env) vs1 vs2)]
        [_ (check-v env n1 n2)]))

    ; Env -> Values-lang v -> Values-lang v -> void
    (define (check-v env v1 v2)
      (match (cons v1 v2)
        [(cons int int)
         #:when (integer? int)
         (void)]
        ;; NOTE: Since I assume the input is a valid Values-lang program, the
        ;; only other case must be variables.
        [(cons x1 x2)
         (check-var env x1 x2)]))
    
    (match (cons p1 p2)
      [(cons `(module ,bs1 ... ,e1)
             `(module ,bs2 ... ,e2))
       (check-e (for/fold ([env '()])
                          ([b1 bs1]
                           [b2 bs2])
                  (check-b env b1 b2))
                e1 e2)]))
  
  
  
  (let ([x '(module (let ([v 1])
                      (let ([w 46])
                        (let ([x v])
                          (let ([x (+ x 7)])
                            (let ([y x])
                              (let ([y (+ y 4)])
                                (let ([z x])
                                  (let ([z (+ z w)])
                                    (let ([t.1 y])
                                      (let ([t.1 (* t.1 -1)])
                                        (let ([z (+ z t.1)])
                                          z))))))))))))])
      (check-Values-lang-alpha-equal? (uniquify x) x))
    
  (let* ([x `(module (define func1 (lambda (x y) (+ x y)))
                              (apply func1 1 3))]
        [x-res (uniquify x)])
    (check-Values-lang-alpha-equal? x-res x)) 

; bug in alpha-equal, this should pass
  ; (let* ([x `(module (define func1 (lambda (x y) (apply func2 x y)))
  ;                     (define func2 (lambda (a b) (apply func1 a b)))
  ;                             (apply func1 1 3))]
  ;       [x-res (uniquify x)])
  ;       (displayln (format "x-res: ~a" x-res))
  ;   (check-Values-lang-alpha-equal? x-res x)) 

  (let* ([x `(module (define func1 (lambda (x y) (apply func1 x y)))
                              (apply func1 1 3))]
        [x-res (uniquify x)])
    (check-Values-lang-alpha-equal? x-res x)) 

  (let* ([x `(module (define func1 (lambda (x y) (if (> x 1) 
                                                      (apply func1 x 1)
                                                      (apply func1 y 1))))
                              (apply func1 1 3))]
        [x-res (uniquify x)])
    (check-Values-lang-alpha-equal? x-res x)) 

  (let* ([x `(module (define func1 (lambda (x y) (if (> x 1) 
                                                      (apply func1 x func1)
                                                      (apply func1 y 1))))
                              (let ([x 1])
                                (let ([y 2])
                                  (apply func1 x y))))]
        [x-res (uniquify x)])
    (check-Values-lang-alpha-equal? x-res x))

 (let* ([x `(module (define func1 (lambda (x y) (if (> x 1) 
                                                      (apply func1 x func1)
                                                      (apply func1 y 1))))
                              (apply func1 1 3))]
        [x-res (uniquify x)])
    (check-Values-lang-alpha-equal? x-res x))

(let* ([x `(module (define func1 (lambda (x y) (if (> x 1) 
                                                      (apply func1 x func1)
                                                      (apply func1 y 1))))
                    (define func2 (lambda (x y) (let ([x x])
                                                  (let ([y y])
                                                    (apply func1 y x)))))
                              (apply func2 1 3))]
        [x-res (uniquify x)])
    (check-Values-lang-alpha-equal? x-res x))

(let* ([x `(module (let ([x 1]) 
                    (let ([x x])
                      (+ x x))))]
        [x-res (uniquify x)])
    (check-Values-lang-alpha-equal? x-res x))

(let* ([x '(module (define f1 (lambda (x y) (+ x y))) (define f2 (lambda (x) (apply f1 x 100))) (apply f2 10))]
        [x-res (uniquify x)])
    (check-Values-lang-alpha-equal? x-res x))

;; alpha equal error
; !! might not work if order of running these tests changed 
(let* ([x '(module (define f1                                   
                        (lambda (x)                              
                            (if (< x 0)                        
                                0                             
                                (let ((y (+ x 1)))              
                                  (apply f2 y)))))            
                    (define f2 (lambda (x)                     
                          (let ((y (* x 2)))               
                            (apply f1 y))))                    
                    (apply f1 10))]                              
        [x-res (uniquify x)])
        ; (displayln (format "x-res ~a" x-res))
    (check-equal? x-res '(module (define L.f1.10 (lambda (x.35) (if (< x.35 0) 0 (let ((y.36 (+ x.35 1))) (apply L.f2.11 y.36))))) (define L.f2.11 (lambda (x.37) (let ((y.38 (* x.37 2))) (apply L.f1.10 y.38)))) (apply L.f1.10 10))))

(let* ([x '(module (define f1                                   
                        (lambda (x)                              
                            (if (< x 0)                        
                                0                             
                                (let ((y (+ x 1)))              
                                  (apply f2 y)))))            
                    (define f2 (lambda (x)                     
                          (let ((y (* x 2)))               
                            (apply f1 y))))                    
                    (+ 1 2))]                              
        [x-res (uniquify x)])
        ; (displayln (format "x-res ~a" x-res))
    (check-equal? x-res `(module (define L.f1.12 (lambda (x.39) (if (< x.39 0) 0 (let ((y.40 (+ x.39 1))) (apply L.f2.13 y.40))))) (define L.f2.13 (lambda (x.41) (let ((y.42 (* x.41 2))) (apply L.f1.12 y.42)))) (+ 1 2))))

(let* ([x '(module (define f1                                   
                        (lambda (x)                              
                            (if (< x 0)                        
                                0                             
                                (let ((y (+ x 1)))              
                                  (apply f2 y)))))            
                    (define f2 (lambda (y)                     
                          (let ((y (* x 2)))               
                            (apply f1 y))))                    
                    (+ 1 2))])
    (check-exn exn:fail? (thunk (uniquify x))))

(let* ([x '(module (define f1                                   
                        (lambda (x)                              
                            (+ x y)))                               
                    (let ([y 10])
                        (apply f1 1)))])
    (check-exn exn:fail? (thunk (uniquify x)))) ; test number 13

(let* ([x '(module (- 1 2))]
        [x-res (uniquify x)])
    (check-Values-lang-alpha-equal? x-res x))

(let* ([x '(module (let ((x (- 4 9))) (+ x 1)))]
        [x-res (uniquify x)])
    (check-Values-lang-alpha-equal? x-res x))

(let* ([x '(module (define f1 (lambda (x y) (+ x y))) (define f2 (lambda (x) (apply f1 x 100))) 
                (let ((x (apply f1 x x))) x))])
    (check-exn exn:fail? (thunk (uniquify x))))

(let* ([x '(module (define f1 (lambda (x y) (+ x y)))
             (let ((x f1)) (apply x x x)))]
        [x-res (uniquify x)])
    (check-Values-lang-alpha-equal? x-res x))

(let* ([x '(module (define f1 (lambda (x y) (+ x y)))
             (let ((x f1))
              (let ((y x)) (apply x y x))))]
        [x-res (uniquify x)])
    (check-Values-lang-alpha-equal? x-res x))

(let* ([x '(module (define f1 (lambda (x y) (+ x y)))
             (let ((x f1))
              (let ((y x)) 
                (if (> x 8) 
                    (apply x y x)
                    (apply y x y)))))]
        [x-res (uniquify x)])
    (check-Values-lang-alpha-equal? x-res x))

)

; Exercise 2
;  Values-unique-lang v6 -> Block-lang v6
; extend the implementation of select-instructions.
; handle apply by using calling conventions
; assume Values-unique-lang v6 is syntactically correct
(define (select-instructions p)
 ;To implement fvars later, we requires that current-frame-base-pointer-register is assigned only by incrementing
 ; or decrementing it by an integer literal. Other uses current-frame-base-pointer-register are invalid programs.
 ; Later passes will assume this in order to compute frame variable locations.
    (define return-loc (fresh 'ra))
    ;  fv_0 ... fv_k-1 are the first k frame variables, i.e., locations on this function’s frame. 
    (define frames empty)
    
    ; The info field records all the new frames created in the block

    (define (select-n n res-loc)
      (match n 
        [`,num #:when (int64? num) (list `(set! ,res-loc ,num))]
        [`,v #:when (aloc? v) (list `(set! ,res-loc ,v))]
        [`(,binop ,v1 ,v2) #:when (valid-binop? binop)
          (let* ([res1 (fresh)])
              (append (select-n v1 res1) (list `(set! ,res-loc (,binop ,res1 ,v2)))))]
        [`(apply ,f ,vs ...) 
          (let* ([rp (fresh-label 'rp)]
                 [reglist (current-parameter-registers)]
                 [assigned-list (assign-n vs reglist)])
            (list `(return-point ,rp
                      (begin 
                        ,@(map (lambda (x y) `(set! ,x ,y)) assigned-list vs)
                         (set! ,(current-return-address-register) ,rp)
                         (jump ,f ,(current-frame-base-pointer-register) ,(current-return-address-register) ,@assigned-list))
                         )
                  `(set! ,res-loc ,(current-return-value-register))))]
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
              (append ass-reg (reverse ass-loc))))
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
                [reglist (current-parameter-registers)])
          `(define ,func ((new-frames ,(reverse frames))) (begin (set! ,return-loc ,(current-return-address-register)) ,@(make-args-impl args reglist empty) ,@cont) ))])
      ))


    (define (select-e-impl e tmp-rp)
      (match e 
       [`,num #:when (int64? num) 
            `((set! ,(current-return-value-register) ,num)
              (jump ,tmp-rp,(current-frame-base-pointer-register) ,(current-return-value-register)))]
       [`,v #:when (aloc? v) 
            `((set! ,(current-return-value-register) ,v)
              (jump ,tmp-rp ,(current-frame-base-pointer-register) ,(current-return-value-register)))]
       [`(,binop ,v1 ,v2) #:when (valid-binop? binop)
          (let ([res-loc (fresh)])
               `(,@(select-n e res-loc)
                (set! ,(current-return-value-register) ,res-loc)
                (jump ,tmp-rp ,(current-frame-base-pointer-register) ,(current-return-value-register)))
          )]
       [`(let ([,x ,n]) ,e) #:when (aloc? x)
          `(,@(select-n n x)
            ,@(select-e-impl e tmp-rp))]
       [`(if (,cmp ,v1 ,v2) ,e1 ,e2) #:when (cmp? cmp)
            (let ([tmp (fresh)])
              `((set! ,tmp ,v1)
                (if (,cmp ,tmp ,v2)
                  (begin ,@(select-e-impl e1 tmp-rp))
                  (begin ,@(select-e-impl e2 tmp-rp)))))]
    ;  We want limit the live ranges of registers to help the register allocator makes better use of registers, 
    ; we should generate accesses to registers last to limit their live ranges. Loading the return address register 
    ; last can also help limit its live range for simple functions.
        [`(apply ,f ,vs ...)
          (let* ([reglist (current-parameter-registers)]
                 [assigned-reg (reverse (apply-assign-reg vs reglist))]
                 [assigned-frame (reverse (apply-assign-frame vs reglist))])
                ;  (displayln (format "assigned: ~a" assigned))
            `(,@(map (lambda (x y) `(set! ,x ,y)) assigned-frame (take-right vs (length assigned-frame)))
              ,@(map (lambda (x y) `(set! ,x ,y)) assigned-reg (take vs (length assigned-reg)))
                (set! ,(current-return-address-register) ,tmp-rp)
                (jump ,f ,(current-frame-base-pointer-register) ,(current-return-address-register) ,@assigned-reg ,@assigned-frame)))]
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
      ))


    ; (displayln (format "select intr: ~a" p))
    (match p 
      [`(module ,bs ... ,e)
        (let ([e-res (select-e e)])
          `(module (define ,(fresh-label 'main) ((new-frames ,(reverse frames))) ,e-res) ,@(map select-b bs)))]
    )
)

(module+ test 
  (check-equal? (select-instructions 
                  `(module (define L.fun.1 (lambda (a.1 a.2) a.2)) 
                          (apply L.fun.1 7 8)))
                  '(module
                      (define L.main.22
                        ((new-frames ()))
                        (begin
                          (set! ra.64 r15)
                          (set! rdi 7)
                          (set! rsi 8)
                          (set! r15 ra.64)
                          (jump L.fun.1 rbp r15 rdi rsi)))
                      (define L.fun.1
                        ((new-frames ()))
                        (begin
                          (set! ra.65 r15)
                          (set! a.2 rsi)
                          (set! a.1 rdi)
                          (set! rax a.2)
                          (jump ra.65 rbp rax))))
                          "seelct test 1")

  (check-equal? (select-instructions 
                  `(module 42))
                  '(module
                      (define L.main.23
                        ((new-frames ()))
                        (begin (set! ra.66 r15) (set! rax 42) (jump ra.66 rbp rax))))
                          "seelct test 2")
  
  (check-equal? (select-instructions 
                  `(module (+ 3 1)))
                  '(module
                      (define L.main.24
                        ((new-frames ()))
                        (begin
                          (set! ra.67 r15)
                          (set! tmp.69 3)
                          (set! tmp.68 (+ tmp.69 1))
                          (set! rax tmp.68)
                          (jump ra.67 rbp rax))))
                          "seelct test 3")

   (check-equal? (select-instructions 
                `(module (if (eq? 2 3) (+ 4 2) (* 2 3))))
                '(module
                    (define L.main.25
                      ((new-frames ()))
                      (begin
                        (set! ra.70 r15)
                        (set! tmp.71 2)
                        (if (eq? tmp.71 3)
                          (begin
                            (set! tmp.73 4)
                            (set! tmp.72 (+ tmp.73 2))
                            (set! rax tmp.72)
                            (jump ra.70 rbp rax))
                          (begin
                            (set! tmp.75 2)
                            (set! tmp.74 (* tmp.75 3))
                            (set! rax tmp.74)
                            (jump ra.70 rbp rax)))))))                        

  (check-equal? (select-instructions 
                `(module (let ((x.1 (apply f 1 2))) (- x.1 1))))
                 '(module
                    (define L.main.27
                      ((new-frames ()))
                      (begin
                        (set! ra.76 r15)
                        (return-point L.rp.26
                          (begin
                            (set! rsi 1)
                            (set! rdi 2)
                            (set! r15 L.rp.26)
                            (jump f rbp r15 rsi rdi)))
                        (set! x.1 rax)
                        (set! tmp.78 x.1)
                        (set! tmp.77 (- tmp.78 1))
                        (set! rax tmp.77)
                        (jump ra.76 rbp rax))))) 

  (check-equal? (parameterize ([current-parameter-registers '()])
                  (select-instructions
                    '(module
                      (define L.swap.1
                        (lambda (x.1 y.2)
                          (if (< y.2 x.1)
                              x.1
                              (apply L.swap.1 y.2 x.1))))
                      (apply L.swap.1 1 2))))
                       '(module
                            (define L.main.28
                              ((new-frames ()))
                              (begin
                                (set! ra.79 r15)
                                (set! fv0 1)
                                (set! fv1 2)
                                (set! r15 ra.79)
                                (jump L.swap.1 rbp r15 fv0 fv1)))
                            (define L.swap.1
                              ((new-frames ()))
                              (begin
                                (set! ra.80 r15)
                                (set! y.2 fv1)
                                (set! x.1 fv0)
                                (set! tmp.81 y.2)
                                (if (< tmp.81 x.1)
                                  (begin (set! rax x.1) (jump ra.80 rbp rax))
                                  (begin
                                    (set! fv0 y.2)
                                    (set! fv1 x.1)
                                    (set! r15 ra.80)
                                    (jump L.swap.1 rbp r15 fv0 fv1)))))))   

   (check-equal? (parameterize ([current-parameter-registers '(rdi)])
                  (select-instructions
                    '(module
                      (define L.swap.1
                        (lambda (x.1 y.2)
                          (if (< y.2 x.1)
                              x.1
                              (apply L.swap.1 y.2 x.1))))
                      (apply L.swap.1 1 2))))
                    '(module
   (define L.main.29
     ((new-frames ()))
     (begin
       (set! ra.82 r15)
       (set! fv0 2)
       (set! rdi 1)
       (set! r15 ra.82)
       (jump L.swap.1 rbp r15 rdi fv0)))
   (define L.swap.1
     ((new-frames ()))
     (begin
       (set! ra.83 r15)
       (set! y.2 fv0)
       (set! x.1 rdi)
       (set! tmp.84 y.2)
       (if (< tmp.84 x.1)
         (begin (set! rax x.1) (jump ra.83 rbp rax))
         (begin
           (set! fv0 x.1)
           (set! rdi y.2)
           (set! r15 ra.83)
           (jump L.swap.1 rbp r15 rdi fv0)))))))                                    


  (check-equal? (select-instructions 
                    `(module (let ((x.1 5)) 
                               (let ((x.2 (+ x.1 11)))
                                       x.2))) )
               '(module
                  (define L.main.30
                    ((new-frames ()))
                    (begin
                      (set! ra.85 r15)
                      (set! x.1 5)
                      (set! tmp.86 x.1)
                      (set! x.2 (+ tmp.86 11))
                      (set! rax x.2)
                      (jump ra.85 rbp rax)))))

  (check-equal? (select-instructions `(module (define L.main.1 (lambda (x.1) (apply L.main.2 2 x.1 3))) (define L.main.2 (lambda (x.2 x.3 x.4) x.3)) 5))
                      '(module
                            (define L.main.31
                              ((new-frames ()))
                              (begin (set! ra.87 r15) (set! rax 5) (jump ra.87 rbp rax)))
                            (define L.main.1
                              ((new-frames ()))
                              (begin
                                (set! ra.88 r15)
                                (set! x.1 rdi)
                                (set! rdi 2)
                                (set! rsi x.1)
                                (set! rdx 3)
                                (set! r15 ra.88)
                                (jump L.main.2 rbp r15 rdi rsi rdx)))
                            (define L.main.2
                              ((new-frames ()))
                              (begin
                                (set! ra.89 r15)
                                (set! x.4 rdx)
                                (set! x.3 rsi)
                                (set! x.2 rdi)
                                (set! rax x.3)
                                (jump ra.89 rbp rax)))))                             

  (check-equal? (select-instructions '(module (define L.swap.1 
                                                    (lambda (x.1 y.2) (if (< y.2 x.1) x.1 (apply L.swap.1 y.2 x.1)))) 
                                              (apply L.swap.1 1 2)))
                     '(module
                          (define L.main.32
                            ((new-frames ()))
                            (begin
                              (set! ra.90 r15)
                              (set! rdi 1)
                              (set! rsi 2)
                              (set! r15 ra.90)
                              (jump L.swap.1 rbp r15 rdi rsi)))
                          (define L.swap.1
                            ((new-frames ()))
                            (begin
                              (set! ra.91 r15)
                              (set! y.2 rsi)
                              (set! x.1 rdi)
                              (set! tmp.92 y.2)
                              (if (< tmp.92 x.1)
                                (begin (set! rax x.1) (jump ra.91 rbp rax))
                                (begin
                                  (set! rdi y.2)
                                  (set! rsi x.1)
                                  (set! r15 ra.91)
                                  (jump L.swap.1 rbp r15 rdi rsi)))))))

  (check-equal? (select-instructions  '(module (let ([v 1])
                                          (let ([w 46])
                                            (let ([x v])
                                              (let ([x (+ x 7)])
                                                (let ([y x])
                                                  (let ([y (+ y 4)])
                                                    (let ([z x])
                                                      (let ([z (+ z w)])
                                                        (let ([t.1 y])
                                                          (let ([t.1 (* t.1 -1)])
                                                            (let ([z (+ z t.1)])
                                                              z)))))))))))))
                                        '(module
                                            (define L.main.33
                                              ((new-frames ()))
                                              (begin
                                                (set! ra.93 r15)
                                                (set! v 1)
                                                (set! w 46)
                                                (set! x v)
                                                (set! tmp.94 x)
                                                (set! x (+ tmp.94 7))
                                                (set! y x)
                                                (set! tmp.95 y)
                                                (set! y (+ tmp.95 4))
                                                (set! z x)
                                                (set! tmp.96 z)
                                                (set! z (+ tmp.96 w))
                                                (set! t.1 y)
                                                (set! tmp.97 t.1)
                                                (set! t.1 (* tmp.97 -1))
                                                (set! tmp.98 z)
                                                (set! z (+ tmp.98 t.1))
                                                (set! rax z)
                                                (jump ra.93 rbp rax)))))
 
  (check-equal? (select-instructions 
                  `(module (define L.fun.1 (lambda (x.2) 12)) (+ 3 1)))
                  '(module
                      (define L.main.34
                        ((new-frames ()))
                        (begin
                          (set! ra.99 r15)
                          (set! tmp.101 3)
                          (set! tmp.100 (+ tmp.101 1))
                          (set! rax tmp.100)
                          (jump ra.99 rbp rax)))
                      (define L.fun.1
                        ((new-frames ()))
                        (begin
                          (set! ra.102 r15)
                          (set! x.2 rdi)
                          (set! rax 12)
                          (jump ra.102 rbp rax))))
                          "seelct test 4")
  
  (check-equal? (select-instructions 
                  `(module (define L.fun.2 (lambda (b.1 b.2) b.1)) 
                          (define L.fun.1 (lambda (a.1 a.2) (apply L.fun.1 a.1 a.2))) 
                          (apply L.fun.1 7 8)))
                  '(module
                      (define L.main.35
                        ((new-frames ()))
                        (begin
                          (set! ra.103 r15)
                          (set! rdi 7)
                          (set! rsi 8)
                          (set! r15 ra.103)
                          (jump L.fun.1 rbp r15 rdi rsi)))
                      (define L.fun.2
                        ((new-frames ()))
                        (begin
                          (set! ra.104 r15)
                          (set! b.2 rsi)
                          (set! b.1 rdi)
                          (set! rax b.1)
                          (jump ra.104 rbp rax)))
                      (define L.fun.1
                        ((new-frames ()))
                        (begin
                          (set! ra.105 r15)
                          (set! a.2 rsi)
                          (set! a.1 rdi)
                          (set! rdi a.1)
                          (set! rsi a.2)
                          (set! r15 ra.105)
                          (jump L.fun.1 rbp r15 rdi rsi))))
                          "seelct test 5")  
    
  (check-equal? (select-instructions 
                  `(module (define L.fun.1 (lambda (a.1) 
                                              (let ([b.1 (+ a.1 1)])
                                                b.1)))
                            (let ([b.1 10])
                              (apply L.fun.1 b.1))))
                  '(module
                      (define L.main.36
                        ((new-frames ()))
                        (begin
                          (set! ra.106 r15)
                          (set! b.1 10)
                          (set! rdi b.1)
                          (set! r15 ra.106)
                          (jump L.fun.1 rbp r15 rdi)))
                      (define L.fun.1
                        ((new-frames ()))
                        (begin
                          (set! ra.107 r15)
                          (set! a.1 rdi)
                          (set! tmp.108 a.1)
                          (set! b.1 (+ tmp.108 1))
                          (set! rax b.1)
                          (jump ra.107 rbp rax))))
                              "select test 6")                                                      
    
    
    (check-equal? (select-instructions 
                  `(module (define L.fun.1 (lambda (a.1) 
                                              (if (< a.1 100)
                                                  (let ([t.1 a.1]) (* t.1 a.1))
                                                  (apply L.fun.2 a.1))))
                            (define L.fun.2 (lambda (x.1) 
                                              (let ([x.2 (+ x.1 1)])
                                                (apply L.fun.1 x.2))))
                            (apply L.fun.1 0)))
                '(module
                    (define L.main.37
                      ((new-frames ()))
                      (begin
                        (set! ra.109 r15)
                        (set! rdi 0)
                        (set! r15 ra.109)
                        (jump L.fun.1 rbp r15 rdi)))
                    (define L.fun.1
                      ((new-frames ()))
                      (begin
                        (set! ra.110 r15)
                        (set! a.1 rdi)
                        (set! tmp.111 a.1)
                        (if (< tmp.111 100)
                          (begin
                            (set! t.1 a.1)
                            (set! tmp.113 t.1)
                            (set! tmp.112 (* tmp.113 a.1))
                            (set! rax tmp.112)
                            (jump ra.110 rbp rax))
                          (begin (set! rdi a.1) (set! r15 ra.110) (jump L.fun.2 rbp r15 rdi)))))
                    (define L.fun.2
                      ((new-frames ()))
                      (begin
                        (set! ra.114 r15)
                        (set! x.1 rdi)
                        (set! tmp.115 x.1)
                        (set! x.2 (+ tmp.115 1))
                        (set! rdi x.2)
                        (set! r15 ra.114)
                        (jump L.fun.1 rbp r15 rdi))))
                                           "select test 7")
    (check-equal? (select-instructions 
                  `(module (define L.fun.1 (lambda (a.1 a.2) a.2)) 
                          (let ([a.1 1])
                            (let ([a.2 2])
                              (apply L.fun.1 a.2 a.1)))))
                  '(module
                    (define L.main.38
                      ((new-frames ()))
                      (begin
                        (set! ra.116 r15)
                        (set! a.1 1)
                        (set! a.2 2)
                        (set! rdi a.2)
                        (set! rsi a.1)
                        (set! r15 ra.116)
                        (jump L.fun.1 rbp r15 rdi rsi)))
                    (define L.fun.1
                      ((new-frames ()))
                      (begin
                        (set! ra.117 r15)
                        (set! a.2 rsi)
                        (set! a.1 rdi)
                        (set! rax a.2)
                        (jump ra.117 rbp rax))))
                          "seelct test 8")
    
    (check-equal? (select-instructions
                  `(module (define L.fun.1 (lambda () 12))
                            (let ([a.1 L.fun.1])
                              (apply a.1))))
                  '(module
                      (define L.main.39
                        ((new-frames ()))
                        (begin
                          (set! ra.118 r15)
                          (set! a.1 L.fun.1)
                          (set! r15 ra.118)
                          (jump a.1 rbp r15)))
                      (define L.fun.1
                        ((new-frames ()))
                        (begin (set! ra.119 r15) (set! rax 12) (jump ra.119 rbp rax))))
                    "select test 9")

  (check-equal? (select-instructions 
                  `(module (define L.fun.1 (lambda (a.1) 12))
                            (let ([a.1 L.fun.1])
                              (apply a.1 L.fun.1))))
                  '(module
                      (define L.main.40
                        ((new-frames ()))
                        (begin
                          (set! ra.120 r15)
                          (set! a.1 L.fun.1)
                          (set! rdi L.fun.1)
                          (set! r15 ra.120)
                          (jump a.1 rbp r15 rdi)))
                      (define L.fun.1
                        ((new-frames ()))
                        (begin
                          (set! ra.121 r15)
                          (set! a.1 rdi)
                          (set! rax 12)
                          (jump ra.121 rbp rax))))
                    "select test 10")

; frames
; where nfv.0 must be assigned to frame location 0 in the callee’s frame.
  (check-equal? (parameterize ([current-parameter-registers '(rdi)]) 
                  (select-instructions
                  '(module (define L.fun.1 (lambda (a.1) (apply L.fun.2 a.1 7 8)))
                           (define L.fun.2 (lambda (x.1 x.2 x.3) (+ x.1 x.3)))
                           (let ([x (apply L.fun.1 L.fun.1)])
                                (apply L.fun.1 L.fun.2)))))
                                 '(module
                                    (define L.main.42
                                      ((new-frames ()))
                                      (begin
                                        (set! ra.122 r15)
                                        (return-point L.rp.41
                                          (begin
                                            (set! rdi L.fun.1)
                                            (set! r15 L.rp.41)
                                            (jump L.fun.1 rbp r15 rdi)))
                                        (set! x rax)
                                        (set! rdi L.fun.2)
                                        (set! r15 ra.122)
                                        (jump L.fun.1 rbp r15 rdi)))
                                    (define L.fun.1
                                      ((new-frames ()))
                                      (begin
                                        (set! ra.123 r15)
                                        (set! a.1 rdi)
                                        (set! fv0 7)
                                        (set! fv1 8)
                                        (set! rdi a.1)
                                        (set! r15 ra.123)
                                        (jump L.fun.2 rbp r15 rdi fv0 fv1)))
                                    (define L.fun.2
                                      ((new-frames ()))
                                      (begin
                                        (set! ra.124 r15)
                                        (set! x.3 fv1)
                                        (set! x.2 fv0)
                                        (set! x.1 rdi)
                                        (set! tmp.126 x.1)
                                        (set! tmp.125 (+ tmp.126 x.3))
                                        (set! rax tmp.125)
                                        (jump ra.124 rbp rax))))
                                "test frames")

  (check-equal? (parameterize ([current-parameter-registers '(rdi)]) 
                  (select-instructions
                  '(module (define L.fun.1 (lambda (a.1) (apply L.fun.2 a.1 7 8)))
                           (define L.fun.2 (lambda (x.1 x.2 x.3) (+ x.1 x.3)))
                           (let ([x (apply L.fun.1 L.fun.1)])
                                (let ([y (apply L.fun.2 1 2 3)])
                                  (apply L.fun.1 L.fun.2))))))
                                   '(module
                                      (define L.main.45
                                        ((new-frames ((nfv.129 nfv.128))))
                                        (begin
                                          (set! ra.127 r15)
                                          (return-point L.rp.43
                                            (begin
                                              (set! rdi L.fun.1)
                                              (set! r15 L.rp.43)
                                              (jump L.fun.1 rbp r15 rdi)))
                                          (set! x rax)
                                          (return-point L.rp.44
                                            (begin
                                              (set! rdi 1)
                                              (set! nfv.128 2)
                                              (set! nfv.129 3)
                                              (set! r15 L.rp.44)
                                              (jump L.fun.2 rbp r15 rdi nfv.128 nfv.129)))
                                          (set! y rax)
                                          (set! rdi L.fun.2)
                                          (set! r15 ra.127)
                                          (jump L.fun.1 rbp r15 rdi)))
                                      (define L.fun.1
                                        ((new-frames ()))
                                        (begin
                                          (set! ra.130 r15)
                                          (set! a.1 rdi)
                                          (set! fv0 7)
                                          (set! fv1 8)
                                          (set! rdi a.1)
                                          (set! r15 ra.130)
                                          (jump L.fun.2 rbp r15 rdi fv0 fv1)))
                                      (define L.fun.2
                                        ((new-frames ()))
                                        (begin
                                          (set! ra.131 r15)
                                          (set! x.3 fv1)
                                          (set! x.2 fv0)
                                          (set! x.1 rdi)
                                          (set! tmp.133 x.1)
                                          (set! tmp.132 (+ tmp.133 x.3))
                                          (set! rax tmp.132)
                                          (jump ra.131 rbp rax)))))

   (check-equal? (select-instructions
                  '(module (define L.fun.1 (lambda (a.1) (apply L.fun.2 a.1 7 8)))
                           (define L.fun.2 (lambda (x.1 x.2 x.3) (+ x.1 x.3)))
                           (let ([x (apply L.fun.1 L.fun.1)])
                                (let ([y (apply L.fun.2 1 2 3)])
                                  (apply L.fun.1 L.fun.2)))))
                                   '(module
                                      (define L.main.48
                                        ((new-frames ()))
                                        (begin
                                          (set! ra.134 r15)
                                          (return-point L.rp.46
                                            (begin
                                              (set! rdi L.fun.1)
                                              (set! r15 L.rp.46)
                                              (jump L.fun.1 rbp r15 rdi)))
                                          (set! x rax)
                                          (return-point L.rp.47
                                            (begin
                                              (set! rdx 1)
                                              (set! rsi 2)
                                              (set! rdi 3)
                                              (set! r15 L.rp.47)
                                              (jump L.fun.2 rbp r15 rdx rsi rdi)))
                                          (set! y rax)
                                          (set! rdi L.fun.2)
                                          (set! r15 ra.134)
                                          (jump L.fun.1 rbp r15 rdi)))
                                      (define L.fun.1
                                        ((new-frames ()))
                                        (begin
                                          (set! ra.135 r15)
                                          (set! a.1 rdi)
                                          (set! rdi a.1)
                                          (set! rsi 7)
                                          (set! rdx 8)
                                          (set! r15 ra.135)
                                          (jump L.fun.2 rbp r15 rdi rsi rdx)))
                                      (define L.fun.2
                                        ((new-frames ()))
                                        (begin
                                          (set! ra.136 r15)
                                          (set! x.3 rdx)
                                          (set! x.2 rsi)
                                          (set! x.1 rdi)
                                          (set! tmp.138 x.1)
                                          (set! tmp.137 (+ tmp.138 x.3))
                                          (set! rax tmp.137)
                                          (jump ra.136 rbp rax)))))                                 

 (check-equal? (parameterize ([current-parameter-registers '(rdi)]) 
                  (select-instructions
                  '(module (define L.fun.1 (lambda (a.1) (apply L.fun.2 a.1 7 8)))
                           (define L.fun.2 (lambda (x.1 x.2 x.3) (+ x.1 x.3)))
                           (let ([x (apply L.fun.2 L.fun.1 2 3)])
                            (let ([y (apply L.fun.2 x L.fun.1 3)])
                                (apply L.fun.1 L.fun.2))))))
                                '(module
                                      (define L.main.51
                                        ((new-frames ((nfv.141 nfv.140) (nfv.143 nfv.142))))
                                        (begin
                                          (set! ra.139 r15)
                                          (return-point L.rp.49
                                            (begin
                                              (set! rdi L.fun.1)
                                              (set! nfv.140 2)
                                              (set! nfv.141 3)
                                              (set! r15 L.rp.49)
                                              (jump L.fun.2 rbp r15 rdi nfv.140 nfv.141)))
                                          (set! x rax)
                                          (return-point L.rp.50
                                            (begin
                                              (set! rdi x)
                                              (set! nfv.142 L.fun.1)
                                              (set! nfv.143 3)
                                              (set! r15 L.rp.50)
                                              (jump L.fun.2 rbp r15 rdi nfv.142 nfv.143)))
                                          (set! y rax)
                                          (set! rdi L.fun.2)
                                          (set! r15 ra.139)
                                          (jump L.fun.1 rbp r15 rdi)))
                                      (define L.fun.1
                                        ((new-frames ()))
                                        (begin
                                          (set! ra.144 r15)
                                          (set! a.1 rdi)
                                          (set! fv0 7)
                                          (set! fv1 8)
                                          (set! rdi a.1)
                                          (set! r15 ra.144)
                                          (jump L.fun.2 rbp r15 rdi fv0 fv1)))
                                      (define L.fun.2
                                        ((new-frames ()))
                                        (begin
                                          (set! ra.145 r15)
                                          (set! x.3 fv1)
                                          (set! x.2 fv0)
                                          (set! x.1 rdi)
                                          (set! tmp.147 x.1)
                                          (set! tmp.146 (+ tmp.147 x.3))
                                          (set! rax tmp.146)
                                          (jump ra.145 rbp rax)))))

 (check-equal? (parameterize ([current-parameter-registers '(rdi)]) 
                  (select-instructions
                  '(module (define L.fun.1 (lambda (a.1) 
                              (let ([x (apply L.fun.2 a.1 22 33)])
                                (let ([y (apply L.fun.2 x a.1 y)])
                                  (apply L.fun.1 y)))))
                           (define L.fun.2 (lambda (x.1 x.2 x.3) (+ x.1 x.3)))
                           (let ([x (apply L.fun.2 L.fun.1 2 3)])
                            (let ([y (apply L.fun.2 x L.fun.1 3)])
                                (apply L.fun.1 L.fun.2))))))
                                '(module
                                    (define L.main.54
                                      ((new-frames ((nfv.150 nfv.149) (nfv.152 nfv.151))))
                                      (begin
                                        (set! ra.148 r15)
                                        (return-point L.rp.52
                                          (begin
                                            (set! rdi L.fun.1)
                                            (set! nfv.149 2)
                                            (set! nfv.150 3)
                                            (set! r15 L.rp.52)
                                            (jump L.fun.2 rbp r15 rdi nfv.149 nfv.150)))
                                        (set! x rax)
                                        (return-point L.rp.53
                                          (begin
                                            (set! rdi x)
                                            (set! nfv.151 L.fun.1)
                                            (set! nfv.152 3)
                                            (set! r15 L.rp.53)
                                            (jump L.fun.2 rbp r15 rdi nfv.151 nfv.152)))
                                        (set! y rax)
                                        (set! rdi L.fun.2)
                                        (set! r15 ra.148)
                                        (jump L.fun.1 rbp r15 rdi)))
                                    (define L.fun.1
                                      ((new-frames ((nfv.155 nfv.154) (nfv.157 nfv.156))))
                                      (begin
                                        (set! ra.153 r15)
                                        (set! a.1 rdi)
                                        (return-point L.rp.55
                                          (begin
                                            (set! rdi a.1)
                                            (set! nfv.154 22)
                                            (set! nfv.155 33)
                                            (set! r15 L.rp.55)
                                            (jump L.fun.2 rbp r15 rdi nfv.154 nfv.155)))
                                        (set! x rax)
                                        (return-point L.rp.56
                                          (begin
                                            (set! rdi x)
                                            (set! nfv.156 a.1)
                                            (set! nfv.157 y)
                                            (set! r15 L.rp.56)
                                            (jump L.fun.2 rbp r15 rdi nfv.156 nfv.157)))
                                        (set! y rax)
                                        (set! rdi y)
                                        (set! r15 ra.153)
                                        (jump L.fun.1 rbp r15 rdi)))
                                    (define L.fun.2
                                      ((new-frames ()))
                                      (begin
                                        (set! ra.158 r15)
                                        (set! x.3 fv1)
                                        (set! x.2 fv0)
                                        (set! x.1 rdi)
                                        (set! tmp.160 x.1)
                                        (set! tmp.159 (+ tmp.160 x.3))
                                        (set! rax tmp.159)
                                        (jump ra.158 rbp rax)))))
)

; Exercise 12
; Block-fvar-lang v6 -> Block-nested-lang v6
; implement abstractions:  return points and frame variables
; remove one form of addr since we do not want to allow a called function 
; to access parts of the caller’s stack.
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
      [`(set! ,v1 ,v2) 
        `(set! ,(to-addr v1) ,(to-addr v2))]
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


; test tool func
#|
(parameterize ([current-frame-base-pointer-register 'r15])
    (pretty-display
     ((compose
       replace-locations
       discard-call-live
       assign-frame-variables
       assign-registers
       assign-frames
       pre-assign-frame-variables
       conflict-analysis
       undead-analysis
       uncover-locals
       select-instructions)
      '(module
         (define L.fun.1 (lambda (x.1 x.2 x.3) 
                            (let ([x.4 (* x.2 x.3)]) (apply L.fun.2 x.4))))
          (define L.fun.2 (lambda (x.1) 
                            (if (eq? x.1 3)
                                (let ([f.1 L.fun.1])
                                  (apply f.1 x.1 x.1 x.1))
                                (let ([t.1 (apply L.fun.2 x.1)])
                                    (+ x.1 L.fun.2)))))
              (let ([x.8 (apply L.fun.1 1 2 3)])
                (let ([y.1 (apply L.fun.2 x.8)])
                  (apply L.fun.1 x.8 y.1 x.8))))
         )))


(parameterize ([current-frame-base-pointer-register 'r15])
    (pretty-display
     ((compose
       implement-fvars
       replace-locations
       discard-call-live
       assign-frame-variables
       assign-registers
       assign-frames
       pre-assign-frame-variables
       conflict-analysis
       undead-analysis
       uncover-locals
       select-instructions)
      '(module
         (define L.fun.1 (lambda (x.1 x.2 x.3) 
                            (let ([x.4 (* x.2 x.3)]) (apply L.fun.2 x.4))))
          (define L.fun.2 (lambda (x.1) 
                            (if (eq? x.1 3)
                                (let ([f.1 L.fun.1])
                                  (apply f.1 x.1 x.1 x.1))
                                (let ([t.1 (apply L.fun.2 x.1)])
                                    (+ x.1 L.fun.2)))))
              (let ([x.8 (apply L.fun.1 1 2 3)])
                (let ([y.1 (apply L.fun.2 x.8)])
                  (apply L.fun.1 x.8 y.1 x.8))))
         )))
|#

(module+ test
  (check-equal? (parameterize ([current-frame-base-pointer-register 'r15]) (implement-fvars `(module
  (define L.main.1
    ()
    (begin
      (set! fv0 r15)
      (set! r15 (+ r15 16))
      (return-point L.rp.2
        (begin
          (set! rdx 3)
          (set! rsi 2)
          (set! rdi 1)
          (set! r15 L.rp.2)
          (jump L.fun.1)))
      (set! r15 (- r15 16))
      (set! fv1 rax)
      (set! r15 (+ r15 16))
      (return-point L.rp.3
        (begin (set! rdi fv1) (set! r15 L.rp.3) (jump L.fun.2)))
      (set! r15 (- r15 16))
      (set! r15 rax)
      (set! rdx fv1)
      (set! rsi r15)
      (set! rdi fv1)
      (set! r15 fv0)
      (jump L.fun.1)))
  (define L.fun.1
    ()
    (begin
      (nop)
      (set! r14 rdi)
      (set! r14 rsi)
      (set! r13 rdx)
      (set! r14 (* r14 r13))
      (nop)
      (set! rdi r14)
      (nop)
      (jump L.fun.2)))
  (define L.fun.2
    ()
    (begin
      (set! fv0 r15)
      (set! fv1 rdi)
      (if (eq? fv1 3)
        (begin
          (set! r14 L.fun.1)
          (set! rdx fv1)
          (set! rsi fv1)
          (set! rdi fv1)
          (set! r15 fv0)
          (jump r14))
        (begin
          (set! r15 (+ r15 16))
          (return-point L.rp.4
            (begin (set! rdi fv1) (set! r15 L.rp.4) (jump L.fun.2)))
          (set! r15 (- r15 16))
          (set! r14 rax)
          (set! r14 (+ fv1 L.fun.2))
          (set! rax r14)
          (jump fv0))))))))
         '(module
  (define L.main.1
    ()
    (begin
      (set! (r15 + 0) r15)
      (set! r15 (+ r15 16))
      (return-point L.rp.2
        (begin
          (set! rdx 3)
          (set! rsi 2)
          (set! rdi 1)
          (set! r15 L.rp.2)
          (jump L.fun.1)))
      (set! r15 (- r15 16))
      (set! (r15 + 8) rax)
      (set! r15 (+ r15 16))
      (return-point L.rp.3
        (begin (set! rdi (r15 + -8)) (set! r15 L.rp.3) (jump L.fun.2)))
      (set! r15 (- r15 16))
      (set! r15 rax)
      (set! rdx (r15 + 8))
      (set! rsi r15)
      (set! rdi (r15 + 8))
      (set! r15 (r15 + 0))
      (jump L.fun.1)))
  (define L.fun.1
    ()
    (begin
      (nop)
      (set! r14 rdi)
      (set! r14 rsi)
      (set! r13 rdx)
      (set! r14 (* r14 r13))
      (nop)
      (set! rdi r14)
      (nop)
      (jump L.fun.2)))
  (define L.fun.2
    ()
    (begin
      (set! (r15 + 0) r15)
      (set! (r15 + 8) rdi)
      (if (eq? (r15 + 8) 3)
        (begin
          (set! r14 L.fun.1)
          (set! rdx (r15 + 8))
          (set! rsi (r15 + 8))
          (set! rdi (r15 + 8))
          (set! r15 (r15 + 0))
          (jump r14))
        (begin
          (set! r15 (+ r15 16))
          (return-point L.rp.4
            (begin (set! rdi (r15 + -8)) (set! r15 L.rp.4) (jump L.fun.2)))
          (set! r15 (- r15 16))
          (set! r14 rax)
          (set! r14 (+ (r15 + 8) L.fun.2))
          (set! rax r14)
          (jump (r15 + 0)))))))) 

  (check-equal? (implement-fvars '(module
                                    (define L.main.1
                                      ()
                                      (begin (nop) 
                                        (set! fv1 2) 
                                        (set! fv0 1) 
                                        (nop) 
                                        (jump L.swap.1)))
                                    (define L.swap.1
                                      ()
                                      (begin
                                        (set! fv2 r15)
                                        (set! r15 fv0)
                                        (set! r14 fv1)
                                        (if (< r14 r15)
                                          (begin (set! rax r15) 
                                                 (jump fv2))
                                          (begin
                                            (set! rbp (+ rbp 24))
                                            (return-point L.rp.2
                                              (begin
                                                (set! fv3 r15)
                                                (set! fv4 r14)
                                                (set! r15 L.rp.2)
                                                (jump L.swap.1)))
                                            (set! rbp (- rbp 24))
                                            (set! r15 rax)
                                            (set! rax r15)
                                            (jump fv2)))))))
                                   '(module
                                      (define L.main.1
                                        ()
                                        (begin (nop) 
                                                (set! (rbp + 8) 2) 
                                                (set! (rbp + 0) 1) 
                                                (nop) 
                                                (jump L.swap.1)))
                                      (define L.swap.1
                                        ()
                                        (begin
                                          (set! (rbp + 16) r15)
                                          (set! r15 (rbp + 0))
                                          (set! r14 (rbp + 8))
                                          (if (< r14 r15)
                                            (begin (set! rax r15) (jump (rbp + 16)))
                                            (begin
                                              (set! rbp (+ rbp 24))
                                              (return-point L.rp.2
                                                (begin
                                                  (set! (rbp + 0) r15)
                                                  (set! (rbp + 8) r14)
                                                  (set! r15 L.rp.2)
                                                  (jump L.swap.1)))
                                              (set! rbp (- rbp 24))
                                              (set! r15 rax)
                                              (set! rax r15)
                                              (jump (rbp + 16)))))))         )

   (check-equal? (implement-fvars '(module
                                    (define L.main.1
                                      ()
                                      (begin
                                        (nop)
                                        (set! r14 1)
                                        (set! r13 2)
                                        (set! r14 (+ r14 r13))
                                        (set! rax r14)
                                        (jump r15)))
                                    (define L.swap.1
                                      ()
                                      (begin
                                        (set! fv2 r15)
                                        (set! r15 fv0)
                                        (set! r14 fv1)
                                        (if (< r14 r15)
                                          (begin (set! rax r15) (jump fv2))
                                          (begin
                                            (set! rbp (+ rbp 24))
                                            (return-point L.rp.2
                                              (begin
                                                (set! fv3 r15)
                                                (set! fv4 r14)
                                                (set! r15 L.rp.2)
                                                (jump L.swap.1)))
                                            (set! rbp (- rbp 24))
                                            (set! r15 rax)
                                            (set! rax r15)
                                            (jump fv2)))))))
                                      `(module
                                          (define L.main.1
                                            ()
                                            (begin
                                              (nop)
                                              (set! r14 1)
                                              (set! r13 2)
                                              (set! r14 (+ r14 r13))
                                              (set! rax r14)
                                              (jump r15)))
                                          (define L.swap.1
                                            ()
                                            (begin
                                              (set! (rbp + 16) r15)
                                              (set! r15 (rbp + 0))
                                              (set! r14 (rbp + 8))
                                              (if (< r14 r15)
                                                (begin (set! rax r15) (jump (rbp + 16)))
                                                (begin
                                                  (set! rbp (+ rbp 24))
                                                  (return-point L.rp.2
                                                    (begin
                                                      (set! (rbp + 0) r15)
                                                      (set! (rbp + 8) r14)
                                                      (set! r15 L.rp.2)
                                                      (jump L.swap.1)))
                                                  (set! rbp (- rbp 24))
                                                  (set! r15 rax)
                                                  (set! rax r15)
                                                  (jump (rbp + 16))))))))

  (check-equal? (implement-fvars `(module (define L.main.1 () (begin (nop) (set! rax 42) (jump r15)))))
          `(module (define L.main.1 () (begin (nop) (set! rax 42) (jump r15)))))

  (check-equal? (implement-fvars `(module
                                    (define L.main.1
                                      ()
                                      (begin
                                        (set! fv3 r15)
                                        (set! rbp (+ rbp 32))
                                        (return-point L.rp.2
                                          (begin
                                            (set! fv4 3)
                                            (set! fv5 2)
                                            (set! fv6 1)
                                            (set! r15 L.rp.2)
                                            (jump L.fun.1)))
                                        (set! rbp (- rbp 32))
                                        (set! fv0 rax)
                                        (set! rbp (+ rbp 32))
                                        (return-point L.rp.3
                                          (begin
                                            (set! fv4 5)
                                            (set! fv5 4)
                                            (set! fv6 fv0)
                                            (set! r15 L.rp.3)
                                            (jump L.fun.1)))
                                        (set! rbp (- rbp 32))
                                        (set! r15 rax)
                                        (set! fv2 fv0)
                                        (set! fv1 r15)
                                        (nop)
                                        (set! r15 fv3)
                                        (jump L.fun.1)))
                                    (define L.fun.1
                                      ()
                                      (begin
                                        (nop)
                                        (set! r14 fv0)
                                        (set! r13 fv1)
                                        (set! r12 fv2)
                                        (set! r9 (* r13 r12))
                                        (nop)
                                        (set! fv2 r12)
                                        (set! fv1 r13)
                                        (set! fv0 r14)
                                        (nop)
                                        (jump L.fun.1)))))
                       `(module
                          (define L.main.1
                            ()
                            (begin
                              (set! (rbp + 24) r15)
                              (set! rbp (+ rbp 32))
                              (return-point L.rp.2
                                (begin
                                  (set! (rbp + 0) 3)
                                  (set! (rbp + 8) 2)
                                  (set! (rbp + 16) 1)
                                  (set! r15 L.rp.2)
                                  (jump L.fun.1)))
                              (set! rbp (- rbp 32))
                              (set! (rbp + 0) rax)
                              (set! rbp (+ rbp 32))
                              (return-point L.rp.3
                                (begin
                                  (set! (rbp + 0) 5)
                                  (set! (rbp + 8) 4)
                                  (set! (rbp + 16) (rbp + -32))
                                  (set! r15 L.rp.3)
                                  (jump L.fun.1)))
                              (set! rbp (- rbp 32))
                              (set! r15 rax)
                              (set! (rbp + 16) (rbp + 0))
                              (set! (rbp + 8) r15)
                              (nop)
                              (set! r15 (rbp + 24))
                              (jump L.fun.1)))
                          (define L.fun.1
                            ()
                            (begin
                              (nop)
                              (set! r14 (rbp + 0))
                              (set! r13 (rbp + 8))
                              (set! r12 (rbp + 16))
                              (set! r9 (* r13 r12))
                              (nop)
                              (set! (rbp + 16) r12)
                              (set! (rbp + 8) r13)
                              (set! (rbp + 0) r14)
                              (nop)
                              (jump L.fun.1))))) 

  (check-equal? (implement-fvars `(module
                                    (define L.main.1
                                      ()
                                      (begin
                                        (set! fv0 r15)
                                        (set! rbp (+ rbp 16))
                                        (return-point L.rp.2
                                          (begin
                                            (set! rdx 3)
                                            (set! rsi 2)
                                            (set! rdi 1)
                                            (set! r15 L.rp.2)
                                            (jump L.fun.1)))
                                        (set! rbp (- rbp 16))
                                        (set! fv1 rax)
                                        (set! rbp (+ rbp 16))
                                        (return-point L.rp.3
                                          (begin
                                            (set! rdx 5)
                                            (set! rsi 4)
                                            (set! rdi fv1)
                                            (set! r15 L.rp.3)
                                            (jump L.fun.1)))
                                        (set! rbp (- rbp 16))
                                        (set! r15 rax)
                                        (set! rdx fv1)
                                        (set! rsi r15)
                                        (set! rdi fv1)
                                        (set! r15 fv0)
                                        (jump L.fun.1)))
                                    (define L.fun.1
                                      ()
                                      (begin
                                        (nop)
                                        (set! r14 rdi)
                                        (set! r13 rsi)
                                        (set! r12 rdx)
                                        (set! r9 (* r13 r12))
                                        (nop)
                                        (set! rdx r12)
                                        (set! rsi r13)
                                        (set! rdi r14)
                                        (nop)
                                        (jump L.fun.1)))))
                          `(module
                              (define L.main.1
                                ()
                                (begin
                                  (set! (rbp + 0) r15)
                                  (set! rbp (+ rbp 16))
                                  (return-point L.rp.2
                                    (begin
                                      (set! rdx 3)
                                      (set! rsi 2)
                                      (set! rdi 1)
                                      (set! r15 L.rp.2)
                                      (jump L.fun.1)))
                                  (set! rbp (- rbp 16))
                                  (set! (rbp + 8) rax)
                                  (set! rbp (+ rbp 16))
                                  (return-point L.rp.3
                                    (begin
                                      (set! rdx 5)
                                      (set! rsi 4)
                                      (set! rdi (rbp + -8))
                                      (set! r15 L.rp.3)
                                      (jump L.fun.1)))
                                  (set! rbp (- rbp 16))
                                  (set! r15 rax)
                                  (set! rdx (rbp + 8))
                                  (set! rsi r15)
                                  (set! rdi (rbp + 8))
                                  (set! r15 (rbp + 0))
                                  (jump L.fun.1)))
                              (define L.fun.1
                                ()
                                (begin
                                  (nop)
                                  (set! r14 rdi)
                                  (set! r13 rsi)
                                  (set! r12 rdx)
                                  (set! r9 (* r13 r12))
                                  (nop)
                                  (set! rdx r12)
                                  (set! rsi r13)
                                  (set! rdi r14)
                                  (nop)
                                  (jump L.fun.1)))))          

  (check-equal? (implement-fvars `(module
                                    (define L.main.1
                                      ()
                                      (begin
                                        (set! fv3 r15)
                                        (set! rbp (+ rbp 32))
                                        (return-point L.rp.2
                                          (begin
                                            (set! fv4 3)
                                            (set! fv5 2)
                                            (set! fv6 1)
                                            (set! r15 L.rp.2)
                                            (jump L.fun.1)))
                                        (set! rbp (- rbp 32))
                                        (set! fv0 rax)
                                        (set! rbp (+ rbp 32))
                                        (return-point L.rp.3
                                          (begin (set! fv4 fv0) (set! r15 L.rp.3) (jump L.fun.2)))
                                        (set! rbp (- rbp 32))
                                        (set! r15 rax)
                                        (set! fv2 fv0)
                                        (set! fv1 r15)
                                        (nop)
                                        (set! r15 fv3)
                                        (jump L.fun.1)))
                                    (define L.fun.1
                                      ()
                                      (begin
                                        (nop)
                                        (set! r14 fv0)
                                        (set! r13 fv1)
                                        (set! r12 fv2)
                                        (set! r9 (* r13 r12))
                                        (nop)
                                        (set! fv2 r12)
                                        (set! fv1 r13)
                                        (set! fv0 r14)
                                        (nop)
                                        (jump L.fun.1)))
                                    (define L.fun.2
                                      ()
                                      (begin
                                        (set! fv3 r15)
                                        (nop)
                                        (if (eq? fv0 3)
                                          (begin
                                            (set! fv2 fv0)
                                            (set! fv1 fv0)
                                            (nop)
                                            (set! r15 fv3)
                                            (jump L.fun.1))
                                          (begin
                                            (set! rbp (+ rbp 32))
                                            (return-point L.rp.4
                                              (begin (set! fv4 fv0) (set! r15 L.rp.4) (jump L.fun.2)))
                                            (set! rbp (- rbp 32))
                                            (set! r15 rax)
                                            (set! r15 1)
                                            (set! r15 (+ r15 fv0))
                                            (set! rax r15)
                                            (jump fv3)))))))
                            `(module
                              (define L.main.1
                                ()
                                (begin
                                  (set! (rbp + 24) r15)
                                  (set! rbp (+ rbp 32))
                                  (return-point L.rp.2
                                    (begin
                                      (set! (rbp + 0) 3)
                                      (set! (rbp + 8) 2)
                                      (set! (rbp + 16) 1)
                                      (set! r15 L.rp.2)
                                      (jump L.fun.1)))
                                  (set! rbp (- rbp 32))
                                  (set! (rbp + 0) rax)
                                  (set! rbp (+ rbp 32))
                                  (return-point L.rp.3
                                    (begin (set! (rbp + 0) (rbp + -32)) (set! r15 L.rp.3) (jump L.fun.2)))
                                  (set! rbp (- rbp 32))
                                  (set! r15 rax)
                                  (set! (rbp + 16) (rbp + 0))
                                  (set! (rbp + 8) r15)
                                  (nop)
                                  (set! r15 (rbp + 24))
                                  (jump L.fun.1)))
                              (define L.fun.1
                                ()
                                (begin
                                  (nop)
                                  (set! r14 (rbp + 0))
                                  (set! r13 (rbp + 8))
                                  (set! r12 (rbp + 16))
                                  (set! r9 (* r13 r12))
                                  (nop)
                                  (set! (rbp + 16) r12)
                                  (set! (rbp + 8) r13)
                                  (set! (rbp + 0) r14)
                                  (nop)
                                  (jump L.fun.1)))
                              (define L.fun.2
                                ()
                                (begin
                                  (set! (rbp + 24) r15)
                                  (nop)
                                  (if (eq? (rbp + 0) 3)
                                    (begin
                                      (set! (rbp + 16) (rbp + 0))
                                      (set! (rbp + 8) (rbp + 0))
                                      (nop)
                                      (set! r15 (rbp + 24))
                                      (jump L.fun.1))
                                    (begin
                                      (set! rbp (+ rbp 32))
                                      (return-point L.rp.4
                                        (begin
                                          (set! (rbp + 0) (rbp + -32))
                                          (set! r15 L.rp.4)
                                          (jump L.fun.2)))
                                      (set! rbp (- rbp 32))
                                      (set! r15 rax)
                                      (set! r15 1)
                                      (set! r15 (+ r15 (rbp + 0)))
                                      (set! rax r15)
                                      (jump (rbp + 24))))))))    

  (check-equal? (implement-fvars `(module
                                    (define L.main.1
                                      ()
                                      (begin
                                        (set! fv2 r15)
                                        (set! rbp (+ rbp 24))
                                        (return-point L.rp.2
                                          (begin
                                            (set! fv3 3)
                                            (set! fv4 2)
                                            (set! rsi 1)
                                            (set! r15 L.rp.2)
                                            (jump L.fun.1)))
                                        (set! rbp (- rbp 24))
                                        (set! fv1 rax)
                                        (set! rbp (+ rbp 24))
                                        (return-point L.rp.3
                                          (begin (set! rsi fv1) (set! r15 L.rp.3) (jump L.fun.2)))
                                        (set! rbp (- rbp 24))
                                        (set! r15 rax)
                                        (nop)
                                        (set! fv0 r15)
                                        (set! rsi fv1)
                                        (set! r15 fv2)
                                        (jump L.fun.1)))
                                    (define L.fun.1
                                      ()
                                      (begin
                                        (nop)
                                        (set! r14 rsi)
                                        (set! r13 fv0)
                                        (set! r12 fv1)
                                        (set! r9 (* r13 r12))
                                        (nop)
                                        (set! fv1 r12)
                                        (set! fv0 r13)
                                        (set! rsi r14)
                                        (nop)
                                        (jump L.fun.1)))
                                    (define L.fun.2
                                      ()
                                      (begin
                                        (set! fv2 r15)
                                        (set! fv0 rsi)
                                        (if (eq? fv0 3)
                                          (begin
                                            (set! fv1 fv0)
                                            (nop)
                                            (set! rsi fv0)
                                            (set! r15 fv2)
                                            (jump L.fun.1))
                                          (begin
                                            (set! rbp (+ rbp 24))
                                            (return-point L.rp.4
                                              (begin (set! rsi fv0) (set! r15 L.rp.4) (jump L.fun.2)))
                                            (set! rbp (- rbp 24))
                                            (set! r15 rax)
                                            (set! r15 1)
                                            (set! r15 (+ r15 fv0))
                                            (set! rax r15)
                                            (jump fv2)))))))
              `(module
                  (define L.main.1
                    ()
                    (begin
                      (set! (rbp + 16) r15)
                      (set! rbp (+ rbp 24))
                      (return-point L.rp.2
                        (begin
                          (set! (rbp + 0) 3)
                          (set! (rbp + 8) 2)
                          (set! rsi 1)
                          (set! r15 L.rp.2)
                          (jump L.fun.1)))
                      (set! rbp (- rbp 24))
                      (set! (rbp + 8) rax)
                      (set! rbp (+ rbp 24))
                      (return-point L.rp.3
                        (begin (set! rsi (rbp + -16)) (set! r15 L.rp.3) (jump L.fun.2)))
                      (set! rbp (- rbp 24))
                      (set! r15 rax)
                      (nop)
                      (set! (rbp + 0) r15)
                      (set! rsi (rbp + 8))
                      (set! r15 (rbp + 16))
                      (jump L.fun.1)))
                  (define L.fun.1
                    ()
                    (begin
                      (nop)
                      (set! r14 rsi)
                      (set! r13 (rbp + 0))
                      (set! r12 (rbp + 8))
                      (set! r9 (* r13 r12))
                      (nop)
                      (set! (rbp + 8) r12)
                      (set! (rbp + 0) r13)
                      (set! rsi r14)
                      (nop)
                      (jump L.fun.1)))
                  (define L.fun.2
                    ()
                    (begin
                      (set! (rbp + 16) r15)
                      (set! (rbp + 0) rsi)
                      (if (eq? (rbp + 0) 3)
                        (begin
                          (set! (rbp + 8) (rbp + 0))
                          (nop)
                          (set! rsi (rbp + 0))
                          (set! r15 (rbp + 16))
                          (jump L.fun.1))
                        (begin
                          (set! rbp (+ rbp 24))
                          (return-point L.rp.4
                            (begin (set! rsi (rbp + -24)) (set! r15 L.rp.4) (jump L.fun.2)))
                          (set! rbp (- rbp 24))
                          (set! r15 rax)
                          (set! r15 1)
                          (set! r15 (+ r15 (rbp + 0)))
                          (set! rax r15)
                          (jump (rbp + 16))))))))            
                                        

  (check-equal? (implement-fvars `(module
                                    (define L.main.1
                                      ()
                                      (begin
                                        (set! fv2 r15)
                                        (set! rbp (+ rbp 24))
                                        (return-point L.rp.2
                                          (begin
                                            (set! fv3 3)
                                            (set! fv4 2)
                                            (set! rsi 1)
                                            (set! r15 L.rp.2)
                                            (jump L.fun.1)))
                                        (set! rbp (- rbp 24))
                                        (set! fv1 rax)
                                        (set! rbp (+ rbp 24))
                                        (return-point L.rp.3
                                          (begin (set! rsi fv1) (set! r15 L.rp.3) (jump L.fun.2)))
                                        (set! rbp (- rbp 24))
                                        (set! r15 rax)
                                        (nop)
                                        (set! fv0 r15)
                                        (set! rsi fv1)
                                        (set! r15 fv2)
                                        (jump L.fun.1)))
                                    (define L.fun.1
                                      ()
                                      (begin
                                        (nop)
                                        (set! r14 rsi)
                                        (set! r14 fv0)
                                        (set! r13 fv1)
                                        (set! r14 (* r14 r13))
                                        (nop)
                                        (set! rsi r14)
                                        (nop)
                                        (jump L.fun.2)))
                                    (define L.fun.2
                                      ()
                                      (begin
                                        (set! fv2 r15)
                                        (set! fv0 rsi)
                                        (if (eq? fv0 3)
                                          (begin
                                            (set! r14 L.fun.1)
                                            (set! fv1 fv0)
                                            (nop)
                                            (set! rsi fv0)
                                            (set! r15 fv2)
                                            (jump r14))
                                          (begin
                                            (set! rbp (+ rbp 24))
                                            (return-point L.rp.4
                                              (begin (set! rsi fv0) (set! r15 L.rp.4) (jump L.fun.2)))
                                            (set! rbp (- rbp 24))
                                            (set! r15 rax)
                                            (set! r15 (+ fv0 L.fun.2))
                                            (set! rax r15)
                                            (jump fv2)))))))
              '(module
                  (define L.main.1
                    ()
                    (begin
                      (set! (rbp + 16) r15)
                      (set! rbp (+ rbp 24))
                      (return-point L.rp.2
                        (begin
                          (set! (rbp + 0) 3)
                          (set! (rbp + 8) 2)
                          (set! rsi 1)
                          (set! r15 L.rp.2)
                          (jump L.fun.1)))
                      (set! rbp (- rbp 24))
                      (set! (rbp + 8) rax)
                      (set! rbp (+ rbp 24))
                      (return-point L.rp.3
                        (begin (set! rsi (rbp + -16)) (set! r15 L.rp.3) (jump L.fun.2)))
                      (set! rbp (- rbp 24))
                      (set! r15 rax)
                      (nop)
                      (set! (rbp + 0) r15)
                      (set! rsi (rbp + 8))
                      (set! r15 (rbp + 16))
                      (jump L.fun.1)))
                  (define L.fun.1
                    ()
                    (begin
                      (nop)
                      (set! r14 rsi)
                      (set! r14 (rbp + 0))
                      (set! r13 (rbp + 8))
                      (set! r14 (* r14 r13))
                      (nop)
                      (set! rsi r14)
                      (nop)
                      (jump L.fun.2)))
                  (define L.fun.2
                    ()
                    (begin
                      (set! (rbp + 16) r15)
                      (set! (rbp + 0) rsi)
                      (if (eq? (rbp + 0) 3)
                        (begin
                          (set! r14 L.fun.1)
                          (set! (rbp + 8) (rbp + 0))
                          (nop)
                          (set! rsi (rbp + 0))
                          (set! r15 (rbp + 16))
                          (jump r14))
                        (begin
                          (set! rbp (+ rbp 24))
                          (return-point L.rp.4
                            (begin (set! rsi (rbp + -24)) (set! r15 L.rp.4) (jump L.fun.2)))
                          (set! rbp (- rbp 24))
                          (set! r15 rax)
                          (set! r15 (+ (rbp + 0) L.fun.2))
                          (set! rax r15)
                          (jump (rbp + 16))))))))
)

; Exercise 14
;  Block-asm-lang v6 -> Paren-asm v6
; Redesign and extend the implementation of the function flatten-program.
; flatten all blocks into straight-line code
(define (flatten-program p)

  (define (flatten-tail t)
    (match t 
      [`(begin ,s ... ,tail)
        `(,@s ,@(flatten-tail tail))]
      [`(begin ,tail)
        `(,@(flatten-tail tail))]
      [`(jump ,trg)
        `((jump ,trg))]
      [`(if (,cmp ,v1 ,v2) (jump ,l1) (jump ,l2))
        `((compare ,v1 ,v2)
          (jump-if ,cmp ,l1)
          (jump ,l2))]))

  (define (find-tail label t)
    (match t
      [`(begin ,s ... ,tail)
        (if (empty? s)
            (find-tail label tail)
            (cons `(define ,label ,(first s)) `(,@(rest s) ,@(flatten-tail tail))))
        ]
      [`(begin ,tail)
        (find-tail label tail)]
      [`(jump ,trg)
        `((define ,label ,t))]
      [`(if (,cmp ,v1 ,v2) (jump ,l1) (jump ,l2)) #:when (cmp? cmp)
        `((define ,label (compare ,v1 ,v2))
          (jump-if ,cmp ,l1)
          (jump ,l2))])
  )

  (define (flatten-b b)
    (match b 
      [`(define ,label ,info ,tail)
        (find-tail label tail)]))

; (displayln (format "flatten ~a" p))
  (match p
    [`(module ,bs ...) 
      `(begin ,@(append (append-map flatten-b bs)))]
    ))

(module+ test 
  (check-equal? (flatten-program
  '(module
     (define L.main.3
       ()
       (begin
         (set! (rbp + 0) r15)
         (set! rbp (+ rbp 8))
         (set! rsi 2)
         (set! rdi 1)
         (set! r15 L.rp.4)
         (jump L.L.f.1.2)))
     (define L.L.f.1.2
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
         (set! r14 1)
         (set! r15 (+ r15 r14))
         (set! rax r15)
         (jump (rbp + 0))))))
  '(begin
    (define L.main.3 (set! (rbp + 0) r15))
    (set! rbp (+ rbp 8))
    (set! rsi 2)
    (set! rdi 1)
    (set! r15 L.rp.4)
    (jump L.L.f.1.2)
    (define L.L.f.1.2 (nop))
    (set! r14 rdi)
    (set! r13 rsi)
    (set! r14 (+ r14 r13))
    (set! rax r14)
    (jump r15)
    (define L.rp.4 (set! rbp (- rbp 8)))
    (set! r15 rax)
    (set! r14 1)
    (set! r15 (+ r15 r14))
    (set! rax r15)
    (jump (rbp + 0))))

    (check-equal? (flatten-program
    '(module (define L.start.1 () (begin (set! r8 1) (jump (rbp + 0))))))
    '(begin (define L.start.1 (set! r8 1)) (jump (rbp + 0))))

    (check-equal? (flatten-program
    '(module (define L.start.1 () (begin (begin (jump (rbp + 0)))))))
    '(begin (define L.start.1 (jump (rbp + 0)))))

    (check-equal? (flatten-program 
    '(module (define L.start.1 () (begin (set! r12 64) (begin (jump (rbp + 0)))))
      (define L.start.2 () 
        (begin (set! rax (- (rbp + 8) L.start.1)) 
               (if (eq? (rbp + 8) rax) 
                    (jump L.start.2)
                    (jump rax))))))
    '(begin
        (define L.start.1 (set! r12 64))
        (jump (rbp + 0))
        (define L.start.2 (set! rax (- (rbp + 8) L.start.1)))
        (compare (rbp + 8) rax)
        (jump-if eq? L.start.2)
        (jump rax)))

    (check-equal? (flatten-program 
    '(module (define L.start.1 () (begin (jump L.start.1)))))
    '(begin (define L.start.1 (jump L.start.1))))

    (check-equal? (flatten-program
     '(module (define L.start.1 () (begin (if (< rax (rbp + 16))
                                              (jump L.start.1)
                                              (jump L.start.2))))))
     '(begin
        (define L.start.1 (compare rax (rbp + 16)))
        (jump-if < L.start.1)
        (jump L.start.2)))

    (check-equal? (flatten-program
      '(module (define L.start.1 () (begin (set! rax rax) (set! rax rsp) 
                                      (begin (set! rax 1) (set! r11 45) (jump L.start.2))))
               (define L.start.2 () (begin (set! rax rax) (set! rax rsp) 
                                      (begin (set! rax 1) (set! r11 45) (jump L.start.3))))
                (define L.start.3 () (begin (set! rax rax) (set! rax rsp) 
                                      (begin (set! rax 1) (set! r11 45) (jump L.start.1))))))
      '(begin
          (define L.start.1 (set! rax rax))
          (set! rax rsp)
          (set! rax 1)
          (set! r11 45)
          (jump L.start.2)
          (define L.start.2 (set! rax rax))
          (set! rax rsp)
          (set! rax 1)
          (set! r11 45)
          (jump L.start.3)
          (define L.start.3 (set! rax rax))
          (set! rax rsp)
          (set! rax 1)
          (set! r11 45)
          (jump L.start.1)))
      
    (check-equal? (flatten-program 
        '(module (define L.start.1 () (begin (set! (rbp + 8) rax) (jump L.start.1)))))
        '(begin (define L.start.1 (set! (rbp + 8) rax)) (jump L.start.1)))
)

; Exercise 15
;  Paren-asm v6 -> Paren-x64 v6
; redesign and extend patch-instructions, which translate Paren-asm v6 to Paren-x64 v6
; consider edge cases carefully, such as (set! (rbp + 0) (+ (rbp + 8) 2147483648)). use (current-patch-instructions-registers)
(define (patch-instructions p)

  (define tmp1 (first (current-patch-instructions-registers)))
  (define tmp2 (second (current-patch-instructions-registers)))

  (define (prloc? r)
    (or (valid-addr? r) (register? r)))


  
  (define (patch-jump trg)
    (cond 
      [(label? trg) (list `(jump ,trg))]
      [(register? trg) (list `(jump ,trg))]
      [(valid-addr? trg) (list `(set! ,tmp1 ,trg) `(jump ,tmp1))]))
  
  (define (patch-cmp s)
   (match s 
    [`(compare ,addr1 ,addr2) #:when (and (valid-addr? addr1) (valid-addr? addr2))
      (list `(set! ,tmp1 ,addr2)
            `(set! ,tmp1 (* ,tmp1 -1))
            `(set! ,tmp1 (+ ,tmp1 ,addr1))
            `(compare ,tmp1 0))]
    [`(compare ,addr1 ,v2) #:when (valid-addr? addr1)
      (list `(set! ,tmp1 ,addr1)
            `(compare ,tmp1 ,v2))]
    [`(compare ,v1 ,addr2) #:when (valid-addr? addr2)
      (list `(set! ,tmp1 ,addr2)
            `(compare ,v1 ,tmp1))]
    [`(compare ,v1 ,v2)
      (list s)]))
  

  (define (patch-binop s)
    (match s
      [`(set! ,reg (,binop ,reg ,num)) #:when (and (or (int32? num) (prloc? num)) (register? reg))
        (list s)] 
      [`(set! ,reg (,binop ,reg ,num)) #:when (and (int64? num) (register? reg))
        (list `(set! ,tmp1 ,num) `(set! ,reg (,binop ,reg ,tmp1)))] 
      [`(set! ,addr1 (,binop ,addr2 ,num)) #:when (and (or (int32? num) (valid-addr? num) (register? num)) (valid-binop? binop) (prloc? addr1) (prloc? addr2))
        (list `(set! ,tmp1 ,addr2)
              `(set! ,tmp1 (,binop ,tmp1 ,num))
              `(set! ,addr1 ,tmp1))]
      [`(set! ,addr1 (,binop ,addr2 ,num)) #:when (and (int64? num) (valid-binop? binop) (prloc? addr1) (prloc? addr2))
        (list `(set! ,tmp1 ,addr2)
              `(set! ,tmp2 ,num)
              `(set! ,tmp1 (,binop ,tmp1 ,tmp2))
              `(set! ,addr1 ,tmp1))]
      ))

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
      [`(set! ,v1 ,v2)
        (list s)]
      [`(nop) (list s)]))

  (match p 
    [`(begin ,s ...) `(begin ,@(append-map patch-s s))]))

;; used for tracking tests
#;(uniquify '(module (define f1 (lambda (x y) (+ x y)))
                (let ([x f1])
                  (apply x 1 2))))
#;(uniquify '(module 
                (+ 1 3)))
#;(uniquify '(module 
                (let ([x (- 13 3)])
                  x)))
#;(uniquify '(module 
                (let ([x (- 13 3)])
                  (if (> x 10)
                    (+ x x)
                    (- x x))))) 
#;(uniquify '(module (define f (lambda (x) (if (> x 10) (- x 1) (apply g x 1))))
                      (define g (lambda (x y) (let ([x (+ x y)]) (apply f x))))
                      (apply f 100)))                                    
#;(parameterize ([current-parameter-registers '(rdi)]) (uniquify '(module (define f (lambda (x) (if (> x 10) (- x 1) (apply g x 1))))
                      (define g (lambda (x y) (let ([x (+ x y)]) (apply f x))))
                      (apply f 100))))  
(module+ test
  (check-equal? (patch-instructions `(begin (define L.start.1 (jump rax))))
    '(begin (define L.start.1 (jump rax))))
  
  (check-equal? (patch-instructions `(begin (define L.start.1 (jump L.start.1))))
    '(begin (define L.start.1 (jump L.start.1))))
  
  (check-equal? (patch-instructions `(begin (define L.start.1 (jump (rbp + 800)))))
    `(begin (define L.start.1 (set! r10 (rbp + 800))) (jump r10)))

  (check-equal? (patch-instructions `(begin (define L.start.1 (set! rax 10)) (compare (rbp + 16) (rbp - 16)) (jump-if < L.start.1)
        (jump L.start.2)))
    `(begin
        (define L.start.1 (set! rax 10))
        (set! r10 (rbp - 16))
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
                                      (compare r8 (rbp - 8))
                                      (compare (rbp - 16) r10)
                                      (compare (rbp + 8) 66)
                                      (compare (rbp + 16) (rbp + 16))
                                      (compare (rbp + 16) (rbp + 24))
                                      (jump-if >= L.start.1)))
                                    `(begin
                                        (define L.start.1 (set! r8 1))
                                        (set! r10 (rbp - 8))
                                        (compare r8 r10)
                                        (set! r10 (rbp - 16))
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
)

; Exercise 16
; Paren-x64-v3 -> x64
; translate Paren-x64-v3 to x64 executable instructions
(define (generate-x64 p) 
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
       (string-join (map statement->x64 s) "")]
      [_ (error "Invalid Paren-x64-v3")]))

  ; (Paren-x64-v3 Statement) -> x64
  (define (statement->x64 s)
  ;(displayln (format "to x64 statement: ~a" s))
    (match s
      [`(set! ,loc ,v)
       #:when (and (valid-loc? loc) (not (list? v)))
       (format "mov ~a, ~a\n  " (loc->x64 loc) v)]
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
       (format "~a:\n  ~a" label (statement->x64 s))]
      [`(jump ,trg)
       (format "jmp ~a\n" trg)]
      [`(compare ,reg ,opand)
       (format "cmp ~a, ~a\n  " reg opand)] ;; missing , in cmp
      [`(jump-if ,cmp ,trg)
       (format "~a ~a\n  " (cmp->jmp cmp) trg)]
      [`(nop) ""]
      [_ (error "Invalid Paren-x64-v3 statement")]
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