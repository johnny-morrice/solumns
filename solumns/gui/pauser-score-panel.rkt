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

(require "restarter-score-panel.rkt"
	 "pause-status.rkt")

(provide pauser-score-panel%)

; Score panel that has a pause button
(define/contract pauser-score-panel%
		 (class/c (init-field [pause-status (is-a?/c pause-status%)]))
		 (class restarter-score-panel%
			(super-new)

			(init-field pause-status)

			(new button%
			     [parent this]
			     [label "Pause/Unpause (Spacebar)"]
			     [callback
			       (lambda (me evt)
				 (send pause-status toggle-pause))])))
