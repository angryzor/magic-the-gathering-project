#!r6rs

(library
 (card-permanent)
 (export card-permanent)
 (import (rnrs base (6))
         (rnrs io simple)
         (magic object)
         (magic cards card)
         (magic cards card-action)
         (magic cards card-virtual-perm-via-stack))

 ;Class: card-permanent
 (define-dispatch-subclass (card-permanent name color cost game player picture)
   (play destroy turn-begin phase-begin phase-end turn-end can-play? supports-type? get-type changed-zone)
   (card name color cost game player picture)
   (init (super 'add-to-action-library! act-play))
   
   (define already-going-to-play #f)
   
   (define act-play (card-action game
                                 "Play"
                                 (lambda ()
                                   (and (eq? (this 'get-zone) ((player 'get-field) 'get-hand-zone))
                                        (eq? player (game 'get-active-player))
                                        (this 'can-play?)
                                        (not already-going-to-play)))
                                 (lambda ()
                                   (((game 'get-field) 'get-stack-zone) 'push! (card-virtual-perm-via-stack this))
                                   (set! already-going-to-play #t))))
                                        
   
   (define (play)
     (display "Playing card: ")
     (display (this 'get-name))
     (newline)
     (set! already-going-to-play #f))
   (define (destroy)
     (set! already-going-to-play #f))
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
     (cond ((eq? ((player 'get-field) 'get-in-play-zone) zone) (this 'play))))
       
   
   (define (can-play?)
     (display name)
     (display " cost: ")
     (cost 'print)
     (display "; can-afford? ")
     (display ((player 'get-manapool) 'can-afford? cost))
     (newline)
     (and (eq? ((game 'get-phases) 'get-current-type) 'main)
          ((player 'get-manapool) 'can-afford? cost))))
)