#lang scheme/gui

(provide gui-card-control%
         gui-card-with-actions-control%)
(require (lib "card-dimensions.ss" "magic"))

(define gui-card-control% 
  (class canvas%
    (init-field card)
    (init [paint-callback (lambda () 'ok)])
    
    (define pic (make-object bitmap% (card 'get-picture)))
    
    (super-new [min-width CARD-WIDTH]
               [min-height CARD-HEIGHT]
               [stretchable-width #f]
               [stretchable-height #f]
               [paint-callback (lambda (inst dc)
                                 (send dc draw-bitmap pic 0 0)
                                 (paint-callback))])))

(define gui-card-with-actions-control%
  (class gui-card-control%
    (inherit-field card)
    (inherit popup-menu)
    
    ; Show list of actions on rightclick
    (define/override (on-event event)
      (cond ((send event button-up? 'right) (let ([acts (card 'get-actions)])
                                              (unless (acts 'empty?)
                                                (let ([menu (new popup-menu% [title "Action menu"])])
                                                  (acts 'for-each (lambda (action)
                                                                    (when (action 'is-valid?)
                                                                      (new menu-item% [parent menu]
                                                                                      [label (action 'get-description)]
                                                                                      [callback (lambda ()
                                                                                                  (action 'perform))]))))
                                                  (popup-menu menu (send event get-x) (send event get-y))))))
            ((send event button-up? 'left) (card 'perform-default-action))))
    
    (super-new)))
                                                                  