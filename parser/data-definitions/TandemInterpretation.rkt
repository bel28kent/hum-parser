#lang racket/base

#|
	Enumeration of known tandem interpretations.

        Implemented as (hash Symbol RegularExpression ...)
|#

(require racket/contract
         racket/list
         racket/local)

(provide TandemInterpretation
         tandem-interpretation?
         tandem-interpretation-match?)

(define TandemInterpretation (hash 'AboveStaff            "^\\*above"
                                   'AllaOttava            "^\\*8va"
                                   'BelowStaff            "^\\*below"
                                   'BracketTuplet         "^\\*brackettup"
                                   'BreakTuplet           "^\\*tupbreak"
                                   'CancelKeySignature    "^\\*kcancel"
                                   'CenterStaff           "^\\*center"
                                   'Clef                  "^\\*clef"
                                   'CueSizedNotes         "^\\*cue"
                                   'EndAllaOttava         "^\\*X8va"
                                   'EndBracketTuplet      "^\\*Xbrackettup"
                                   'EndFlipSubspines      "^\\*Xflip"
                                   'EndLigatureBracket    "^\\*Xlig"
                                   'EndNumberTuplet       "^\\*Xtuplet"
                                   'EndOttavaBassa        "^\\*X8ba"
                                   'EndPedalMarking       "^\\*Xped"
                                   'EndTremolo            "^\\*Xtremolo"
                                   'ExpansionList         "^\\*>"
                                   'FlipSubspines         "^\\*flip"
                                   'GroupAttribution      "^\\*grp:"
                                   'GroupNumber           "^\\*group\\d+"
                                   'InstrumentClass       "^\\*(m|o)?I"
                                   'KeyLabel              "^\\*k\\["
                                   'KeySignature          "^\\*[A-Ga-g][#-]?:"
                                   'LigatureBracket       "^\\*lig"
                                   'MetronomeMarking      "^\\*MM"
                                   'NullInterpretation    "^\\*$"
                                   'NumberTuplet          "^\\*tuplet"
                                   'OttavaBassa           "^\\*8ba"
                                   'PartNumber            "^\\*part\\d+"
                                   'PedalMarking          "^\\*ped"
                                   'RhythmicScalingFactor "^\\*rscale:\\d+(/\\d+)?"
                                   'SpineJoin             "^\\*v"
                                   'SpineSplit            "^\\*\\^"
                                   'SpineTerminator       "^\\*-"
                                   'StaffNumber           "^\\*staff\\d+"
                                   'TimeSignature         "^\\*M\\d+/\\d+"
                                   'Tremolo               "^\\*tremolo"
))

(define/contract (tandem-interpretation? str)
  (-> string? boolean?)
  (local [(define (tandem-interpretation? keys)
            (cond [(empty? keys) #f]
                  [(tandem-interpretation-match? (first keys) str) #t]
                  [else
                    (tandem-interpretation? (rest keys))]))]
    (tandem-interpretation? (hash-keys TandemInterpretation))))

(define/contract (tandem-interpretation-match? interp str)
  (-> symbol? string? boolean?)
  (regexp-match? (pregexp
                   (hash-ref TandemInterpretation interp))
                 str))
