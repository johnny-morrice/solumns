#lang racket/gui

(require "../../solumns/gui/panel.rkt"
	 "../../solumns/gui/grid.rkt"
	 "../../solumns/gui/grid-canvas.rkt"
	 "../../solumns/grid.rkt"
	 "../../solumns/gui/controllers/dropper.rkt")

; Blocks should drop and be moved by the user keys

(define win
  (new frame%
       [label "Solums Drop Test"]
       [width 600]
       [height 600]))

(define gr
  (new grid%
       [width 5]
       [height 10]))

(define game-view
  (new solumns-panel% [parent win]))

(define can
  (new grid-canvas%
       [grid gr]
       [frame-delay 0.03]
       [parent game-view]))

(define screen
  (new gui-grid%
       [speed 0.05]
       [canvas can]
       [grid gr]))

(define dropper
  (new dropper-controller%
       [game-delay 0.03]
       [model screen]))

(new button%
     [parent win]
     [label "Start"]
     [callback (lambda (me evt)
		 (send win delete-child me)
		 (send dropper add-column 3 7 '#(1 2 3))
		 (send game-view controller-is dropper)
		 (send dropper start)
		 (send game-view focus))])

(send win show #t)
