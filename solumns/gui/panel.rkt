#lang racket/gui

(require "controller.rkt")

(provide solumns-panel%)

; Frame that passes user input actions to a controller/c
(define/contract solumns-panel%
		 (class/c [controller-is (->m controller/c
					      void)])
		 (class panel%
			(super-new [vert-margin 5]
				   [horiz-margin 5])

			(field (controller #f))

			(override on-subwindow-char on-superwindow-show)

			(public controller-is)

			; Add the controller
			(define (controller-is c)
			  (set! controller c))

			(define (on-subwindow-char receiver event)
			  (when controller
			    (case (send event get-key-code)
			      [(left)  (send controller left)]
			      [(right) (send controller right)]
			      [(up)    (send controller up)]
			      [(down)  (send controller down)])))

			(define (on-superwindow-show shown?)
			  (when (and (not shown?) controller)
			    (send controller stop)))))

