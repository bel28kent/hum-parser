#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data-structures: AbstractHumdrumGraph
;;    tests for ab-hgraph-to-hfile.rkt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../../parser/data-definitions/data-definitions.rkt"
         "../../../../parser/functions/file.rkt"
         "../../../../parser/data-structures/humdrum-graph/data-definitions/data-definitions.rkt"
         "../../../../parser/data-structures/humdrum-graph/functions/hfile-to-hgraph.rkt"
         "../../../../parser/data-structures/humdrum-graph/functions/hgraph-to-hfile.rkt"
         test-engine/racket-tests)

(define two-spines-both-split-hgraph (hfile->hgraph
                                      (path->hfile "../data/two-spines-both-split.krn")))

; hgraph->hfile
; HumdrumGraph -> HumdrumFile
; converts the graph to a HumdrumFile
(check-expect (hgraph->hfile two-spines-both-split-hgraph)
              (hfile (list (record "**kern\t**dynam"
                                   TOKEN
                                   (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0)
                                         (token "**dynam" EXCLUSIVE-INTERPRETATION 0 1))
                                   0)
                           (record "*clefG2\t*"
                                   TOKEN
                                   (list (token "*clefG2" CLEF 1 0)
                                         (token "*" NULL-INTERPRETATION 1 1))
                                   1)
                           (record "*k[]\t*"
                                   TOKEN
                                   (list (token "*k[]" KEY-SIG 2 0)
                                         (token "*" NULL-INTERPRETATION 2 1))
                                   2)
                           (record "*a:\t*"
                                   TOKEN
                                   (list (token "*a:" KEY-LABEL 3 0)
                                         (token "*" NULL-INTERPRETATION 3 1))
                                   3)
                           (record "*M1/4\t*"
                                   TOKEN
                                   (list (token "*M1/4" TIME-SIG 4 0)
                                         (token "*" NULL-INTERPRETATION 4 1))
                                   4)
                           (record "*\t*^"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 5 0)
                                         (token "*^" SPINE-SPLIT 5 1))
                                   5)
                           (record "4a\tp\tpp"
                                   TOKEN
                                   (list (token "4a" SPINE-DATA 6 0)
                                         (token "p" SPINE-DATA 6 1)
                                         (token "pp" SPINE-DATA 6 2))
                                   6)
                           (record "=2\t=2\t=2"
                                   TOKEN
                                   (list (token "=2" MEASURE 7 0)
                                         (token "=2" MEASURE 7 1)
                                         (token "=2" MEASURE 7 2))
                                   7)
                           (record "*^\t*\t*"
                                   TOKEN
                                   (list (token "*^" SPINE-SPLIT 8 0)
                                         (token "*" NULL-INTERPRETATION 8 1)
                                         (token "*" NULL-INTERPRETATION 8 2))
                                   8)
                           (record "4b\t4bb\tf\tff"
                                   TOKEN
                                   (list (token "4b" SPINE-DATA 9 0)
                                         (token "4bb" SPINE-DATA 9 1)
                                         (token "f" SPINE-DATA 9 2)
                                         (token "ff" SPINE-DATA 9 3))
                                   9)
                           (record "=3\t=3\t=3\t=3"
                                   TOKEN
                                   (list (token "=3" MEASURE 10 0)
                                         (token "=3" MEASURE 10 1)
                                         (token "=3" MEASURE 10 2)
                                         (token "=3" MEASURE 10 3))
                                   10)
                           (record "4a\t4aa\t.\tff"
                                   TOKEN
                                   (list (token "4a" SPINE-DATA 11 0)
                                         (token "4aa" SPINE-DATA 11 1)
                                         (token "." NULL-SPINE-DATA 11 2)
                                         (token "ff" SPINE-DATA 11 3))
                                   11)
                           (record "*\t*\t*v\t*v"
                                   TOKEN
                                   (list (token "*" NULL-INTERPRETATION 12 0)
                                         (token "*" NULL-INTERPRETATION 12 1)
                                         (token "*v" SPINE-JOIN 12 2)
                                         (token "*v" SPINE-JOIN 12 3))
                                   12)
                           (record "*v\t*v\t*"
                                   TOKEN
                                   (list (token "*v" SPINE-JOIN 13 0)
                                         (token "*v" SPINE-JOIN 13 1)
                                         (token "*" NULL-INTERPRETATION 13 2))
                                   13)
                          (record "==\t=="
                                   TOKEN
                                  (list (token "==" MEASURE 14 0)
                                        (token "==" MEASURE 14 1))
                                  14)
                           (record "*-\t*-"
                                   TOKEN
                                   (list (token "*-" SPINE-TERMINATOR 15 0)
                                         (token "*-" SPINE-TERMINATOR 15 1))
                                   15))))

; lolot->lor
; (listof (listof Token)) -> (listof Record)
; converts the token lists to a (listof Record)
(check-expect (lolot->lor (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0)
                                      (token "**dynam" EXCLUSIVE-INTERPRETATION 0 1))
                                (list (token "*clefG2" CLEF 1 0)
                                      (token "*" NULL-INTERPRETATION 1 1))
                                (list (token "*k[]" KEY-SIG 2 0)
                                      (token "*" NULL-INTERPRETATION 2 1))
                                (list (token "*a:" KEY-LABEL 3 0)
                                      (token "*" NULL-INTERPRETATION 3 1))
                                (list (token "*M1/4" TIME-SIG 4 0)
                                      (token "*" NULL-INTERPRETATION 4 1))
                                (list (token "*" NULL-INTERPRETATION 5 0)
                                      (token "*^" SPINE-SPLIT 5 1))
                                (list (token "4a" SPINE-DATA 6 0)
                                      (token "p" SPINE-DATA 6 1)
                                      (token "pp" SPINE-DATA 6 2))
                                (list (token "=2" MEASURE 7 0)
                                      (token "=2" MEASURE 7 1)
                                      (token "=2" MEASURE 7 2))
                                (list (token "*^" SPINE-SPLIT 8 0)
                                      (token "*" NULL-INTERPRETATION 8 1)
                                      (token "*" NULL-INTERPRETATION 8 2))
                                (list (token "4b" SPINE-DATA 9 0)
                                      (token "4bb" SPINE-DATA 9 1)
                                      (token "f" SPINE-DATA 9 2)
                                      (token "ff" SPINE-DATA 9 3))
                                (list (token "=3" MEASURE 10 0)
                                      (token "=3" MEASURE 10 1)
                                      (token "=3" MEASURE 10 2)
                                      (token "=3" MEASURE 10 3))
                                (list (token "4a" SPINE-DATA 11 0)
                                      (token "4aa" SPINE-DATA 11 1)
                                      (token "." NULL-SPINE-DATA 11 2)
                                      (token "ff" SPINE-DATA 11 3))
                                (list (token "*" NULL-INTERPRETATION 12 0)
                                      (token "*" NULL-INTERPRETATION 12 1)
                                      (token "*v" SPINE-JOIN 12 2)
                                      (token "*v" SPINE-JOIN 12 3))
                                (list (token "*v" SPINE-JOIN 13 0)
                                      (token "*v" SPINE-JOIN 13 1)
                                      (token "*" NULL-INTERPRETATION 13 2))
                                (list (token "==" MEASURE 14 0)
                                      (token "==" MEASURE 14 1))
                                (list (token "*-" SPINE-TERMINATOR 15 0)
                                      (token "*-" SPINE-TERMINATOR 15 1))))
              (list (record "**kern\t**dynam"
                            TOKEN
                            (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0)
                                  (token "**dynam" EXCLUSIVE-INTERPRETATION 0 1))
                            0)
                    (record "*clefG2\t*"
                            TOKEN
                            (list (token "*clefG2" CLEF 1 0)
                                  (token "*" NULL-INTERPRETATION 1 1))
                            1)
                    (record "*k[]\t*"
                            TOKEN
                            (list (token "*k[]" KEY-SIG 2 0)
                                  (token "*" NULL-INTERPRETATION 2 1))
                            2)
                    (record "*a:\t*"
                            TOKEN
                            (list (token "*a:" KEY-LABEL 3 0)
                                  (token "*" NULL-INTERPRETATION 3 1))
                            3)
                    (record "*M1/4\t*"
                            TOKEN
                            (list (token "*M1/4" TIME-SIG 4 0)
                                  (token "*" NULL-INTERPRETATION 4 1))
                            4)
                    (record "*\t*^"
                            TOKEN
                            (list (token "*" NULL-INTERPRETATION 5 0)
                                  (token "*^" SPINE-SPLIT 5 1))
                            5)
                    (record "4a\tp\tpp"
                            TOKEN
                            (list (token "4a" SPINE-DATA 6 0)
                                  (token "p" SPINE-DATA 6 1)
                                  (token "pp" SPINE-DATA 6 2))
                            6)
                    (record "=2\t=2\t=2"
                            TOKEN
                            (list (token "=2" MEASURE 7 0)
                                  (token "=2" MEASURE 7 1)
                                  (token "=2" MEASURE 7 2))
                            7)
                    (record "*^\t*\t*"
                            TOKEN
                            (list (token "*^" SPINE-SPLIT 8 0)
                                  (token "*" NULL-INTERPRETATION 8 1)
                                  (token "*" NULL-INTERPRETATION 8 2))
                            8)
                    (record "4b\t4bb\tf\tff"
                            TOKEN
                            (list (token "4b" SPINE-DATA 9 0)
                                  (token "4bb" SPINE-DATA 9 1)
                                  (token "f" SPINE-DATA 9 2)
                                  (token "ff" SPINE-DATA 9 3))
                            9)
                    (record "=3\t=3\t=3\t=3"
                            TOKEN
                            (list (token "=3" MEASURE 10 0)
                                  (token "=3" MEASURE 10 1)
                                  (token "=3" MEASURE 10 2)
                                  (token "=3" MEASURE 10 3))
                            10)
                    (record "4a\t4aa\t.\tff"
                            TOKEN
                            (list (token "4a" SPINE-DATA 11 0)
                                  (token "4aa" SPINE-DATA 11 1)
                                  (token "." NULL-SPINE-DATA 11 2)
                                  (token "ff" SPINE-DATA 11 3))
                            11)
                    (record "*\t*\t*v\t*v"
                            TOKEN
                            (list (token "*" NULL-INTERPRETATION 12 0)
                                  (token "*" NULL-INTERPRETATION 12 1)
                                  (token "*v" SPINE-JOIN 12 2)
                                  (token "*v" SPINE-JOIN 12 3))
                            12)
                    (record "*v\t*v\t*"
                            TOKEN
                            (list (token "*v" SPINE-JOIN 13 0)
                                  (token "*v" SPINE-JOIN 13 1)
                                  (token "*" NULL-INTERPRETATION 13 2))
                            13)
                   (record "==\t=="
                            TOKEN
                           (list (token "==" MEASURE 14 0)
                                 (token "==" MEASURE 14 1))
                           14)
                    (record "*-\t*-"
                            TOKEN
                            (list (token "*-" SPINE-TERMINATOR 15 0)
                                  (token "*-" SPINE-TERMINATOR 15 1))
                            15)))

; hgraph->lolot
; HumdrumGraph -> (listof (listof Token))
; converts the graph to a (listof (listof Token))
(check-expect (hgraph->lolot two-spines-both-split-hgraph)
              (list (list (token "**kern" EXCLUSIVE-INTERPRETATION 0 0)
                          (token "**dynam" EXCLUSIVE-INTERPRETATION 0 1))
                    (list (token "*clefG2" CLEF 1 0)
                          (token "*" NULL-INTERPRETATION 1 1))
                    (list (token "*k[]" KEY-SIG 2 0)
                          (token "*" NULL-INTERPRETATION 2 1))
                    (list (token "*a:" KEY-LABEL 3 0)
                          (token "*" NULL-INTERPRETATION 3 1))
                    (list (token "*M1/4" TIME-SIG 4 0)
                          (token "*" NULL-INTERPRETATION 4 1))
                    (list (token "*" NULL-INTERPRETATION 5 0)
                          (token "*^" SPINE-SPLIT 5 1))
                    (list (token "4a" SPINE-DATA 6 0)
                          (token "p" SPINE-DATA 6 1)
                          (token "pp" SPINE-DATA 6 2))
                    (list (token "=2" MEASURE 7 0)
                          (token "=2" MEASURE 7 1)
                          (token "=2" MEASURE 7 2))
                    (list (token "*^" SPINE-SPLIT 8 0)
                          (token "*" NULL-INTERPRETATION 8 1)
                          (token "*" NULL-INTERPRETATION 8 2))
                    (list (token "4b" SPINE-DATA 9 0)
                          (token "4bb" SPINE-DATA 9 1)
                          (token "f" SPINE-DATA 9 2)
                          (token "ff" SPINE-DATA 9 3))
                    (list (token "=3" MEASURE 10 0)
                          (token "=3" MEASURE 10 1)
                          (token "=3" MEASURE 10 2)
                          (token "=3" MEASURE 10 3))
                    (list (token "4a" SPINE-DATA 11 0)
                          (token "4aa" SPINE-DATA 11 1)
                          (token "." NULL-SPINE-DATA 11 2)
                          (token "ff" SPINE-DATA 11 3))
                    (list (token "*" NULL-INTERPRETATION 12 0)
                          (token "*" NULL-INTERPRETATION 12 1)
                          (token "*v" SPINE-JOIN 12 2)
                          (token "*v" SPINE-JOIN 12 3))
                    (list (token "*v" SPINE-JOIN 13 0)
                          (token "*v" SPINE-JOIN 13 1)
                          (token "*" NULL-INTERPRETATION 13 2))
                    (list (token "==" MEASURE 14 0)
                          (token "==" MEASURE 14 1))
                    (list (token "*-" SPINE-TERMINATOR 15 0)
                          (token "*-" SPINE-TERMINATOR 15 1))))

(test)
