#lang racket/gui

(provide gui-grid%
	 dropper?
	 dropper-x
	 dropper-y
	 dropper-col)

(require "colour-mapping.rkt"
	 "../grid.rkt"
	 "../util.rkt")

; Struct representing the dropping column
(struct dropper (x y col) #:mutable)


; User interface for manipulating the grid% by dropping columns on it. 
(define/contract gui-grid%
		 (class/c [update (->m void)]
			  [add-column (->m exact-nonnegative-integer?
					   exact-nonnegative-integer?
					   column?
					   void)]
			  [left (->m void)]
			  [right (->m void)]
			  [drop (->m boolean?)]
			  [throw (->m boolean?)]
			  [accelerate (->m (and/c real? positive?)
					   void)])
		 (class object%
			(super-new)

			(init parent)
			(init-field grid)

			(public update add-column left right drop throw shift accelerate)

			(field (canvas (new canvas%
					    [parent parent]))
			       (dc (send canvas get-dc))
			       (next #f)
			       (bl-width 1)
			       (bl-height 1)
			       (speed 0.025))

			(send dc set-background (send the-color-database find-color "black"))

			; Perform a function with a next column
			; if it doesn't exist, then raise a contract error
			(define (with-next f)
			  (if next
			    (f next)
			    (raise (exn:fail:contract "There was no next column"
						      (current-continuation-marks)))))

			; Set the block size by resizing the canvas to fill all available space, and then
			; resizing the blocks to fill the grid
			(define (set-block-size)
			  (call-with-values (lambda () (send parent get-size))
					    (lambda (parent-width parent-height)
					      (when (and (< 10 parent-width) (< 10 parent-height))
						(let [(canvas-width (- parent-width 10))
						      (canvas-height (- parent-height 10))]
						  (send canvas min-width canvas-width)
						  (send canvas min-height canvas-height)
						  (set! bl-width (/ canvas-width
								    (get-field width grid)))
						  (set! bl-height (/ canvas-height
								     (get-field height grid))))))))

			; Shift the new column, as when the player presses up
			(define (shift)
			  (with-next (lambda (n)
				       (set-dropper-col! next (column-shift (dropper-col n))))))

			; Attempt to occupy an area in the grid
			(define (attempt-horizontal-move x)
			  (when (and (>= x 0) (send grid can-occupy? x (round-exact (dropper-y next))))
			    (set-dropper-x! next x)))

			; Move the next column left
			(define (left)
			  (with-next (lambda (n)
				       (attempt-horizontal-move (- (dropper-x n) 1)))))

			; Move the next column right
			(define (right)
			  (with-next (lambda (n)
				       (attempt-horizontal-move (+ (dropper-x n) 1)))))

			; Drop the block by a given amount.
			(define (drop-block dy)
			  (let [(x (dropper-x next))
				(new-y (- (dropper-y next) dy))]
			    (if (> new-y 0)
			      (if (send grid can-occupy? x (inexact->exact (floor new-y)))
				(begin (set-dropper-y! next new-y)
				       #f)
				(begin (send grid drop-until x (round-exact new-y) (dropper-col next))
				       (set! next #f)
				       #t))
			      (begin
				(send grid add-column x 0 (dropper-col next))
				(set! next #f)
				#t))))

			; Throw the column with great alacrity, as when the user presses down
			(define (throw)
			  (drop-block 1))

			; Drop the block gently
			(define (drop)
			  (drop-block speed))

			; Accelerate the columns by a given fraction of the current speed
			(define (accelerate percent)
			  (set! speed (+ speed (* speed percent))))

			; Add a column to the GUI
			(define (add-column x y col)
			  (set! next (dropper x y col)))

			; Draw a square, adjusting for relative sizes
			(define (draw-square x y c)
			  (send dc set-brush (to-colour c) 'opaque)
			  (send dc draw-rectangle
				(* x bl-width)
				(* (- (- y (- (get-field height grid) 1)))
				   bl-height)
				bl-width
				bl-height))

			; Update the GUI, should be called after something moves,
			; or the window is resized
			(define (update)
			  (send dc clear)
			  (set-block-size)

			  (send grid visit-squares
				(lambda (x y c)
				  (when c
				    (draw-square x y c))))

			  (when next
			    (let [(x (dropper-x next))
				  (y (dropper-y next))
				  (col (dropper-col next))]
			      (for [(i (in-range 0 3))
				    (clr (in-vector col))]
				   (draw-square x (+ i y) clr)))))))
