#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumTree
;;    visualize-htree: produces an image of a HumdrumTree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         "../data-definitions/data-definitions.rkt"
         pict
         pict/tree-layout
         racket/gui)

(provide (all-defined-out))

(define FACTOR 10)

; visualize-htree
; HumdrumTree -> Image
; produces an image of the HumdrumTree

(define (visualize-htree htree)
  (local [(define diameter (get-diameter htree))

          (define (fn-for-root root)
            (local [(define (iterator branches acc)
                      (cond [(empty? branches) (reverse acc)]
                            [else
                              (iterator (rest branches)
                                        (cons (fn-for-node (first branches)) acc))]))]
              (naive-layered (apply tree-layout (iterator (root-branches root) empty)))))

          (define (fn-for-node node)
            (cond [(false? node) #f]
                  [(leaf? node) (fn-for-leaf node)]
                  [else
                    (fn-for-parent node)]))

          (define (fn-for-leaf leaf)
            (tree-layout #:pict
                         (fn-for-token (leaf-token leaf))
                         (fn-for-node (leaf-next leaf))))

          (define (fn-for-parent parent)
            (tree-layout #:pict
                         (fn-for-token (parent-token parent))
                         (fn-for-node (parent-left parent))
                         (fn-for-node (parent-right parent))))

          (define (fn-for-token token)
            (cc-superimpose (disk diameter
                                  #:color "white"
                                  #:border-color "black")
                            (text (token-token token))))]
    (fn-for-root (htree-root htree))))

; get-diameter
; HumdrumTree -> Natural
; produces the length of the longest token string in the tree

(define (get-diameter htree)
  (local [; Root -> Natural
          (define (longest-string-length root)
            (local [(define lengths (fn-for-root root))

                    (define (longest lol largest)
                      (cond [(empty? lol) (* largest FACTOR)]
                            [else
                              (if (> (first lol) largest)
                                  (longest (rest lol) (first lol))
                                  (longest (rest lol) largest))]))]
              (if (empty? lengths)
                  0
                  (longest (rest lengths) (first lengths)))))

          ; Root -> (listof Natural)
          (define (fn-for-root root)
            (local [(define (iterator branches)
                      (cond [(empty? branches) empty]
                            [else
                              (append (fn-for-node (first branches))
                                      (iterator (rest branches)))]))]
              (iterator (root-branches root))))

          ; Node -> (listof Natural)
          (define (fn-for-node node)
            (cond [(false? node) empty]
                  [(leaf? node) (fn-for-leaf node)]
                  [else
                    (fn-for-parent node)]))

          ; Leaf -> (listof Natural)
          (define (fn-for-leaf leaf)
            (cons (fn-for-token (leaf-token leaf))
                  (fn-for-node (leaf-next leaf))))

          ; Parent -> (listof Natural)
          (define (fn-for-parent parent)
            (cons (fn-for-token (parent-token parent))
                  (append (fn-for-node (parent-left parent))
                          (fn-for-node (parent-right parent)))))

          ; Token -> Natural
          (define (fn-for-token token)
            (string-length (token-token token)))]
    (longest-string-length (htree-root htree))))
