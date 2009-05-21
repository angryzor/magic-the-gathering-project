#!r6rs

(library
 (card-virtual)
 (export card-virtual)
 (import (rnrs base (6))
         (magic object)
         (magic cards card-stackable))
 
 (define-dispatch-subclass (card-virtual name color cost game player picture)
   (supports-type? get-type destroy)
   (card-stackable name color cost game player picture)
   
   (define (supports-type? type)
     (or (eq? type card-virtual) (super 'supports-type? type)))
   (define (get-type)
     card-virtual)
   (define (destroy)
     ((this 'get-zone) 'delete-card! this))) ; virtual cards shouldn't linger in the graveyard
 )

