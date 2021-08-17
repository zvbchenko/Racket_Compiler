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
     (execute '(module
        (define sum
        (lambda (a b c d e f g h)
            (let ((i (+ a b)))
            (let ((j (+ g h))) (+ i j)))))
        (let ((x 10))
        (if (eq? 1 2)
            (let ((j (sum 1 2 3 4 5 6 7 8))) j)
            (let ((x 5)) (sum 1 2 3 4 5 6 7 x)))))
     ) 15)



    (check-equal?
     (execute `(module
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
                          (let ((z9 (+ z8 t2))) z9))))))))))))
     ) 42)

     (check-equal?
     (execute '(module (letrec ([f (lambda (x) (if (<= x 9) x (f (- x 1))))])
                            (f 20)))
     ) 9)

     (check-equal?
     (execute `(module (letrec ([is-even? (lambda (n)
                                    (or (eq? n 0)
                                        (is-odd? (- n 1))))]
                        [is-odd? (lambda (n)
                                    (and (not (eq? 0 n))
                                        (is-even? (- n 1))))])
                            (is-odd? 11)))
     ) #t)

     (check-equal?
     (execute '(module (define zeros (lambda (n l) (if (eq? n 0) 
                                                        l 
                                                        (zeros (- n 1) (cons 0 l)))))
                        (define map (lambda (f l) (if (empty? l) 
                                                        l 
                                                        (cons (f (car l)) (map f (cdr l))))))
                        (define inc (lambda (x) (+ x 1)))
                        (let ([listofZero (zeros 32 '())])
                            (let ([ones (map inc listofZero)])
                                ones)))
     ) '(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))



    

     (check-equal? (execute '(module (letrec ([f (lambda (x) (lambda (y) (+ x y)))])
                ((f 7) 9))))
                16)

    (check-equal? (execute `(module (define f (lambda (x) (lambda (y) (+ x y))))
                               ((f 7) 9)))
                               16)

    (check-equal? (execute '(module (define filter (lambda (pred? lox) (if (empty? lox) 
                                                                            '()
                                                                            (if (apply-pred pred? (car lox))
                                                                                (cons (car lox) (filter pred? (cdr lox)))
                                                                                (filter pred? (cdr lox))))))
                                    (define apply-pred (lambda (pred? x) (pred? x)))
                                    (define make-bigger? (lambda (threshold) (lambda (n) (> n threshold))))
                                    (define only-bigger (lambda (threshold lon) (filter (make-bigger? threshold) lon)))
                                (only-bigger 8 '(6 7 8 9 1 23))))
      '(9 23)
      "lambda filter")  

    



    (check-equal? (execute '(module
                              (letrec ((filter
                                        (lambda (pred? lox)
                                          (if (empty? lox)
                                            '()
                                            (if (apply-pred pred? (car lox))
                                              (cons (car lox) (filter pred? (cdr lox)))
                                              (filter pred? (cdr lox))))))
                                      (apply-pred
                                        (lambda (pred? x)
                                          (if (eq? (car pred?) #\m)
                                            (> x (cdr pred?))
                                            (error 99))))
                                      (make-bigger?
                                        (lambda (threshold) (cons #\m threshold))))
                                (filter (make-bigger? 8) '(4 7 8 9 1 23)))))
      '(9 23)
      "defunctionalize filter")   


    (check-equal? (execute '(module (letrec ([f (lambda (p l) (if (empty? l) 
                                                                '()
                                                                (if (a p (car l))
                                                                    (cons (car l) (f p (cdr l)))
                                                                    (f p (cdr l)))))]
                      [a (lambda (p x) (let ([l (vector-ref p 0)]) (l p x)))]
                      [m (lambda (t) (let ([c #(0 0)])
                                        (begin (vector-set! c 1 t)
                                              (vector-set! c 0 (lambda (p n) (> n (vector-ref p 1))))
                                              c)))])
                    (f (m 8) '(4 7 8 9 1 23)))))
      '(9 23)
      "open-closed filter")                         
#|
|#


  ))