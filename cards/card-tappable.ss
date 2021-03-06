#!r6rs

(library
 (card-tappable)
 (export card-tappable)
 (import (rnrs base (6))
         (magic object)
         (magic cards card-permanent)
         (magic cards card-action))

 (define-dispatch-subclass (card-tappable name color cost game player picture)
   (tapped? tap! untap! supports-type? get-type)
   (card-permanent name color cost game player picture)
   (init (super 'add-to-action-library! act-untap))
   
   (define act-untap (card-action game
                                  "Untap"
                                  (lambda ()
                                    (and (eq? (super 'get-zone) ((player 'get-field) 'get-in-play-zone))
                                         (eq? ((game 'get-phases) 'get-current-type) 'beginning-untap)
                                         (eq? player (game 'get-active-player))
                                         (this 'tapped?)))
                                  (lambda ()
                                    (this 'untap!))))
   
   (define tapped #f)
   
   (define (tapped?)
     tapped)
   (define (tap!)
     (set! tapped #t))
   (define (untap!)
     (set! tapped #f))
   
   (define (supports-type? type)
     (or (eq? type card-tappable) (super 'supports-type? type)))
   (define (get-type)
     card-tappable))

 )