#lang racket

(require "grid.rkt")

(provide colgorithm/c)

; Colgorithms are objects which provide an algorithm
; for determining the next column, given a matrix.
(define colgorithm/c
  (class/c [next (->m grid? 
		      exact-nonnegative-integer?
		      column?)]))


