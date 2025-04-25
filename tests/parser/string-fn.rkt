#lang racket

#|
	Tests for string functions.
|#

(require "../../parser/string-fn.rkt"
         "../../parser/HumdrumSyntax.rkt"
         test-engine/racket-tests)

; split
(check-expect (split "" TokenSeparator) empty)
(check-expect (split "**kern" TokenSeparator) (list "**kern"))
(check-expect (split "**kern\t**kern\t**kern" TokenSeparator)
              (list "**kern" "**kern" "**kern"))
(check-expect (split "**kern\t**dynam\t**kern\t**text" TokenSeparator)
              (list "**kern" "**dynam" "**kern" "**text"))

; gather
(check-expect (gather empty TokenSeparator) "")
(check-expect (gather (list "**kern") TokenSeparator) "**kern")
(check-expect (gather (list "**kern" "**kern" "**kern") TokenSeparator)
              "**kern\t**kern\t**kern")
(check-expect (gather (list "**kern" "**dynam" "**kern" "**text") TokenSeparator)
              "**kern\t**dynam\t**kern\t**text")

(test)
