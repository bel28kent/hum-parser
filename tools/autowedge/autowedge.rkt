#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: tools: autowedge
;;    complete cresc. and dim. wedges with parens
;; CONSTRAINT: assumes wedges never begin before split or end after merge
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/cmdline
         racket/list
         racket/local
         "../../hum-parser.rkt")

(provide (all-defined-out))

; composition
; String -> #<void>
; displays the file's data with cresc. and dim. wedges completed

(define (composition path)
  (local [(define path-hfile (path->hfile path))
          (define path-pre (hfile (filter (λ (r) (not (string=? TOKEN (record-type r))))
                                          (hfile-records path-hfile))))]
    (map displayln (hfile->los
                     (hfile-hash-join path-pre (ab-hgraph->hfile
                                                 (autowedge
                                                   (hfile->ab-hgraph path-hfile ab-hgraph))))))))
; autowedge
; AbstractHumdrumGraph -> AbstractHumdrumGraph
; produces the humdrum tree with paired cresc. and dim. wedges completed

(define (autowedge graph)
  (local [; Root -> Root
          (define (fn-for-root root)
            (local [(define (iterator branches new-branches)
                      (cond [(empty? branches) (reverse new-branches)]
                            [(iterator (rest branches)
                                       (cons (if (string=? "**dynam" (token-token
                                                                       (leaf-token
                                                                         (first (first branches)))))
                                                 (fn-for-lon (first branches))
                                                 (first branches))
                                             new-branches))]))]
              (iterator (root-branches root) empty)))

          ; Leaf -> Boolean
          ; produce true if leaf is NOT one of ">", "<", "."
          (define (not-angle-or-null? leaf)
            (local [(define str_1 (token-token (leaf-token leaf)))

                    (define (str=? str_2)
                      (string=? str_1 str_2))]
              (and (not (or (str=? ">") (str=? "<")))
                   (not (str=? ".")))))

          ; Leaf -> Boolean
          ; produce true if "."
          (define (null-token? leaf)
            (string=? "." (token-token (leaf-token leaf))))

          ; Leaf (listof Node) -> Boolean
          ; produce true if leaf is angle and is paired with a square
          (define (is-paired? f lon)
            (local [(define (paired? lon)
                      (cond [(empty? lon) #f]
                            [(not (regexp-match? #px"[\\[\\]\\.=]" (token-token
                                                                     (leaf-token (first lon)))))
                             #f]
                            [(regexp-match? #px"[\\[|\\]]" (token-token
                                                             (leaf-token (first lon))))
                             #t]
                            [else
                              (paired? (rest lon))]))]
              (and (regexp-match? #px"<|>" (token-token (leaf-token f))) (paired? lon))))

          ; Leaf -> Boolean
          (define (is-angle? leaf)
            (regexp-match? #px"<|>" (token-token (leaf-token leaf))))

          ; Leaf -> Boolean
          (define (is-left? leaf)
            (string=? "<" (token-token (leaf-token leaf))))

          ; (listof Node) -> (listof Node)
          (define (fn-for-lon branch)
            (local [(define (fn-for-lon branch angle? left?)
                      (local [(define f (if (empty? branch)
                                            empty
                                            (first branch)))
                              (define r (if (empty? branch)
                                            empty
                                            (rest branch)))
                              (define p? (if (not (empty? f))
                                             (is-paired? f r)
                                             #f))]
                        (cond [(empty? branch) empty]
                              [(leaf? f) (cond [(or (not-angle-or-null? f)
                                                    (and (is-angle? f) (not p?))
                                                    (and (null-token? f) (not angle?)))
                                                (cons f (fn-for-lon r #f #f))]
                                               [p? (cons f (fn-for-lon r #t (is-left? f)))]
                                               [(cons (fn-for-leaf f left?)
                                                      (fn-for-lon r angle? left?))])]
                              [(cons (parent (parent-token f)
                                             (fn-for-lon (parent-left f) #f #f)
                                             (fn-for-lon (parent-right f) #f #f))
                                     (fn-for-lon r #f #f))])))]
              (fn-for-lon branch #f #f)))

          (define (fn-for-leaf l left?)
            (if left?
                (leaf (fn-for-token (leaf-token l) "("))
                (leaf (fn-for-token (leaf-token l) ")"))))

          (define (fn-for-token t paren)
            (token paren
                   SPINE-DATA
                   (token-record-number t)))]
    (ab-hgraph (root (fn-for-root (abstract-humdrum-graph-root graph))))))

(define autowedge-cmd
  (command-line
    #:args (filename)
    (composition filename)))
