#!r6rs
(library
 (card-action)
 (export card-action)
 (import (rnrs base (6))
         (magic object))
 
  ;Class: card-action
 (define-dispatch-class (card-action description ; validity-check
                                     action)
   (get-description perform)
   
   (define (get-description)
     description)
;   (define (is-valid?)
;     (validity-check))
   (define (perform)
     (action))
 )