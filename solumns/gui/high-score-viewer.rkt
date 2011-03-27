#lang racket/gui

(require "high-scores.rkt")

(provide high-score-viewer%)

; Allow the user to fill in their high scores!
; Scores should be added in decreasing order.
(define/contract high-score-viewer%
		 (class/c [new-hero (->m string?)] 
			  [display-scores (->m void)]
			  (init-field [scores (listof score?)]))

		 (class vertical-panel%
			(super-new)

			(init-field (scores '()))

			(field (who-dunnit-field #f))

			(public display-scores new-hero)

			; Display the scores
			(define (display-scores)
			  (printf "scores were ~a\n" scores)
			  (for [(i (in-range 1 (+ 1 (length scores))))
				(score scores)]
			       (display-score i (car score) (cadr score))))

			; Display a score
			(define (display-score pos who score)
			  (if who
			    (new message%
				 [parent this]
				 [label (format "~a.~a: ~a" pos who score)])
			    (let [(hoz
				    (new horizontal-panel%
					 [parent this]))]
			      (set! who-dunnit-field
				(new text-field%
				     [parent hoz]
				     [label (format "~a." pos)]))
			      (new message%
				   [parent hoz]
				   [label (format "~a" score)]))))

			; What was the name of the new champion?
			(define (new-hero)
			  (send who-dunnit-field get-value))))

