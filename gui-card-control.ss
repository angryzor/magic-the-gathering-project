#lang scheme/gui

(provide gui-card-control%
         gui-card-with-actions-control%
         gui-card-choice-control%
         gui-card-zoom%)
(require (lib "card-dimensions.ss" "magic"))
(require (lib "cards.ss" "magic"))
(require (lib "null-card.ss" "magic"))

(define gui-card-control% 
  (class canvas%
    (init-field card)
    (init-field view)
    (init [paint-callback (lambda () 'ok)])
    (init-field [face-down #f])
    (init [min-width CARD-WIDTH])
    (init [min-height CARD-HEIGHT])
               
    (define/public (picpath)
      (if face-down 
          "resources/bitmaps/cards/card-back.jpg"
          (string-append "resources/bitmaps/cards/" (card 'get-picture))))
    
    (define pic (send (view 'get-bm-cache) access (picpath)))
    
    (define/override (on-event event)
      (cond ((and (send event entering?)
                  (not face-down)) (view 'zoom-on card))
            ((and (send event button-up? 'left)
                  (view 'waiting-for-card?)) (view 'found-card card))))
    
    (define/public (get-card)
      card)
    
    (define/public (reload-pic)
      (set! pic (send (view 'get-bm-cache) access (picpath))))
    
    (super-new [min-width min-width]
               [min-height min-height]
               [stretchable-width #f]
               [stretchable-height #f]
               [paint-callback (lambda (inst dc)
                                 (send dc draw-bitmap pic 0 0) 
                                 (when (and (card 'supports-type? card-tappable)
                                            (card 'tapped?))
                                   (send dc set-text-foreground (make-object color% 255 255 255))
                                   (send dc set-text-background (make-object color% 0 0 0))
                                   (send dc set-text-mode 'solid)
                                   (send dc draw-text "TAPPED" 0 0))
                                 (paint-callback))])))

(define gui-card-with-actions-control%
  (class gui-card-control%
    (inherit-field card)
    (inherit-field view)
    (inherit-field face-down)
    (inherit popup-menu)
    
    ; Show list of actions on rightclick
    (define/override (on-event event)
        (cond ((and (send event entering?)
                    (not face-down)) (view 'zoom-on card))
              ((view 'waiting-for-card?) (when (send event button-up? 'left)
                                           (view 'found-card card)))
              (else (when (eq? (card 'get-player) (view 'get-player))
                      (cond ((send event button-up? 'right) (let ([acts (card 'get-actions)])
                                                              (unless (acts 'empty?)
                                                                (let ([menu (new popup-menu% [title "Action menu"])])
                                                                  (acts 'for-each (lambda (action)
                                                                                    (new menu-item% [parent menu]
                                                                                         [label (action 'get-description)]
                                                                                         [callback (lambda (i e)
                                                                                                     (action 'perform))])))
                                                                  (popup-menu menu (send event get-x) (send event get-y))))))
                            ((send event button-up? 'left) (card 'perform-default-action)))))))
    
    (super-new)))
                                                                  
(define gui-card-choice-control%
  (class gui-card-control%
    (init-field callback)
    
    (define/override (on-event event)
      (when (send event button-up? 'left)
        (callback this event)))
    (super-new)))

(define gui-card-custom-control%
  (class gui-card-control%
    (init-field callback)
    
    (define/override (on-event event)
        (callback this event))
    (super-new)))

(define gui-card-zoom%
  (class gui-card-control%
    (inherit-field card)
    (init game)
    (init player)
    
    (inherit reload-pic)
    (inherit refresh)
    
    (define/override (picpath)
      (string-append "resources/bitmaps/cards/hires/" (card 'get-picture)))
    (define/public (zoom-on acard)
      (when (and (not (eq? acard card))
                 (not (acard 'supports-type? no-card)))
        (set! card acard))
      (reload-pic)
      (refresh))
    (define/override (on-event event)
      'ok) ;do nothing
    (super-new [card (null-card game player)]
               [min-height 285]
               [min-width 200])))