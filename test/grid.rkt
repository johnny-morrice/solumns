#lang racket

(require "../solumns/grid.rkt"
	 "../solumns/c/elimination-step.rkt"
	 rackunit)

(define (with-grid f)
  (define g
    (new grid% [width 2] [height 6]))
  (send g add-column 0 0 '#(1 2 1))
  (send g add-column 1 0 '#(2 1 3))
  (send g add-column 1 3 '#(1 1 3))
  (f g))

(define (matrix->lists mat)
  (vector->list
	(vector-map
	  vector->list mat)))

(test-case "Tag"
	   (with-grid (lambda (g)
			(check-equal? (matrix->lists (send g tag))
				      '((2 2 3 0 0 0)
					(2 3 1 3 2 1))))))

(test-case "Dropping"
	   (let [(gr (new grid%
			  [width 2]
			  [height 5]))]
	     (send gr matrix-set! 0 0 1)
	     (send gr drop-until 0 0 '#(2 3 4))
	     (check-equal? (send gr all-colours)
			   '((1 2 3 4 0) (0 0 0 0 0)))))

(test-case "Visit matrix"
	   (with-grid (lambda (g)
			(check-equal? (matrix->lists
					  (send g visit-squares-matrix
						(lambda (x y c)
						  c)))
				      '((1 2 1 0 0 0)
					(2 1 3 1 1 3))))))
				      


(test-case "Cloning"
	   (with-grid (lambda (g)
			(let [(h (send g clone))]
			  (check-equal? (send g all-colours)
					(send h all-colours))
			  (send h add-column 0 3 '(1 2 1))
			  (check-false (equal? (send g all-colours)
					       (send h all-colours)))))))


(test-case "Reduction"
	   (with-grid (lambda (g)
			(send g reduce)
			(check-equal? (send g all-colours)
				      '((2 0 0 0 0 0)
					(2 3 3 0 0 0))))))

(test-case "Elimination"
	   (with-grid (lambda (g)
			(let [(eliminated (send g elimination-step))]
			  (when (not eliminated)
			    (log-error "ERROR: elimination did not succeed!"))
			  (check-equal? (length eliminated) 5)
			  (check-equal? (send g all-colours)
					'((0 2 0 0 0 0)
					  (2 0 3 0 0 3)))))))

(test-case "Elimination in C"
	   (with-grid (lambda (g)
			(let* [(matrix (get-field matrix g))
			       (elim (eliminator (vector-length matrix) (vector-length (vector-ref matrix 0))))
			       (eliminated (elim matrix))]
			  (when (not eliminated)
			    (log-error "ERROR: elimination did not succeed!"))
			  (check-equal? (length eliminated) 5)
			  (check-equal? matrix
					'((0 2 0 0 0 0)
					  (2 0 3 0 0 3)))))))
	   

(test-case "Gravity"
	   (with-grid (lambda (g)
			(send g elimination-step)
			(send g gravity)
			(check-equal? (send g all-colours)
				      '((2 0 0 0 0 0)
					(2 3 3 0 0 0))))))
(test-case "Losing"
	   (let [(g (new grid% [width 1] [height 3]))]
	     (send g add-column 0 0 '#(1 1 4))
	     (check-true (send g lost?))))

(test-case "Winning"
	   (let [(g (new grid% [width 1] [height 4]))]
	     (send g add-column 0 0 '#(1 1 3))
	     (check-false (send g lost?))))

(test-case "The heights of a grid"
	   (let [(gr (new grid% [width 4] [height 3]))]
	     (send gr add-column 0 0 '#(1 2 3))
	     (send gr add-column 3 0 '#(1 3 4))
	     (send gr matrix-set! 1 0 5)
	     (check-equal? (send gr heights)
			   '(3 1 0 3))))
