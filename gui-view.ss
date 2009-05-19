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
  (define proc-to-ex-on-crd-sel #f)
  
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
  
  (define (wait-for-card-selection msg proc)
    (set! proc-to-ex-on-crd-sel proc))
  
  (define (waiting-for-card?)
    proc-to-ex-on-crd-sel)
  
  (define (found-card card)
    (proc-to-ex-on-crd-sel card)
    (set! proc-to-ex-on-crd-sel #f))
  
  (define (wait-for-player-selection msg proc)
    (let* ([dlg (new dialog% [label "Select a player"]
                             [parent my-main-frame])]
           [players (game 'get-players)]
           [plyrs (players 'to-vector)])
      (new message% [label msg]
                    [parent dlg])
      (let ([c (new choice% [label "Player: "]
                   [parent dlg]
                   [choices ((players 'map (lambda (player)
                                             (player 'get-name)) eqv?) 'foldr (lambda (res val)
                                                                                (cons val res)) '())])])
        (new button% [label "OK"]
             [parent dlg]
             [callback (lambda (i e)
                         (send dlg show #f)
                         (proc (vector-ref plyrs (send c get-selection))))])
        (send dlg show #t))))
  
  (define (obj-gui-view msg . args)
    (case msg
      ((update) (apply update args))
      ((close) (apply close args))
      ((wait-for-card-selection) (apply wait-for-card-selection args))
      ((wait-for-player-selection) (apply wait-for-player-selection args))
      ((waiting-for-card?) (apply waiting-for-card? args))
      ((found-card) (apply found-card args))
      (else (error 'obj-gui-view "message not understood: ~S" msg))))
  
  (prepare-layout)
  (send my-main-frame show #t)
  
  obj-gui-view)

(define-syntax gui-card-let
  (syntax-rules ()
    [(_ gui-ref msg () inner ...) (begin inner ...)]
    [(_ gui-ref msg (variable1 othervariables ...) inner ...) (gui-card-let 'wait-for-card-selection msg (lambda (variable1)
                                                                                                           (guiblah gui-ref msg (othervariables ...) inner ...)))]))
