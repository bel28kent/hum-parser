#lang racket/base

#|
	Enumeration of known tandem interpretations.

        Implemented as (hash Symbol RegularExpression ...)
|#

(require (only-in "abstract-fn.rkt" get-type hash-match? hash-member?))

(provide TandemInterpretation
         tandem-interpretation?
         tandem-interpretation-match?
         type-tandem)

(define TandemInterpretation (hash 'AboveStaff            "^\\*above$"
                                   'AllaOttava            "^\\*8va$"
                                   'BelowStaff            "^\\*below$"
                                   'BracketTuplet         "^\\*brackettup$"
                                   'BreakTuplet           "^\\*tupbreak$"
                                   'CancelKeySignature    "^\\*kcancel$"
                                   'CenterStaff           "^\\*center$"
                                   'Clef                  "^\\*clef[FGC]\\d$"
                                   'CueSizedNotes         "^\\*cue$"
                                   'EndAllaOttava         "^\\*X8va$"
                                   'EndBracketTuplet      "^\\*Xbrackettup$"
                                   'EndFlipSubspines      "^\\*Xflip$"
                                   'EndLigatureBracket    "^\\*Xlig$"
                                   'EndNumberTuplet       "^\\*Xtuplet$"
                                   'EndOttavaBassa        "^\\*X8ba$"
                                   'EndPedalMarking       "^\\*Xped$"
                                   'EndTremolo            "^\\*Xtremolo$"
                                   'ExpansionList         "^\\*>.*$"
                                   'FlipSubspines         "^\\*flip$"
                                   'GroupAttribution      "^\\*grp:\\w$"
                                   'GroupNumber           "^\\*group\\d+$"
                                   'InstrumentClass       "^\\*(m|o)?I$"
                                   'KeyLabel              "^\\*[a-gA-GX][-#]?:$"
                                   'KeySignature          "^\\*k\\[([a-g][-#])*\\]$"
                                   'LigatureBracket       "^\\*lig$"
                                   'MetronomeMarking      "^\\*MM\\d+$"
                                   'NullInterpretation    "^\\*$"
                                   'NumberTuplet          "^\\*tuplet$"
                                   'OttavaBassa           "^\\*8ba$"
                                   'PartNumber            "^\\*part\\d+$"
                                   'PedalMarking          "^\\*ped$"
                                   'RhythmicScalingFactor "^\\*rscale:\\d+(/\\d+)?$"
                                   'SpineJoin             "^\\*v$"
                                   'SpineSplit            "^\\*\\^$"
                                   'SpineTerminator       "^\\*-$"
                                   'StaffNumber           "^\\*staff\\d+$"
                                   'TimeSignature         "^\\*M\\d+/\\d+$"
                                   'Tremolo               "^\\*tremolo$"
))

(define (tandem-interpretation? str)
  (hash-member? TandemInterpretation str))

(define (tandem-interpretation-match? interp str)
  (hash-match? TandemInterpretation interp str))

(define (type-tandem str)
  (get-type str TandemInterpretation 'Unknown))
