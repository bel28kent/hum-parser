#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  hum-parser: functions: predicates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require racket/bool
         racket/list
         racket/local
         "../data-definitions/data-definitions.rkt"
         "abstract.rkt")

(provide (all-defined-out))

; reference?
; String -> Boolean
; produce true if string starts with REFERENCE-TAG

(define (reference? string)
  (tag=? string 3 REFERENCE-TAG))

; global-comment?
; String -> Boolean
; produce true if string starts with GLOBAL-COMMENT-TAG

(define (global-comment? string)
  (and (tag=? string 2 GLOBAL-TAG)
       (not (reference? string))))

; local-comment?
; String -> Boolean
; produce true if string starts with LOCAL-COMMENT-TAG

(define (local-comment? string)
  (and (tag=? string 1 LOCAL-TAG)
       (andmap not (valmap string (list reference? global-comment?)))))

; metadata?
; String -> Boolean
; produce true if string is a type of metadata

(define (metadata? string)
  (ormap true?
         (valmap string (list reference? global-comment? local-comment?))))

; exclusive-interpretation?
; String -> Boolean
; produce true if string starts with EXCLUSIVE-TAG

(define (exclusive-interpretation? token)
  (tag=? token 2 EXCLUSIVE-TAG))

; tandem-interpretation?
; String -> Boolean
; produce true if string starts with TANDEM-TAG

(define (tandem-interpretation? token)
  (and (tag=? token 1 TANDEM-TAG)
       (> (string-length token) 1)
       (not (exclusive-interpretation? token))))

; null-interpretation?
; String -> Boolean
; produce true if string exactly matches TANDEM-TAG

(define (null-interpretation? token)
  (and (tag=? token 1 TANDEM-TAG)
       (= 1 (string-length token))))

; interpretation?
; String -> Boolean
; produce true if string is exclusive or tandem interpretation

(define (interpretation? token)
  (ormap true? (valmap token (list exclusive-interpretation?
                                   tandem-interpretation?
                                   null-interpretation?))))

; spine-split?
; String -> Boolean
; produce true if string equals SPLIT-TOKEN

(define (spine-split? token)
  (string=? token SPLIT-TOKEN))

; spine-join?
; String -> Boolean
; produce true if string equals JOIN-TOKEN

(define (spine-join? token)
  (string=? token JOIN-TOKEN))

; spine-terminator?
; String -> Boolean
; produce true if string equals TERMINATOR

(define (spine-terminator? token)
  (string=? token TERMINATOR))

; spine-structure?
; String -> Boolean
; produce true if string is spine split, spine join, or terminator

(define (spine-structure? token)
  (ormap true?
         (valmap token (list spine-split? spine-join? spine-terminator?))))

; measure?
; String -> Boolean
; produce true if string starts with MEASURE-TAG

(define (measure? token)
  (tag=? token 1 MEASURE-TAG))

; clef?
; String -> Boolean
; produce true if string starts with "^\\*m?clef"

(define (clef? token)
  (not (false? (regexp-match #px"^\\*m?clef" token))))

; time-sig?
; String -> Boolean
; produce true if string starts with "(^\\*m{1,2}et.*$)|(^\\*M[\\d]+/[\\d]+$)"

(define (time-sig? token)
  (not
    (false? (regexp-match #px"(^\\*m{1,2}et.*$)|(^\\*M[\\d]+/[\\d]+$)" token))))

; key-sig?
; String -> Boolean
; produce true if string matches "\\*k\\[.*\\]"

(define (key-sig? token)
  (not (false? (regexp-match #px"\\*k\\[.*\\]" token))))

; key-label?
; String -> Boolean
; produce true if string matches "\\*[a-gA-G](-|#)?:"

(define (key-label? token)
  (local [(define matches (regexp-match* #px"\\*([a-gA-G]|X)(-|#)?:" token))]
    (not (empty? matches))))

; key-label?
; String -> Boolean
; produce true if string equals "*kcancel"

(define (key-cancel? token)
  (string=? "*kcancel" token))

; staff-number?
; String -> Boolean
; produce true if string matches "\\*staff[0-9]+"

(define (staff-number? token)
  (not (false? (regexp-match #px"\\*staff[0-9]+" token))))

; instrument-class?
; String -> Boolean
; produce true if string matches "^\\*I.*$"

(define (instrument-class? token)
  (not (false? (regexp-match #px"^\\*I.*$" token))))

; ottava?
; String -> Boolean
; produce true if string matches "^\\*X?8.+$"

(define (ottava? token)
  (not (false? (regexp-match #px"^\\*X?8.+$" token))))

; group-attribution?
; String -> Boolean
; produce true if string matches "^\\*grp:.+$"

(define (group-attribution? token)
  (not (false? (regexp-match #px"^\\*grp:.+$" token))))

; part-number?
; String -> Boolean
; produce true if string matches "^\\*part[[:digit:]]+$"

(define (part-number? token)
  (not (false? (regexp-match #px"^\\*part[[:digit:]]+$" token))))

; metronome-marking?
; String -> Boolean
; produce true if string matches "^\\*MM[\\d]+\\.?[\\d]*$"

(define (metronome-marking? token)
  (not (false? (regexp-match #px"^\\*MM[\\d]+\\.?[\\d]*$" token))))

; cue-sized-notes?
; String -> Boolean
; produces true if string matches "^\\*X?cue$"

(define (cue-sized-notes? token)
  (not (false? (regexp-match #px"^\\*X?cue$" token))))

; tuplet?
; String -> Boolean
; produces true if string matches "^\\*X?tuplet$"

(define (tuplet? token)
  (not (false? (regexp-match #px"^\\*X?tuplet$" token))))

; tremolo?
; String -> Boolean
; produces true if string matches "^\\*X?tremolo$"

(define (tremolo? token)
  (not (false? (regexp-match #px"^\\*X?tremolo$" token))))

; pedal-marking?
; String -> Boolean
; produces true if string matches "^\\*X?ped"

(define (pedal-marking? token)
  (not (false? (regexp-match #px"^\\*X?ped" token))))

; form-marker?
; String -> Boolean
; produces true if string matches "^\\*>.*$"

(define (form-marker? token)
  (not (false? (regexp-match #px"^\\*>.*$" token))))

; bracket-tuplet?
; String -> Boolean
; produces true if string matches "^\\*X?brackettup$"

(define (bracket-tuplet? token)
  (not (false? (regexp-match #px"^\\*X?brackettup$" token))))

; flip-subspines?
; String -> Boolean
; produces true if string matches "^\\*X?flip$"

(define (flip-subspines? token)
  (not (false? (regexp-match #px"^\\*X?flip$" token))))

; above-staff?
; String -> Boolean
; produces true if string matches "^\\*above"

(define (above-staff? token)
  (not (false? (regexp-match #px"^\\*above" token))))

; below-staff?
; String -> Boolean
; produces true if string matches "^\\*below"

(define (below-staff? token)
  (not (false? (regexp-match #px"^\\*below" token))))

; center-staff?
; String -> Boolean
; produces true if string matches "^\\*center"

(define (center-staff? token)
  (not (false? (regexp-match #px"^\\*center" token))))

; ligature-bracket?
; String -> Boolean
; produces true if string matches "^\\*X?lig$"

(define (ligature-bracket? token)
  (not (false? (regexp-match #px"^\\*X?lig$" token))))

; rhythmic-scaling-factor?
; String -> Boolean
; produces true if string matches "^\\*rscale" 

(define (rhythmic-scaling-factor? token)
  (not (false? (regexp-match #px"^\\*rscale" token))))

; tasto-solo?
; String -> Boolean
; produces true if string matches  "\\*solo"

(define (tasto-solo? token)
  (not (false? (regexp-match #px"\\*solo" token))))

; end-tasto-solo?
; String -> Boolean
; produces true if string matches "\\*accomp"

(define (end-tasto-solo? token)
  (not (false? (regexp-match #px"\\*accomp" token))))

; spine-data?
; String -> Boolean
; produce true if string is not METADATA and is not another TOKEN type

(define (spine-data? token)
  (andmap not
          (valmap token (list metadata?
                              interpretation?
                              spine-structure?
                              measure?
                              null-spine-data?))))

; null-spine-data?
; String -> Boolean
; produce true if string equals "."

(define (null-spine-data? token)
  (string=? "." token))

; local-comment-token?
; String -> Boolean
; produce true if string starts with "!"

(define (local-comment-token? token)
  (not (false? (regexp-match #px"!.*" token))))

; kern?
; Token -> Boolean
; produce true if token-token equals "**kern"

(define (kern? token)
  (string=? "**kern" (token-token token)))

; dynam?
; Token -> Boolean
; produce true if token-token equals "**dynam"

(define (dynam? token)
  (string=? "**dynam" (token-token token)))
