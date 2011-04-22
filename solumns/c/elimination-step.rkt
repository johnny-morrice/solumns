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
	 "../coordinate.rkt"
	 racket/unsafe/ops)

(provide/contract
  [eliminate (-> (vectorof (vectorof exact-nonnegative-integer?))
		 (values (vectorof (vectorof exact-nonnegative-integer?))
			 (listof coordinate/c)))])

; The elimination-step function
(define (eliminate matrix)
  (let* [(width (vector-length matrix))
	 (height (vector-length (vector-ref matrix 0)))
	 (cmatrix (unsafe-new-matrix width height))]
    (for [(i (in-range width))]
	 (let [(ccol (unsafe-get-column cmatrix i))
	       (rcol (vector-ref matrix i))]
	   (for [(j (in-range height))]
		(unsafe-write-colour ccol j (vector-ref rcol j)))))
    (let* [(crecord (unsafe-eliminate width height cmatrix))
	   (cleaned (build-vector width
				  (lambda (i)
				    (build-vector height
						  (let [(ccol (unsafe-get-column cmatrix i))]
						    (lambda (j)
						      (unsafe-read-colour ccol j)))))))
	   (deleted
	     (flatten
	       (for/list [(i (in-range width))]
			 (let [(ccol (unsafe-get-column crecord i))]
			   (for/fold 
			     [(gone '())]
			     [(j (in-range height))]
			     (let [(clr (unsafe-read-colour ccol j))]
			       (if (unsafe-fx> clr 0)
				 (cons (vector i j clr)
				       gone)
				 gone)))))))]
      (unsafe-free-matrix width cmatrix)
      (unsafe-free-matrix width crecord)
      (values cleaned deleted))))

