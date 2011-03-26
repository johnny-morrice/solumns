#lang racket/gui

(require "../controller.rkt"
	 "../../colgorithm.rkt"
	 "../../grid.rkt"
	 "../../util.rkt"
	 "dropper.rkt")

(provide gamer-controller%)

; Play a game of columns!
(define/contract gamer-controller%
		 (class/c (init-field [grid (is-a?/c grid%)]
				      [colgorithm colgorithm/c])
			  [eliminate (->m any)]
			  [lose (->m any)]
			  [next-column (->m (is-a?/c grid%)
					    column?)])
			  

		 (class dropper-controller%
			(super-new)

			(init-field grid colgorithm)

			(override landed)

			(public eliminate lose next-column)

			; Perform elimination on the grid.
			; Return the number of blocks removed,
			; or false otherwise.
			(define (eliminate)
			  (send grid elimination-step))

			; You have lost :(
			(define (lose)
			  (send this stop))

			; Given a grid (NOT the same as the grid field), find the next column
			(define (next-column clone)
			  (send colgorithm next clone))

			; The column has landed.
			(define (landed)
			  (super landed)
			  (send (get-field model this) accelerate 0.02)
			  (let* [(clone (send grid clone)) 
				 (lost? (begin
					  (send clone reduce)
					  (send clone lost?)))
				 (next #f)]
			  ; Find the other column in another thread
			  (when (not lost?)
			    (thread (lambda ()
				      (set! next (send this next-column clone)))))
			  ; Do some special effects while we wait for the next column
			  (do []
			    [(not (send this eliminate))]
			    (sleep/yield 0.5)
			    (send grid gravity))
			  ; Have we lost?
			  (if lost?
			    (send this lose)
			    (begin
			      ; Wait till the column is ready
			      (do []
				[next]
				(sleep/yield 0.05))
			      ; Add the column!
			      (send this add-column
				    (inexact->exact (floor (/ (- (get-field width grid) 1)
							      2)))
				    (- (get-field height grid) 1)
				    next)))))))
