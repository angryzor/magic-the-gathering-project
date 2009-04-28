#!r6rs

(library
 (card)
 (export card
         card-action)
 (import (rnrs base (6))
         (magic double-linked-position-list)
         (magic object)
         (magic cards card-action))

 ; Code
 ; Class: card 
 (define-dispatch-class (card name color cost game player picture)
   (get-name get-color get-cost get-game get-player set-cost! can-play?
             draw destroy supports-type? get-type get-picture get-actions add-action! remove-action! perform-default-action)
   
   (define actions (position-list eq?))
   
   (define draw-action (card-action "Draw" (lambda ()
                                             (player 'draw-card))))
   
   (define (get-name)
     name)
   (define (get-color)
     color)
   (define (get-cost)
     cost)
   (define (get-game)
     game)
   (define (get-player)
     player)
   (define (set-cost! new-cost)
     (set! cost new-cost))
   (define (can-play?)
     #f) ; you can never play this card.
   (define (draw)
     (remove-action! draw-action))
   (define (destroy)
     #f)
   (define (enter-library)
     (add-action! draw-action))
   (define (supports-type? type)
     (eq? type card))
   (define (get-type)
     card)
   (define (get-picture)
     picture)
   (define (get-actions)
     actions)
   (define (add-action! action)
     (actions 'add-after! action))
   (define (remove-action! action)
    (let ([pos (actions 'find action)])
	  (if pos
       (actions 'delete! action))))
   (define (perform-default-action)
     #f)
   (define (zone-change source dest)
     (let ([pfield (player 'get-field)])
       (case source
         (((pfield 'get-library-zone)) (this 'draw)))
       (case dest
         (((pfield 'get-library-zone)) (this 'enter-library))
         (((pfield 'get-graveyard-zone)) (this 'destroy))))))



 
 )