#lang scheme/gui

(provide gui-view)
(require (lib "gui-card-control.ss" "magic"))
(require (lib "card-dimensions.ss" "magic"))
(require (lib "gui-elements.ss" "magic"))
(require (lib "double-linked-position-list.ss" "magic"))
(require (lib "gui-zone-views.ss" "magic"))
(require (lib "object.ss" "magic"))
(require (lib "gui-bitmap-cache.ss" "magic"))

(define (gui-view player game)
  (define my-main-frame (new frame% [label (string-append "Magic: The Gathering -- " (player 'get-name))]))
  (define pkgs (position-list eq?))
  (define waiting-for-card #f)
  (define card-result #f)
  (define bm-cache (new gui-bitmap-cache%))
  (define stackview '())
  (define readybtn '())
  (define zoomview '())
  
  ; Layout *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
  
  (define (prepare-layout)
    (let* ([main (new horizontal-pane% [parent my-main-frame])]
           [left (new vertical-pane% [parent main])]
           [right (new vertical-pane% [parent main])])
      (set! zoomview (new gui-card-zoom% [game game]
                          [player player]
                          [view obj-gui-view]
                          [parent left]))
      (let ([stackpane (new horizontal-pane% [parent right]
                            [min-height CARD-HEIGHT])])
        (set! readybtn (new button% [parent stackpane]
                            [label "Ready!"]
                            [callback (λ (i e) (player 'set-ready! #t))]))
        (set! stackview (new gui-card-list-view% [view obj-gui-view]
                             [parent stackpane]
                             [src ((game 'get-field) 'get-stack-zone)])))
      (let ([players (game 'get-players)])
        (players 'for-each (lambda (player)
                             (pkgs 'add-after! (new gui-player-package% [parent right]
                                                    [min-width (* CARD-WIDTH 10)]
                                                    [game game]
                                                    [player player]
                                                    [view obj-gui-view])))))))
                           
  

  ; Menu bar =========================================================================================
;  (define my-menu-bar (new menu-bar% [parent my-main-frame]))
;  (define my-menu-game (new menu% [parent my-menu-bar]
;                                  [label "&Game"]))
;  (define my-menu-item-exit (new menu-item% [parent my-menu-game]
;                                            [label "&Exit"]
;                                            [callback (lambda (i e)
;                                                        (display "exit clicked in instance ")
;                                                        (display i))]))
;  
;  
  ; Interface -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
  
  (define (update)
    (send stackview update)
    (pkgs 'for-each (lambda (pkg)
                      (send pkg update))))
  
  (define (close)
    'ok)
  
  (define (yield-card-loop)
    (when waiting-for-card
      (sleep/yield 0.03)
      (yield-card-loop)))
  
  (define (wait-for-card-selection msg)
    (send my-main-frame set-label (string-append "Magic: The Gathering -- " (player 'get-name) " -- " msg))
    (set! waiting-for-card #t)
    (send readybtn enable #f)
    (yield-card-loop)
    (send my-main-frame set-label (string-append "Magic: The Gathering -- " (player 'get-name)))
    card-result)
  
  (define (waiting-for-card?)
    waiting-for-card)
  
  (define (found-card card)
    (set! card-result card)
    (set! waiting-for-card #f)
    (send readybtn enable #t))
  
  (define (wait-for-player-selection msg)
    (define result #f)
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
                         (set! result (vector-ref plyrs (send c get-selection)))
                         (send dlg show #f))]))
      (send dlg show #t))  ; modal dialog, yields here
    result)
  
  (define (wait-select-from-card-range msg cards)
    (define result #f)
    (let* ([dlg (new dialog% [label "Select a card"]
                             [parent my-main-frame])])
      (new message% [label msg]
                    [parent dlg])
      (let ([cl (new gui-card-list-view% [parent dlg]
                                         [src cards]
                                         [view obj-gui-view]
                                         [card-control-constructor (lambda (parent card view)
                                                                     (new gui-card-choice-control%
                                                                          [parent parent]
                                                                          [card card]
                                                                          [view view]
                                                                          [callback (lambda (i e)
                                                                                      (set! result (send i get-card))
                                                                                      (send dlg show #f))]))])])
        (send cl update))
      (send dlg show #t)) ;modal dialog, yields here
    result)
  
  (define (wait-reorder-cards msg cards)
    (define src #f)
    (define btn '())
    (define cl '())
    (define (handler i e)
      (if src
          (let ([cardpos (cards 'find src)]
                [newcardpos (cards 'find (send i get-card))])
            (cards 'delete! cardpos)
            (cards 'add-before! src newcardpos)
            (send cl update)
            (set! src #f)
            (send btn enable #t))
          (begin
            (send btn enable #f)
            (set! src (send i get-card)))))
    (let* ([dlg (new dialog% [label "Sort your cards"]
                             [parent my-main-frame])])
      (new message% [label msg]
                    [parent dlg])
      (set! cl (new gui-card-list-view% [parent dlg]
                                        [src cards]
                                        [view obj-gui-view]
                                        [card-control-constructor (lambda (parent card view)
                                                                    (new gui-card-choice-control%
                                                                         [parent parent]
                                                                         [card card]
                                                                         [view view]
                                                                         [callback handler]))]))
      (send cl update)
      (set! btn (new button% [label "OK"]
                             [parent dlg]
                             [callback (lambda (i e)
                                         (send dlg show #f))]))
      (send dlg show #t)) ;modal dialog, yields here
    cards)
  
  (define (prompt msg cchoices)
    (define result #f)
    (let* ([dlg (new dialog% [label "Prompt"]
                             [parent my-main-frame])]
           [players (game 'get-players)]
           [plyrs (players 'to-vector)])
      (new message% [label msg]
                    [parent dlg])
      (let ([c (new choice% [label "Choice: "]
                   [parent dlg]
                   [choices (cchoices 'foldr (lambda (res val)
                                               (cons val res)) '())])])
        (new button% [label "OK"]
             [parent dlg]
             [callback (lambda (i e)
                         (set! result (send c get-selection))
                         (send dlg show #f))]))
      (send dlg show #t))  ; modal dialog, yields here
    result)
  
  (define (get-bm-cache)
    bm-cache)
  
  (define (zoom-on card)
    (send zoomview zoom-on card))
  
  (define (obj-gui-view msg . args)
    (case msg
      ((update) (apply update args))
      ((close) (apply close args))
      ((wait-for-card-selection) (apply wait-for-card-selection args))
      ((wait-for-player-selection) (apply wait-for-player-selection args))
      ((waiting-for-card?) (apply waiting-for-card? args))
      ((wait-select-from-card-range) (apply wait-select-from-card-range args))
      ((wait-reorder-cards) (apply wait-reorder-cards args))
      ((prompt) (apply prompt args))
      ((found-card) (apply found-card args))
      ((get-bm-cache) (apply get-bm-cache args))
      ((zoom-on) (apply zoom-on args))
      ((get-player) player)
      (else (error 'obj-gui-view "message not understood: ~S" msg))))
  
  (prepare-layout)
  (send my-main-frame show #t)
  
  obj-gui-view)

