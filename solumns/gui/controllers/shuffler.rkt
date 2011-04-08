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

(require "fader.rkt"
	 "../../colgorithms/shuffler.rkt")

(provide shuffler-controller%)

; A controller that shuffles the shuffler% colgorithm's
; columns every time it is started
(define/contract shuffler-controller%
		 (class/c (init-field [colgorithm (is-a?/c shuffler%)]))

		 (class fader-controller%
			(super-new)

			(override start)

			; Shuffle the columns then start the controller
			(define (start)
			  (log-info "Shuffling...")
			  (send (get-field colgorithm this) shuffle-columns)
			  (log-info "Shuffling done.")
			  (super start))))

