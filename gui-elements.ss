#lang scheme/gui

(provide gui-library%
         gui-graveyard%
         gui-in-play%
         gui-hand%
         gui-player-package%)
(require (lib "card-dimensions.ss" "magic"))
(require (lib "gui-zone-views.ss" "magic"))
(require (lib "gui-player-info.ss" "magic"))
 
 (define gui-library%
   (class gui-top-down-stack-zone-view%
     (init player)
     (super-new [src ((player 'get-field) 'get-library-zone)]
                [player player])))
 
 (define gui-graveyard%
   (class gui-top-down-stack-zone-view%
     (init player)
     (super-new [src ((player 'get-field) 'get-graveyard-zone)]
                [player player])))
 
 (define gui-hand%
   (class gui-card-list-view%
     (init player)
     (super-new [src ((player 'get-field) 'get-hand-zone)])))
 
 (define gui-in-play%
   (class gui-card-list-view%
     (init player)
     (super-new [src ((player 'get-field) 'get-in-play-zone)])))
 
 (define gui-player-package%
   (class vertical-pane%
     (init-field game)
     (init-field player)
     (init-field view)
     (super-new)
     
     (define face-down (not (eq? player (view 'get-player))))
     
     (define ip (new gui-in-play% [parent this]
                                  [player player]
                                  [min-height CARD-HEIGHT]
                                  [view view]))
     
     (define handlevel (new horizontal-pane% [parent this]
                                            [min-height CARD-HEIGHT]))
     (define hand (new gui-hand% [parent handlevel]
                                 [player player]
                                 [stretchable-width #t]
                                 [view view]
                                 [face-down face-down]))
     (define info (new gui-player-info% [parent handlevel]
                                        [player player]))
     (define lib (new gui-library% [parent handlevel]
                                   [game game]
                                   [player player]
                                   [view view]
                                   [face-down #t]))
     (define grave (new gui-graveyard% [parent handlevel]
                                       [game game]
                                       [player player]
                                       [view view]))
     
     (define/public (update)
       (send ip update)
       (send hand update)
       (send info update)
       (send lib update)
       (send grave update))))