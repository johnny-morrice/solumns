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

(require "restarter.rkt"
	 "../grid-fader.rkt")

(provide fader-controller%)

(define/contract fader-controller%
		 (class/c (init-field [model (is-a?/c gui-grid-fader%)]))
		 (class restarter-controller%
			(super-new)

			(override eliminate)

			; Whenever blocks are eliminated, get the GUI to fade them out!
			(define (eliminate)
			  (let* [(blocks (super eliminate))
				 (special (send (get-field grid this) clone))]
			    (when (> (length blocks) 0)
			      (send (get-field model this)
				    fade
				    (get-field gravity-delay this)
				    special
				    blocks))
			    blocks))))
