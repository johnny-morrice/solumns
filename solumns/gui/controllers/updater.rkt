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
				right-press
				up-press
				down-press
				down-release
				start stop step)

			; Player presses left
			(define (left-press)
			  (void))

			; Player presses right
			(define (right-press)
			  (void))

			; Player presses up
			(define (up-press)
			  (void))

			; Player presses down
			(define (down-press)
			  (void))

			; Player releases down
			(define (down-release)
			  (void))

			; The game is started
			(define (start)
			  (set! runner (thread main-loop))
			  (log-info "Controller started"))

			; The game should be immediately stopped
			(define (stop)
			  (when runner
			      (log-info "Controller stopping...")
			      (kill-thread runner)))

			; This step should be overridden by subclasses!
			(define (step)
			  (send model update)
			  (sleep/yield 0.03))

			; The main game loop
			(define (main-loop)
			  (step)
			  (main-loop))))




