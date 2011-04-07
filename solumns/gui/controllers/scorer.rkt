#lang racket

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
			    

