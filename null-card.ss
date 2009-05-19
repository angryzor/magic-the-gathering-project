#!r6rs

(library 
 (null-card)
 (export null-card no-card)
 (import (rnrs base (6))
         (magic cards)
         (magic object))
 
 (define (null-card game player)
   (let ([c (card "MISSINGNO"
                  'white
                  '()
                  game
                  player
                  "resources/bitmaps/cards/card-back.jpg")])
     (c 'add-to-action-library! (card-action game "NULLACTION" (lambda () #t) (lambda () 'ok)))
     c))
  (define-dispatch-subclass (no-card game player)
    (supports-type? get-type)
    (card "EMTPY"
         'white
         '()
         game
         player
         "resources/bitmaps/surface/cardslot.png")
    (define (supports-type? type)
      (or (eq? type no-card) (super 'supports-type? type)))
    (define (get-type)
      no-card))
  
  )
                         
                         