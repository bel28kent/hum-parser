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

(provide gspines->linked-spines)

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
            (map (λ (t) (terminator-node (box-immutable t))) lot))

          ; (listof Token) (listof Node) -> (listof Node)
          (define (wrap-tokens tokens next-nodes)
            (map (λ (t) (pair-token t tokens next-nodes)) tokens))

          ; Token (listof Token) (listof Node) -> Node
          (define (pair-token token tokens next-nodes)
            (cond [(spine-split? (token-token token))
                   (split-helper token (adjust-index token tokens) next-nodes)]
                  [(spine-join? (token-token token))
                   (join-helper token (adjust-index token tokens) tokens next-nodes)]
                  [(null-interpretation? (token-token token))
                   (null-helper token (adjust-index token tokens) next-nodes)]
                  [(terminator-node? (first next-nodes))
                   (token-node token (at-same-field-index token next-nodes))]
                  [else
                   (token-node token (box-immutable (at-same-field-index token next-nodes)))]))

          ; Token (listof Node) -> Node
          (define (at-same-field-index token next-nodes)
            (local [(define index (token-field-index token))

                    (define (index=? n)
                      (cond [(token-node? n) (= index (token-field-index (token-node-token n)))]
                            [(split-node? n) (= index (token-field-index (split-node-token n)))]
                            [else
                             (= index (token-field-index (unbox (terminator-node-token n))))]))]
              (first (filter index=? next-nodes))))

          ; Token (listof Token) -> Natural
          ; adjust index of Token if there are splits or joins to the left
          (define (adjust-index token tokens)
            (local [(define index (token-field-index token))

                    ; i: Natural. the index.
                    ; counter: Natural. number of tokens processed so far.
                    ; loj: (listof Token). if found, a list of successive spine joins, else empty.
                    (define (adjust tokens i counter loj)
                      (cond [(= counter index) (if (empty? loj)
                                                   i
                                                   (- i (- (length loj) 1)))]
                            [(string=? SPINE-SPLIT (token-type (first tokens)))
                             (adjust (rest tokens) (add1 i) (add1 counter) empty)]
                            [(string=? SPINE-JOIN (token-type (first tokens)))
                             (adjust (rest tokens) i (add1 counter) (cons (first tokens) loj))]
                            [else
                             (if (empty? loj)
                                 (adjust (rest tokens) i (add1 counter) empty)
                                 (adjust (rest tokens)
                                         (- i (- (length loj) 1))
                                         (add1 counter)
                                         empty))]))]
              (adjust tokens index 0 empty)))

          ; Token Index (listof Node) -> SplitNode
          (define (split-helper token index next-nodes)
            (cond [(terminator-node? (first next-nodes))
                   (split-node token (list-ref next-nodes index)
                                     (list-ref next-nodes (add1 index)))]
                  [else
                    (split-node token (box-immutable (list-ref next-nodes index))
                                      (box-immutable (list-ref next-nodes (add1 index))))]))

          ; BOUNDARY: left most join is treated like a regular token (do not decrement)
          ; Token Index (listof Token) (listof Node) -> TokenNode
          (define (join-helper token index tokens next-nodes)
            (local [(define not-adjusted-i (token-field-index token))

                    (define i (cond [(zero? not-adjusted-i) 0]
                                    [(not (spine-join? (token-token
                                                         (list-ref tokens (sub1 not-adjusted-i)))))
                                     index]
                                    [else
                                      (sub1 index)]))]
              (cond [(terminator-node? (first next-nodes)) (token-node token
                                                                       (list-ref next-nodes i))]
                    [else
                      (token-node token (box-immutable (list-ref next-nodes i)))])))

          ; Token Index (listof Node) -> TokenNode
          (define (null-helper token index next-nodes)
            (cond [(terminator-node? (first next-nodes))
                   (token-node token (list-ref next-nodes index))]
                  [else
                    (token-node token (box-immutable (list-ref next-nodes index)))]))]
    (map gspine->linked-spine gspines)))
