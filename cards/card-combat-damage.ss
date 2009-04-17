#!r6rs

(library
 (card-combat-damage)
 (export card-virtual-blocked-combat-damage
         card-virtual-direct-combat-damage)
 (import (rnrs base (6))
         (magic object)
         (magic cards card-stackable)
         (magic mana))

 (define (card-virtual-blocked-combat-damage for-creature to-creature . this-a)
   (define (cast)
     (to-creature 'set-health! (- (to-creature 'get-health) (for-creature 'get-power))))
   
   (define (obj-card-virtual-blocked-combat-damage msg . args)
     (case msg
       ((cast) (apply cast args))
       (else (apply super msg args))))
   
   (define this (extract-this obj-card-virtual-blocked-combat-damage this-a))
   (define super (card-stackable (for-creature 'get-name)
                                 (for-creature 'get-color)
                                 (mana-list)
                                 (for-creature 'get-game)
                                 (for-creature 'get-player)
                                 (for-creature 'get-picture)
                                 this))
   
   obj-card-virtual-blocked-combat-damage)
 
 (define (card-virtual-direct-combat-damage for-creature to-player . this-a)
   (define (cast)
     (to-player 'set-life-counter! (- (to-player 'get-life-counter) (for-creature 'get-power))))
   
   (define (obj-card-virtual-direct-combat-damage msg . args)
     (case msg
       ((cast) (apply cast args))
       (else (apply super msg args))))
   
   (define this (extract-this obj-card-virtual-direct-combat-damage this-a))
   (define super (card-stackable (for-creature 'get-name)
                                 (for-creature 'get-color)
                                 (mana-list)
                                 (for-creature 'get-game)
                                 (for-creature 'get-player)
                                 (for-creature 'get-picture)
                                 this))
   
   obj-card-virtual-direct-combat-damage)
)