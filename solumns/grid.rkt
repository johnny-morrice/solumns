#lang racket

(provide grid%)

; A grid of blocks present on the screen.
(define/contract grid%
  (class/c [elimination-step (->m boolean?)])
  (class object%
	 (super-new)
	 (init-field width height)
	 (field [matrix
		  (build-vector width
				(lambda (i) (build-vector height
							  (lambda (j) #f))))])

	   ; Apply gravity to a grid.
	   (define (gravity grid)
	     (list->vector
	       (for/list [(col grid)]
			 (let [(dropped (vector-filter remq* '(#f) col))]
			   (vector-append dropped (make-vector (- height (length dropped)) #f))))))

	   ; Apply a single step of elimination to a grid (that is, removal of congruent elements)

