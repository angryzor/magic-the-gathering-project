#!r6rs

(library
 (phase-std-bundle)
 (export phase-std-bundle)
 (import (rnrs base (6))
         (magic object)
         (magic phase-type))
 
 (define-dispatch-class (phase-std-bundle game)
   (get-beginning-untap 
                   get-beginning-upkeep 
                   get-beginning-draw 
                   get-first-main get-combat-begin 
                   get-combat-declare-attackers 
                   get-combat-declare-blockers 
                   get-combat-damage
                   get-combat-end
                   get-second-main
                   get-end-end-of-turn
                   get-end-cleanup)
 
   (define beginning-untap (phase-beginning-untap-state game))
   (define beginning-upkeep (phase-beginning-upkeep-state game))
   (define beginning-draw (phase-beginning-draw-state game))
   (define first-main (phase-main-state game))
   (define combat-begin (phase-combat-begin-state game))
   (define combat-declare-attackers (phase-combat-declare-attackers-state game))
   (define combat-declare-blockers (phase-combat-declare-blockers-state game))
   (define combat-damage (phase-combat-damage-state game))
   (define combat-end (phase-combat-end-state game))
   (define second-main (phase-main-state game))
   (define end-end-of-turn (phase-end-end-of-turn-state game))
   (define end-cleanup (phase-end-cleanup-state game))
   
   (define (get-beginning-untap) beginning-untap)
   (define (get-beginning-upkeep) beginning-upkeep)
   (define (get-beginning-draw) beginning-draw)
   (define (get-first-main) first-main)
   (define (get-combat-begin) combat-begin)
   (define (get-combat-declare-attackers) combat-declare-attackers)
   (define (get-combat-declare-blockers) combat-declare-blockers)
   (define (get-combat-damage) combat-damage)
   (define (get-combat-end) combat-end)
   (define (get-second-main) second-main)
   (define (get-end-end-of-turn) end-end-of-turn)
   (define (get-end-cleanup) end-cleanup))
                  
 
 )