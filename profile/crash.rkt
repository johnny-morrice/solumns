#lang racket

(require "../solumns/cgrid.rkt"
	 "../solumns/colgorithms/random.rkt"
	 "../solumns/colgorithms/brute-force.rkt")

(define clrs
  3)

(define brute
  (new brute-force% [colours clrs]))

(define gr
  (new cgrid% [width 4] [height 9]))

(define rand
  (make-rand clrs))

(define (racol)
  (send rand next gr))

(send gr add-column 0 0 (racol))
(send gr add-column 1 0 (racol))
(send gr add-column 1 3 (racol))
(send gr add-column 2 0 (racol))
(send gr add-column 3 0 (racol))
(send gr add-column 3 3 (racol))

(define start
  (current-milliseconds))

(define (crash)
  (for [(i (in-naturals))]
       (printf "Bruteforcing... ~ams\n" (- (current-milliseconds) start))
       (printf "Generated: ~a\n\n" (send brute next gr))))

(crash)
