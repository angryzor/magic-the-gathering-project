#!r6rs

(library
 (card-stackable)
 (export card-stackable)
 (import (rnrs base (6))
         (magic object)
         (magic cards card))

 ;Class: card-stackable
 (define (card-stackable name color cost game player picture . this-a)
   
   (define (play)
     #f)
   (define (cast)
     #f)
   
   (define (supports-type? type)
     (or (eq? type card-stackable) (super 'supports-type? type)))
   (define (get-type)
     card-stackable)
   
   (define (obj-card-stackable msg . args)
     (case msg
       ((play) (apply play args))
       ((cast) (apply cast args))
       ((supports-type?) (apply supports-type? args))
       ((get-type) (apply get-type args))
       (else (apply super msg args))))
   
   (define this (extract-this obj-card-stackable this-a))
   (define super (card name color cost game player picture this))
   
   obj-card-stackable)
 
)