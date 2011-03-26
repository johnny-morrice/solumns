#lang racket

(require framework/preferences)

(define (score? score)
  (and (or (string? (car score))
	   (eq? #f (car score)))
       (exact-nonnegative-integer? (cadr score))))

(provide/contract
  [score? (-> any/c
	      boolean?)]
  [sort-scores (-> (listof score?)
		   (listof score?))]
  [set-default-high-scores (-> void)]
  [set-high-scores (-> (listof score?)
		       void)]
  [get-high-scores (-> (listof score?))]
  [top-ten (-> (listof score?)
	       (listof score?))])

(require framework/preferences)

; Symbol for saving the scores
(define score-sym
  'solumns:high-scores)

; Must be called before other functions
(define (set-default-high-scores)
  (preferences:set-default score-sym
			 '()
			 (listof score?)))

; Get the top ten scores!
(define (top-ten scores)
  (let [(reversed (reverse (sort-scores scores)))]
    (if (< 10 (length scores))
      (cons (car reversed)
	    (take (cdr reversed) 9))
      reversed)))

; Get the high scores
(define (get-high-scores)
  (preferences:get score-sym))

; Set the high scores
(define (set-high-scores scores)
  (preferences:set score-sym scores))

; Sort the scores
(define (sort-scores scores)
  (sort scores (lambda (s1 s2) (< (cadr s1) (cadr s2)))))



