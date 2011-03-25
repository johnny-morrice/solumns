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

(test-case "Dropping"
	   (let [(gr (new grid%
			  [width 2]
			  [height 5]))]
	     (send gr matrix-set! 0 0 0)
	     (send gr drop-until 0 0 '#(1 2 3))
	     (check-equal? (send gr all-colours)
			   '((0 1 2 3 #f) (#f #f #f #f #f)))))

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

(test-case "Cloning"
	   (with-grid (lambda (g)
			(let [(h (send g clone))]
			  (check-equal? (send g all-colours)
					(send h all-colours))
			  (send h add-column 0 3 '(0 1 0))
			  (check-false (equal? (send g all-colours)
					       (send h all-colours)))))))


(test-case "Reduction"
	   (with-grid (lambda (g)
			(send g reduce)
			(check-equal? (send g all-colours)
				      '((1 #f #f #f #f #f)
					(1 2 2 #f #f #f))))))

(test-case "Elimination"
	   (with-grid (lambda (g)
			(let [(eliminated (send g elimination-step))]
			(when (not eliminated)
			  (log-error "ERROR: elimination did not succeed!"))
			(check-equal? eliminated 5)
			(check-equal? (send g all-colours)
				      '((#f 1 #f #f #f #f)
				        (1 #f 2 #f #f 2)))))))

(test-case "Gravity"
	   (with-grid (lambda (g)
			(send g elimination-step)
			(send g gravity)
			(check-equal? (send g all-colours)
				      '((1 #f #f #f #f #f)
					(1 2 2 #f #f #f))))))

(test-case "Losing"
	   (let [(g (new grid% [width 1] [height 3]))]
	     (send g add-column 0 0 '#(0 0 3))
	     (check-true (send g lost?))))

(test-case "Winning"
	   (let [(g (new grid% [width 1] [height 4]))]
	     (send g add-column 0 0 '#(0 0 2))
	     (check-false (send g lost?))))

(test-case "A grid with more squares is harder."
	   (let [(small (new grid% [width 3] [height 3]))
		 (big (new grid% [width 3] [height 3]))]
	     (send small add-column 0 0 '#(3 0 0))
	     (send big add-column 0 0 '#(2 0 0))
	     (send big add-column 1 0 '#(0 0 1))
	     (check-true (grid-lt small big))
	     (check-false (grid-lt big small))))

(test-case "The heights of a grid"
	   (let [(gr (new grid% [width 4] [height 3]))]
	     (send gr add-column 0 0 '#(0 1 2))
	     (send gr add-column 3 0 '#(0 2 3))
	     (send gr matrix-set! 1 0 4)
	     (check-equal? (send gr heights)
			   '(3 1 0 3))))

(test-case "An overall taller grid is harder."
	   (let [(small (new grid% [width 4] [height 3]))
		 (big (new grid% [width 4] [height 3]))]
	     (send small add-column 0 0 '#(0 1 2))
	     (send big matrix-set! 0 0 0)
	     (send big matrix-set! 1 0 1)
	     (send big matrix-set! 2 0 2)
	     (send big matrix-set! 3 0 3)
	     (check-true (grid-lt small big))
	     (check-false (grid-lt big small))))
