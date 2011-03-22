#lang racket

(provide controller-class?
	 controller?)

; A controller responds to user and other input
(define-syntax-rule (controller-contract contract) 
  (contract [up (->m any)]
	    [start-drop (->m any)]
	    [end-drop (->m any)]
	    [left (->m any)]
	    [right (->m any)]
	    [start (->m any)]
	    [stop (->m any)]))

; Recognise a controller class
(define controller-class?
  (controller-contract class/c))

; Recognise a controller object
(define controller?
  (controller-contract object/c))
