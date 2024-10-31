#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: AbstractHumdrumGraph
;;    tests for longest-string-in
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require
  (only-in "../../../../parser/functions/file.rkt"
           path->hfile)
  "../../../../parser/data-structures/humdrum-graph/functions/hfile-to-hgraph.rkt"
  "../../../../parser/data-structures/humdrum-graph/functions/longest-string-in.rkt"
  test-engine/racket-tests)

(define three-spines-path "../data/three-spines-two-splits-not-consecutive.krn")
(define three-spines-no-splits (hfile->hgraph (path->hfile three-spines-path)))

; longest-string-in
(check-expect (longest-string-in three-spines-no-splits) "2.C#] 2.B]")

(test)
