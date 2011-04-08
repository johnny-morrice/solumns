#lang racket

(require "../solumns/gui/pause-status.rkt"
	 rackunit)

(define p
  (new pause-status%))

(test-case "Starts not paused."
	   (check-false (send p paused?)))

(test-case "Toggling pauses"
	   (send p toggle-pause)
	   (check-true (send p paused?)))

(test-case "Toggling unpauses"
	   (send p toggle-pause)
	   (check-false (send p paused?)))
