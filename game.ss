#!r6rs

(library
 (game)
 (export game)
 (import (rnrs base (6))
         (magic fields)
         (magic double-linked-position-list)
         (magic phase)
         (magic player))
 
 (define (game num-players)
   
   (define (construct)
     (define (iter n)
       (players 'add-after! (player field))
       (if (> n 0)
           (iter (- n 1))))
     (iter num-players))
   
   (define (get-field)
     field)
   
   (define (get-players)
     players)
   
   (define (get-active-player)
     (players 'value (players 'first-position)))
   
   (define (next-turn)
     (let* ([pos (players 'first-position)]
            [p (players 'value pos)])
       (players 'delete! pos)
       (players 'add-after! p)))
   
   (define (obj-game msg . args)
     (case msg
       ((get-field) (apply get-field args))
       ((get-players) (apply get-players args))
       ((get-active-player) (apply get-active-player args))
       (else (assertion-violation 'game "message not understood" msg))))
   (define field (main-field))
   (define players (position-list eq?))
   (define phases (phases-fsm obj-game))
   
   (construct)
   
   obj-game))
 
 
   
   