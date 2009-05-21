#!r6rs

(library
 (fields)
 (export player-field
         main-field)
 (import (rnrs base (6))
         (magic object)
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
   
   (define (get-player)
     player)
   
   (define (obj-player-field msg . args)
     (case msg
       ((get-in-play-zone) (apply get-in-play-zone args))
       ((get-hand-zone) (apply get-hand-zone args))
       ((get-library-zone) (apply get-library-zone args))
       ((get-graveyard-zone) (apply get-graveyard-zone args))
       ((get-player) (apply get-player args))
       (else (assertion-violation 'player-field "message not understood" msg))))
   obj-player-field)
 
 (define-dispatch-class (main-field)
   (add-player-field! get-player-fields get-stack-zone to-all for-all)
   
   (define pfields (position-list eq?))
   (define stack (zone-stack))
   
   (define (add-player-field! field)
     (pfields 'add-after! field))
   
   (define (get-player-fields)
     pfields)
   
   (define (get-stack-zone)
     stack)
   
   (define (to-all msg . args)
     (for-all (lambda (card)
                (apply card msg args))))
   
   (define (for-all proc)
     (define (to-all-in-zone zone)
       (zone 'for-each (lambda (card)
                         (proc card))))
     (let ([pfields (this 'get-player-fields)])
       (pfields 'for-each (lambda (pfield)
                            (to-all-in-zone (pfield 'get-in-play-zone))
                            (to-all-in-zone (pfield 'get-hand-zone))
                            (to-all-in-zone (pfield 'get-library-zone))
                            (to-all-in-zone (pfield 'get-graveyard-zone))
                            (to-all-in-zone (pfield 'get-library-zone)))))))
 
 )
