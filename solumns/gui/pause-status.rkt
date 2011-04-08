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

(provide pause-status%)

; Is the game paused?
(define/contract pause-status%
		 (class/c [paused? (->m boolean?)]
			  [toggle-pause (->m void)])

		 (class object%
			(super-new)

			(field [paused #f])

			(public toggle-pause paused?)

			; Either pause or unpause
			(define (toggle-pause)
			  (set! paused (not paused))
  			  (log-info (format "paused toggled to ~a\n" paused)))

			; Are we paused?
			(define (paused?)
			  paused)))
