#lang scheme/gui

(provide gui-card-let)
(provide gui-player-let)

(define-syntax gui-card-let
  (syntax-rules ()
    [(_ gui-ref msg () inner ...) (begin inner ...)]
    [(_ gui-ref msg (variable1 othervariables ...) inner ...) (gui-ref 'wait-for-card-selection msg (lambda (variable1)
                                                                                                           (gui-card-let gui-ref msg (othervariables ...) inner ...)))]))
(define-syntax gui-player-let
  (syntax-rules ()
    [(_ gui-ref msg () inner ...) (begin inner ...)]
    [(_ gui-ref msg (variable1 othervariables ...) inner ...) (gui-ref 'wait-for-player-selection msg (lambda (variable1)
                                                                                                               (gui-player-let gui-ref msg (othervariables ...) inner ...)))]))
