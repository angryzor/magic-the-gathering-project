#!r6rs

(library
 (phase)
 (export phases-fsm)
 (import (rnrs base (6))
         (magic fsm)
         (magic cards)
         (magic fields))
 
 
 
 
 (define (phases-fsm game)
   
   (define (phase-state entry-action exit-action type)
     (define (to-all-perms msg . args)
       (define (to-all-perms-in-zone zone msg . args)
         (zone 'for-each (lambda (card)
                           (if (card 'supports-type? card-permanent)
                               (apply card msg args)))))
       (let ([pfields ((game 'get-field) 'get-player-fields)])
         (pfields 'for-each (lambda (pfield)
                              (apply to-all-perms-in-zone (pfield 'get-in-play-zone) msg args)))))
     
     (define super (fsm-state (lambda ()
                                (entry-action)
                                (to-all-perms 'turn-begin))
                              (lambda ()
                                (to-all-perms 'turn-end)
                                (exit-action))))
     
     (define (get-type)
       type)
     
     (define (obj-phase-state msg . args)
       (case msg
         ((get-type) (apply get-type args))
         (else (apply super msg args))))
     obj-phase-state)
   
   ;Beginning phases
   (define phase-beginning-untap (phase-state (lambda ()
                                                'ok)
                                              (lambda ()
                                                'ok)
                                              'beginning-untap))
   (define phase-beginning-upkeep (phase-state (lambda ()
                                                 'ok)
                                               (lambda ()
                                                 'ok)
                                               'beginning-upkeep))
   (define phase-beginning-draw (phase-state (lambda ()
                                               'ok)
                                             (lambda ()
                                               'ok)
                                             'beginning-draw))
   
   (define (main-phase) (phase-state (lambda ()
                                       'ok)
                                     (lambda ()
                                       'ok)
                                     'main))
   
   ; First main phase
   (define phase-first-main (main-phase))
   
   ; Combat phases
   (define phase-combat-begin (phase-state (lambda ()
                                             'ok)
                                           (lambda ()
                                             'ok)
                                           'combat-begin))
   (define phase-combat-declare-attackers (phase-state (lambda ()
                                                         'ok)
                                                       (lambda ()
                                                         'ok)
                                                       'combat-declare-attackers))
   (define phase-combat-declare-blockers (phase-state (lambda ()
                                                        'ok)
                                                      (lambda ()
                                                        'ok)
                                                      'combat-declare-blockers))
   (define phase-combat-damage (phase-state (lambda ()
                                              (let* ([ap (game 'get-active-player)])
                                                (((ap 'get-field) 'get-in-play-zone) 'for-each (lambda (card)
                                                                                                        (if (card 'supports-type? 'card-creature)
                                                                                                            (card 'deal-damage))))))
                                            (lambda ()
                                              'ok)
                                            'combat-damage))
   (define phase-combat-end (phase-state (lambda ()
                                           'ok)
                                         (lambda ()
                                           'ok)
                                         'combat-end))
   
   ; Second main phase
   (define phase-second-main (main-phase))
   
   ; End of turn
   (define phase-end-end-of-turn (phase-state (lambda ()
                                                'ok)
                                              (lambda ()
                                                'ok)
                                              'end-end-of-turn))
   (define phase-end-cleanup (phase-state (lambda ()
                                            'ok)
                                          (lambda ()
                                            'ok)
                                          'end-cleanup))
   
   ; Some recurring transition events
   (define (immediate) 
     #t)
   (define (playersready-nostack?)
     (and ((game 'get-players) 'all-true? (lambda (player)
                                            (player 'ready?)))
          (((game 'get-field) 'get-stack-zone) 'empty?)))
   (define (playersready-somestack?)
     (and ((game 'get-players) 'all-true? (lambda (player)
                                            (player 'ready?)))
          (not (((game 'get-field) 'get-stack-zone) 'empty?))))
   
   (define super (fsm phase-beginning-untap))
   
   (define (get-current-type)
     ((super 'get-current-state) 'get-type))
   
   (define (obj-phases-fsm msg . args)
     (case msg
       ((get-current-type) (apply get-current-type args))
       (else (apply super msg args))))

   
   ; Add recurring transitions
   (define (add-stack-resolvers! state end-state . trans-action)
     (state 'add-transition! (apply fsm-transition playersready-nostack? end-state trans-action))
     (state 'add-transition! (fsm-transition playersready-somestack? state (lambda ()
                                                                             (((game 'get-field) 'get-stack-zone) 'resolve-one!)))))
   
   ; Transition from beginning-untap
   ; We can only move on to the next phase if all cards of the active player are untapped
   (phase-beginning-untap          'add-transition! (fsm-transition (lambda ()
                                                                      (let* ([ap (game 'get-active-player)]
                                                                             [ipzone ((ap 'get-field) 'get-in-play-zone)])
                                                                        (ipzone 'all-false? (lambda (card)
                                                                                              (if (card 'supports-type? card-tappable)
                                                                                                  (card 'tapped?)
                                                                                                  #f)))))
                                                                    phase-beginning-upkeep)) ; Move to the upkeep
   ; Do the upkeep and move to the draw phase when stack is resolved.
   (add-stack-resolvers! phase-beginning-upkeep phase-beginning-draw)
   ; Move on when all players have drawn a card
   (phase-beginning-draw           'add-transition! (fsm-transition (lambda () ; Wait till all players have drawn a card
                                                                      ((game 'get-players) 'all-true? (lambda (player)
                                                                                                        (player 'has-drawn?))))
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
