#!r6rs

(library
 (perms-via-stack)
 (export card-virtual-perm-via-stack)
 (import (rnrs base (6))
         (magic object)
         (magic cards card-virtual)
         (magic mana))
 
 (define-dispatch-subclass (card-virtual-perm-via-stack perm)
   (cast get-perm)
   (card-virtual (string-append "Bringing " (perm 'get-name) " into play.")
                   (perm 'get-color)
                   (mana-list)
                   (perm 'get-game)
                   (perm 'get-player)
                   (perm 'get-picture))
   
   (define (supports-type? type)
     (or (eq? type card-virtual-perm-via-stack) (super 'supports-type? type)))
   (define (get-type)
     card-virtual-perm-via-stack)
   
   (define (cast)
     ((perm 'get-zone) 'delete-card! perm)
     ((((perm 'get-player) 'get-field) 'get-in-play-zone) 'add-card! perm))
   (define (get-perm)
     perm)))