#lang racket/gui

(provide score-panel%)

; Tell the player the score and other useful information.
; Inform the player when he lost.
(define/contract score-panel%
  (class/c [score-now (->m exact-nonnegative-integer?
			   void)]
	   [search-time (->m (and/c real? positive?)
				 void)]
	   [game-over (->m void)]
	   (init-field [parent (is-a?/c window<%>)]))

  (class object%
	 (super-new)

	 (public score-now search-time game-over)

	 (init-field parent)

	 (field (score-message (new message%
				    [parent parent]
				    [label "Score: 0"]
				    [auto-resize #t]))
		(generation-message (new message%
					 [parent parent]
					 [label ""]
					 [auto-resize #t])))
	 ; It's game over man!
	 (define (game-over)
	   (new message%
		[parent (get-field parent this)]
		[label "Game over!"])
	   (send parent refresh))

	 ; Set the score
	 (define (score-now n)
	   (send score-message set-label
		 (format "Score: ~a" n))
	   (send parent refresh))

	 ; Set the time it took to generate the last block
	 (define (search-time t)
	   (send generation-message set-label
		 (format "Column found in ~ams" t))
	   (send parent refresh))))

