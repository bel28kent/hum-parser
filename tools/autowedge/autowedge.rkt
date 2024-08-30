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

; composition
; String -> #<void>
; displays the file's data with cresc. and dim. wedges completed

(define (composition path)
  (local [(define path-hfile (path->hfile path))
          (define path-pre (hfile (filter (λ (r) (not
                                                   (string=? TOKEN (record-type r))))
                                          (hfile-records path-hfile))))]
    (map displayln (hfile->los
                     (hfile-hash-join path-pre (ab-hgraph->hfile
                                                 (autowedge
                                                   (hfile->ab-hgraph path-hfile htree))))))))

; autowedge
; HumdrumTree -> HumdrumTree
; produces the humdrum tree with paired cresc. and dim. wedges completed

(define (autowedge htree)
  (local [; Root -> Root
          (define (fn-for-root root)
            (local [(define (iterator branches new-branches)
                      (cond [(empty? branches) (root (reverse new-branches))]
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

          ; Leaf (listof Node) -> Boolean
          ; produce true if leaf is angle and is paired with a square
          (define (is-paired? leaf lon)
            (local [(define (paired? lon)
                      (cond [(empty? lon) #f]
                            [(not (regexp-match? #px"[\\[\\]\\.]" (token-token
                                                                    (leaf-token (first lon))))) #f]
                            [(regexp-match? #px"[\\[|\\]]" (token-token
                                                             (leaf-token (first lon)))) #t]
                            [else
                              (paired? (rest lon))]))]
              (and (regexp-match? #px">|<" (token-token (leaf-token leaf)))
                   (paired? lon))))

          ; Leaf -> Boolean
          (define (is-angle? leaf)
            (regexp-match? #px"<|>" (token-token (leaf-token leaf))))

          ; Leaf -> Boolean
          (define (is-left? leaf)
            (string=? "<" (token-token (leaf-token leaf))))

          ; (listof Node) -> (listof Node)
          (define (fn-for-lon branch)
            (local [(define (fn-for-lon branch angle? left?)
                      (cond [(empty? branch) empty]
                            [(leaf? (first branch))
                             (cond [(or (not-angle-or-null? (first branch))
                                        (not (is-paired? (first branch) (rest branch))))
                                    (cons (first branch)
                                          (fn-for-lon (rest branch) #f #f))]
                                   [(is-angle? (first branch))
                                    (cons (first branch)
                                          (fn-for-lon (rest branch)
                                                      #t (is-left? (first branch))))]
                                   [else
                                     (cons (fn-for-leaf (first branch) left?)
                                                        (fn-for-lon (rest branch) angle? left?))])]
                            [else
                              (cons (parent (fn-for-token (parent-token (first branch)))
                                            (fn-for-lon (parent-left (first branch))
                                                        #f #f)
                                            (fn-for-lon (parent-right (first branch))
                                                        #f #f))
                                    (fn-for-lon (rest branch) #f #f))]))]
              (fn-for-lon branch #f #f)))

          (define (fn-for-leaf leaf left?)
            (if left?
                (fn-for-token (leaf-token leaf) "(")
                (fn-for-token (leaf-token leaf) ")")))

          (define (fn-for-token token paren)
            (token paren
                   (token-type token)
                   (token-record-number token)))]
        (htree (fn-for-root (abstract-humdrum-graph-root htree)))))

(define autowedge-cmd
  (command-line
    #:args (filename)
    (composition filename)))
