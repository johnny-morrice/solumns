#lang racket/gui

(require "../../solumns/gui/panel.rkt"
	 "../../solumns/gui/grid.rkt"
	 "../../solumns/gui/score-panel.rkt"
	 "../../solumns/gui/controllers/restarter.rkt"
	 "../../solumns/grid.rkt"
	 "../../solumns/colgorithms/brute-force.rkt")

(define win
  (new frame%
       [label "Test Solums Game with High-Score"]
       [width 600]
       [height 900]))

(define (create-gui)
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
	 [parent hoz]
	 [min-width 500]))

  (define screen
    (new gui-grid% [parent game-view] [grid gr]))

  (define vert
    (new vertical-panel%
	 [parent hoz]
	 [min-width 100]
	 [alignment '(left center)]))

  (define hud
    (new score-panel% [parent vert]))

  (define restarter 
    (new restarter-controller%
	 [model screen]
	 [grid gr]
	 [colgorithm brute]
	 [score-board hud]
	 [restart-callback
	   (lambda ()
	     (send win delete-child hoz)
	     (create-gui))]))

  (send restarter add-column 2 12 (send brute next gr))
  (send game-view controller-is restarter)
  (send restarter start)
  (send game-view focus))

(new button%
     [parent win]
     [label "Start"]
     [callback (lambda (me evt)
		 (send win delete-child me)
		 (create-gui))])

(send win show #t)
