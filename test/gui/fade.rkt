#lang racket/gui

(require "../../solumns/gui/panel.rkt"
	 "../../solumns/gui/grid.rkt"
	 "../../solumns/gui/score-panel.rkt"
	 "../../solumns/gui/controllers/fader.rkt"
	 "../../solumns/grid.rkt"
	 "../../solumns/colgorithms/brute-force.rkt")

(define win
  (new frame%
       [label "Test Solums Game that can be restarted"]
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

  (define screen
    (new fader-gui-grid% [parent game-view] [grid gr]))

  (define hud
    (new score-panel%
	 [parent hoz]
	 [alignment '(left center)]
	 [min-width 200]
	 [stretchable-width #f]))

  (define fader 
    (new fader-controller%
	 [model screen]
	 [grid gr]
	 [colgorithm brute]
	 [score-board hud]
	 [restart-callback
	   (lambda ()
	     (send win delete-child hoz)
	     (create-gui))]))

  (send fader add-column 2 12 (send brute next gr))
  (send game-view controller-is fader)
  (send fader start)
  (send game-view focus))

(new button%
     [parent win]
     [label "Start"]
     [callback (lambda (me evt)
		 (send win delete-child me)
		 (create-gui))])

(send win show #t)
