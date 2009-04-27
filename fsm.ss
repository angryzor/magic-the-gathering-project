#!r6rs

(library
 (fsm)
 (export fsm
         fsm-state
         fsm-transition)
 (import (rnrs base (6))
         (magic double-linked-position-list)
         (magic object)
         (magic cards))
 
 ;***************************************************
 ; Class fsm-state
 ; Constructor spec: ( (  -> { #<void> } ) (  -> { #<void> } ) number . fsm-state -> fsm-state )
 ; Desc: FSM state class; represents a state of a
 ;       Finite State Machine
 ; Args: entry-action - a procedure containing the entry action
 ;       exit-action - a procedure containing the exit action
 ;       size - the maximum number of transitions that can be contained
 ;***************************************************
 (define-dispatch-class (fsm-state entry-action exit-action)
   (add-transition! next-state enter leave)
   
   (define trans-list (position-list eq?))
   
   ;=================================================
   ; Method add-transition
   ; Spec: ( fsm-transition -> { #<void> } )
   ; Desc: adds a new transition to the state
   ; Args: trans - the transition to be added
   ;=================================================
   (define (add-transition! trans)
     (if (trans-list 'full?)
         (error 'fsm-state.add-transition! "transition list is full. check your fsm-state size")
         (trans-list 'add-after! trans)))

   ;=================================================
   ; Method add-transition
   ; Spec: ( fsm-transition -> { #<void> } )
   ; Desc: adds a new transition to the state
   ; Args: trans - the transition to be added
   ;=================================================
   (define (remove-transition! trans)
     (let ([pos (trans-list 'find trans)])
       (if pos
           (trans-list 'delete! (trans-list 'find trans)))))

   ;=================================================
   ; Method next-state
   ; Spec: (  -> fsm-state U { #f } )
   ; Desc: "check"'s all transitions and returns the first non-#f value returned.
   ;       Returns #f if all of the transitions return #f.
   ;       The FSM should stay in its current state in this case.
   ;       NOTE1: transitions are checked in the order in which they were added
   ;       NOTE2: when a state is returned, the FSM MUST transition to that state
   ; Args: /
   ;=================================================
   (define (next-state)
     (define (find-next-state pos)
       (let* ((the-trans (trans-list 'value pos))
              (trans-check (the-trans 'check)))
         (cond (trans-check (the-trans 'act)
                            trans-check)
               ((trans-list 'has-next? pos) (find-next-state (trans-list 'next pos)))
               (else #f))))
     (if (trans-list 'empty?)
         #f
         (find-next-state (trans-list 'first-position))))
   
   ;=================================================
   ; Method enter
   ; Spec: (  -> sobj )
   ; Desc: should be called when the fsm enters this state;
   ;       executes the entry event
   ; Args: /
   ;=================================================
   (define (enter)
     (if (not (null? entry-action))
         (entry-action)))
   
   ;=================================================
   ; Method leave
   ; Spec: (  -> sobj )
   ; Desc: should be called when the fsm leaves this state;
   ;       executes the exit event
   ; Args: /
   ;=================================================
   (define (leave)
     (if (not (null? exit-action))
         (exit-action))))
 
 
 ;*************************************************************
 ; Class fsm-transition
 ; Constructor spec: ( (  -> boolean ) fsm-state-object )
 ; Desc: FSM transition class; represents a transition of a
 ;       Finite State Machine
 ; Args: condition - a lambda that will return whether the condition for this
 ;                   transition is met
 ;       target - the target state for this transition
 ;       trans-action - optional Transition Action, which will be
 ;                      called when the fsm transition through this transition
 ;*************************************************************
 (define (fsm-transition condition target . trans-action)
   
   ;=========================================================
   ; Method check
   ; Spec: (  -> fsm-state-object U { #f } )
   ; Desc: Call this procedure on every state-change check.
   ;       It will return the state object specified in target when the condition is met, and #f if it is not.
   ; Args: /
   ;=========================================================
   (define (check)
     (if (condition)
         target
         #f))
   
   (define (act)
     (if (and (not (null? trans-action))
              (not (null? (car trans-action))))
         ((car trans-action))))
   
   (define (obj-fsm-transition msg . args)
     (case msg
       ((check) (apply check args))
       ((act) (apply act args))
       (else (assertion-violation 'fsm-transition-object "message \"~S\" unknown" msg))))
   obj-fsm-transition)
 
 ;***************************************************
 ; Class fsm
 ; Constructor spec: ( fsm-state -> fsm )
 ; Desc: FSM class; represents a Finite State Machine
 ; Args: state - the starting state that the fsm is in
 ;***************************************************
 (define-dispatch-class (fsm state)
   (transition get-current-state)
   
   ;===================================================
   ; Method transition
   ; Spec: (  -> { 'ok } )
   ; Desc: Is called to possibly transition the fsm to a next state
   ; Args: /
   ;===================================================
   
   (define (transition)
     (let ((next-state (state 'next-state)))
       (if next-state
           (begin
             (state 'leave)
             (set! state next-state)
             (state 'enter)
             'ok)
           'ok)))
   
   (define (get-current-state)
     state))
 
 
)