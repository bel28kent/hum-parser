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
         "../data-definitions/data-definitions.rkt")

(provide hfile->htree
         file->tree)

; hfile->htree
; HumdrumFile -> HumdrumTree
; converts the HumdrumFile to a HumdrumTree

(define (hfile->htree hfile)
  (prune-htree (file->tree hfile)))

; file->tree
; HumdrumFile -> HumdrumTree
; maps a HumdrumFile's spines on to a HumdrumTree

(define (file->tree hfile)
  (local [(define spines (spine-parser hfile))

          (define (fn-for-logs logs)
            (foldr (λ (f rnr) (cons (fn-for-global-spine f) rnr)) empty logs))

          (define (fn-for-global-spine gspine)
            (fn-for-lolot (global-spine-tokens gspine)))

          (define (fn-for-lolot lolot)
            ; parent?: Boolean. True if recursive call is in a parent.
            ; left?: Boolean. True if recursive call is left child of a parent.
            ; spine-num: Natural. The index of this (sub)spine.
            ;
            (local [(define (fn-for-lolot lolot parent? left? spine-num)
                      (local [(define first-token (if (not (empty? lolot))
                                                      (get-token (first lolot) spine-num)
                                                      empty))

                              (define first-token-str (if (not (empty? first-token))
                                                          (token-token first-token)
                                                          empty))]
                        (cond [(empty? first-token) #f]
                              [(string=? "*^" first-token-str)
                               (parent first-token
                                       (fn-for-lolot (rest lolot) #t #t spine-num)
                                       (fn-for-lolot (rest lolot) #t #f (add1 spine-num)))]
                              [left? (if (and (string=? "*v" first-token-str) (>= spine-num 2))
                                         (leaf first-token
                                           (fn-for-lolot (rest lolot) #t #t (sub1 spine-num)))
                                         (leaf first-token
                                           (fn-for-lolot (rest lolot) #t #t spine-num)))]
                              [(and parent? (not left?))
                               (if (and (string=? "*v" first-token-str)
                                        (right-hand? (first lolot) spine-num))
                                   (leaf first-token
                                         #f)
                                   (leaf first-token
                                         (fn-for-lolot (rest lolot)
                                                       #t #f
                                                       (if (splits-to-left? first-token-str
                                                                            (first lolot)
                                                                            spine-num)
                                                           (add1 spine-num)
                                                           spine-num))))]
                              [else
                                (leaf first-token
                                      (fn-for-lolot (rest lolot) #f #f spine-num))])))]
              (fn-for-lolot lolot #f #f 1)))

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

          (define (right-hand? lot spine-num)
            (local [(define (right-hand? lot counter)
                      (cond [(empty? lot) #f]
                            [else
                              (if (and (= 1 (- spine-num counter))
                                       (string=? "*v" (token-token (first lot))))
                                  #t
                                  (right-hand? (rest lot) (add1 counter)))]))]
              (right-hand? lot 1)))

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
                  #f)))]
    (htree (root (fn-for-logs spines)))))

; prune-htree
; HumdrumTree SpineArity -> HumdrumTree
; prunes duplicated data in lefthand spines 

(define (prune-htree htree)
  (htree (root empty)))

#|
    Duplicate data is the result of the file->tree converter,
        which allows data after spine joins to always continue
        in the left branch.
    Duplicate data exists only in the left branch of a parent.
    In the case in which a spine has only been split once,
        there is no duplication.
    In the case in which a spine splits mutliple times, and the
        the spine join is not the last (i.e., it does not reduce
        the number of subspines to one), there is no duplication.
    In the case in which a spine splits multiple times, and the
        the spine join is the last (i.e., it reduces the number
        of subspines to one), there is duplication because the
        lefthand spine in the nested parent will repeat data that
        should only be in the lefthand spine of the topmost
        parent.

    (byrecord->byspine SpineArity)

    If no previous SpineArity has been greater than or equal to
        three, do nothing.
    If a previous SpineArity has been greater than or equal to
        three, and this SpineArity is not three, do nothing.
    If a previous SpineArity has been greater than or equal to
        three, and this SpineArity is one, substitute false for
        the rest of parent-left.
|#
