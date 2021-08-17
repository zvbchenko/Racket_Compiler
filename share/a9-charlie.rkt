#lang racket

(require
    "a9-compiler-lib.rkt"
    "util.rkt")

(provide 
    ; uniquify
    define->letrec
    ; dox-lambdas
    ; uncover-free
    ; convert-closures
    hoist-lambdas
    implement-closures)

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
; Exprs-lang v9 -> Impure-Exprs-safe-lang v9
; what uniquify does isdischarge the last assumption, we know which names refer to which abstract locations,
; and thus introduce the last abstraction
; uniquify replace variables to alocs
(define (uniquify p)
   
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
                    `(define ,(b-env x) (lambda ,(map (lambda (x) (b-env x)) args) ,(uniquify-e e b-env))))]))

    (define (uniquify-v v env)
        (match v 
            [`,num #:when (fixnum? v) v]
            [`,prim #:when (prim-f? prim) prim]
            [#t #t]
            [#f #f]
            ['() '()]
            [`(void) '(void)]
            [`(error ,code) #:when (uint8? code) v]
            [`,char #:when (ascii-char-literal? char)
                char]
            [`(lambda (,args ...) ,e)
                (let ([b-env (list-extend-env args env)])
                    `(lambda ,(map (lambda (x) (b-env x)) args) ,(uniquify-e e b-env)))]
            [`,var (env var)]))

    (define (uniquify-e e env) 
        (match e 
            [`(,binop ,v1 ,v2) #:when (valid-binop? binop)
                `(,binop ,(uniquify-e v1 env) ,(uniquify-e v2 env))]
            [`(apply ,v1 ,vs ...) 
                `(apply ,(uniquify-e v1 env) ,@(map (lambda (x) (uniquify-e x env)) vs))]
            [`(let ([,x ,n]) ,e1)
                (let* ([new-x (fresh x)]
                    [e-env (extend-env x new-x env)]) 
                `(let ([,new-x ,(uniquify-e n env)]) ,(uniquify-e e1 e-env)))]
            [`(if ,e1 ,e2 ,e3) 
                `(if ,(uniquify-e e1 env) ,(uniquify-e e2 env) ,(uniquify-e e3 env))]
            [`,v (uniquify-v v env)]))   

    (displayln (format "uniquify ~a" p))
    (match p
        [`(module ,b ... ,e)
           (let ([new-env (init-function b empty-env)])
            `(module ,@(map (lambda (x) (uniquify-b x new-env)) b) ,(uniquify-e e new-env)))])
    )


(module+ test

    (check-equal? (uniquify '(module (define x1 (lambda (arg1 arg2) (apply * arg1 arg2)))
                                        (let ([x2 x1])
                                            (apply + x1 x2))))
                 '(module
   (define x1.1 (lambda (arg1.2 arg2.3) (apply * arg1.2 arg2.3)))
   (let ((x2.4 x1.1)) (apply + x1.1 x2.4))))

    (check-equal? (uniquify '(module (define x1 (lambda (arg1 arg2) (apply * arg1 arg2)))
                                        (let ([x1 99])
                                            (apply cons x1 x1))))
                    '(module
   (define x1.5 (lambda (arg1.6 arg2.7) (apply * arg1.6 arg2.7)))
   (let ((x1.8 99)) (apply cons x1.8 x1.8))))

    (check-equal? (uniquify '(module (define x1 (lambda (arg1 arg2) (apply * arg1 arg2)))
                                     (define x2 (lambda (x1 x2) (apply not x1)))
                                        (let ([x1 99])
                                            (apply cons x1 x1))))
        '(module
   (define x1.9 (lambda (arg1.11 arg2.12) (apply * arg1.11 arg2.12)))
   (define x2.14 (lambda (x1.13 x2.14) (apply not x1.13)))
   (let ((x1.15 99)) (apply cons x1.15 x1.15))))
    
    (check-equal? (uniquify '(module (define x1 (lambda (arg1 arg2) x1))
                                    (define x2 (lambda (arg1 arg2) x1))
                                    x2))
                '(module
   (define x1.16 (lambda (arg1.18 arg2.19) x1.16))
   (define x2.17 (lambda (arg1.20 arg2.21) x1.16))
   x2.17))

    (check-equal? (uniquify '(module (define x1 (lambda (arg1 arg2) 89))
                                     (define x2 (lambda (arg1 arg2) (apply x1 arg2 arg1)))
                                     (let ([x3 x1])
                                        x2)))
                           '(module
   (define x1.22 (lambda (arg1.24 arg2.25) 89))
   (define x2.23 (lambda (arg1.26 arg2.27) (apply x1.22 arg2.27 arg1.26)))
   (let ((x3.28 x1.22)) x2.23)))
    
    (check-equal? (uniquify '(module (let ([x1 cons]) +)))
            '(module (let ((x1.29 cons)) +)))
    
    (check-equal? (uniquify '(module (lambda (arg1 arg2) 
                                        (lambda (arg3 arg4) 
                                            (apply cons arg2 arg3)))))
                            '(module
   (lambda (arg1.30 arg2.31)
     (lambda (arg3.32 arg4.33) (apply cons arg2.31 arg3.32)))))
    
    (check-equal? (uniquify '(module (let ([x (lambda (x y) x)])
                                        (apply x x x))))
                    '(module (let ((x.34 (lambda (x.35 y.36) x.35))) (apply x.34 x.34 x.34))))

    (check-equal? (uniquify '(module (define x (lambda (x) (apply not x)))
                                        (let ([y x])
                                            (apply x y))))
                            '(module
                                (define x.38 (lambda (x.38) (apply not x.38)))
                                (let ((y.39 x.37)) (apply x.37 y.39))))

    (check-equal? (uniquify '(module (define x (lambda (a b) a))
                                    (let ([n #t]) (apply x n (void)))))
                    '(module
                                (define x.40 (lambda (a.41 b.42) a.41))
                                (let ((n.43 #t)) (apply x.40 n.43 (void)))))

    (check-equal? (uniquify '(module (define x (lambda (a b) (apply x2 b)))
                                     (define x2 (lambda (c) (apply x x2 c)))
                                     (let ([n ()])
                                        (let ([n <=])
                                            (let ([m (apply <= x x2)])
                                                (error 8))))))
                '(module
   (define x.44 (lambda (a.46 b.47) (apply x2.45 b.47)))
   (define x2.45 (lambda (c.48) (apply x.44 x2.45 c.48)))
   (let ((n.49 ()))
     (let ((n.50 <=)) (let ((m.51 (apply <= x.44 x2.45))) (error 8))))))
    
    (check-equal? (uniquify '(module (if > <= (let ((n 12)) (lambda (x) error?)))))
        '(module (if > <= (let ((n.52 12)) (lambda (x.53) error?)))))

)


;; exercise 2
;  Impure-Exprs-safe-lang v9 -> Just-Exprs-lang v9
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

)


;; Exercise 3
;  Just-Exprs-lang v9 -> Lam-opticon-lang v9
; gives freedom to functional programmers
;  transform each `(lambda (,alocs ...) ,e) into `(letrec ([,tmp (lambda (,alocs ...) ,e)]) ,tmp), where tmp is a fresh aloc.
(define (dox-lambdas p)
    
    (define (dox-impl e) 
        (match e 
            [`(apply ,e1 ,es ...) `(apply ,(dox-impl e1) ,@(map dox-impl es))]
            [`(letrec ([,alocs (lambda ,args ,es)] ...) ,e2) 
                `(letrec (,@(map (lambda (x y z) `[,x (lambda ,y ,(dox-impl z))]) alocs args  es)) ,(dox-impl e2))]
            [`(let ([,aloc ,e1]) ,e2) `(let ([,aloc ,(dox-impl e1)]) ,(dox-impl e2))]
            [`(if ,e1 ,e2 ,e3)
                `(if ,(dox-impl e1) ,(dox-impl e2) ,(dox-impl e3))]
            [`(lambda ,args ,ee)
                (let ([t1 (fresh)]) `(letrec ([,t1 (lambda ,args ,(dox-impl ee))]) ,t1))]
            [_ e]))
    
    (displayln (format "dox-lambdas ~a" p))

    (match p 
        [`(module ,e) `(module ,(dox-impl e))]))

(module+ test
    (check-equal? (dox-lambdas '(module 77))
                '(module 77))


    (check-equal? (dox-lambdas `(module (lambda (x.1) (lambda (x.2) (apply + x.1 x.2)))))
                                '(module
   (letrec ((tmp.54
             (lambda (x.1)
               (letrec ((tmp.55 (lambda (x.2) (apply + x.1 x.2)))) tmp.55))))
     tmp.54)))

    (check-equal? (dox-lambdas `(module (letrec ([f.1 (lambda (x.1) x.1)]
                                                 [f.2 (lambda () (lambda (x.1) f.1))])
                                                 (apply f.1 f.2))))
                        '(module
   (letrec ((f.1 (lambda (x.1) x.1))
            (f.2 (lambda () (letrec ((tmp.56 (lambda (x.1) f.1))) tmp.56))))
     (apply f.1 f.2))))

    (check-equal? (dox-lambdas '(module (lambda (a.1 a.2) (apply + a.1 a.2))))
                    '(module (letrec ((tmp.57 (lambda (a.1 a.2) (apply + a.1 a.2)))) tmp.57)))
    
    (check-equal? (dox-lambdas '(module (let ([x.2 (apply (lambda (arg.1 arg.2) arg.1) 2 3)])
                                             x.2)))
                                '(module
   (let ((x.2
          (apply (letrec ((tmp.58 (lambda (arg.1 arg.2) arg.1))) tmp.58) 2 3)))
     x.2)))
    
    (check-equal? (dox-lambdas '(module (letrec ([f.1 (lambda (x.1) (apply + x.1 9))])
                                            (letrec ([f.2 (lambda (x.1) (lambda (x.2) x.1))])
                                                +))))
                            '(module
   (letrec ((f.1 (lambda (x.1) (apply + x.1 9))))
     (letrec ((f.2
               (lambda (x.1) (letrec ((tmp.59 (lambda (x.2) x.1))) tmp.59))))
       +))))
    
    (check-equal? (dox-lambdas '(module (if (lambda (x.1) (apply x.1 x.1)) (lambda (x.2) (x.2)) (lambda (x.1 x.2) (lambda (x.3) 123)))))
       '(module
   (if (letrec ((tmp.60 (lambda (x.1) (apply x.1 x.1)))) tmp.60)
     (letrec ((tmp.61 (lambda (x.2) (x.2)))) tmp.61)
     (letrec ((tmp.62
               (lambda (x.1 x.2)
                 (letrec ((tmp.63 (lambda (x.3) 123))) tmp.63))))
       tmp.62))))

)

;; Exercise 5
; Safe-apply-lang v9 -> Lambda-free-lang v9
; now our procedures can contain references to free-variables in their lexical scope
; uncover the free variables in each lambda

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
            [`(let ([,aloc ,e1]) ,e2) 
                (let ([tt empty])
                    (let-values ([(et1 et2) (uncover-e e1 env)]
                                 [(et3 et4) (uncover-e e2 env)])
                            (values `(let ([,aloc ,et1]) ,et3) (append et2 et4))))]
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
    (check-equal? (uncover-free '(module (let ([x.1 7])
                                            (letrec ([f.1 (lambda (a.1 a.2) x.1)])
                                                f.1))))
                                '(module
                                    (let ((x.1 7)) (letrec ((f.1 (lambda (a.1 a.2) (free (x.1)) x.1))) f.1))))

    (check-equal? (uncover-free
                    `(module
                        (letrec ([x.1 (lambda () (apply x.1))])
                            x.1)))
                            '(module (letrec ((x.1 (lambda () (free (x.1)) (apply x.1)))) x.1)))
    
    (check-equal? (uncover-free 
                    '(module (letrec ([f.1 (lambda (x.1 x.2) 
                                                (letrec ([f.2 (lambda (x.3 x.4) (apply unsafe-fx+ x.1 (apply unsafe-fx+ x.2 (apply unsafe-fx+ x.3 (apply unsafe-fx+ x.4)))))]) f.2))])
                                                7)))
                '(module
                    (letrec ((f.1
                                (lambda (x.1 x.2)
                                (free ())
                                (letrec ((f.2
                                            (lambda (x.3 x.4)
                                            (free (x.2 x.1))
                                            (apply
                                            unsafe-fx+
                                            x.1
                                            (apply
                                                unsafe-fx+
                                                x.2
                                                (apply unsafe-fx+ x.3 (apply unsafe-fx+ x.4)))))))
                                    f.2))))
                        7)))

    (check-equal? (uncover-free
                    `(module
                        (letrec ([f.1 (lambda ()
                                        (letrec ([x.1 (lambda () (apply x.1))])
                                            x.1))])
                            f.1)))
                    '(module
                    (letrec ((f.1
                                (lambda ()
                                (free ())
                                (letrec ((x.1 (lambda () (free (x.1)) (apply x.1)))) x.1))))
                        f.1)))

    (check-equal? (uncover-free '(module (letrec ([f.1 (lambda (x.1 x.2) f.2)]
                                                  [f.2 (lambda (x.1 x.2) f.1)])
                                                  (apply f.1 f.2 f.1))))
                                '(module
            (letrec ((f.1 (lambda (x.1 x.2) (free (f.2)) f.2))
                    (f.2 (lambda (x.1 x.2) (free (f.1)) f.1)))
                (apply f.1 f.2 f.1))))

    (check-equal? (uncover-free '(module (letrec ([f.1 (lambda (x.1 x.2) (apply f.1 x.1 x.2))])
                                            (let ([x.1 f.1])
                                                (apply f.1 x.1 f.1)))))
                                '(module
                                    (letrec ((f.1 (lambda (x.1 x.2) (free (f.1)) (apply f.1 x.1 x.2))))
                                        (let ((x.1 f.1)) (apply f.1 x.1 f.1)))))      

    (check-equal? (uncover-free '(module (letrec ([f.1 (lambda (x.1 x.2) (apply unsafe-fx* x.1 x.2))])
                                            f.1)))
                                '(module
                                    (letrec ((f.1 (lambda (x.1 x.2) (free ()) (apply unsafe-fx* x.1 x.2)))) f.1)))

    (check-equal? (uncover-free '(module (letrec ([f.1 (lambda (x.1) (apply x.1 fr.1 fr.2))]
                                                  [f.2 (lambda (x.1) (apply x.1 fr.3 fr.4))])
                                                  f.1)))
                                '(module
                                    (letrec ((f.1 (lambda (x.1) (free (fr.2 fr.1)) (apply x.1 fr.1 fr.2)))
                                            (f.2 (lambda (x.1) (free (fr.4 fr.3)) (apply x.1 fr.3 fr.4))))
                                        f.1)))            

    (check-equal? (uncover-free 
`(module (letrec ([f.1 
                    (lambda (x.1) (letrec ([f.2 (lambda (x.2) (apply f.1 x.2 f.1))]) 99))])
            (letrec ([f.3 (lambda (x.3) (apply f.1 x.1 x.2))]) 77)
            )))
            '(module
  (letrec ((f.1
            (lambda (x.1)
              (free (f.1))
              (letrec ((f.2 (lambda (x.2) (free (f.1)) (apply f.1 x.2 f.1))))
                99))))
    (letrec ((f.3 (lambda (x.3) (free (x.2 x.1 f.1)) (apply f.1 x.1 x.2))))
      77))))


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
)


;; Exercise 6
;;  Lambda-free-lang v9 -> Closure-lang v9
; changes letrec to bind labels to procedure code
; cletrec, which only binds closures. Closures can, in general, have recursive self-references, so this is a variant of the letrec form.
; (closure-ref e_c e_i):  Deference the value at index e_i in the environment of the closure e_c. No need for dynamic checks
; (make-closure e_label e_arity e_i ...): Creates a closure whose code is at label e_label, which expects e_arity number of arguments, and has the values e_i in its environment.
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
            [`(apply ,e1 ,es ...) `(closure-apply ,e1 ,e1 ,@(map convert-e es))]
            [`(let ([,aloc ,e1]) ,e2)
                `(let ((,aloc ,(convert-e e1))) ,(convert-e e2))]
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
               (lambda (c.64 a.1 a.2) (let ((x.1 (closure-ref c.64 0))) x.1))))
       (cletrec ((f.1 (make-closure L.f.1.1 2 x.1))) f.1)))))

    (check-equal? (convert-closures  '(module
                                    (letrec ((f.1 (lambda (x.1 x.2) (free (f.1)) (apply f.1 x.1 x.2))))
                                        (let ((x.1 f.1)) (apply f.1 x.1 f.1)))))
                    '(module
   (letrec ((L.f.1.2
             (lambda (c.65 x.1 x.2)
               (let ((f.1 (closure-ref c.65 0)))
                 (closure-apply f.1 f.1 x.1 x.2)))))
     (cletrec
      ((f.1 (make-closure L.f.1.2 2 f.1)))
      (let ((x.1 f.1)) (closure-apply f.1 f.1 x.1 f.1))))))

    (check-equal? (convert-closures  '(module
            (letrec ((f.1 (lambda (x.1 x.2) (free (f.2)) f.2))
                    (f.2 (lambda (x.1 x.2) (free (f.1)) f.1)))
                (apply f.1 f.2 f.1))))
                '(module
                    (letrec ((L.f.1.3
                                (lambda (c.66 x.1 x.2) (let ((f.2 (closure-ref c.66 0))) f.2)))
                                (L.f.2.4
                                (lambda (c.67 x.1 x.2) (let ((f.1 (closure-ref c.67 0))) f.1))))
                        (cletrec
                        ((f.1 (make-closure L.f.1.3 2 f.2)) (f.2 (make-closure L.f.2.4 2 f.1)))
                        (closure-apply f.1 f.1 f.2 f.1)))))
    
    (check-equal? (convert-closures '(module
                                        (letrec ((f.1 (lambda (x.1 x.2) (free ()) (apply unsafe-fx* x.1 x.2)))) f.1)))
                                    '(module
                                        (letrec ((L.f.1.5
                                                    (lambda (c.68 x.1 x.2)
                                                    (let () (closure-apply unsafe-fx* unsafe-fx* x.1 x.2)))))
                                            (cletrec ((f.1 (make-closure L.f.1.5 2))) f.1))))

    (check-equal? (convert-closures '(module
                    (letrec ((f.1
                                (lambda (x.1 x.2)
                                (free ())
                                (letrec ((f.2
                                            (lambda (x.3 x.4)
                                            (free (x.2 x.1))
                                            (apply
                                            unsafe-fx+
                                            x.1
                                            (apply
                                                unsafe-fx+
                                                x.2
                                                (apply unsafe-fx+ x.3 (apply unsafe-fx+ x.4)))))))
                                    f.2))))
                        7)))
                '(module
                    (letrec ((L.f.1.6
                                (lambda (c.69 x.1 x.2)
                                (let ()
                                    (letrec ((L.f.2.7
                                            (lambda (c.70 x.3 x.4)
                                                (let ((x.2 (closure-ref c.70 0))
                                                    (x.1 (closure-ref c.70 1)))
                                                (closure-apply
                                                    unsafe-fx+
                                                    unsafe-fx+
                                                    x.1
                                                    (closure-apply
                                                    unsafe-fx+
                                                    unsafe-fx+
                                                    x.2
                                                    (closure-apply
                                                    unsafe-fx+
                                                    unsafe-fx+
                                                    x.3
                                                    (closure-apply
                                                    unsafe-fx+
                                                    unsafe-fx+
                                                    x.4))))))))
                                    (cletrec ((f.2 (make-closure L.f.2.7 2 x.2 x.1))) f.2))))))
                        (cletrec ((f.1 (make-closure L.f.1.6 2))) 7))))

    (check-equal? (convert-closures '(module
                                        (letrec ((f.1 (lambda (x.1) (free (fr.2 fr.1)) (apply x.1 fr.1 fr.2)))
                                                (f.2 (lambda (x.1) (free (fr.4 fr.3)) (apply x.1 fr.3 fr.4))))
                                            f.1)))
                                     '(module
   (letrec ((L.f.1.8
             (lambda (c.71 x.1)
               (let ((fr.2 (closure-ref c.71 0)) (fr.1 (closure-ref c.71 1)))
                 (closure-apply x.1 x.1 fr.1 fr.2))))
            (L.f.2.9
             (lambda (c.72 x.1)
               (let ((fr.4 (closure-ref c.72 0)) (fr.3 (closure-ref c.72 1)))
                 (closure-apply x.1 x.1 fr.3 fr.4)))))
     (cletrec
      ((f.1 (make-closure L.f.1.8 1 fr.2 fr.1))
       (f.2 (make-closure L.f.2.9 1 fr.4 fr.3)))
      f.1))))

    (check-equal? (convert-closures'(module
  (letrec ((f.1
            (lambda (x.1)
              (free (f.1))
              (letrec ((f.2 (lambda (x.2) (free (f.1)) (apply f.1 x.2 f.1))))
                99))))
    (letrec ((f.3 (lambda (x.3) (free (x.2 x.1 f.1)) (apply f.1 x.1 x.2))))
      77))))
      '(module
   (letrec ((L.f.1.10
             (lambda (c.73 x.1)
               (let ((f.1 (closure-ref c.73 0)))
                 (letrec ((L.f.2.11
                           (lambda (c.74 x.2)
                             (let ((f.1 (closure-ref c.74 0)))
                               (closure-apply f.1 f.1 x.2 f.1)))))
                   (cletrec ((f.2 (make-closure L.f.2.11 1 f.1))) 99))))))
     (cletrec
      ((f.1 (make-closure L.f.1.10 1 f.1)))
      (letrec ((L.f.3.12
                (lambda (c.75 x.3)
                  (let ((x.2 (closure-ref c.75 0))
                        (x.1 (closure-ref c.75 1))
                        (f.1 (closure-ref c.75 2)))
                    (closure-apply f.1 f.1 x.1 x.2)))))
        (cletrec ((f.3 (make-closure L.f.3.12 1 x.2 x.1 f.1))) 77))))))

)


; Exercise 7
;  Closure-lang v9 -> Hoisted-lang v9
(define (hoist-lambdas p)
    (define funcs empty)

    (define (discover-lam l)
        (match l 
            [`(lambda (,args ...) ,body) (discover-letrec body)]))

    (define (discover-letrec pp)
        (match pp 
            [`,aloc #:when (aloc? aloc) aloc]
            [`(,primop ,es ...) #:when (primop? primop) (map discover-letrec es)]
            [`(unsafe-apply ,e1 ,es ...) (discover-letrec e1) (map discover-letrec es)]
            [`(let ([,aloc ,es] ...) ,e2) (map discover-letrec es) (discover-letrec e2)]
            [`(cletrec ([,aloc ,es] ...) ,e2) (map discover-letrec es) (discover-letrec e2)]
            [`(let () ,ee) `(let () ,(discover-letrec ee))]
            [`(letrec ([,fname ,lams] ...) ,ee)
                (map discover-lam lams) 
                (map (lambda (x y) (set! funcs (cons `(define ,x ,(hoist-lam y)) funcs))) fname lams)
                (discover-letrec ee)]
            [`(if ,e1 ,e2 ,e3) (discover-letrec e1) (discover-letrec e2) (discover-letrec e3)]
            [`(begin ,es ...) (map discover-letrec es)]
            [else (void)]))

    (define (hoist-lam l)
        (match l 
            [`(lambda (,arg ...) ,body) `(lambda ,arg ,(hoist-e body))]))


    (define (hoist-e e)
        (match e 
            [`,aloc #:when (aloc? aloc) aloc]
            [`(,primop ,es ...) #:when (primop? primop) `(,primop ,@(map hoist-e es))]
            [`(unsafe-apply ,e1 ,es ...) `(unsafe-apply ,(hoist-e e1) ,@(map hoist-e es))]
            [`(let ([,alocs ,es] ... ) ,e2) 
                `(let ,(map (lambda (x y) `(,x ,(hoist-e y))) alocs es) ,(hoist-e e2))]
            [`(let () ,ee) `(let () ,(hoist-e ee))]
            [`(letrec ([,fname ,lams] ...) ,ee) 
                    (match ee 
                        [`(cletrec ,a ,b) `(cletrec ,a ,(hoist-e b))]
                        [else (hoist-e ee)])]
            [`(if ,e1 ,e2 ,e3) `(if ,(hoist-e e1) ,(hoist-e e2) ,(hoist-e e3))]
            [`(begin ,es ...) `(begin ,@(map hoist-e es))]
            [`(cletrec ([,fname ,lams] ...) ,ee) 
                `(cletrec ,(map (lambda (x y) `(,x ,(hoist-e y))) fname lams) ,(hoist-e ee))]
            [else e])
        )

    
    (displayln (format "hoist-lambdas ~a" p))

    (match p 
        [`(module ,e)
            (discover-letrec e)
            `(module ,@funcs ,(hoist-e e))
           ])
)

(module+ test 

    (check-equal? (hoist-lambdas '(module
                                    (letrec ((L.f.1.8
                                                (lambda (c.71 x.1)
                                                (let ((fr.2 (closure-ref c.71 0)) (fr.1 (closure-ref c.71 1)))
                                                    (closure-apply x.1 x.1 fr.1 fr.2))))
                                                (L.f.2.9
                                                (lambda (c.72 x.1)
                                                (let ((fr.4 (closure-ref c.72 0)) (fr.3 (closure-ref c.72 1)))
                                                    (closure-apply x.1 x.1 fr.3 fr.4)))))
                                        (cletrec
                                        ((f.1 (make-closure L.f.1.8 1 fr.2 fr.1))
                                        (f.2 (make-closure L.f.2.9 1 fr.4 fr.3)))
                                        f.1))))
                '(module
                    (define L.f.2.9
                        (lambda (c.72 x.1)
                        (let ((fr.4 (closure-ref c.72 0)) (fr.3 (closure-ref c.72 1)))
                            (closure-apply x.1 x.1 fr.3 fr.4))))
                    (define L.f.1.8
                        (lambda (c.71 x.1)
                        (let ((fr.2 (closure-ref c.71 0)) (fr.1 (closure-ref c.71 1)))
                            (closure-apply x.1 x.1 fr.1 fr.2))))
                    (cletrec
                    ((f.1 (make-closure L.f.1.8 1 fr.2 fr.1))
                        (f.2 (make-closure L.f.2.9 1 fr.4 fr.3)))
                    f.1))
      )

      (check-equal? (hoist-lambdas  '(module
                    (letrec ((L.f.1.6
                                (lambda (c.69 x.1 x.2)
                                (let ()
                                    (letrec ((L.f.2.7
                                            (lambda (c.70 x.3 x.4)
                                                (let ((x.2 (closure-ref c.70 0))
                                                    (x.1 (closure-ref c.70 1)))
                                                (closure-apply
                                                    unsafe-fx+
                                                    unsafe-fx+
                                                    x.1
                                                    (closure-apply
                                                    unsafe-fx+
                                                    unsafe-fx+
                                                    x.2
                                                    (closure-apply
                                                    unsafe-fx+
                                                    unsafe-fx+
                                                    x.3
                                                    (closure-apply
                                                    unsafe-fx+
                                                    unsafe-fx+
                                                    x.4))))))))
                                    (cletrec ((f.2 (make-closure L.f.2.7 2 x.2 x.1))) f.2))))))
                        (cletrec ((f.1 (make-closure L.f.1.6 2))) 7))))
                        '(module
   (define L.f.1.6
     (lambda (c.69 x.1 x.2)
       (let () (cletrec ((f.2 (make-closure L.f.2.7 2 x.2 x.1))) f.2))))
   (define L.f.2.7
     (lambda (c.70 x.3 x.4)
       (let ((x.2 (closure-ref c.70 0)) (x.1 (closure-ref c.70 1)))
         (closure-apply
          unsafe-fx+
          unsafe-fx+
          x.1
          (closure-apply
           unsafe-fx+
           unsafe-fx+
           x.2
           (closure-apply
            unsafe-fx+
            unsafe-fx+
            x.3
            (closure-apply unsafe-fx+ unsafe-fx+ x.4)))))))
   (cletrec ((f.1 (make-closure L.f.1.6 2))) 7)))

  (check-equal? (hoist-lambdas '(module
                                        (letrec ((L.f.1.5
                                                    (lambda (c.68 x.1 x.2)
                                                    (let () (closure-apply unsafe-fx* unsafe-fx* x.1 x.2)))))
                                            (cletrec ((f.1 (make-closure L.f.1.5 2))) f.1))))
                                '(module
                                    (define L.f.1.5
                                        (lambda (c.68 x.1 x.2)
                                        (let () (closure-apply unsafe-fx* unsafe-fx* x.1 x.2))))
                                    (cletrec ((f.1 (make-closure L.f.1.5 2))) f.1)))

    (check-equal? (hoist-lambdas '(module
                    (letrec ((L.f.1.3
                                (lambda (c.66 x.1 x.2) (let ((f.2 (closure-ref c.66 0))) f.2)))
                                (L.f.2.4
                                (lambda (c.67 x.1 x.2) (let ((f.1 (closure-ref c.67 0))) f.1))))
                        (cletrec
                        ((f.1 (make-closure L.f.1.3 2 f.2)) (f.2 (make-closure L.f.2.4 2 f.1)))
                        (closure-apply f.1 f.1 f.2 f.1)))))
                    '(module
                        (define L.f.2.4
                            (lambda (c.67 x.1 x.2) (let ((f.1 (closure-ref c.67 0))) f.1)))
                        (define L.f.1.3
                            (lambda (c.66 x.1 x.2) (let ((f.2 (closure-ref c.66 0))) f.2)))
                        (cletrec
                        ((f.1 (make-closure L.f.1.3 2 f.2)) (f.2 (make-closure L.f.2.4 2 f.1)))
                        (closure-apply f.1 f.1 f.2 f.1))))

    (check-equal? (hoist-lambdas '(module
                        (letrec ((L.f.1.2
                                    (lambda (c.65 x.1 x.2)
                                    (let ((f.1 (closure-ref c.65 0)))
                                        (closure-apply f.1 f.1 x.1 x.2)))))
                            (cletrec
                            ((f.1 (make-closure L.f.1.2 2 f.1)))
                            (let ((x.1 f.1)) (closure-apply f.1 f.1 x.1 f.1))))))
      '(module
  (define L.f.1.2
    (lambda (c.65 x.1 x.2)
      (let ((f.1 (closure-ref c.65 0))) (closure-apply f.1 f.1 x.1 x.2))))
  (cletrec
   ((f.1 (make-closure L.f.1.2 2 f.1)))
   (let ((x.1 f.1)) (closure-apply f.1 f.1 x.1 f.1)))))

    (check-equal? (hoist-lambdas '(module
        (let ((x.1 7))
            (letrec ((L.f.1.1
                    (lambda (c.64 a.1 a.2) (let ((x.1 (closure-ref c.64 0))) x.1))))
            (cletrec ((f.1 (make-closure L.f.1.1 2 x.1))) f.1)))))
            '(module
                    (define L.f.1.1
                        (lambda (c.64 a.1 a.2) (let ((x.1 (closure-ref c.64 0))) x.1)))
                    (let ((x.1 7)) (cletrec ((f.1 (make-closure L.f.1.1 2 x.1))) f.1))))

    (check-equal? (hoist-lambdas '(module
  (letrec ((L.f.1.1
            (lambda (c.4 x.1)
              (let ((f.1 (closure-ref c.4 0)))
                (letrec ((L.f.2.2
                          (lambda (c.5 x.2)
                            (let ((f.1 (closure-ref c.5 0)))
                              (closure-apply f.1 f.1 x.2 f.1)))))
                  (cletrec ((f.2 (make-closure L.f.2.2 1 f.1))) 99))))))
    (cletrec
     ((f.1 (make-closure L.f.1.1 1 f.1)))
     (letrec ((L.f.3.3
               (lambda (c.6 x.3)
                 (let ((x.2 (closure-ref c.6 0))
                       (x.1 (closure-ref c.6 1))
                       (f.1 (closure-ref c.6 2)))
                   (closure-apply f.1 f.1 x.1 x.2)))))
       (cletrec ((f.3 (make-closure L.f.3.3 1 x.2 x.1 f.1))) 77))))))
       '(module
  (define L.f.3.3
    (lambda (c.6 x.3)
      (let ((x.2 (closure-ref c.6 0))
            (x.1 (closure-ref c.6 1))
            (f.1 (closure-ref c.6 2)))
        (closure-apply f.1 f.1 x.1 x.2))))
  (define L.f.1.1
    (lambda (c.4 x.1)
      (let ((f.1 (closure-ref c.4 0)))
        (cletrec ((f.2 (make-closure L.f.2.2 1 f.1))) 99))))
  (define L.f.2.2
    (lambda (c.5 x.2)
      (let ((f.1 (closure-ref c.5 0))) (closure-apply f.1 f.1 x.2 f.1))))
  (cletrec
   ((f.1 (make-closure L.f.1.1 1 f.1)))
   (cletrec ((f.3 (make-closure L.f.3.3 1 x.2 x.1 f.1))) 77))))

(check-equal? (hoist-lambdas '(module
                        (letrec ((L.f.1.2
                                    (lambda (c.65 x.1 x.2)
                                    (let ((f.1 (closure-ref c.65 0)))
                                        (closure-apply f.1 f.1 x.1 x.2)))))
                                (unsafe-apply L.f.1.2 1 2 3))))
`(module
  (define L.f.1.2
    (lambda (c.65 x.1 x.2)
      (let ((f.1 (closure-ref c.65 0))) (closure-apply f.1 f.1 x.1 x.2))))
  (unsafe-apply L.f.1.2 1 2 3)))

)


; Exercise 8
;; Hoisted-lang v9 -> Proc-apply-lang v9
; (make-procedure e_label e_arity e_size)
;        Creates a procedure whose label is e_label, which expects e_arity number of arguments, 
;        and has an environment of size e_size.
; (unsafe-procedure-ref e_proc e_index)
;       Return the value at index e_index in the environment of the procedure e_proc.
; (unsafe-procedure-set! e_proc e_index e_val)
;       Set the value at index e_index in the environment of the procedure e_proc to be e_val.
; (procedure-apply e_proc es ...)
;       Safely apply the procedure e_proc to its arguments es
(define (implement-closures p)
; Transform make-closure to make-procedure & begin unsafe-procedure-set! 
; Transform closure-ref to unsafe-procedure-ref 
; Transform closure-apply to procedure-apply
    (define (implement-b b)
        (match b
            [`(define ,label (lambda (,aloc ...) ,e)) 
                `(define ,label (lambda ,aloc  ,(implement-e e)))]))
    
    (define (get-env e)
        (match e 
            [`(make-closure ,label ,arity ,es ...) es]))

    (define (implement-e e)
        (match e 
            [`,aloc #:when (aloc? aloc) aloc]
            [`(closure-ref ,c ,i) `(unsafe-procedure-ref ,(implement-e c) ,(implement-e i))]
            [`(closure-apply ,c ,es ...) `(procedure-apply ,(implement-e c) ,@(map implement-e es))]
            [`(,primop ,es ...) #:when (primop? primop) `(,primop ,@(map implement-e es))]
            [`(unsafe-apply ,e1 ,es ...) `(unsafe-apply ,(implement-e e1) ,@(map implement-e es))]
            [`(let ([,alocs ,es] ... ) ,e2) 
                `(let ,(map (lambda (x y) `(,x ,(implement-e y))) alocs es) ,(implement-e e2))]
            [`(let () ,ee) `(let () ,(implement-e ee))]
            [`(if ,e1 ,e2 ,e3) `(if ,(implement-e e1) ,(implement-e e2) ,(implement-e e3))]
            [`(begin ,es ...) `(begin ,@(map implement-e es))]
            [`(cletrec ([,fname ,makes] ...) ,ee) 
                (let ([envs (make-hash)])
                    `(let ,(map (lambda (x y) 
                                   (match y 
                                    [`(make-closure ,label ,arity ,es ...) 
                                        (begin (dict-set! envs x es)
                                                `(,x (make-procedure ,label ,arity ,(length es))))])) fname makes) 
                            (begin ,@(append-map (lambda (x) 
                                        (let ([res empty]
                                              [tenv (dict-ref envs x)])
                                            (for ([ele (dict-ref envs x)])
                                                (set! res (cons `(unsafe-procedure-set! ,x ,(index-of tenv ele) ,ele) res)))
                                            (if (empty? res)
                                                empty
                                                (list `(begin ,@(reverse res))))
                                            )) fname)
                                    ,(implement-e ee))))]
            [else e]))
    
    (displayln (format "implement-closures ~a" p))

    (match p 
        [`(module ,bs ... ,e) `(module ,@(map implement-b bs) ,(implement-e e))]))

(module+ test 
    (check-equal? (implement-closures '(module
                                    (define L.f.1.5
                                        (lambda (c.68 x.1 x.2)
                                        (let () (closure-apply unsafe-fx* unsafe-fx* x.1 x.2))))
                                    (cletrec ((f.1 (make-closure L.f.1.5 2))) f.1)))
                '(module
  (define L.f.1.5
    (lambda (c.68 x.1 x.2)
      (let () (procedure-apply unsafe-fx* unsafe-fx* x.1 x.2))))
  (let ((f.1 (make-procedure L.f.1.5 2 0))) (begin f.1))))


    (check-equal? (implement-closures '(module
   (define L.f.1.6
     (lambda (c.69 x.1 x.2)
       (let () (cletrec ((f.2 (make-closure L.f.2.7 2 x.2 x.1))) f.2))))
   (define L.f.2.7
     (lambda (c.70 x.3 x.4)
       (let ((x.2 (closure-ref c.70 0)) (x.1 (closure-ref c.70 1)))
         (closure-apply
          unsafe-fx+
          unsafe-fx+
          x.1
          (closure-apply
           unsafe-fx+
           unsafe-fx+
           x.2
           (closure-apply
            unsafe-fx+
            unsafe-fx+
            x.3
            (closure-apply unsafe-fx+ unsafe-fx+ x.4)))))))
   (cletrec ((f.1 (make-closure L.f.1.6 2))) 7)))
   '(module
  (define L.f.1.6
    (lambda (c.69 x.1 x.2)
      (let ()
        (let ((f.2 (make-procedure L.f.2.7 2 2)))
          (begin
            (begin
              (unsafe-procedure-set! f.2 0 x.2)
              (unsafe-procedure-set! f.2 1 x.1))
            f.2)))))
  (define L.f.2.7
    (lambda (c.70 x.3 x.4)
      (let ((x.2 (unsafe-procedure-ref c.70 0))
            (x.1 (unsafe-procedure-ref c.70 1)))
        (procedure-apply
         unsafe-fx+
         unsafe-fx+
         x.1
         (procedure-apply
          unsafe-fx+
          unsafe-fx+
          x.2
          (procedure-apply
           unsafe-fx+
           unsafe-fx+
           x.3
           (procedure-apply unsafe-fx+ unsafe-fx+ x.4)))))))
  (let ((f.1 (make-procedure L.f.1.6 2 0))) (begin 7))))
    
    (check-equal? (implement-closures '(module
                    (define L.f.2.9
                        (lambda (c.72 x.1)
                        (let ((fr.4 (closure-ref c.72 0)) (fr.3 (closure-ref c.72 1)))
                            (closure-apply x.1 x.1 fr.3 fr.4))))
                    (define L.f.1.8
                        (lambda (c.71 x.1)
                        (let ((fr.2 (closure-ref c.71 0)) (fr.1 (closure-ref c.71 1)))
                            (closure-apply x.1 x.1 fr.1 fr.2))))
                    (cletrec
                    ((f.1 (make-closure L.f.1.8 1 fr.2 fr.1))
                        (f.2 (make-closure L.f.2.9 1 fr.4 fr.3)))
                    f.1)))
            '(module
  (define L.f.2.9
    (lambda (c.72 x.1)
      (let ((fr.4 (unsafe-procedure-ref c.72 0))
            (fr.3 (unsafe-procedure-ref c.72 1)))
        (procedure-apply x.1 x.1 fr.3 fr.4))))
  (define L.f.1.8
    (lambda (c.71 x.1)
      (let ((fr.2 (unsafe-procedure-ref c.71 0))
            (fr.1 (unsafe-procedure-ref c.71 1)))
        (procedure-apply x.1 x.1 fr.1 fr.2))))
  (let ((f.1 (make-procedure L.f.1.8 1 2)) (f.2 (make-procedure L.f.2.9 1 2)))
    (begin
      (begin
        (unsafe-procedure-set! f.1 0 fr.2)
        (unsafe-procedure-set! f.1 1 fr.1))
      (begin
        (unsafe-procedure-set! f.2 0 fr.4)
        (unsafe-procedure-set! f.2 1 fr.3))
      f.1))))

    (check-equal? (implement-closures '(module
                        (define L.f.2.4
                            (lambda (c.67 x.1 x.2) (let ((f.1 (closure-ref c.67 0))) f.1)))
                        (define L.f.1.3
                            (lambda (c.66 x.1 x.2) (let ((f.2 (closure-ref c.66 0))) f.2)))
                        (cletrec
                        ((f.1 (make-closure L.f.1.3 2 f.2)) (f.2 (make-closure L.f.2.4 2 f.1)))
                        (closure-apply f.1 f.1 f.2 f.1))))
                '(module
                    (define L.f.2.4
                        (lambda (c.67 x.1 x.2) (let ((f.1 (unsafe-procedure-ref c.67 0))) f.1)))
                    (define L.f.1.3
                        (lambda (c.66 x.1 x.2) (let ((f.2 (unsafe-procedure-ref c.66 0))) f.2)))
                    (let ((f.1 (make-procedure L.f.1.3 2 1)) (f.2 (make-procedure L.f.2.4 2 1)))
                        (begin
                        (begin (unsafe-procedure-set! f.1 0 f.2))
                        (begin (unsafe-procedure-set! f.2 0 f.1))
                        (procedure-apply f.1 f.1 f.2 f.1)))))

    (check-equal? (implement-closures '(module
                    (define L.f.1.2
                        (lambda (c.65 x.1 x.2)
                        (let ((f.1 (closure-ref c.65 0))) (closure-apply f.1 f.1 x.1 x.2))))
                    (cletrec
                    ((f.1 (make-closure L.f.1.2 2 f.1)))
                    (let ((x.1 f.1)) (closure-apply f.1 f.1 x.1 f.1)))))
                '(module
                    (define L.f.1.2
                        (lambda (c.65 x.1 x.2)
                        (let ((f.1 (unsafe-procedure-ref c.65 0)))
                            (procedure-apply f.1 f.1 x.1 x.2))))
                    (let ((f.1 (make-procedure L.f.1.2 2 1)))
                        (begin
                        (begin (unsafe-procedure-set! f.1 0 f.1))
                        (let ((x.1 f.1)) (procedure-apply f.1 f.1 x.1 f.1))))))

    (check-equal? (implement-closures '(module
                    (define L.f.1.1
                        (lambda (c.64 a.1 a.2) (let ((x.1 (closure-ref c.64 0))) x.1)))
                    (let ((x.1 7)) (cletrec ((f.1 (make-closure L.f.1.1 2 x.1))) f.1))))
                '(module
                    (define L.f.1.1
                        (lambda (c.64 a.1 a.2) (let ((x.1 (unsafe-procedure-ref c.64 0))) x.1)))
                    (let ((x.1 7))
                        (let ((f.1 (make-procedure L.f.1.1 2 1)))
                        (begin (begin (unsafe-procedure-set! f.1 0 x.1)) f.1)))))

    (check-equal? (implement-closures '(module
                    (define L.f.3.3
                        (lambda (c.6 x.3)
                        (let ((x.2 (closure-ref c.6 0))
                                (x.1 (closure-ref c.6 1))
                                (f.1 (closure-ref c.6 2)))
                            (closure-apply f.1 f.1 x.1 x.2))))
                    (define L.f.1.1
                        (lambda (c.4 x.1)
                        (let ((f.1 (closure-ref c.4 0)))
                            (cletrec ((f.2 (make-closure L.f.2.2 1 f.1))) 99))))
                    (define L.f.2.2
                        (lambda (c.5 x.2)
                        (let ((f.1 (closure-ref c.5 0))) (closure-apply f.1 f.1 x.2 f.1))))
                    (cletrec
                    ((f.1 (make-closure L.f.1.1 1 f.1)))
                    (cletrec ((f.3 (make-closure L.f.3.3 1 x.2 x.1 f.1))) 77))))
                    '(module
                        (define L.f.3.3
                            (lambda (c.6 x.3)
                            (let ((x.2 (unsafe-procedure-ref c.6 0))
                                    (x.1 (unsafe-procedure-ref c.6 1))
                                    (f.1 (unsafe-procedure-ref c.6 2)))
                                (procedure-apply f.1 f.1 x.1 x.2))))
                        (define L.f.1.1
                            (lambda (c.4 x.1)
                            (let ((f.1 (unsafe-procedure-ref c.4 0)))
                                (let ((f.2 (make-procedure L.f.2.2 1 1)))
                                (begin (begin (unsafe-procedure-set! f.2 0 f.1)) 99)))))
                        (define L.f.2.2
                            (lambda (c.5 x.2)
                            (let ((f.1 (unsafe-procedure-ref c.5 0)))
                                (procedure-apply f.1 f.1 x.2 f.1))))
                        (let ((f.1 (make-procedure L.f.1.1 1 1)))
                            (begin
                            (begin (unsafe-procedure-set! f.1 0 f.1))
                            (let ((f.3 (make-procedure L.f.3.3 1 3)))
                                (begin
                                (begin
                                    (unsafe-procedure-set! f.3 0 x.2)
                                    (unsafe-procedure-set! f.3 1 x.1)
                                    (unsafe-procedure-set! f.3 2 f.1))
                                77))))))

    )