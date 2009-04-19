#!r6rs

(library
 (phase)
 (export phases-fsm)
 (import (rnrs base (6))
         (magic fsm)
         (magic cards)
         (magic fields))
 
 
 
 
 (define (phases-fsm game)
   
   
   ; Some recurring transition events
   (define (immediate) 
     #t)
   
   (define super (fsm phase-beginning-untap))
   
   (define (get-current-type)
     ((super 'get-current-state) 'get-type))
   
   (define (obj-phases-fsm msg . args)
     (case msg
       ((get-current-type) (apply get-current-type args))
       (else (apply super msg args))))

   
   
   ; Transition from beginning-untap
   ; We can only move on to the next phase if all cards of the active player are untapped
   (phase-beginning-untap          'add-transition! ) ; Move to the upkeep
   ; Do the upkeep and move to the draw phase when stack is resolved.
   (add-stack-resolvers! phase-beginning-upkeep phase-beginning-draw)
   ; Move on when all players have drawn a card
   (phase-beginning-draw           'add-transition! (fsm-transition 
                                                                    phase-first-main)) ; Move to main phase
   
   ; Wait for stack resolve.
   (add-stack-resolvers! phase-first-main phase-combat-begin)
   
   (add-stack-resolvers! phase-combat-begin phase-combat-declare-attackers)
   (add-stack-resolvers! phase-combat-declare-attackers phase-combat-declare-blockers)
   (add-stack-resolvers! phase-combat-declare-blockers phase-combat-damage)
   (add-stack-resolvers! phase-combat-damage phase-combat-end)
   (add-stack-resolvers! phase-combat-end phase-second-main)
   
   (add-stack-resolvers! phase-second-main phase-end-end-of-turn)
   
   (add-stack-resolvers! phase-end-end-of-turn phase-end-cleanup)
   (phase-end-cleanup 'add-transition! (fsm-transition (lambda ()
                                                         ((game 'get-players) 'all-true? (lambda (player)
                                                                                           (<= (((player 'get-field) 'get-hand-zone) 'size) 7))))
                                                       phase-beginning-untap))
   
   obj-phases-fsm)
 
 )
