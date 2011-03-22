#lang racket/gui

(require "../../solumns/gui/frame.rkt")

; Blocks should drop and be moved by the user keys

(define gr
  (new grid%
       [width 5]
       [height 10]))

(define dropper
  (new block-dropper% [grid gr]))

(define win
  (new solumns-frame%
       [label "Solums Drop Test"]
       [controller dropper]))

(new button%
     [parent win]
     [label "Start"]
     [callback (lambda (me evt)
		 (send win delete-child me)
		 (send gr add-column 3 7 '#(1 2 3))
		 (send dropper start))])


