#lang racket

(require "../solumns/cgrid.rkt"
	 "../solumns/colgorithms/brute-force.rkt"
         racket/runtime-path)

(define gr
  (new cgrid% [width 7] [height 9]))

(send gr add-column 0 0 '#(1 8 9))
(send gr add-column 1 0 '#(3 4 5))
(send gr add-column 1 3 '#(5 4 6))
(send gr add-column 2 0 '#(5 6 1))
(send gr add-column 3 0 '#(1 9 2))
(send gr add-column 3 3 '#(3 4 5))
(send gr add-column 4 3 '#(5 4 7))
(send gr add-column 5 0 '#(0 1 2))
(send gr add-column 5 3 '#(7 4 7))
(send gr add-column 6 3 '#(5 8 1))

(define brute
  (new brute-force% [colours 9]))

(define (stress)
  (printf "Generated: ~a\n" (send brute next gr)))

(for [(i (in-range 10))]
  (time (stress)))
   
