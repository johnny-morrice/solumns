#lang racket

(require "grid.rkt")

(provide colgorithm-class/c
	 colgorithm/c)

; Macro that returns code for a contract on colgorithms
(define-syntax-rule (nexter contract-type)
		    (contract-type [next (->m (is-a?/c grid%) 
			           column?)]))

; Colgorithms are objects which provide an algorithm
; for determining the next column, given a grid%.
; This contract recognises a class
(define colgorithm-class/c
  (nexter class/c))

; This contract recognises an object of the class colgorithm/c
(define colgorithm/c
  (nexter object/c))


