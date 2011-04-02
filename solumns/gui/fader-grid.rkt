#lang racket

(provide fader-gui-grid%)

(define/contract fader-canvas%
		 (class/c 			  
		   [fade (->m
			   exact-nonnegative-integer?
			   (listof (non-empty-listof exact-nonnegative-integer?))
			   void)]
		   [fade-in (->m exact-nonnegative-integer?
				 void)])
		 (class gui-grid%
			(super-new)

			(field
			  [fade-alpha 0]
			  ; Fade alpha d is a positive number
			  ; expressing the magnitude of the change to fade-alpha
			  [fade-alpha-d 0]
			  [faders '()])

			; Set the time it should take to fade in seconds
			(define (fade-in t)
			  (set! fade-alpha-d (/ t (get-field frame-delay))))

			; Draw a fading square
			(define (draw-fader x y c)
			  (let [(add-alpha (lambda (col) (append col (list fade-alpha))))]
			    (apply render-square x y (map add-alpha (shades c)))))

			; We render with transparency!
			(define (draw-grid)
			  (when (> 0 fade-alpha)
			    (for-each
			      (lambda (fa)
				(apply render-fader fa))
			      faders)
			    (set! fade-alpha (- fade-alpha fade-alpha-d)))
			  (super draw-grid))))




