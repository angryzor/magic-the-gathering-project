#!r6rs

(library
 (card-stackable)
 (export card-stackable)
 (import (rnrs base (6))
         (magic object)
         (magic cards card))

 ;Class: card-stackable
 (define-dispatch-subclass (card-stackable name color cost game player picture)
   (play cast supports-type? get-type changed-zone)
   (card name color cost game player picture)
   
   (define (play)
     ((player 'get-manapool) 'delete! cost))
   (define (cast)
     #f)
   
   (define (changed-zone zone)
     (super 'changed-zone zone)
     (if (eq? ((game 'get-field) 'get-stack-zone) zone)
         (this 'play)))

   (define (supports-type? type)
     (or (eq? type card-stackable) (super 'supports-type? type)))
   (define (get-type)
     card-stackable))
 
)