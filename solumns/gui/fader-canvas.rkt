#lang racket

; Copyright 2011 John Morrice
;
; This file is part of Solumns. 
;
; Solumns is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; Foobar is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with Solumns.  If not, see <http://www.gnu.org/licenses/>.

(require "grid-canvas.rkt"
	 "colour-mapping.rkt"
	 "../grid.rkt"
	 sgl
	 sgl/gl)

(provide fader-canvas%)

; TODO this class implements some pretty slow openGL code.  Go fix!
(define/contract fader-canvas%
		 (class/c 			  
		   [fade (->m
			   (and/c real? positive?)
			   (is-a?/c grid%)
			   (listof (vectorof exact-nonnegative-integer?))
			   void)])
		 (class grid-canvas%
			(super-new)

			(public fade)
			(inherit render-square shades)
			(override draw-grid)

			(field
			  [static #f]
			  [fade-alpha 0]
			  ; Fade alpha d is a positive number
			  ; expressing the magnitude of the change to fade-alpha
			  [fade-alpha-d 0]
			  [faders '()]
			  [blended #f])

			; Set the time it should take to fade in seconds
			; as well as the squares to be faded
			(define (fade t clone squares)
			  (set! static clone)
			  (set! faders (map vector->list squares))
			  (set! fade-alpha-d (/ (get-field frame-delay this) t))
			  (set! fade-alpha 1.0))

						  ; Draw a fading square
			(define (draw-fader x y c)
			  (let [(add-alpha (lambda (col) (append col (list fade-alpha))))]
			    (apply (lambda (l d dr)
				     (render-square x y l d dr))
				   (map add-alpha (shades (to-colour c))))))

			; Enable blending
			(define (enable-blending)
			  (when (not (glGetBooleanv GL_RGBA_MODE 1))
			    (raise (exn:fail:contract "can't enable transparency"
						      (current-continuation-marks))))
			  (gl-enable 'blend)
			  (gl-blend-func 'src-alpha 'one-minus-src-alpha)
			  (set! blended #t))

			; We render with transparency!
			(define (draw-grid)

			  (unless blended
			    (enable-blending))

			  (if (> fade-alpha 0)
			    (begin
			      (for-each
				(lambda (fa)
				  (apply 
				    (lambda (x y c) 
				      (draw-fader x y c))
				    fa))
				faders)
			      (set! fade-alpha (- fade-alpha fade-alpha-d))
			      (super draw-grid static))
			    (super draw-grid)))))




