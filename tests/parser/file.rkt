#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for file functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../parser/data-definitions/data-definitions.rkt"
         "../../parser/functions/file.rkt"
         test-engine/racket-tests)

(provide BERG-PATH)

(define BERG-PATH "tests/parser/data/berg01.pc")

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
(check-expect (los->hfile empty) (make-hfile empty))
(check-expect (los->hfile (list "!!!COM: Berg, Alban"))
              (make-hfile (list (make-record "!!!COM: Berg, Alban"
                                             REFERENCE-RECORD
                                             (list "!!!COM: Berg, Alban")
                                             0))))
(check-expect (los->hfile (list "!!!COM: Berg, Alban" "**pc\t**kern"))
              (make-hfile (list (make-record "!!!COM: Berg, Alban"
                                             REFERENCE-RECORD
                                             (list "!!!COM: Berg, Alban")
                                             0)
                                (make-record "**pc\t**kern"
                                             TOKEN
                                             (list (make-token "**pc" EXCLUSIVE-INTERPRETATION 1)
                                                   (make-token "**kern" EXCLUSIVE-INTERPRETATION 1))
                                             1))))

; hfile->los
(check-expect (hfile->los (make-hfile empty)) empty)
(check-expect (hfile->los (make-hfile (list (make-record "!!!COM: Berg, Alban"
                                                         REFERENCE-RECORD
                                                         (list "!!!COM: Berg, Alban")
                                                         0))))
                          (list "!!!COM: Berg, Alban"))
(check-expect (hfile->los (make-hfile (list (make-record "!!!COM: Berg, Alban"
                                                         REFERENCE-RECORD
                                                         (list "!!!COM: Berg, Alban")
                                                         0)
                                            (make-record "**pc\t**kern"
                                                         TOKEN
                                                         (list (make-token "**pc" EXCLUSIVE-INTERPRETATION 1)
                                                               (make-token "**kern" EXCLUSIVE-INTERPRETATION 1))
                                                         1))))
                          (list "!!!COM: Berg, Alban" "**pc\t**kern"))

; write-file
; should not be run more than once because file exists
;(check-expect (write-file (list "!!!COM: Berg, Alban"
;                        "!!!OTL: Chamber Concerto"
;                        "!!!OMV: Movements 1 and 3"
;                        "!!!ODT: 1925"
;                        "!!!ONB: In German, the last 8 notes are the capitalized letters in ArnolD SCHoenBErG."
;                        "**pc\t**kern"
;                        "*X:\t*X:"
;                        "0\tF"
;                        "1\tF#"
;                        "3\tG#"
;                        "8\tC#"
;                        "4\tA"
;                        "9\tD"
;                        "10\tE-"
;                        "7\tC"
;                        "6\tB"
;                        "5\tB-"
;                        "11\tE"
;                        "2\tG"
;                        "*-\t*-"
;                        "!!!YOR: Dave Headlam, The Music of Alban Berg (New Haven, CT: Yale University Press, 1996), p. 391"
;                        "!!!ref: @{COM}: <i>@{OTL}</i> (@{ODT}), @{OMV} <br>@{ONB}"
;                        "!!!SEM: This row contains 4 instances of the semitone interval class."
;                        "!!!AIR: This is an all-interval row."
;                        "!!!RKY: 0.55"
;                        "!!!T33: 1"
;                        "!!!T35: 0")
;                          "tests/parser/data/berg01-write-file-test.krn")
;              (void))
;(check-expect (read-file "tests/parser/data/berg01-write-file-test.krn")
;              (list "!!!COM: Berg, Alban"
;              "!!!OTL: Chamber Concerto"
;              "!!!OMV: Movements 1 and 3"
;              "!!!ODT: 1925"
;              "!!!ONB: In German, the last 8 notes are the capitalized letters in ArnolD SCHoenBErG."
;              "**pc\t**kern"
;              "*X:\t*X:"
;              "0\tF"
;              "1\tF#"
;              "3\tG#"
;              "8\tC#"
;              "4\tA"
;              "9\tD"
;              "10\tE-"
;              "7\tC"
;              "6\tB"
;              "5\tB-"
;              "11\tE"
;              "2\tG"
;              "*-\t*-"
;              "!!!YOR: Dave Headlam, The Music of Alban Berg (New Haven, CT: Yale University Press, 1996), p. 391"
;              "!!!ref: @{COM}: <i>@{OTL}</i> (@{ODT}), @{OMV} <br>@{ONB}"
;              "!!!SEM: This row contains 4 instances of the semitone interval class."
;              "!!!AIR: This is an all-interval row."
;              "!!!RKY: 0.55"
;              "!!!T33: 1"
;              "!!!T35: 0"))

(test)
