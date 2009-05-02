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
    draw destroy update-actions supports-type? get-type get-picture get-actions add-action! remove-action! clear-actions! perform-default-action)
   
   (define actions (position-list eq?))
   (define my-zone '())
   
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
   (define (clear-actions!)
     (actions 'clear!))
   (define (perform-default-action)
     #f)
   (define (changed-zone zone)
     (set! my-zone zone)
     (this 'update-actions))
   (define (get-zone)
     my-zone)
   (define (update-actions)
     (this 'clear-actions!)
     (let* ([p-field (player 'get-field)]
            [phases (game 'get-phases)]
            [c-phase-type (phases 'get-current-type)])
       (display my-zone)
       (display c-phase-type)
       (display (eq? player (game 'get-active-player)))
       (cond ((and (eq? my-zone (p-field 'get-library-zone))
                   (eq? c-phase-type 'beginning-draw)
                   (eq? player (game 'get-active-player))) (add-action! draw-action)))))
   
   )
 
 )