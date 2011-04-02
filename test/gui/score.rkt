#lang racket/gui

(require "../../solumns/gui/panel.rkt"
	 "../../solumns/gui/grid.rkt"
	 "../../solumns/gui/grid-canvas.rkt"
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

(define can
  (new grid-canvas%
       [frame-delay 0.03]
       [grid gr]
       [parent game-view]))

(define screen
  (new gui-grid%
       [speed 0.05]
       [canvas can]
       [grid gr]))

(define hud
  (new score-panel%
       [parent hoz]
       [alignment '(left center)]
       [min-width 100]
       [stretchable-width #f]))

(define scorer 
  (new scorer-controller%
       [game-delay 0.03]
       [acceleration 0.02]
       [gravity-delay 0.5]
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
