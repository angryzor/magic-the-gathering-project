#!r6rs

(library
 (card-land)
 (export card-land)
 (import (rnrs base (6))
         (rnrs io simple)
         (magic object)
         (magic mana)
         (magic cards card-tappable)
         (magic cards card-action)
         (magic cards card-virtual-perm-via-stack))
         
 (define-dispatch-subclass (card-virtual-perm-via-stack-land perm)
   (play)
   (card-virtual-perm-via-stack perm)
   (define (play)   ; We don't need this to linger on the stack... It'll only slow us down
     (this 'cast)
     ((this 'get-zone) 'move-card! this (((perm 'get-player) 'get-field) 'get-graveyard-zone))))

 ;Class: card-land
 (define-dispatch-subclass (card-land name color game player picture)
   (perform-default-action supports-type? get-type create-card-virtual-perm-via-stack play can-play?)
   (card-tappable name color (mana-list) game player picture)
   (init (super 'add-to-action-library! tap-for-mana))
   ; Actions:
   ; This card can be tapped for mana. This is the default action.
   (define tap-for-mana (card-action game
                                     "Tap: +1 mana"
                                     (lambda ()
                                       (and (eq? (super 'get-zone) ((player 'get-field) 'get-in-play-zone))
                                            (eq? ((game 'get-phases) 'get-current-type) 'main)
                                            (eq? player (game 'get-active-player))
                                            (not (this 'tapped?))))
                                     (lambda ()
                                       (super 'tap!)
                                       ((player 'get-manapool) 'add! (mana-list (mana-unit color))))))
   
   ; Operations:
   (define (perform-default-action)
     (if ((super 'get-actions) 'find tap-for-mana)
         (tap-for-mana 'perform)))
   
   (define (play)
     (super 'play)
     (player 'set-flag-played-land!))
   (define (supports-type? type)
     (or (eq? type card-land) (super 'supports-type? type)))
   (define (get-type)
     card-land)
   (define (create-card-virtual-perm-via-stack)
     (card-virtual-perm-via-stack-land this))
   (define (can-play?)
     (and (not (player 'has-played-land?))
          (super 'can-play?))))

 )