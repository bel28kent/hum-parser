#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data-structures: AbstractHumdrumGraph
;;    tests for ab-hgraph-to-hfile.rkt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         "../../../parser/functions/file.rkt"
         "../../../data-structures/abstract-humdrum-graph/data-definitions/data-definitions.rkt"
         "../../../data-structures/abstract-humdrum-graph/functions/hfile-to-ab-hgraph.rkt"
         "../../../data-structures/abstract-humdrum-graph/functions/ab-hgraph-to-hfile.rkt"
         test-engine/racket-tests)

(define two-spines-both-split-ab-hgraph (hfile->ab-hgraph
                                          (path->hfile "../data/two-spines-both-split.krn")
                                          ab-hgraph))

; ab-graph->hfile
; AbstractHumdrumGraph -> HumdrumFile
; converts the graph to a HumdrumFile
(check-expect (ab-hgraph->hfile two-spines-both-split-ab-hgraph)
              (hfile (list (record "**kern\t**dynam"
                                   TOKEN
                                   (list (token "**kern" EXCLUSIVE-INTERPRETATION 0)
                                         (token "**dynam" EXCLUSIVE-INTERPRETATION 0))
                                   0)
                           (record "*clefG2\t*"
                                   TOKEN
                                   (list (token "*clefG2" CLEF 1)
                                         (token "*" NULL-INTERPRETATION 1))
                                   1)
                           (record "*k[]\t*"
                                   TOKEN
                                   (list (token "*k[]" KEY-SIG 2)
                                         (token "*" NULL-INTERPRETATION 2))
                                   2)
                           (record "*a:\t*"
                                   TOKEN
                                   (list (token "*a:" KEY-LABEL 3)
                                         (token "*" NULL-INTERPRETATION 3))
                                   3)
                           (record "*M1/4\t*"
                                   TOKEN
                                   (list (token "*M1/4" TIME-SIG 4)
                                         (token "*" NULL-INTERPRETATION 4))
                                   4)
                           (record "*\t*^"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 5)
                                         (token "*^" SPINE-SPLIT 5))
                                   5)
                           (record "4a\tp\tpp"
                                   TOKEN
                                   (list (token "4a" SPINE-DATA 6)
                                         (token "p" SPINE-DATA 6)
                                         (token "pp" SPINE-DATA 6))
                                   6)
                           (record "=2\t=2\t=2"
                                   TOKEN
                                   (list (token "=2" MEASURE 7)
                                         (token "=2" MEASURE 7)
                                         (token "=2" MEASURE 7))
                                   7)
                           (record "*^\t*\t*"
                                   TOKEN
                                   (list (token "*^" SPINE-SPLIT 8)
                                         (token "*" NULL-INTERPRETATION 8)
                                         (token "*" NULL-INTERPRETATION 8))
                                   8)
                           (record "4b\t4bb\tf\tff"
                                   TOKEN
                                   (list (token "4b" SPINE-DATA 9)
                                         (token "4bb" SPINE-DATA 9)
                                         (token "f" SPINE-DATA 9)
                                         (token "ff" SPINE-DATA 9))
                                   9)
                           (record "=3\t=3\t=3\t=3"
                                   TOKEN
                                   (list (token "=3" MEASURE 10)
                                         (token "=3" MEASURE 10)
                                         (token "=3" MEASURE 10)
                                         (token "=3" MEASURE 10))
                                   10)
                           (record "4a\t4aa\t.\tff"
                                   TOKEN
                                   (list (token "4a" SPINE-DATA 11)
                                         (token "4aa" SPINE-DATA 11)
                                         (token "." NULL-SPINE-DATA 11)
                                         (token "ff" SPINE-DATA 11))
                                   11)
                           (record "*\t*\t*v\t*v"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 12)
                                         (token "*" NULL-INTERPRETATION 12)
                                         (token "*v" SPINE-JOIN 12)
                                         (token "*v" SPINE-JOIN 12))
                                   12)
                           (record "*v\t*v\t*"
                                   TOKEN
                                   (list (token "*v" SPINE-JOIN 13)
                                         (token "*v" SPINE-JOIN 13)
                                         (token "*" NULL-INTERPRETATION 13))
                                   13)
                          (record "==\t=="
                                   TOKEN
                                  (list (token "==" MEASURE 14)
                                        (token "==" MEASURE 14))
                                  14)
                           (record "*-\t*-"
                                   TOKEN
                                   (list (token "*-" SPINE-TERMINATOR 15)
                                         (token "*-" SPINE-TERMINATOR 15))
                                   15))))

; lolot->lor
; (listof (listof Token)) -> (listof Record)
; converts the token lists to a (listof Record)
(check-expect (lolot->lor (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0)
                                      (token "**dynam" EXCLUSIVE-INTERPRETATION 0))
                                (list (token "*clefG2" CLEF 1)
                                      (token "*" NULL-INTERPRETATION 1))
                                (list (token "*k[]" KEY-SIG 2)
                                      (token "*" NULL-INTERPRETATION 2))
                                (list (token "*a:" KEY-LABEL 3)
                                      (token "*" NULL-INTERPRETATION 3))
                                (list (token "*M1/4" TIME-SIG 4)
                                      (token "*" NULL-INTERPRETATION 4))
                                (list (token "*" NULL-INTERPRETATION 5)
                                      (token "*^" SPINE-SPLIT 5))
                                (list (token "4a" SPINE-DATA 6)
                                      (token "p" SPINE-DATA 6)
                                      (token "pp" SPINE-DATA 6))
                                (list (token "=2" MEASURE 7)
                                      (token "=2" MEASURE 7)
                                      (token "=2" MEASURE 7))
                                (list (token "*^" SPINE-SPLIT 8)
                                      (token "*" NULL-INTERPRETATION 8)
                                      (token "*" NULL-INTERPRETATION 8))
                                (list (token "4b" SPINE-DATA 9)
                                      (token "4bb" SPINE-DATA 9)
                                      (token "f" SPINE-DATA 9)
                                      (token "ff" SPINE-DATA 9))
                                (list (token "=3" MEASURE 10)
                                      (token "=3" MEASURE 10)
                                      (token "=3" MEASURE 10)
                                      (token "=3" MEASURE 10))
                                (list (token "4a" SPINE-DATA 11)
                                      (token "4aa" SPINE-DATA 11)
                                      (token "." NULL-SPINE-DATA 11)
                                      (token "ff" SPINE-DATA 11))
                                (list (token "*" NULL-INTERPRETATION 12)
                                      (token "*" NULL-INTERPRETATION 12)
                                      (token "*v" SPINE-JOIN 12)
                                      (token "*v" SPINE-JOIN 12))
                                (list (token "*v" SPINE-JOIN 13)
                                      (token "*v" SPINE-JOIN 13)
                                      (token "*" NULL-INTERPRETATION 13))
                                (list (token "==" MEASURE 14)
                                      (token "==" MEASURE 14))
                                (list (token "*-" SPINE-TERMINATOR 15)
                                      (token "*-" SPINE-TERMINATOR 15))))
              (list (record "**kern\t**dynam"
                            TOKEN
                            (list (token "**kern" EXCLUSIVE-INTERPRETATION 0)
                                  (token "**dynam" EXCLUSIVE-INTERPRETATION 0))
                            0)
                    (record "*clefG2\t*"
                            TOKEN
                            (list (token "*clefG2" CLEF 1)
                                  (token "*" NULL-INTERPRETATION 1))
                            1)
                    (record "*k[]\t*"
                            TOKEN
                            (list (token "*k[]" KEY-SIG 2)
                                  (token "*" NULL-INTERPRETATION 2))
                            2)
                    (record "*a:\t*"
                            TOKEN
                            (list (token "*a:" KEY-LABEL 3)
                                  (token "*" NULL-INTERPRETATION 3))
                            3)
                    (record "*M1/4\t*"
                            TOKEN
                            (list (token "*M1/4" TIME-SIG 4)
                                  (token "*" NULL-INTERPRETATION 4))
                            4)
                    (record "*\t*^"
                            TOKEN
                            (list (token "*" NULL-INTERPRETATION 5)
                                  (token "*^" SPINE-SPLIT 5))
                            5)
                    (record "4a\tp\tpp"
                            TOKEN
                            (list (token "4a" SPINE-DATA 6)
                                  (token "p" SPINE-DATA 6)
                                  (token "pp" SPINE-DATA 6))
                            6)
                    (record "=2\t=2\t=2"
                            TOKEN
                            (list (token "=2" MEASURE 7)
                                  (token "=2" MEASURE 7)
                                  (token "=2" MEASURE 7))
                            7)
                    (record "*^\t*\t*"
                            TOKEN
                            (list (token "*^" SPINE-SPLIT 8)
                                  (token "*" NULL-INTERPRETATION 8)
                                  (token "*" NULL-INTERPRETATION 8))
                            8)
                    (record "4b\t4bb\tf\tff"
                            TOKEN
                            (list (token "4b" SPINE-DATA 9)
                                  (token "4bb" SPINE-DATA 9)
                                  (token "f" SPINE-DATA 9)
                                  (token "ff" SPINE-DATA 9))
                            9)
                    (record "=3\t=3\t=3\t=3"
                            TOKEN
                            (list (token "=3" MEASURE 10)
                                  (token "=3" MEASURE 10)
                                  (token "=3" MEASURE 10)
                                  (token "=3" MEASURE 10))
                            10)
                    (record "4a\t4aa\t.\tff"
                            TOKEN
                            (list (token "4a" SPINE-DATA 11)
                                  (token "4aa" SPINE-DATA 11)
                                  (token "." NULL-SPINE-DATA 11)
                                  (token "ff" SPINE-DATA 11))
                            11)
                    (record "*\t*\t*v\t*v"
                            TOKEN
                            (list (token "*" NULL-INTERPRETATION 12)
                                  (token "*" NULL-INTERPRETATION 12)
                                  (token "*v" SPINE-JOIN 12)
                                  (token "*v" SPINE-JOIN 12))
                            12)
                    (record "*v\t*v\t*"
                            TOKEN
                            (list (token "*v" SPINE-JOIN 13)
                                  (token "*v" SPINE-JOIN 13)
                                  (token "*" NULL-INTERPRETATION 13))
                            13)
                   (record "==\t=="
                            TOKEN
                           (list (token "==" MEASURE 14)
                                 (token "==" MEASURE 14))
                           14)
                    (record "*-\t*-"
                            TOKEN
                            (list (token "*-" SPINE-TERMINATOR 15)
                                  (token "*-" SPINE-TERMINATOR 15))
                            15)))

; ab-graph->lolot
; AbstractHumdrumGraph -> (listof (listof Token))
; converts the graph to a (listof (listof Token))
(check-expect (ab-hgraph->lolot two-spines-both-split-ab-hgraph)
              (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0)
                          (token "**dynam" EXCLUSIVE-INTERPRETATION 0))
                    (list (token "*clefG2" CLEF 1)
                          (token "*" NULL-INTERPRETATION 1))
                    (list (token "*k[]" KEY-SIG 2)
                          (token "*" NULL-INTERPRETATION 2))
                    (list (token "*a:" KEY-LABEL 3)
                          (token "*" NULL-INTERPRETATION 3))
                    (list (token "*M1/4" TIME-SIG 4)
                          (token "*" NULL-INTERPRETATION 4))
                    (list (token "*" NULL-INTERPRETATION 5)
                          (token "*^" SPINE-SPLIT 5))
                    (list (token "4a" SPINE-DATA 6)
                          (token "p" SPINE-DATA 6)
                          (token "pp" SPINE-DATA 6))
                    (list (token "=2" MEASURE 7)
                          (token "=2" MEASURE 7)
                          (token "=2" MEASURE 7))
                    (list (token "*^" SPINE-SPLIT 8)
                          (token "*" NULL-INTERPRETATION 8)
                          (token "*" NULL-INTERPRETATION 8))
                    (list (token "4b" SPINE-DATA 9)
                          (token "4bb" SPINE-DATA 9)
                          (token "f" SPINE-DATA 9)
                          (token "ff" SPINE-DATA 9))
                    (list (token "=3" MEASURE 10)
                          (token "=3" MEASURE 10)
                          (token "=3" MEASURE 10)
                          (token "=3" MEASURE 10))
                    (list (token "4a" SPINE-DATA 11)
                          (token "4aa" SPINE-DATA 11)
                          (token "." NULL-SPINE-DATA 11)
                          (token "ff" SPINE-DATA 11))
                    (list (token "*" NULL-INTERPRETATION 12)
                          (token "*" NULL-INTERPRETATION 12)
                          (token "*v" SPINE-JOIN 12)
                          (token "*v" SPINE-JOIN 12))
                    (list (token "*v" SPINE-JOIN 13)
                          (token "*v" SPINE-JOIN 13)
                          (token "*" NULL-INTERPRETATION 13))
                    (list (token "==" MEASURE 14)
                          (token "==" MEASURE 14))
                    (list (token "*-" SPINE-TERMINATOR 15)
                          (token "*-" SPINE-TERMINATOR 15))))

(test)
