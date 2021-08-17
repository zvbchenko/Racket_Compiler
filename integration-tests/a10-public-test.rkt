#lang racket
(require
  "../a10.rkt"
  "../a10-compiler-lib.rkt"
  "../a10-graph-lib.rkt")
(module+ test
  (require rackunit))


(module+ test
  (parameterize ([current-pass-list
                  (list
                   uniquify
                   expand-macros
                   define->letrec
                   purify-letrec
                   convert-assigned
                   dox-lambdas
                   implement-safe-primops
                   uncover-free
                   convert-closures
                   optimize-known-calls
                   hoist-lambdas
                   implement-closures
                   sequentialize-let
                   implement-safe-apply
                   specify-representation
                   a-normalize
                   select-instructions
                   expose-allocation-pointer
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
                   patch-instructions
                   implement-mops
                   generate-x64
                   wrap-x64-boilerplate
                   wrap-x64-run-time)])


    (check-equal?
     (execute
      `(module
         (define even?
           (lambda (n)
             (if (eq? n 0)
                 #t
                 (odd? (- n 1)))))
         (define odd?
           (lambda (n)
             (if (eq? n 0)
                 #f
                 (even? (- n 1)))))
         (cons
          (even? 0)
          (cons
           (even? 1)
           (cons
            (even? 2)
            (cons
             (odd? 0)
             (cons
              (odd? 1)
              (cons
               (odd? 2)
               ()))))))))
     '(#t #f #t #f #t #f))



    (check-equal?
     (execute
      '(module
         (define F
           (lambda (a b c d e f g)
             (let ([r (G a b c d e f g 8)])
               (+ r 10))))
         (define G
           (lambda (a b c d e f g h)
             (H a b c d e f g h 9)))
         (define H
           (lambda (a b c d e f g h j)
             (let ([r1 (+ a b)])
               (let ([r2 (+ r1 c)])
                 (let ([r3 (+ r2 d)])
                   (let ([r4 (+ r3 e)])
                     (let ([r5 (+ r4 f)])
                       (let ([r6 (+ r5 g)])
                         (let ([r7 (+ r6 h)])
                           (+ r7 j))))))))))
         (F 1 2 3 4 5 6 7)))
     (+ 1 2 3 4 5 6 7 8 9 10))


    (check-equal?
     (execute
      '(module
         (define L.swap.1
           (lambda (x.1 y.2)
             (if (> y.2 x.1)
                 x.1
                 (L.swap.1 y.2 x.1))))
         (L.swap.1 2 1)))
     1)

  
    (check-equal?
     (execute
      '(module
         (define error
           (lambda (define)
             (let ([not eq?])
               (letrec ([letrec -])
                 (let ([eq? 1])
                   (let ([apply 0])
                     (let ([lambda define])
                       (let ([let *])
                         (if (not define apply)
                             eq?
                             (let define (error (letrec lambda eq?))))))))))))
         (let ([let 5])
           (letrec ([define error])
             (define let)))))
     120)

  
    (check-equal?
     (execute
      '(module
         (define counter!
           (let ([x (make-vector 1)])
             (lambda ()
               (begin
                 (vector-set! x 0 (+ 1 (vector-ref x 0)))
                 (vector-ref x 0)))))
         (begin
           (counter!)
           (counter!)
           (counter!))))
     3)

  
    (check-equal?
     (execute
      '(module
         (define list?
           (lambda (x)
             (if (eq? () x)
                 #t
                 (if (pair? x)
                     (list? (cdr x))
                     #f))))
         (define length
           (lambda (x)
             (if (not (list? x))
                 (error 5)
                 (letrec ([loop
                           (lambda (x)
                             (if (eq? () x)
                                 0
                                 (+ 1 (loop (cdr x)))))])
                   (loop x)))))
         (cons
          (list? '(1 2 3 4))
          (cons
           (list? (cons 1 2))
           (length '(1 2 3 4))))))
     '(#t #f . 4))


    (check-equal?
     (execute
      '(module
         (define vector-map!
           (lambda (v f)
             (letrec ([loop
                       (lambda (i)
                         (if (eq? i (vector-length v))
                             (void)
                             (begin
                               (vector-set! v i (f (vector-ref v i)))
                               (loop (+ i 1)))))])
               (begin
                 (loop 0)
                 v))))
         (cons
          (vector-map! #(1 2 3 4 5) (lambda (x) (+ x 1)))
          (cons
           (vector-map! #(1 2 3 4 5) (lambda (x) 0))
           (vector-map! #(1 2 3 4 5) (lambda (x) (* x 2)))))))
     '(#(2 3 4 5 6)
       #(0 0 0 0 0)
       .
       #(2 4 6 8 10)))

    (check-equal?
     (execute
      '(module
         (define list?
           (lambda (x)
             (if (eq? () x)
                 #t
                 (if (pair? x)
                     (list? (cdr x))
                     #f))))
         (define length
           (lambda (x)
             (if (not (list? x))
                 (error 5)
                 (letrec ([loop
                           (lambda (x)
                             (if (eq? () x)
                                 0
                                 (+ 1 (loop (cdr x)))))])
                   (loop x)))))
         (define empty?
           (lambda (l)
             (eq? l ())))

         (define append
           (lambda (l1 l2)
             (if (empty? l1)
                 l2
                 (cons (car l1) (append (cdr l1) l2)))))
         (define ++
           (lambda (d1 d2)
             (if (and (list? d1) (list? d2))
                 (append d1 d2)
                 (if (and (fixnum? d1) (fixnum? d2))
                     (+ d1 d2)
                     (if (and (boolean? d1) (boolean? d2))
                         (or d1 d2)
                         (if (and (procedure? d1) (procedure? d2))
                             (if (and (eq? (procedure-arity d1) 1)
                                      (eq? (procedure-arity d2) 1))
                                 (lambda (x) (d1 (d2 x)))
                                 (error 1))
                             (error 2)))))))
         (cons
          (++ '(1 2 3 4) '(5 6 7 8))
          (cons
           (++ 5 6)
           (cons
            (++ #t #f)
            (cons
             ((++ (lambda (x) (+ x 1))
                  (lambda (x) 9)) 0)
             ()))))))
     '((1 2 3 4 5 6 7 8)
       11
       #t
       10))


  ))