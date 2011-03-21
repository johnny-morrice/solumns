#lang racket

; Test the random colgorithm algorithm

(require "../solumns/colgorithms/random.rkt"
	 "../solumns/grid.rkt"
	 rackunit)

(test-case "Choose randomly from set"
	   (let [(choose (random-member (set 0 1 2)))]
	     (check-true (or (= 0 choose)
			     (= 1 choose)
			     (= 2 choose)))))

; Create a new random column generator
(define rand
  (make-rand 3))

; Create a grid
(define gr
  (new grid% [width 1] [height 1]))

; Generate one hundred columns randomly.
(define columns
  (for/list [(i (in-range 0 100))]
	    (send rand next gr)))

; Each colour is distinct from the other two
(define (all-dissimilar col)
  (not (or (= (vector-ref col 0)
	      (vector-ref col 1))
	   (= (vector-ref col 1)
	      (vector-ref col 2))
	   (= (vector-ref col 2)
	      (vector-ref col 0)))))

; Each colour has at least one colour that is dissimilar from the other two
(define (one-dissimilar col)
  (or (not (= (vector-ref col 0)
	      (vector-ref col 1)))
      (not (= (vector-ref col 1)
	      (vector-ref col 2)))
      (not (= (vector-ref col 2)
	      (vector-ref col 0)))))

; Apply a predicate to elements of a list, return true if any of them are true.
(define (list-any? f l)
  (foldl (lambda (e gd)
	   (or (f e) gd)) #f l))

; Apply a predicate to elements of a list, return true if all of them are true
(define (list-all? f l)
  (foldl (lambda (e gd)
	   (and (f e) gd)) #t l))

(test-case "Two colour columns present in 100 samples"
	   (check-true (list-any? (lambda (column)
				    (and (not (all-dissimilar column))
					 (one-dissimilar column)))
				 columns)))

(test-case "Three colour columns present in 100 samples"
	   (check-true (list-any? all-dissimilar columns)))

(test-case "All and only expected colours present in 100 samples"
	   (let [(clrs (flatten (map vector->list columns)))]
	     (check-true (list-all?
			      (lambda (clr)
				     (or (= 0 clr)
					 (= 1 clr)
					 (= 2 clr))) clrs))))
