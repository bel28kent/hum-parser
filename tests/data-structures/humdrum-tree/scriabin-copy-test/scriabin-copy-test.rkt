#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data-structures: HumdrumTree
;;    Stress test for hfile->htree
;;
;;    If hfile->htree is successful, then a
;;    function should be able to recurse
;;    through the tree and produce a
;;    GlobalSpine for each branch. Each
;;    GlobalSpine should then match the spine
;;    extracted from the original kern file
;;    using the humextra tool `extractx`.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require (only-in "../../../../parser/functions/file.krt"
                  path->hfile)
         "../../../../data-structures/humdrum-tree/functions/hfile-to-htree.krn")

(define SCRIABIN-64-HTREE (hfile->htree (path->hfile "scriabin-op64.krn")))

(struct global-spine (tokens spine-number) #:transparent)
; GlobalSpine is (global-spine (listof (listof Token)) Natural)
;  Represents a singe global column of a Humdrum file.
;  CONSTRAINT: spine-number >= 0

; copy-spines
; HumdrumTree -> (listof GlobalSpine)
; produce a GlobalSpine for each branch in HumdrumTree
