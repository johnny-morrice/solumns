#lang racket

(require rackunit
	 "../solumns/colgorithms/shuffler.rkt")

(test-case "Shuffle list"
	   (let* [(unshuffled (build-list 1000 (lambda (x) x)))
		  (shuffled (shuffle unshuffled))]
	     (displayln (take unshuffled 10))
	     (displayln (take shuffled 10))
	     (check-true (> 10
			    (foldr (lambda (ush sh eqs)
				     (if (= ush sh)
				       (add1 eqs)
				       eqs))
				   0
				   unshuffled shuffled)))))


