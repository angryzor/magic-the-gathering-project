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
              "lands/card-forest.jpg"))
 (define (card-swamp game player)
   (card-land "Swamp"
              'black
              game
              player
              "lands/card-swamp.jpg"))
 (define (card-mountain game player)
   (card-land "Mountain"
              'red
              game
              player
              "lands/card-mountain.jpg"))
 (define (card-plains game player)
   (card-land "Plains"
              'white
              game
              player
              "lands/card-plains.jpg"))
 (define (card-island game player)
   (card-land "Island"
              'blue
              game
              player
              "lands/card-island.jpg"))
 
 ; ======================= CREATURES ==============================
 
 (define (card-canopy-spider game player)
   (card-creature "Canopy Spider" 
                  'green 
                  (mana-list (mana-unit 'green) (mana-unit 'colorless))
                  game
                  player
                  1
                  3
                  "creatures/card-canopy-spider.jpg"
                  '(reach)))
 
 (define (card-doomed-necromancer game player)
   (card-creature "Doomed Necromancer" 
                  'black
                  (mana-list (mana-unit 'black) (mana-unit 'colorless) (mana-unit 'colorless))
                  game
                  player
                  2
                  2
                  "creatures/card-doomed-necromancer.jpg"
                  '()))
 
 )
 
 
