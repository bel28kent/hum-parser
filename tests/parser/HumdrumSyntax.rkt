#lang racket

#|
	Tests for HumdrumSyntax.
|#

(require "../../parser/HumdrumSyntax.rkt"
         test-engine/racket-tests
         (only-in rackunit check-exn))

; humdrum-record-type-match?
(check-expect (humdrum-record-type-match? 'ExclusiveInterpretation "**kern") #t)
(check-expect (humdrum-record-type-match? 'GlobalComment "!! Global comment") #t)
(check-expect (humdrum-record-type-match? 'LocalComment "!\t! Local comment\t!") #t)
(check-expect (humdrum-record-type-match? 'Measure "=8\t=8") #t)
(check-expect (humdrum-record-type-match? 'Reference "!!!COM: Bach, Johann Sebastian") #t)
(check-expect (humdrum-record-type-match? 'TandemInterpretation "*\t*clefG2\t*\t*") #t)
(check-expect (humdrum-record-type-match? 'Token "4a\t4cc#\tf") #t)
(check-expect (humdrum-record-type-match? 'ExclusiveInterpretation "*clef") #f)
(check-expect (humdrum-record-type-match? 'GlobalComment "!\t! Local comment\t!") #f)
(check-expect (humdrum-record-type-match? 'LocalComment "!! Global comment") #f)
(check-expect (humdrum-record-type-match? 'Measure "4a\t4cc#\tf") #f)
(check-expect (humdrum-record-type-match? 'Reference "!! Global comment") #f)
(check-expect (humdrum-record-type-match? 'TandemInterpretation "**kern\t**kern") #f)
(check-expect (humdrum-record-type-match? 'Token "=8\t=8") #f)

; type-humdrum-record
(check-expect (type-humdrum-record "**kern") 'ExclusiveInterpretation)
(check-expect (type-humdrum-record "!! Global comment") 'GlobalComment)
(check-expect (type-humdrum-record "!\t! Local comment\t!") 'LocalComment)
(check-expect (type-humdrum-record "=8\t=8") 'Measure)
(check-expect (type-humdrum-record "!!!COM: Bach, Johann Sebastian") 'Reference)
(check-expect (type-humdrum-record "*\t*clefG2\t*\t*") 'TandemInterpretation)
(check-expect (type-humdrum-record "4a\t4cc#\tf") 'Token)
(check-exn #rx"syntax-error: could not match a "
           (λ ()
              (type-humdrum-record "")))

; humdrum-token-type-match?
(check-expect (humdrum-token-type-match? 'ExclusiveInterpretation "**kern") #t)
(check-expect (humdrum-token-type-match? 'LocalComment "!") #t)
(check-expect (humdrum-token-type-match? 'LocalComment "! Local comment") #t)
(check-expect (humdrum-token-type-match? 'Measure "=8") #t)
(check-expect (humdrum-token-type-match? 'NullSpineData ".") #t)
(check-expect (humdrum-token-type-match? 'SpineData "4.a") #t)
(check-expect (humdrum-token-type-match? 'SpineData "pp") #t)
(check-expect (humdrum-token-type-match? 'TandemInterpretation "*staff1") #t)
(check-expect (humdrum-token-type-match? 'ExclusiveInterpretation "*staff1") #f)
(check-expect (humdrum-token-type-match? 'LocalComment ".") #f)
(check-expect (humdrum-token-type-match? 'Measure "4a") #f)
(check-expect (humdrum-token-type-match? 'NullSpineData "!") #f)
(check-expect (humdrum-token-type-match? 'SpineData "**dynam") #f)
(check-expect (humdrum-token-type-match? 'TandemInterpretation "**kern") #f)

; type-humdrum-token
(check-expect (type-humdrum-token "**kern") 'ExclusiveInterpretation)
(check-expect (type-humdrum-token "!") 'LocalComment)
(check-expect (type-humdrum-token "! Local comment") 'LocalComment)
(check-expect (type-humdrum-token "=8") 'Measure)
(check-expect (type-humdrum-token ".") 'NullSpineData)
(check-expect (type-humdrum-token "4.a") 'SpineData)
(check-expect (type-humdrum-token "pp") 'SpineData)
(check-expect (type-humdrum-token "*staff1") 'TandemInterpretation)
(check-exn #rx"syntax-error: could not match a "
           (λ ()
              (type-humdrum-token "")))

(test)
