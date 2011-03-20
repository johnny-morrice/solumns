#lang racket

(require "../solumns/colgorithms/brute-force.rkt"
	 "../solumns/grid.rkt"
	 "colgorithm.rkt"
	 rackunit)

(test-case "Permutations"
	   (check-equal? (permute 2)
			 (list '#(1 1 0)
			       '#(1 0 1)
			       '#(1 0 0)
			       '#(0 1 1)
			       '#(0 1 0)
			       '#(0 0 1))))

(test-case "Local minimisation."
	   (check-colgorithm (lambda (n)
			       (new brute-force% [colours n]))))
