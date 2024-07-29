#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: data-structures: AbstractHumdrumGraph
;;    Stress test for hfile->ab-hgraph
;;
;;    If hfile->ab-hgraph is successful, then a
;;    function should be able to recurse
;;    through the tree and produce a
;;    GlobalSpine for each branch. Each
;;    GlobalSpine should then match the spine
;;    extracted from the original kern file
;;    using the humextra tool `extractx`.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
