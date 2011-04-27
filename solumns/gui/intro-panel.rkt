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

(require "logo-dir.rkt"
	 "high-scores.rkt"
	 "high-score-viewer.rkt"
	 "frame.rkt"
	 net/sendurl)

; Provide intro panel
(provide create-intro)

; The solumns logo
(define logo
  (make-object bitmap% (build-path logo-dir "logo.png") 'png))

; The left of an object to be drawn in the centre of the window
(define (my-left width win)
  (let [(middle (/ (send win get-width) 2))]
    (- middle (/ width 2))))

; Set up the intro screen
(define (create-intro win create-gui)

  ; Panel to hold the intro stuff
  (define intro-panel
    (new vertical-panel%
	 [parent win]
	 [alignment '(center center)]))

  ; Show the logo
  (new canvas%
       [parent intro-panel]
       [style '(transparent)]
       [min-width (send win get-width)]
       [min-height 158]
       [stretchable-width #f]
       [stretchable-height #f]
       [paint-callback (lambda (me dc)
			 (let [(ellipse-width 228)]
			   (send dc set-brush "white" 'opaque)
			   (send dc draw-ellipse (my-left ellipse-width win) 0 ellipse-width 156)
			   (send dc draw-bitmap logo (my-left 128 win) 15)))])

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
       [label "Most of the time, Solumns will give you evil combinations of colours."])

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
       [label "This is an beta release."])

  (new message%
       [parent tech-panel]
       [label "You may find it lumpy."])

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
	   (let* [(score-win (new solumns-frame% [label "Solumns Hall of Fame"]))
		  (announce (new message%
				 [parent score-win]
				 [label "Champions of Solumns"]))
		  (high-score-panel (new high-score-viewer%
					 [parent score-win]
					 [scores (top-ten (get-high-scores))]))]
	     (send high-score-panel display-scores)
	     (send score-win show #t)))]))

