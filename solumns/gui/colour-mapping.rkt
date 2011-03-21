#lang racket/gui

(define (find nm)
  (send the-color-database find-color nm))

; A hash of colour numbers as used by colgorithms to colors
(define colour-table
  (hash #f (find "black")
	0 (find "red")
	1 (find "yellow")
	2 (find "lime")
	3 (find "blue")
	4 (find "darkturquoise")
	5 (find "fuchsia")
	6 (find "darkorange")))


; Map integers or #f to colours, recognised by gracket
(define (to-colour c)
  (hash-ref colour-table c))

(provide/contract
  [colour-table hash?]
  [to-colour (-> (or/c #f
		       (and/c exact-nonnegative-integer?
			      (lambda (n)
				(< n (length (for/list
					       [(p (in-hash-keys colour-table))]
					       #f))))))
		 (is-a?/c color%))])

