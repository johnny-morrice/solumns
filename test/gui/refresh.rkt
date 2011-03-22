#lang racket/gui

(require "../../solumns/grid.rkt"
	 "../../solumns/gui/grid.rkt"
	 "../../solumns/gui/panel.rkt"
	 "../../solumns/gui/controllers/updater.rkt")

; Should create a frame, showing a grid, that is dynamically resized.

(define win
  (new frame%
       [label "Solumns Refresh Test"]))

(define screen
  (new solumns-panel%
       [parent win]))

(define gr
  (new grid%
       [width 3]
       [height 6]))

(define game
  (new gui-grid% 
       [parent screen]
       [grid gr]))

(send gr add-column 0 0 '#(0 1 2))
(send gr matrix-set! 1 0 3)
(send gr matrix-set! 1 1 4)
(send gr matrix-set! 2 0 5)

(define refresher
  (new updater-controller% [model game]))

(new button%
     [parent win]
     [label "Start"]
     [callback (lambda (me evt)
		 (send win delete-child me)
		 (send screen controller-is refresher)
		 (send refresher start))])

(send win show #t)
