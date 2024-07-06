#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data-structures: HumdrumTree
;;    Stress test for hfile->htree
;;
;;    If hfile->htree is successful, then a
;;    function should be able to recurse
;;    through the tree and produce a
;;    GlobalSpine for each branch. Each
;;    GlobalSpine should then match the spine
;;    extracted from the original kern file
;;    using the humextra tool `extractx`.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require (only-in "../../../../parser/functions/file.krt"
                  path->hfile)
         "../../../../data-structures/humdrum-tree/functions/hfile-to-htree.krn")

(define SCRIABIN-64-HTREE (hfile->htree (path->hfile "scriabin-op64.krn")))

(struct global-spine (tokens spine-number) #:transparent)
; GlobalSpine is (global-spine (listof (listof Token)) Natural)
;  Represents a singe global column of a Humdrum file.
;  CONSTRAINT: spine-number >= 0

; copy-spines
; HumdrumTree -> (listof GlobalSpine)
; produce a GlobalSpine for each branch in HumdrumTree

;; will probably need to reverse result
(define (copy-spines htree)
  (local [(define (fn-for-root root)
            (local [(define (iterator branches spine-index)
                      (cond [(empty? branches) empty]
                            [else
                              (cons (global-spine (list (fn-for-node (first branches)))
                                                  spine-index)
                                    (iterator (rest branches) spine-index))]))]
              (iterator (root-branches root) 0)))

          ; (fn-for-token ...) -> current
          (define (fn-for-node node parent? left-children right-children result)
            (cond [(false? node) ...]
                  [(leaf? node) (fn-for-leaf node)]
                  [else
                    (fn-for-parent node)]))

          (define (fn-for-leaf leaf parent? left-children right-children result)
            (... (fn-for-token (leaf-token leaf))
                 (fn-for-node (leaf-next leaf))))

          (define (fn-for-parent parent parent? left-children right-children result)
            (... (fn-for-token (parent-token parent))
                 (fn-for-node (parent-left parent))
                 (fn-for-node (parent-right parent))))

          (define (fn-for-token token parent? left-children right-children result)
            (... (token-token token)
                 (token-type token)
                 (token-record-number token)))]
    (fn-for-root (htree-root htree))))
