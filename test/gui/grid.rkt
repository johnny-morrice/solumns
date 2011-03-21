#lang gracket

(require "../solumns/gui/grid.rkt"
	 "../solumns/gui/colour-mapping.rkt"
	 "../solumns/grid.rkt")

; Test that the GUI provides a proper representation of the grid.

; Create a grid
(define gr
  (new grid% [width 3] [height 3]))

(send gr matrix-set! 0 0 0)
(send gr matrix-set! 0 1 1)
(send gr matrix-set! 0 2 2)
(send gr matrix-set! 1 0 3)
(send gr matrix-set! 1 1 4)
(send gr matrix-set! 2 0 5)
(send gr matrix-set! 2 2 6)

; Create a window
(define win
  (new frame% [title "Solumns Grid Representation"]))

; Put a message on the window
(new message% 
     [parent win]
     [label "The two images below should look alike."])

; Create a horizontal panel, to display the images side by side
(define hoz
  (new horizontal-panel% [parent win]))

; Create the GUI grid
(define (screen-grid)
  (new gui-grid%
       [parent hoz]
       [grid gr]))

(send screen-grid update)

(new message%
     [parent hoz]
     [label "and"])

(define bitmap-holder
  (new panel% [parent hoz]))

(define canv
  (new canvas% [parent panel%]))

(send (get-dc canv)
      draw-bitmap 0 0 (make-object bitmap "test/img/layout.png"))

(send win show #t)
