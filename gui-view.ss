#lang scheme/gui

(provide gui-view)
(require (lib "gui-card-control.ss" "magic"))
(require (lib "null-card.ss" "magic"))
(require (lib "card-dimensions.ss" "magic"))

(define (gui-view player game)
  (define my-main-frame (new frame% [label (string-append "Magic: The Gathering -- " (player 'get-name))]))
  
  ; Layout *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
  
  (define (prepare-layout)
    (new horizontal-pane% [parent my-main-frame]
                          [min-height CARD-HEIGHT])
    (let ([players (game 'get-players)])
      (players 'for-each (lambda (player)
                           (let ([div (new vertical-pane% [parent my-main-frame]
                                                          [min-width (* CARD-WIDTH 10)])])
                             (new horizontal-pane% [parent div]
                                                   [min-height CARD-HEIGHT])
                             (let ([handlevel (new horizontal-pane% [parent div]
                                                                    [min-height CARD-HEIGHT])])
                               (new horizontal-pane% [parent handlevel]
                                                     [stretchable-width #t])
                               (new gui-card-control% [parent handlevel]
                                                      [card (null-card game player)])
                               (new gui-card-control% [parent handlevel]
                                                      [card (null-card game player)])
                               ))))))
                           
  

  ; Menu bar =========================================================================================
  (define my-menu-bar (new menu-bar% [parent my-main-frame]))
  (define my-menu-game (new menu% [parent my-menu-bar]
                                  [label "Game"]))
  (define my-menu-item-exit (new menu-item% [parent my-menu-game]
                                            [label "&Exit"]
                                            [callback (lambda (i e)
                                                        (display "exit clicked in instance ")
                                                        (display i))]))
  
  
  ; Interface -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
  (define (update)
    'ok)
  
  (define (close)
    'ok)
  
  (define (obj-gui-view msg . args)
    (case msg
      ((update) (apply update args))
      ((close) (apply close args))
      (else (error 'obj-gui-view "message not understood" msg))))
  
  (prepare-layout)
  (send my-main-frame show #t)
  
  obj-gui-view)