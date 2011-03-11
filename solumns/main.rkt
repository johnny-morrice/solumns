#lang gracket

(require "gui.rkt"
	 "matrix.rkt")

; Entry point for solumns!

; Load the colgorithms
(define plugins
  (for [(path (directory-list "solumns/colgorithms"))]
     (dynamic-require (build-path "solumns" path) "colgorithm")))

; Create a GUI
(define gui
  (make-object solumns-gui plugins]))

; Run the GUI
(send gui run) 
