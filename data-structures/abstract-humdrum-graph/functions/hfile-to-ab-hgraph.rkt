#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data structures: AbstractHumdrumGraph
;;    hfile->ab-hgraph: Converts HumdrumFile to AbstractHumdrumGraph
;;        or one of its subtypes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/list
         racket/local
         "../../../parser/data-definitions/data-definitions.rkt"
         (only-in "../../../parser/functions/predicates.rkt"
                  spine-split? spine-join? null-interpretation?)
         (only-in "../../../parser/functions/spine-parser.rkt"
                  spine-parser)
         "../data-definitions/data-definitions.rkt")

(provide (all-defined-out))

#|
    ASSUMPTIONS:
        1a. All subspines merge into one spine before termination.
        1b. All spines terminate correctly; i.e., the last two tokens in all
            spines are "==" and "*-".
        2. When a "*v" is encountered it immediately terminates the subspine.
           (Overlapping left and right subspines when there is more than one
           spine split creates too many corner cases.)
|#

; hfile->ab-hgraph
; HumdrumFile Type -> AbstractHumdrumGraph
; converts the HumdrumFile to an AbstractHumdrumGraph or one of its subtypes

(define (hfile->ab-hgraph hfile type)
  (local [(define spines (spine-parser hfile))

          (define (fn-for-logs logs)
            (cond [(empty? logs) empty]
                  [else
                    (cons (fn-for-global-spine (first logs))
                          (fn-for-logs (rest logs)))]))

          (define (fn-for-global-spine global-spine)
            (fn-for-lolot (global-spine-tokens global-spine)))

          (define (fn-for-lolot lolot)
            (local [(define original lolot)

                    (define (fn-for-lolot lolot parent? left? spine-num)
                      (local [(define first-token (if (not (empty? lolot))
                                                      (get-token (first lolot) spine-num)
                                                      empty))]
                        (cond [(empty? lolot) empty]
                              ; splits-to-left? can also happend here because simultaneous
                              [(string=? "*^" (token-token first-token))
                               (local [(define left (fn-for-lolot (rest lolot) #t #t spine-num))

                                       (define right (fn-for-lolot (rest lolot) #t #f
                                                                   (add1 spine-num)))]
                                 (list* (parent first-token
                                                left
                                                right)
                                        (fn-for-lolot (trim-original original left right)
                                                      #f #f
                                                      spine-num)))]
                              [(string=? "*v" (token-token first-token)) (list (leaf first-token))]
                              [left? (list* (leaf first-token)
                                            (fn-for-lolot (rest lolot) #t #t spine-num))]
                              [(and parent? (not left?))
                                     ; joins-to-left? (fn-for-lolot ... (sub1 spine-num))
                               (cond [(splits-to-left? (token-token first-token)
                                                       (first lolot)
                                                       spine-num)
                                      (list* (leaf first-token)
                                             (fn-for-lolot (rest lolot)
                                                           #t #f
                                                           (add1 spine-num)))]
                                     [else
                                       (list* (leaf first-token)
                                              (fn-for-lolot (rest lolot) #t #f spine-num))])]
                              [else
                                (list* (leaf first-token)
                                       (fn-for-lolot (rest lolot) #f #f spine-num))])))]
              (fn-for-lolot lolot #f #f 1)))]
    (type (root (fn-for-logs spines)))))

; get-token
; (listof Token) Natural -> Token
; produces the token at index

(define (get-token lot index)
  (local [(define original lot)

          (define (get-token lot index counter)
            (cond [(empty? lot) (raise-result-error
                                  'get-token
                                  "reached empty before finding token"
                                  0
                                  original
                                  index
                                  counter)]
                  [else
                    (if (= index counter)
                        (first lot)
                        (get-token (rest lot)
                                   index
                                   (add1 counter)))]))]
    (get-token lot index 1)))

; splits-to-left?
; String (listof Token) Natural -> Boolean
; produces true if there is a spine split to the left of this token

(define (splits-to-left? first-token-str lot spine-num)
  (local [(define (splits-to-left? lot counter)
            (cond [(empty? lot) (raise-result-error
                                       'splits-to-left?
                                       "reached empty before this spine"
                                       0
                                       lot
                                       spine-num)]
                  [(= counter spine-num) #f]
                  [else
                    (if (spine-split? (token-token (first lot)))
                        #t
                        (splits-to-left? (rest lot)
                                         (add1 counter)))]))]
    (if (or (spine-split? first-token-str)
            (spine-join? first-token-str)
            (null-interpretation? first-token-str))
        (splits-to-left? lot 1)
        #f)))

; trim-original
; (listof Token) (listof Token) (listof Token) -> (listof Token)
; produces the original list of tokens with parent contents removed

(define (trim-original original left right)
  (local [(define record-index (token-record-number
                                     (leaf-token
                                       (first (reverse right)))))

          (define (trim-original original)
            (cond [(empty? original)
                   (raise-result-error 'trim-original
                                       "reached empty before finding index"
                                       0
                                       original
                                       left
                                       right)]
                  [(= record-index (token-record-number
                                     (first (first original))))
                   (handle-join (rest original) left right)]
                  [else
                    (trim-original (rest original))]))]
    (trim-original original)))

; handle-join
; (listof Token) (listof Token) (listof Token) -> (listof Token)
; removes "*v" from original only if its pair has already been processed

(define (handle-join rest-original left right)
  (if (string=? "*v" (token-token (first (first rest-original))))
      (if (join-is-already-paired? (first (first rest-original))
                                   left
                                   right)
          (rest rest-original)
          rest-original)
      rest-original))

; join-is-already-paired?
; Token (listof Token) (listof Token) -> Boolean
; produces true if join can be found twice between left and right

(define (join-is-already-paired? join left right)
  (local [(define (counter lot)
            (cond [(empty? lot) 0]
                  [else
                    (if (equal? join (first lot))
                        (add1 (counter (rest lot)))
                        (counter (rest lot)))]))

          (define left-count (counter (branch->lot left)))

          (define right-count (counter (branch->lot right)))]
    (if (= 2 (+ left-count right-count))
        #t
        #f)))

; branch->lot
; (listof Node) -> (listof Token)
; collapses a branch of a tree to a (listof Token)

(define (branch->lot branch)
  (local [(define (branch->lot branch acc)
            (cond [(empty? branch) (reverse acc)]
                  [(leaf? (first branch))
                   (branch->lot (rest branch)
                                (cons (leaf-token (first branch))
                                      acc))]
                  [else
                    (branch->lot (append (parent-left (first branch))
                                         (parent-right (first branch))
                                         (rest branch))
                                 (cons (parent-token (first branch))
                                       acc))]))]
    (branch->lot branch empty)))
