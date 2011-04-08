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

(require "score-panel.rkt")

(provide restarter-score-panel%)

; Score panel that can have button to restart game
(define/contract restarter-score-panel%
		 (class/c [make-restart-button (->m procedure? 
						    void)])
		 (class score-panel%
			(super-new)

			; Create a button to restart the game
			(define/public (make-restart-button cb)
				       (new button%
					    [parent this]
					    [label "Play again"]
					    [callback cb]))))
