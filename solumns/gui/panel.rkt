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

(require "controller.rkt")

(provide solumns-panel%)

; Frame that passes user input actions to a controller/c
(define/contract solumns-panel%
		 (class/c [controller-is (->m controller/c
					      void)])
		 (class vertical-panel%
			(super-new)

			(field (controller #f))

			(override on-subwindow-char on-superwindow-show)

			(public controller-is)

			; Add the controller
			(define (controller-is c)
			  (set! controller c))

			(define (on-subwindow-char receiver event)
			  (when controller
			    (case (send event get-key-code)
			      [(left)   (send controller left-press)]
			      [(right)  (send controller right-press)]
			      [(up)     (send controller up-press)]
			      [(down)   (send controller down-press)]
			      [(release) (case (send event get-key-release-code)
					   [(down)  (send controller down-release)])])))

			(define (on-superwindow-show shown?)
			  (super on-superwindow-show shown?)
			  (when (and (not shown?) controller)
			    (send controller stop)))))

