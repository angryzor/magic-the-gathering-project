#!r6rs

(library
 (card-creature)
 (export card-creature)
 (import (rnrs base (6))
         (magic double-linked-position-list)
         (magic cards card-combat-damage)
         (magic cards card-tappable)
         (magic object)
         (magic cards card-action)
         (magic gui-util))

 ;Class: card-creature
 (define-dispatch-subclass (card-creature name color cost game player power toughness picture attr-lst)
   (deal-damage can-block? turn-end get-power set-power! get-toughness
    set-toughness! get-health set-health! is-blocked! attacks! get-special-attributes 
    has-special-attribute? add-special-attribute! remove-special-attribute! supports-type? get-type)
   (card-tappable name color cost game player picture)
   (init (special-attribs 'from-scheme-list attr-lst)
         (super 'add-to-action-library! (card-action game
                                                     "Attack"
                                                     (lambda ()
                                                       (and (eq? ((game 'get-phases) 'get-current-type) 'combat-declare-attackers)
                                                            (eq? player (game 'get-active-player))))
                                                     (lambda ()
                                                       (gui-player-let (player 'get-gui) "Select a player to attack"
                                                         (player)
                                                         (set! attacksplayer player)
                                                         (attacks!)))))
         (super 'add-to-action-library! (card-action game
                                                     "Block"
                                                     (lambda ()
                                                       (and (eq? ((game 'get-phases) 'get-current-type) 'combat-declare-blockers)
                                                            (not (eq? player (game 'get-active-player)))))
                                                     (lambda ()
                                                       (gui-card-let (player 'get-gui) "Select the card that you wish to block"
                                                         (c1)
                                                         (c1 'is-blocked! this))))))
   
   (define attacksplayer #f)
   (define health toughness)
   (define special-attribs (position-list eq?))
   
   (define blocker #f)
   (define attacks #f)
   
   (define (is-blocked! by)
     (if attacks
         (set! blocker by)
         (assertion-violation 'card-creature.is-blocked! "this creature doesn't even attack!" this by)))
   
   (define (attacks!)
     (set! attacks #t))
   
   (define (deal-damage)
     (if attacks
         (if blocker
             (damage-creature)
             (damage-player player))))
   
   (define (damage-player player)
     (((game 'get-field) 'get-stack-zone) 'push! (card-virtual-direct-combat-damage this player)))
   
   (define (damage-creature)
     (set! health toughness)
     (blocker 'set-health! (blocker 'get-toughness))
     (let ([stack ((game 'get-field) 'get-stack-zone)])
       (stack 'push! (card-virtual-blocked-combat-damage this blocker))
       (stack 'push! (card-virtual-blocked-combat-damage blocker this))))

   (define (can-block? attacker)
     #t) ; special-attribs should be calculated here
   
   (define (turn-end)
     (set! blocker #f)
     (set! attacks #f)
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
           (special-attribs 'delete! pos))))
   
   (define (supports-type? type)
     (or (eq? type card-creature) (super 'supports-type? type)))
   (define (get-type)
     card-creature))
 )

