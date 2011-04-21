#lang racket/gui

; Copyright 2011 John Morrice
;
; This file is part of Solumns. 
;
; Solumns is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; Foobar is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with Solumns.  If not, see <http://www.gnu.org/licenses/>.

(require "gui/pauser-panel.rkt"
	 "gui/grid-fader.rkt"
	 "gui/fader-canvas.rkt"
	 "gui/pauser-score-panel.rkt"
	 "gui/controllers/pauser.rkt"
	 "gui/pause-status.rkt"
	 "gui/high-scores.rkt"
	 "gui/high-score-viewer.rkt"
	 "cgrid.rkt"
	 "colgorithms/rotator.rkt"
	 "util.rkt"
	 "logo-dir.rkt"
	 net/sendurl)

; This file needs sorting out... too many different concerns in here.
; E.g. geometry management should be kept separate from game instructions.

(define win-width 400)
(define win-height 600)

(call-with-values get-display-size
		  (lambda (sw sh)
		    (set! win-height (round-exact (* 0.8 sh)))
		    (set! win-width (round-exact (* 0.8 win-height)))))

; The solumns logo
(define logo
  (make-object bitmap% (build-path logo-dir "logo.png") 'png))

; The little solumns window icon
(define frame-icon
  (make-object bitmap% (build-path logo-dir "solumns-frame-icon.png")))

; The window takes up most of the screen.
(define win
  (new frame%
       [label "Solumns :("]
       [width win-width]
       [height win-height]))

; Set the icon
(send win set-icon frame-icon)

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
    (new cgrid%
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
	 [parent hoz]
	 [alignment '(left center)]
	 [min-width 150]
	 [stretchable-width #f]))

  (define restarter 
    (new pauser-controller%
	 [pause-status pause]
	 [game-delay 0.03]
	 [acceleration 0.0001]
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

; The left of an object to be drawn in the centre of the window
(define (my-left width)
  (let [(middle (/ win-width 2))]
    (- middle (/ width 2))))

; Set up the intro screen
(define (create-intro)

  ; Panel to hold the intro stuff
  (define intro-panel
    (new vertical-panel%
	 [parent win]
	 [alignment '(center center)]))

  ; Show the logo
  (new canvas%
       [parent intro-panel]
       [style '(transparent)]
       [min-width win-width]
       [min-height 158]
       [stretchable-width #f]
       [stretchable-height #f]
       [paint-callback (lambda (me dc)
			 (let [(ellipse-width 228)]
			   (send dc set-brush "white" 'opaque)
			   (send dc draw-ellipse (my-left ellipse-width) 0 ellipse-width 158)
			   (send dc draw-bitmap logo (my-left 128) 15)))])

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
       [label "Not quite: most of the time, Solumns will give you evil combinations of colours."])

  ; Panel for legal and tech info
  (define tech-panel
    (new vertical-panel%
	 [parent win]
	 [alignment '(center bottom)]))

  (new message%
       [parent tech-panel]
       [label "Solumns is Copyright 2011 John Morrice"])

  (new message%
       [parent tech-panel]
       [label "This is an alpha release of solumns."])

  (new message%
       [parent tech-panel]
       [label "Your Mileage May Vary"])

  (new message%
       [parent tech-panel]
       [label "Report bugs to spoon@killersmurf.com"])

  (new button%
       [parent tech-panel]
       [label "Visit Killersmurf.com for more fun stuff"]
       [callback
	 (lambda (me evt)
	   (send-url "http://killersmurf.com"))])

  (new button%
       [parent tech-panel]
       [label "Solumns logo by Maddy Norval of Magweno.com"]
       [callback
	 (lambda (me evt)
	   (send-url "http://magweno.com/"))])

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

  (new button%
       [parent intro-panel]
       [label "View High Scores"]
       [callback
	 (lambda (me evt)
	   (let* [(score-win (new frame% [label "Solumns Hall of Fame"]))
		  (announce (new message%
				 [parent score-win]
				 [label "Champions of Solumns"]))
		  (high-score-panel (new high-score-viewer%
					 [parent score-win]
					 [scores (top-ten (get-high-scores))]))]
	     (send high-score-panel display-scores)
	     (send score-win set-icon frame-icon)
	     (send score-win show #t)))])

  (send win show #t))

(create-intro)
