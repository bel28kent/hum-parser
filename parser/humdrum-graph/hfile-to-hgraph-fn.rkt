#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumGraph
;;    hfile->hgraph: Converts HumdrumFile to HumdrumGraph
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/list
         racket/local
         "../../../../parser/data-definitions/data-definitions.rkt"
         (only-in "../../../../parser/functions/predicates.rkt"
                  spine-split? spine-join? null-interpretation?)
         (only-in "../../../../parser/functions/spine-parser.rkt"
                  spine-parser)
         "../../../../parser/data-structures/linked-spine/data-definitions/data-definitions.rkt"
         "../../../../parser/data-structures/linked-spine/functions/gspines-to-linked-spines.rkt"
         "../../../../parser/data-structures/humdrum-graph/data-definitions/data-definitions.rkt")

(provide hfile->hgraph)

; hfile->hgraph
; HumdrumFile -> HumdrumGraph
; converts the HumdrumFile to a HumdrumGraph

(define (hfile->hgraph hfile)
  (local [(define linked-spines (gspines->linked-spines (spine-parser hfile) hfile))

          ; LinkedSpine -> (listof Node)
          (define (linked-spine->branch l-spine)
            ())]
    (hgraph (root (map linked-spine->branch linked-spines)))))
