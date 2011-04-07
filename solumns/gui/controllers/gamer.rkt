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

(require "../controller.rkt"
	 "../../colgorithm.rkt"
	 "../../grid.rkt"
	 "../../util.rkt"
	 "dropper.rkt")

(provide gamer-controller%)

; Play a game of columns!
(define/contract gamer-controller%
		 (class/c (init-field [grid (is-a?/c grid%)]
				      [colgorithm colgorithm/c])
			  [eliminate (->m (listof (vectorof exact-nonnegative-integer?)))]
			  [lose (->m any)]
			  [next-column (->m (is-a?/c grid%)
					    column?)]
			  (init-field [acceleration (and/c real? positive?)]
				      [gravity-delay (and/c real? positive?)]))
			  

		 (class dropper-controller%
			(super-new)

			(init-field grid colgorithm acceleration gravity-delay)

			(override landed)

			(public eliminate lose next-column)

			; Perform elimination on the grid.
			; Return the blocks removed
			(define (eliminate)
			  (send grid elimination-step))

			; You have lost :(
			(define (lose)
			  (send this stop))

			; Given a grid (NOT the same as the grid field), find the next column
			(define (next-column clone)
			  (send colgorithm next clone))

			; The column has landed.
			(define (landed)
			  (super landed)
			  (send (get-field model this) accelerate acceleration)
			  (let* [(clone (send grid clone)) 
				 (lost? (begin
					  (send clone reduce)
					  (send clone lost?)))
				 (next #f)]
			  ; Find the other column in another thread
			  (when (not lost?)
			    (thread (lambda ()
				      (set! next (send this next-column clone)))))
			  ; Do some special effects while we wait for the next column
			  (do []
			    [(= (length (send this eliminate)) 0)]
			    (sleep/yield gravity-delay)
			    (send grid gravity))
			  ; Have we lost?
			  (if lost?
			    (send this lose)
			    (begin
			      ; Wait till the column is ready
			      (do []
				[next]
				(sleep/yield 0.01))
			      ; Add the column!
			      (send this add-column
				    (inexact->exact (floor (/ (- (get-field width grid) 1)
							      2)))
				    (- (get-field height grid) 1)
				    next)))))))
