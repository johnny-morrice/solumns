#lang racket/gui

(require "../../solumns/gui/grid-canvas.rkt"
	 "../../solumns/gui/next-column.rkt"
	 "../../solumns/grid.rkt")

; Test that the GUI provides a proper representation of the grid.

; Create a grid
(define gr
  (new grid% [width 3] [height 6]))

(send gr matrix-set! 0 0 1)
(send gr matrix-set! 0 1 2)
(send gr matrix-set! 0 2 3)
(send gr matrix-set! 1 0 4)
(send gr matrix-set! 1 1 5)
(send gr matrix-set! 2 0 6)

; Create a window
(define win
  (new frame%
       [label "Solumns Grid Representation"]
       [width 400]
       [height 800]))

; Create the GUI grid
(define canvas
  (new grid-canvas%
       [frame-delay 0.03]
       [parent win]
       [grid gr]))

(send canvas falling (dropper 2 3 '#(7 8 9)))
(send win show #t) 

(thread (lambda ()
	  (system "eog test/img/layout.png")))
