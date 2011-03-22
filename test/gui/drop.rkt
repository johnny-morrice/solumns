#lang racket/gui

(require "../../solumns/gui/panel.rkt"
	 "../../solumns/gui/grid.rkt"
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

(define screen
  (new gui-grid% [parent game-view] [grid gr]))

(define dropper
  (new dropper-controller% [model screen]))



(new button%
     [parent win]
     [label "Start"]
     [callback (lambda (me evt)
		 (send win delete-child me)
		 (send dropper add-column 3 7 '#(1 2 3))
		 (send game-view controller-is dropper)
		 (send dropper start)
		 (send win focus))])

(send win show #t)
