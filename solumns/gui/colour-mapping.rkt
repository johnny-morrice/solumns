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

; A hash of colour numbers as used by colgorithms to colors
(define colour-table
  (hash 0 '(0.9 0.0 0.0)
	1 '(0.9 0.9 0)
	2 '(0.0 0.9 0)
	3 '(0.0 0.0 0.9)
	4 '(0.0 0.81 0.81)
	5 '(0.87 0.0 1.0)
	6 '(0.45 0.45 0.45)
	7 '(0.545 0.32 0.176)
	8 '(0.91 0.588 0.478)))


; Map integers or #f to colours, recognised by gracket
(define (to-colour c)
  (hash-ref colour-table c))

(provide/contract
  [colour-table hash?]
  [to-colour (-> (and/c exact-nonnegative-integer?
			(lambda (n)
			  (< n (length (for/list
					 [(p (in-hash-keys colour-table))]
					 #f)))))
		 (listof (and/c real? (not/c negative?))))])

