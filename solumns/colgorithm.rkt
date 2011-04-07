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

(require "grid.rkt")

(provide colgorithm-class/c
	 colgorithm/c)

; Macro that returns code for a contract on colgorithms
(define-syntax-rule (nexter contract-type)
		    (contract-type [next (->m (is-a?/c grid%) 
			           column?)]))

; Colgorithms are objects which provide an algorithm
; for determining the next column, given a grid%.
; This contract recognises a class
(define colgorithm-class/c
  (nexter class/c))

; This contract recognises an object of the class colgorithm/c
(define colgorithm/c
  (nexter object/c))


