#lang racket

(require "../controller.rkt"
	 "../../colgorithm.rkt"
	 "../../grid.rkt"
	 "../../util.rkt"
	 "../score-panel.rkt"
	 "gamer.rkt")

(provide scorer-controller%)

; Play a game of columns that keeps track of the score
(define/contract scorer-controller%
		 (class/c (init-field [score-board (is-a?/c score-panel%)]))

		 (class gamer-controller%
			(super-new)

			(override eliminate lose next-column)

			(init-field score-board)
			(field (score 0))

			; When you lose, tell the score board
			(define (lose)
			  (send score-board game-over))

			; We time the generation of new columns
			(define (next-column clone)
			  (let* [(t1 (current-milliseconds))
				 (next (super next-column clone))]
			    (send score-board search-time
				  (abs (- (current-milliseconds) t1)))
			    next))

			; When blocks are eliminated, we count the score.
			(define (eliminate)
			  (let [(blocks-removed (super eliminate))]
			    (when blocks-removed
			      (set! score (+ score (* 100 blocks-removed)))
			      (send score-board score-now score))
			    blocks-removed))))
			    

