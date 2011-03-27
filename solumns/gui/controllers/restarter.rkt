#lang racket/gui

(require "high-scorer.rkt")

(provide restarter-controller%)

; A solumns controller that will let you restart the game.
(define/contract restarter-controller%
		   (class/c (init-field [restart-callback (-> void)]))

		   (class high-score-controller%
			  (super-new)

			  (override on-no-high-score on-high-score-saved)
			  
			  (init-field restart-callback)

			  ; Create a button on the score board
			  ; that restarts the game
			  (define (make-restart-button)
			    (log-info "making restart button")
			    (new button%
				 [parent (get-field score-board this)]
				 [label "Play again"]
				 [callback
				   (lambda (me evt)
				     (restart-callback))]))

			  ; When the high score is saved, create the
			  ; restart game button
			  (define (on-high-score-saved)
			    (super on-high-score-saved)
			    (make-restart-button))

			  ; When the player hasn't made a high score,
			  ; create the restart button
			  (define (on-no-high-score)
			    (super on-no-high-score)
			    (make-restart-button))))
		   
