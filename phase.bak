#!r6rs

(library
 (phase)
 (export phases-fsm)
 (import (rnrs base (6))
         (magic object)
         (magic fsm)
         (magic cards)
         (magic fields)
         (magic phase-std-bundle))
 
 (define-dispatch-subclass (phases-fsm game)
   (get-current-type get-std-bundle)
   (fsm (std-bundle 'get-beginning-untap))
   (init ((std-bundle 'get-beginning-untap) 'attach-next! (std-bundle 'get-beginning-upkeep))
         ((std-bundle 'get-beginning-upkeep) 'attach-next! (std-bundle 'get-beginning-draw))
         ((std-bundle 'get-beginning-draw) 'attach-next! (std-bundle 'get-first-main))
         ((std-bundle 'get-first-main) 'attach-next! (std-bundle 'get-combat-begin))
         ((std-bundle 'get-combat-begin) 'attach-next! (std-bundle 'get-combat-declare-attackers))
         ((std-bundle 'get-combat-declare-attackers) 'attach-next! (std-bundle 'get-combat-declare-blockers))
         ((std-bundle 'get-combat-declare-blockers) 'attach-next! (std-bundle 'get-combat-damage))
         ((std-bundle 'get-combat-damage) 'attach-next! (std-bundle 'get-combat-end))
         ((std-bundle 'get-combat-end) 'attach-next! (std-bundle 'get-second-main))
         ((std-bundle 'get-second-main) 'attach-next! (std-bundle 'get-end-end-of-turn))
         ((std-bundle 'get-end-end-of-turn) 'attach-next! (std-bundle 'get-end-cleanup))
         ((std-bundle 'get-end-cleanup) 'attach-next! (std-bundle 'get-beginning-untap)))

   
   
   (define std-bundle (phase-std-bundle game))
   
   (define (get-current-type)
     ((super 'get-current-state) 'get-type))
   
   (define (get-std-bundle)
     std-bundle)
   
   (define (obj-phases-fsm msg . args)
     (case msg
       ((get-current-type) (apply get-current-type args))
       (else (apply super msg args)))))
 
 )

