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

			(public left-press
				left-release
				right-press
				right-release
				up-press
				up-release
				down-press
				down-release
				start stop step)

			; Player presses left
			(define (left-press)
			  (void))

			; Player releases left
			(define (left-release)
			  (void))

			; Player presses right
			(define (right-press)
			  (void))

			; Player releases right
			(define (right-release)
			  (void))

			; Player presses up
			(define (up-press)
			  (void))

			; Player releases up
			(define (up-release)
			  (void))

			; Player presses down
			(define (down-press)
			  (void))

			; Player releases down
			(define (down-release)
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




