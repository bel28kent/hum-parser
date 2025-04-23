#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: tools: visualize-htree
;;    produces an svg image of the file as a HumdrumTree 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/cmdline
         racket/list
         racket/local
         2htdp/image
         (only-in "../../parser/functions/file.rkt"
                  path->hfile)
         "../../data-structures/abstract-humdrum-graph/functions/hfile-to-ab-hgraph.rkt"
         "../../data-structures/humdrum-tree/data-definitions/data-definitions.rkt"
         "../../data-structures/humdrum-tree/functions/visualize-htree.rkt")

; htree-svg
; String -> Image
; saves an svg image of the data at filename converted to a HumdrumTree

(define (htree-svg filename)
  (save-svg-image
    (visualize-htree
      (hfile->ab-hgraph
        (path->hfile filename)
        htree))
    (svg-filename filename)))

; svg-filename
; String -> String
; produces a name for an svg image

(define (svg-filename filename)
  (local [(define without-extension (first
                                      (regexp-match #px"^[a-zA-Z0-9_\\-]+[^\\.]"
                                                    filename)))]
    (string-append without-extension "-htree.svg")))

(define visualize-htree-cmd
  (command-line
    #:args (filename)
    (htree-svg filename)))
