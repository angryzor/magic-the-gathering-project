#!r6rs

(library
 (known-decks)
 (export deck-arcanis-guile
 ;        deck-mannos-resolve
  ;       deck-evincars-tiranny
   ;      deck-kamahls-temper
    ;     deck-molimos-might
         )
 (import (rnrs base (6))
         (magic object)
         (magic deck)
         (magic tenth-edition))
 

 (define (deck-arcanis-guile)
   (let ([d (deck "Arcanis' Guile")])
     (d 'add-ccn-multiple! 17 (ccn-couple "Island" card-island))
     (d 'add-ccn-multiple! 2 (ccn-couple "Sage Owl" card-sage-owl))
     (d 'add-ccn-multiple! 2 (ccn-couple "Cloud Elemental" card-cloud-elemental))
     (d 'add-ccn! (ccn-couple "Phantom Warrior" card-phantom-warrior))
     (d 'add-ccn! (ccn-couple "Aven Fisher" card-aven-fisher))
     (d 'add-ccn! (ccn-couple "Thieving Magpie" card-thieving-magpie))
     (d 'add-ccn! (ccn-couple "Air Elemental" card-air-elemental))
     (d 'add-ccn! (ccn-couple "Arcanis the Omnipotent" card-arcanis-the-omnipotent))
     (d 'add-ccn! (ccn-couple "Denizen of the Deep" card-denizen-of-the-deep))
     (d 'add-ccn-multiple! 2 (ccn-couple "Unsummon" card-unsummon))
     (d 'add-ccn-multiple! 2 (ccn-couple "Remove Soul" card-remove-soul))
     (d 'add-ccn! (ccn-couple "Telling Time" card-telling-time))
     (d 'add-ccn! (ccn-couple "Boomerang" card-boomerang))
     (d 'add-ccn-multiple! 2 (ccn-couple "Counsel of the Soratami" card-counsel-of-the-soratami))
     (d 'add-ccn-multiple! 2 (ccn-couple "Cancel" card-cancel))
     (d 'add-ccn! (ccn-couple "Tidings" card-tidings))
     (d 'add-ccn! (ccn-couple "Kraken's Eye" card-krakens-eye))
     (d 'add-ccn! (ccn-couple "Rod of Ruin" card-rod-of-ruin))))
     )