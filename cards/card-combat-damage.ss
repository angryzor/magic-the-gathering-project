#!r6rs

(library
 (card-combat-damage)
 (export card-virtual-blocked-combat-damage
         card-virtual-direct-combat-damage)
 (import (rnrs base (6))
         (magic object)
         (magic cards card-stackable)
         (magic mana))

 (define-dispatch-subclass (card-virtual-blocked-combat-damage for-creature to-creature)
   (cast)
   (card-stackable (for-creature 'get-name)
                                 (for-creature 'get-color)
                                 (mana-list)
                                 (for-creature 'get-game)
                                 (for-creature 'get-player)
                                 (for-creature 'get-picture))
   
   (define (cast)
     (to-creature 'set-health! (- (to-creature 'get-health) (for-creature 'get-power)))))
 
 (define-dispatch-subclass (card-virtual-direct-combat-damage for-creature to-player)
   (cast)
   (card-stackable (for-creature 'get-name)
                                 (for-creature 'get-color)
                                 (mana-list)
                                 (for-creature 'get-game)
                                 (for-creature 'get-player)
                                 (for-creature 'get-picture))
   
   (define (cast)
     (to-player 'set-life-counter! (- (to-player 'get-life-counter) (for-creature 'get-power)))))
)