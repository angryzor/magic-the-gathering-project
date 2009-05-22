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
         (only (scheme base) random)
         (magic object)
         (magic cards)
         (magic double-linked-position-list))
 
 (define-dispatch-subclass (zone)
   (add-card! delete-card! move-card!)
   (position-list eq?)
   
   (define (add-card! card . newpos)
     (apply super 'add-before! card newpos)
     (card 'changed-zone this)
     (((card 'get-game) 'get-field) 'for-all (lambda (card2)
                                               (if (not (eq? card card2))
                                                   (card2 'other-changed-zone card this)))))
   
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
   
   (define (peek-at-first-n n)
     (if (not (super 'empty?))
         (super 'sublist (super 'first-position) n)))
   
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
   (add-card! push! resolve-one!)
   (zone-stacklike)
   
   (define (add-card! card)
     (if (card 'supports-type? card-stackable)
         (begin
           (super 'add-card! card))
         (assertion-violation 'zone-stack.add-card! "trying to add non-stackable card")))
   
   (define (push! card)
     (add-card! card))
   
   (define (resolve-one!)
     (let ([card (super 'pop!)])
       (card 'cast)
       ((((card 'get-player) 'get-field) 'get-graveyard-zone) 'push! card)))
   )
 
 (define-dispatch-subclass (zone-library)
   (shuffle draw)
   (zone-stacklike)
   
   (define (shuffle)
    (define (knuth_shuffle vec)
      (define (knuth_shuffle_inner vec n)
        (if (< n 1)
            vec
            (let ((k (random (+ n 1))))
              (if (not (= k n))
                  (let ((tmp (vector-ref vec k)))
                    (vector-set! vec k (vector-ref vec n))
                    (vector-set! vec n tmp)))
              (knuth_shuffle_inner vec (- n 1)))))
      (knuth_shuffle_inner vec (- (vector-length vec) 1)))
    (this 'from-vector 
     (knuth_shuffle
      (this 'to-vector))))
   
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