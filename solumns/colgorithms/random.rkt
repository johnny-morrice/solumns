#lang racket

; Generate random columns, like the normal columns algorithm

(require "../colgorithm.rkt"
	 "../grid.rkt")

; Create the random colour generator.
; The number of colours must be greater or equal to two.
(define (make-rand clrs)
  (new rand% [num-colours clrs]))

; Given a set of numbers, choose one randomly
(define (random-member uniqs)
  (let* [(uniq-list (for/list [(un uniqs)] un))
	 (choose (random (length uniq-list)))]
    (list-ref uniq-list choose)))

; Random column generator 
; The number of colours it is created with must be greater or equal to 3.
(define/contract rand%
		 colgorithm/c
		 (class object%
			(super-new)

			(init num-colours)

			(field [colours (foldl (lambda (col set)
						 (set-add set col))
					       (set)
					       (for/list [(col (in-range 0 num-colours))]
							 col))])

			; Generate a new column
			(define/public (next gr)
				       (let [(choose (random 2))]
					 ; Either we generate a column with 3 different colours
					 ; or one with two different colours.
					 (if (= choose 0)
					   (three)
					   (two))))

			; Generate a column with three colours
			(define/public (three)
			  (let [(column (vector #f #f #f))]
			    (for/fold [(possibilities colours)]
				      [(i (in-range 0 3))]
				      (let [(choose (random-member possibilities))]
					(vector-set! column i choose)
					(set-remove possibilities choose)))
			    column))

			; Generate a column with two colours
			(define/public (two)
			  (let* [(column (vector #f #f #f))
				 (pos (random 3))
				 (frs (random-member colours))
				 (scn (random-member (set-remove colours frs)))]
			    (for [(i (in-range 0 3))]
				 (vector-set! column i (if (= i pos)
							 frs scn)))
			    column))))

(provide/contract
  [make-rand (-> (and/c exact-nonnegative-integer?
			(lambda (n) (>= 3 n)))
		 (is-a?/c rand%))]
  [random-member (-> set?
		     any)])
