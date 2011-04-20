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

; A column is a vector of length 3, containing exact integers.
(define column?
  (flat-named-contract 'column
		       (lambda (candidate)
			 (and (vector? candidate)
			      (= (vector-length candidate) 3)
			      (andmap exact-nonnegative-integer? (vector->list candidate))
			      (not (and (= (vector-ref candidate 0)
					   (vector-ref candidate 1))
					(= (vector-ref candidate 1)
					   (vector-ref candidate 2))))))))

(provide/contract
  [column? contract?]
  [column-shift (-> column?
		    column?)])

; Produce the next arrangement of a column, like when the player presses up.
(define (column-shift col)
  (let [(next (vector 0 0 0))]
    (vector-set! next 2 (vector-ref col 1))
    (vector-set! next 1 (vector-ref col 0))
    (vector-set! next 0 (vector-ref col 2))
    next))
