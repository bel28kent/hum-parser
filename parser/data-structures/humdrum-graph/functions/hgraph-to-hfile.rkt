#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data-structures: HumdrumGraph
;;    hgraph-to-hfile: converts a HumdrumGraph to HumdrumFile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#|
  This function only assembles data in the given HumdrumGraph. Non-token records filtered
  out when the HumdrumGraph was created are not inserted, so resultant HumdrumFile may be
  smaller than original.
|#

(require racket/list
         racket/local
         "../../../parser/data-definitions/data-definitions.rkt"
         "../../../parser/functions/type.rkt"
         "../../../parser/functions/split-and-gather.rkt"
         "../data-definitions/data-definitions.rkt")

(provide (all-defined-out))

; hgraph->hfile
; HumdrumGraph -> HumdrumFile
; converts the graph to a HumdrumFile

(define (hgraph->hfile hgraph)
  (hfile
    (lolot->lor
      (hgraph->lolot hgraph))))

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

; hgraph->lolot
; HumdrumGraph -> (listof (listof Token))
; converts the graph to a (listof (listof Token))

(define (hgraph->lolot hgraph)
  (local [; Root -> (listof Record)
          (define (fn-for-root root)
                    ; acc. (listof (listof Node)). the rest of each branch.
                    ; rec. (listof Token). the nodes at one level.
                    ; lolot. (listof (listof Token)). the (listof Token) from previous cuts.
            (local [(define (iterator branches acc rec lolot)
                      (cond [(and (empty? branches) (empty? acc)) (reverse
                                                                    (cons (reverse rec) lolot))]
                            [(and (empty? branches)
                                  (not (empty? acc))) (iterator (reverse acc)
                                                                empty
                                                                empty
                                                                (cons (reverse rec) lolot))]
                            [else
                              (local [(define fof (first (first branches)))
                                      (define t (cond [(leaf? fof) (leaf-token fof)]
                                                      [(parent-token fof)]))
                                      (define rof (rest (first branches)))]
                                (iterator (rest branches)
                                          (cond [(parent? fof) (cons (parent-right fof)
                                                                 (cons (append (parent-left fof)
                                                                               rof)
                                                                   acc))]
                                                [(not (empty? rof)) (cons rof acc)]
                                                [acc])
                                          (cons t rec)
                                          lolot))]))]
              (iterator (root-branches root) empty empty empty)))]
    (fn-for-root (humdrum-graph-root hgraph))))
