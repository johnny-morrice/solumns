#lang racket

(require "../grid.rkt"
	 "../colgorithm.rkt"
	 "random.rkt")

(provide brute-force%)

(provide/contract [permute (-> exact-nonnegative-integer?
			       (listof (vectorof exact-nonnegative-integer?)))])

; Take a column and produce three columns; each of the columns that may be created when the player presses up!
(define (three-cycle col)
  (let* [(next (column-shift col))
	 (after (column-shift next))]
    (list col next after)))

; Colgorithm that explores the entire input space of columns and hence determines which column is least desirable.
(define/contract brute-force%
		 colgorithm/c
		 (class object%
			(super-new)

			(init colours)

			(field [columns (permute colours)]
			       [discrete-columns (make-hash)]
			       [simple (make-rand colours)])

			; Associate discrete columns with columns
			(for-each
			  (lambda (col)
			    (let [(cyc (three-cycle col))]
			      (when (not (ormap (lambda (mirror)
						  (hash-has-key? discrete-columns mirror))
						cyc))
				(hash-set! discrete-columns col cyc))))
			  columns)

			(public next)

			; Find the next column by bruteforce search of the entire input space
			; if the grid is empty, give a random column
			(define (next gr)
			  (if (= (send gr size) 0)
			    (send simple next gr)
			    (let [(candidates
				    (hash-map discrete-columns
					      (lambda (discrete cols)
						(list discrete
						      (car (sort (flatten (map (lambda (col)
										 (possible-positions gr col))
									       cols))
								 grid-lt))))))]
			      (caar (reverse (sort candidates
						   (lambda (cand1 cand2)
						     (grid-lt (cadr cand1) (cadr cand2)))))))))

			; Produce every possible position of the column in the grid
			(define (possible-positions gr col)
			  ; This is horrible.  How can I write such a simple function in such a contrived manner? 
			  (let [(heights (make-hash))]
			    (for [(x (in-range 0 (get-field width gr)))]
				 (hash-set! heights x '()))
			    (send gr visit-squares
				  (lambda (x y c)
				    (when c
				      (hash-set! heights x (cons y (hash-ref heights x))))))
			    (let* [(next-positions
				     (for/list [(x (in-hash-keys heights))
						(ys (in-hash-values heights))]
					       (list x
						     (if (null? ys)
						       0
						       (car (reverse (sort ys <)))))))
				   (next-grids
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
							  (current-continuation-marks)))))))))

; Permute from 0, up to n^3, with the exclusion of numbers 
; where each place is equal (in base n).  E.g. (0,0,0) is not included in the results.
; Numbers are represented as vectors of length 3, in base n.
(define (permute n)
  (filter column?
	  (for/fold
	    [(vs (list '#(0 0 0)))]
	    [(i (in-range 0 (- (expt n 3) 1)))]
	    (cons (next n (car vs)) vs))))

; Given a number v in base n, represent by a vector of length 3, return the vector which is 1 greater than this number.
; Raises a contract error if v = n^3.
; This is pretty stupid, but it's okay for generating the sort of
; permutation like objects we're looking for, as long
; as columns continue to be of length 3!
(define (next n v)
  (local
    [(define cand
       (vector 0 0 0))
     (define (copy i)
       (vector-set! cand i
		    (vector-ref v i)))
     (define (inc i)
       (vector-set! cand i
		    (+ 1 (vector-ref v i))))
     (define (max? i)
       (= i (- n 1)))]
    (if (max? (vector-ref v 2))
      (if (max? (vector-ref v 1))
	(if (max? (vector-ref v 0))
	  (raise (exn:fail:contract "Cannot exceed n^3" (current-continuation-marks)))
	  (inc 0))
	(begin
	  (inc 1)
	  (copy 0)))
      (begin
	(inc 2)
	(copy 1)
	(copy 0)))
    cand))

