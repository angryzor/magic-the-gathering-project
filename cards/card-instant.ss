#!r6rs

(library
 (card-instant)
 (export card-instant)
 (import (rnrs base (6))
         (magic object)
         (magic cards card-stackable)
         (magic cards card-action))

 ;Class: card-instant
 (define-dispatch-subclass (card-instant name color cost game player picture)
   (can-play? supports-type? get-type)
   (card-stackable name color cost game player picture)
   (init (super 'add-to-action-library! act-cast))
   
   (define act-cast (card-action game
                                 "Cast"
                                 (lambda ()
                                   (and (eq? (super 'get-zone) ((player 'get-field) 'get-hand-zone))
                                        (eq? player (game 'get-active-player))
                                        (eq? player (game 'get-active-player))))
                                 (lambda ()
                                   (if ((player 'get-manapool) 'can-afford? cost)
                                       (begin
                                         ((super 'get-zone) 'delete-card! this)
                                         (((game 'get-field) 'get-stack-zone) 'push! this))))))
   
   (define (can-play?)
     #t)
   (define (supports-type? type)
     (or (eq? type card-instant) (super 'supports-type? type)))
   (define (get-type)
     card-instant))
 
)