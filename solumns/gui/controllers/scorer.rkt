#lang racket

(require "../controller.rkt"
	 "../score-panel.rkt"
	 "gamer.rkt")

(provide scorer-controller%)

; Play a game of columns that keeps track of the score
(define/contract scorer-controller%
		 (class/c (init-field [score-board (is-a?/c score-panel%)]))

		 (class gamer-controller%
			(super-new)

			(override eliminate next-column)

			(init-field score-board)
			(field (score 0))

			; We time the generation of new columns
			(define (next-column clone)
			  (let* [(t1 (current-milliseconds))
				 (next (super next-column clone))]
			    (send score-board search-time
				  (abs (- (current-milliseconds) t1)))
			    next))

			; When blocks are eliminated, we count the score.
			(define (eliminate)
			  (let* [(blocks (super eliminate))
				 (blocks-removed (length blocks))]
			    (when (> blocks-removed 0)
			      (set! score (+ score (* 100 blocks-removed)))
			      (send score-board score-now score))
			    blocks))))
			    

