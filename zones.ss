(define (zone)
  (define cards (position-list eq?))
  
  (define (find-pos idx)
    (define (iter pos n)
      (if (and (> n 0)
               (cards 'has-next? pos))
          (iter (cards 'next pos) (- n 1))
          pos))
    (if (cards 'empty?)
        (error 'zone.find-pos "searching for position in empty list" idx)
        (iter (cards 'first-position) idx)))
  
  (define (add-card card . idx)
    (cond ((null? idx) (cards 'add-before! card))
          ((= (length idx) 1) (cards 'add-before! card (find-pos idx)))
          (else (assertion-violation 'zone.add-card "too many arguments" idx))))
  
  (define (delete-card! card)
    (let ((pos (cards 'find card)))
      (if pos
          (cards 'delete! pos)
          (error 'zone.delete-card! "card does not exist!" card))))
  
  (define (delete-by-index! idx)
    (if (cards 'empty?)
        (error 'zone.delete-by-index! "zone is empty!" card)
        (cards 'delete! (find-pos idx))))
  
  (define (get-at-index idx)
    (if (cards 'empty?)
        (error 'zone.delete-by-index! "zone is empty!" card)
        (cards 'value (find-pos idx))))
  
  (define (to-position-list)
    cards)
  
  (define (size)
    (cards 'size))
  
  (define (empty?)
    (cards 'empty?))
  
  (define (obj-zone msg . args)
    (case msg
      ((add-card!) (apply add-card! args))
      ((delete-card!) (apply delete-card! args))
      ((delete-by-index!) (apply delete-by-index! args))
      ((get-at-index) (apply get-at-index args))
      ((to-position-list) (apply to-position-list args))
      ((size) (apply size args))
      ((empty?) (apply empty? args))
      (else (assertion-violation 'zone "message not understood" msg))))
  obj-zone)

(define (zone-stack)
  (define super (zone))
  
  (define (push! card)
    (super 'add-card! card))
  
  (define (top)
    (super 'get-at-index 0))
  
  (define (pop!)
    (let ((card (super 'get-at-index 0)))
      (super 'delete-by-index! 0)
      card))
  
  (define (obj-zone-stack msg . args)
    (case msg
      ((push!) (apply push! args))
      ((top) (apply top args))
      ((pop!) (apply pop! args))
      (else (apply super args))))
  obj-zone-stack)

(define (zone-library)
  (define super (zone-stack))
  
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
  (define super (zone-stack))
  
  (define (obj-zone-graveyard msg . args)
    (case msg
      (else (apply super msg args))))
  obj-zone-graveyard)

(define (zone-hand)
  (define super (zone))
  
  (define (sort old-idx new-idx)
    (let ((card (super 'get-at-index old-idx)))
      (super 'delete-by-index! old-idx)
      