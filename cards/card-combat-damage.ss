#!r6rs

(library
 (card-combat-damage)
 (export card-virtual-blocked-combat-damage
         card-virtual-direct-combat-damage)
 (import (rnrs base (6))
         (magic object)
         (magic cards card-virtual)
         (magic mana))

 (define-dispatch-subclass (card-virtual-blocked-combat-damage for-creature to-creature)
   (cast supports-type? get-type)
   (card-virtual (string-append (for-creature 'get-name) " - Combat damage to " (to-creature 'get-name))
                   (for-creature 'get-color)
                   (mana-list)
                   (for-creature 'get-game)
                   (for-creature 'get-player)
                   (for-creature 'get-picture))
   
   (define (supports-type? type)
     (or (eq? type card-virtual-blocked-combat-damage) (super 'supports-type? type)))
   (define (get-type)
     card-virtual-blocked-combat-damage)
   
   (define (cast)
     (to-creature 'set-health! (- (to-creature 'get-health) (for-creature 'get-power)))
     (for-creature 'set-health! (- (for-creature 'get-health) (to-creature 'get-power)))))
 
 (define-dispatch-subclass (card-virtual-direct-combat-damage for-creature to-player)
   (cast supports-type? get-type)
   (card-virtual (string-append (for-creature 'get-name) " - Combat damage to " (to-player 'get-name))
                   (for-creature 'get-color)
                   (mana-list)
                   (for-creature 'get-game)
                   (for-creature 'get-player)
                   (for-creature 'get-picture))
   
   (define (supports-type? type)
     (or (eq? type card-virtual-direct-combat-damage) (super 'supports-type? type)))
   (define (get-type)
     card-virtual-direct-combat-damage)
   
   (define (cast)
     (to-player 'set-life-counter! (- (to-player 'get-life-counter) (for-creature 'get-power)))))
)