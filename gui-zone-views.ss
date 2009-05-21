#lang scheme/gui

(provide gui-card-list-view%
         gui-top-down-stack-zone-view%)
(require (lib "gui-card-control.ss" "magic"))
(require (lib "null-card.ss" "magic"))
 
 (define gui-card-list-view%
   (class horizontal-pane%
     (init-field view)
     (init-field src)
     (init-field [card-control-constructor (lambda (parent card view)
                                             (new gui-card-with-actions-control%
                                                  [parent parent]
                                                  [card card]
                                                  [view view]))])
     
     (inherit change-children)
     
     (define/public (update)
       (change-children (lambda (l)
                            (src 'foldr (lambda (res card)
                                              (cons (card-control-constructor this card view) res)) '()))))
     
     (super-new)
     (update)))
 
 (define gui-top-down-stack-zone-view%
   (class gui-card-with-actions-control%
     (init-field src)
     (init-field game)
     (init-field player)
     
     (inherit-field card)
     
     (inherit refresh)
     (inherit reload-pic)
     
     (define/public (update)
       (let ([new-card (if (src 'empty?)
                           (no-card game player)
                           (src 'top))])
         (unless (or (and (card 'supports-type? no-card)
                          (new-card 'supports-type? no-card))
                     (eq? card new-card))
           (set! card new-card)
           (reload-pic)
           (refresh))))
     (super-new [card (null-card game player)])
     (update)))
