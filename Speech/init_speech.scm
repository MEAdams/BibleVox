#!/usr/bin/festival --script
;; ===========================================================================
;; File    : init_speech.scm
;; Created : 2016.08.10
;; Release : 2016.08.10
;; Version : 2016.08.29
;; Author  : M.E.Adams
;; Purpose : Configure festival for suitable Bible narration
;; --------:------------------------------------------------------------------
;; Depends : 1. This script
;;         : 2. Festival speech engine release 2.4 
;;         : 3. Diatheke command line SWORD frontend version 4.7
;;         : 4. M.E.Adams Festival lexicon pronunciation corrections
;; --------:------------------------------------------------------------------
;; Notes & : 1. My system specifications (performance baseline):
;; Assumes :    amd64 (i.e. x86-64) Ubuntu 14.04 LTS
;;         :    2GHz i7-4510U CPU w/ 8GB RAM and Solid State HD
;;         : 2. Doesn't look like the Festival REPL supports printing to
;;         :    STDOUT will performing TTS processing. All prints are getting
;;         :    spooled and dumped all at once after TTS processing has
;;         :    completed.
;; --------:------------------------------------------------------------------
;; To Do   : 1. Report to CMU the bug documented herein
;;         : 2. Report to Ubuntu the diatheke bug noted in sword_speak.bash
;;         : 3. Should add pauses for phrases offet by double (wide) hyphens
;; ===========================================================================
;; Script files must explicitly load initialization files if desired.
(load (path-append datadir "init.scm"))

;; M.E.Adams modifications:

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

;; Modified main TTS processing loop including diagnostic function
;;(set! tts_hooks (list utt.synth token-dump utt.play))

;; Bible narration:
;; mea-2016.08.10:

;; Select narrator's voice
;(voice_cmu_us_bdl_cg)
;(voice_cmu_us_slt_cg)
;(voice_cmu_us_rms_cg)
(voice_cmu_us_awb_cg)

;; this works from within a script file or within festival REPL. But,
;; not in the initialization files.
(Param.set 'Duration_Stretch 1.1)

;; This does not spool, but processes only one line at a time, which
;; causes long pauses between utterances. But, it does play the final
;; utterance of multi-line texts. This is useful for non-deterministic
;; process during developments and studies.
;;(tts_file "-")

;; This does spool, but does not play the final utterance of multi-line
;; text (bug). However, piping text to "festival --tts" does complete.
;; See the (define (tts file mode) function in festival/tts.scm file.
;; (audio_mode 'sync) is commented out with "Hmm this is probably bad".
;; He was probably correct, but it should probably be as I have below
;; with setting the 'close mode, not 'sync.
;;(audio_mode 'async)  ;; process next while speaking prior
;;(tts_file "-")       ;; no file name, so get from stdin

;;(audio_mode 'close)  ;; insure final utterance is processed

;; The function (tts) is a simple wrapper performing the above first
;; two lines. However, the final utterance is not being processed. So,
;; the third line above is needed to force the processing of the final
;; utterance remaining in the spooling buffer (festival bug).
(tts "-" nil)
(audio_mode 'close)
