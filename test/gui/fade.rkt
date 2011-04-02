#lang racket/gui

(require "../../solumns/gui/panel.rkt"
	 "../../solumns/gui/grid-fader.rkt"
	 "../../solumns/gui/fader-canvas.rkt"
	 "../../solumns/gui/score-panel.rkt"
	 "../../solumns/gui/controllers/fader.rkt"
	 "../../solumns/grid.rkt"
	 "../../solumns/colgorithms/brute-force.rkt")

(define win
  (new frame%
       [label "Test Solums Game with SPECIAL FX"]
       [width 600]
       [height 800]))

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
	 [min-width 400]))

  (define can
    (new fader-canvas%
	 [frame-delay 0.03]
	 [grid gr]
	 [parent game-view]))

  (define screen
    (new gui-grid-fader%
	 [speed 0.05]
	 [canvas can]
	 [grid gr]))

  (define hud
    (new score-panel%
	 [parent hoz]
	 [alignment '(left center)]
	 [min-width 200]
	 [stretchable-width #f]))

  (define restarter 
    (new fader-controller%
	 [game-delay 0.03]
	 [acceleration 0.001]
	 [gravity-delay 0.2]
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
