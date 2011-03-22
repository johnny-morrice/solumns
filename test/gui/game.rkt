#lang racket/gui

(require "../../solumns/gui/panel.rkt"
	 "../../solumns/gui/grid.rkt"
	 "../../solumns/gui/controllers/gamer.rkt"
	 "../../solumns/grid.rkt"
	 "../../solumns/colgorithms/brute-force.rkt")

(define win
  (new frame%
       [label "Solums Game Prototype"]
       [width 600]
       [height 600]))

(define gr
  (new grid%
       [width 6]
       [height 12]))

(define brute
  (new brute-force% [colours 7]))

(define game-view
  (new solumns-panel% [parent win]))

(define screen
  (new gui-grid% [parent game-view] [grid gr]))

(define gamer
  (new gamer-controller%
       [model screen]
       [grid gr]
       [colgorithm brute]))

(new button%
     [parent win]
     [label "Start"]
     [callback (lambda (me evt)
		 (send win delete-child me)
		 (send gamer add-column 2 9 (send brute next gr))
		 (send game-view controller-is gamer)
		 (send gamer start)
		 (send game-view focus))])

(send win show #t)
