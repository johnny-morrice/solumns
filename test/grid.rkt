#lang racket

(require "../solumns/grid.rkt"
	 rackunit)

(define (with-grid f)
  (define g
    (new grid% [width 2] [height 6]))
  (send g add-column 0 0 '#(0 1 0))
  (send g add-column 1 0 '#(1 0 2))
  (send g add-column 1 3 '#(0 0 2))
  (f g))

(test-case "Find neighbours"
	   (with-grid (lambda (g)
			(check-equal?
			  (call-with-values
			    (lambda ()
			      (send g find-neighbours
				(set '(0 0))
				(set '(0 2)
				     '(1 1)
				     '(1 3)
				     '(1 4))))
			    (lambda (n u)
			      n))
			  (set '(0 0)
			       '(0 2)
			       '(1 1)
			       '(1 3)
			       '(1 4))))))


(test-case "Elimination"
	   (with-grid (lambda (g)
			(when (not (send g elimination-step))
			  (log-error "ERROR: elimination did not succeed!"))
			(check-equal? (send g all-colours)
				      '((#f 1 #f #f #f #f)
				        (1 #f 2 #f #f 2))))))

(test-case "Gravity"
	   (with-grid (lambda (g)
			(send g elimination-step)
			(send g gravity)
			(check-equal? (send g all-colours)
				      '((1 #f #f #f #f #f)
					(1 2 2 #f #f #f))))))

