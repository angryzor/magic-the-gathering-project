#!r6rs
(library
 (card-action)
 (export card-action)
 (import (rnrs base (6))
         (magic object))
 
  ;Class: card-action
 (define-dispatch-class (card-action game description validity-check
                                     action)
   (get-description perform is-valid?)
   
   (define (get-description)
     description)
   (define (is-valid?)
     (validity-check))
   (define (perform)
     (action)
     ((game 'get-field) 'to-all 'update-actions)
     (game 'update-all-guis)))
 )