#lang racket

#|
	Tests for file functions.
|#

(require "../../parser/HumdrumSyntax.rkt"
         "../../parser/file-fn.rkt"
         test-engine/racket-tests)

(define BERG-PATH (string-append HUM-PARSER-PATH "/tests/parser/data/berg01.pc"))

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

#|
; write-file
(check-expect (write-file
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
                      "!!!T35: 0")
                (string-append HUM-PARSER-PATH "/tests/parser/data/berg01-write-file-test.krn"))
              (void))
(check-expect (read-file (string-append HUM-PARSER-PATH "/tests/parser/data/berg01-write-file-test.krn"))
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
|#

; path->hfile
(check-expect (path->hfile BERG-PATH)
              (hfile (list (record "!!!COM: Berg, Alban"
                                   'Reference
                                   (list "!!!COM: Berg, Alban")
                                   0)
                           (record "!!!OTL: Chamber Concerto"
                                   'Reference
                                   (list "!!!OTL: Chamber Concerto")
                                   1)
                           (record "!!!OMV: Movements 1 and 3"
                                   'Reference
                                   (list "!!!OMV: Movements 1 and 3")
                                   2)
                           (record "!!!ODT: 1925"
                                   'Reference
                                   (list "!!!ODT: 1925")
                                   3)
                           (record "!!!ONB: In German, the last 8 notes are the capitalized letters in ArnolD SCHoenBErG."
                                   'Reference
                                   (list "!!!ONB: In German, the last 8 notes are the capitalized letters in ArnolD SCHoenBErG.")
                                   4)
                           (record "**pc\t**kern"
                                   'ExclusiveInterpretation
                                   (list (token "**pc" 'ExclusiveInterpretation 5 0)
                                         (token "**kern" 'ExclusiveInterpretation 5 1))
                                   5)
                           (record "*X:\t*X:"
                                   'TandemInterpretation
                                   (list (token "*X:" 'KeyLabel 6 0)
                                         (token "*X:" 'KeyLabel 6 1))
                                   6)
                           (record "0\tF"
                                   'Token
                                   (list (token "0" 'SpineData 7 0)
                                         (token "F" 'SpineData 7 1))
                                   7)
                           (record "1\tF#"
                                   'Token
                                   (list (token "1" 'SpineData 8 0)
                                         (token "F#" 'SpineData 8 1))
                                   8)
                           (record "3\tG#"
                                   'Token
                                   (list (token "3" 'SpineData 9 0)
                                         (token "G#" 'SpineData 9 1))
                                   9)
                           (record "8\tC#"
                                   'Token
                                   (list (token "8" 'SpineData 10 0)
                                         (token "C#" 'SpineData 10 1))
                                   10)
                           (record "4\tA"
                                   'Token
                                   (list (token "4" 'SpineData 11 0)
                                         (token "A" 'SpineData 11 1))
                                   11)
                           (record "9\tD"
                                   'Token
                                   (list (token "9" 'SpineData 12 0)
                                         (token "D" 'SpineData 12 1))
                                   12)
                           (record "10\tE-"
                                   'Token
                                   (list (token "10" 'SpineData 13 0)
                                         (token "E-" 'SpineData 13 1))
                                   13)
                           (record "7\tC"
                                   'Token
                                   (list (token "7" 'SpineData 14 0)
                                         (token "C" 'SpineData 14 1))
                                   14)
                           (record "6\tB"
                                   'Token
                                   (list (token "6" 'SpineData 15 0)
                                         (token "B" 'SpineData 15 1))
                                   15)
                           (record "5\tB-"
                                   'Token
                                   (list (token "5" 'SpineData 16 0)
                                         (token "B-" 'SpineData 16 1))
                                   16)
                           (record "11\tE"
                                   'Token
                                   (list (token "11" 'SpineData 17 0)
                                         (token "E" 'SpineData 17 1))
                                   17)
                           (record "2\tG"
                                   'Token
                                   (list (token "2" 'SpineData 18 0)
                                         (token "G" 'SpineData 18 1))
                                   18)
                           (record "*-\t*-"
                                   'TandemInterpretation
                                   (list (token "*-" 'SpineTerminator 19 0)
                                         (token "*-" 'SpineTerminator 19 1))
                                   19)
                           (record "!!!YOR: Dave Headlam, The Music of Alban Berg (New Haven, CT: Yale University Press, 1996), p. 391"
                                   'Reference
                                   (list "!!!YOR: Dave Headlam, The Music of Alban Berg (New Haven, CT: Yale University Press, 1996), p. 391")
                                   20)
                           (record "!!!ref: @{COM}: <i>@{OTL}</i> (@{ODT}), @{OMV} <br>@{ONB}"
                                   'Reference
                                   (list "!!!ref: @{COM}: <i>@{OTL}</i> (@{ODT}), @{OMV} <br>@{ONB}")
                                   21)
                           (record "!!!SEM: This row contains 4 instances of the semitone interval class."
                                   'Reference
                                   (list "!!!SEM: This row contains 4 instances of the semitone interval class.")
                                   22)
                           (record "!!!AIR: This is an all-interval row."
                                   'Reference
                                   (list "!!!AIR: This is an all-interval row.")
                                   23)
                           (record "!!!RKY: 0.55"
                                   'Reference
                                   (list "!!!RKY: 0.55")
                                   24)
                           (record "!!!T33: 1"
                                   'Reference
                                   (list "!!!T33: 1")
                                   25)
                           (record "!!!T35: 0"
                                   'Reference
                                   (list "!!!T35: 0")
                                   26))))

; hfile->strings
(check-expect (hfile->strings (hfile empty)) empty)
(check-expect (hfile->strings (hfile (list (record "!!!COM: Berg, Alban"
                                               'Reference
                                               (list "!!!COM: Berg, Alban")
                                               0))))
                          (list "!!!COM: Berg, Alban"))
(check-expect (hfile->strings
                (hfile
                  (list
                    (record "!!!COM: Berg, Alban"
                            'Reference
                            (list "!!!COM: Berg, Alban")
                            0)
                    (record "**pc\t**kern"
                            'Token
                            (list (token "**pc" 'ExclusiveInterpretation 1 0)
                                  (token "**kern" 'ExclusiveInterpretation 1 1))
                            1))))
              (list "!!!COM: Berg, Alban" "**pc\t**kern"))

; build-filenames
(check-expect (build-filenames "scriabin-op11_no" ".krn" 24)
              (list "scriabin-op11_no01.krn"
                    "scriabin-op11_no02.krn"
                    "scriabin-op11_no03.krn"
                    "scriabin-op11_no04.krn"
                    "scriabin-op11_no05.krn"
                    "scriabin-op11_no06.krn"
                    "scriabin-op11_no07.krn"
                    "scriabin-op11_no08.krn"
                    "scriabin-op11_no09.krn"
                    "scriabin-op11_no10.krn"
                    "scriabin-op11_no11.krn"
                    "scriabin-op11_no12.krn"
                    "scriabin-op11_no13.krn"
                    "scriabin-op11_no14.krn"
                    "scriabin-op11_no15.krn"
                    "scriabin-op11_no16.krn"
                    "scriabin-op11_no17.krn"
                    "scriabin-op11_no18.krn"
                    "scriabin-op11_no19.krn"
                    "scriabin-op11_no20.krn"
                    "scriabin-op11_no21.krn"
                    "scriabin-op11_no22.krn"
                    "scriabin-op11_no23.krn"
                    "scriabin-op11_no24.krn"))

; build-paths
(check-expect (build-paths "~/Mysterium/op11/"
                           (build-filenames "scriabin-op11_no" ".krn" 24))
              (list "~/Mysterium/op11/scriabin-op11_no01.krn"
                    "~/Mysterium/op11/scriabin-op11_no02.krn"
                    "~/Mysterium/op11/scriabin-op11_no03.krn"
                    "~/Mysterium/op11/scriabin-op11_no04.krn"
                    "~/Mysterium/op11/scriabin-op11_no05.krn"
                    "~/Mysterium/op11/scriabin-op11_no06.krn"
                    "~/Mysterium/op11/scriabin-op11_no07.krn"
                    "~/Mysterium/op11/scriabin-op11_no08.krn"
                    "~/Mysterium/op11/scriabin-op11_no09.krn"
                    "~/Mysterium/op11/scriabin-op11_no10.krn"
                    "~/Mysterium/op11/scriabin-op11_no11.krn"
                    "~/Mysterium/op11/scriabin-op11_no12.krn"
                    "~/Mysterium/op11/scriabin-op11_no13.krn"
                    "~/Mysterium/op11/scriabin-op11_no14.krn"
                    "~/Mysterium/op11/scriabin-op11_no15.krn"
                    "~/Mysterium/op11/scriabin-op11_no16.krn"
                    "~/Mysterium/op11/scriabin-op11_no17.krn"
                    "~/Mysterium/op11/scriabin-op11_no18.krn"
                    "~/Mysterium/op11/scriabin-op11_no19.krn"
                    "~/Mysterium/op11/scriabin-op11_no20.krn"
                    "~/Mysterium/op11/scriabin-op11_no21.krn"
                    "~/Mysterium/op11/scriabin-op11_no22.krn"
                    "~/Mysterium/op11/scriabin-op11_no23.krn"
                    "~/Mysterium/op11/scriabin-op11_no24.krn"))

(test)
