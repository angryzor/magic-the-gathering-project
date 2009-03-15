#lang scheme/gui

(define mtg-canvas%
  (class canvas%
    (define/override (on-event event)
      (display "Got mouse event"))
    (super-new)))

(define (gui-view player game)
  (define my-main-frame (new frame% [label (string-append "Magic: The Gathering -- " "")]));(player 'get-name))]))
  (define my-canvas (new mtg-canvas% [parent my-main-frame]
                                     [min-width 800]
                                     [min-height 600]))
  (define my-menu-bar (new menu-bar% [parent my-main-frame]))
  (define my-menu-game (new menu% [parent my-menu-bar]
                                  [label "Game"]))
  (define my-menu-item-exit (new menu-item% [parent my-menu-game]
                                            [label "&Exit"]
                                            [callback (lambda (i e)
                                                        (display "exit clicked in instance ")
                                                        (display i))]))
  
  (define (gui-view-obj)
    'ok)
  
  (send my-main-frame show #t)
  
  gui-view-obj)