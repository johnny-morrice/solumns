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
			  [lose (->m any)])
			  

		 (class dropper-controller%
			(super-new)

			(init-field grid colgorithm)

			(override landed)

			(public eliminate lose)

			; Perform elimination on the grid.
			; Return false if no elimination took place.
			(define (eliminate)
			  (not (send grid elimination-step)))

			; You have lost :(
			(define (lose)
			  (void))

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
				      (set! next (send colgorithm next clone)))))
			  ; Do some special effects while we wait for the next column
			  (do []
			    [(send this eliminate)]
			    (send (get-field model this) update)
			    (sleep/yield 0.5)
			    (send grid gravity))
			  (send (get-field model this) update)
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
				    (round-exact (/ (get-field width grid) 2))
				    (- (get-field height grid) 1)
				    next)))))))
