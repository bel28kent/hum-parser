#lang racket

#|
	Tests for ExclusiveInterpretation.
|#

(require "../../parser/ExclusiveInterpretation.rkt"
         test-engine/racket-tests)

; exclusive-interpretation?
(check-expect (exclusive-interpretation? "**dynam") #t)
(check-expect (exclusive-interpretation? "**kern") #t)
(check-expect (exclusive-interpretation? "**MIDI") #t)
(check-expect (exclusive-interpretation? "**neume") #t)
(check-expect (exclusive-interpretation? "**solfa") #t)
(check-expect (exclusive-interpretation? "**text") #t)
(check-expect (exclusive-interpretation? "!!!REF: Reference record") #f)
(check-expect (exclusive-interpretation? "!! Global comment") #f)
(check-expect (exclusive-interpretation? "!\t! Local comment\t!") #f)
(check-expect (exclusive-interpretation? "*tandem") #f)

; exclusive-interpretation-match?
(check-expect (exclusive-interpretation-match? 'Dynam "**dynam") #t)
(check-expect (exclusive-interpretation-match? 'Kern "**kern") #t)
(check-expect (exclusive-interpretation-match? 'MIDI "**MIDI") #t)
(check-expect (exclusive-interpretation-match? 'Neume "**neume") #t)
(check-expect (exclusive-interpretation-match? 'Solfa "**solfa") #t)
(check-expect (exclusive-interpretation-match? 'Text "**text") #t)
(check-expect (exclusive-interpretation-match? 'Kern "**dynam") #f)

; type-exclusive
(check-expect (type-exclusive "**dynam") 'Dynam)
(check-expect (type-exclusive "**kern") 'Kern)
(check-expect (type-exclusive "**MIDI") 'MIDI)
(check-expect (type-exclusive "**neume") 'Neume)
(check-expect (type-exclusive "**solfa") 'Solfa)
(check-expect (type-exclusive "**text") 'Text)
(check-expect (type-exclusive "**new") 'Unknown)

(test)
