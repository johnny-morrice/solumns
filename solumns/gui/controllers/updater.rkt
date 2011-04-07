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
	 "../grid.rkt")

(provide updater-controller%)

; A controller that just updates the display
(define/contract updater-controller%
		 (and/c controller-class/c
			(class/c
			  (init-field [game-delay (and/c real? positive?)]
				      [model (is-a?/c gui-grid%)])))
		 (class object%
			(super-new)

			(init-field model game-delay)
			(field (runner #f))

			(public left-press
				right-press
				up-press
				down-press
				down-release
				start stop step)

			; Player presses left
			(define (left-press)
			  (void))

			; Player presses right
			(define (right-press)
			  (void))

			; Player presses up
			(define (up-press)
			  (void))

			; Player presses down
			(define (down-press)
			  (void))

			; Player releases down
			(define (down-release)
			  (void))

			; The game is started
			(define (start)
			  (set! runner (thread main-loop))
			  (log-info "Controller started"))

			; The game should be immediately stopped
			(define (stop)
			  (when runner
			      (log-info "Controller stopping...")
			      (kill-thread runner)))

			; This step should be overridden by subclasses!
			(define (step)
			  (sleep/yield game-delay))

			; The main game loop
			(define (main-loop)
			  (step)
			  (main-loop))))




