#lang racket/gui

(require "controller.rkt")

(provide solumns-frame%)

; Frame that passes user input actions to a controller/c
(define/contract solumns-frame%
		 (class/c (init-field [controller controller?]))
		 (class frame%
			(super-new)

			(init-field controller)
			(override on-subwindow-char)
			(augment on-close)

			(define (on-subwindow-char receiver event)
			  (case (send event get-key-code)
			    [(left)  (send controller left)]
			    [(right) (send controller right)]
			    [(up)    (send controller up)]
			    [(down)  (send controller down)]))

			(define (on-close)
			  (send controller stop))))
				  
