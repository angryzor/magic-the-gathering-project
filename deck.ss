#!r6rs

(library
 (deck)
 (export ccn-couple
         deck)
 (import (rnrs base (6))
         (magic object)
         (magic double-linked-position-list))
 
   (define-dispatch-class (ccn-couple name constructor)
     (get-name get-constructor)
     (define (get-name)
       name)
     (define (get-constructor)
       constructor))
   
   (define-dispatch-class (deck name)
     (add-ccn! add-ccn-multiple! for-each-ccn get-name give-to)
     
     (define ccns (position-list eq?))
     
     (define (add-ccn! ccn)
       (ccns 'add-after! ccn))
     
     (define (add-ccn-multiple! n ccn)
       (if (> n 0)
           (begin
             (add-ccn! ccn)
             (add-ccn-multiple! (- n 1) ccn))))
     
     (define (for-each-ccn proc)
       (ccns 'for-each proc))
     
     (define (get-name)
       name)
     
     (define (give-to player game)
       (let ([lib ((player 'get-field) 'get-library-zone)])
         (lib 'clear!)
         (this 'for-each-ccn (lambda (ccn)
                               (lib 'push! ((ccn 'get-constructor) game player))))
         
         (lib 'shuffle)))))