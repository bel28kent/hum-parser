#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for file functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../data-definitions/data-definitions.rkt"
         "../functions/file.rkt"
         test-engine/racket-tests)

(provide BERG-PATH)

(define BERG-PATH "data/berg01.pc")

; TODO
;  More robust tests would use real examples that contain each tag.
;  Could use constants.

; read-file
(check-expect (read-file BERG-PATH)
                  (list "!!!COM: Berg, Alban"
                        "!!!OTL: Chamber Concerto"
                        "!!!OMV: Movements 1 and 3"
                        "!!!ODT: 1925"
                        "!!!ONB: In German, the last 8 notes are the capitalized letters in ArnolD SCHoenBErG."
                        "**pc\t**kern"
                        "*X:\t*X:"
                        "0\tF"
                        "1\tF#"
                        "3\tG#"
                        "8\tC#"
                        "4\tA"
                        "9\tD"
                        "10\tE-"
                        "7\tC"
                        "6\tB"
                        "5\tB-"
                        "11\tE"
                        "2\tG"
                        "*-\t*-"
                        "!!!YOR: Dave Headlam, The Music of Alban Berg (New Haven, CT: Yale University Press, 1996), p. 391"
                        "!!!ref: @{COM}: <i>@{OTL}</i> (@{ODT}), @{OMV} <br>@{ONB}"
                        "!!!SEM: This row contains 4 instances of the semitone interval class."
                        "!!!AIR: This is an all-interval row."
                        "!!!RKY: 0.55"
                        "!!!T33: 1"
                        "!!!T35: 0"))

; los->hfile
(check-expect (los->hfile "empty-file.krn" empty) (make-hfile "empty-file.krn" empty))
(check-expect (los->hfile "berg01.pc" (list "!!!COM: Berg, Alban"))
              (make-hfile "berg01.pc" (list (make-record "!!!COM: Berg, Alban"
                                                         REFERENCE-RECORD
                                                         (list "!!!COM: Berg, Alban")
                                                         0))))
(check-expect (los->hfile "berg01.pc" (list "!!!COM: Berg, Alban" "**pc\t**kern"))
              (make-hfile "berg01.pc" (list (make-record "!!!COM: Berg, Alban"
                                                         REFERENCE-RECORD
                                                         (list "!!!COM: Berg, Alban")
                                                         0)
                                            (make-record "**pc\t**kern"
                                                         TOKEN
                                                         (list (make-token "**pc" EXCLUSIVE-INTERPRETATION 1)
                                                               (make-token "**kern" EXCLUSIVE-INTERPRETATION 1))
                                                         1))))
; TODO
; write-file

(test)
