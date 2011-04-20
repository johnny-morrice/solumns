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
;
(require ffi/unsafe)

(provide unsafe-eliminator)

; The shared object providing the elimination-step function
(define eliminator-lib
  (ffi-lib "work/elimination"))

; The elimination-step function
(define (unsafe-eliminator width height)
  (get-ffi-obj "elimination_step"
	       eliminator-lib
	       (_fun _int8
		     _int8
		     (_vector io (_vector io _int8 height) width)
		     (_vector io (_vector io _int8 height) width)
		     ->
		     _void)))
