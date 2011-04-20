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
	 "updater.rkt"
	 "../../column.rkt")

(provide dropper-controller%)

; A controller that drops blocks and moves them when the player presses
; the appropriate keys
(define/contract dropper-controller%
		 (and/c controller-class/c
			(class/c [gravity (->m void)]
				 [add-column (->m exact-nonnegative-integer?
						  exact-nonnegative-integer?
						  column?
						  void)]
				 [landed (->m any)]))

		 (class updater-controller%
			(super-new)

			(override step
				  left-press
				  right-press
				  up-press
				  down-press
				  down-release)
			(public gravity add-column landed)

			(field (throw #f)
			       (falling #f))

			; Add a new column
			(define (add-column x y col)
			  (send (get-field model this) add-column x y col)
			  (set! falling #t))

			; Set input states when the player presses keys
			(define (left-press)
			  (when falling 
			    (send (get-field model this) left)))

			(define (right-press)
			  (when falling
			    (send (get-field model this) right)))

			(define (down-press)
			  (when falling
			    (set! throw #t)))

			(define (up-press)
			  (when falling
			    (send (get-field model this) shift)))

			; Stop falling!
			(define (down-release)
			  (set! throw #f))

			; Let gravity act on the column
			(define (gravity)
			  (if throw
			    (send (get-field model this) throw)
			    (send (get-field model this) drop)))

			; The column has landed
			(define (landed)
			  (set! falling #f))

			; Perform a step of the game loop
			(define (step)
			  (super step)
			  (when falling
			    (when (gravity)
			      (landed))))))

