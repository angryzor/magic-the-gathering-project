#!r6rs

(library
 (phase-type)
 (export phase-type)
 (import (rnrs base (6))
         (magic object)
         (magic double-linked-position-list)
 
 (define (phase-type entry-action exit-action . this-a)
   (define entry-actions (position-list eq?))
   (define exit-actions (position-list eq?))
   
   (define (enter)
     (entry-actions 'for-each (lambda (action)
                                (action))))
   (define (exit)
     (exit-actions 'for-each (lambda (action)
                               (action))))

   (put-interface phase-type
                  this-a
                  (enter exit)))
 
 )
 
 