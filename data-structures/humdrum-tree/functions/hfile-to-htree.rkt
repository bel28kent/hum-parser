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

          (define (fn-for-logs logs)
            (foldr (λ (f rnr) (cons (fn-for-global-spine f) rnr)) empty logs))

          (define (fn-for-global-spine gspine)
            (fn-for-lolot (global-spine-tokens gspine)))

          (define (fn-for-lolot lolot)
            ; parent?: Boolean. True if recursive call is in a parent.
            ; left?: Boolean. True if recursive call is left child of a parent.
            ; spine-num: Natural.
            ;
            (local [(define (fn-for-lolot lolot parent? left? spine-num)
                      (cond [(empty? lolot) #f]
                            [(string=? "*^" (token-token (first (first lolot))))
                             (parent (get-token (first lolot) spine-num)
                                     (fn-for-lolot (rest lolot) #t #t spine-num)
                                     (fn-for-lolot (rest lolot) #t #f (add1 spine-num)))]
                            [left? (leaf (get-token (first lolot) spine-num)
                                         (fn-for-lolot (rest lolot) #t #t spine-num))]
                            [(and parent? (not left?)) (if (string=? "*v" (token-token (second (first lolot))))
                                                           (leaf (get-token (first lolot) spine-num)
                                                                 #f)
                                                           (leaf (get-token (first lolot) spine-num)
                                                                 (fn-for-lolot (rest lolot) #t #f spine-num)))]
                            [else
                              (leaf (get-token (first lolot) spine-num)
                                    (fn-for-lolot (rest lolot) #f #f spine-num))]))]
              (fn-for-lolot lolot #f #f 1)))

          ; TODO: time complexity
          (define (get-token lot index)
            (local [(define (get-token lot index counter)
                      (cond [(empty? lot) (error "Reached an empty list before finding token.")]
                            [else
                              (if (= index counter)
                                  (first lot)
                                  (get-token (rest lot) index (add1 counter)))]))]
              (get-token lot index 1)))]
    (htree (root (fn-for-logs spines)))))
