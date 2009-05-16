#!r6rs

(library
 (card-instant)
 (export card-instant)
 (import (rnrs base (6))
         (magic object)
         (magic cards card-stackable))

 ;Class: card-instant
 (define-dispatch-subclass (card-instant name color cost game player picture)
   (can-play? supports-type? get-type)
   (card-stackable name color cost game player picture)
   
   
   (define (can-play?)
     #t)
   (define (supports-type? type)
     (or (eq? type card-instant) (super 'supports-type? type)))
   (define (get-type)
     card-instant))
 
)