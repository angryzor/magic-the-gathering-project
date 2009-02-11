#!r6rs

(library 
 (cards)
 (export card-sorcery
         card-instant
         card-enchantment
         card-action
         card-land
         card-creature
         card-artifact)
 (import (rnrs)
         (rnrs base (6))
         (magic double-linked-position-list))
 
 (define mana-unit 3)
 (define (game) 'ok)
 ; Code
 ; Class: card 
 (define (card name color cost player)
   (define (get-name)
     name)
   (define (get-color)
     color)
   (define (get-cost)
     cost)
   (define (get-player)
     player)
   (define (set-cost! new-cost)
     (set! cost new-cost))
   (define (can-play?)
     #f) ; you can never play this card.
   (define (draw)
     #f)
   (define (supports-type? type)
     (eq? type card))
   (define (get-type)
     card)
   
   (define (obj-card msg . args)
     (case msg
       ((get-name) (apply get-name args))
       ((get-color) (apply get-color args))
       ((get-cost) (apply get-cost args))
       ((get-player) (apply get-player args))
       ((set-cost!) (apply set-cost! args))
       ((can-play?) (apply can-play? args))
       ((draw) (apply draw args))
       ((supports-type?) (apply supports-type? args))
       ((get-type) (apply get-type args))
       (else (assertion-violation 'obj-card "message not understood" msg))))
   obj-card)
 
 ;Class: card-permanent
 (define (card-permanent name color cost player)
   (define super (card name color cost player))
   
   (define (play)
     #f)
   (define (destroy)
     #f)
   (define (turn-begin)
     #f)
   (define (phase-begin)
     #f)
   (define (phase-end)
     #f)
   (define (turn-end)
     #f)
   
   (define (supports-type? type)
     (or (eq? type card-permanent) (super 'supports-type? type)))
   (define (get-type)
     card-permanent)
   
   (define (can-play?)
     (eq? ((game 'get-phases) 'get-current-type) 'main-phase)
     (eq? (game 'get-active-player) player))
   
   (define (obj-card-permanent msg . args)
     (case msg
       ((play) (apply play args))
       ((destroy) (apply destroy args))
       ((turn-begin) (apply turn-begin args))
       ((phase-begin) (apply phase-begin args))
       ((phase-end) (apply phase-end args))
       ((turn-end) (apply turn-end args))
       ((can-play?) (apply can-play? args))
       ((supports-type?) (apply supports-type? args))
       ((get-type) (apply get-type args))
       (else (apply super msg args))))
   obj-card-permanent)
 
 ;Class: card-stackable
 (define (card-stackable name color cost player)
   (define super (card name color cost player))
   
   (define (play)
     #f)
   (define (cast)
     #f)
   
   (define (supports-type? type)
     (or (eq? type card-stackable) (super 'supports-type? type)))
   (define (get-type)
     card-stackable)
   
   (define (obj-card-stackable msg . args)
     (case msg
       ((play) (apply play args))
       ((cast) (apply cast args))
       ((supports-type?) (apply supports-type? args))
       ((get-type) (apply get-type args))
       (else (apply super msg args))))
   obj-card-stackable)
 
 ;Class: card-sorcery
 (define (card-sorcery name color cost player)
   (define super (card-stackable name color cost player))
   
   (define (can-play?)
     (and (eq? ((game 'get-phases) 'get-current-type) 'main-phase)
          (eq? (game 'get-active-player) player)))
   
   (define (supports-type? type)
     (or (eq? type card-sorcery) (super 'supports-type? type)))
   (define (get-type)
     card-sorcery)
   
   (define (obj-card-sorcery msg . args)
     (case msg
       ((can-play?) (apply can-play? args))
       ((supports-type?) (apply supports-type? args))
       ((get-type) (apply get-type args))
       (else (apply super msg args))))
   obj-card-sorcery)
 
 ;Class: card-instant
 (define (card-instant name color cost player)
   (define super (card-stackable name color cost player))
   
   (define (can-play?)
     #t)
   
   (define (supports-type? type)
     (or (eq? type card-instant) (super 'supports-type? type)))
   (define (get-type)
     card-instant)
   
   (define (cast)
     (
   
   (define (obj-card-instant msg . args)
     (case msg
       ((can-play?) (apply can-play? args))
       ((supports-type?) (apply supports-type? args))
       ((get-type) (apply get-type args))
       (else (apply super msg args))))
   obj-card-instant)
 
 ;Class: card-enchantment
 (define (card-enchantment name color cost player)
   (define super (card-permanent name color cost player))
   
   (define (get-linked-creature)
     #f)
   
   (define (supports-type? type)
     (or (eq? type card-enchantment) (super 'supports-type? type)))
   (define (get-type)
     card-enchantment)
   
   (define (obj-card-enchantment msg . args)
     (case msg
       ((supports-type?) (apply supports-type? args))
       ((get-type) (apply get-type args))
       (else (apply super msg args))))
   obj-card-enchantment)
 
 (define (card-with-actions name color cost player)
   (define super (card-permanent name color cost player))
   (define actions (position-list eq?))
   (define tapped #f)
   
   (define (get-actions)
     actions)
   (define (add-action! action)
     (actions 'add-after! action))
   (define (remove-action! action)
     (actions 'delete! action))
   (define (perform-default-action)
     #f)
   (define (tapped?)
     tapped)
   (define (tap!)
     (set! tapped #t))
   (define (untap!)
     (set! tapped #f))
   
   (define (supports-type? type)
     (or (eq? type card-with-actions) (super 'supports-type? type)))
   (define (get-type)
     card-with-actions)
   
   (define (obj-card-with-actions msg . args)
     (case msg
       ((get-actions) (apply get-actions args))
       ((add-action!) (apply add-action! args))
       ((remove-action!) (apply remove-action! args))
       ((perform-default-action) (apply perform-default-action args))
       ((tapped?) (apply tapped? args))
       ((tap!) (apply tap! args))
       ((untap!) (apply untap! args))
       ((supports-type?) (apply supports-type? args))
       ((get-type) (apply get-type args))
       (else (apply super msg args))))
   obj-card-with-actions)
 
 ;Class: card-action
 (define (card-action description validity-check action)
   (define (get-description)
     description)
   (define (is-valid?)
     (validity-check))
   (define (perform)
     (if (validity-check)
         (action)))
   
   (define (obj-card-action msg . args)
     (case msg
       ((get-description) (apply get-description args))
       ((is-valid?) (apply is-valid? args))
       ((perform) (apply perform args))
       (else (assertion-violation 'obj-card-action "message not understood" msg))))
   obj-card-action)
 
 ;Class: card-land
 (define (card-land name color cost player)
   (define super (card-with-actions name color cost player))
   
   ; Actions:
   ; This card can be tapped for mana. This is the default action.
   (define tap-for-mana (card-action "Tap: +1 mana"
                                     (lambda ()
                                       (not (obj-card-land 'tapped?)))
                                     (lambda ()
                                       (super 'tap!)
                                       ((player 'get-manapool) 'add! (mana-unit color)))))
   
   ; Operations:
   (define (perform-default-action)
     (tap-for-mana 'perform))
   
   (define (supports-type? type)
     (or (eq? type card-land) (super 'supports-type? type)))
   (define (get-type)
     card-land)
   
   (define (obj-card-land msg . args)
     (case msg
       ((perform-default-action) (apply perform-default-action args))
       ((supports-type?) (apply supports-type? args))
       ((get-type) (apply get-type args))
       (else (apply super msg args))))
   
   ; Adding actions
   (super 'add-action! tap-for-mana)
   
   obj-card-land)
 
 (define (card-virtual-blocked-combat-damage for-creature to-creature)
   (define super (card-stackable (for-creature 'get-name)
                                 (for-creature 'get-color)
                                 (mana-list)
                                 (for-creature 'get-player)))
   
   (define (cast)
     (to-creature 'set-health! (- (to-creature 'get-health) (for-creature 'get-power))))
   
   (define (obj-card-virtual-blocked-combat-damage msg . args)
     (case msg
       ((cast) (apply cast args))
       (else (apply super msg args))))
   obj-card-virtual-blocked-combat-damage)
 
 (define (card-virtual-direct-combat-damage for-creature to-player)
   (define super (card-stackable (for-creature 'get-name)
                                 (for-creature 'get-color)
                                 (mana-list)
                                 (for-creature 'get-player)))
   
   (define (cast)
     (player 'set-life-counter! (- (player 'get-life-counter) power)))
   
   (define (obj-card-virtual-direct-combat-damage msg . args)
     (case msg
       ((cast) (apply cast args))
       (else (apply super msg args))))
   obj-card-virtual-direct-combat-damage)
 
 
 ;Class: card-creature
 (define (card-creature name color cost player power toughness)
   (define super (card-with-actions name color cost player))
   (define health toughness)
   (define special-attribs (position-list eq?))
   
   (define (damage-player player)
     (((game 'get-field) 'get-stack-zone) 'push! (card-virtual-direct-combat-damage)))
   
   
   (define (can-block? attacker)
     #f)
   (define (block attacker)
     (attacker 'set-health! (- (attacker 'get-health) (get-power)))
     (set-health! (- (get-health) (attacker 'get-power)))
     (if (<= (attacker 'get-health) 0)
         ((player 'get-player-field) 'search-and-destroy! attacker))
     (if (<= (get-health) 0)
         (((attacker 'get-player) 'get-player-field) 'search-and-destroy! obj-card-creature)))
   
   
   (define (turn-end)
     (set! health toughness)
     (super 'turn-end))
   
   
   (define (get-power)
     power)
   (define (set-power! val)
     (set! power val))
   (define (get-toughness)
     toughness)
   (define (set-toughness! val)
     (set! toughness val))
   (define (get-health)
     health)
   (define (set-health! val)
     (set! health val))
   
   
   (define (get-special-attributes)
     special-attribs)
   (define (has-special-attribute? attrib)
     (special-attribs 'find attrib))
   (define (add-special-attribute! attrib)
     (if (not (special-attribs 'find attrib))
         (special-attribs 'add-after! attrib)))
   (define (remove-special-attribute! attrib)
     (let ((pos (special-attribs 'find attrib)))
       (if pos
           (special-attribs 'delete! attrib))))
   
   (define (supports-type? type)
     (or (eq? type card-creature) (super 'supports-type? type)))
   (define (get-type)
     card-creature)
   
   (define (obj-card-creature msg . args)
     (case msg
       ((damage-player) (apply damage-player args))
       ((can-block?) (apply can-block? args))
       ((block attacker) (apply block args))
       ((turn-end) (apply turn-end args))
       ((get-power) (apply get-power args))
       ((set-power!) (apply set-power! args))
       ((get-toughness) (apply get-toughness args))
       ((set-toughness!) (apply set-toughness! args))
       ((get-health) (apply get-health args))
       ((set-health!) (apply set-health! args))
       ((get-special-attributes) (apply get-special-attributes args))
       ((has-special-attribute?) (apply has-special-attribute? args))
       ((add-special-attribute!) (apply add-special-attribute! args))
       ((remove-special-attribute!) (apply remove-special-attribute! args))
       ((supports-type?) (apply supports-type? args))
       ((get-type) (apply get-type args))
       (else (apply super msg args))))
   obj-card-creature)
 
 (define (card-artifact name color cost player)
   (define super (card-permanent name color cost player))
   
   (define (supports-type? type)
     (or (eq? type card-artifact) (super 'supports-type? type)))
   (define (get-type)
     card-artifact)
   
   (define (obj-card-artifact msg . args)
     (case msg
       ((supports-type?) (apply supports-type? args))
       ((get-type) (apply get-type args))
       (else (apply super msg args))))
   obj-card-artifact)
 
 )
