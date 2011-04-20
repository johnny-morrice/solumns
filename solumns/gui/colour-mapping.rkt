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

; The colours
(define red
  '(0.9 0.0 0.0))

(define yellow
  '(0.9 0.9 0))

(define green
  '(0.14 0.54 0.14))

(define blue
  '(0.15 0.25 0.54))

(define linen 
  '(0.98 0.94 0.90))

(define purple
'(0.407 0.09 0.55))

(define grey
  '(0.51 0.51 0.51))

(define brown
  '(0.32 0.21 0.16))

(define skin 
  '(1.0 0.501 0.478))

; A hash of colour numbers as used by colgorithms to colors
(define colour-table
  (hash 1 red
	2 yellow
	3 green
	4 blue
	5 linen
	6 purple
	7 grey
	8 brown
	9 skin))


; Map integers or #f to colours, recognised by gracket
(define (to-colour c)
  (hash-ref colour-table c))

(provide/contract
  [colour-table hash?]
  [to-colour (-> (and/c exact-nonnegative-integer?
			(lambda (n)
			  (<= n (length (for/list
					  [(p (in-hash-keys colour-table))]
					  #f)))))
		 (listof (and/c real? (not/c negative?))))])

