#lang racket

(require "../controller.rkt"
	 "updater.rkt"
	 "../../grid.rkt")

(provide dropper-controller%)

; A controller that drops blocks and moves them when the player presses
; the appropriate keys
(define/contract dropper-controller%
		 (and/c controller-class/c
			(class/c [gravity (->m void)]
				 [add-column (->m exact-nonnegative-integer?
						  exact-nonnegative-integer?
						  column?
						  void)]
				 [landed (->m any)]))

		 (class updater-controller%
			(super-new)

			(override step
				  left-press
				  right-press
				  up-press
				  down-press
				  down-release)
			(public gravity add-column landed)

			(field (throw #f)
			       (falling #f))

			; Add a new column
			(define (add-column x y col)
			  (send (get-field model this) add-column x y col)
			  (set! falling #t))

			; Set input states when the player presses keys
			(define (left-press)
			  (when falling 
			    (send (get-field model this) left)))

			(define (right-press)
			  (when falling
			    (send (get-field model this) right)))

			(define (down-press)
			  (when falling
			    (set! throw #t)))

			(define (up-press)
			  (when falling
			    (send (get-field model this) shift)))

			; Stop falling!
			(define (down-release)
			  (set! throw #f))

			; Let gravity act on the column
			(define (gravity)
			  (if throw
			    (send (get-field model this) throw)
			    (send (get-field model this) drop)))

			; The column has landed
			(define (landed)
			  (set! falling #f)
			  (send (get-field model this) update))

			; Perform a step of the game loop
			(define (step)
			  (when falling
			    (when (gravity)
			      (landed)))
			  (super step))))

