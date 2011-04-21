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
	 "c/elimination-step.rkt")

(provide cgrid%)

; Grid that uses C for the elimination step
(define cgrid%
  (class grid%
	 (super-new)

	 (override elimination-step)

	 (field [elim (eliminator (get-field width this) (get-field height this))])

	 (define (elimination-step)
	   (call-with-values
	     (lambda ()
	       (elim (get-field matrix this)))
	     (lambda (new-matrix deleted)
	       (set-field! matrix this new-matrix)
	       deleted)))))


