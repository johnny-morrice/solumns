#lang racket

(require "../controller.rkt"
	 "updater.rkt"
	 "../../grid.rkt")

(provide dropper-controller%)

; A controller that drops blocks and moves them when the player presses
; the appropriate keys
(define/contract dropper-controller%
		 (and/c controller-class/c
			(class/c [respond-to-player (->m void)]
				 [gravity (->m void)]
				 [clear-inputs (->m void)]
				 [add-column (->m exact-nonnegative-integer?
						  exact-nonnegative-integer?
					          column?
						  void)]))

		 (class updater-controller%
			(super-new)

			(override step left right up down)
			(public respond-to-player gravity add-column clear-inputs)

			(field (xdir 0)
			       (throw #f)
			       (shift #f)
			       (falling #f))

			; Add a new column
			(define (add-column x y col)
			  (send (get-field model this) add-column x y col)
			  (set! falling #t))

			; Set input states when the player presses keys
			(define (left)
			  (set! xdir -1))

			(define (right)
			  (set! xdir +1))

			(define (down)
			  (set! throw #t))

			(define (up)
			  (set! shift #t))

			; Clear the input state.  Call after processing to ensure a clean state for next inputs.
			(define (clear-inputs)
			  (set! xdir 0)
			  (set! throw #f)
			  (set! shift #f))

			; Let gravity act on the column
			(define (gravity)
			  (if throw
			    (send (get-field model this) throw)
			    (send (get-field model this) drop)))

			; Respond to the player's movements
			(define (respond-to-player)
			  (case xdir
			    [(-1) (send (get-field model this) left)]
			    [(1)  (send (get-field model this) right)]))

			; Perform a step of the game loop
			(define (step)
			  (when falling
			    (respond-to-player)
			    (when (gravity)
			      (set! falling #f)))
			  (clear-inputs)
			  (super step))))

