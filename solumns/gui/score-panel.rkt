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

(provide score-panel%)

; Tell the player the score and other useful information.
; Inform the player when he lost.
(define/contract score-panel%
  (class/c [score-now (->m exact-nonnegative-integer?
			   void)]
	   [search-time (->m (and/c real? (or/c zero? positive?))
				 void)])

  (class vertical-panel%
	 (super-new)

	 (inherit refresh)

	 (public score-now search-time)

	 (field (score-message (new message%
				    [parent this]
				    [label "Score: 0"]
				    [auto-resize #t]))
		(generation-message (new message%
					 [parent this]
					 [label ""]
					 [auto-resize #t])))
	 ; Set the score
	 (define (score-now n)
	   (send score-message set-label
		 (format "Score: ~a" n))
	   (refresh))

	 ; Set the time it took to generate the last block
	 (define (search-time t)
	   (send generation-message set-label
		 (format "Column found in ~ams" t))
	   (refresh))))

