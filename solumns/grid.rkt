#lang racket

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
		   [elimination-step (->m (or/c exact-nonnegative-integer? boolean?))]
		   [visit-squares (->m (-> exact-nonnegative-integer?
					   exact-nonnegative-integer?
					   (or/c exact-nonnegative-integer? #f)
					   any)
				       (listof (listof any/c)))]
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
				    void)])

		 (class object%
			(super-new)
			(init-field width height)

			(field [matrix
				 (build-vector width
					       (lambda (i) (build-vector height
									 (lambda (j) #f))))])

			(public gravity elimination-step add-column visit-squares find-neighbours all-colours clone lost?
				size reduce matrix-set! can-occupy? drop-until heights)

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
			       (not (vector-ref (vector-ref matrix x) y)))) 

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

			; Is this coordinate in the matrix?
			(define (in-matrix? x y)
			  (and (>= x 0)
			       (>= y 0)
			       (< x width)
			       (< y height)))

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

			; Set an element in the grid's matrix
			(define (matrix-set! x y val)
			  (when (in-matrix? x y)
			    (vector-set! (vector-ref matrix x) y val)))

			; Removes neighbours from the matrix, given a set of points.
			; Returns true if neighbours were removed
			(define (remove-neighbours unreached [worked? #f])
			  (if (set-empty? unreached)
			    worked?
			    (for/first [(square unreached)]
				       (call-with-values (lambda ()
							   (find-neighbours (set square) unreached))
							 (lambda (neighbours now-unreached)
							   (let [(working? (>= (length (for/list [(n neighbours)] n)) 3))]
							     (when working?
							       (for [(pos neighbours)]
								    (matrix-set! (car pos) (cadr pos) #f)))
							     (remove-neighbours now-unreached
										(or worked? working?))))))))

			; Find a set of neighbours and a new set of unreached values, given a list of currently joined squares and a set of unreached neighbours
			(define (find-neighbours reached unreached)
			  (let* [(candidates (apply set
						    (filter (lambda (pos)
							      (apply in-matrix? pos))
							    (for*/list [(square reached)
									(xd (in-range -1 2))
									(yd (in-range -1 2))]
								       (list (+ (car square) xd)
									     (+ (cadr square) yd))))))
				 (present (set-intersect candidates unreached))]
			    (if (set-empty? present)
			      (values reached unreached)
			      (find-neighbours (set-union reached present)
					       (set-subtract unreached candidates)))))

			; Return the number of filled squares in the grid
			(define (size)
			  (apply + (heights)))

			; Perform elimination and gravity steps until there is no change!
			(define (reduce)
			  (do []
			    [(not (elimination-step)) (void)]
			    (gravity)))

			; Apply a single step of elimination to a grid (that is, removal of congruent elements)
			; Return true if squares were eliminated, false otherwise.
			(define (elimination-step)

			  ; Group each colour into sets
			  (define colours (make-hash))

			  ; We need to compute the number of squares in an insane grid!
			  (define (size-insane)
			    (apply + (flatten
				       (visit-squares (lambda (x y c)
							(if c 1 0))))))

			  (define size-before
			    (size-insane))
			    

			  ; Add each square into the appropriate set
			  (visit-squares (lambda (x y c)
					   (when (number? c)
					     (when (and (not (hash-has-key? colours c)))
					       (hash-set! colours c (set)))
					     (hash-set! colours c (set-add (hash-ref colours c) (list x y))))))

			  ; For each colour, find neighbours and delete them.
			  ; Return the number of squares removed or false if this was 0. (due to legacy...)
			  (let [(removed?
				  (for/fold [(worked? #f)]
				    [(clr-set (in-dict-values colours))]
				    (or (remove-neighbours clr-set) worked?)))]

			    (if removed?
			      (- size-before (size-insane))
			      #f)))



			; Add a column, with the bottom of the column at the given position
			(define (add-column x y col)
			  (for [(c col)
				(i (in-range 0 3))]
			       (matrix-set! x (+ y i) c)))

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
