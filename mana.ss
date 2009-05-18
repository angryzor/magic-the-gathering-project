#!r6rs

(library (mana)
 (export mana-unit
         mana-list
         manapool)
 (import (rnrs base (6))
         (magic double-linked-position-list))
 
 (define (mana-unit color)
   (define (get-color)
     color)
   
   (define (obj-mana-unit msg . args)
     (case msg
       ((get-color) (apply get-color args))
       (else (assertion-violation 'mana-unit "message not understood" msg))))
   
   obj-mana-unit)
 
 (define manacheck (lambda (x y)
                     (or (eq? (x 'get-color) (y 'get-color)) 
                         (eq? (x 'get-color) 'colorless)
                         (eq? (y 'get-color) 'colorless))))
 
 (define (mana-list . lst)
   (let ([l (position-list manacheck)])
     (l 'from-scheme-list lst)
     l))
 
 (define (manapool)
   (define cache (mana-list))
   (define (add! mana)
     (mana 'for-each (lambda (x)
                       (cache 'add-after! x))))
   (define (can-afford? mana)
     (let ([tmpcache (cache 'duplicate)])
       (call/cc (lambda (cont)
                  (mana 'for-each (lambda (x)
                                    (let ((pos (tmpcache 'find x)))
                                      (if pos
                                          (tmpcache 'delete! pos)
                                          (cont #f)))))
                  #t))))
   
   (define (delete! mana)
     (if (can-afford? mana)
         (mana 'for-each (lambda (x)
                           (cache 'delete! (cache 'find x))))
         (error 'manapool.delete! "can't afford")))
   
   (define (obj-manapool msg . args)
     (case msg
       ((add!) (apply add! args))
       ((can-afford?) (apply can-afford? args))
       ((delete!) (apply delete! args))
       ((print) (cache 'print))
       (else (assertion-violation 'manapool "message not understood" msg))))
   
   obj-manapool)
)