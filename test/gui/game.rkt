#lang racket/gui

(require "../../solumns/gui/panel.rkt"
	 "../../solumns/gui/grid.rkt"
	 "../../solumns/gui/grid-canvas.rkt"
	 "../../solumns/gui/controllers/gamer.rkt"
	 "../../solumns/grid.rkt"
	 "../../solumns/colgorithms/brute-force.rkt")

(define win
  (new frame%
       [label "Test Solums Game Prototype"]
       [width 600]
       [height 600]))

(define gr
  (new grid%
       [width 6]
       [height 15]))

(define brute
  (new brute-force% [colours 7]))

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

(define gamer
  (new gamer-controller%
       [game-delay 0.03]
       [acceleration 0.02]
       [gravity-delay 0.5]
       [model screen]
       [grid gr]
       [colgorithm brute]))

(new button%
     [parent win]
     [label "Start"]
     [callback (lambda (me evt)
		 (send win delete-child me)
		 (send gamer add-column 2 12 (send brute next gr))
		 (send game-view controller-is gamer)
		 (send gamer start)
		 (send game-view focus))])

(send win show #t)
