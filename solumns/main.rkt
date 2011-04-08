#lang racket/gui

(require "gui/pauser-panel.rkt"
	 "gui/grid-fader.rkt"
	 "gui/fader-canvas.rkt"
	 "gui/pauser-score-panel.rkt"
	 "gui/controllers/pauser.rkt"
	 "gui/pause-status.rkt"
	 "grid.rkt"
	 "colgorithms/rotator.rkt"
	 "util.rkt"
	 net/sendurl
	 racket/runtime-path)

(define win-width 400)
(define win-height 600)

(call-with-values get-display-size
		  (lambda (sw sh)
		    (set! win-height (round-exact (* 0.8 sh)))
		    (set! win-width (round-exact (* 0.8 win-height)))))

; The window takes up most of the screen.
(define win
  (new frame%
       [label "Solumns :("]
       [width win-width]
       [height win-height]))

; Tracks the state of the game being paused
(define pause
  (new pause-status%))

; Create the solumns gui
(define (create-gui)
  (define hoz
    (new horizontal-panel%
	 [parent win]
	 [min-width (max win-width (send win get-width))]
	 [min-height (max win-height (send win get-height))]
	 [stretchable-width #f]
	 [stretchable-height #f]))

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
	 [min-width 300]))

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
	 [min-width 150]
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

; Panel to hold the intro stuff
(define intro-panel
  (new vertical-panel%
       [parent win]
       [alignment '(center center)]))

; Show the solumns logo
(define logo
  (make-object bitmap% "data/logo.png" 'png))

(define can
  (new canvas%
       [parent intro-panel]
       [min-width 128]
       [min-height 128]
       [stretchable-width #f]
       [stretchable-height #f]
       [paint-callback (lambda (me dc)
			 (send dc draw-bitmap logo 0 0))]))

; Write some instructions
(new message%
     [parent intro-panel]
     [font (make-object font% 18 'default 'normal 'bold)]
     [label "SOLUMNS"])

(new message%
     [parent intro-panel]
     [label "Solumns is an evil colour matching game."])

(new message%
     [parent intro-panel]
     [label "Columns fall from the sky."])

(new message%
     [parent intro-panel]
     [label "Use the arrow keys to move them."])

(new message%
     [parent intro-panel]
     [label "The up key cycles the colours."])

(new message%
     [parent intro-panel]
     [label "Prevent the grid becoming full by eliminating squares"])

(new message%
     [parent intro-panel]
     [label "Three or more squares of the same colour are eliminated if they are touching."])

(new message%
     [parent intro-panel]
     [label "Sounds simple?"])

(new message%
     [parent intro-panel]
     [label "Not quite: Solumns will give you evil combinations of colours."])

; Panel for legal and tech info
(define tech-panel
  (new vertical-panel%
       [parent win]
       [alignment '(center bottom)]))

(new button%
     [parent tech-panel]
     [label "Visit http://killersmurf.com for more fun stuff."]
     [callback
       (lambda (me evt)
	 (send-url "http://killersmurf.com"))])

(new message%
     [parent tech-panel]
     [label "This is an alpha release of solumns."])

(new message%
     [parent tech-panel]
     [label "Your Mileage May Vary"])

(new message%
     [parent tech-panel]
     [label "Report bugs to spoon@killersmurf.com"])

(new message%
     [parent tech-panel]
     [label "Copyright 2011 John Morrice"])

(new button%
     [parent intro-panel]
     [min-width 100]
     [min-height 80]
     [vert-margin 30]
     [label "Play"]
     [callback (lambda (me evt)
		 (send win delete-child intro-panel)
		 (send win delete-child tech-panel)
		 (create-gui))])

(send win show #t)
