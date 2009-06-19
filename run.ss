#!r6rs

(import (rnrs base (6))
        (magic game)
        (magic tenth-edition)
        (rnrs io simple))

(define mygame (game '("Speler 1" "Speler 2") (deck-arcanis-guile)))

;DEBUG
(define pl1 ((mygame 'get-players) 'value ((mygame 'get-players) 'first-position)))
(define fld1 (pl1 'get-field))
(define hand (fld1 'get-hand-zone))
(define lib (fld1 'get-library-zone))
(define (do-add name)
  (call/cc (lambda (return)
             (lib 'for-each (lambda (card)
                              (display (string=? (card 'get-name) name))
                              (display (card 'get-name))
                              (display name)
                              (if (string=? (card 'get-name) name)
                                  (begin
                                    (lib 'move-card! card hand)
                                    (return))))))))
(do-add "Thieving Magpie")
