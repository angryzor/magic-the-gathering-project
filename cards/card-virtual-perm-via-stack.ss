#!r6rs

(library
 (perms-via-stack)
 (export card-virtual-perm-via-stack)
 (import (rnrs base (6))
         (magic object)
         (magic cards card-virtual)
         (magic mana))
 
 (define-dispatch-subclass (card-virtual-perm-via-stack perm)
   (cast get-perm play supports-type? get-type)
   (card-virtual (string-append "Bringing " (perm 'get-name) " into play.")
                   (perm 'get-color)
                   (mana-list)
                   (perm 'get-game)
                   (perm 'get-player)
                   (perm 'get-picture))
   
   (define gotplayed #f)
   
   (define (supports-type? type)
     (or (eq? type card-virtual-perm-via-stack) (super 'supports-type? type)))
   (define (get-type)
     card-virtual-perm-via-stack)
   
   (define (play)
     (super 'play)
     (((perm 'get-player) 'get-manapool) 'delete! (perm 'get-cost)))
   (define (cast)
     (super 'cast)
     (set! gotplayed #t)
     ((perm 'get-zone) 'move-card! perm (((perm 'get-player) 'get-field) 'get-in-play-zone)))
   (define (get-perm)
     perm)))