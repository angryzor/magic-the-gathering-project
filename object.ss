#!r6rs

(library
 (object)
 (export extract-this
         define-dispatch-class
         define-dispatch-subclass)
 (import (for (rnrs) run expand)
         (rnrs base (6)))

 (define (extract-this obj this-a)
   (if (null? this-a)
       obj
       (car this-a)))
 
; (define-syntax put-interface-sub
;   (syntax-rules (this super)
;     [(_ classname this-a (super-name super-args ...) (interface ...)) (begin (define (obj msg . args)
;                                                                                (case msg
;                                                                                  ((interface) (apply interface args))
;                                                                                  ...
;                                                                                  (else (apply super msg args))))
;                                                                              (define this (extract-this obj this-a))
;                                                                              (define super (super-name super-args ... this))
;                                                                              obj)]))
;
; (define-syntax put-interface
;   (syntax-rules (this)
;     [(_ classname this-a (interface ...)) (begin (define (obj msg . args)
;                                                    (case msg
;                                                      ((interface) (apply interface args))
;                                                      ...
;                                                      (else (assertion-violation (quote classname) "message not understood"))))
;                                                  (define this (extract-this obj this-a))
;                                                  obj)]))
;
; 
;
; (define-syntax put-interface-sub-no-obj
;   (syntax-rules ()
;     [(_ classname this-a (super-name super-args ...) (interface ...)) (begin (define (obj msg . args)
;                                                                                (case msg
;                                                                                  ((interface) (apply interface args))
;                                                                                  ...
;                                                                                  (else (apply super msg args))))
;                                                                              (define this (extract-this obj this-a))
;                                                                              (define super (super-name super-args ... this))
;                                                                              obj)]))
;
; (define-syntax put-interface-no-obj
;   (syntax-rules ()
;     [(_ classname this-a (interface ...)) (begin (define (obj msg . args)
;                                                    (case msg
;                                                      ((interface) (apply interface args))
;                                                      ...
;                                                      (else (assertion-violation (quote classname) "message not understood"))))
;                                                  (define this (extract-this obj this-a))
;                                                  obj)]))

 

 (define-syntax define-dispatch-class
   (lambda (x)
     (syntax-case x (init)
       [(k (name class-args ...) (interface ...) (init init-clauses ...) rest ...) (with-syntax ([this (datum->syntax #'k 'this)])
                                                                        #'(define (name class-args ... . this-a)
                                                                            rest ...
                                                                            (define (obj msg . args)
                                                                              (case msg
                                                                                ((interface) (apply interface args))
                                                                                ...
                                                                                (else (assertion-violation (quote name) "message not understood" msg))))
                                                                            (define this (extract-this obj this-a))
                                                                            init-clauses ...
                                                                            obj))]
       [(k (name class-args ...) (interface ...) rest ...) (with-syntax ([this (datum->syntax #'k 'this)])
                                                             #'(define (name class-args ... . this-a)
                                                                 rest ...
                                                                 (define (obj msg . args)
                                                                   (case msg
                                                                     ((interface) (apply interface args))
                                                                     ...
                                                                     (else (assertion-violation (quote name) "message not understood" msg))))
                                                                 (define this (extract-this obj this-a))
                                                                 obj))])))
 
 (define-syntax define-dispatch-subclass
   (lambda (x)
     (syntax-case x (init)
       [(k (name class-args ...) (interface ...) (super-name super-args ...) (init init-clauses ...) rest ...) (with-syntax ([this (datum->syntax #'k 'this)]
                                                                                                                [super (datum->syntax #'k 'super)])
                                                                                                    #'(define (name class-args ... . this-a)
                                                                                                        rest ...
                                                                                                        (define (obj msg . args)
                                                                                                          (case msg
                                                                                                            ((interface) (apply interface args))
                                                                                                            ...
                                                                                                            (else (apply super msg args))))
                                                                                                        (define this (extract-this obj this-a))
                                                                                                        (define super (super-name super-args ... this))
                                                                                                        init-clauses ...
                                                                                                        obj))]
       [(k (name class-args ...) (interface ...) (super-name super-args ...) rest ...) (with-syntax ([this (datum->syntax #'k 'this)]
                                                                                                     [super (datum->syntax #'k 'super)])
                                                                                         #'(define (name class-args ... . this-a)
                                                                                             rest ...
                                                                                             (define (obj msg . args)
                                                                                               (case msg
                                                                                                 ((interface) (apply interface args))
                                                                                                 ...
                                                                                                 (else (apply super msg args))))
                                                                                             (define this (extract-this obj this-a))
                                                                                             (define super (super-name super-args ... this))
                                                                                             obj))])))
 )
