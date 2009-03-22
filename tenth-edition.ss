#!r6rs

(library
 (tenth-edition)
 (export card-forest
         card-canopy-spider
         card-doomed-necromancer)
 (import (rnrs base (6))
         (magic cards)
         (magic mana))
 
 ; ======================= LANDS ==================================
 ; -------------------BASIC LANDS----------------------------------
 (define (card-forest game player)
   (card-land "Forest"
              'green
              game
              player
              "resources/bitmaps/cards/lands/card-forest.jpg"))
 
 ; ======================= CREATURES ==============================
 
 (define (card-canopy-spider game player)
   (card-creature "Canopy Spider" 
                  'green 
                  (mana-list (mana-unit 'green) (mana-unit 'colorless))
                  game
                  player
                  1
                  3
                  "resources/bitmaps/cards/creatures/card-canopy-spider.jpg"
                  '(reach)))
 
 (define (card-doomed-necromancer game player)
   (card-creature "Doomed Necromancer" 
                  'black
                  (mana-list (mana-unit 'black) (mana-unit 'colorless) (mana-unit 'colorless))
                  game
                  player
                  2
                  2
                  "resources/bitmaps/cards/creatures/card-doomed-necromancer.jpg"
                  '()))
 
 )
 
 
