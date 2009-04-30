#!r6rs

(library
 (card-tappable)
 (export card-tappable)
 (import (rnrs base (6))
         (magic object)
         (magic cards card-permanent))

 (define-dispatch-subclass (card-tappable name color cost game player picture)
   (tapped? tap! untap! supports-type? get-type)
   (card-permanent name color cost game player picture)
   
   (define tapped #f)
   
   (define (tapped?)
     tapped)
   (define (tap!)
     (set! tapped #t)
     (game 'update-all-guis))
   (define (untap!)
     (set! tapped #f)
     (game 'update-all-guis))
   
   (define (supports-type? type)
     (or (eq? type card-tappable) (super 'supports-type? type)))
   (define (get-type)
     card-tappable))

 )