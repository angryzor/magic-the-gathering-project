#!r6rs
(library
 (card-action)
 (export card-action)
 (import (rnrs base (6)))
 
  ;Class: card-action
 (define (card-action description validity-check action)
   (define (get-description)
     description)
   (define (is-valid?)
     (validity-check))
   (define (perform)
     (if (validity-check)
         (action)))
   
   (define (obj-card-action msg . args)
     (case msg
       ((get-description) (apply get-description args))
       ((is-valid?) (apply is-valid? args))
       ((perform) (apply perform args))
       (else (assertion-violation 'obj-card-action "message not understood" msg))))
   obj-card-action) 
 )