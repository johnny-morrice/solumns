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

(require "unsafe/grid.rkt"
	 "../coordinate.rkt")

(provide/contract
  [eliminator (-> byte? byte?
		  (-> (vectorof (vectorof exact-nonnegative-integer?))
		      (values (vectorof (vectorof exact-nonnegative-integer?))
			      (listof coordinate/c))))])

; The elimination-step function
(define (eliminator width height)
  (let [(celim (unsafe-eliminator width height))]
    (lambda (matrix)
      (let* [(blank (build-vector width
				  (lambda (n)
				    (make-vector height 0))))]
	(call-with-values
	  (lambda ()
	    (celim width height matrix blank))
	  (log-debug "So we don't garbage collect the matrix: ~a\n" matrix)
	  (log-debug "So we don't garbage collect the blank: ~a\n" blank)
	  (lambda (cleaned record)
	    (let [(deleted (flatten
			     (for/list [(i (in-naturals))
					(bcol (in-vector record))]
				       (for/fold
					 [(deleted '())]
					 [(j (in-naturals))
					  (col (in-vector bcol))]
					 (if (> col 0)
					   (cons (vector i j col)
						 deleted)
					   deleted)))))]
	      (values cleaned deleted))))))))
