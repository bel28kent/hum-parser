#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: LinkedSpine
;;    gspines->linked-spines: Converts a (listof GlobalSpine) to a (listof LinkedSpine)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/list
         racket/local
         "../../../../parser/data-definitions/data-definitions.rkt"
         "../../../../parser/functions/predicates.rkt"
         "../data-definitions/data-definitions.rkt")

(provide (all-defined-out))

; gspines->linked-spines
; (listof GlobalSpine) -> (listof LinkedSpine)
; produce a list of LinkedSpines

(define (gspines->linked-spines gspines)
  (local [; GlobalSpine -> LinkedSpine
          (define (gspine->linked-spine gspine)
            (linked-spine (fn-for-lolot (global-spine-tokens gspine))))

          ; (listof (listof Token)) -> Node
          ; Must go in reverse order because next must already be wrapped in a node type
          (define (fn-for-lolot lolot)
            ; reversed: (listof (listof Token)). the spines tokens, in reverse order
            ; next-nodes: (listof Node). the already wrapped tokens from the next record
            (local [(define (fn-for-lolot reversed next-nodes)
                      (cond [(empty? reversed) (first next-nodes)]
                            [else
                             (fn-for-lolot (rest reversed)
                                           (wrap-tokens (first reversed) next-nodes))]))]
              (fn-for-lolot (rest (reverse lolot))
                            (wrap-terminators (first (reverse lolot))))))

          ; (listof Token) -> (listof Node)
          (define (wrap-terminators lot)
            (map (λ (t) (node-box (box-immutable t))) lot))

          ; (listof Token) (listof Node) -> (listof Node)
          (define (wrap-tokens tokens next-nodes)
            (local [(define (wrap-tokens tokens)
                      (cond [(empty? tokens) empty]
                            [else
                             (cons (pair-token (first tokens) next-nodes)
                                   (wrap-tokens (rest tokens)))]))]
              (wrap-tokens tokens)))

          ; Token (listof Node) -> Node
          (define (pair-token token next-nodes)
            (cond [(spine-split? (token-token token)) (split-helper token next-nodes)]
                  [(spine-join? (token-token token)) (join-helper token next-nodes)]
                  [(null-interpretation? (token-token token)) (null-helper token next-nodes)]
                  [else
                   (token-node token (node-box (box (at-same-field-index token next-nodes))))]))

          ; Token (listof Node) -> Node
          (define (at-same-field-index token next-nodes)
            (local [(define index (token-field-index token))

                    (define (index=? n)
                      (cond [(token-node? n) (= index (token-field-index (token-node-token n)))]
                            [(split-node? n) (= index (token-field-index (split-node-token n)))]
                            [else
                             (= index (token-field-index (terminator-node-token n)))]))]
              (filter index=? next-nodes)))

          ; Token (listof NodeBox) -> SplitNode
          (define (split-helper token next-nodes)
            ())

          ; Token (listof NodeBox) -> TokenNode
          (define (join-helper token next-nodes)
            ())

          ; Token (listof NodeBox) -> TokenNode
          (define (null-helper token next-nodes)
            ())]
    (map gspine->linked-spine gspines)))
