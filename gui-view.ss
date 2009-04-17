#lang scheme/gui

(provide gui-view)
(require (lib "gui-card-control.ss" "magic"))
(require (lib "card-dimensions.ss" "magic"))
(require (lib "gui-elements.ss" "magic"))
(require (lib "double-linked-position-list.ss" "magic"))
(require (lib "object.ss" "magic"))

(define (gui-view player game)
  (define my-main-frame (new frame% [label (string-append "Magic: The Gathering -- " (player 'get-name))]))
  (define pkgs (position-list eq?))
  (define selected-card #f)
  
  ; Layout *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
  
  (define (prepare-layout)
    (let ([stackpane (new horizontal-pane% [parent my-main-frame]
                                           [min-height CARD-HEIGHT])])
      (new button% [parent stackpane]
                   [label "Ready!"]
                   [callback (λ (i e) (player 'set-ready! #t))]))
    (let ([players (game 'get-players)])
      (players 'for-each (lambda (player)
                           (pkgs 'add-after! (new gui-player-package% [parent my-main-frame]
                                                                      [min-width (* CARD-WIDTH 10)]
                                                                      [game game]
                                                                      [player player]
                                                                      [view obj-gui-view]))))))
                           
  

  ; Menu bar =========================================================================================
  (define my-menu-bar (new menu-bar% [parent my-main-frame]))
  (define my-menu-game (new menu% [parent my-menu-bar]
                                  [label "&Game"]))
  (define my-menu-item-exit (new menu-item% [parent my-menu-game]
                                            [label "&Exit"]
                                            [callback (lambda (i e)
                                                        (display "exit clicked in instance ")
                                                        (display i))]))
  
  
  ; Interface -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
  
  (define (update)
    (pkgs 'for-each (lambda (pkg)
                      (send pkg update))))
  
  (define (close)
    'ok)
  
  (define (wait-for-target-card-selection)
    (define (loop)
      (unless selected-card
        (sleep 0.01)
        (loop)))
    (pkgs 'for-each (lambda (pkg)
                      (send pkg wait-for-target-card-selection)))
    (loop)
    (let ([res selected-card])
      (set! selected-card #f)
      res))
  
  (define (found-card card)
    (set! selected-card card))
  
  (define (obj-gui-view msg . args)
    (case msg
      ((update) (apply update args))
      ((close) (apply close args))
      ((wait-for-target-card-selection) (apply wait-for-target-card-selection args))
      ((found-card) (apply found-card args))
      (else (error 'obj-gui-view "message not understood" msg))))
  
  (prepare-layout)
  (send my-main-frame show #t)
  
  obj-gui-view)