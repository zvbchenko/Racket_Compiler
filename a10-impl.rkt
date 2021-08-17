#lang racket

(require
    "a10-compiler-lib.rkt"
    "a10-graph-lib.rkt"
    "share/util.rkt")

(provide 
uniquify
expand-macros
optimize-known-calls
purify-letrec
convert-assigned
define->letrec
dox-lambdas
uncover-free
convert-closures)

(module+ test
  (require rackunit))

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

; Exercise 1
; Racketish -> Racketish-Unique
; Exercise 6
; Racketish-Surface -> Racketish-Surface-Unique
; what uniquify does isdischarge the last assumption, we know which names refer to which abstract locations,
; and thus introduce the last abstraction
; uniquify replace variables to alocs
; letrec is not restricted to bind procedures
(define (uniquify p)

    ;; Var -> Value
    (define (unique-empty-env x)
      #f)

    (define (reserved? e) 
      (member e `(if let letrec)))
   
    (define (init-function bs env)
        (if (empty? bs)
            env
            (match (first bs)
                [`(define ,x ,lams) 
                    (init-function (rest bs) (extend-env x (fresh x) env))]    
            )))

    (define (list-extend-env args env)
        (if (empty? args)
            env
            (list-extend-env (rest args) (extend-env (first args) (fresh (first args)) env))))

    (define (uniquify-b b env) 
        (match b 
            [`(define ,x (lambda (,args ...) ,e))
                (let ([b-env (list-extend-env args env)])
                    `(define ,(b-env x) (lambda ,(map (lambda (x) (b-env x)) args) ,(uniquify-e e b-env))))]
            [`(define ,x ,e) `(define ,(env x) ,(uniquify-e e env))]))

    (define (uniquify-v v env)
        (match v 
            [`,num #:when (fixnum? v) v]
            [#t #t]
            [#f #f]
            ['() '()]
            [`(void) '(void)]
            [`,var #:when(env var) (env var)]
            [`,prim #:when (prim-f? prim) prim]
            [`(error ,code) #:when (uint8? code) v]
            [`,char #:when (ascii-char-literal? char)
                char]
            [`(lambda (,args ...) ,e)
                (let ([b-env (list-extend-env args env)])
                    `(lambda ,(map (lambda (x) (b-env x)) args) ,(uniquify-e e b-env)))]
            [`,var (env var)]))

    (define (uniquify-e e env) 
    ; (displayln (format "uniquify-e ~a" e))
        (match e 
            [`(,v1 ,vs ...)  #:when (env v1)
              ; (displayln (format "e-e-e ~a v1 ~a reserved? ~a isSymbol ~a" e v1 (reserved? v1) (symbol? v1)))
                `(,(uniquify-e v1 env) ,@(map (lambda (x) (uniquify-e x env)) vs))]
            [`(,ma ,vs ...) #:when (primop? ma)
                `(,ma ,@(map (lambda (x) (uniquify-e x env)) vs))]
            [`(,binop ,v1 ,v2) #:when (valid-binop? binop)
                `(,binop ,(uniquify-e v1 env) ,(uniquify-e v2 env))]
            [`#(,es ...) e]
            [`(quote ,es) e]
            [`(,ma ,vs ...) #:when (macro-id? ma)
                `(,ma ,@(map (lambda (x) (uniquify-e x env)) vs))]
            [`(let ([,x ,n]) ,e1)
                (let* ([new-x (fresh x)]
                    [e-env (extend-env x new-x env)]) 
                `(let ([,new-x ,(uniquify-e n env)]) ,(uniquify-e e1 e-env)))]
            [`(letrec ([,xs ,es] ...) ,ee)
                (let ([new-env env])
                    (map (lambda (x) (set! new-env (extend-env x (fresh x) new-env))) xs)
                    `(letrec ,(map (lambda (x y) 
                                    `(,(new-env x) ,(uniquify-e y new-env))) xs es) ,(uniquify-e ee new-env)))]
            [`(if ,e1 ,e2 ,e3) 
                `(if ,(uniquify-e e1 env) ,(uniquify-e e2 env) ,(uniquify-e e3 env))]
            [`(,v1 ,vs ...) #:when (not-reserved? v1)
              ; (displayln (format "e-e-e ~a v1 ~a reserved? ~a isSymbol ~a" e v1 (reserved? v1) (symbol? v1)))
                `(,(uniquify-e v1 env) ,@(map (lambda (x) (uniquify-e x env)) vs))]
            [`,v (uniquify-v v env)]))   

    (displayln (format "uniquify ~a" p))
    (match p
        [`(module ,b ... ,e)
           (let ([new-env (init-function b unique-empty-env)])
            `(module ,@(map (lambda (x) (uniquify-b x new-env)) b) ,(uniquify-e e new-env)))])
    )

(module+ test 
    (check-equal? (uniquify `(module (letrec ([x 7]) ( + x 9))))
        '(module (letrec ((x.1 7)) ( + x.1 9))))

    (check-equal? (uniquify `(module (letrec ([x (letrec ([y 9]) x)]) x)))
       '(module (letrec ((x.2 (letrec ((y.3 9)) x.2))) x.2)))

    (check-equal? (uniquify '(module (letrec ([f (lambda (x) ( f x 10))]) ( * f 9))))
        '(module (letrec ((f.4 (lambda (x.5) (f.4 x.5 10)))) (* f.4 9))))

    (check-equal? (uniquify '(module (letrec ([f (g f 8)]
                                              [g (lambda (f t) (not f))])
                                              g)))
                        '(module
   (letrec ((f.6 (g.7 f.6 8)) (g.7 (lambda (f.8 t.9) (not f.8))))
     g.7)))
    
    (check-equal? (uniquify '(module (let ([g (+ 9 8)])
                                        (letrec ([f (+ g 9)])
                                            (+ g f)))))
                            '(module
   (let ((g.10 (+ 9 8)))
     (letrec ((f.11 (+ g.10 9))) (+ g.10 f.11)))))

    (check-equal? (uniquify '(module (letrec ([g (+ f 8)][f 12])
                                        (let ([f (+ g 9)])
                                            (+ g f)))))
                        '(module
   (letrec ((g.12 (+ f.13 8)) (f.13 12))
     (let ((f.14 (+ g.12 9))) (+ g.12 f.14)))))
    
    ; might cause error
    (check-equal? (uniquify '(module (letrec ([f (+ h 10)][h f])
                                        (let ([g f])
                                            (letrec ([h (+ g f)])
                                                g)))))
                       '(module
   (letrec ((f.15 (+ h.16 10)) (h.16 f.15))
     (let ((g.17 f.15)) (letrec ((h.18 (+ g.17 f.15))) g.17)))))

    ; might cause error
    (check-equal? (uniquify `(module (letrec ([f (+ 8 g)][g (lambda (x y) (+ x y))])
                                        (letrec ([g (+ f 10)])
                                            (+ f g)))))
                         '(module
   (letrec ((f.19 (+ 8 g.20))
            (g.20 (lambda (x.21 y.22) (+ x.21 y.22))))
     (letrec ((g.23 (+ f.19 10))) (+ f.19 g.23)))))



    )

;; exercise 2
;  Impure-Exprs-safe-lang v10 -> Just-Exprs-lang v10
; turn defines to letrec
(define (define->letrec p)
    (define (toletrec b)
        (match b 
            [`(define ,name ,lam) `(,name ,lam)]))
    
    (displayln (format "define->letrec ~a" p))
    (match p
        [`(module ,bs ... ,e) 
            `(module (letrec ,(map toletrec bs) ,e))])
    )


(module+ test
    (check-equal? (define->letrec  '(module
                                        (define x1.22 (lambda (arg1.24 arg2.25) 89))
                                        (define x2.23 (lambda (arg1.26 arg2.27) (apply x1.22 arg2.27 arg1.26)))
                                        (let ((x3.28 x1.22)) x2.23)))
                                    '(module
  (letrec ((x1.22 (lambda (arg1.24 arg2.25) 89))
           (x2.23 (lambda (arg1.26 arg2.27) (apply x1.22 arg2.27 arg1.26))))
    (let ((x3.28 x1.22)) x2.23))))

    (check-equal? (define->letrec '(module (define f.1 (lambda (arg.1 arg.2) arg.1))
                                                f.1))
                                                '(module (letrec ((f.1 (lambda (arg.1 arg.2) arg.1))) f.1)))

    (check-equal? (define->letrec '(module 17))
                                               '(module (letrec () 17)))

    (check-equal? (define->letrec '(module (define f.1 (lambda (arg.1) f.1))
                                            (lambda (f.1) f.1)))
                                '(module (letrec ((f.1 (lambda (arg.1) f.1))) (lambda (f.1) f.1))))
    
    (check-equal?  (define->letrec  '(module
                                        (define x1.22 (lambda (arg1.24 arg2.25) 89))
                                        (define x2.23 (lambda (arg1.26 arg2.27) (apply x1.22 arg2.27 arg1.26)))
                                        (letrec ((x3.28 x1.22) (f.12 12)) x2.23)))
                                    '(module
                                        (letrec ((x1.22 (lambda (arg1.24 arg2.25) 89))
                                                (x2.23 (lambda (arg1.26 arg2.27) (apply x1.22 arg2.27 arg1.26))))
                                            (letrec ((x3.28 x1.22) (f.12 12)) x2.23))))

)


;; Exercise 3 purify-letrec
; purify all letrecs so letrec only binds procedures
; simple binding: the bound expression e contains no occurrences of the variables xs bound by the letrec expression 
                    ; and no applications unless the application is a prim-f with simple operands. 
                    ; We can also reduce compile time by considering letrec non-simple; otherwise, 
                    ; the simple check may be non-linear in the number of let-bindings.
; lambda binding: A binding `[,x ,e] is lambda if e is literally a lambda value.
; Complex binding: otherwise
(define (purify-letrec p) 

    (define (simple? e env)
      (match e 
        [`,n #:when (number? n) #t]
        [`,b #:when (boolean? b) #t]
        [`,prim #:when (prim-f? prim) #t]
        [`(void) #t]
        [`() #t]
        [`(error ,n) #t]
        [`,aloc #:when (aloc? aloc) (member aloc env)]
        [`(apply ,prim ,es ...) #:when (prim-f? prim) (andmap (lambda (x) (simple? x env)) es)]
        [else #f]))  
    
    (define (letrec-impl alocs es env e2)
      (let* ([simple-binds empty]
             [lam-binds empty]
             [complex-binds (make-hash)])
        (for ([al alocs]
              [ee es])
            (match ee 
              [`(lambda ,args ,body) (set! lam-binds (cons `(,al ,(purify-impl ee env)) lam-binds))]
              [`,e #:when (simple? e env) (set! simple-binds (cons `(,al ,e) simple-binds))]
              [else (dict-set! complex-binds al (purify-impl ee env))]))
        `(let (info ((assigned ())))
          ,simple-binds
          (let (info ((assigned ,(dict-keys complex-binds))))
            ,(map (lambda (x) `(,x (void))) (dict-keys complex-binds))
            (letrec ,lam-binds 
              (let (info ((assigned ()))) 
                ,(map (lambda (x) (let* ([new-al (fresh x)]
                                        [eval `(,new-al ,(dict-ref complex-binds x))])
                                    (dict-set! complex-binds x new-al) eval)) (dict-keys complex-binds))
                (begin ,@(map (lambda (x) `(set! ,x ,(dict-ref complex-binds x))) (dict-keys complex-binds)) ,(purify-impl e2 (append alocs env)))))))))

    (define (purify-impl e env)
        (match e
           [`(apply ,e1 ,es ...) `(apply ,(purify-impl e1 env) ,@(map (lambda (x) (purify-impl x env)) es))]
            [`(let ([,aloc ,e1]) ,e2) `(let (info ((assigned ()))) ([,aloc ,(purify-impl e1 env)]) ,(purify-impl e2 (cons aloc env)))]
            [`(letrec ([,alocs ,es] ...) ,e2) 
                (letrec-impl alocs es env e2)]
            [`(if ,e1 ,e2 ,e3)
                `(if ,(purify-impl e1 env) ,(purify-impl e2 env) ,(purify-impl e3 env))]
            [`(lambda ,args ,ee)
                `(lambda ,args ,(purify-impl ee (append args env)))]
            [_ e]))

    (match p 
        [`(module ,e) `(module ,(purify-impl e empty))]))

(module+ test

    (check-equal? (purify-letrec `(module (let ([x.1 7])
                                    (letrec ([x.2 (apply * x.1 x.1)]
                                              [x.3 (apply * x.2 x.2)])
                                            x.2))))
                                 '(module
     (let (info ((assigned ())))
       ((x.1 7))
       (let (info ((assigned ())))
         ((x.2 (apply * x.1 x.1)))
         (let (info ((assigned (x.3))))
           ((x.3 (void)))
           (letrec ()
             (let (info ((assigned ())))
               ((x.3.24 (apply * x.2 x.2)))
               (begin (set! x.3 x.3.24) x.2))))))))

    (check-equal? (purify-letrec '(module (letrec ([f.1 (lambda (x.1) (letrec ([x.2 x.1]) x.2))]) (apply f.1 1))))
                    '(module
                        (let (info ((assigned ())))
                          ()
                          (let (info ((assigned ())))
                            ()
                            (letrec ((f.1
                                      (lambda (x.1)
                                        (let (info ((assigned ())))
                                          ((x.2 x.1))
                                          (let (info ((assigned ())))
                                            ()
                                            (letrec ()
                                              (let (info ((assigned ()))) () (begin x.2))))))))
                              (let (info ((assigned ()))) () (begin (apply f.1 1))))))))

    (check-equal? (purify-letrec `(module (let ([x.1 (apply * 4 9)])
                                            (letrec ([x.2 x.1])
                                                x.2))))
                                '(module
  (let (info ((assigned ())))
    ((x.1 (apply * 4 9)))
    (let (info ((assigned ())))
      ((x.2 x.1))
      (let (info ((assigned ())))
        ()
        (letrec () (let (info ((assigned ()))) () (begin x.2))))))))


    (check-equal? (purify-letrec `(module (let ([x.1 (let ([x.3 34]) x.3)])
                                            (letrec ([x.2 x.1])
                                                x.2))))
            '(module
  (let (info ((assigned ())))
    ((x.1 (let (info ((assigned ()))) ((x.3 34)) x.3)))
    (let (info ((assigned ())))
      ((x.2 x.1))
      (let (info ((assigned ())))
        ()
        (letrec () (let (info ((assigned ()))) () (begin x.2))))))))

    (check-equal? (purify-letrec `(module (let ([x.1 (lambda () 123)])
                                            (letrec ([x.2 x.1])
                                                x.2))))
                    '(module
  (let (info ((assigned ())))
    ((x.1 (lambda () 123)))
    (let (info ((assigned ())))
      ((x.2 x.1))
      (let (info ((assigned ())))
        ()
        (letrec () (let (info ((assigned ()))) () (begin x.2))))))))

    (check-equal? (purify-letrec `(module (letrec ([x.1 12]) x.1)))
                   '(module
  (let (info ((assigned ())))
    ((x.1 12))
    (let (info ((assigned ())))
      ()
      (letrec () (let (info ((assigned ()))) () (begin x.1))))))
      "simple simple")

    (check-match (purify-letrec `(module (letrec ([x.1 13] [x.2 14]) x.1)))
        `(module
  (let (info ((assigned ())))
    ,(list-no-order `(x.1 13) `(x.2 14))
    (let (info ((assigned ())))
      ()
      (letrec () (let (info ((assigned ()))) () (begin x.1)))))))

    (check-equal? (purify-letrec `(module (letrec ([x.1 13] [x.2 x.1]) x.1)))
        '(module
  (let (info ((assigned ())))
    ((x.1 13))
    (let (info ((assigned (x.2))))
      ((x.2 (void)))
      (letrec ()
        (let (info ((assigned ())))
          ((x.2.25 x.1))
          (begin (set! x.2 x.2.25) x.1)))))))

    (check-equal? (purify-letrec `(module (letrec ([x.1 13] [x.2 (apply * 13 x.1)]) x.1)))
                    '(module
  (let (info ((assigned ())))
    ((x.1 13))
    (let (info ((assigned (x.2))))
      ((x.2 (void)))
      (letrec ()
        (let (info ((assigned ())))
          ((x.2.26 (apply * 13 x.1)))
          (begin (set! x.2 x.2.26) x.1))))))
          "simple combined")


    (check-equal? (purify-letrec `(module (let ([x.2 3]) (letrec ([x.1 x.2]) (apply * x.1 x.2)))))
                        '(module
  (let (info ((assigned ())))
    ((x.2 3))
    (let (info ((assigned ())))
      ((x.1 x.2))
      (let (info ((assigned ())))
        ()
        (letrec ()
          (let (info ((assigned ()))) () (begin (apply * x.1 x.2)))))))))

    (check-equal? (purify-letrec `(module (let ([x.2 (apply * 1 2)]) x.2)))
        '(module (let (info ((assigned ()))) ((x.2 (apply * 1 2))) x.2)))

    (check-equal? (purify-letrec '(module (letrec ([x.1 13])
                                            (letrec ([x.2 x.1]) x.1))))
                                '(module
  (let (info ((assigned ())))
    ((x.1 13))
    (let (info ((assigned ())))
      ()
      (letrec ()
        (let (info ((assigned ())))
          ()
          (begin
            (let (info ((assigned ())))
              ((x.2 x.1))
              (let (info ((assigned ())))
                ()
                (letrec () (let (info ((assigned ()))) () (begin x.1)))))))))))   )

    (check-equal? (purify-letrec '(module (letrec ([x.1 *] [x.2 (apply x.1 3 9)]) x.2)))
                    '(module
  (let (info ((assigned ())))
    ((x.1 *))
    (let (info ((assigned (x.2))))
      ((x.2 (void)))
      (letrec ()
        (let (info ((assigned ())))
          ((x.2.27 (apply x.1 3 9)))
          (begin (set! x.2 x.2.27) x.2)))))))

    (check-match (purify-letrec '(module (letrec ([x.1 #t] [x.2 (void)] [x.3 (error 8)]
                                                    [x.4 ()] [x.5 (apply * 1 2)]) 9)))
                                `(module
  (let (info ((assigned ())))
    ,(list-no-order `(x.1 #t) `(x.2 (void)) `(x.3 (error 8)) `(x.4 ()) `(x.5 (apply * 1 2)))
    (let (info ((assigned ())))
      ()
      (letrec () (let (info ((assigned ()))) () (begin 9))))))  )
    
    (check-equal? (purify-letrec '(module (let ([o.1 *])
                                            (letrec ([x.1 (apply o.1 13 32)])
                                                x.1))))
                '(module
  (let (info ((assigned ())))
    ((o.1 *))
    (let (info ((assigned ())))
      ()
      (let (info ((assigned (x.1))))
        ((x.1 (void)))
        (letrec ()
          (let (info ((assigned ())))
            ((x.1.28 (apply o.1 13 32)))
            (begin (set! x.1 x.1.28) x.1))))))))
        
    (check-equal? (purify-letrec '(module (letrec ([x.1 (lambda () (apply * 1 3))]) x.1)))
            '(module
  (let (info ((assigned ())))
    ()
    (let (info ((assigned ())))
      ()
      (letrec ((x.1 (lambda () (apply * 1 3))))
        (let (info ((assigned ()))) () (begin x.1)))))))

    (check-equal? (purify-letrec '(module (letrec ([x.1 (lambda (x.1) (letrec ([x.2 13]) x.1))]) x.1)))
                    '(module
  (let (info ((assigned ())))
    ()
    (let (info ((assigned ())))
      ()
      (letrec ((x.1
                (lambda (x.1)
                  (let (info ((assigned ())))
                    ((x.2 13))
                    (let (info ((assigned ())))
                      ()
                      (letrec ()
                        (let (info ((assigned ()))) () (begin x.1))))))))
        (let (info ((assigned ()))) () (begin x.1)))))))

    (check-equal? (purify-letrec '(module (letrec ([x.1 (apply cons 1 (lambda () y.1))]
                                 [y.1 (let ([y.1 5]) x.1)])
                                          (apply + (apply car x.1) (apply car ((cdr x.1)))))))
                        '(module
  (let (info ((assigned ())))
    ()
    (let (info ((assigned (x.1 y.1))))
      ((x.1 (void)) (y.1 (void)))
      (letrec ()
        (let (info ((assigned ())))
          ((x.1.29 (apply cons 1 (lambda () y.1)))
           (y.1.30 (let (info ((assigned ()))) ((y.1 5)) x.1)))
          (begin
            (set! x.1 x.1.29)
            (set! y.1 y.1.30)
            (apply + (apply car x.1) (apply car ((cdr x.1)))))))))))

    (check-equal? (purify-letrec `(module (letrec ([x.1 (lambda () 100)]
                                                   [x.2 x.1])
                                                   x.2)))
                            '(module
  (let (info ((assigned ())))
    ()
    (let (info ((assigned (x.2))))
      ((x.2 (void)))
      (letrec ((x.1 (lambda () 100)))
        (let (info ((assigned ())))
          ((x.2.31 x.1))
          (begin (set! x.2 x.2.31) x.2)))))))
       
)


;; Exerciese 4 
; convert set! to vector-set!
; `(let (info ((assigned (x.1))))
;       ([x.1 (void)])
;    (let (info ((assigned ())))
;      ([tmp.2 (apply cons 1 (lambda () x.1))])
;      (begin
;        (set! x.1 tmp.2)
;        x.1)))
; =>
; `(let ([x.1 (apply make-vector 1)])
;    (let ([tmp.2 (apply cons 1 (lambda () (apply vector-ref x.1 0)))])
;      (let ([tmp.3 (apply vector-set! x.1 0 tmp.2)])
;        x.1)))
(define (convert-assigned p) 

  (define (convert-set e env)
    (match e 
      [`(set! ,e1 ,e2) `(,(fresh) (apply vector-set! ,e1 0 ,(convert-impl e2 env)))]))

  (define (convert-impl e env)
    (match e 
      [`,aloc #:when (aloc? aloc) (if (member aloc env)
                                      `(apply vector-ref ,aloc 0)
                                      aloc)]
      [`(,primop ,es ...) #:when (primop? primop) `(,primop ,@(map (lambda (x) (convert-impl x env)) es))]
      [`(apply ,e1 ,es ...) `(apply ,(convert-impl e1 env) ,@(map (lambda (x) (convert-impl x env)) es))]
      [`(let (info ((assigned ,assigns))) ([,aloc ,es] ...) ,e2) 
          `(let ,(map (lambda (x y) (if (and (equal? y '(void)) (member x assigns))
                                          `(,x (apply make-vector 1))
                                          `(,x ,(convert-impl y env)) )) aloc es) ,(convert-impl e2 (append assigns env)))]
      [`(letrec ([,fname ,lams] ...) ,ee)
          `(letrec ,(map (lambda (x y) `(,x ,(convert-impl y env))) fname lams) ,(convert-impl ee env))]
      [`(if ,e1 ,e2 ,e3) `(if ,(convert-impl e1 env) ,(convert-impl e2 env) ,(convert-impl e3 env))]
      [`(begin ,es ... ,ee)
          (if (empty? es)
              (convert-impl ee env)
              `(let ,(map (lambda (x) (convert-set x env)) es)
                                ,(convert-impl ee env)))]
      [`(lambda ,args ,body) `(lambda ,args ,(convert-impl body env))]
      [else e]))
  
  (match p 
    [`(module ,e) `(module ,(convert-impl e empty))]))

(module+ test
  (check-equal? (convert-assigned `(module (let (info ((assigned (x.1))))
                                        ([x.1 (void)])
                                    (let (info ((assigned ())))
                                      ([tmp.2 (apply cons 1 (lambda () x.1))])
                                      (begin
                                        (set! x.1 tmp.2)
                                        x.1)))))
    '(module
  (let ((x.1 (apply make-vector 1)))
    (let ((tmp.2 (apply cons 1 (lambda () (apply vector-ref x.1 0)))))
      (let ((tmp.32 (apply vector-set! x.1 0 tmp.2)))
        (apply vector-ref x.1 0))))))

  (check-equal? (convert-assigned '(module
     (let (info ((assigned ())))
       ((x.1 7))
       (let (info ((assigned ())))
         ((x.2 (apply * x.1 x.1)))
         (let (info ((assigned (x.3))))
           ((x.3 (void)))
           (letrec ()
             (let (info ((assigned ())))
               ((x.3.24 (apply * x.2 x.2)))
               (begin (set! x.3 x.3.24) x.2))))))))
               '(module
  (let ((x.1 7))
    (let ((x.2 (apply * x.1 x.1)))
      (let ((x.3 (apply make-vector 1)))
        (letrec ()
          (let ((x.3.24 (apply * x.2 x.2)))
            (let ((tmp.33 (apply vector-set! x.3 0 x.3.24))) x.2))))))))

  (check-equal? (convert-assigned '(module
                        (let (info ((assigned ())))
                          ()
                          (let (info ((assigned ())))
                            ()
                            (letrec ((f.1
                                      (lambda (x.1)
                                        (let (info ((assigned ())))
                                          ((x.2 x.1))
                                          (let (info ((assigned ())))
                                            ()
                                            (letrec ()
                                              (let (info ((assigned ()))) () (begin x.2))))))))
                              (let (info ((assigned ()))) () (begin (apply f.1 1))))))))
                        '(module
  (let ()
    (let ()
      (letrec ((f.1
                (lambda (x.1)
                  (let ((x.2 x.1)) (let () (letrec () (let () x.2)))))))
        (let () (apply f.1 1)))))))

  (check-equal? (convert-assigned '(module 
                                      (let (info ((assigned (x.1)))) ([x.1 (void)]) 
                                        (letrec ([f.1 (lambda (x.1) (let (info ((assigned (x.2)))) ([x.2 (void)]) 
                                                                      (begin (set! x.2 x.1) x.2)))])
                                                                      f.1))))
               '(module
  (let ((x.1 (apply make-vector 1)))
    (letrec ((f.1
              (lambda (x.1)
                (let ((x.2 (apply make-vector 1)))
                  (let ((tmp.34
                         (apply vector-set! x.2 0 (apply vector-ref x.1 0))))
                    (apply vector-ref x.2 0))))))
      f.1))))

  (check-equal? (convert-assigned '(module (let (info ((assigned (x.1 x.2))))
                                              ([x.1 (void)] [x.2 (void)])
                                          (let (info ((assigned ())))
                                            ([tmp.2 (apply cons 1 (lambda () x.1))])
                                            (begin
                                              (set! x.1 tmp.2)
                                              x.1)))))
                '(module
  (let ((x.1 (apply make-vector 1)) (x.2 (apply make-vector 1)))
    (let ((tmp.2 (apply cons 1 (lambda () (apply vector-ref x.1 0)))))
      (let ((tmp.35 (apply vector-set! x.1 0 tmp.2)))
        (apply vector-ref x.1 0))))))

  (check-equal? (convert-assigned '(module (let (info ((assigned (x.1))))
                                              ([x.1 (void)] [x.2 8])
                                          (let (info ((assigned ())))
                                            ([tmp.2 (apply cons 1 (lambda () x.1))])
                                            (begin
                                              (set! x.1 tmp.2)
                                              x.1)))))
                      '(module
  (let ((x.1 (apply make-vector 1)) (x.2 8))
    (let ((tmp.2 (apply cons 1 (lambda () (apply vector-ref x.1 0)))))
      (let ((tmp.36 (apply vector-set! x.1 0 tmp.2)))
        (apply vector-ref x.1 0))))))

  (check-equal? (convert-assigned `(module (let (info ((assigned (x.1))))
                                        ([x.1 (void)])
                                    (let (info ((assigned (x.1))))
                                      ([x.1 (void)] [tmp.2 (apply cons 1 (lambda () x.1))])
                                      (begin
                                        (set! x.1 tmp.2)
                                        x.1)))))
            '(module
  (let ((x.1 (apply make-vector 1)))
    (let ((x.1 (apply make-vector 1))
          (tmp.2 (apply cons 1 (lambda () (apply vector-ref x.1 0)))))
      (let ((tmp.37 (apply vector-set! x.1 0 tmp.2)))
        (apply vector-ref x.1 0))))))

  )


;; Exercise 5
; ajust multi-arity let
(define (dox-lambdas p)
    
    (define (dox-impl e) 
        (match e 
            [`(apply ,e1 ,es ...) `(apply ,(dox-impl e1) ,@(map dox-impl es))]
            [`(letrec ([,alocs (lambda ,args ,es)] ...) ,e2) 
                `(letrec (,@(map (lambda (x y z) `[,x (lambda ,y ,(dox-impl z))]) alocs args  es)) ,(dox-impl e2))]
            [`(let ([,alocs ,es] ...) ,e2) `(let ,(map (lambda (x y) `(,x ,(dox-impl y))) alocs es) ,(dox-impl e2))]
            [`(if ,e1 ,e2 ,e3)
                `(if ,(dox-impl e1) ,(dox-impl e2) ,(dox-impl e3))]
            [`(lambda ,args ,ee)
                (let ([t1 (fresh)]) `(letrec ([,t1 (lambda ,args ,(dox-impl ee))]) ,t1))]
            [_ e]))
    
    (displayln (format "dox-lambdas ~a" p))

    (match p 
        [`(module ,e) `(module ,(dox-impl e))]))

(module+ test 
   (check-equal? (dox-lambdas '(module (let ([x.2 (apply (lambda (arg.1 arg.2) arg.1) 2 3)])
                                             x.2)))
                                '(module
   (let ((x.2
          (apply (letrec ((tmp.38 (lambda (arg.1 arg.2) arg.1))) tmp.38) 2 3)))
     x.2)))

  (check-equal? (dox-lambdas '(module (let ([x.2 (apply (lambda (arg.1 arg.2) arg.1) 2 3)]
                                           [x.3 (apply (lambda (arg.1 arg.2) arg.1) 2 3)])
                                             x.2)))
                                            '(module
  (let ((x.2 (apply (letrec ((tmp.39 (lambda (arg.1 arg.2) arg.1))) tmp.39) 2 3))
        (x.3
         (apply (letrec ((tmp.40 (lambda (arg.1 arg.2) arg.1))) tmp.40) 2 3)))
    x.2)) )
)

;; uncover-free
(define (uncover-free p) 

    (define (find-in-env var env)
        (if (member var env)
            empty
            (list var)))
    
    (define (uncover-lam exp)
        (match exp
            [`(lambda (,args ...) ,e)
                (let-values ([(stmt frees) (uncover-e e args)])
                    (let ([frees^  empty])
                    (map (lambda (x) (let-values ([(t1 t2) (uncover-e x args)]) (set! frees^ (append t2 frees^)))) (remove-duplicates frees))
                    (values `(lambda ,args (free ,(reverse frees^)) ,stmt) frees^)))]))

    (define (uncover-e e env)
        (match e
            [`,aloc #:when (aloc? aloc) 
                (values aloc (find-in-env aloc env))]
            [`(,primop ,es ...) #:when (prim-f? primop)
                (let ([tt empty]
                      [el empty])
                    (for ([et es])
                        (let-values ([(pre post) (uncover-e et env)])
                            (set! tt (append post tt))
                            (set! el (cons pre el))))
                    (values `(,primop ,@(reverse el)) tt))]
            [`(apply ,e1 ,es ...) 
                (let ([tt '()]
                      [el empty])
                      (let-values ([(et1 et2) (uncover-e e1 env)])
                        (set! tt (append et2 tt))
                        (for ([et es])
                            (let-values ([(pre post) (uncover-e et env)])
                                (set! tt (append post tt))
                                (set! el (cons pre el))))
                        (values `(apply ,et1 ,@(reverse el)) tt)))]
            ; [`(let ([,aloc ,e1] ...) ,e2) 
            ;     (let ([tt empty])
            ;         (let-values ([(et1 et2) (uncover-e e1 env)]
            ;                      [(et3 et4) (uncover-e e2 env)])
            ;                 (values `(let ([,aloc ,et1]) ,et3) (append et2 et4))))]
            [`(let ([,fname ,lams] ...) ,ee)
                (let-values ([(et1 et2) (uncover-e ee (append fname env))])
                    (values `(let ,(map (lambda (x y) 
                                             (let-values ([(u1 u2) (uncover-e y env)])
                                                (set! et2 (append (remq x u2) et2))   
                                                `(,x ,u1))) fname lams) ,et1) et2))]
            [`(letrec ([,fname ,lams] ...) ,ee)
                (let-values ([(et1 et2) (uncover-e ee (append fname env))])
                    (values `(letrec ,(map (lambda (x y) 
                                             (let-values ([(u1 u2) (uncover-lam y)])
                                                (set! et2 (append (remq x u2) et2))   
                                                `(,x ,u1))) fname lams) ,et1) et2))]
            [`(if ,e1 ,e2 ,e3) 
                (let-values ([(e11 e12) (uncover-e e1 env)]
                             [(e21 e22) (uncover-e e2 env)]
                             [(e31 e32) (uncover-e e3 env)])
                    (values `(if ,e11 ,e21 ,e31) (append e12 e22 e32)))]
            [`(begin ,cs ... ,e3) 
                (let ([tt empty]
                      [el empty])
                    (for ([et cs])
                        (let-values ([(pre post) (uncover-e et env)])
                            (set! tt (append post tt))
                            (set! el (append pre el))))
                    (let-values ([(pre-e post-e) (uncover-e e3 env)])
                        (values `(begin ,el ,pre-e) (append el post-e))))]
            [else (values e empty)]
            ))

    (displayln (format "uncover-free ~a" p))
    (match p 
        [`(module ,e)
            (let-values ([(res temp) (uncover-e e empty)])
            `(module ,res))])
    )

(module+ test 

  (check-equal? (uncover-free `(module (letrec ((vector-init-loop.70 (lambda (len.71 i.73 vec.72) 
                      (if (eq? len.71 i.73) vec.72 
                      (begin (unsafe-vector-set! vec.72 i.73 0) 
                              (apply vector-init-loop.70 len.71 (unsafe-fx+ i.73 1) vec.72)))))) 
                            (letrec () (apply cons 7 ())))))

                      '(module
    (letrec ((vector-init-loop.70
              (lambda (len.71 i.73 vec.72)
                (free (vector-init-loop.70))
                (if (eq? len.71 i.73)
                  vec.72
                  (begin
                    (unsafe-vector-set! vec.72 i.73 0)
                    (apply
                    vector-init-loop.70
                    len.71
                    (unsafe-fx+ i.73 1)
                    vec.72))))))
      (letrec () (apply cons 7 ()))))
      )

  (check-equal? (uncover-free '(module (let ([x.1 7])
                                            (letrec ([f.1 (lambda (a.1 a.2) x.1)])
                                                f.1))))
                                '(module
                                    (let ((x.1 7)) (letrec ((f.1 (lambda (a.1 a.2) (free (x.1)) x.1))) f.1))))

  (check-equal? (uncover-free '(module (letrec ([f.1 (lambda (x.1 x.2) (apply f.1 x.1 x.2))])
                                            (let ([x.1 f.1])
                                                (apply f.1 x.1 f.1)))))
                                '(module
                                    (letrec ((f.1 (lambda (x.1 x.2) (free (f.1)) (apply f.1 x.1 x.2))))
                                        (let ((x.1 f.1)) (apply f.1 x.1 f.1)))))      

  (check-equal? (uncover-free '(module (let ([x.1 7] [x.3 99])
                                            (letrec ([f.1 (lambda (a.1 a.2) x.3)])
                                                f.1))))
                                '(module
  (let ((x.1 7) (x.3 99))
    (letrec ((f.1 (lambda (a.1 a.2) (free (x.3)) x.3))) f.1))))


)

;; convert-closures
(define (convert-closures p)
    
    (define (make-fenv fname env)
        (if (empty? fname)
            env
            (make-fenv (rest fname) (extend-env (first fname) (fresh-label (first fname)) env))))
    
    (define (make-dick fname env)
        (if (empty? fname)
            env
            (make-dick (rest fname) (extend-env (first fname) (fresh 'c) env))))

    (define (convert-lam fname body dic)
        (let ([env-name (dic fname)])
            (match body
                [`(lambda ,args (free ,frees) ,rbody)
                    `(lambda ,(cons env-name args) 
                        (let ,(map (lambda (x)  `(,x (closure-ref ,env-name ,(index-of frees x)))) frees)
                            ,(convert-e rbody)))])))

    (define (convert-closure func name)
        (match func
            [`(lambda ,args (free ,frees) ,rbody)
                `(make-closure ,name ,(length args) ,@frees)]))

    (define (convert-e e)
        (match e 
            [`(letrec ([,fname ,lams] ...) ,ee) 
                (let ([fenv (make-fenv fname empty-env)]
                      [dic-env (make-dick fname empty-env)])
                    `(letrec ,(map (lambda (x y) `(,(fenv x) ,(convert-lam x y dic-env))) fname lams) 
                        (cletrec ,(map (lambda (x y) `(,x ,(convert-closure y (fenv x)))) fname lams) ,(convert-e ee))))]
            [`(apply ,e1 ,es ...)
              (if (aloc? e1)
               `(closure-apply ,e1 ,e1 ,@(map convert-e es))
               (let ([tmp (fresh)])
                  `(let ([,tmp ,(convert-e e1)])
                      (closure-apply ,tmp ,tmp ,@(map convert-e es)))))]
            [`(let ([,aloc ,e1] ...) ,e2)
                `(let ,(map (lambda (x y) `(,x ,(convert-e y))) aloc e1) ,(convert-e e2))]
            [`(if ,e1 ,e2 ,e3) `(if ,(convert-e e1) ,(convert-e e2) ,(convert-e e3))]
            [`(,primop ,es ...) #:when (prim-f? primop)
                `(,primop ,@(map convert-e es))]
            [`(begin ,es ...)
                `(begin ,@(map convert-e es))]
            [else e]))

    
    (displayln (format "convert-closures ~a" p))

    (match p 
        [`(module ,e) 
            `(module ,(convert-e e))]))



(module+ test 
  (check-equal? (convert-closures '(module
                                    (let ((x.1 7)) (letrec ((f.1 (lambda (a.1 a.2) (free (x.1)) x.1))) f.1))))
                               '(module
   (let ((x.1 7))
     (letrec ((L.f.1.1
               (lambda (c.41 a.1 a.2) (let ((x.1 (closure-ref c.41 0))) x.1))))
       (cletrec ((f.1 (make-closure L.f.1.1 2 x.1))) f.1)))))

  (check-equal? (convert-closures '(module
                                    (let ((x.1 7) (x.3 9)) (letrec ((f.1 (lambda (a.1 a.2) (free (x.1)) x.1))) f.1))))
                               '(module
  (let ((x.1 7) (x.3 9))
    (letrec ((L.f.1.2
              (lambda (c.42 a.1 a.2) (let ((x.1 (closure-ref c.42 0))) x.1))))
      (cletrec ((f.1 (make-closure L.f.1.2 2 x.1))) f.1)))))
  
)

;; test for Exercise 6
; To handle ’s-expr, remember that it is implicitly elaborated to (quote s-expr) by Racket.
(module+ test 
  
  (check-equal? (uniquify '(module '(#t #f 99 jo () (98 jj))))
    '(module '(#t #f 99 jo () (98 jj))))
  
  (check-equal? (uniquify '(module #(#t #f 123)))
    '(module #(#t #f 123)))

  (check-equal? (uniquify '(module (letrec ([x (and 13 #(123 33))]
                                            [y (or '(13) 33)]
                                            [z (quote '(33 33) #(ijj) +)]
                                            [t (vector '(ji) #t)]
                                            [f (begin (if #t #f #t) (void) ())])
                                          t)))
              '(module
                (letrec ((x.43 (and 13 #(123 33)))
                        (y.44 (or '(13) 33))
                        (z.45 (quote '(33 33) #(ijj) +))
                        (t.46 (vector '(ji) #t))
                        (f.47 (begin (if #t #f #t) (void) ())))
                  t.46)))

  (check-equal? (uniquify
  '(module
     (define my-and
       (lambda (ps)
         (if (empty? ps)
           #t
           (if (car ps)
             (my-and (cdr ps))
             #f))))
     (let ((and my-and)) (and '(#t #t #f)))))
    '(module
  (define my-and.48
    (lambda (ps.49)
      (if (empty? ps.49) #t (if (car ps.49) (my-and.48 (cdr ps.49)) #f))))
  (let ((and.50 my-and.48)) (and.50 '(#t #t #f)))) )


  (check-equal? (uniquify '(module (error 123)))
    '(module (error 123)))

  )

; Exercise 7
; Racketish-Surface-Unique -> Racketish-Unique
; Notice that each macro can generate more uses of macros.
;  As a result, the recursive structure of this elaborate pass is going to be slightly different from other passes.
(define (expand-macros p)  
  (define (expand-b b) 
    (match b 
      [`(define ,f ,body) `(define ,f ,(expand-e body))]))
    
  (define (expand-quote e)
  ; (displayln (format "expand quote ~a" e))
    (match e 
      [`(,e1 ,es ...) (expand-e `(cons ',e1 ',es))]
      [`,v (expand-e v)]))
    
  (define (expand-vector e)
    (let ([tmp (fresh 'tmp)] [counter -1])
      (expand-e  `(let ([,tmp (make-vector ,(length e))])
                                (begin
                                  ,@(map (lambda (x) (set! counter (add1 counter)) `(vector-set! ,tmp ,counter ,x)) e)
                                  ,tmp)))))
  
  (define (expand-and e)
   (match e 
    [`(and) #t]
    [`(and ,e1 ,es ...) 
      (if (empty? es)
          (expand-e e1)
          (expand-e `(if ,e1 (and ,@es ) #f)))]))
    
  (define (expand-or e)
    (match e 
      [`(or) #f]
      [`(or ,e1 ,es ...) 
      (if (empty? es)
          (expand-e e1)
          (let ([tmp (fresh 'tmp)]) (expand-e `(let ([,tmp ,e1]) (if ,tmp ,tmp (or ,@es)))
      )))]))

  (define (expand-begin b)
    (match b 
      [`(begin) '(void)]
      [`(begin ,e1 ,es ...) 
          (if (empty? es)
              (expand-e e1)
              (let ([tmp (fresh 'tmp)])
                (expand-e `(let ([,tmp ,e1])
                            (if (error? ,tmp)
                                ,tmp
                                (begin ,@es)))
                          )))]))

  (define (expand-e e)
    (match e 
      [`,num #:when (number? num) num]
      [`,prim #:when (prim-f? prim) prim]
      [`,aloc #:when (aloc? aloc) aloc]
      [#t #t]
      [#f #f]
      ['() '()]
      [`(void) '(void)]
      [`(error ,code) #:when (uint8? code) e]
      [`,char #:when (ascii-char-literal? char)
          char]
      [`(lambda (,args ...) ,ee)
          `(lambda ,args ,(expand-e ee))]
      [`(quote ,es) (expand-quote es)]
      [`#(,es ...) (expand-vector es)]
      [`(and ,es ...) (expand-and e)]
      [`(or ,es ...) (expand-or e)]
      [`(quote ,es) (expand-quote es)]
      [`(vector ,es ...) (expand-vector es)]
      [`(begin ,es ...) (expand-begin e)]
      [`(let ([,aloc ,e1]) ,ee) 
          `(let ([,aloc ,(expand-e e1)]) ,(expand-e ee))]
      [`(letrec ([,alocs ,es] ...) ,ee)
          `(letrec ,(map (lambda (x y) `(,x ,(expand-e y))) alocs es) ,(expand-e ee))]
      [`(if ,e1 ,e2 ,e3) `(if ,(expand-e e1) ,(expand-e e2) ,(expand-e e3))]
      [`(,e1 ,es ...) ;#:when (or (aloc? e1) (prim-f? e1))
          `(apply ,(expand-e e1) ,@(map expand-e es))]
      [else e]))

  (match p 
      [`(module ,bs ... ,e) 
         `(module ,@(map (lambda (x) (expand-b x)) bs) ,(expand-e e))]))

(module+ test 

  (check-equal? (expand-macros '(module (define f.1 (begin)) (let ([x.1 (begin 78)]) (begin 98 88))))
                  '(module
                    (define f.1 (void))
                    (let ((x.1 78)) (let ((tmp.51 98)) (if (apply error? tmp.51) tmp.51 88)))))


  (check-equal? (expand-macros '(module (let ([x.1 (quote (12 21))])
                                          (letrec ([x.2 'x.1]
                                                [x.3 '(x.2 x.1)])
                                                x.3))))
                 '(module
  (let ((x.1 (apply cons 12 (apply cons 21 ()))))
    (letrec ((x.2 x.1) (x.3 (apply cons x.2 (apply cons x.1 ())))) x.3))))

  (check-equal? (expand-macros '(module (let ([x.1 #(123 #f #t ())])
                                          (letrec ([x.2 (vector '(x.1) #f)])
                                            x.2))))
                 '(module
  (let ((x.1
         (let ((tmp.52 (apply make-vector 4)))
           (let ((tmp.53 (apply vector-set! tmp.52 0 123)))
             (if (apply error? tmp.53)
               tmp.53
               (let ((tmp.54 (apply vector-set! tmp.52 1 #f)))
                 (if (apply error? tmp.54)
                   tmp.54
                   (let ((tmp.55 (apply vector-set! tmp.52 2 #t)))
                     (if (apply error? tmp.55)
                       tmp.55
                       (let ((tmp.56 (apply vector-set! tmp.52 3 ())))
                         (if (apply error? tmp.56) tmp.56 tmp.52)))))))))))
    (letrec ((x.2
              (let ((tmp.57 (apply make-vector 2)))
                (let ((tmp.58 (apply vector-set! tmp.57 0 (apply cons x.1 ()))))
                  (if (apply error? tmp.58)
                    tmp.58
                    (let ((tmp.59 (apply vector-set! tmp.57 1 #f)))
                      (if (apply error? tmp.59) tmp.59 tmp.57)))))))
      x.2))))

(check-equal? (expand-macros '(module (let ([x.1 (or)])
                                        (letrec ([x.2 (or x.1)]
                                                  [x.3 (or x.2 x.3 x.3)])
                                                  x.3))))
'(module
  (let ((x.1 #f))
    (letrec ((x.2 x.1)
             (x.3
              (let ((tmp.60 x.2))
                (if tmp.60 tmp.60 (let ((tmp.61 x.3)) (if tmp.61 tmp.61 x.3))))))
      x.3))))

(check-equal? (expand-macros '(module (let ([x.1 (and)])
                                        (letrec ([x.2 (and x.1)]
                                                  [x.4 (and x.2 (and x.2 x.3))]
                                                  [x.3 (and x.2 x.3 x.4)])
                                                  x.3))))
'(module
  (let ((x.1 #t))
    (letrec ((x.2 x.1)
             (x.4 (if x.2 (if x.2 x.3 #f) #f))
             (x.3 (if x.2 (if x.3 x.4 #f) #f)))
      x.3))))

(check-equal? (expand-macros '(module (let ([x.1 (or)])
                                        (letrec ([x.2 (or x.1)]
                                                  [x.4 (or x.1 x.2 (and x.3 #(x.3 x.4)))]
                                                  [x.3 (or x.2 x.3 x.3)])
                                                  x.3))))
 '(module
     (let ((x.1 #f))
       (letrec ((x.2 x.1)
                (x.4
                 (let ((tmp.62 x.1))
                   (if tmp.62
                     tmp.62
                     (let ((tmp.63 x.2))
                       (if tmp.63
                         tmp.63
                         (if x.3
                           (let ((tmp.64 (apply make-vector 2)))
                             (let ((tmp.65 (apply vector-set! tmp.64 0 x.3)))
                               (if (apply error? tmp.65)
                                 tmp.65
                                 (let ((tmp.66 (apply vector-set! tmp.64 1 x.4)))
                                   (if (apply error? tmp.66) tmp.66 tmp.64)))))
                           #f))))))
                (x.3
                 (let ((tmp.67 x.2))
                   (if tmp.67
                     tmp.67
                     (let ((tmp.68 x.3)) (if tmp.68 tmp.68 x.3))))))
         x.3))))

  (check-equal? (expand-macros '(module (define f.1 (lambda (x.1) #(x.1 x.2)))
                                  (f.1 13)))
                                  '(module
  (define f.1
    (lambda (x.1)
      (let ((tmp.69 (apply make-vector 2)))
        (let ((tmp.70 (apply vector-set! tmp.69 0 x.1)))
          (if (apply error? tmp.70)
            tmp.70
            (let ((tmp.71 (apply vector-set! tmp.69 1 x.2)))
              (if (apply error? tmp.71) tmp.71 tmp.69)))))))
  (apply f.1 13)))


  (check-equal? (expand-macros '(module (letrec ([x.1 #((if #t 3 4) (lambda (x.2) x.2))]
                                                 [x.3 #((x.1 x.3))])
                                                 x.3)))
         '(module
  (letrec ((x.1
            (let ((tmp.72 (apply make-vector 2)))
              (let ((tmp.73 (apply vector-set! tmp.72 0 (if #t 3 4))))
                (if (apply error? tmp.73)
                  tmp.73
                  (let ((tmp.74 (apply vector-set! tmp.72 1 (lambda (x.2) x.2))))
                    (if (apply error? tmp.74) tmp.74 tmp.72))))))
           (x.3
            (let ((tmp.75 (apply make-vector 1)))
              (let ((tmp.76 (apply vector-set! tmp.75 0 (apply x.1 x.3))))
                (if (apply error? tmp.76) tmp.76 tmp.75)))))
    x.3)))

  (check-equal? (expand-macros `(module (letrec ([x.1 '(1 2 3)]
                                                 [x.2 '(x.1 (x.3 87))]
                                                 [x.3 (lambda (x.4) x.4)])
                                                 x.2)))
                     '(module
  (letrec ((x.1 (apply cons 1 (apply cons 2 (apply cons 3 ()))))
           (x.2
            (apply
             cons
             x.1
             (apply cons (apply cons x.3 (apply cons 87 ())) ())))
           (x.3 (lambda (x.4) x.4)))
    x.2)) )

  (check-equal? (expand-macros '(module (define f.1 '(#(98 89) 123)) f.1))
        '(module
  (define f.1
    (apply
     cons
     (let ((tmp.77 (apply make-vector 2)))
       (let ((tmp.78 (apply vector-set! tmp.77 0 98)))
         (if (apply error? tmp.78)
           tmp.78
           (let ((tmp.79 (apply vector-set! tmp.77 1 89)))
             (if (apply error? tmp.79) tmp.79 tmp.77)))))
     (apply cons 123 ())))
  f.1))

  (check-equal? (expand-macros '(module (define f.1 '(123)) f.1))
    '(module (define f.1 (apply cons 123 ())) f.1))
  
  (check-equal? (expand-macros '(module (define f.1 '(123)) '((and f.1 3))))
   '(module
  (define f.1 (apply cons 123 ()))
  (apply cons (apply cons and (apply cons f.1 (apply cons 3 ()))) ())))

  (check-equal? (expand-macros '(module (define f.1 '13) f.1))
    '(module (define f.1 13) f.1))

  (check-equal? (expand-macros '(module (letrec ([x.1 (and)] [x.2 (or)]) (and (or) (and)))))
    '(module (letrec ((x.1 #t) (x.2 #f)) (if #f #t #f))))


  
  (check-equal? (uniquify '(module (define i (lambda (x) (- x 0))) (define two (lambda () (i 2))) (let ((x (two))) (i x))))
                            '(module
                          (define i.80 (lambda (x.82) (- x.82 0)))
                          (define two.81 (lambda () (i.80 2)))
                          (let ((x.83 (two.81))) (i.80 x.83))))


)

;; A9 challenge 2 
;  optimize-known-calls 
(define (optimize-known-calls p) 

  ;; Var -> Value
  (define (optimize-empty-env x)
    x)
  
  (define (artiy-check aloc clet es env)
      (displayln (format "artiy-check clet ~a" clet))
    (match (second clet)
      [`(lambda (,args ...) ,ee) (if (eq? (length args) (length es))
                              `(let ([,(fresh) ,aloc]) (unsafe-apply ,(first clet) ,@(map (lambda (x) (optimize-e x env)) es)))
                              `(error 42))]))

  (define (get-label e) 
    (match e 
      [`(make-closure ,label ,es ...) label]
      [else empty]))

  (define (optimize-e e env)
    (match e 
      [`(let ([,xs ,es] ...) ,ee) 
          `(let ,(map (lambda (x y) `(,x ,(optimize-e y env))) xs es) ,(optimize-e ee env))]
      [`(if ,e1 ,e2 ,e3) `(if ,(optimize-e e1 env) ,(optimize-e e2 env) ,(optimize-e e3 env))]
      [`(letrec ([,rxs ,res] ...) 
          (cletrec ([,cxs ,ces] ...) ,ee)) 
          (let* ([label-table (make-hash)]
                  [aloc-table (make-hash)]
                  [new-env env])
            (begin 
              (for/list ([lx rxs]
                    [le res])
                  (dict-set! label-table lx le))
              (for/list ([ax cxs]
                    [ae ces])
                  (dict-set! aloc-table ax (get-label ae)))
              (for/list ([x cxs])
                (set! new-env (extend-env x `(,(dict-ref aloc-table x) ,(dict-ref label-table (dict-ref aloc-table x))) new-env)))
              `(letrec ,(map (lambda (x y) `(,x ,(optimize-e y new-env))) rxs res) 
                  (cletrec ,(map (lambda (x y) `(,x ,y)) cxs ces)
                    ,(optimize-e ee new-env)))
            ))]
      [`(letrec ([,xs ,es] ...) ,ee) 
          `(letrec ,(map (lambda (x y) `(,x ,(optimize-e y env))) xs es) ,(optimize-e ee env))]
      [`(cletrec ([,xs ,es] ...) ,ee) 
          `(cletrec ,(map (lambda (x y) `(,x ,(optimize-e y env))) xs es) ,(optimize-e ee env))]
      [`(closure-apply ,aloc ,es ...)
        (displayln (format "closure-app aloc: ~a es: ~a" aloc es))
          (let ([tmp (env aloc)])
            (if (and (list? tmp) (not (empty? tmp)))
              (artiy-check aloc tmp es env)
              `(closure-apply ,aloc ,@(map (lambda (x) (optimize-e x env)) es))))]
      [`(,primf ,es ...) #:when (primop? primf)
          `(,primf ,@(map (lambda (x) (optimize-e x env)) es))]
      [`(unsafe-apply ,es ...)
          `(unsafe-apply ,@(map (lambda (x) (optimize-e x env)) es))]
      [`(begin ,cs ...) 
          `(begin ,@(map (lambda (x) (optimize-e x env)) cs))]
      [`(lambda ,args ,ee) `(lambda ,args ,(optimize-e ee env))]
      [else e]
      ))

  (match p 
    [`(module ,e) `(module ,(optimize-e e optimize-empty-env))]))

(module+ test

(check-equal? (optimize-known-calls '(module (letrec ((L.vector-init-loop.75.3
              (lambda (c.86 len.76 i.78 vec.77)
                (let ((vector-init-loop.75 (closure-ref c.86 0)))
                  (if (eq? len.76 i.78)
                    vec.77
                    (begin
                      (unsafe-vector-set! vec.77 i.78 0)
                      (closure-apply
                       vector-init-loop.75
                       vector-init-loop.75
                       len.76
                       (unsafe-fx+ i.78 1)
                       vec.77)))))))
                       99)))
                '(module
  (letrec ((L.vector-init-loop.75.3
            (lambda (c.86 len.76 i.78 vec.77)
              (let ((vector-init-loop.75 (closure-ref c.86 0)))
                (if (eq? len.76 i.78)
                  vec.77
                  (begin
                    (unsafe-vector-set! vec.77 i.78 0)
                    (closure-apply
                     vector-init-loop.75
                     vector-init-loop.75
                     len.76
                     (unsafe-fx+ i.78 1)
                     vec.77)))))))
    99)))


(check-equal? (optimize-known-calls '(module 
    (letrec ((L.+.43.29 (lambda (c.34 x.6 y.7) (let () (if (fixnum? y.7) (if (fixnum? x.6) (unsafe-fx+ x.6 y.7) (error 1)) (error 1)))))
             (L.f1.1.31 (lambda (c.36 x.3) (let ((|+.43| (closure-ref c.36 0)))
               (closure-apply |+.43| |+.43| x.3 10)))))   ; TODO debug sub1
        (cletrec ((|+.43| (make-closure L.+.43.29 2)) (f1.1 (make-closure L.f1.1.31 1 |+.43|))) 
            (let ((y.2.4 (closure-apply f1.1 f1.1 90)))
                (closure-apply *.42 *.42 22 10))))))
      '(module
  (letrec ((L.+.43.29
            (lambda (c.34 x.6 y.7)
              (let ()
                (if (fixnum? y.7)
                  (if (fixnum? x.6) (unsafe-fx+ x.6 y.7) (error 1))
                  (error 1)))))
           (L.f1.1.31
            (lambda (c.36 x.3)
              (let ((|+.43| (closure-ref c.36 0)))
                (let ((tmp.84 |+.43|)) (unsafe-apply L.+.43.29 |+.43| x.3 10))))))
    (cletrec
     ((|+.43| (make-closure L.+.43.29 2)) (f1.1 (make-closure L.f1.1.31 1 |+.43|)))
     (let ((y.2.4 (let ((tmp.85 f1.1)) (unsafe-apply L.f1.1.31 f1.1 90))))
       (closure-apply *.42 *.42 22 10))))))
      

  (check-match (optimize-known-calls '(module 
    (letrec (  (L.vector-init-loop.70.3 (lambda (c.8 len.71 i.73 vec.72) (let ((vector-init-loop.70 (closure-ref c.8 0))) (if (eq? len.71 i.73) vec.72 (begin (unsafe-vector-set! vec.72 i.73 0) (closure-apply vector-init-loop.70 vector-init-loop.70 len.71 (unsafe-fx+ i.73 1) vec.72)))))) 
     ) (cletrec ((vector-init-loop.70 (make-closure L.vector-init-loop.70.3 3 vector-init-loop.70)) ) (closure-apply vector-init-loop.70 vector-init-loop.70 len.71 (unsafe-fx+ i.73 1) vec.72)))))
  `(module
  (letrec ((L.vector-init-loop.70.3
            (lambda (c.8 len.71 i.73 vec.72)
              (let ((vector-init-loop.70 (closure-ref c.8 0)))
                (if (eq? len.71 i.73)
                  vec.72
                  (begin
                    (unsafe-vector-set! vec.72 i.73 0)
                    (let ((,tmp.4 vector-init-loop.70))
                      (unsafe-apply
                       L.vector-init-loop.70.3
                       vector-init-loop.70
                       len.71
                       (unsafe-fx+ i.73 1)
                       vec.72))))))))
    (cletrec
     ((vector-init-loop.70
       (make-closure L.vector-init-loop.70.3 3 vector-init-loop.70)))
     (let ((,tmp.5 vector-init-loop.70))
       (unsafe-apply
        L.vector-init-loop.70.3
        vector-init-loop.70
        len.71
        (unsafe-fx+ i.73 1)
        vec.72))))))

 (check-equal? (optimize-known-calls '(module 
    (letrec ((L.vector-init-loop.70.3 
      (lambda (c.8 len.71) 
        (let ((vector-init-loop.70 (closure-ref c.8 0))) 
          (if (eq? len.71 i.73) 
            vec.72 
            (begin (unsafe-vector-set! vec.72 i.73 0) (closure-apply vector-init-loop.70 vector-init-loop.70 len.71 (unsafe-fx+ i.73 1) vec.72))))))) 
    (cletrec ((vector-init-loop.70 (make-closure L.vector-init-loop.70.3 3 vector-init-loop.70)) ) 
      (closure-apply vector-init-loop.70 vector-init-loop.70 len.71 (unsafe-fx+ i.73 1) vec.72)))))
'(module
  (letrec ((L.vector-init-loop.70.3
            (lambda (c.8 len.71)
              (let ((vector-init-loop.70 (closure-ref c.8 0)))
                (if (eq? len.71 i.73)
                  vec.72
                  (begin (unsafe-vector-set! vec.72 i.73 0) (error 42)))))))
    (cletrec
     ((vector-init-loop.70
       (make-closure L.vector-init-loop.70.3 3 vector-init-loop.70)))
     (error 42)))))

#;(check-equal? (optimize-known-calls '(module
    (letrec ((L.unsafe-vector-ref.3.1
              (lambda (c.84 tmp.79 tmp.80)
                (let ()
                  (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
                    (if (unsafe-fx>= tmp.80 0)
                      (unsafe-vector-ref tmp.79 tmp.80)
                      (error 10))
                    (error 10)))))
             (L.unsafe-vector-set!.2.2
              (lambda (c.85 tmp.79 tmp.80 tmp.81)
                (let ()
                  (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
                    (if (unsafe-fx>= tmp.80 0)
                      (begin (unsafe-vector-set! tmp.79 tmp.80 tmp.81) tmp.79)
                      (error 9))
                    (error 9)))))
             (L.vector-init-loop.75.3
              (lambda (c.86 len.76 i.78 vec.77)
                (let ((vector-init-loop.75 (closure-ref c.86 0)))
                  (if (eq? len.76 i.78)
                    vec.77
                    (begin
                      (unsafe-vector-set! vec.77 i.78 0)
                      (closure-apply
                       vector-init-loop.75
                       vector-init-loop.75
                       len.76
                       (unsafe-fx+ i.78 1)
                       vec.77))))))
             (L.make-init-vector.1.4
              (lambda (c.87 tmp.73)
                (let ((vector-init-loop.75 (closure-ref c.87 0)))
                  (let ((tmp.74 (unsafe-make-vector tmp.73)))
                    (closure-apply
                     vector-init-loop.75
                     vector-init-loop.75
                     tmp.73
                     0
                     tmp.74)))))
             (L.eq?.72.5
              (lambda (c.88 tmp.45 tmp.46) (let () (eq? tmp.45 tmp.46))))
             (L.cons.71.6
              (lambda (c.89 tmp.43 tmp.44) (let () (cons tmp.43 tmp.44))))
             (L.not.70.7 (lambda (c.90 tmp.42) (let () (not tmp.42))))
             (L.vector?.69.8 (lambda (c.91 tmp.41) (let () (vector? tmp.41))))
             (L.procedure?.68.9
              (lambda (c.92 tmp.40) (let () (procedure? tmp.40))))
             (L.pair?.67.10 (lambda (c.93 tmp.39) (let () (pair? tmp.39))))
             (L.error?.66.11 (lambda (c.94 tmp.38) (let () (error? tmp.38))))
             (L.ascii-char?.65.12
              (lambda (c.95 tmp.37) (let () (ascii-char? tmp.37))))
             (L.void?.64.13 (lambda (c.96 tmp.36) (let () (void? tmp.36))))
             (L.empty?.63.14 (lambda (c.97 tmp.35) (let () (empty? tmp.35))))
             (L.boolean?.62.15
              (lambda (c.98 tmp.34) (let () (boolean? tmp.34))))
             (L.fixnum?.61.16 (lambda (c.99 tmp.33) (let () (fixnum? tmp.33))))
             (L.procedure-arity.60.17
              (lambda (c.100 tmp.32)
                (let ()
                  (if (procedure? tmp.32)
                    (unsafe-procedure-arity tmp.32)
                    (error 13)))))
             (L.cdr.59.18
              (lambda (c.101 tmp.31)
                (let () (if (pair? tmp.31) (unsafe-cdr tmp.31) (error 12)))))
             (L.car.58.19
              (lambda (c.102 tmp.30)
                (let () (if (pair? tmp.30) (unsafe-car tmp.30) (error 11)))))
             (L.vector-ref.57.20
              (lambda (c.103 tmp.28 tmp.29)
                (let ((unsafe-vector-ref.3 (closure-ref c.103 0)))
                  (if (fixnum? tmp.29)
                    (if (vector? tmp.28)
                      (closure-apply
                       unsafe-vector-ref.3
                       unsafe-vector-ref.3
                       tmp.28
                       tmp.29)
                      (error 10))
                    (error 10)))))
             (L.vector-set!.56.21
              (lambda (c.104 tmp.25 tmp.26 tmp.27)
                (let ((unsafe-vector-set!.2 (closure-ref c.104 0)))
                  (if (fixnum? tmp.26)
                    (if (vector? tmp.25)
                      (closure-apply
                       unsafe-vector-set!.2
                       unsafe-vector-set!.2
                       tmp.25
                       tmp.26
                       tmp.27)
                      (error 9))
                    (error 9)))))
             (L.vector-length.55.22
              (lambda (c.105 tmp.24)
                (let ()
                  (if (vector? tmp.24)
                    (unsafe-vector-length tmp.24)
                    (error 8)))))
             (L.make-vector.54.23
              (lambda (c.106 tmp.23)
                (let ((make-init-vector.1 (closure-ref c.106 0)))
                  (if (fixnum? tmp.23)
                    (closure-apply
                     make-init-vector.1
                     make-init-vector.1
                     tmp.23)
                    (error 7)))))
             (L.>=.53.24
              (lambda (c.107 tmp.21 tmp.22)
                (let ()
                  (if (fixnum? tmp.22)
                    (if (fixnum? tmp.21) (unsafe-fx>= tmp.21 tmp.22) (error 6))
                    (error 6)))))
             (L.>.52.25
              (lambda (c.108 tmp.19 tmp.20)
                (let ()
                  (if (fixnum? tmp.20)
                    (if (fixnum? tmp.19) (unsafe-fx> tmp.19 tmp.20) (error 5))
                    (error 5)))))
             (L.<=.51.26
              (lambda (c.109 tmp.17 tmp.18)
                (let ()
                  (if (fixnum? tmp.18)
                    (if (fixnum? tmp.17) (unsafe-fx<= tmp.17 tmp.18) (error 4))
                    (error 4)))))
             (L.<.50.27
              (lambda (c.110 tmp.15 tmp.16)
                (let ()
                  (if (fixnum? tmp.16)
                    (if (fixnum? tmp.15) (unsafe-fx< tmp.15 tmp.16) (error 3))
                    (error 3)))))
             (L.-.49.28
              (lambda (c.111 tmp.13 tmp.14)
                (let ()
                  (if (fixnum? tmp.14)
                    (if (fixnum? tmp.13) (unsafe-fx- tmp.13 tmp.14) (error 2))
                    (error 2)))))
             (L.+.48.29
              (lambda (c.112 tmp.11 tmp.12)
                (let ()
                  (if (fixnum? tmp.12)
                    (if (fixnum? tmp.11) (unsafe-fx+ tmp.11 tmp.12) (error 1))
                    (error 1)))))
             (L.*.47.30
              (lambda (c.113 tmp.9 tmp.10)
                (let ()
                  (if (fixnum? tmp.10)
                    (if (fixnum? tmp.9) (unsafe-fx* tmp.9 tmp.10) (error 0))
                    (error 0))))))
      (cletrec
       ((unsafe-vector-ref.3 (make-closure L.unsafe-vector-ref.3.1 2))
        (unsafe-vector-set!.2 (make-closure L.unsafe-vector-set!.2.2 3))
        (vector-init-loop.75
         (make-closure L.vector-init-loop.75.3 3 vector-init-loop.75))
        (make-init-vector.1
         (make-closure L.make-init-vector.1.4 1 vector-init-loop.75))
        (eq?.72 (make-closure L.eq?.72.5 2))
        (cons.71 (make-closure L.cons.71.6 2))
        (not.70 (make-closure L.not.70.7 1))
        (vector?.69 (make-closure L.vector?.69.8 1))
        (procedure?.68 (make-closure L.procedure?.68.9 1))
        (pair?.67 (make-closure L.pair?.67.10 1))
        (error?.66 (make-closure L.error?.66.11 1))
        (ascii-char?.65 (make-closure L.ascii-char?.65.12 1))
        (void?.64 (make-closure L.void?.64.13 1))
        (empty?.63 (make-closure L.empty?.63.14 1))
        (boolean?.62 (make-closure L.boolean?.62.15 1))
        (fixnum?.61 (make-closure L.fixnum?.61.16 1))
        (procedure-arity.60 (make-closure L.procedure-arity.60.17 1))
        (cdr.59 (make-closure L.cdr.59.18 1))
        (car.58 (make-closure L.car.58.19 1))
        (vector-ref.57 (make-closure L.vector-ref.57.20 2 unsafe-vector-ref.3))
        (vector-set!.56
         (make-closure L.vector-set!.56.21 3 unsafe-vector-set!.2))
        (vector-length.55 (make-closure L.vector-length.55.22 1))
        (make-vector.54
         (make-closure L.make-vector.54.23 1 make-init-vector.1))
        (>=.53 (make-closure L.>=.53.24 2))
        (>.52 (make-closure L.>.52.25 2))
        (<=.51 (make-closure L.<=.51.26 2))
        (<.50 (make-closure L.<.50.27 2))
        (|-.49| (make-closure L.-.49.28 2))
        (|+.48| (make-closure L.+.48.29 2))
        (*.47 (make-closure L.*.47.30 2)))
       (let ()
         (let ()
           (letrec ()
             (cletrec
              ()
              (let ()
                (let ((x.4 #t))
                  (let ((t.5 (closure-apply make-vector.54 make-vector.54 1)))
                    (letrec ()
                      (cletrec
                       ()
                       (let ((t.5.7
                              (if (let ((tmp.6 #t)) (if tmp.6 tmp.6 #f))
                                x.4
                                #f)))
                         (let ((tmp.8
                                (closure-apply
                                 vector-set!.56
                                 vector-set!.56
                                 t.5
                                 0
                                 t.5.7)))
                           (closure-apply
                            not.70
                            not.70
                            (closure-apply
                             vector-ref.57
                             vector-ref.57
                             t.5
                             0)))))))))))))))))
            '(module
    (letrec ((L.unsafe-vector-ref.3.1
              (lambda (c.84 tmp.79 tmp.80)
                (let ()
                  (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
                    (if (unsafe-fx>= tmp.80 0)
                      (unsafe-vector-ref tmp.79 tmp.80)
                      (error 10))
                    (error 10)))))
             (L.unsafe-vector-set!.2.2
              (lambda (c.85 tmp.79 tmp.80 tmp.81)
                (let ()
                  (if (unsafe-fx< tmp.80 (unsafe-vector-length tmp.79))
                    (if (unsafe-fx>= tmp.80 0)
                      (begin (unsafe-vector-set! tmp.79 tmp.80 tmp.81) tmp.79)
                      (error 9))
                    (error 9)))))
             (L.vector-init-loop.75.3
              (lambda (c.86 len.76 i.78 vec.77)
                (let ((vector-init-loop.75 (closure-ref c.86 0)))
                  (if (eq? len.76 i.78)
                    vec.77
                    (begin
                      (unsafe-vector-set! vec.77 i.78 0)
                      (let ((tmp.114 vector-init-loop.75))
                        (unsafe-apply
                         L.vector-init-loop.75.3
                         vector-init-loop.75
                         len.76
                         (unsafe-fx+ i.78 1)
                         vec.77)))))))
             (L.make-init-vector.1.4
              (lambda (c.87 tmp.73)
                (let ((vector-init-loop.75 (closure-ref c.87 0)))
                  (let ((tmp.74 (unsafe-make-vector tmp.73)))
                    (let ((tmp.115 vector-init-loop.75))
                      (unsafe-apply
                       L.vector-init-loop.75.3
                       vector-init-loop.75
                       tmp.73
                       0
                       tmp.74))))))
             (L.eq?.72.5
              (lambda (c.88 tmp.45 tmp.46) (let () (eq? tmp.45 tmp.46))))
             (L.cons.71.6
              (lambda (c.89 tmp.43 tmp.44) (let () (cons tmp.43 tmp.44))))
             (L.not.70.7 (lambda (c.90 tmp.42) (let () (not tmp.42))))
             (L.vector?.69.8 (lambda (c.91 tmp.41) (let () (vector? tmp.41))))
             (L.procedure?.68.9
              (lambda (c.92 tmp.40) (let () (procedure? tmp.40))))
             (L.pair?.67.10 (lambda (c.93 tmp.39) (let () (pair? tmp.39))))
             (L.error?.66.11 (lambda (c.94 tmp.38) (let () (error? tmp.38))))
             (L.ascii-char?.65.12
              (lambda (c.95 tmp.37) (let () (ascii-char? tmp.37))))
             (L.void?.64.13 (lambda (c.96 tmp.36) (let () (void? tmp.36))))
             (L.empty?.63.14 (lambda (c.97 tmp.35) (let () (empty? tmp.35))))
             (L.boolean?.62.15
              (lambda (c.98 tmp.34) (let () (boolean? tmp.34))))
             (L.fixnum?.61.16 (lambda (c.99 tmp.33) (let () (fixnum? tmp.33))))
             (L.procedure-arity.60.17
              (lambda (c.100 tmp.32)
                (let ()
                  (if (procedure? tmp.32)
                    (unsafe-procedure-arity tmp.32)
                    (error 13)))))
             (L.cdr.59.18
              (lambda (c.101 tmp.31)
                (let () (if (pair? tmp.31) (unsafe-cdr tmp.31) (error 12)))))
             (L.car.58.19
              (lambda (c.102 tmp.30)
                (let () (if (pair? tmp.30) (unsafe-car tmp.30) (error 11)))))
             (L.vector-ref.57.20
              (lambda (c.103 tmp.28 tmp.29)
                (let ((unsafe-vector-ref.3 (closure-ref c.103 0)))
                  (if (fixnum? tmp.29)
                    (if (vector? tmp.28)
                      (let ((tmp.116 unsafe-vector-ref.3))
                        (unsafe-apply
                         L.unsafe-vector-ref.3.1
                         unsafe-vector-ref.3
                         tmp.28
                         tmp.29))
                      (error 10))
                    (error 10)))))
             (L.vector-set!.56.21
              (lambda (c.104 tmp.25 tmp.26 tmp.27)
                (let ((unsafe-vector-set!.2 (closure-ref c.104 0)))
                  (if (fixnum? tmp.26)
                    (if (vector? tmp.25)
                      (let ((tmp.117 unsafe-vector-set!.2))
                        (unsafe-apply
                         L.unsafe-vector-set!.2.2
                         unsafe-vector-set!.2
                         tmp.25
                         tmp.26
                         tmp.27))
                      (error 9))
                    (error 9)))))
             (L.vector-length.55.22
              (lambda (c.105 tmp.24)
                (let ()
                  (if (vector? tmp.24)
                    (unsafe-vector-length tmp.24)
                    (error 8)))))
             (L.make-vector.54.23
              (lambda (c.106 tmp.23)
                (let ((make-init-vector.1 (closure-ref c.106 0)))
                  (if (fixnum? tmp.23)
                    (let ((tmp.118 make-init-vector.1))
                      (unsafe-apply
                       L.make-init-vector.1.4
                       make-init-vector.1
                       tmp.23))
                    (error 7)))))
             (L.>=.53.24
              (lambda (c.107 tmp.21 tmp.22)
                (let ()
                  (if (fixnum? tmp.22)
                    (if (fixnum? tmp.21) (unsafe-fx>= tmp.21 tmp.22) (error 6))
                    (error 6)))))
             (L.>.52.25
              (lambda (c.108 tmp.19 tmp.20)
                (let ()
                  (if (fixnum? tmp.20)
                    (if (fixnum? tmp.19) (unsafe-fx> tmp.19 tmp.20) (error 5))
                    (error 5)))))
             (L.<=.51.26
              (lambda (c.109 tmp.17 tmp.18)
                (let ()
                  (if (fixnum? tmp.18)
                    (if (fixnum? tmp.17) (unsafe-fx<= tmp.17 tmp.18) (error 4))
                    (error 4)))))
             (L.<.50.27
              (lambda (c.110 tmp.15 tmp.16)
                (let ()
                  (if (fixnum? tmp.16)
                    (if (fixnum? tmp.15) (unsafe-fx< tmp.15 tmp.16) (error 3))
                    (error 3)))))
             (L.-.49.28
              (lambda (c.111 tmp.13 tmp.14)
                (let ()
                  (if (fixnum? tmp.14)
                    (if (fixnum? tmp.13) (unsafe-fx- tmp.13 tmp.14) (error 2))
                    (error 2)))))
             (L.+.48.29
              (lambda (c.112 tmp.11 tmp.12)
                (let ()
                  (if (fixnum? tmp.12)
                    (if (fixnum? tmp.11) (unsafe-fx+ tmp.11 tmp.12) (error 1))
                    (error 1)))))
             (L.*.47.30
              (lambda (c.113 tmp.9 tmp.10)
                (let ()
                  (if (fixnum? tmp.10)
                    (if (fixnum? tmp.9) (unsafe-fx* tmp.9 tmp.10) (error 0))
                    (error 0))))))
      (cletrec
       ((unsafe-vector-ref.3 (make-closure L.unsafe-vector-ref.3.1 2))
        (unsafe-vector-set!.2 (make-closure L.unsafe-vector-set!.2.2 3))
        (vector-init-loop.75
         (make-closure L.vector-init-loop.75.3 3 vector-init-loop.75))
        (make-init-vector.1
         (make-closure L.make-init-vector.1.4 1 vector-init-loop.75))
        (eq?.72 (make-closure L.eq?.72.5 2))
        (cons.71 (make-closure L.cons.71.6 2))
        (not.70 (make-closure L.not.70.7 1))
        (vector?.69 (make-closure L.vector?.69.8 1))
        (procedure?.68 (make-closure L.procedure?.68.9 1))
        (pair?.67 (make-closure L.pair?.67.10 1))
        (error?.66 (make-closure L.error?.66.11 1))
        (ascii-char?.65 (make-closure L.ascii-char?.65.12 1))
        (void?.64 (make-closure L.void?.64.13 1))
        (empty?.63 (make-closure L.empty?.63.14 1))
        (boolean?.62 (make-closure L.boolean?.62.15 1))
        (fixnum?.61 (make-closure L.fixnum?.61.16 1))
        (procedure-arity.60 (make-closure L.procedure-arity.60.17 1))
        (cdr.59 (make-closure L.cdr.59.18 1))
        (car.58 (make-closure L.car.58.19 1))
        (vector-ref.57 (make-closure L.vector-ref.57.20 2 unsafe-vector-ref.3))
        (vector-set!.56
         (make-closure L.vector-set!.56.21 3 unsafe-vector-set!.2))
        (vector-length.55 (make-closure L.vector-length.55.22 1))
        (make-vector.54
         (make-closure L.make-vector.54.23 1 make-init-vector.1))
        (>=.53 (make-closure L.>=.53.24 2))
        (>.52 (make-closure L.>.52.25 2))
        (<=.51 (make-closure L.<=.51.26 2))
        (<.50 (make-closure L.<.50.27 2))
        (|-.49| (make-closure L.-.49.28 2))
        (|+.48| (make-closure L.+.48.29 2))
        (*.47 (make-closure L.*.47.30 2)))
       (let ()
         (let ()
           (letrec ()
             (cletrec
              ()
              (let ()
                (let ((x.4 #t))
                  (let ((t.5
                         (let ((tmp.119 make-vector.54))
                           (unsafe-apply
                            L.make-vector.54.23
                            make-vector.54
                            1))))
                    (letrec ()
                      (cletrec
                       ()
                       (let ((t.5.7
                              (if (let ((tmp.6 #t)) (if tmp.6 tmp.6 #f))
                                x.4
                                #f)))
                         (let ((tmp.8
                                (let ((tmp.120 vector-set!.56))
                                  (unsafe-apply
                                   L.vector-set!.56.21
                                   vector-set!.56
                                   t.5
                                   0
                                   t.5.7))))
                           (let ((tmp.121 not.70))
                             (unsafe-apply
                              L.not.70.7
                              not.70
                              (let ((tmp.122 vector-ref.57))
                                (unsafe-apply
                                 L.vector-ref.57.20
                                 vector-ref.57
                                 t.5
                                 0)))))))))))))))))))
)

