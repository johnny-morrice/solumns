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
		   
