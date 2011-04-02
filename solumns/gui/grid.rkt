#lang racket/gui

(provide gui-grid%
	 dropper?
	 dropper-x
	 dropper-y
	 dropper-col)

(require "grid-canvas.rkt"
	 "next-column.rkt"
	 "../grid.rkt"
	 "../util.rkt")

; User interface for manipulating the grid% by dropping columns on it. 
(define/contract gui-grid%
		 (class/c [add-column (->m exact-nonnegative-integer?
					   exact-nonnegative-integer?
					   column?
					   void)]
			  [left (->m void)]
			  [right (->m void)]
			  [drop (->m boolean?)]
			  [throw (->m boolean?)]
			  [accelerate (->m (and/c real? positive?)
					   void)]
			  (init-field [canvas (is-a?/c grid-canvas%)]
				      [grid (is-a?/c grid%)]
				      [speed (and/c real? positive?)]))
		 (class object%
			(super-new)

			(init-field grid canvas speed)

			(public add-column left right drop throw shift accelerate)

			(field [next #f])

			; Perform a function with a next column
			; if it doesn't exist, then raise a contract error
			(define (with-next f)
			  (if next
			    (f next)
			    (raise (exn:fail:contract "There was no next column"
						      (current-continuation-marks)))))

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
				       (remove-next)
				       #t))
			      (begin
				(send grid add-column x 0 (dropper-col next))
				(remove-next)
				#t))))

			; Remove the falling column
			(define (remove-next)
			  (set! next #f)
			  (send canvas remove-falling))

			; Throw the column with great alacrity, as when the user presses down
			(define (throw)
			  (drop-block 1))

			; Drop the block gently
			(define (drop)
			  (drop-block speed))

			; Accelerate the columns by a given amount 
			(define (accelerate constant)
			  (set! speed (+ speed constant)))

			; Add a column to the GUI
			(define (add-column x y col)
			  (set! next (dropper x y col))
			  (send canvas falling next))))
