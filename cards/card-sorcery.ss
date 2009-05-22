#!r6rs

(library
 (card-sorcery)
 (export card-sorcery)
 (import (rnrs base (6))
         (magic object)
         (magic cards card-stackable)
         (magic cards card-action))

 ;Class: card-sorcery
 (define-dispatch-subclass (card-sorcery name color cost game player picture)
   (can-play? supports-type? get-type)
   (card-stackable name color cost game player picture)
   (init (super 'add-to-action-library! act-cast))
        
   (define act-cast (card-action game
                                 "Cast"
                                 (lambda ()
                                   (this 'can-play?))
                                 (lambda ()
                                   ((super 'get-zone) 'delete-card! this)
                                   (((game 'get-field) 'get-stack-zone) 'push! this))))

   (define (can-play?)
     (and (eq? (super 'get-zone) ((player 'get-field) 'get-hand-zone))
          (eq? ((game 'get-phases) 'get-current-type) 'main)
          (eq? (game 'get-active-player) player)
          ((player 'get-manapool) 'can-afford? cost)))
   
   (define (supports-type? type)
     (or (eq? type card-sorcery) (super 'supports-type? type)))
   (define (get-type)
     card-sorcery))
 
)
