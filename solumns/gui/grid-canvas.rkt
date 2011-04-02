#lang racket/gui

(require "../grid.rkt"
	 "colour-mapping.rkt"
	 "next-column.rkt"
	 sgl
	 sgl/gl)

(provide grid-canvas%)

; A canvas that displays a grid
(define/contract grid-canvas%
		 (class/c [falling (->m dropper? 
					void)]
			  [remove-falling (->m void)]
			  (init-field [frame-delay (and/c real? positive?)]
			  	      [grid (is-a?/c grid%)]))

		 (class canvas%
			(super-new [style '(no-autoclear)])

			(public falling remove-falling draw-grid render-square shades)
			(override on-paint)
			(inherit refresh with-gl-context swap-gl-buffers get-width get-height)

			(init-field grid frame-delay)

			(field [next #f])
			
			; A column is falling
			(define (falling drop)
			  (set! next drop))
			
			; A column is no longer falling
			(define (remove-falling)
			  (set! next #f))

			; Produce the three shades used for rendering a colour 
			(define (shades c)
			  (let* [(darken (lambda (col)
					   (map (lambda (n) (* 0.9 n))
						col)))
				 (dark (darken c))
				 (darker (darken dark))]
			    (list c dark darker)))

			; Draw the grid
			(define (draw-grid [gr grid])
			  (send gr visit-squares
				(lambda (x y c)
				  (when c
				    (draw-square x y c)))))

			; Draw a square, adjusting for relative sizes
			(define (render-square x y light dark darker)
			  (let* [(border 0.05)
				 (l (* x))
				 (ler (+ border l))
				 (r (+ 1 l))
				 (rer (- r border))
				 (b (* y))
				 (ber (+ b border))
				 (t (+ 1 b))
				 (ter (- t border))]
    			    (gl-begin 'quads)
			    	(apply gl-color light)
				(gl-vertex l b)
				(gl-vertex ler ber)
				(gl-vertex ler t)
				(gl-vertex l t)
			    (gl-end)
			    (gl-begin 'quads)
			    	(apply gl-color light)
				(gl-vertex l t)
				(gl-vertex ler ter)
				(gl-vertex rer ter)
				(gl-vertex r t)
			    (gl-end)
			    (gl-begin 'quads)
			    	(apply gl-color dark)
			    	(gl-vertex ler ber)
			    	(gl-vertex ler ter)
			    	(gl-vertex rer ter)
			    	(gl-vertex rer ber)
			    (gl-end)
			    (gl-begin 'quads)
			    	(apply gl-color darker)
				(gl-vertex l b)
				(gl-vertex r b)
				(gl-vertex rer ber)
				(gl-vertex ler ber)
			    (gl-end)
			    (gl-begin 'quads)
			        (apply gl-color darker)
				(gl-vertex rer ber)
				(gl-vertex r b)
				(gl-vertex r t)
				(gl-vertex rer ter)
			    (gl-end)))

			; Draw a square, taking the three needed colours
			; for the borders and the centre as arguments
			(define (draw-square x y c)
			    (apply (lambda (l d dr)
				     (render-square x y l d dr))
				   (shades (to-colour c))))

			; Update the GUI
			(define (on-paint)
			  (with-gl-context
			    (lambda ()
			      (gl-clear-color 0.0 0.0 0.0 0.0)
			      (gl-clear 'color-buffer-bit)

			      (gl-matrix-mode 'modelview)
			      (gl-load-identity)
			      (gl-push-matrix)
			      (gluOrtho2D 0 (get-field width grid) 0 (get-field height grid))

			      (send this draw-grid)

			      (when next
				(let [(x (dropper-x next))
				      (y (dropper-y next))
				      (col (dropper-col next))]
				  (for [(i (in-range 0 3))
					(clr (in-vector col))]
				       (draw-square x (+ i y) clr))))

			      (gl-pop-matrix)

			      (swap-gl-buffers)
			      (queue-callback (lambda ()
						(sleep/yield frame-delay)
						(refresh))))))))
