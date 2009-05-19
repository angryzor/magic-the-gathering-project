#!r6rs

(import (rnrs base (6))
        (rnrs io simple)) 

(define gui-ref (lambda (msg . args)
                  (apply get-card args)))
(define (get-card proc)
  (proc 1))

(define-syntax guiblah
  (syntax-rules ()
    [(_ gui-ref () inner ...) (begin inner ...)]
    [(_ gui-ref (variable1 othervariables ...) inner ...) (gui-ref 'get-card (lambda (variable1)
                                                                               (guiblah gui-ref (othervariables ...) inner ...)))]))

(define (on-tap)
  ; we need 2 cards to operate on
  (guiblah gui-object (card1 card2)
           (do-coolness card1)
           (do sweetness card2)))

;deez mss erges apart zetten, handige functie
(define (gui-await-n-times n and-do . afterwards)
  (define (the-callback-generator n)
    (lambda (a-card)
      (and-do a-card)
      (cond ((> n 0) (gui 'await-selection (gui-await-n-times (- n 1) and-do)))
            ((not (null? afterwards)) ((car afterwards))))))
  (if (> n 0)
      (gui 'await-selection (the-callback-generator (- n 1)))))

;deez gaat in de card
(gui-await-n-times cost-in-nr-of-lands (lambda (card)
                                         (add-resolved-neutrals mana (list (cons (card 'colour) 1)))))
(if (playable 'playable? the-card)
    (begin 
      (if (player 'use-manas mana-use)
          (begin
            (my-hand 'delete the-card)
            (in-play-field 'add the-card)
            (set! area (player 'in-play))
            (the-card 'set-area (player 'in-play))
            (gui 'refresh))))
    (begin (display "You cannot add a creature at this time")
           (newline)))))
