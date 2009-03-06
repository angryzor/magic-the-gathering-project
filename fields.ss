#!r6rs

(library
 (fields)
 (export player-field
         main-field)
 (import (rnrs base (6))
         (magic double-linked-position-list)
         (magic zones))
 
 (define (player-field player)
   (define in-play (zone-in-play))
   (define hand (zone-hand))
   (define library (zone-library))
   (define graveyard (zone-graveyard))
   
   (define (get-in-play-zone)
     in-play)
   
   (define (get-hand-zone)
     hand)
   
   (define (get-library-zone)
     library)
   
   (define (get-graveyard-zone)
     graveyard)
   
   (define (obj-player-field msg . args)
     (case msg
       ((get-in-play-zone) (apply get-in-play-zone args))
       ((get-hand-zone) (apply get-hand-zone args))
       ((get-library-zone) (apply get-library-zone args))
       ((get-graveyard-zone) (apply get-graveyard-zone args))
       (else (assertion-violation 'player-field "message not understood" msg))))
   obj-player-field)
 
 (define (main-field)
   (define pfields (position-list eq?))
   (define stack (zone-stack))
   
   (define (add-player-field! field)
     (pfields 'add-after! field))
   
   (define (get-player-fields)
     pfields)
   
   (define (get-stack-zone)
     stack)
   
   (define (obj-main-field msg . args)
     (case msg
       ((add-player-field!) (apply add-player-field! args))
       ((get-player-fields) (apply get-player-fields args))
       ((get-stack-zone) (apply get-stack-zone args))
       (else (assertion-violation 'main-field "message not understood" msg))))
   obj-main-field)
 
 )
