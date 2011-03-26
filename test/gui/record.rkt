#lang racket

(require "../../solumns/gui/high-scores.rkt"
	 rackunit)

(define two-sample
  '(("ben" 1) ("mic" 2)))

(define ten-sample
  (build-list 10 (lambda (x)
		   (list "Ben" x))))

(define big-sample
  (build-list 20
	      (lambda (x)
		(list "Mike" x))))

(test-case "Setting default + cleaning high scores"
	   (set-default-high-scores)
	   (set-high-scores '()))

(test-case "Sorting"
	   (check-equal? (take (sort-scores (reverse ten-sample)) 3)
			 (build-list 3 (lambda (x) (list "Ben" x)))))

(test-case "Top ten"
	   (check-equal? (top-ten '())
			 '())
	   (check-equal? (top-ten two-sample)
			 '(("mic" 2) ("ben" 1)))
	   (check-equal? (length (top-ten ten-sample))
			 10)
	   (check-equal? (length (top-ten big-sample))
			 10)
	   (check-equal? (take (top-ten big-sample) 3)
			 '(("Mike" 19) ("Mike" 18) ("Mike" 17))))

(test-case "Saving"
	   (set-high-scores ten-sample))

(test-case "Loading"
	   (check-equal? (get-high-scores)
			 ten-sample))


