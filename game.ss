#!r6rs

(library
 (game)
 (export game)
 (import (rnrs base (6))
         (rnrs io simple)
         (magic fields)
         (magic double-linked-position-list)
         (magic phase)
         (magic player)
         (magic gui-view)
         )
 
 (define (game names deck)
   (define num-players (length names))
   
   (define (construct)
     (for-each (lambda (name)
                 (players 'add-after! (player obj-game field name)))
               names)
     
     (players 'for-each (lambda (player)
                          (player 'set-gui! (gui-view player obj-game))
                          (deck 'give-to player obj-game)
                          (player 'deal-initial-hand)))
     
     (players 'for-each (lambda (player)
                          ((player 'get-gui) 'update))))
   
   (define (get-field)
     field)
      
   (define (get-players)
     players)
   
   (define (get-num-players)
     num-players)
   
   (define (get-active-player)
     (players 'value (players 'first-position)))
   
   (define (next-turn!)
     (let* ([pos (players 'first-position)]
            [p (players 'value pos)])
       (players 'delete! pos)
       (players 'add-after! p)))
   
   (define (get-phases)
     phases)
   
   (define (to-all-players msg . args)
     (players 'for-each (lambda (player)
                          (apply player msg args))))
   
   (define (update-all-guis)
     (players 'for-each (lambda (player)
                          ((player 'get-gui) 'update))))
   
   (define (obj-game msg . args)
     (case msg
       ((get-field) (apply get-field args))
       ((get-players) (apply get-players args))
       ((get-num-players) (apply get-num-players args))
       ((get-active-player) (apply get-active-player args))
       ((next-turn!) (apply next-turn! args))
       ((get-phases) (apply get-phases args))
       ((update-all-guis) (apply update-all-guis args))
       ((to-all-players) (apply to-all-players args))
       (else (assertion-violation 'game "message not understood" msg))))
   (define field (main-field))
   (define players (position-list eq?))
   (define phases (phases-fsm obj-game))
   
   (construct)
   
   obj-game)
 
)
 
 
   
