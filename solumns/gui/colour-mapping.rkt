#lang racket/gui

; A hash of colour numbers as used by colgorithms to colors
(define colour-table
  (hash 0 '(0.9 0.0 0.0)
	1 '(0.9 0.9 0)
	2 '(0.0 0.9 0)
	3 '(0.0 0.0 0.9)
	4 '(0.0 0.81 0.81)
	5 '(0.87 0.0 1.0)
	6 '(0.45 0.45 0.45)))


; Map integers or #f to colours, recognised by gracket
(define (to-colour c)
  (hash-ref colour-table c))

(provide/contract
  [colour-table hash?]
  [to-colour (-> (and/c exact-nonnegative-integer?
			(lambda (n)
			  (< n (length (for/list
					 [(p (in-hash-keys colour-table))]
					 #f)))))
		 (listof (and/c real? (not/c negative?))))])

