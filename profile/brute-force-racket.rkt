#lang racket

(require "../solumns/grid.rkt"
	 "../solumns/colgorithms/brute-force.rkt")

(define brute
  (new brute-force% [colours 9]))

(define gr
  (new grid% [width 7] [height 9]))

(send gr add-column 0 0 '#(0 1 2))
(send gr add-column 1 0 '#(3 4 5))
(send gr add-column 1 3 '#(5 4 1))
(send gr add-column 2 0 '#(5 6 0))
(send gr add-column 3 0 '#(0 1 2))
(send gr add-column 3 3 '#(3 4 5))
(send gr add-column 4 3 '#(5 4 1))
(send gr add-column 5 0 '#(0 1 2))
(send gr add-column 5 3 '#(3 4 5))
(send gr add-column 6 3 '#(5 4 1))

(define (stress)
  (printf "Generated: ~a\n" (send brute next gr)))

(stress)
