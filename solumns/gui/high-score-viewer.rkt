#lang racket/gui

; Copyright 2011 John Morrice
;
; This file is part of Solumns. 
;
; Solumns is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; Foobar is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with Solumns.  If not, see <http://www.gnu.org/licenses/>.

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
			  (log-info (format "scores were ~a\n" scores))
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

