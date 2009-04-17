#!r6rs

(library
 (card-artifact)
 (export card-artifact)
 (import (rnrs base (6))
         (magic cards card-permanent)
         (magic object))

 ; Card-artifact
 (define (card-artifact name color cost game player picture . this-a)
   (define (supports-type? type)
     (or (eq? type card-artifact) (super 'supports-type? type)))
   (define (get-type)
     card-artifact)
   
   (define (obj-card-artifact msg . args)
     (case msg
       ((supports-type?) (apply supports-type? args))
       ((get-type) (apply get-type args))
       (else (apply super msg args))))
   
   (define this (extract-this obj-card-artifact this-a))
   (define super (card-permanent name color cost game player picture this))
   
   obj-card-artifact)
 

)