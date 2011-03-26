#lang racket/gui

(require "../../solumns/gui/panel.rkt"
	 "../../solumns/gui/grid.rkt"
	 "../../solumns/gui/score-panel.rkt"
	 "../../solumns/gui/controllers/scorer.rkt"
	 "../../solumns/grid.rkt"
	 "../../solumns/colgorithms/brute-force.rkt")

(define win
  (new frame%
       [label "Test Solums Game with Score"]
       [width 600]
       [height 600]))

(define hoz
  (new horizontal-panel% [parent win]))

(define gr
  (new grid%
       [width 6]
       [height 15]))

(define brute
  (new brute-force% [colours 7]))

(define game-view
  (new solumns-panel%
       [parent hoz]))

(define screen
  (new gui-grid% [parent game-view] [grid gr]))

(define vert
  (new vertical-panel%
       [parent hoz]
       [alignment '(left center)]
       [min-width 100]
       [stretchable-width #f]))

(define hud
  (new score-panel% [parent vert]))

(define scorer 
  (new scorer-controller%
       [model screen]
       [grid gr]
       [colgorithm brute]
       [score-board hud]))

(new button%
     [parent win]
     [label "Start"]
     [callback (lambda (me evt)
		 (send win delete-child me)
		 (send scorer add-column 2 12 (send brute next gr))
		 (send game-view controller-is scorer)
		 (send scorer start)
		 (send game-view focus))])

(send win show #t)
