#lang racket/gui

(require "../controller.rkt")

(provide updater-controller%)

; A controller that just updates the display
(define/contract updater-controller%
		 controller-class/c
		 (class object%
			(super-new)

			(init-field model)
			(field (runner #f))

			(public left right up down start stop step)

			; Player presses left
			(define (left)
			  (void))

			; Player presses right
			(define (right)
			  (void))

			; Player presses up
			(define (up)
			  (void))

			; Player presses down
			(define (down)
			  (void))

			; The game is started
			(define (start)
			  (set! runner (thread main-loop)))

			; The game should be immediately stopped
			(define (stop)
			  (if runner
			    (begin (kill-thread runner)
				   (set! runner #f))
			    (raise (exn:fail:contract "Thread was stopped before being started"
						      (current-continuation-marks)))))

			; This step should be overridden by subclasses!
			(define (step)
			  (send model update)
			  (sleep/yield 0.03))

			; The main game loop
			(define (main-loop)
			  (step)
			  (main-loop))))




