#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data-structures: HumdrumTree
;;    htree->str: Converts HumdrumTree to String
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         (only-in "../../../parser/functions/predicates.rkt" spine-join?)
         "../data-definitions/data-definitions.rkt")

(provide htree->str)

(define (htree->str htree)
  (local [(define (fn-for-root root)
            (local [(define (iterator branches)
                      (cond [(empty? branches) ""]
                            [else
                              (string-append "branch:"
                                             "\n"
                                             "\t" (fn-for-node (first branches) 1)
                                             "\n"
                                             (iterator (rest branches)))]))]
              (iterator (root-branches root))))

          (define (fn-for-node node num-spines)
            (cond [(false? node) ""]
                  [(leaf? node) (fn-for-leaf node num-spines)]
                  [else
                    (fn-for-parent node num-spines)]))

          ; TODO: refactor recomputation
          (define (fn-for-leaf leaf num-spines)
            (string-append "leaf:\t" (fn-for-token (leaf-token leaf))
                           "\n"
                           (make-string (if (is-join? (leaf-token leaf))
                                            (- num-spines 2)
                                            num-spines)
                                        #\tab)
                           (fn-for-node (leaf-next leaf)
                                        (if (is-join? (leaf-token leaf))
                                            (- num-spines 2)
                                            num-spines))))

          (define (fn-for-parent parent num-spines)
            (local [(define current-indent (make-string (add1 num-spines) #\tab))

                    (define next-indent (make-string (+ num-spines 2) #\tab))]
              (string-append "parent:\t" (fn-for-token (parent-token parent))
                             "\n"
                             current-indent "left:"
                             "\n"
                             next-indent (fn-for-node (parent-left parent) (+ num-spines 2))
                             "\n"
                             current-indent "right:"
                             "\n"
                             next-indent (fn-for-node (parent-right parent) (+ num-spines 2)))))

          (define (fn-for-token token)
            (token-token token))

          (define (is-join? token)
            (spine-join? (token-token token)))]
    (fn-for-root (htree-root htree))))
