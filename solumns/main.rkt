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
	 "cgrid.rkt"
	 "colgorithms/rotator.rkt"
	 "util.rkt"
	 "gui/frame.rkt"
	 "gui/intro-panel.rkt")

; This file creates the window and starts the main game loop

(define win-width 400)
(define win-height 600)

(call-with-values get-display-size
		  (lambda (sw sh)
		    (set! win-height (round-exact (* 0.8 sh)))
		    (set! win-width (round-exact (* 0.8 win-height)))))

; The window takes up most of the screen.
(define win
  (new solumns-frame%
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
	 [min-width win-width]
	 [min-height win-height]
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

(create-intro win create-gui)
(send win show #t)
