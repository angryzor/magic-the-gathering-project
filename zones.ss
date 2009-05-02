#!r6rs

(library
 (zones)
 (export zone-stack
         zone-library
         zone-graveyard
         zone-hand
         zone-in-play)
 (import (rnrs base (6))
         (rnrs io simple)
         (magic object)
         (magic double-linked-position-list)
         (magic cards))
 
 (define-dispatch-subclass (zone)
   (add-card! delete-card! move-card!)
   (position-list eq?)
   
   (define (add-card! card . newpos)
     (apply super 'add-before! card newpos)
     (card 'changed-zone this))
   
   (define (delete-card! card)
     (let ([pos (super 'find card)])
       (if pos
           (super 'delete! pos)
           (error 'zone.delete-card! "card does not exist!" card))))
   
   (define (move-card! card new-zone)
     (this 'delete-card! card)
     (new-zone 'add-card! card)))
 
 (define-dispatch-subclass (zone-stacklike)
   (push! top pop!)
   (zone)
   
   (define (push! card)
     (super 'add-card! card))
   
   (define (top)
     (if (super 'empty?)
         (error 'zone-stacklike.top "zone is empty")
         (super 'value (super 'first-position))))
   
   (define (pop!)
     (if (super 'empty?)
         (error 'zone-stacklike.pop! "zone is empty")
         (let* ([pos (super 'first-position)]
                [card (super 'value pos)])
           (super 'delete! pos)
           card))))
 
 (define-dispatch-subclass (zone-stack)
   (add-card! push!)
   (zone-stacklike)
   
   (define (add-card! card)
     (if (card 'supports-type? card-stackable)
         (begin
           (super 'add-card! card))
         (assertion-violation 'zone-stack.add-card! "trying to add non-stackable card")))
   
   (define (push! card)
     (add-card! card))
   
;   (define (resolve-one!)
;     (let ([card (super 'pop!)])
;       (card 'cast)))
   )
 
 (define-dispatch-subclass (zone-library)
   (shuffle draw)
   (zone-stacklike)
   
   (define (shuffle)
     #f)
   
   (define (draw)
     (super 'pop!)))
 
 (define-dispatch-subclass (zone-graveyard)
   ()
   (zone-stacklike))
 
 (define-dispatch-subclass (zone-hand)
   (sort)
   (zone)
   
   (define (sort old-pos new-pos)
     #f))
 
 (define-dispatch-subclass (zone-in-play)
   (add-card!)
   (zone)
   
   (define (add-card! card)
     (if (card 'supports-type? card-permanent)
         (begin
           (super 'add-card! card))
         (assertion-violation 'zone-in-play.add-card! "trying to add non-permanent card"))))
 
 )