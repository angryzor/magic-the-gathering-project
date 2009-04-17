#!r6rs

(library
 (card-sorcery)
 (export card-sorcery)
 (import (rnrs base (6))
         (magic object)
         (magic cards card-stackable))

 ;Class: card-sorcery
 (define (card-sorcery name color cost game player picture . this-a)
   
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
   
   (define this (extract-this obj-card-sorcery this-a))
   (define super (card-stackable name color cost game player picture this))
   
   obj-card-sorcery)
 
)
