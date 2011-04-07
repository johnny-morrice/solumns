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

(require "grid.rkt"
	 "../grid.rkt"
	 "fader-canvas.rkt")

(provide gui-grid-fader%)

; TODO The existence of this pointless fucking class shows that
; this is designed a little wrong
(define/contract gui-grid-fader%
		 (class/c [fade (->m 
				  (and/c real? positive?)
				  (is-a?/c grid%)
				  (listof (vectorof exact-nonnegative-integer?))
				void)]
			  (init-field [canvas (is-a?/c fader-canvas%)]))
		 (class gui-grid%
			(super-new)

			; Fade out some bricks
			(define/public (fade time grid bricks)
			  (send (get-field canvas this) fade time grid bricks))))
