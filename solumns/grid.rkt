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

(require racket/unsafe/ops
	 "column.rkt"
	 "coordinate.rkt")

(provide grid%)

(provide/contract
	 [coloured? (-> exact-nonnegative-integer?
			boolean?)])

; Is this a colour, safely?
(define (coloured? c)
  (unsafe-coloured? c))

; Is this a colour?
(define (unsafe-coloured? c)
  (unsafe-fx> c 0))

; A grid of blocks present on the screen.
(define/contract grid%
		 (class/c
		   [gravity (->m void)]
		   [elimination-step (->m (listof coordinate/c))]
		   [visit-squares (->m (-> exact-nonnegative-integer?
					   exact-nonnegative-integer?
					   exact-nonnegative-integer?
					   any)
				       (listof (listof any/c)))]
		   [visit-squares-matrix (->m (-> exact-nonnegative-integer?
						  exact-nonnegative-integer?
						  exact-nonnegative-integer?
						  any)
					      (vectorof (vectorof any/c)))]

		   [add-column (->m exact-nonnegative-integer?
				    exact-nonnegative-integer?
				    column?
				    void)]
		   [clone (->m (is-a?/c grid%))]
		   [size (->m exact-nonnegative-integer?)]
		   [reduce (->m void)]
		   [can-occupy? (->m exact-nonnegative-integer?
				     exact-nonnegative-integer?
				     boolean?)]
		   [drop-until (->m exact-nonnegative-integer?
				    exact-nonnegative-integer?
				    column?
				    void)]
		   [matrix-ref (->m exact-nonnegative-integer?
				    exact-nonnegative-integer?
				    exact-nonnegative-integer?)]
		   [greq? (->m (is-a?/c grid%)
				boolean?)])

		 (class object%
			(super-new)
			(init-field width height)

			(field [matrix
				 (build-vector width
					       (lambda (i) (build-vector height
									 (lambda (j) 0))))])

			; Mostly we expose so much so that the testing module can get at them
			; better to do this with module hiding
			(public gravity elimination-step add-column visit-squares visit-squares-matrix all-colours clone lost?
				size reduce matrix-set! can-occupy? drop-until heights tag around matrix-ref greq?)

			; Is the other grid the same as this?
			(define (greq? other)
			  (equal? (all-colours)
				  (send other all-colours)))

			; Return the heights of each column in a list.
			(define (heights)
			  (for/list [(x (in-range 0 (vector-length matrix)))]
				    (column-height x)))

			; Return the height of the column at x
			(define (column-height x)
			  (let* [(slice (vector-ref matrix x))
				 (places (vector->list slice))
				 (colours-end (member 0 places))]
			    (if colours-end
			      (- (length places) (length colours-end))
			      (length places))))

			; Have we lost?
			(define (lost?)
			  (ormap (lambda (h) (>= h height)) (heights)))

			; Assuming the grid is sane, can a new column sit in this position?
			(define (can-occupy? x y)
			  (and (in-matrix? x y)
			       (unsafe-fx= 0 (matrix-ref x y))))

			; Drop a column until it hits the block or floor above this position
			(define (drop-until x y col)
			  (add-column x (column-height x) col))

			; Clone this grid.
			(define (clone)
			  (let [(gen (new grid%
					  [width width]
					  [height height]))]
			    (visit-squares
			      (lambda (x y c)
				(send gen matrix-set! x y c)))
			    gen))

			; Return all squares around the neighbours and the object itself
			(define (around x y)
			  (filter vector?
				  (for*/list [(i (in-list '(-1 0 1)))
					      (j (in-list '(-1 0 1)))]
					     (let [(n (unsafe-fx+ x i))
						   (m (unsafe-fx+ y j))]
					       (if (in-matrix? n m)
						 (vector n m (matrix-ref n m))
						 #f)))))

			; Is this coordinate in the matrix?
			(define (in-matrix? x y)
			  (and (unsafe-fx>= x 0)
			       (unsafe-fx>= y 0)
			       (unsafe-fx< x width)
			       (unsafe-fx< y height)))

			(define (all-colours)
			  (visit-squares
			    (lambda (x y c) c)))

			; Apply gravity to a grid.
			(define (gravity)
			  (set! matrix
			    (vector-map
			      (lambda (col)
				(let [(dropped (vector-filter (lambda (x) (unsafe-coloured? x))
							      col))]
				  (vector-append dropped
						 (make-vector (- height (vector-length dropped)) 0))))
			      matrix)))

			; Get an element in the matrix
			(define (matrix-ref x y)
			  (vector-ref (vector-ref matrix x) y))

			; Set an element in the grid's matrix
			(define (matrix-set! x y val)
			  (when (in-matrix? x y)
			    (vector-set! (vector-ref matrix x) y val)))

			; Return the number of filled squares in the grid
			(define (size)
			  (apply + (heights)))

			; Perform elimination and gravity steps until there is no change!
			(define (reduce)
			  (do []
			    [(unsafe-fx= (length (elimination-step)) 0)]
			    (gravity)))

			(define (count-neighbours x y c)
			  (if (unsafe-coloured? c)
			    (foldr (lambda (ne total)
				     (if (eq? (vector-ref ne 2) c)
				       (unsafe-fx+ total 1)
				       total))
				   0 (around x y))
			    0))

			; Tag the squares based on their number of neighbours.
			; Return a matrix of said squares
			(define (tag)
			  (visit-squares-matrix
			    (lambda (x y c)
			      (count-neighbours x y c))))

			; Apply a single step of elimination to a grid (that is, removal of congruent elements)
			; Return number if squares were eliminated, false otherwise.
			;
			; This algorithm uses the fact that if three squares are connected, each square
			; is or is connected to at least one square that is connected to at least two others
			(define (elimination-step)
			  (let* [(tagged (tag))
				 (removing
				   (for*/fold
				     [(deleted '())]
				     [(x (in-range 0 width))
				      (y (in-range 0 height))]
				     (let [(c (matrix-ref x y))]
				       (if (and (unsafe-coloured? c)
						(ormap (lambda (pos)
							 (unsafe-fx>= (vector-ref (vector-ref tagged (vector-ref pos 0)) (vector-ref pos 1))
								      3))
						       (filter (lambda (pos) (eq? c (vector-ref pos 2)))
							       (around x y))))
					 (cons (vector x y c) deleted)
					 deleted))))]
			    (for-each
			      (lambda (pos)
				(matrix-set! (vector-ref pos 0) (vector-ref pos 1) 0))
			      removing)
			    removing))

			; Add a column, with the bottom of the column at the given position
			(define (add-column x y col)
			  (for [(c col)
				(i (in-range 0 3))]
			       (matrix-set! x (+ y i) c)))

			; Pass a function which visits all squares, return another matrix
			(define (visit-squares-matrix visitor)
			  (list->vector (map list->vector (visit-squares visitor))))

			; Pass a function which visits all squares in the matrix.
			(define (visit-squares visitor)
			  (for/list [(col matrix)
				     (i (in-range 0 (vector-length matrix)))]
				    (for/list [(square col)
					       (j (in-range 0 (vector-length col)))]
					      (visitor i j square))))))
