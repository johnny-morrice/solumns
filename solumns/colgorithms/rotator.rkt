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

(require "shuffler.rkt"
	 "brute-force.rkt")

(provide rotator%)

; Like a shuffler but it randomly rotates the produced column,
; so they don't all come out pointing the same way.
(define rotator%
  (class shuffler%
	 (super-new)

	 (override next-evil)

	 (define (next-evil gr)
	   (let [(col (super next-evil gr))
		 (rots (random 3))]
	     (list-ref (three-cycle col) rots)))))

	     
