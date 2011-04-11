#lang racket/gui

(require "../../solumns/grid.rkt"
	 "../../solumns/gui/grid.rkt"
	 "../../solumns/gui/grid-canvas.rkt"
	 "../../solumns/gui/panel.rkt"
	 "../../solumns/gui/controllers/updater.rkt")

; Should create a frame, showing a grid, that is dynamically resized.

(define win
  (new frame%
       [label "Solumns Refresh Test"]
       [width 600]
       [height 600]))

(define screen
  (new solumns-panel%
       [parent win]))

(define gr
  (new grid%
       [width 3]
       [height 6]))

(define can
  (new grid-canvas%
       [grid gr]
       [frame-delay 0.03]
       [parent screen]))

(define game
  (new gui-grid%
       [speed 0.05]
       [canvas can]
       [grid gr]))

(send gr add-column 0 0 '#(0 1 2))
(send gr matrix-set! 1 0 3)
(send gr matrix-set! 1 1 4)
(send gr matrix-set! 2 0 5)

(define refresher
  (new updater-controller%
       [game-delay 0.03]
       [model game]))

(new button%
     [parent win]
     [label "Start"]
     [callback (lambda (me evt)
		 (send win delete-child me)
		 (send screen controller-is refresher)
		 (send refresher start))])

(send win show #t)
