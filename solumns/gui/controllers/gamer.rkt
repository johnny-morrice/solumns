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
				      [colgorithm colgorithm/c]))

		 (class dropper-controller%
			(super-new)

			(init-field grid colgorithm)

			(override landed)

			(define (landed)
			  (super landed)
			  (send (get-field model this) accelerate 0.02)
			  (do []
			    [(not (send grid elimination-step))]
			    (send (get-field model this) update)
			    (sleep/yield 0.1)
			    (send grid gravity))
			  (send (get-field model this) update)
			  (when (not (send grid lost?))
			    (send this add-column
				  (round-exact (/ (get-field width grid) 2))
				  (- (get-field height grid) 1)
				  (send colgorithm next grid))))))

