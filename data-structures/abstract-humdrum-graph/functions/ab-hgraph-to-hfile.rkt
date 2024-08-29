#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data-structures: AbstractHumdrumGraph
;;    ab-hgraph-to-hfile: converts an AbstractHumdrumGraph
;;        to a HumdrumFile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#|
  This function only assembles data in the given AbstractHumdrumGraph. Non-token records filtered
  out when AbstractHumdrumGraph was created are not inserted, so resultant HumdrumFile may be
  smaller than original.
|#

(require racket/list
         racket/local
         "../../../parser/data-definitions/data-definitions.rkt"
         "../../../parser/functions/type.rkt"
         "../../../parser/functions/split-and-gather.rkt"
         "../data-definitions/data-definitions.rkt")

(provide (all-defined-out))

; ab-graph->hfile
; AbstractHumdrumGraph -> HumdrumFile
; converts the graph to a HumdrumFile

(define (ab-hgraph->hfile ab-hgraph)
  (hfile
    (lolot->lor
      (ab-hgraph->lolot ab-hgraph))))

; lolot->lor
; (listof (listof Token)) -> (listof Record)
; converts the token lists to a (listof Record)

(define (lolot->lor lolot)
  (local [(define (lot->r lot)
            (local [(define r (gather (map token-token lot)))]
              (record r
                      (type-record r)
                      lot
                      (token-record-number (first lot)))))]
    (map lot->r lolot)))

; ab-graph->lolot
; AbstractHumdrumGraph -> (listof (listof Token))
; converts the graph to a (listof (listof Token))

(define (ab-hgraph->lolot ab-hgraph)
  (local [; Root -> (listof Record)
          (define (fn-for-root root)
                    ; acc. (listof (listof Node)). the rest of each branch.
                    ; rec. (listof Token). the nodes at one level.
                    ; lor. (listof Record). the records from previous cuts.
            (local [(define (iterator branches acc rec lor)
                      (cond [(and (empty? branches) (empty? acc)) (reverse lor)]
                            [(and (empty? branches)
                                  (not (empty? acc))) (iterator (reverse acc)
                                                                empty
                                                                (cons (reverse rec) lor))]
                            [else
                              (local [(define fof (first (first branches)))

                                      (define result
                                              (cond [(leaf? fof)
                                                     (fn-for-leaf fof)]
                                                    [(parent? fof)
                                                     (fn-for-leaf
                                                       (parent-token fof))]))]
                                (iterator (rest branches)
                                          (if (parent? fof)
                                              (cons (rest (parent-right fof))
                                                (cons (rest (parent-left fof))
                                                  acc))
                                              (cons (rest (first branches)) acc))
                                          (cons fof rec)
                                          lor))]))]
              (iterator (root-branches root) empty empty empty)))

          (define (fn-for-leaf leaf)
            (leaf-token leaf))]
    (fn-for-root (abstract-humdrum-graph-root ab-hgraph))))
