(library
 (zones)
 (export zone-stack
         zone-library
         zone-graveyard
         zone-hand
         zone-in-play)
 (import (rnrs base (6))
         (magic double-linked-position-list))
 
 (define (zone)
   (define super (position-list eq?))
   
   (define (find-pos idx)
     (define (iter pos n)
       (if (and (> n 0)
                (super 'has-next? pos))
           (iter (super 'next pos) (- n 1))
           pos))
     (if (super 'empty?)
         (error 'zone.find-pos "searching for position in empty list" idx)
         (iter (super 'first-position) idx)))
   
   (define (add-card card . idx)
     (cond ((null? idx) (super 'add-before! card))
           ((= (length idx) 1) (super 'add-before! card (find-pos idx)))
           (else (assertion-violation 'zone.add-card "too many arguments" idx))))
   
   (define (delete-card! card)
     (let ((pos (super 'find card)))
       (if pos
           (super 'delete! pos)
           (error 'zone.delete-card! "card does not exist!" card))))
   
   (define (delete-by-index! idx)
     (if (super 'empty?)
         (error 'zone.delete-by-index! "zone is empty!" card)
         (super 'delete! (find-pos idx))))
   
   (define (get-at-index idx)
     (if (super 'empty?)
         (error 'zone.delete-by-index! "zone is empty!" card)
         (super 'value (find-pos idx))))
   
   (define (obj-zone msg . args)
     (case msg
       ((add-card!) (apply add-card! args))
       ((delete-card!) (apply delete-card! args))
       ((delete-by-index!) (apply delete-by-index! args))
       ((get-at-index) (apply get-at-index args))
       (else (assertion-violation 'zone "message not understood" msg))))
   obj-zone)
 
 (define (zone-stacklike)
   (define super (zone))
   
   (define (push! card)
     (add-card! card))
   
   (define (top)
     (super 'get-at-index 0))
   
   (define (pop!)
     (let ((card (super 'get-at-index 0)))
       (super 'delete-by-index! 0)
       card))
   
   (define (obj-zone-stacklike msg . args)
     (case msg
       ((push!) (apply push! args))
       ((top) (apply top args))
       ((pop!) (apply pop! args))
       (else (apply super args))))
   obj-zone-stacklike)
 
 (define (zone-stack)
   (define super (zone-stacklike))
   
   (define (add-card! card)
     (if (card 'supports-type? card-stackable)
         (begin
           (super 'add-card! card)
           (card 'play))
         (assertion-violation 'zone-stack.add-card! "trying to add non-stackable card")))
   
   (define (push! card)
     (add-card! card))
   
   (define (resolve-one!)
     (let ([card (pop!)])
       (card 'cast)))
   
   (define (obj-zone-stack msg . args)
     (case msg
       ((add-card!) (apply add-card! args))
       ((push!) (apply push! args))
       (else (apply super args))))
   obj-zone-stack)
 
 (define (zone-library)
   (define super (zone-stacklike))
   
   (define (shuffle)
     #f)
   
   (define (draw)
     (pop!))
   
   (define (obj-zone-library msg . args)
     (case msg
       ((shuffle) (apply shuffle args))
       ((draw) (apply draw args))
       (else (apply super msg args))))
   obj-zone-library)
 
 (define (zone-graveyard)
   (define super (zone-stacklike))
   
   (define (obj-zone-graveyard msg . args)
     (case msg
       (else (apply super msg args))))
   obj-zone-graveyard)
 
 (define (zone-hand)
   (define super (zone))
   
   (define (sort old-idx new-idx)
     (let ((card (super 'get-at-index old-idx)))
       (super 'delete-by-index! old-idx)
       (super 'add-card! card (if (> new-idx old-idx)
                                  (+ new-idx 1)
                                  new-idx))))
   
   (define (obj-zone-hand msg . args)
     (case msg
       (else (apply super msg args))))
   obj-zone-hand)
 
 (define (zone-in-play)
   (define super (zone))
   
   (define (add-card! card)
     (if (card 'supports-type? card-permanent)
         (begin
           (super 'add-card! card)
           (card 'play))
         (assertion-violation 'zone-in-play.add-card! "trying to add non-permanent card")))

   (define (obj-zone-in-play msg . args)
     (case msg
       ((add-card!) (apply add-card! args))
       (else (apply super msg args))))
   obj-zone-in-play)
 
 )