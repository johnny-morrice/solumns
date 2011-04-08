#lang racket/gui

(require "../../solumns/gui/pauser-panel.rkt"
	 "../../solumns/gui/grid-fader.rkt"
	 "../../solumns/gui/fader-canvas.rkt"
	 "../../solumns/gui/pauser-score-panel.rkt"
	 "../../solumns/gui/controllers/pauser.rkt"
	 "../../solumns/gui/pause-status.rkt"
	 "../../solumns/grid.rkt"
	 "../../solumns/colgorithms/rotator.rkt")

(define win
  (new frame%
       [label "Test Solums Game that randomly rotates generated columns."]
       [width 600]
       [height 800]))

(define pause
  (new pause-status%))

(define (create-gui)
  (define hoz
    (new horizontal-panel% [parent win]))

  (define gr
    (new grid%
	 [width 6]
	 [height 15]))

  (define brute
    (new rotator% [colours 9]))

  (define game-view
    (new pauser-panel%
	 [pause-status pause]
	 [parent hoz]
	 [min-width 400]))

  (define can
    (new fader-canvas%
	 [frame-delay 0.01]
	 [grid gr]
	 [parent game-view]))

  (define screen
    (new gui-grid-fader%
	 [speed 0.05]
	 [canvas can]
	 [grid gr]))

  (define hud
    (new pauser-score-panel%
	 [pause-status pause]
	 [parent hoz]
	 [alignment '(left center)]
	 [min-width 200]
	 [stretchable-width #f]))

  (define restarter 
    (new pauser-controller%
	 [pause-status pause]
	 [game-delay 0.03]
	 [acceleration 0.0001]
	 [gravity-delay 0.4]
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
