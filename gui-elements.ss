#lang scheme/gui

(provide gui-library%
         gui-graveyard%
         gui-in-play%
         gui-hand%
         gui-player-package%)
(require (lib "gui-card-control.ss" "magic"))
(require (lib "card-dimensions.ss" "magic"))
(require (lib "null-card.ss" "magic"))
 
 (define gui-library%
   (class gui-card-control%
     (init-field game)
     (init-field player)
     
     (inherit-field card)
     
     (inherit refresh)
     
     (define/public (update)
       (set! card (let ([lib ((player 'get-field) 'get-library-zone)])
                    (if (lib 'empty?)
                        (no-card game player)
                        (lib 'top))))
       (refresh))
     
     (super-new)))
 
 (define gui-graveyard%
   (class gui-card-control%
     (init-field game)
     (init-field player)
     
     (inherit-field card)
     
     (inherit refresh)
     
     (define/public (update)
       (set! card (let ([grv ((player 'get-field) 'get-graveyard-zone)])
                    (if (grv 'empty?)
                        (no-card game player)
                        (grv 'top))))
       (refresh))
     
     (super-new)))
 
 (define gui-hand%
   (class horizontal-pane%
     (init-field player)
     
     (inherit change-children)
     
     (define/public (update)
       (change-children (lambda (l)
                          (let ([hand ((player 'get-field) 'get-hand-zone)]
                                [newlist '()])
                            (hand 'for-each (lambda (card)
                                              (set! newlist (cons (new gui-card-with-actions-control% 
                                                                       [parent this]
                                                                       [card card]) newlist))))
                            newlist))))
     (super-new)))
 
 (define gui-in-play%
   (class horizontal-pane%
     (init-field player)
     
     (inherit change-children)
     
     (define/public (update)
       (change-children (lambda (l)
                          (let ([hand ((player 'get-field) 'get-in-play-zone)]
                                [newlist '()])
                            (hand 'for-each (lambda (card)
                                              (set! newlist (cons (new gui-card-with-actions-control% 
                                                                       [parent this]
                                                                       [card card]) newlist))))
                            newlist))))
     (super-new)))
 
 (define gui-player-package%
   (class vertical-pane%
     (init-field game)
     (init-field player)
     (super-new)
     
     (define ip (new gui-in-play% [parent this]
                                  [player player]
                                  [min-height CARD-HEIGHT]))
     
     (define handlevel (new horizontal-pane% [parent this]
                                            [min-height CARD-HEIGHT]))
     (define hand (new gui-hand% [parent handlevel]
                                 [player player]
                                 [stretchable-width #t]))
     (define lib (new gui-library% [parent handlevel]
                                   [card (null-card game player)]
                                   [game game]
                                   [player player]))
     (define grave (new gui-graveyard% [parent handlevel]
                                       [card (null-card game player)]
                                       [game game]
                                       [player player]))
     
     (define/public (update)
       (send ip update)
       (send hand update)
       (send lib update)
       (send grave update))))