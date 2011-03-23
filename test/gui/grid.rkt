#lang racket/gui

(require "../../solumns/gui/grid.rkt"
	 "../../solumns/gui/colour-mapping.rkt"
	 "../../solumns/grid.rkt")

; Test that the GUI provides a proper representation of the grid.

; Create a grid
(define gr
  (new grid% [width 3] [height 5]))

(send gr matrix-set! 0 0 0)
(send gr matrix-set! 0 1 1)
(send gr matrix-set! 0 2 2)
(send gr matrix-set! 1 0 3)
(send gr matrix-set! 1 1 4)
(send gr matrix-set! 2 0 5)

; Create a window
(define win
  (new frame%
       [label "Solumns Grid Representation"]
       [min-width 400]
       [min-height 800]))

(send win show #t)

; Put a message on the window
(new message% 
     [parent win]
     [label "The two images below should look alike."])

; Create a horizontal panel, to display the images side by side
(define hoz
  (new horizontal-panel%
       [parent win]
       [spacing 1]))

; Create the GUI grid
(define screen-grid
  (new gui-grid%
       [parent hoz]
       [grid gr]))

(send screen-grid add-column 2 2 '#(6 2 4))

(define canv
  (new canvas% [parent hoz]))

(sleep/yield 1)

(send screen-grid update)

(send (send canv get-dc)
     draw-bitmap (make-object bitmap% "test/img/layout.png" 'png) 0 0)
