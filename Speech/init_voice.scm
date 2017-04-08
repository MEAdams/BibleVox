#!/usr/bin/festival --script
;; ===========================================================================
;; File    : init_voice.scm
;; Project : BibleVox
;; Date    : 2016.08.29
;; Author  : MEAdams
;; Purpose : Configure festival for RDT&E speaking
;; --------:------------------------------------------------------------------
;; Depends : 1. This script
;;         : 2. Festival speech engine release 2.4 
;;         : 3. Diatheke command line SWORD frontend version 4.7
;;         : 4. MEAdams Festival lexicon pronunciation corrections
;; --------:------------------------------------------------------------------
;; Notes & : 1. My system specifications (performance baseline):
;; Assumes :    amd64 (i.e. x86-64) Ubuntu 14.04 LTS
;;         :    2GHz i7-4510U CPU w/ 8GB RAM and Solid State HD
;;         : 2. Doesn't look like the Festival REPL supports printing to
;;         :    STDOUT while performing TTS processing. All prints are getting
;;         :    spooled and dumped all at once after TTS processing has
;;         :    completed.
;; --------:------------------------------------------------------------------
;; To Do   : 1. Develop processing loop mods to perform flat pronunciations
;;         :    useful for dictionary development and reference.
;; ===========================================================================
;; Script files must explicitly load initialization files if desired.
(load (path-append datadir "init.scm"))

;; MEAdams modifications:

;; mea-2016.08.24: New End-Of-Utterance tree (see festival/tts.scm)
;;
;; mea-mods include pause processing for comma and parenthesis characters.
;;
;; Note: The below comment "(2 nls)" means 2 new lines!
;; This is used to define utterance breaks in tts on files
(defvar mea_eou_tree 
  '((lisp_max_num_tokens > 200)
    ((1))
    ((n.whitespace matches ".*\n.*\n\\(.\\|\n\\)*") ;; significant break (2 nls)
     ((1))
     ((name matches "--+") ;; mea: what is this for?
     ((1))
     ((n.prepunctuation matches ".*(.*") ;; mea-2016.08.26: created "("
     ((1))
     ((punc matches ".*[\\?:!;,)].*") ;; mea-2016.08.26: added "," and ")"
      ((1))
      ((punc matches ".*\\..*")
       ((punc matches "..+") ;; longer punctuation string
	((punc matches "\\..*,") ;; for U.S.S.R., like tokens
	 ((0))
	 ((1)))
	;; This is to distinguish abbreviations vs periods
	;; These are heuristics
	((name matches "\\(.*\\..*\\|[A-Z][A-Za-z]?[A-Za-z]?\\|etc\\)") ;; abbrv
	 ((n.whitespace is " ")
	  ((0)) ;; if abbrev single space isn't enough for break
	  ((n.name matches "[A-Z].*")
	   ((1))
	   ((0))))
	 ((n.whitespace is " ") ;; if it doesn't look like an abbreviation
	  ((n.name matches "[A-Z].*") ;; single space and non-cap is no break
	   ((1))
	   ((0)))
	  ((1)))))
       ((0))))))))
  "mea_eou_tree
End of utterance tree.  A decision tree used to determine if the given
token marks the end of an utterance.  It may look one token ahead to
do this. [see Utterance chunking]")

;; Use mea End-Of-Utterance tree
(set! eou_tree mea_eou_tree)


;; Development notes and code:

;; uttType Words defined in /usr/share/festival/synthesis.scm:
;;
;; (defUttType Words
;;  (Initialize utt)
;;  (POS utt)
;;  (Phrasify utt)
;;  (Word utt)
;;  (Pauses utt)
;;  (Intonation utt)
;;  (PostLex utt)
;;  (Duration utt)
;;  (Int_Targets utt)
;;  (Wave_Synth utt))

;; uttType Text defined in /usr/share/festival/synthesis.scm:
;;
;; (defUttType Text
;;  (Initialize utt)
;;  (Text utt)
;;  (Token_POS utt)
;;  (Token utt)
;;  (POS utt)
;;  (Phrasify utt)
;;  (Word utt)
;;  (Pauses utt)
;;  (Intonation utt)
;;  (PostLex utt)
;;  (Duration utt)
;;  (Int_Targets utt)
;;  (Wave_Synth utt))

;; Experimenting shows print statements don't get dumped to STDOUT until
;; all speech processing has completed.

;; Diagnostic dump (dumps all tokens so, only use for shorter texts!)
(define (token-dump utt)
  "Output utt relation tree"
  (print (utt.relation_tree utt 'Token)) utt)

;;(gc-status nil)

;; Stardard main TTS processing loop (default)
(set! tts_hooks (list utt.synth utt.play))

;; Modified main TTS processing loop
;;(set! tts_hooks (list utt.synth token-dump utt.play))

;; Bible narration:
;; mea-2016.08.10:

;; Select narrator's voice
(voice_cmu_us_bdl_cg)
;;(voice_cmu_us_slt_cg)
;;(voice_cmu_us_rms_cg)
;;(voice_cmu_us_awb_cg)
;;(voice_kal_diphone)

;; -----------------------------------
;; Initialized configuration
;; -----------------------------------
;; Duration_Method  : Default
;; Duration_Stretch : 1
;; duffint_params   : ((start 130) (end 110))
;; Int_Method       : Intonation_Tree
;; Int_Target_Method: Int_Targets_LR (Note: used with ToBI)
;; -----------------------------------
;; Dictionary configuration:
(Param.set 'Duration_Method 'Default)
(Param.set 'Duration_Stretch 1.5)

;(set! duffint_params '((start 130) (end 100)))
;(Param.set 'Int_Method 'DuffInt)
;(Param.set 'Int_Target_Method Int_Targets_Default)

;; Load and evaluate each s-expression (scheme code) presented on STDIN
(load "-" nil)
