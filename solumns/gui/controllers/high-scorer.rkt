#lang racket/gui

(require "../high-score-viewer.rkt"
	 "../high-scores.rkt"
	 "scorer.rkt")

(provide high-score-controller%)

(set-default-high-scores)

; Record the player's high scores :D
(define/contract high-score-controller%
		 (class/c (field [score-win (or/c #f (is-a?/c window<%>))]))
		 (class scorer-controller%
			(super-new)

			(override lose)

			(field (score-win #f))

			; When you lose, try to record a high score.
			(define (lose)
			  (let [(old-scores (get-high-scores))
				(new-score (list #f (get-field score this)))]
			    (if (null? old-scores)
			      (new-high-score (list new-score))
			      (when (< (cadar (sort-scores old-scores)) (get-field score this))
				(new-high-score (cons new-score old-scores)))))
			    (super lose))

			; You have a new high score!
			(define (new-high-score scores)
			  (set! score-win
			    (new frame% [label "You have a new high score!"]))
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




