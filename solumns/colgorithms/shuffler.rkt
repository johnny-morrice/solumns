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

(require "occasional.rkt")

(provide shuffler%)

(provide/contract
  [shuffle (-> (listof any/c)
	       (listof any/c))])

; Shuffle a list
; Use Fisher-Yates algorithm
(define (shuffle li)
  (let [(ve (list->vector li))]
    (for [(i (in-range (sub1 (vector-length ve)) 1 -1))]
	 (let* [(j (random (add1 i)))
		(temp-i (vector-ref ve i))]
	   (vector-set! ve i (vector-ref ve j))
	   (vector-set! ve j temp-i)))
    (vector->list ve)))
	   
; This colgorithm is derived from occasional,
; but shuffles the order of the columns
; in order to create more interesting games.
(define/contract shuffler%
		 (class/c [shuffle-columns (->m void)])
		 (class occasional%
			(super-new)

			; Shuffle the order of the columns
			(define/public (shuffle-columns)
				       (set-field! columns this
						   (shuffle (get-field columns this))))))
