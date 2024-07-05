#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: HumdrumTree
;;    hfile->htree: converts HumdrumFile to HumdrumTree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../../../parser/data-definitions/data-definitions.rkt"
         (only-in "../../../parser/functions/extract-spine-arity.rkt"
                  extract-spine-arity)
         (only-in "../../../parser/functions/predicates.rkt"
                  spine-split? spine-join? null-interpretation?)
         (only-in "../../../parser/functions/spine-parser.rkt"
                  byrecord->byspine spine-parser)
         "../data-definitions/data-definitions.rkt")

(provide hfile->htree
         file->tree)

; hfile->htree
; HumdrumFile -> HumdrumTree
; converts the HumdrumFile to a HumdrumTree

(define (hfile->htree hfile)
  (htree (root (prune-htree hfile))))

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
            ; prev-token: #f or Token. The previous token; initially false.
            ;
            (local [(define (fn-for-lolot lolot parent? left? spine-num prev-token)
                      (local [(define first-token (if (not (empty? lolot))
                                                      (get-token (first lolot) spine-num)
                                                      empty))

                              (define first-token-str (if (not (empty? first-token))
                                                          (token-token first-token)
                                                          empty))]
                        (cond [(empty? first-token) #f]
                              [(string=? "*^" first-token-str)
                               (parent first-token
                                       (fn-for-lolot (rest lolot) #t #t spine-num first-token)
                                       (fn-for-lolot (rest lolot) #t #f (add1 spine-num) first-token))]
                              [left? (cond [(and (string=? "*v" first-token-str) (right-hand? (first lolot) spine-num))
                                             (leaf first-token
                                                   #f)]
                                           [(and (string=? "*v" (token-token prev-token)) (>= spine-num 2))
                                             (leaf first-token
                                               (fn-for-lolot (rest lolot) #t #t (sub1 spine-num) first-token))]
                                           [else
                                             (leaf first-token
                                               (fn-for-lolot (rest lolot) #t #t spine-num first-token))])]
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
                                                           spine-num)
                                                           first-token)))]
                              [else
                                (leaf first-token
                                      (fn-for-lolot (rest lolot) #f #f spine-num first-token))])))]
              (fn-for-lolot lolot #f #f 1 #f)))

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
; HumdrumFile -> (listof Node)
; prunes duplicated data in lefthand spines 

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

    If no previous SpineArity has been greater than or equal to
        three, do nothing.
    If a previous SpineArity has been greater than or equal to
        three, and this SpineArity is not three, do nothing.
    If a previous SpineArity has been greater than or equal to
        three, and this SpineArity is one, substitute false for
        the rest of parent-left.
|#

(define (prune-htree hfile)
  (local [(define htree (file->tree hfile))

          (define byspine (byrecord->byspine (extract-spine-arity hfile)))

          (define (fn-for-htree htree byspine)
            (local [(define (fn-for-root root byspine)
                      (local [(define (iterator branches byspine)
                                (cond [(empty? branches) empty]
                                      [else
                                        (cons (fn-for-node (first branches)
                                                           (first byspine)
                                                           (first (first byspine))
                                                           #f
                                                           1
                                                           "")
                                              (iterator (rest branches) byspine))]))]
                        (iterator (root-branches root) byspine)))

                    (define (fn-for-node node byspine largest-prev left? num-sub prev-token)
                      (cond [(false? node) #f]
                            [(leaf? node) (fn-for-leaf node byspine largest-prev left? num-sub prev-token)]
                            [else
                              (fn-for-parent node byspine largest-prev left? num-sub prev-token)]))

                    (define (fn-for-leaf leaf1 byspine largest-prev left? num-sub prev-token)
                      (if (and left?
                               (> num-sub 1)
                               (= 1 (first byspine))
                               (>= largest-prev 3)
                               (string=? "*v" (token-token prev-token)))
                          #f
                          (leaf (leaf-token leaf1)
                                (fn-for-node (leaf-next leaf1)
                                             (rest byspine)
                                             (if (> (first byspine) largest-prev)
                                                 (first byspine)
                                                 largest-prev)
                                             left?
                                             num-sub
                                             (leaf-token leaf1)))))

                    (define (fn-for-parent parent1 byspine largest-prev left? num-sub prev-token)
                      (parent (parent-token parent1)
                              (fn-for-node (parent-left parent1)
                                           (rest byspine)
                                           (if (> (first byspine) largest-prev)
                                               (first byspine)
                                               largest-prev)
                                           #t
                                           num-sub
                                           (parent-left parent1))
                              (fn-for-node (parent-right parent1)
                                           (rest byspine)
                                           (if (> (first byspine) largest-prev)
                                               (first byspine)
                                               largest-prev)
                                           #f
                                           (add1 num-sub)
                                           (parent-right parent1))))]
              (fn-for-root (htree-root htree) byspine)))]
    (fn-for-htree htree byspine)))
