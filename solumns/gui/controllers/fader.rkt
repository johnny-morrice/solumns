#lang racket

(require "restarter.rkt"
	 "../grid-fader.rkt")

(provide fader-controller%)

(define/contract fader-controller%
		 (class/c (init-field [model (is-a?/c gui-grid-fader%)]))
		 (class restarter-controller%
			(super-new)

			(override eliminate)

			; Whenever blocks are eliminated, get the GUI to fade them out!
			(define (eliminate)
			  (let* [(blocks (super eliminate))
				 (special (send (get-field grid this) clone))]
			    (when (> (length blocks) 0)
			      (send (get-field model this)
				    fade
				    (get-field gravity-delay this)
				    special
				    blocks))
			    blocks))))
