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

(require "panel.rkt"
	 "pause-status.rkt")

(provide pauser-panel%)

; Frame that detects pause events and tells the controller to pause
(define/contract pauser-panel%
		 (class/c (init-field [pause-status (is-a?/c pause-status%)]))

		 (class solumns-panel%
			(super-new)

			(init-field pause-status)

			(override on-subwindow-char)

			; Pause the controller
			(define (pause-event)
			  (send pause-status toggle-pause))

			; Detect space bar and pause
			(define (on-subwindow-char receiver event)
			  (when (get-field controller this)
			    (case (send event get-key-code)
			      [(#\space) (pause-event)]
			      [else (super on-subwindow-char receiver event)])))))

