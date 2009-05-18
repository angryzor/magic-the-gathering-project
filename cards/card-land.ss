#!r6rs

(library
 (card-land)
 (export card-land)
 (import (rnrs base (6))
         (magic object)
         (magic mana)
         (magic cards card-tappable)
         (magic cards card-action))

 ;Class: card-land
 (define-dispatch-subclass (card-land name color game player picture)
   (perform-default-action supports-type? get-type)
   (card-tappable name color (mana-list) game player picture)
   (init (super 'add-to-action-library! tap-for-mana))
   ; Actions:
   ; This card can be tapped for mana. This is the default action.
   (define tap-for-mana (card-action game
                                     "Tap: +1 mana"
                                     (lambda ()
                                       (and (eq? (super 'get-zone) ((player 'get-field) 'get-in-play-zone))
                                         (eq? (phases 'get-current-type) 'beginning-untap)
                                         (eq? player (game 'get-active-player))
                                         (not (this 'tapped?))))
                                     (lambda ()
                                       (super 'tap!)
                                       ((player 'get-manapool) 'add! (mana-list (mana-unit color))))))
   
   ; Operations:
   (define (perform-default-action)
     (tap-for-mana 'perform))
   
   (define (supports-type? type)
     (or (eq? type card-land) (super 'supports-type? type)))
   (define (get-type)
     card-land))

 )