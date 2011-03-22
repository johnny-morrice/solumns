#lang racket/gui

(provide gui-grid%)

(require "colour-mapping.rkt")

(define/contract gui-grid%
		 (class/c [update (->m void)])
		 (class object%
			(super-new)

			(init parent)
			(init-field grid)

			(public update add-column)

			(field (canvas (new canvas% [parent parent]))
			       (dc (send canvas get-dc))
			       (next #f)
			       (bl-width 1)
			       (bl-height 1))

			(send dc set-background (send the-color-database find-color "black"))

			(define (set-block-size)
			  (call-with-values (lambda () (send canvas get-client-size))
					    (lambda (canvas-width canvas-height)
					      (set! bl-width (/ canvas-width
								(get-field width grid)))
					      (set! bl-height (/ canvas-height
								 (get-field height grid))))))

			; Add a column to the GUI
			(define (add-column x y col)
			  (set! next (list x y col)))

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
			    (apply (lambda (x y col)
				     (for [(i (in-range 0 3))
					   (clr (in-vector col))]
					  (draw-square x (+ i y) clr)))
				   next)))))



