#lang racket

(require "grid.rkt")

(provide colgorithm/c
	 column?)

; A column is a vector of length 3, containing exact integers.
(define column?
  (flat-named-contract 'column
		       (lambda (candidate)
			 (and (vector? candidate)
			      (= (vector-length candidate) 3)
			      ((vectorof exact-nonnegative-integer?))))))

; Colgorithms are objects which provide an algorithm
; for determining the next column, given a matrix.
(define colgorithm/c
  (class/c [next (->m grid? 
		      exact-nonnegative-integer?
		      column?)]))


