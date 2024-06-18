#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hum-parser: tools: rid
;;    eliminate specified humdrum record types
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;The rid command allows the user to eliminate specified types of Humdrum records (lines) from the input stream.
;Depending on the options selected, rid will eliminate: global comments,
;                                                       local comments,
;                                                       interpretations,
;                                                       duplicate exclusive interpretations,
;                                                       tandem interpretations,
;                                                       data records,
;                                                       data records consisting of just null tokens (null data records),
;                                                       empty global or local comments,
;                                                       empty interpretations,
;                                                       or any combination of these record types.
