#!r6rs

(library
 (card-stackable)
 (export card-stackable)
 (import (rnrs base (6))
         (magic object)
         (magic cards card))

 ;Class: card-stackable
 (define-dispatch-subclass (card-stackable name color cost game player picture)
   (play cast supports-type? get-type)
   (card name color cost game player picture)
   
   (define (play)
     #f)
   (define (cast)
     #f)
   
   (define (changed-zone zone)
     (super 'changed-zone zone)
     (case zone
       (( (eq? ((player 'get-field) 'get-stack-zone) zone) )   (this 'play))))

   (define (supports-type? type)
     (or (eq? type card-stackable) (super 'supports-type? type)))
   (define (get-type)
     card-stackable))
 
)