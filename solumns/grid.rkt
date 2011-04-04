#lang racket

(require racket/unsafe/ops)

(provide grid%)

; A column is a vector of length 3, containing exact integers.
(define column?
  (flat-named-contract 'column
		       (lambda (candidate)
			 (and (vector? candidate)
			      (= (vector-length candidate) 3)
			      ((vectorof exact-nonnegative-integer?) candidate)
			      (not (and (= (vector-ref candidate 0)
					   (vector-ref candidate 1))
					(= (vector-ref candidate 1)
					   (vector-ref candidate 2))))))))

; Produce the next arrangement of a column, like when the player presses up.
(define (column-shift col)
  (let [(next (vector 0 0 0))]
    (vector-set! next 2 (vector-ref col 1))
    (vector-set! next 1 (vector-ref col 0))
    (vector-set! next 0 (vector-ref col 2))
    next))

; A grid of blocks present on the screen.
(define/contract grid%
		 (class/c
		   [gravity (->m void)]
		   [elimination-step (->m (listof (vectorof exact-nonnegative-integer?)))]
		   [visit-squares (->m (-> exact-nonnegative-integer?
					   exact-nonnegative-integer?
					   (or/c exact-nonnegative-integer? #f)
					   any)
				       (listof (listof any/c)))]
		   [visit-squares-matrix (->m (-> exact-nonnegative-integer?
						  exact-nonnegative-integer?
						  (or/c exact-nonnegative-integer? #f)
						  any)
					      (vectorof (vectorof any/c)))]

		   [add-column (->m exact-nonnegative-integer?
				    exact-nonnegative-integer?
				    column?
				    void)]
		   [clone (->m (is-a?/c grid%))]
		   [size (->m exact-nonnegative-integer?)]
		   [reduce (->m void)]
		   [can-occupy? (->m exact-nonnegative-integer?
				     exact-nonnegative-integer?
				     boolean?)]
		   [drop-until (->m exact-nonnegative-integer?
				    exact-nonnegative-integer?
				    column?
				    void)]
		   [matrix-ref (->m exact-nonnegative-integer?
				    exact-nonnegative-integer?
				    (or/c #f exact-nonnegative-integer?))])

		 (class object%
			(super-new)
			(init-field width height)

			(field [matrix
				 (build-vector width
					       (lambda (i) (build-vector height
									 (lambda (j) #f))))])

			; Mostly we expose so much so that the testing module can get at them
			; better to do this with module hiding
			(public gravity elimination-step add-column visit-squares visit-squares-matrix all-colours clone lost?
				size reduce matrix-set! can-occupy? drop-until heights tag around matrix-ref)

			; Return the heights of each column in a list.
			(define (heights)
			  (for/list [(x (in-range 0 (vector-length matrix)))]
				    (column-height x)))

			; Return the height of the column at x
			(define (column-height x)
			  (let* [(slice (vector-ref matrix x))
				 (places (vector->list slice))
				 (colours-end (member #f places))]
			    (if colours-end
			      (- (length places) (length colours-end))
			      (length places))))

			; Have we lost?
			(define (lost?)
			  (ormap (lambda (h) (>= h height)) (heights)))

			; Assuming the grid is sane, can a new column sit in this position?
			(define (can-occupy? x y)
			  (and (in-matrix? x y)
			       (not (matrix-ref x y))))

			; Drop a column until it hits the block or floor above this position
			(define (drop-until x y col)
			  (add-column x (column-height x) col))

			; Clone this grid.
			(define (clone)
			  (let [(gen (new grid%
					  [width width]
					  [height height]))]
			    (visit-squares
			      (lambda (x y c)
				(send gen matrix-set! x y c)))
			    gen))

			; Return all squares around the neighbours and the object itself
			(define (around x y)
			  (filter vector?
				  (for*/list [(i (in-list '(-1 0 1)))
					      (j (in-list '(-1 0 1)))]
					     (let [(n (unsafe-fx+ x i))
						   (m (unsafe-fx+ y j))]
					       (if (in-matrix? n m)
						 (vector n m (matrix-ref n m))
						 #f)))))

			; Is this coordinate in the matrix?
			(define (in-matrix? x y)
			  (and (unsafe-fx>= x 0)
			       (unsafe-fx>= y 0)
			       (unsafe-fx< x width)
			       (unsafe-fx< y height)))

			(define (all-colours)
			  (visit-squares
			    (lambda (x y c) c)))

			; Apply gravity to a grid.
			(define (gravity)
			  (set! matrix
			    (list->vector
			      (for/list [(col matrix)]
					(let [(dropped (vector-filter (lambda (x) x)
								      col))]
					  (vector-append dropped
							 (make-vector (- height (vector-length dropped)) #f)))))))

			; Get an element in the matrix
			(define (matrix-ref x y)
			  (vector-ref (vector-ref matrix x) y))

			; Set an element in the grid's matrix
			(define (matrix-set! x y val)
			  (when (in-matrix? x y)
			    (vector-set! (vector-ref matrix x) y val)))

			; Return the number of filled squares in the grid
			(define (size)
			  (apply + (heights)))

			; Perform elimination and gravity steps until there is no change!
			(define (reduce)
			  (do []
			    [(unsafe-fx= (length (elimination-step)) 0)]
			    (gravity)))

			; Tag the squares based on their number of neighbours.
			; Return a matrix of said squares
			(define (tag)
			  (local [(define (count-neighbours x y c)
				    (if c
				      (foldl (lambda (ne total)
					       (if (eq? (vector-ref ne 2) c)
						 (unsafe-fx+ total 1)
						 total))
					     0 (around x y))
				      0))]
				 (visit-squares-matrix
				   (lambda (x y c)
				     (count-neighbours x y c)))))

			; Apply a single step of elimination to a grid (that is, removal of congruent elements)
			; Return number if squares were eliminated, false otherwise.
			;
			; This algorithm uses the fact that if three squares are connected, each square
			; is or is connected to at least one square that is connected to at least two others
			(define (elimination-step)
			  (let* [(tagged (tag))
				 (removing
				   (for*/fold
				     [(deleted '())]
				     [(x (in-range 0 width))
				      (y (in-range 0 height))]
				     (let [(c (matrix-ref x y))]
				       (if (and c
						(ormap (lambda (pos)
							 (unsafe-fx>= (vector-ref (vector-ref tagged (vector-ref pos 0)) (vector-ref pos 1))
							     3))
						       (filter (lambda (pos) (eq? c (vector-ref pos 2)))
							       (around x y))))
					 (cons (vector x y c) deleted)
					 deleted))))
				 (removed (length removing))]
			    (for-each
			      (lambda (pos)
				(matrix-set! (vector-ref pos 0) (vector-ref pos 1) #f))
			      removing)
			    removing))

			; Add a column, with the bottom of the column at the given position
			(define (add-column x y col)
			  (for [(c col)
				(i (in-range 0 3))]
			       (matrix-set! x (+ y i) c)))

			; Pass a function which visits all squares, return another matrix
			(define (visit-squares-matrix visitor)
			  (list->vector (map list->vector (visit-squares visitor))))

			; Pass a function which visits all squares in the matrix.
			(define (visit-squares visitor)
			  (for/list [(col matrix)
				     (i (in-range 0 (vector-length matrix)))]
				    (for/list [(square col)
					       (j (in-range 0 (vector-length col)))]
					      (visitor i j square))))))

; Take two grids, rank one higher than another.  Lower value means better for the player.
(define (grid-lt p q)
  (< (send p size)
     (send q size)))

(provide/contract
  [column? (-> any/c
	       boolean?)]
  [column-shift (-> column?
		    column?)]
  [grid-lt (-> (is-a?/c grid%)
	       (is-a?/c grid%)
	       boolean?)])
