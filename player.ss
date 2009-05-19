#!r6rs


(library
 (player)
 (export player)
 (import (rnrs base (6))
         (rnrs io simple)
         (magic mana)
         (magic fields))
 
 (define (player game field name)
   (define my-field (player-field player))
   (define my-mana (manapool))
;   (define my-view '())
   (define life 20)
   (define gui '())
   (define is-ready #f)
   (define drawn #f)
   (define pland #f)
   
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
   
   (define (set-ready! val)
     (set! is-ready val)
     ((game 'get-phases) 'transition)
     (display "DEBUG: ")
     (display ((game 'get-phases) 'get-current-type)))
   
   (define (ready?)
     is-ready)
   
   (define (draw-card)
     (let ([lib (my-field 'get-library-zone)]
           [hand (my-field 'get-hand-zone)])
       (if (not (or (lib 'empty?)
                    (has-drawn?)))
         (begin
           (set! drawn #t)
           (hand 'add-card! (lib 'pop!))
           (game 'update-all-guis)))))
   
   (define (has-drawn?)
     drawn)
   
   (define (set-flag-played-land!)
     (set! pland #t))
   
   (define (has-played-land?)
     pland)
   
   (define (reset-flags!)
     (set! drawn #f)
     (set! pland #f))
   
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
       ((set-ready!) (apply set-ready! args))
       ((ready?) (apply ready? args))
       ((draw-card) (apply draw-card args))
       ((set-flag-played-land!) (apply set-flag-played-land! args))
       ((has-drawn?) (apply has-drawn? args))
       ((has-played-land?) (apply has-played-land? args))
       ((reset-flags!) (apply reset-flags! args))
       (else (assertion-violation 'player "message not understood" msg))))
   
   (field 'add-player-field! my-field)
;   (set! my-view (player-view field obj-player)) ; not yet implemented
   
   obj-player)
 )

     
 