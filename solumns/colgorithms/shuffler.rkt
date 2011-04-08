#lang racket

(require "occasional.rkt")

(provide shuffler%)

(provide/contract
  [shuffle (-> (listof any/c)
	       (listof any/c))])

; Shuffle a list
; Use Fisher-Yates algorithm
(define (shuffle li)
  (let [(ve (list->vector li))]
    (for [(i (in-range (sub1 (vector-length ve)) 1 -1))]
	 (let* [(j (random (add1 i)))
		(temp-i (vector-ref ve i))]
	   (vector-set! ve i (vector-ref ve j))
	   (vector-set! ve j temp-i)))
    (vector->list ve)))
	   
; This colgorithm is derived from occasional,
; but shuffles the order of the columns
; in order to create more interesting games.
(define/contract shuffler%
		 (class/c [shuffle-columns (->m void)])
		 (class occasional%
			(super-new)

			; Shuffle the order of the columns
			(define/public (shuffle-columns)
				       (set-field! columns this
						   (shuffle (get-field columns this))))))
