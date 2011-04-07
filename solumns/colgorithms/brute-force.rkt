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

(require "../grid.rkt"
	 "../colgorithm.rkt"
	 "random.rkt"
	 racket/unsafe/ops)

(provide brute-force%)

(provide/contract [permute (-> exact-nonnegative-integer?
			       (listof (listof column?)))]
		  [permute-singles (-> exact-nonnegative-integer?
				       (listof column?))]
		  [permute-doubles (-> exact-nonnegative-integer?
				       (listof column?))]
		  [three-cycle (-> column?
				   (listof column?))])

; Take a column and produce three columns; each of the columns that may be created when the player presses up!
(define (three-cycle col)
  (let* [(next (column-shift col))
	 (after (column-shift next))]
    (list col next after)))

; Colgorithm that explores the entire input space of columns and hence determines which column is least desirable.
(define/contract brute-force%
		 colgorithm-class/c
		 (class object%
			(super-new)

			(init colours)

			(field [columns (permute colours)]
			       [simple (make-rand colours)])

			(public next)

			; Find the next column by bruteforce search of the entire input space
			; if the grid is empty, give a random column
			(define (next gr)
			  (if (unsafe-fx= (send gr size) 0)
			    (send simple next gr)
			    (let* [(heights (send gr heights))
				   (next-positions
				     (for/list [(x (in-range 0 (length heights)))
						(y (in-list heights))]
					       (list x y)))
				   (candidates
				     (map (lambda (cols)
					    (list (car cols)
						  (argmin (lambda (gr)
							    (send gr size))
							  (flatten (map (lambda (col)
									  (possible-positions gr col next-positions))
									cols)))))
					  columns))]

			      ; Get the most difficult grid!
			      (car (argmax
				     (lambda (cnd)
				       (send (cadr cnd) size))
				     candidates)))))

			; Produce every possible position of the column in the grid
			(define (possible-positions gr col next-positions)
			  ; This is horrible.  How can I write such a simple function in such a contrived manner? 
			  (let* [(next-grids
				   (for/list [(pos (in-list next-positions))]
					     (let [(matrix (send gr clone))]
					       (send matrix add-column (car pos) (cadr pos) col)
					       (send matrix reduce)
					       matrix)))
				 (num-pos (length next-grids))
				 (width (get-field width gr))]

			    (if (= num-pos width)
			      next-grids
			      (raise (exn:fail:contract (format "The number of positions ~a is not equal to the width of the grid! ~a"
								num-pos width)
							(current-continuation-marks))))))))

; Take a column and return a new column with the last two elements swapped
(define (swap-last c)
  (vector (vector-ref c 0) (vector-ref c 2) (vector-ref c 1)))

; Create possible columns, with each colour different, with n colours
(define (permute-singles n)
  (if (> n 2)
    (let [(ending (vector (- n 3) (- n 2) (- n 1)))]
      ; Here we make columns which have no elements the same
      (let singles [(vs (list '#(0 1 2) '#(0 2 1)))]
	(let [(u (car vs))]
	  (if (not (equal? u ending))
	    (let* [(v (next-single n u))
		   (w (swap-last v))]
	      (singles (append (list v w) vs)))
	    vs))))
    '()))

; Create possible columns, with 2 colours the same, with n colours
(define (permute-doubles n)
  (let [(ending (vector (- n 1) (- n 2) (- n 2)))]
    (let doubles [(vs (list '#(0 1 1)))]
      (let [(u (car vs))]
	(if (not (equal? u ending))
		 (doubles (cons (next-double n (car vs)) vs))
		 vs)))))

; Creates all possible columns given n colours.
;
; Returns a vector of length (n^3 - n) / 3,
; each member of which is a vector of length three,
; containing columns - each of which can be rotated to produce the other two.
;
; Each column should be unique, amongst all the others returned.
;
; Look up some group theory, if this confuses you.
(define (permute n)
  (map three-cycle
       (append (permute-doubles n) (permute-singles n))))

; Given n colours, is the colour at the ith position in the column the max colour?
(define (max-colour? n i v)
  (= (vector-ref v i)
     (- n 1)))

; Produce a new column and pass it to a function along with functions to manipulate that column
(define (with-column-ops n v f)
  (local
    [(define cand
       (vector 0 0 0))
     (define (copy i)
       (vector-set! cand i
		    (vector-ref v i)))
     (define (inc i)
       (vector-set! cand i
		    (+ 1 (vector-ref v i))))]
    (f cand copy inc)))

; Given the number of colours, and a column which has three numbers all different,
; produce the next column that has three numbers all different.
(define (next-single n v)
  (with-column-ops n v
		   (lambda (cand copy inc)
		     (if (max-colour? n 2 v)
		       (if (>= (vector-ref v 1) (- (vector-ref v 2) 1))
			 (if (>= (vector-ref v 0) (- (vector-ref v 1) 1))
			   (raise (exn:fail:contract "Ran out of single columns" (current-continuation-marks)))
			   (begin
			     (inc 0)
			     (copy 1)
			     (copy 2)))
			 (begin
			   (inc 1)
			   (copy 0)
			   (copy 2)))
		       (begin 
			 (inc 2)
			 (copy 0)
			 (copy 1)))
		     cand)))

; Given the number of colours, and a column which has two numbers the same,
; return the next column has two numbers the same
(define (next-double n v)
  (with-column-ops n v
		   (lambda (cand copy inc)
		     (if (max-colour? n 1 v)
		       (if (max-colour? n 0 v)
			 (raise (exn:fail:contract "Ran out of double columns" (current-continuation-marks)))
			 (begin
			   (inc 0)))
		       (begin
			 (inc 1)
			 (inc 2)
			 (copy 0)))
		     (if (column? cand)
		       cand
		       (next-double n cand)))))

