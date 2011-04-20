#lang racket

(require "../solumns/colgorithms/brute-force.rkt"
	 "../solumns/grid.rkt"
	 "colgorithm.rkt"
	 rackunit)

(define colours
  4)

(define double-4s
  (set
    '#(1 2 2) '#(2 2 1) '#(2 1 2)
    '#(1 3 3) '#(3 3 1) '#(3 1 3)
    '#(1 4 4) '#(4 4 1) '#(4 1 4)
    '#(2 1 1) '#(1 1 2) '#(1 2 1)
    '#(2 3 3) '#(3 3 2) '#(3 2 3)
    '#(2 4 4) '#(4 4 2) '#(4 2 4)
    '#(3 1 1) '#(1 1 3) '#(1 3 1)
    '#(3 2 2) '#(2 2 3) '#(2 3 2)
    '#(3 4 4) '#(4 4 3) '#(4 3 4)
    '#(4 1 1) '#(1 1 4) '#(1 4 1)
    '#(4 2 2) '#(2 2 4) '#(2 4 2)
    '#(4 3 3) '#(3 3 4) '#(3 4 3)))

(define single-4s
  (set
    '#(1 2 3) '#(2 3 1) '#(3 1 2)
    '#(1 3 2) '#(3 2 1) '#(2 1 3)
    '#(1 2 4) '#(2 4 1) '#(4 1 2)
    '#(1 4 2) '#(4 2 1) '#(2 1 4)
    '#(1 3 4) '#(3 4 1) '#(4 1 3)
    '#(1 4 3) '#(4 3 1) '#(3 1 4)
    '#(2 3 4) '#(3 4 2) '#(4 2 3)
    '#(2 4 3) '#(4 3 2) '#(3 2 4)))

(define uniq-4s
  (set-union double-4s single-4s))

(define (permutation-set cols)
  (apply set (flatten cols)))

(define (column-in-limit col)
  (vector-map
    (lambda (clr)
      (unless (<= clr colours)
	(fail (format "column out of bounds: ~a" col))))
    col))

(test-case "Time large generations"
	   (displayln "7 colours")
	   (time (permute 7))
	   (displayln "10 colours")
	   (time (permute 10))
	   (void))

(test-case "Single permutations"
	   (let [(singles (permute-singles colours))]

	     (for-each (lambda (s)
			 (when (or (= (vector-ref s 0)
				      (vector-ref s 1))
				   (= (vector-ref s 1)
			              (vector-ref s 2))
				   (= (vector-ref s 2)
			              (vector-ref s 0)))
			   (fail (format "duplicate elements ~a" s)))

			 (column-in-limit s))
		       singles)

	     (check-equal? (length singles)
			   8)
	     (check-equal? (permutation-set (map three-cycle singles))
			   single-4s)))


(test-case "Double permutations"
	   (let [(doubles (permute-doubles colours))]
	     (for-each (lambda (d)
			 (unless (or (= (vector-ref d 0)
					(vector-ref d 1))
				     (= (vector-ref d 1)
					(vector-ref d 2)))
			   (fail (format "no duplicate elements ~a" d)))
			 (column-in-limit d))
		       doubles)
	     (check-equal? (length doubles)
			   12)
	     (check-equal? (permutation-set (map three-cycle doubles))
			   double-4s)))

(test-case "All permutations"
	   (let* [(cols (permute colours))]
	     (check-equal? (length cols)
			   20) 
	     (check-equal? (permutation-set cols)
			   uniq-4s)
	     (for* [(colv cols)
		    (col colv)]
		   (check-equal? (apply +
					(map (lambda (other-colv)
						      (if (member col other-colv)
							1
							0))
						    cols))
				 1))))

(test-case "Local minimisation."
	   (check-colgorithm (lambda (n)
			       (new brute-force% [colours n]))))
