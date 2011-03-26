#lang racket/gui

(require "../grid.rkt"
	 "colour-mapping.rkt"
	 "next-column.rkt")

(provide grid-canvas%)

; A canvas that displays a grid
(define/contract grid-canvas%
		 (class/c [falling (->m dropper? 
					void)]
			  [remove-falling (->m void)]
			  (init-field [grid (is-a?/c grid%)]))
		 (class canvas%
			(super-new)

			(public falling remove-falling)
			(override on-size on-paint)
			(inherit refresh)

			(init-field grid)

			(field (next #f)
			       (bl-width 1)
			       (bl-height 1)
			       (dc (send this get-dc)))
			
			(send dc set-background (send the-color-database find-color "black"))

			; A column is falling
			(define (falling drop)
			  (set! next drop))
			
			; A column is no longer falling
			(define (remove-falling)
			  (set! next #f))


			; Draw a square, adjusting for relative sizes
			(define (draw-square x y c)
			  (send dc set-brush (to-colour c) 'opaque)
			  (send dc draw-rectangle
				(* x bl-width)
				(* (- (- y (- (get-field height grid) 1)))
				   bl-height)
				bl-width
				bl-height))

			; Set the block size by resizing the canvas to fill all available space, and then
			; resizing the blocks to fill the grid
			(define (on-size width height)
			  (displayln "sizing")
			  (set! bl-width (/ width
					    (get-field width grid)))
			  (set! bl-height (/ height
					     (get-field height grid))))

			; Update the GUI
			(define (on-paint)
			  (send dc clear)
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
