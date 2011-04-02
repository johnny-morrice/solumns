#lang racket

(require "grid.rkt"
	 "../grid.rkt"
	 "fader-canvas.rkt")

(provide gui-grid-fader%)

; TODO The existence of this pointless fucking class shows that
; this is designed a little wrong
(define/contract gui-grid-fader%
		 (class/c [fade (->m 
				  (and/c real? positive?)
				  (is-a?/c grid%)
				  (listof (vectorof exact-nonnegative-integer?))
				void)]
			  (init-field [canvas (is-a?/c fader-canvas%)]))
		 (class gui-grid%
			(super-new)

			; Fade out some bricks
			(define/public (fade time grid bricks)
			  (send (get-field canvas this) fade time grid bricks))))
