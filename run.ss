#!r6rs

(import (rnrs base (6))
        (magic game)
        (magic tenth-edition))

(define mygame (game '("Speler 1" "Speler 2") (deck-arcanis-guile)))
