#!r6rs

(library
 (phase)
 (export untap-phase)
 (import (rnrs base (6))
         (magic fsm))
 
 (define (phase-state entry-action exit-action type)
   (define (to-all-perms msg . args)
     (define (to-all-perms-in-zone zone msg . args)
       (zone 'for-each (lambda (card)
                         (if (card 'supports-type? card-permanent)
                             (apply card msg args)))))
     (let ([pfields (field 'get-player-fields)])
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
 
 
 
 (define (phases-fsm)
   
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
                                              'ok)
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
   
   
   ; Transition from beginning-untap
   ; We can only move on to the next phase if all cards of the active player are untapped
   (phase-beginning-untap 'add-transition! (fsm-transition (lambda ()
                                                             (let* ([ap (game 'get-active-player)]
                                                                    [ipzone ((ap 'get-player-field) 'get-in-play-zone)]
                                                                    [tapmap (ipzone 'map (lambda (card)
                                                                               (if (card 'supports-type? card-with-actions)
                                                                                   (card 'tapped?)
                                                                                   #f)))])
                                                               (tapmap 'foldl (lambda (x y)
                                                                                (or x y)))
   