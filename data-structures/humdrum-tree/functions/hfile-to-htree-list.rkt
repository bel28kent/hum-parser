#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumTree
;;    hfile->htree: converts HumdrumFile to HumdrumTree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         (only-in "../../../parser/functions/predicates.rkt"
                  spine-split? spine-join? null-interpretation?)
         (only-in "../../../parser/functions/spine-parser.rkt"
                  spine-parser)
         "../data-definitions/data-definitions-list.rkt")

(provide hfile->htree)

; hfile->htree
; HumdrumFile -> HumdrumTree
; converts the HumdrumFile to a HumdrumTree

(define (hfile->htree hfile)
  (local [(define spines (spine-parser hfile))

          (define (fn-for-logs logs)
            (cond [(empty? logs) empty]
                  [else
                    (cons (fn-for-global-spine (first logs))
                          (fn-for-logs (rest logs)))]))

          (define (fn-for-global-spine global-spine)
            (fn-for-lolot (global-spine-tokens global-spine) #f #f 1))

          (define (fn-for-lolot lolot parent? left? spine-num)
            (local [(define first-token (if (not (empty? lolot))
                                            (get-token (first lolot) spine-num)
                                            empty))]
              (cond [(empty? lolot) empty]
                    [(string=? "*^" (token-token first-token))
                     (append (list (parent first-token
                                           (fn-for-lolot (rest lolot) #t #t spine-num)
                                           (fn-for-lolot (rest lolot) #t #f (add1 spine-num))))
                             (fn-for-lolot (trim-parent lolot spine-num) #f #f (if (>= spine-num 2)
                                                                                   (sub1 spine-num)
                                                                                   spine-num)))]
                    [(string=? "*v" (token-token first-token)) (leaf first-token)]
                    [left? (append (list (leaf first-token))
                                   (fn-for-lolot (rest lolot) #t #t spine-num))]
                    [(and parent? (not left?))
                     (cond [(splits-to-left? (token-token first-token) (first lolot) spine-num)
                            (append (list (leaf first-token))
                                    (fn-for-lolot (rest lolot) #t #f (add1 spine-num)))]
                           [else
                             (append (list (leaf first-token))
                                     (fn-for-lolot (rest lolot) #t #f spine-num))])]
                    [else
                      (append (list (leaf first-token))
                              (fn-for-lolot (rest lolot) #f #f spine-num))])))

          ; TODO: time complexity
          (define (get-token lot index)
            (local [(define original lot)

                    (define (get-token lot index counter)
                      (cond [(empty? lot) (error "Reached an empty list before finding token."
                                                 original
                                                 index
                                                 counter)]
                            [else
                              (if (= index counter)
                                  (first lot)
                                  (get-token (rest lot) index (add1 counter)))]))]
              (get-token lot index 1)))

          (define (splits-to-left? first-token-str lot spine-num)
            (local [(define (splits-to-left? lot counter)
                      (cond [(empty? lot) #f]
                            [(= counter spine-num) #f]
                            [else
                              (if (spine-split? (token-token (first lot)))
                                  #t
                                  (splits-to-left? (rest lot) (add1 counter)))]))]
              (if (or (spine-split? first-token-str)
                      (spine-join? first-token-str)
                      (null-interpretation? first-token-str))
                  (splits-to-left? lot 1)
                  #f)))

          (define (trim-parent lolot spine-num)
            (cond [(empty? lolot) (error "Reached an empty list before finding spine join.")]
                  [(= 1 (length (first lolot))) (trim-parent (rest lolot) spine-num)]
                  [(and (string=? "*v" (token-token (get-token (first lolot) spine-num)))
                        (string=? "*v" (token-token (get-token (first lolot) (add1 spine-num)))))
                   (rest lolot)]
                  [else
                    (trim-parent (rest lolot) spine-num)]))]
    (htree (root (fn-for-logs spines)))))

; append-lists
; HumdrumTree -> HumdrumTree
; append lists

#|
(define (append-lists htree)
  (local [(define (fn-for-root root)
            (local [(define (iterator branches)
                      (cond [(empty? branches) ...]
                            [else
                              (... (fn-for-lon (first branches))
                                   (iterator (rest branches)))]))]
              (iterator (root-branches root))))

          (define (fn-for-lon branch)
            (cond [(empty? branch) ...]
                  [else
                    (... (fn-for-node (first branch))
                         (fn-for-lon (rest branch)))]))

          (define (fn-for-node node)
            (cond [(leaf? node) (fn-for-leaf node)]
                  [else
                    (fn-for-parent node)]))

          (define (fn-for-leaf leaf)
            (... (fn-for-token (leaf-token leaf))))

          (define (fn-for-parent parent)
            (... (fn-for-token (parent-token parent))
                 (fn-for-lon (parent-left parent))
                 (fn-for-lon (parent-right parent))))

          (define (fn-for-token token)
            (... (token-token token)
                 (token-type token)
                 (token-record-number token)))]
    (... (fn-for-root (htree-root htree)))))
|#
