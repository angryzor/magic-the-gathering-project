#!r6rs

(library
 (card)
 (export card
         card-action)
 (import (rnrs base (6))
         (rnrs io simple)
         (magic double-linked-position-list)
         (magic object)
         (magic cards card-action))

 ; Code
 ; Class: card 
 (define-dispatch-class (card name color cost game player picture)
   (get-name get-color get-cost get-game get-player set-cost! can-play? changed-zone
    draw destroy update-actions supports-type? get-type get-picture get-actions add-action! remove-action! add-to-action-library! clear-actions! perform-default-action get-zone)
   (init (add-to-action-library! draw-action))
   
   (define actions (position-list eq?))
   (define action-library (position-list eq?))
   (define my-zone '())
   
   (define draw-action (card-action game
                                    "Draw" 
                                    (lambda ()
                                      (and (eq? my-zone ((player 'get-field) 'get-library-zone))
                                           (eq? ((game 'get-phases) 'get-current-type) 'beginning-draw)
                                           (eq? player (game 'get-active-player))))
                                    (lambda ()
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
   (define (add-to-action-library! action)
     (action-library 'add-after! action))
   (define (clear-actions!)
     (actions 'clear!))
   (define (perform-default-action)
     #f)
   (define (changed-zone zone)
     (set! my-zone zone)
     (this 'update-actions)
     (if (eq? ((player 'get-field) 'get-graveyard-zone) zone) 
         (this 'destroy)))
   (define (get-zone)
     my-zone)
   (define (update-actions)
     (this 'clear-actions!)
     (action-library 'for-each (lambda (action)
                                 (if (action 'is-valid?)
                                     (add-action! action)))))
   
   )
 
 )