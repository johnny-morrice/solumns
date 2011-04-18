#lang racket

(require ffi/unsafe)

(provide eliminator
	 copy-matrix
	 retrieve-matrix)

; The shared object providing the elimination-step function
(define eliminator-lib
  (ffi-lib "work/elimination"))

; The elimination-step function
(define (eliminator width height)
  (get-ffi-obj "elimination_step"
	       eliminator-lib
	       (_fun (_vector io (_vector io _int8 height) width) -> _bool)))

; Convert the matrix to C format
(define (increment-matrix eliminator)
  incremented
	  (vector-map
	    (lambda (row)
	      (vector-map
		(lambda (cell)
		  (if cell
		    (add1 cell)
		    0))
		row))
	    matrix))

