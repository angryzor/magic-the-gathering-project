#!r6rs

(library
 (tenth-edition)
 (export card-forest
         card-canopy-spider
         card-doomed-necromancer
         card-island
         card-sage-owl)
 (import (rnrs base (6))
         (magic object)
         (magic double-linked-position-list)
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
 
 ;canopy spider
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
 
 
 ;doomed necromancer
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
 
 
 ;sage owl
 (define-dispatch-subclass (card-sage-owl game player)
   (play)
   (card-creature "Sage Owl"
                  'blue
                  (mana-list (mana-unit 'blue) (mana-unit 'colorless))
                  game
                  player
                  1
                  1
                  "creatures/card-sage-owl.jpg"
                  '(flying))
   
   (define (play)                                          ; Lets you rearrange top 4 of your library 
     (super 'play)
     (let ([lib ((player 'get-field) 'get-library-zone)]
           [tmplst (position-list eq?)])
       (let loop ([n 4])
         (if (and (> n 0)
                  (not (lib 'empty?)))
             (begin
               (tmplst 'add-before! (lib 'pop!))
               (loop (- n 1)))))
       ((player 'get-gui) 'wait-reorder-cards "Reorder the first 4 cards of your library." tmplst)
       (tmplst 'for-each (lambda (card)
                           (lib 'push! card))))))
 
 
 ;cloud elemental
 (define-dispatch-subclass (card-cloud-elemental game player)
   (can-block?)
   (card-creature "Cloud Elemental"
                  'blue
                  (mana-list (mana-unit 'blue) (mana-unit 'colorless) (mana-unit 'colorless))
                  game
                  player
                  2
                  3
                  "creatures/card-cloud-elemental.jpg"
                  '(flying))
   
   (define (can-block? attacker)                              ; Can only block creatures with flying
     (and (super 'can-block? attacker)
          (attacker 'has-special-attribute? 'flying))))
 
 
 ;phantom warrior
 (define-dispatch-subclass (card-phantom-warrior game player)
   (can-be-blocked-by?)
   (card-creature "Phantom Warrior"
                  'blue
                  (mana-list (mana-unit 'blue) (mana-unit 'blue) (mana-unit 'colorless))
                  game
                  player
                  2
                  2
                  "creatures/card-phantom-warrior.jpg"
                  '())
 
   (define (can-be-blocked-by? blocker)
     #f))
 
 
 ;aven fisher
 (define-dispatch-subclass (card-aven-fisher game player)
   (changed-zone)
   (card-creature "Aven Fisher"
                  'blue
                  (mana-list (mana-unit 'blue) (mana-unit 'colorless) (mana-unit 'colorless) (mana-unit 'colorless))
                  game
                  player
                  2
                  2
                  "creatures/card-aven-fisher.jpg"
                  '(flying))
   
   (define prev-zone '())
   
   (define (changed-zone zone)
     (super 'changed-zone)
     (let ([pfield (player 'get-field)])
       (if (and (eq? zone (pfield 'get-graveyard-zone))
                (eq? prev-zone (pfield 'get-in-play-zone)))
           (player 'draw-card)))
     (set! prev-zone zone)))
 
 
 ;thieving magpie
 (define-dispatch-subclass (card-virtual-blocked-combat-damage-thieving-magpie for-creature to-creature)
   (cast)
   (card-virtual-blocked-combat-damage for-creature to-creature)
   
   (define (cast)
     (super 'cast)
     ((this 'get-player) 'draw-card)))
 (define-dispatch-subclass (card-virtual-direct-combat-damage-thieving-magpie for-creature to-player)
   (cast)
   (card-virtual-direct-combat-damage for-creature to-player)
   
   (define (cast)
     (super 'cast)
     ((this 'get-player) 'draw-card)))
 (define-dispatch-subclass (card-thieving-magpie game player)
   (create-virtual-blocked-combat-damage create-virtual-direct-combat-damage)
   (card-creature "Thieving Magpie"
                  'blue
                  (mana-list (mana-unit 'blue) (mana-unit 'blue) (mana-unit 'colorless) (mana-unit 'colorless))
                  game
                  player
                  1
                  3
                  "creatures/card-thieving-magpie.jpg"
                  '(flying))
   
   (define (create-virtual-blocked-combat-damage for-creature to-creature)
     (card-virtual-blocked-combat-damage-thieving-magpie for-creature to-creature))
   (define (create-virtual-direct-combat-damage for-creature to-player)
     (card-virtual-direct-combat-damage-thieving-magpie for-creature to-player)))
 
 
 ;air elemental
 (define (card-air-elemental game player)
   (card-creature "Air Elemental"
                  'blue
                  (mana-list (mana-unit 'blue) (mana-unit 'blue) (mana-unit 'colorless) (mana-unit 'colorless) (mana-unit 'colorless))
                  game
                  player
                  4
                  4
                  "creatures/card-air-elemental.jpg"
                  '(flying)))
 
 
 ;arcanis the omnipotent
 (define-dispatch-subclass (card-arcanis-the-omnipotent game player)
   ()
   (card-creature "Arcanis the Omnipotent"
                  'blue
                  (mana-list (mana-unit 'blue) (mana-unit 'blue) (mana-unit 'blue) (mana-unit 'colorless) (mana-unit 'colorless) (mana-unit 'colorless))
                  game
                  player
                  3
                  4
                  "creatures/card-arcanis-the-omnipotent.jpg"
                  '())
   (init (super 'add-to-action-library! tap-for-cards)
         (super 'add-to-action-library! pay-for-return))
   (define tap-for-cards (card-action game
                                     "Tap: Draw 3 cards"
                                     (lambda ()
                                       (and (eq? (super 'get-zone) ((player 'get-field) 'get-in-play-zone))
                                            (eq? ((game 'get-phases) 'get-current-type) 'main)
                                            (eq? player (game 'get-active-player))
                                            (not (this 'tapped?))))
                                     (lambda ()
                                       (super 'tap!)
                                       (player 'draw-card)
                                       (player 'draw-card)
                                       (player 'draw-card))))
   (define pay-for-return (card-action game
                                     "Sacrifice mana: Return Arcanis to hand"
                                     (lambda ()
                                       (and (eq? (super 'get-zone) ((player 'get-field) 'get-in-play-zone))
                                            (eq? ((game 'get-phases) 'get-current-type) 'main)
                                            (eq? player (game 'get-active-player))
                                            (not (this 'tapped?))
                                            ((player 'get-manapool) 'can-afford? (mana-list (mana-unit 'blue) (mana-unit 'blue) (mana-unit 'colorless) (mana-unit 'colorless)))))
                                     (lambda ()
                                       ((this 'get-zone) 'move-card! this ((player 'get-field) 'get-hand-zone))))))
 
 
 ;denizen of the deep
 (define-dispatch-subclass (card-denizen-of-the-deep game player)
   (play)
   (card-creature "Denizen of the Deep"
                  'blue
                  (mana-list (mana-unit 'blue) (mana-unit 'blue) (mana-unit 'colorless) (mana-unit 'colorless) (mana-unit 'colorless) (mana-unit 'colorless) (mana-unit 'colorless) (mana-unit 'colorless))
                  game
                  player
                  11
                  11
                  "creatures/card-denizen-of-the-deep.jpg"
                  '())
   
   (define (play)
     (let ([inplay ((player 'get-field) 'get-in-play-zone)]
           [hand ((player 'get-field) 'get-hand-zone)])
       (define (iter pos)
         (let ([next (if (inplay 'has-next? pos)
                         (inplay 'next pos)
                         #f)]
               [card (inplay 'value pos)])
           (if (not (eq? card this))
               (begin
                 (inplay 'delete! pos)
                 (hand 'add-card! card)))
           (if next
               (iter next))))
       (if (not (inplay 'empty?))
           (iter (inplay 'first-position))))))
 
 
 ;unsummon
 (define-dispatch-subclass (card-unsummon game player)
   (play cast)
   (card-instant "Unsummon"
                 'blue
                 (mana-list (mana-unit 'blue))
                 game
                 player
                 "instants/card-unsummon.jpg")
   
   (define target #f)
   (define (play)
     (define (wait-for-suitable-card card)
       (if (card 'supports-type? card-creature)
           card
           (wait-for-suitable-card ((player 'get-gui) 'wait-for-card-selection "Select a target creature to cast \"Unsummon\" upon."))))
     (set! target (wait-for-suitable-card ((player 'get-gui) 'wait-for-card-selection "Select a target creature to cast \"Unsummon\" upon."))))
   
   (define (cast)
     (let ([owner (target 'get-player)])
       ((target 'get-zone) 'move-card! target ((owner 'get-field) 'get-hand-zone)))))
 
 ;remove soul
 (define-dispatch-subclass (card-remove-soul game player)
   (play cast)
   (card-instant "Remove Soul"
                 'blue
                 (mana-list (mana-unit 'blue) (mana-unit 'colorless))
                 game
                 player
                 "instants/card-remove-soul.jpg")
   (define target #f)
   (define (play)
     (define (wait-for-suitable-card card)
       (if (and (card 'supports-type? card-virtual-perm-via-stack)
                ((card 'get-perm) 'supports-type? card-creature))
           card
           (wait-for-suitable-card ((player 'get-gui) 'wait-for-card-selection "Select a target creature to cast \"Remove Soul\" upon."))))
     (set! target (wait-for-suitable-card ((player 'get-gui) 'wait-for-card-selection "Select a target creature to cast \"Remove Soul\" upon."))))
   (define (cast)
     (let ([owner (target 'get-player)])
       (((target 'get-perm) 'get-zone) 'move-card! (target 'get-perm) ((owner 'get-field) 'get-graveyard-zone))
       ((target 'get-zone) 'move-card! target ((owner 'get-field) 'get-graveyard-zone)))))
 
 
 ;telling time
 (define-dispatch-subclass (card-telling-time game player)
   (cast)
   (card-instant "Telling Time"
                 'blue
                 (mana-list (mana-unit 'blue) (mana-unit 'colorless))
                 game
                 player
                 "instants/card-telling-time.jpg")
   
   (define (cast)
     (let ([lib ((player 'get-field) 'get-library-zone)]
           [tmplst (position-list eq?)])
       (let loop ([n 3])
         (if (and (> n 0)
                  (not (lib 'empty?)))
             (begin
               (tmplst 'add-before! (lib 'pop!))
               (loop (- n 1)))))
       (let ([c1 ((player 'get-gui) 'wait-select-from-card-range "Telling Time: Choose card to put in your hand" tmplst)])
         (tmplst 'delete! (tmplst 'find c1))
         (let ([c2 ((player 'get-gui) 'wait-select-from-card-range "Telling Time: Choose card to put on top of library" tmplst)])
           (tmplst 'delete! (tmplst 'find c2))
           (let ([c3 ((player 'get-gui) 'wait-select-from-card-range "Telling Time: Choose card to put on bottom of library" tmplst)])
             (((player 'get-field) 'get-hand-zone) 'add-card! c1)
             (lib 'add-before! c2)
             (lib 'add-after! c3))))))
                 
   
 ;
 
 
     )