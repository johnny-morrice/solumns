#lang racket/gui

(require "../../solumns/gui/high-score-viewer.rkt")

(define win
  (new frame% [label "Test Score Filling"]))

(define test-score-viewer%
  (class high-score-viewer%
	 (super-new)

	 (override on-superwindow-show)

	 (define (on-superwindow-show shown?)
	   (when (not shown?)
	     (printf "The new champion was: ~a\n" (send this new-hero))))))


(new message%
     [parent win]
     [label "Lowest scoring"])

(define filler-low
  (new test-score-viewer%
       [parent win]
       [scores '(("Billy" 10000)
		 ("Alex" 5000)
		 (#f 3000))]))

(new message%
     [parent win]
     [label "Highest scoring"])

(define filler-high
  (new test-score-viewer%
       [parent win]
       [scores '((#f 2000)
		 ("Lucy" 1000)
		 ("Sammy" 100))]))


(new message%
     [parent win]
     [label "Middling score"])

(define filler-middle
  (new test-score-viewer%
       [parent win]
       [scores '(("Cindy" 10000)
		 (#f 2000)
		 ("Mike" 1000))]))

(send win show #t)
(send filler-low display-scores)
(send filler-high display-scores)
(send filler-middle display-scores)
