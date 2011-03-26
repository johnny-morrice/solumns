#lang racket/gui

(require "../high-score-viewer.rkt"
	 "../high-scores.rkt"
	 "scorer.rkt")

(provide high-score-controller%)

(set-default-high-scores)

; A little frame for showing the high score
; that tells us if it dies, that is after the 
; high scores have been saved
(define score-frame%
  (class frame%
	 (super-new)

	 (override on-superwindow-show)

	 (init-field controller)

	 (define (on-superwindow-show shown?)
	   (when (not shown?)
	     (send controller on-high-score-saved)))))


	 

; Record the player's high scores :D
(define/contract high-score-controller%
		 (class/c (field [score-win (or/c #f (is-a?/c window<%>))])
			  [on-no-high-score (->m void)]
			  [on-high-score-saved (->m void)])
		 (class scorer-controller%
			(super-new)

			(override lose)

			(public on-no-high-score on-high-score-saved)

			(field (score-win #f))

			; Override this to provide custom behaviour when the player
			; did not achieve a high score
			(define (on-no-high-score)
			  (void))

			; Override this to provide custom behaviour when the player
			; does achieve a high score.
			; This will be triggered when the player has closed the
			; high score window
			(define (on-high-score-saved)
			  (void))

			; When you lose, try to record a high score.
			(define (lose)
			  (let [(old-scores (get-high-scores))
				(new-score (list #f (get-field score this)))]
			    (if (null? old-scores)
			      (new-high-score (list new-score))
			      (if (< (cadar (sort-scores old-scores)) (get-field score this))
				(new-high-score (cons new-score old-scores))
				(send this on-no-high-score)))
			    (super lose)))

			; You have a new high score!
			(define (new-high-score scores)
			  (set! score-win
			    (new score-frame%
				 [label "You have a new high score!"]
				 [controller this]))
			  (let* [(shorter-scores (top-ten scores))
				 (viewer
				   (new high-score-viewer%
					[parent score-win]
					[scores shorter-scores]))]
			    (new button%
				 [parent score-win]
				 [label "Awesome!"]
				 [callback (lambda (me evt)
					     (let [(new-scores (map (lambda (x)
								      (if (car x) x
									(list
									  (send viewer new-hero)
									  (cadr x))))
								    shorter-scores))]
					       (set-high-scores new-scores))
					     (send score-win show #f))])
			    (send score-win show #t)
			    (send viewer display-scores)))))




