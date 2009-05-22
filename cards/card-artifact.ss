#!r6rs

(library
 (card-artifact)
 (export card-artifact)
 (import (rnrs base (6))
         (magic cards card-tappable)
         (magic object))

 ; Card-artifact
 (define-dispatch-subclass (card-artifact name color cost game player picture)
   (supports-type? get-type)
   (card-tappable name color cost game player picture)
   
   (define (supports-type? type)
     (or (eq? type card-artifact) (super 'supports-type? type)))
   (define (get-type)
     card-artifact))
 

)