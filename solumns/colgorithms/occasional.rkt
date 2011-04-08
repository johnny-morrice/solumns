#lang racket/gui

(require "brute-force.rkt")

(provide occasional%)

; Occasionally give a random column, to stop infinite cycles.
(define occasional%
  (class brute-force%
	 (super-new)

	 (override next-evil)

	 (field [count 0])

	 (define (next-evil gr)
	   (if (or (= 5 count) (= 0 (random 10)))
	     (begin
	       (sleep/yield 0.1)
	       (set! count 0)
	       (send this next-random gr))
	     (begin
	       (set! count (+ 1 count))
	       (super next-evil gr))))))
