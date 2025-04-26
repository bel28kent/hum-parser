#lang racket/base

#|
	Function to convert a list of GlobalSpine to a list of LinkedSpine.
|#

(require racket/bool
         racket/contract
         racket/list
         racket/local
         "../HumdrumSyntax.rkt"
         "LinkedSpine.rkt")

(provide gspines->linked-spines)

; gspines->linked-spines
; (listof GlobalSpine) HumdrumFile -> (listof LinkedSpine)
; produce a list of LinkedSpines

(define/contract (gspines->linked-spines gspines hfile)
  (-> (listof global-spine?) humdrum-file? (listof linked-spine?))
  (local [(define (split? t)
            (symbol=? 'SpineSplit (token-type t)))

          (define (join? t)
            (symbol=? 'SpineJoin (token-type t)))

          (define (split-or-join? t)
            (or (split? t) (join? t)))

          (define (null-interp? t)
            (symbol=? 'NullInterpretation (token-type t)))

          (define records (humdrum-file-records hfile))

          ; GlobalSpine -> LinkedSpine
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
            (map (λ (t) (terminator-node t)) lot))

          ; (listof Token) (listof Node) -> (listof Node)
          (define (wrap-tokens tokens next-nodes)
            (map (λ (t) (pair-token t tokens next-nodes)) tokens))

          ; Token (listof Token) (listof Node) -> Node
          (define (pair-token token tokens next-nodes)
            (cond [(split? token)
                   (split-helper token (adjust-index token) next-nodes)]
                  [(join? token)
                   (token-helper token (adjust-index token) next-nodes)]
                  [(null-interp? token)
                   (token-helper token (adjust-index token) next-nodes)]
                  [(terminator-node? (first next-nodes))
                   (token-node token (box-immutable (at-same-field-index token next-nodes)))]
                  [else
                   (token-node token (box-immutable (at-same-field-index token next-nodes)))]))

          ; Token (listof Node) -> Node
          (define (at-same-field-index token next-nodes)
            (local [(define index (token-field-index token))

                    (define (index=? n)
                      (cond [(token-node? n) (= index (token-field-index (token-node-token n)))]
                            [(split-node? n) (= index (token-field-index (split-node-token n)))]
                            [else
                             (= index (token-field-index (terminator-node-token n)))]))]
              (first (filter index=? next-nodes))))

          ; Token (listof Token) -> Natural
          (define (adjust-index token)
            (local [(define r-split (record-split (list-ref records (token-record-index token))))
                    (define index (token-field-index token))

                    (define (<index? t)
                      (< (token-field-index t) index))

                    (define (adjust-index lot)
                      (local [(define count-splits (count split? lot))
                              (define count-joins (if (join? token)
                                                      (count join? lot)
                                                      (sub1 (count join? lot))))]
                        (if (>= count-joins 0)
                            (- (+ index count-splits) count-joins)
                            (+ index count-splits))))]
                  (adjust-index (filter split-or-join? (filter <index? r-split)))))

          ; (listof Node) Natural Token Procedure -> Node
          (define (get-node lon index token caller)
            (local [(define (get-node-index node)
                      (cond [(token-node? node) (token-field-index (token-node-token node))]
                            [(split-node? node) (token-field-index (split-node-token node))]
                            [else
                              (token-field-index (terminator-node-token node))]))

                    (define (get-node nodes)
                      (cond [(empty? nodes) (raise-result-error 'get-node
                                                                "node"
                                                                0
                                                                "reached an empty list"
                                                                lon
                                                                index
                                                                token
                                                                caller)]
                            [(= index (get-node-index (first nodes))) (first nodes)]
                            [else
                              (get-node (rest nodes))]))]
              (get-node lon)))

          ; Token Index (listof Node) -> SplitNode
          (define (split-helper token index next-nodes)
            (cond [(terminator-node? (first next-nodes))
                   (split-node token
                               (box-immutable (get-node next-nodes index token 'split-helper))
                               (box-immutable
                                 (get-node next-nodes (add1 index) token 'split-helper)))]
                  [else
                    (split-node token
                                (box-immutable (get-node next-nodes index token 'split-helper))
                                (box-immutable
                                  (get-node next-nodes (add1 index) token 'split-helper)))]))

          ; Token Index (listof Node) -> TokenNode
          (define (token-helper token index next-nodes)
            (cond [(terminator-node? (first next-nodes))
                   (token-node token
                               (box-immutable (get-node next-nodes index token 'null-helper)))]
                  [else
                    (token-node token (box-immutable
                                        (get-node next-nodes index token 'null-helper)))]))]
    (map gspine->linked-spine gspines)))
