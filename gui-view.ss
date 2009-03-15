#lang scheme/gui

(provide gui-view)
(require (lib "gui-card-control.ss" "magic"))

(define (gui-view player game)
  (define my-main-frame (new frame% [label (string-append "Magic: The Gathering -- ")])); (player 'get-name))]))
  
  ; Layout *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
  
  (define (prepare-layout)
    (new horizontal-pane% [parent my-main-frame])
    (let ([players (game 'get-players)])
      (players 'for-each (lambda (player)
                           (let ([div (new vertical-pane% [parent my-main-frame]
                                                          [min-width 800])])
                             (new horizontal-pane% [parent div]
                                                   [min-height 142])
                             (let ([handlevel (new horizontal-pane% [parent div]
                                                                    [min-height 142])])
                               (new horizontal-pane% [parent handlevel]
                                                     [stretchable-width #t])
                         ;      (new gui-card-control% [parent handlevel])
                          ;     (new gui-card-control% [parent handlevel])
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