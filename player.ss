#!r6rs


(library
 (player)
 (export player)
 (import (rnrs base (6))
         (magic mana)
         (magic fields))
 
 (define (player field name)
   (define my-field (player-field player))
   (define my-mana (manapool))
;   (define my-view '())
   (define life 20)
   (define gui '())
   
   (define (get-life-counter)
     life)
   
   (define (set-life-counter! val)
     (set! life val))
   
   (define (check-dead)
     (<= life 0))
   
;   (define (get-view)
 ;    my-view)
   
   (define (get-manapool)
     my-mana)
   
   (define (get-name)
     name)
   
   (define (get-gui)
     gui)
   
   (define (set-gui! a-gui)
     (set! gui a-gui))
   
   (define (get-field)
     my-field)
   
   (define (obj-player msg . args)
     (case msg
       ((get-life-counter) (apply get-life-counter args))
       ((set-life-counter!) (apply set-life-counter! args))
       ((check-dead) (apply check-dead args))
;       ((get-view) (apply get-view args))
       ((get-manapool) (apply get-manapool args))
       ((get-name) (apply get-name args))
       ((get-gui) (apply get-gui args)) 
       ((set-gui!) (apply set-gui! args))
       ((get-field) (apply get-field args))
       (else (assertion-violation 'player "message not understood" msg))))
   
   (field 'add-player-field! my-field)
;   (set! my-view (player-view field obj-player)) ; not yet implemented
   
   obj-player)
 )

     
 