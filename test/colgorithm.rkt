#lang racket

; General testing for colgorithms

(require "../solumns/colgorithm.rkt"
	 "../solumns/grid.rkt"
	 rackunit)

(provide check-colgorithm)

; Receive a function which takes a number of colours and creates a colgorithm
; test the colgorithms it creates act to produce a local minimum
(define (check-colgorithm cg-maker)
  (local [(define cg
	    (cg-maker 3))
	  (define single
	    (new grid% [width 2] [height 5]))
	  (define double
	    (new grid% [width 3] [height 3]))]
	 (send single matrix-set! 0 0 0)
	 (send single matrix-set! 0 1 0)
	 (send single matrix-set! 1 0 1)
	 (send single matrix-set! 1 1 1)
	 (send double add-column 0 0 '#(0 1 2))
	 (send double add-column 1 0 '#(0 1 2))
	 ; Check if simple minimisation works
	 (local [(define single-col
		   (send cg next single))
		 (define (single-col-pos x y)
		   (let [(cl (send single clone))]
		     (send cl add-column x y single-col)
		     (send cl reduce)
		     cl))]
		(check-eq? (send (car (sort (list (single-col-pos 0 2) (single-col-pos 1 2)) grid-lt))
				 size)
			   7))
	 ; Check if a harder minimisation works
	 (send double add-column 2 0 (send cg next double))
	 (send double reduce)
	 (check-eq? (send double size)
		    2)))
