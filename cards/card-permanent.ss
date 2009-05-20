#!r6rs

(library
 (card-permanent)
 (export card-permanent)
 (import (rnrs base (6))
         (rnrs io simple)
         (magic object)
         (magic cards card)
         (magic cards card-action))

 ;Class: card-permanent
 (define-dispatch-subclass (card-permanent name color cost game player picture)
   (play destroy turn-begin phase-begin phase-end turn-end can-play? supports-type? get-type changed-zone)
   (card name color cost game player picture)
   (init (super 'add-to-action-library! act-play))
   
   (define act-play (card-action game
                                 "Play"
                                 (lambda ()
                                   (and (eq? (this 'get-zone) ((player 'get-field) 'get-hand-zone))
                                        (eq? player (game 'get-active-player))
                                        (this 'can-play?)))
                                 (lambda ()
                                   ((super 'get-zone) 'delete-card! this)
                                   (((player 'get-field) 'get-in-play-zone) 'add-card! this))))
                                        
   
   (define (play)
     (display "Playing card: ")
     (display (this 'get-name))
     (newline)
     #f)
   (define (destroy)
     #f)
   (define (turn-begin)
     #f)
   (define (phase-begin)
     #f)
   (define (phase-end)
     #f)
   (define (turn-end)
     #f)
   
   (define (supports-type? type)
     (or (eq? type card-permanent) (super 'supports-type? type)))
   (define (get-type)
     card-permanent)
   (define (changed-zone zone)
     (super 'changed-zone zone)
     (cond ((eq? ((player 'get-field) 'get-in-play-zone) zone) (this 'play))
           ((eq? ((player 'get-field) 'get-graveyard-zone) zone) (this 'destroy))))
       
   
   (define (can-play?)
     (display name)
     (display ": ")
     (cost 'print)
     (display ((player 'get-manapool) 'can-afford? cost))
     (newline)
     (and (eq? ((game 'get-phases) 'get-current-type) 'main)
          ((player 'get-manapool) 'can-afford? cost))))
)