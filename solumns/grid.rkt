#lang racket

(provide grid%
	 column?)

; A column is a vector of length 3, containing exact integers.
(define column?
  (flat-named-contract 'column
		       (lambda (candidate)
			 (and (vector? candidate)
			      (= (vector-length candidate) 3)
			      ((vectorof exact-nonnegative-integer?) candidate)))))

; A grid of blocks present on the screen.
(define/contract grid%
  (class/c [elimination-step (->m boolean?)]
	   [visit-squares (->m (-> exact-nonnegative-integer?
			           exact-nonnegative-integer?
				   (or/c exact-nonnegative-integer? #f)
				   any)
			       (listof (listof any/c)))]
	   [add-column (->m exact-nonnegative-integer?
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

	 (public gravity elimination-step add-column visit-squares find-neighbours all-colours)

	 ; Is this coordinate in the matrix?
	 (define (in-matrix? coord)
	   (and (>= (car coord) 0)
		(>= (cadr coord) 0)
	        (< (car coord) width)
		(< (cadr coord) height)))

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
	     (vector-set! (vector-ref matrix x) y val))

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
				     (filter in-matrix?
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

	 ; Apply a single step of elimination to a grid (that is, removal of congruent elements)
	 ; Return true if squares were eliminated, false otherwise.
	 (define (elimination-step)

	   ; Group each colour into sets
	   (define colours (make-hash))

	   ; Add each square into the appropriate set
	   (visit-squares (lambda (x y c)
			    (when (number? c)
			      (when (and (not (hash-has-key? colours c)))
				(hash-set! colours c (set)))
			      (hash-set! colours c (set-add (hash-ref colours c) (list x y))))))

	   ; For each colour, find neighbours and delete them.
	   ; Return true if at least one square was eliminated.
	   (for/fold [(worked? #f)]
		     [(clr-set (in-dict-values colours))]
		     (or (remove-neighbours clr-set) worked?)))

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



