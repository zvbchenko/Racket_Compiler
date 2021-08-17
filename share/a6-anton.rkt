#lang racket

(require "util.rkt")
(require "a7-compiler-lib.rkt")

(module+ test
  (require rackunit))


(provide 
 assign-frame-variables
 discard-call-live
 replace-locations
;  expose-basic-blocks
 )

; Exercise 9
; Spilled-lang v6 -> Block-jump-live-lang v6
(define (assign-frame-variables p)
    (displayln (format "\n *********** \n\n assign-frame-variables: ~a" p) )
  
  (define cnflcts (void))
  
  (define (check-conflicts assig loc)
    ;; get conflicts for the location
    ;; check if the conflict was assigned
    ;; assign fav(max index found + 1)
    (define found 0)
    (define max 0)
    (define tmpconf (void))
    (for ([cnf cnflcts])
      (if (eq? (first cnf) loc)
          (begin (set! found 1)
                 (set! tmpconf (first (rest cnf))))
          (set! found found)))
    (displayln (format "check-conflicts assig ~a loc ~a" assig loc))
    (if (eq? found 1)
        (if (empty? assig)
            (make-fvar 0)
            (begin              
              (for ([as assig])
                (for ([tmp tmpconf])
                  (if (eq? (first as) tmp)
                      (begin (displayln (format "assign tmpconf ~a as ~a tmp ~a" tmpconf as tmp)) 
                          (when (fvar? (second as)) 
                            (when (>= (fvar->index (second as)) max) 
                              (set! max (+ 1 (fvar->index (second as)))))))
                      (set! max max)
                      )))
              (make-fvar max)))
        (make-fvar 0)
        
        ))

  (define (parse-c conflicts)
    (match conflicts
      [`(conflicts ,cnfs) cnfs]))
  
  (define (add-locs locs assig)
    (if (empty? locs)
        assig
        (add-locs (rest locs) (foldr cons (list `(,(first locs) ,(check-conflicts assig (first locs)))) assig))))

  ;; (listof fvar) -> fvar
    (define (produce-non-conflict-fvar conflict-fvars) 
      (define (find-a-num l)
        (let ([res 0])
          (for ([i l])
            (unless (member (+ i 1) l)
              (set! res (+ i 1))))
          res))
      (let ([indices (set->list (list->set (map fvar->index conflict-fvars)))])
          ; (displayln (format "indices: ~a" indices))
        ; (make-fvar (helper indices 0))
          (make-fvar (find-a-num (sort indices >))) ))

  (define (replace-var varlist assigned)
    (for ([var varlist])
      (let ([var^ (info-ref assigned var (lambda () '()))])
        (unless (empty? var^)
          (begin (remove var varlist)
                (set! varlist (cons var^ varlist))))))
    varlist)
               
  ; TODO fix no assignment case
  (define (assign-assignments locs assigned)
    (for ([loc locs])
      (let* ([conflict-vars (info-ref cnflcts loc)]
             [replaced-vars (replace-var conflict-vars assigned)]
             [conflict-fvars (filter fvar? replaced-vars)]
             [fvar (produce-non-conflict-fvar conflict-fvars)])
            (set! assigned (info-set assigned loc fvar))))
    ; `(assignment ,(add-locs (reverse locs) assignment)
    (info-set '() 'assignment assigned)
    )
    ; (match assignment
    ;   [`(assignment ,assig) `(assignment ,(add-locs (reverse locs) assig))])
    

  (define (assign-locals conflicts locals assignment)
    ; (set! cnflcts (parse-c conflicts)
    (set! cnflcts conflicts)
    (assign-assignments locals assignment)
    ; (match locals
    ;   [`(locals ,locs)(assign-assignments locs assignment)]
    ;   )
      )
  
  (define (info-reduce info)
     `(,(assign-locals (info-ref info 'conflicts (lambda () '())) (info-ref info 'locals (lambda () '())) (info-ref info 'assignment (lambda () '()))))
    ; (match info
    ;   [`(,locals ,undead ,conflicts ,assignment) `(,(assign-locals conflicts locals assignment))]
    ;   ; [`(,new-frames ,locals ,undead ,conflicts ,assignment) `(,(assign-locals conflicts locals assignment))]
    ;   )
      )


  (define (info-parse b)
    (match b
      [	`(define ,label ,info ,tail)`(define ,label ,@(info-reduce info)
                                       ,tail)]
      ;[else (error "fail to flatten block")]
      ))
  
  
  (define (trampoline p)
    (match p
      [`(module ,b ...) `(module ,@(map info-parse b))]
      ;[else (error "fail to flatten program")]
      ))

  (trampoline p))

(module+ test
  (check-equal? (assign-frame-variables
                 '(module  (define L.main.15
                             ((locals (ra.25))
                              (undead-out
                               ((ra.25 rbp)))
                              (conflicts
                               ((ra.25 (rbp))))
                              (assignment ()))
                             (begin
                               (set! ra.25 r15)
                               (jump L.s.1 rbp r15 fv0)))))
                '(module
                     (define L.main.15
                       ((assignment ((ra.25 fv0))))
                       (begin (set! ra.25 r15) (jump L.s.1 rbp r15 fv0)))))
  (check-equal? (assign-frame-variables
                 '(module  (define L.main.15
                             ((locals (ra.25 v.23))
                              (undead-out
                               ((ra.25 rbp)))
                              (conflicts
                               ((ra.25 (rbp))
                                (v.23 (rbp))))
                              (assignment ()))
                             (begin
                               (set! ra.25 r15)
                               (set! v.23 (ra.25 - 8) 
                                     (jump L.s.1 rbp r15 fv0))))))
                '(module
                     (define L.main.15
                       ((assignment ((v.23 fv0)(ra.25 fv0))))
                       (begin
                         (set! ra.25 r15)
                         (set! v.23 (ra.25 - 8) (jump L.s.1 rbp r15 fv0))))))
  (check-equal? (assign-frame-variables
                 '(module  (define L.main.15
                             ((locals (ra.25 v.23))(undead-out ()) (conflicts ()) (assignment ()))
                             (begin
                               (set! ra.25 r15)
                               (set! v.23 (ra.25 - 8) 
                                     (jump L.s.1 rbp r15 fv0))))
                    (define L.s.1
                      ((locals (ra.21 v.21))(undead-out ())(conflicts ())(assignment ()))
                      (begin
                        (set! ra.21 r15)
                        (set! v.21 (ra.25 - 8) 
                              (jump L.main.15 rbp r15 fv1))))))
                '(module
                     (define L.main.15
                       ((assignment ((v.23 fv0) (ra.25 fv0) )))
                       (begin (set! ra.25 r15) (set! v.23 (ra.25 - 8) (jump L.s.1 rbp r15 fv0))))
                   (define L.s.1
                     ((assignment ((v.21 fv0)(ra.21 fv0))))
                     (begin
                       (set! ra.21 r15)
                       (set! v.21 (ra.25 - 8) (jump L.main.15 rbp r15 fv1))))))




  
  (check-equal? (assign-frame-variables
                 '(module
                      (define L.main.1
                        ((locals ())
                         (undead-out
                          ((ra.1 rbp)
                           (ra.1 rsi rbp)
                           (ra.1 rdi rsi rbp)
                           (rdi rsi r15 rbp)
                           (rdi rsi r15 rbp)))
                         (conflicts
                          ((ra.1 (rdi rsi rbp))
                           (rbp (r15 rdi rsi ra.1))
                           (rsi (r15 rdi ra.1 rbp))
                           (rdi (r15 ra.1 rsi rbp))
                           (r15 (rdi rsi rbp))))
                         (assignment ((ra.1 r15))))
                        (begin
                          (set! ra.1 r15)
                          (set! rsi 2)
                          (set! rdi 1)
                          (set! r15 ra.1)
                          (jump L.swap.1 rbp r15 rsi rdi)))
                    (define L.swap.1
                      ((locals ())
                       (undead-out
                        ((rdi rsi ra.2 rbp)
                         (rsi x.1 ra.2 rbp)
                         (y.2 x.1 ra.2 rbp)
                         ((y.2 x.1 ra.2 rbp)
                          ((ra.2 rax rbp) (rax rbp))
                          (((rax ra.2 rbp)
                            ((y.2 rsi rbp) (rdi rsi rbp) (rdi rsi r15 rbp) (rdi rsi r15 rbp)))
                           (z.3 ra.2 rbp)
                           (ra.2 rax rbp)
                           (rax rbp)))))
                       (conflicts
                        ((rax (rbp ra.2))
                         (ra.2 (y.2 x.1 rdi rsi rbp z.3 rax))
                         (rbp (y.2 x.1 ra.2 z.3 r15 rdi rsi rax))
                         (rsi (x.1 ra.2 r15 rdi y.2 rbp))
                         (y.2 (x.1 ra.2 rbp rsi))
                         (rdi (ra.2 r15 rsi rbp))
                         (r15 (rdi rsi rbp))
                         (z.3 (ra.2 rbp))
                         (x.1 (y.2 rsi ra.2 rbp))))
                       (assignment ((ra.2 fv0) (x.1 r15) (y.2 r14) (z.3 r15))))
                      (begin
                        (set! ra.2 r15)
                        (set! x.1 rdi)
                        (set! y.2 rsi)
                        (if (< y.2 x.1)
                            (begin (set! rax x.1) (jump ra.2 rbp rax))
                            (begin
                              (set! rbp (+ rbp 8))
                              (return-point L.rp.2
                                            (begin
                                              (set! rsi x.1)
                                              (set! rdi y.2)
                                              (set! r15 L.rp.2)
                                              (jump L.swap.1 rbp r15 rsi rdi)))
                              (set! rbp (- rbp 8))
                              (set! z.3 rax)
                              (set! rax z.3)
                              (jump ra.2 rbp rax)))))))
                '(module
                     (define L.main.1
                       ((assignment ((ra.1 r15))))
                       (begin
                         (set! ra.1 r15)
                         (set! rsi 2)
                         (set! rdi 1)
                         (set! r15 ra.1)
                         (jump L.swap.1 rbp r15 rsi rdi)))
                   (define L.swap.1
                     ((assignment ((ra.2 fv0) (x.1 r15) (y.2 r14) (z.3 r15))))
                     (begin
                       (set! ra.2 r15)
                       (set! x.1 rdi)
                       (set! y.2 rsi)
                       (if (< y.2 x.1)
                           (begin (set! rax x.1) (jump ra.2 rbp rax))
                           (begin
                             (set! rbp (+ rbp 8))
                             (return-point L.rp.2
                                           (begin
                                             (set! rsi x.1)
                                             (set! rdi y.2)
                                             (set! r15 L.rp.2)
                                             (jump L.swap.1 rbp r15 rsi rdi)))
                             (set! rbp (- rbp 8))
                             (set! z.3 rax)
                             (set! rax z.3)
                             (jump ra.2 rbp rax)))))))

  (check-equal? (assign-frame-variables '(module
                                             (define L.main.1
                                               ((locals ())
                                                (undead-out ((ra.1 rbp) (ra.1 rdi rbp) (rdi r15 rbp) (rdi r15 rbp)))
                                                (conflicts
                                                 ((ra.1 (rdi rbp))
                                                  (rbp (r15 rdi ra.1))
                                                  (rdi (r15 ra.1 rbp))
                                                  (r15 (rdi rbp))))
                                                (assignment ((ra.1 r15))))
                                               (begin
                                                 (set! ra.1 r15)
                                                 (set! rdi 1)
                                                 (set! r15 ra.1)
                                                 (jump L.swap.1 rbp r15 rdi)))
                                           (define L.swap.1
                                             ((locals ())
                                              (undead-out
                                               ((rdi ra.2 rbp)
                                                (x.1 ra.2 rbp)
                                                ((rax ra.2 rbp) ((rdi rbp) (rdi r15 rbp) (rdi r15 rbp)))
                                                (z.3 ra.2 rbp)
                                                (ra.2 rax rbp)
                                                (rax rbp)))
                                              (conflicts
                                               ((ra.2 (z.3 rax x.1 rdi rbp))
                                                (rbp (z.3 r15 rdi rax x.1 ra.2))
                                                (rdi (r15 rbp ra.2))
                                                (x.1 (ra.2 rbp))
                                                (rax (rbp ra.2))
                                                (r15 (rdi rbp))
                                                (z.3 (ra.2 rbp))))
                                              (assignment ((ra.2 fv0) (x.1 r15) (z.3 r15))))
                                             (begin
                                               (set! ra.2 r15)
                                               (set! x.1 rdi)
                                               (set! rbp (+ rbp 8))
                                               (return-point L.rp.2
                                                             (begin (set! rdi x.1) (set! r15 L.rp.2) (jump L.swap.1 rbp r15 rdi)))
                                               (set! rbp (- rbp 8))
                                               (set! z.3 rax)
                                               (set! rax z.3)
                                               (jump ra.2 rbp rax)))))
                '(module
                     (define L.main.1
                       ((assignment ((ra.1 r15))))
                       (begin
                         (set! ra.1 r15)
                         (set! rdi 1)
                         (set! r15 ra.1)
                         (jump L.swap.1 rbp r15 rdi)))
                   (define L.swap.1
                     ((assignment ((ra.2 fv0) (x.1 r15) (z.3 r15))))
                     (begin
                       (set! ra.2 r15)
                       (set! x.1 rdi)
                       (set! rbp (+ rbp 8))
                       (return-point L.rp.2
                                     (begin (set! rdi x.1) (set! r15 L.rp.2) (jump L.swap.1 rbp r15 rdi)))
                       (set! rbp (- rbp 8))
                       (set! z.3 rax)
                       (set! rax z.3)
                       (jump ra.2 rbp rax)))))

  (check-equal? (assign-frame-variables '(module
                                             (define L.add.2
                                               ((locals (m))(undead-out())(conflicts ())
                                                            (assignment ((ra.5 fv0)(a.1 fv1))))
                                               (begin
                                                 (set! ra.5 r15)
                                                 (set! y.2 rdi)
                                                 (set! m rsi)
                                                 ))))
                '(module
                     (define L.add.2
                       ((assignment ((ra.5 fv0) (a.1 fv1) (m fv0))))
                       (begin (set! ra.5 r15) (set! y.2 rdi) (set! m rsi)))))



  (check-equal? (assign-frame-variables
                 '(module
                      (define L.main.1
                        ((locals (ra.1 rd.1))
                         (undead-out())
                         (conflicts
                          ((ra.1 (rd.1))(rd.1 (ra.1))))
                         (assignment ()))
                        (begin
                          (set! ra.1 r15)
                          (set! rd.1 2)
                          (set! ra.1 (+ rd.1 1)
                                (set! rd.1 (+ ra.1 rd.1))
                                (jump L.swap.1 ra.1 rd.1))))))
                '(module
                     (define L.main.1
                       ((assignment ((rd.1 fv0) (ra.1 fv1))))
                       (begin
                         (set! ra.1 r15)
                         (set! rd.1 2)
                         (set! ra.1
                               (+ rd.1 1)
                               (set! rd.1 (+ ra.1 rd.1))
                               (jump L.swap.1 ra.1 rd.1))))))

  (check-equal? (assign-frame-variables
                 '(module
                      (define L.main.1
                        ((locals (ra.1 rd.1 rb.3))
                         (undead-out())
                         (conflicts
                          ((ra.1 (rd.1 rb.3))(rd.1 (ra.1 rb.3))(rb.3 (ra.1 rd.1))
                                             ))
                         (assignment ()))
                        (begin
                          (set! ra.1 r15)
                          (set! rd.1 2)
                          (set! ra.1 (+ rd.1 1)
                                (set! rd.1 (+ ra.1 rd.1))
                                (jump L.swap.1 ra.1 rd.1))))))
                '(module
                     (define L.main.1
                       ((assignment ((rb.3 fv0) (rd.1 fv1) (ra.1 fv2))))
                       (begin
                         (set! ra.1 r15)
                         (set! rd.1 2)
                         (set! ra.1
                               (+ rd.1 1)
                               (set! rd.1 (+ ra.1 rd.1))
                               (jump L.swap.1 ra.1 rd.1))))))
  

  )




#;((compose
    
    assign-frame-variables
    assign-registers
    assign-frames
    pre-assign-frame-variables
    conflict-analysis
    undead-analysis
    uncover-locals
    select-instructions)
   '(module
        (define L.swap.1
          (lambda (x.1)
            (let ([z.3 (apply L.swap.1 x.1)])
              z.3)))
      (apply L.swap.1 1))
   )
; Exercise 10

;  Block-jump-live-lang -> Block-assigned-lang
;

(define (discard-call-live p)
  

  ;(displayln (format "discard-call-live: ~a" p) )
  
  (define (flatten-tail tail)
    ;(displayln (format "discard-call-live-tail: ~a" tail) )
    (match tail
      
      [`(return-point ,label ,taim)`(return-point ,label ,(flatten-tail taim))]
      ;[`(set! ,aloc ,triv)`(set! ,aloc ,triv)]
      
      
      [`(jump ,trg ,aloc ...) `(jump ,trg)]
      [`(return-point ,label ,tail)`(return-point ,label ,(flatten-tail tail))]
      [`(if (,cmp ,loc ,opand) ,thntail ,elstail)`(if (,cmp ,loc ,opand) ,(flatten-tail thntail) ,(flatten-tail elstail))]
      ;[`(halt ,opand) `(halt ,opand)]
      ;[`(begin (halt ,opand)) `(begin (halt ,opand))]
      [`(begin `(jump ,trg ,aloc ...)) `(begin (jump ,trg))]
      [`(begin (if (,cmp ,loc ,opand) ,thntail ,elstail)) `(begin (if (,cmp ,loc ,opand) ,(flatten-tail thntail) ,(flatten-tail elstail)))]
      [`(begin (return-point ,label ,ttail)) `(begin (return-point ,label ,@(flatten-tail ttail)))]
      [`(begin ,s ... ,t) (append  (list 'begin) `( ,@(map flatten-tail s)) (list `,(flatten-tail t)))]
      [else tail]
      ))
      

  (define (flatten-block b)
    (match b
      [	`(define ,label ,info ,tail)`(define ,label ,info
                                       ,(flatten-tail tail))]
      ;[else (error "fail to flatten block")]
      ))
  
  
  (define (trampoline p)
    (match p
      [`(module ,b ...) `(module ,@(map flatten-block b))]
      ;[else (error "fail to flatten program")]
      ))

  (trampoline p))
  


(module+ test

  ;; use of return-point
  (check-equal? (discard-call-live
                 '(module (define L ((locals (x.1))(assignment ((x.1 r9))))
                            (begin (set! x.1 42)
                                   (if (eq? x.1 42)
                                       (jump L x.1)
                                       (begin (return-point L (jump L))(jump L)))))))
                '(module
                     (define L
                       ((locals (x.1)) (assignment ((x.1 r9))))
                       (begin
                         (set! x.1 42)
                         (if (eq? x.1 42)
                             (jump L)
                             (begin (return-point L (jump L)) (jump L)))))))


  (check-equal? (discard-call-live
                 '(module (define L.swap.1 ((locals (x.1))(assignment ((x.1 r9))))
                            (begin
                              (set! x.1 r15)
                              (set! fv1 2)
                              (set! fv0 1)
                              (set! r15 x.1)
                              (jump L.swap.1 rbp r15 fv1 fv0)))))
                '(module
                     (define L.swap.1
                       ((locals (x.1)) (assignment ((x.1 r9))))
                       (begin
                         (set! x.1 r15)
                         (set! fv1 2)
                         (set! fv0 1)
                         (set! r15 x.1)
                         (jump L.swap.1)))))
  ; no locals provided
  (check-equal? (discard-call-live
                 '(module (define L.swap.1 ()
                            (begin
                              (set! x.1 fv0)
                              (set! y.2 fv1)
                              (if (< y.2 x.1)
                                  (begin (set! rax x.1) (jump r15 rbp rax))
                                  (begin
                                    (return-point L.rp.12
                                                  (begin
                                                    (set! r15 L.rp.12)
                                                    (jump L.swap.1 rbp r15 x.1 y.2)))
                                    (jump ra.18 rbp z.3)))))))
                '(module
                     (define L.swap.1
                       ()
                       (begin
                         (set! x.1 fv0)
                         (set! y.2 fv1)
                         (if (< y.2 x.1)
                             (begin (set! rax x.1) (jump r15))
                             (begin
                               (return-point L.rp.12 (begin (set! r15 L.rp.12) (jump L.swap.1)))
                               (jump ra.18)))))))
  (check-equal? (discard-call-live '(module
                                        (define L.main.1
                                          ((assignment ((ra.1 r15))))
                                          (begin
                                            (set! ra.1 r15)
                                            (set! rdi 1)
                                            (set! r15 ra.1)
                                            (jump L.swap.1 rbp r15 rdi)))
                                      (define L.swap.1
                                        ((assignment ((ra.2 fv0) (x.1 r15) (z.3 r15))))
                                        (begin
                                          (set! ra.2 r15)
                                          (set! x.1 rdi)
                                          (set! rbp (+ rbp 8))
                                          (return-point L.rp.2
                                                        (begin (set! rdi x.1) (set! r15 L.rp.2) (jump L.swap.1 rbp r15 rdi)))
                                          (set! rbp (- rbp 8))
                                          (set! z.3 rax)
                                          (set! rax z.3)
                                          (jump ra.2 rbp rax)))))
                '(module
                     (define L.main.1
                       ((assignment ((ra.1 r15))))
                       (begin (set! ra.1 r15) (set! rdi 1) (set! r15 ra.1) (jump L.swap.1)))
                   (define L.swap.1
                     ((assignment ((ra.2 fv0) (x.1 r15) (z.3 r15))))
                     (begin
                       (set! ra.2 r15)
                       (set! x.1 rdi)
                       (set! rbp (+ rbp 8))
                       (return-point L.rp.2
                                     (begin (set! rdi x.1) (set! r15 L.rp.2) (jump L.swap.1)))
                       (set! rbp (- rbp 8))
                       (set! z.3 rax)
                       (set! rax z.3)
                       (jump ra.2)))))
                 
   


  


  )


; Exercise 11
(define (replace-locations p)
  ; (displayln (format "replace-location: ~a" p) )
  (define (sub-tail tail)
    (match tail
      [`(begin ,s ... ,t) (append (list 'begin) (map sub-s s) (list `,(sub-tail t)))]
      [`(jump ,trg) (if (and (aloc? trg) (dict-has-key? varReg trg) )
                        `(jump ,(dict-ref varReg trg))
                        `(jump ,trg))]
     
      [`(if (,cmp ,loc ,opand) ,thntail ,elstail) #:when (and (cmp? cmp) (aloc? loc))
                    `(if (,cmp ,(dict-ref varReg loc) ,(sub-s opand)) ,(sub-tail thntail) ,(sub-tail elstail))]


      ))

  (define (sub-s s)
    (match s 
      [`,num #:when (int64? num) num]
        
        
      [`,areg #:when (register? areg) areg]
      [`,label #:when (label? label) label]
      [`,aloc #:when (aloc? aloc) (dict-ref varReg aloc)]
      [`(,binop ,arg1 ,arg2) #:when (valid-binop? binop)
                             `(,binop ,(sub-s arg1) ,(sub-s arg2))]
      [`(set! ,loc1 (mref ,loc2 ,index))`(set! ,(sub-s loc1) (mref ,(sub-s loc2) ,(sub-s index)))]     
      [`(set! ,aloc1 ,int) #:when (and (aloc? aloc1)(int64? int)) `(set! ,(dict-ref varReg aloc1) ,int)]
      [`(set! ,aloc1 ,aloc2) #:when (aloc? aloc1)
        (let ([a1 (dict-ref varReg aloc1)]
              [a2 (sub-s aloc2)])
          (if (equal? a1 a2)
              `(nop)
              `(set! ,a1 ,a2)))]
      [`(set! ,areg ,int) #:when (and (register? areg)(int64? int)) `(set! ,areg ,int)]
      [`(set! ,areg ,aloc) #:when (register? areg) `(set! ,areg ,(sub-s aloc))]
      [`(set! ,fvar ,aloc) #:when (fvar? fvar)
          (let ([ares (sub-s aloc)])
            (if (equal? fvar ares)
                `(nop)
                `(set! ,fvar ,ares)))]
      [`(return-point ,label ,tail)`(return-point ,label ,(sub-tail tail))]
      [`(mset! ,loc ,index ,triv)`(mset! ,(sub-s loc) ,(sub-s index) ,(sub-s triv))]
      [else s]
      )
    )

  (define varReg (make-hash))

    

  (define (alss a)
    (match a
      [`(,aloc ,rloc) (dict-set! varReg aloc rloc)]))

  (define (assign a) 
    (match a 
      [`(assignment (,asloc ...)) (map alss asloc)]
      )
    )

  (define (recur info)
    (if (empty? info) 
        #f
        (begin (assign (first info))
               (recur (rest info))))
    )

  (define (sub-in-block block)
    (match block
      [`(define ,label ,info ,tail)
       (recur info)
       `(define ,label () ,(sub-tail tail))]

      ))

  
  (define (trampoline p)
    (match p
      [`(module ,b ...)  (map sub-in-block b)]
      [else (error "fail to sub")]
      ))

  (append (list 'module) (trampoline p))
  )





(module+ test
  (check-equal? (replace-locations '(module
                                        (define L
                                          ((assignment ((x.1 r9))))
                                          (begin
                                            (set! x.1 42)
                                            (if (eq? x.1 42)
                                                (jump L)
                                                (begin (return-point L (jump L)) (jump L)))))))
                '(module
                     (define L
                       ()
                       (begin
                         (set! r9 42)
                         (if (eq? r9 42) (jump L) (begin (return-point L (jump L)) (jump L)))))))
  (check-equal? (replace-locations '(module
                                        (define L.main.1
                                          ((assignment ((ra.1 r15))))
                                          (begin (set! ra.1 r15) (set! rdi 1) (set! r15 ra.1) (jump L.swap.1)))
                                      (define L.swap.1
                                        ((assignment ((ra.2 fv0) (x.1 r15) (z.3 r15))))
                                        (begin
                                          (set! ra.2 r15)
                                          (set! x.1 rdi)
                                          (set! rbp (+ rbp 8))
                                          (return-point L.rp.2
                                                        (begin (set! rdi x.1) (set! r15 L.rp.2) (jump L.swap.1)))
                                          (set! rbp (- rbp 8))
                                          (set! z.3 rax)
                                          (set! rax z.3)
                                          (jump ra.2)))))
                '(module
                     (define L.main.1 () (begin (set! r15 r15) (set! rdi 1) (set! r15 r15) (jump L.swap.1)))
                   (define L.swap.1
                     ()
                     (begin
                       (set! fv0 r15)
                       (set! r15 rdi)
                       (set! rbp (+ rbp 8))
                       (return-point L.rp.2
                                     (begin (set! rdi r15) (set! r15 L.rp.2) (jump L.swap.1)))
                       (set! rbp (- rbp 8))
                       (set! r15 rax)
                       (set! rax r15)
                       (jump fv0)))))

  
; TODO  handle mref case
 (check-equal? (replace-locations '(module
  (define L.main.4
    ((assignment ((ra.1 r15) (x.1 r14))))
    (begin
      (set! ra.1 r15)
      (set! x.1
        (let ((tmp.10 (+ (alloc (* 8 2)) 3)))
          (begin (mset! tmp.10 -3 16) tmp.10)))
      (mset! x.1 5 8)
      (mset! x.1 13 16)
      (mset! x.1 21 24)
      (set! rax (mref x.1 21))
      (jump ra.1)))))
      '(module
  (define L.main.4
    ()
    (begin
      (nop)
      (set! r14
        (let ((tmp.10 (+ (alloc (* 8 2)) 3)))
          (begin (mset! tmp.10 -3 16) tmp.10)))
      (mset! r14 5 8)
      (mset! r14 13 16)
      (mset! r14 21 24)
      (set! rax (mref r14 21))
      (jump r15)))))

  )


; Exercise 13

(define (expose-basic-blocks p)
  ;(define new-blocks empty)
  ; (displayln (format "expose-basic-blocks: ~a" p) )

  (define add-to-list
    (let ((the-list '()))
      (lambda (new-item)
        (if (empty? new-item)
            (set! the-list the-list)
            (set! the-list (append the-list (list new-item))))
        the-list)))
  

  
  ;;;;;;;;
  (define (create-begin-block p)
    (define block-name (fresh-label))
    (define addm `())
    (match p
      [`(begin (return-point ,label ,tai) ,t) (set! addm `(define ,block-name () (begin ,(create-return-point-block `(return-point ,label ,tai ,t)))))]
      [`(begin ,s ... ,t) (set! addm `(define ,block-name () (begin ,s ,(parse-tail t))))]
      )
    (add-to-list addm)
    block-name
    )
  
  

  (define (create-if-block p)
    (define block-name (fresh-label))
    (define addm empty)
    (match p
      [`(if (,cmp ,loc ,opand) ,thntail ,elstail) (set! addm `(define ,block-name () (if (,cmp ,loc ,opand)
                                                                                         (jump ,(parse-tail thntail))
                                                                                         (jump ,(parse-tail elstail)))))]
  
      )
    (add-to-list addm)
    block-name
    )


  (define (create-jump-block tail)
    (define block-name (fresh-label))
    (define addm empty)
    (match tail
      [`(begin ,s* ,t)(create-begin-block `(begin ,s* ,t))]
      [`(if (,cmp ,loc ,opand) ,thntail ,elstail)(create-if-block tail)]
      [`,trg (set! addm `(define ,block-name ()(jump ,trg)))])
    (add-to-list addm)
    block-name)
  
  ;;;;

    
  
  (define (parse-tail tail)
    (match tail
      [`(begin ,s* ... ,t)(create-begin-block `(begin ,@s* ,t))]
      [`(jump ,trg) (create-jump-block trg)]
      ;[`(halt ,opand)(create-halt-block opand)]
      [`(if (,cmp ,loc ,opand) ,thntail ,elstail)(create-if-block tail)]
      ;[else tail]
      
      ))

     
  (define (check-rloc addr)
    (match addr
      [`(,fbp + ,dispoffset) #:when (fbp? fbp) `(,fbp + ,dispoffset)]
      [else addr]
      ))

  
  (define (create-return-point-block p)
    (define block-name (fresh-label))
    (define addm empty)
    (match p
      [`(return-point ,label ,tai ,t) (begin
                                        (set! addm `(define ,label () (begin ,t)))
                                        (set! block-name tai))]
      [`(return-point ,label ,tai) (begin
                                     (set! addm `(define ,label () (begin ,tai)))
                                     (set! block-name tai))]
  
      )
    (add-to-list addm)
    block-name
    )


  ;;;;;;
  (define (parse-s s)
    (match s
      [`(if (,cmp ,loc ,opand) ,thntail ,elstail)
       (list `(if (,cmp ,loc ,opand) (jump ,(parse-tail thntail))(jump ,(parse-tail elstail))))]
      [`(set! ,addr (,binop ,addr2 ,int))(list `(set! ,(check-rloc addr) (,binop ,(check-rloc addr2) ,int)))]
      [`(set! ,addr ,int)#:when (int64? int) (list `(set! ,(check-rloc addr) ,int))]
      [`(set! ,reg1 ,reg2) #:when (and (register? reg1) (register? reg2)) (list `(set! ,reg1 ,reg2))]
      [`(set! ,addr1 ,addr2) (list `(set! ,(check-rloc addr1) ,(check-rloc addr2)))]
      ;[`(halt ,addr)(list `(halt ,addr))]
      [`(jump ,addr) (begin (set! rp-activated 0)  (list `(jump ,addr)))]
      [`(return-point ,label ,tai)(begin (create-return-point-block s)(process-rp tai))] ;new create-return-point-block is needed
      [`(begin ,s ...) (list `(begin ,@(append-map parse-s s)))]
      [`(nop)(list '(nop))]
      [`() (begin (set! rp-activated 0) '())]
      ))
  ;;;;;;;;;;;
  (define rp-activated 0)
  (define appendtai empty)
  (define labelt empty)


  (define (parse-rp-tail tail)
    ; (displayln (format "parse-rp-tail ~a" tail))
    (match tail
      [`(begin (,s ... ,t))`(begin ,@s ,(parse-rp-tail t))]
      [`(jump ,trg)  `(jump ,trg)]
      [`(if ,cmp ,tail1 ,tail2) `(if ,cmp ,(parse-rp-tail tail1) ,(parse-rp-tail tail2))]
      ))



  
  (define (create-return-point-blocktwo p)
    (displayln (format "create-return-point-blocktwo: ~a" p))
    (match p
      [`(return-point ,label ,tai) `(define ,label () ,(parse-rp-tail `(begin ,(reverse appendtai))))]))

  (define (update-appendtai s)
    (displayln (format "updating tai with: ~a" s))
    (set! appendtai (foldr cons appendtai (parse-s s)))
    `()
    )
    

  (define (rp-s s)
    (match s
      [`(return-point ,label ,tai)(begin (set! labelt label)(process-rp tai))] 
      [else (if (eq? rp-activated 1)
                (update-appendtai s)
                (parse-s s))
                ]))



  (define (process-rp tail)
    (displayln (format "process-rp: ~a" tail))
    (match tail
      [`(begin ,s ... ,t)`(,@s ,(process-rp t))]
      [`(jump ,trg) (begin (set! rp-activated 1) `(jump ,trg))]
      ;[`(halt ,opand)(create-halt-block opand)]
      
      [`(if (,cmp ,loc ,opand) ,thntail ,elstail) (create-if-block tail)]))
  ;;;

  
  (define (expose-tail tail)
    ;(displayln (format "tail: ~a" tail))
    (match tail
      [`(begin ,s ... ,t) `(begin ,@(append-map rp-s s) ,@(parse-tail t))]
      [else (error "fail to expose-tail")])
    
        
    
    )

  (define (expose-block b)
    (match b
      [	`(define ,label ,info ,tail) `(define ,label ,info ,(expose-tail tail))] ;;error
      [else (error "fail to expose block")]
      ))


  (define (trampoline p)
    (match p
      [`(module ,b ...)  (map expose-block b)]
      [else (error "fail to flatten program")]
      ))

  (define (merge) ; Think about moving it to trampoline and resetting appendtai after
    (if (empty? appendtai)
        (add-to-list empty)
        (add-to-list (create-return-point-blocktwo `(return-point ,labelt (begin ,appendtai))))
                  ))

  (append (list 'module) (trampoline p) (merge) )
  )

(module+ test
  (check-equal? (expose-basic-blocks '(module
                                          (define L
                                            ((assignment ((x.1 r9))))
                                            (begin
                                              (set! x.1 42)
                                              (if (eq? x.1 42)
                                                  (jump x.1)
                                                  (begin (return-point L.2 (jump L.2)) (jump L.3)))))))
                '(module
                     (define L
                       ((assignment ((x.1 r9))))
                       (begin
                         (set! x.1 42)
                         (if (eq? x.1 42) (jump L.tmp.1) (jump L.tmp.2))))
                   (define L.tmp.1 () (jump x.1))
                   (define L.2 () (begin (jump L.3)))
                   (define L.tmp.2 () (begin (jump L.2)))))




  

  (check-equal? (expose-basic-blocks '(module
                                          (define L.main.1 () (begin (nop) (set! rdi 1) (nop) (jump L.swap.1)))
                                        (define L.swap.1
                                          ()
                                          (begin
                                            (set! (rbp + 0) r15)
                                            (set! r15 rdi)
                                            (set! rbp (+ rbp 8))
                                            (return-point L.rp.2
                                                          (begin (set! rdi r15) (set! r15 L.rp.2) (jump L.swap.1)))
                                            (set! rbp (- rbp 8))
                                            (set! r15 rax)
                                            (set! rax r15)
                                            (jump (rbp + 0))))))
                '(module
                     (define L.main.1 () (begin (nop) (set! rdi 1) (nop) (jump L.swap.1)))
                   (define L.swap.1
                     ()
                     (begin
                       (set! (rbp + 0) r15)
                       (set! r15 rdi)
                       (set! rbp (+ rbp 8))
                       (set! rdi r15)
                       (set! r15 L.rp.2)
                       (jump L.swap.1)))
                   (define L.rp.2
                     ()
                     (begin
                       (set! rbp (- rbp 8))
                       (set! r15 rax)
                       (set! rax r15)
                       (jump (rbp + 0))))))


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
       (define L.L.f1.1.8
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
      (define L.L.f1.1.8
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



  )


