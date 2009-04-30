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
 (define (card-land name color game player picture . this-a)
   ; Actions:
   ; This card can be tapped for mana. This is the default action.
   (define tap-for-mana (card-action "Tap: +1 mana"
                                     (lambda ()
                                       (not (this 'tapped?)))
                                     (lambda ()
                                       (super 'tap!)
                                       ((player 'get-manapool) 'add! (mana-list (mana-unit color))))))
   
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
   
   (define this (extract-this obj-card-land this-a))
   (define super (card-tappable name color (mana-list) game player picture this))
   
   ; Adding actions
   (super 'add-action! tap-for-mana)
   
   obj-card-land)

 )