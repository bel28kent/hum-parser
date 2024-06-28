#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumTree
;;    hfile->htree: converts HumdrumFile to HumdrumTree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         (only-in "../../../parser/functions/spine-parser.rkt"
                  spine-parser)
         "../data-definitions/data-definitions.rkt")

(provide (all-defined-out))

; hfile->htree
; HumdrumFile -> HumdrumTree
; maps a HumdrumFile's spines on to a HumdrumTree

(define (hfile->htree hfile)
  (local [(define spines (spine-parser hfile))

          (struct parent-result (result after-join))

          (define (fn-for-logs logs)
            (foldr (λ (f rnr) (cons (fn-for-global-spine f) rnr)) empty logs))

          (define (fn-for-global-spine gspine)
            (fn-for-lolot (global-spine-tokens gspine)))

          (define (fn-for-lolot lolot)
            ; parent?: boolean True if this recursive call is in a parent.
            ; left?: boolean. True if this recursive call is in the left child
            ;                of a parent.
            ;
            (local [(define (fn-for-lolot lolot parent? left?)
                      (cond [(empty? lolot) #f]
                            [(string=? "*^" (token-token (first (first lolot))))
                             (parent (first (first lolot))
                                     (fn-for-lolot (rest lolot) #t #t)
                                     (fn-for-lolot (rest lolot) #t #f))]
                            [left? (leaf (first (first lolot))
                                         (fn-for-lolot (rest lolot) #t #t))]
                            [(and parent? (not left?)) (if (string=? "*v" (token-token (second (first lolot))))
                                                           (leaf (second (first lolot))
                                                                 #f)
                                                           (leaf (second (first lolot))
                                                                 (fn-for-lolot (rest lolot) #t #f)))]
                            [else
                              (leaf (first (first lolot))
                                    (fn-for-lolot (rest lolot) #f #f))]))]
              (fn-for-lolot lolot #f #f)))]
    (htree (fn-for-logs spines))))
