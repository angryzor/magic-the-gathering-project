#!r6rs

(library
 (card-permanent-delayed)
 (export card-permanent-delayed)
 (import (rnrs base (6))
         (magic object)
         (magic cards card-tappable)
         (magic cards card-virtual-perm-via-stack))
 
 (define-dispatch-subclass (card-permanent-delayed name color cost game player picture)
   (play destroy supports-type? get-type can-play?)
   (card-tappable name color cost game player picture)
   (init (super 'add-to-action-library! act-play))
   
   (define already-going-to-play #f)
                                        
   (define act-play (card-action game
                                 "Play"
                                 (lambda ()
                                   (this 'can-play?))
                                 (lambda ()
                                   (((game 'get-field) 'get-stack-zone) 'push! (card-virtual-perm-via-stack this))
                                   (set! already-going-to-play #t))))

   (define (play)
     (set! already-going-to-play #f))
   (define (destroy)
     (set! already-going-to-play #f))
   (define (supports-type? type)
     (or (eq? type card-permanent-delayed) (super 'supports-type? type)))
   (define (get-type)
     card-permanent-delayed)
   (define (can-play?)
     (and (not already-going-to-play)
          (super 'can-play?))))
 
 )