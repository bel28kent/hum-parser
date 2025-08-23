#lang racket/base

#|
	Functions to convert between data types.
|#

(provide hfile->hgraph)

#|
	ENDING A PARENT:
	The join and terminator cases that end parents are conflicting because the
	join case ends the split-node recursion, but not the overall recursion,
	while the terminator case ends the parent and overall recursion.

	MAYBE:
		(split-result (parent ...)
                              (if (terminator-node? node)
                                  node
                                  (unbox (token-node-next node))))

	Though if the above is done, then terminators that end parents will be outside
	of the parent wrapper.

	I think this gets back to the join problem . . .
|#
(define (hfile->hgraph hfile)
  (-> humdrum-file? humdrum-graph?)
  (local [(define (linked-spine->nodes linked-spine)
            (local [(struct split-result (parent next-after-parent))

                    (define (join? node)
                      (if (token-node? node)
                          (symbol=? 'SpineJoin (token-type (token-node-token node)))
                          #f))

                    (define (fn-for-node node)
                      (cond [(token-node? node) (append (fn-for-token-node node))]
                            [(split-node? node)
                             (local [(define result (fn-for-split-node node))]
                               (append (list (split-result-parent result))
                                       (fn-for-node (split-result-next-after-parent result))))]
                            [else
                              (append (fn-for-terminator-node node))]))

                    (define (fn-for-token-node node)
                      (append (fn-for-token (token-node-token node))
                              (fn-for-node (unbox (token-node-next node)))))

                    (define (fn-for-split-node node)
                      ...)

                    (define (fn-for-terminator-node node)
                      (fn-for-token (terminator-node-token node)))

                    (define (fn-for-token token)
                      (list (leaf token)))]
              (fn-for-node (linked-spine-first-node linked-spine))))]
    (hgraph
      (root
        (map linked-spine->nodes
             (gspines->linked-spines
               (spine-parser hfile)
               hfile))))))

(define/contract (hgraph->hfile hgraph)
  (-> humdrum-graph? humdrum-file?)
  (hfile
    (tokens->records
      (hgraph->tokens hgraph))))

(define/contract (tokens->records tokens)
  (-> (listof (listof token?)) (listof record?))
  (local [(define (tokens->record tokens)
            (local [(define r (gather (map token-token tokens) TokenSeparator))]
              (record r
                      (type-humdrum-record r)
                      tokens
                      (token-record-index (first tokens)))))]
    (map tokens->record tokens)))

(define/contract (hgraph->tokens hgraph)
  (-> humdrum-graph? (listof (listof token?)))
  (local [(define (fn-for-root root)
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
