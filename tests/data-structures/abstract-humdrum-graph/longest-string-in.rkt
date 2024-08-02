#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: AbstractHumdrumGraph
;;    tests for longest-string-in
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require
  (only-in "../../../parser/functions/file.rkt"
           path->hfile)
  "../../../data-structures/abstract-humdrum-graph/data-definitions/data-definitions.rkt"
  "../../../data-structures/abstract-humdrum-graph/functions/hfile-to-ab-hgraph.rkt"
  "../../../data-structures/abstract-humdrum-graph/functions/longest-string-in.rkt"
  test-engine/racket-tests)

(define three-spines-path "../data/three-spines-two-splits-not-consecutive.krn")
(define three-spines-no-splits (hfile->ab-hgraph (path->hfile three-spines-path)
                                                 ab-hgraph))

; longest-string-in
(check-expect (longest-string-in three-spines-no-splits) "2.C#] 2.B]")

(test)
