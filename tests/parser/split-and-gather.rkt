#lang racket

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: tests for split and gather functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require "../functions/split-and-gather.rkt"
         test-engine/racket-tests)

; TODO
;  More robust tests would use real examples that contain each tag.
;  Could use constants.

; split
(check-expect (split "") empty)
(check-expect (split "**kern") (list "**kern"))
(check-expect (split "**kern\t**kern\t**kern") (list "**kern" "**kern" "**kern"))
(check-expect (split "**kern\t**dynam\t**kern\t**text") (list "**kern" "**dynam" "**kern" "**text"))

; gather
(check-expect (gather empty) "")
(check-expect (gather (list "**kern")) "**kern")
(check-expect (gather (list "**kern" "**kern" "**kern")) "**kern\t**kern\t**kern")
(check-expect (gather (list "**kern" "**dynam" "**kern" "**text")) "**kern\t**dynam\t**kern\t**text")

(test)