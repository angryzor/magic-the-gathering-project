#!r6rs

(library
 (game)
 (export game)
 (import (rnrs base (6))
         (magic fields)
         (magic double-linked-position-list)
         (magic phase)
         (magic player)
         (magic gui-view)
         (magic null-card))
 
 (define (game names)
   (define num-players (length names))
   
   (define (construct)
     (for-each (lambda (name)
                 (players 'add-after! (player field name)))
               names)
     
     (players 'for-each (lambda (player)
                          (player 'set-gui! (gui-view player obj-game)))))
   
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
   
   (define (obj-game msg . args)
     (case msg
       ((get-field) (apply get-field args))
       ((get-players) (apply get-players args))
       ((get-num-players) (apply get-num-players args))
       ((get-active-player) (apply get-active-player args))
       ((next-turn!) (apply next-turn! args))
       (else (assertion-violation 'game "message not understood" msg))))
   (define field (main-field))
   (define players (position-list eq?))
   (define phases (phases-fsm obj-game))
   
   (construct)
   
   obj-game)
 
 
(define a (game '("Ruben" "Sander")))
(define b (a 'get-players))
(define c (b 'value (b 'first-position)))
(define d (c 'get-field))
(define e (d 'get-hand-zone))
(e 'add-card! (null-card a c))
((c 'get-gui) 'update)

)
 
 
   
