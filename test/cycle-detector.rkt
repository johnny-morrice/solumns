#lang racket

(require "../solumns/colgorithms/cycle-detector.rkt"
	 rackunit)

(define c1
  (vector 1 2 3))

(define a1
  (vector 0 0 1))

(define b1
  (vector 1 1 0))

(define d
  (vector 3 4 5))

(define c2
  (vector 1 2 3))

(define a2
  (vector 0 0 1))

(define b2
  (vector 1 1 0))

(define a3
  (vector 0 0 1))

(define b3
  (vector 1 1 0))


(define memory-cyclic
  (list b3 a3))

(define memory-acyclic
  (list d))

(define candidates
  (list (list a1 #f) (list b1 #f) (list c1 #f)))

(test-case "Prevent cycle"
	   (check-equal? (remove-known memory-cyclic candidates)
			 (list (list c2 #f))))

(test-case "No cycle"
	   (check-equal? (remove-known memory-acyclic candidates)
			 (list (list a2 #f) (list b2 #f) (list c2 #f))))
			  			       		        
