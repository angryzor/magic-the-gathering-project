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
   (init (super 'add-to-action-library act-tap)
         (super 'add-to-action-library act-untap))
   
   (define act-tap (card-action "Tap"
                                (lambda ()
                                  (and (eq? (super 'get-zone) ((player 'get-field) 'get-in-play-zone))
                                       (eq? (phases 'get-current-type) 'main)
                                       (eq? player (game 'get-active-player))
                                       (not (this 'tapped?))))
                                (lambda ()
                                  (this 'tap!))))
   (define act-untap (card-action "Untap"
                                  (lambda ()
                                    (and (eq? (super 'get-zone) ((player 'get-field) 'get-in-play-zone))
                                         (eq? (phases 'get-current-type) 'main)
                                         (eq? player (game 'get-active-player))
                                         (this 'tapped?)))
                                  (lambda ()
                                    (this 'untap!))))
   
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