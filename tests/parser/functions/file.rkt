#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for file functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         "../../../parser/functions/file.rkt"
         test-engine/racket-tests)

(define BERG-PATH "../data/berg01.pc")

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

; path->hfile
(check-expect (path->hfile BERG-PATH)
              (hfile (list (record "!!!COM: Berg, Alban"
                                   REFERENCE-RECORD
                                   (list "!!!COM: Berg, Alban")
                                   0)
                           (record "!!!OTL: Chamber Concerto"
                                   REFERENCE-RECORD
                                   (list "!!!OTL: Chamber Concerto")
                                   1)
                           (record "!!!OMV: Movements 1 and 3"
                                   REFERENCE-RECORD
                                   (list "!!!OMV: Movements 1 and 3")
                                   2)
                           (record "!!!ODT: 1925"
                                   REFERENCE-RECORD
                                   (list "!!!ODT: 1925")
                                   3)
                           (record "!!!ONB: In German, the last 8 notes are the capitalized letters in ArnolD SCHoenBErG."
                                   REFERENCE-RECORD
                                   (list "!!!ONB: In German, the last 8 notes are the capitalized letters in ArnolD SCHoenBErG.")
                                   4)
                           (record "**pc\t**kern"
                                   TOKEN
                                   (list (token "**pc" EXCLUSIVE-INTERPRETATION 5 0)
                                         (token "**kern" EXCLUSIVE-INTERPRETATION 5 1))
                                   5)
                           (record "*X:\t*X:"
                                   TOKEN
                                   (list (token "*X:" KEY-LABEL 6 0)
                                         (token "*X:" KEY-LABEL 6 1))
                                   6)
                           (record "0\tF"
                                   TOKEN
                                   (list (token "0" SPINE-DATA 7 0)
                                         (token "F" SPINE-DATA 7 1))
                                   7)
                           (record "1\tF#"
                                   TOKEN
                                   (list (token "1" SPINE-DATA 8 0)
                                         (token "F#" SPINE-DATA 8 1))
                                   8)
                           (record "3\tG#"
                                   TOKEN
                                   (list (token "3" SPINE-DATA 9 0)
                                         (token "G#" SPINE-DATA 9 1))
                                   9)
                           (record "8\tC#"
                                   TOKEN
                                   (list (token "8" SPINE-DATA 10 0)
                                         (token "C#" SPINE-DATA 10 1))
                                   10)
                           (record "4\tA"
                                   TOKEN
                                   (list (token "4" SPINE-DATA 11 0)
                                         (token "A" SPINE-DATA 11 1))
                                   11)
                           (record "9\tD"
                                   TOKEN
                                   (list (token "9" SPINE-DATA 12 0)
                                         (token "D" SPINE-DATA 12 1))
                                   12)
                           (record "10\tE-"
                                   TOKEN
                                   (list (token "10" SPINE-DATA 13 0)
                                         (token "E-" SPINE-DATA 13 1))
                                   13)
                           (record "7\tC"
                                   TOKEN
                                   (list (token "7" SPINE-DATA 14 0)
                                         (token "C" SPINE-DATA 14 1))
                                   14)
                           (record "6\tB"
                                   TOKEN
                                   (list (token "6" SPINE-DATA 15 0)
                                         (token "B" SPINE-DATA 15 1))
                                   15)
                           (record "5\tB-"
                                   TOKEN
                                   (list (token "5" SPINE-DATA 16 0)
                                         (token "B-" SPINE-DATA 16 1))
                                   16)
                           (record "11\tE"
                                   TOKEN
                                   (list (token "11" SPINE-DATA 17 0)
                                         (token "E" SPINE-DATA 17 1))
                                   17)
                           (record "2\tG"
                                   TOKEN
                                   (list (token "2" SPINE-DATA 18 0)
                                         (token "G" SPINE-DATA 18 1))
                                   18)
                           (record "*-\t*-"
                                   TOKEN
                                   (list (token "*-" SPINE-TERMINATOR 19 0)
                                         (token "*-" SPINE-TERMINATOR 19 1))
                                   19)
                           (record "!!!YOR: Dave Headlam, The Music of Alban Berg (New Haven, CT: Yale University Press, 1996), p. 391"
                                   REFERENCE-RECORD
                                   (list "!!!YOR: Dave Headlam, The Music of Alban Berg (New Haven, CT: Yale University Press, 1996), p. 391")
                                   20)
                           (record "!!!ref: @{COM}: <i>@{OTL}</i> (@{ODT}), @{OMV} <br>@{ONB}"
                                   REFERENCE-RECORD
                                   (list "!!!ref: @{COM}: <i>@{OTL}</i> (@{ODT}), @{OMV} <br>@{ONB}")
                                   21)
                           (record "!!!SEM: This row contains 4 instances of the semitone interval class."
                                   REFERENCE-RECORD
                                   (list "!!!SEM: This row contains 4 instances of the semitone interval class.")
                                   22)
                           (record "!!!AIR: This is an all-interval row."
                                   REFERENCE-RECORD
                                   (list "!!!AIR: This is an all-interval row.")
                                   23)
                           (record "!!!RKY: 0.55"
                                   REFERENCE-RECORD
                                   (list "!!!RKY: 0.55")
                                   24)
                           (record "!!!T33: 1"
                                   REFERENCE-RECORD
                                   (list "!!!T33: 1")
                                   25)
                           (record "!!!T35: 0"
                                   REFERENCE-RECORD
                                   (list "!!!T35: 0")
                                   26))))

; hfile->los
(check-expect (hfile->los (hfile empty)) empty)
(check-expect (hfile->los (hfile (list (record "!!!COM: Berg, Alban"
                                               REFERENCE-RECORD
                                               (list "!!!COM: Berg, Alban")
                                               0))))
                          (list "!!!COM: Berg, Alban"))
(check-expect (hfile->los
                (hfile
                  (list
                    (record "!!!COM: Berg, Alban"
                            REFERENCE-RECORD
                            (list "!!!COM: Berg, Alban")
                            0)
                    (record "**pc\t**kern"
                            TOKEN
                            (list (token "**pc" EXCLUSIVE-INTERPRETATION 1 0)
                                  (token "**kern" EXCLUSIVE-INTERPRETATION 1 1))
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
