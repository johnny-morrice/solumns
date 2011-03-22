#lang racket/gui

(require "controller.rkt")

(provide solumns-panel%)

; Frame that passes user input actions to a controller/c
(define/contract solumns-panel%
		 (class/c [controller-is (->m controller/c
					      void)])
		 (class panel%
			(super-new)

			(field (controller #f))

			(override on-subwindow-char on-superwindow-show)

			(public controller-is)

			; Add the controller
			(define (controller-is c)
			  (set! controller c))

			(define (on-subwindow-char receiver event)
			  (when controller
			    (case (send event get-key-code)
			      [(left)   (send controller left-press)]
			      [(right)  (send controller right-press)]
			      [(up)     (send controller up-press)]
			      [(down)   (send controller down-press)]
			      [(release) (case (send event get-key-release-code)
					   [(down)  (send controller down-release)])])))

			(define (on-superwindow-show shown?)
			  (when (and (not shown?) controller)
			    (send controller stop)))))

