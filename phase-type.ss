#!r6rs

(library
 (phase-type)
 (export phase-state
         normal-phase-state
         stack-resolving-phase-state
         phase-beginning-untap-state
         phase-beginning-upkeep-state
         phase-beginning-draw-state
         phase-main-state
         phase-combat-begin-state
         phase-combat-declare-attackers-state
         phase-combat-declare-blockers-state
         phase-combat-damage-state
         phase-combat-end-state
         phase-end-end-of-turn-state
         phase-end-cleanup-state)
 (import (rnrs base (6))
         (magic object)
         (magic double-linked-position-list))
 
 ;==================================================================================
 
 (define (phase-state entry-action exit-action type . this-a)
   (define (to-all-perms msg . args)
     (define (to-all-perms-in-zone zone msg . args)
       (zone 'for-each (lambda (card)
                         (if (card 'supports-type? card-permanent)
                             (apply card msg args)))))
     (let ([pfields ((game 'get-field) 'get-player-fields)])
       (pfields 'for-each (lambda (pfield)
                            (apply to-all-perms-in-zone (pfield 'get-in-play-zone) msg args)))))
   
   (define (get-type)
     type)
   
   (put-interface-sub phase-state this-a
                      (fsm-state (lambda ()
                                   (entry-action)
                                   (to-all-perms 'turn-begin))
                                 (lambda ()
                                   (to-all-perms 'turn-end)
                                   (exit-action)))
                      (get-type)))
 
 ;----------------------------------------------------------------------
 
 (define (normal-phase-state entry-action exit-action type continue-condition . this-a)
   (define my-next #f)
   (define (attach-next! phase)
     (if my-next
         (super 'remove-transition! my-next))
     (set! my-next (fsm-transition continue-condition phase))
     (super 'add-transition! my-next))
   
   (put-interface-sub normal-phase-state this-a
                      (phase-state entry-action exit-action type)
                      (attach-next!)))
 
 ;----------------------------------------------------------------------------------
 (define (stack-resolving-phase-state entry-action exit-action type game . this-a)
   (define my-next #f)
   (define my-same #f)
   
   (define (playersready-nostack?)
     (and ((game 'get-players) 'all-true? (lambda (player)
                                            (player 'ready?)))
          (((game 'get-field) 'get-stack-zone) 'empty?)))
   
   (define (playersready-somestack?)
     (and ((game 'get-players) 'all-true? (lambda (player)
                                            (player 'ready?)))
          (not (((game 'get-field) 'get-stack-zone) 'empty?))))
   
   (define (attach-next! phase)
     (if my-next
         (super 'remove-transition! my-next))
     (if my-same
         (super 'remove-transition! my-same))
     ; make the stack resolving transitions
     (set! my-next (apply fsm-transition playersready-nostack? phase trans-action))
     (set! my-same (fsm-transition playersready-somestack? this (lambda () (((game 'get-field) 'get-stack-zone) 'resolve-one!))))
     ; and add them
     (state 'add-transition! my-next)
     (state 'add-transition! my-same))
   
   (put-interface-sub stack-resolving-phase-state this-a
                      (phase-state entry-action exit-action type)
                      (attach-next!)))
 ;==================================================================================
 
 
 
 ;Beginning phases
 (define (phase-beginning-untap-state game) 
   (normal-phase-state (lambda () 'ok) (lambda () 'ok) 'beginning-untap (lambda ()
                                                                    (let* ([ap (game 'get-active-player)]
                                                                           [ipzone ((ap 'get-field) 'get-in-play-zone)])
                                                                      (ipzone 'all-false? (lambda (card)
                                                                                            (if (card 'supports-type? card-tappable)
                                                                                                (card 'tapped?)
                                                                                                #f)))))))
 (define (phase-beginning-upkeep-state game) (stack-resolving-phase-state (lambda () 'ok) (lambda () 'ok) 'beginning-upkeep game))
 (define (phase-beginning-draw-state game) (normal-phase-state (lambda () 'ok) (lambda () 'ok) 'beginning-draw (lambda () ; Wait till all players have drawn a card
                                                                                                           ((game 'get-players) 'all-true? (lambda (player)
                                                                                                                                             (player 'has-drawn?))))))
 
 (define (phase-main-state game) (stack-resolving-phase-state (lambda () 'ok) (lambda () 'ok) 'main game))
 
 ; Combat phases
 (define (phase-combat-begin-state game) (stack-resolving-phase-state (lambda () 'ok) (lambda () 'ok) 'combat-begin game))
 (define (phase-combat-declare-attackers-state game) (stack-resolving-phase-state (lambda () 'ok) (lambda () 'ok) 'combat-declare-attackers game))
 (define (phase-combat-declare-blockers-state game) (stack-resolving-phase-state (lambda () 'ok) (lambda () 'ok) 'combat-blockers game))
 (define (phase-combat-damage-state game) (stack-resolving-phase-state (lambda ()
                                                                   (let* ([ap (game 'get-active-player)])
                                                                     (((ap 'get-field) 'get-in-play-zone) 'for-each (lambda (card)
                                                                                                                      (if (card 'supports-type? 'card-creature)
                                                                                                                          (card 'deal-damage))))))
                                                                 (lambda () 'ok) 'combat-damage game))
 (define (phase-combat-end-state game) (stack-resolving-phase-state (lambda () 'ok) (lambda () 'ok) 'combat-end game))
 
 ; Second main phase
 ;   (define (phase-second-main) (main-phase))
 
 ; End of turn
 (define (phase-end-end-of-turn-state game) (stack-resolving-phase-state (lambda () 'ok) (lambda () 'ok) 'end-end-of-turn game))
 (define (phase-end-cleanup-state game) (normal-phase-state (lambda () 'ok) (lambda () 'ok) 'end-cleanup (lambda ()
                                                                                                     ((game 'get-players) 'all-true? (lambda (player)
                                                                                                                                       (<= (((player 'get-field) 'get-hand-zone) 'size) 7))))))
 
 
  
  
  
  )
 
 