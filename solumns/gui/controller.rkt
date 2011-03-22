#lang racket

(provide controller-class/c
	 controller/c)

; A controller responds to user and other input
(define-syntax-rule (controller-contract contract) 
  (contract [up-press (->m any)]
	    [down-press (->m any)]
	    [down-release (->m any)]
	    [left-press (->m any)]
	    [right-press (->m any)]
	    [start (->m any)]
	    [stop (->m any)]))

; Recognise a controller class
(define controller-class/c
  (controller-contract class/c))

; Recognise a controller object
(define controller/c
  (controller-contract object/c))
