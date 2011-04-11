#lang racket/gui

(require "../../solumns/gui/panel.rkt")

(define printer%
  (class object%
	 (super-new)

	 (define/public (start)
			(displayln "started"))

	 (define/public (left-press)
			(displayln "user pressed left"))

	 (define/public (right-press)
			(displayln "user pressed right"))

	 (define/public (up-press)
			(displayln "user pressed up"))

	 (define/public (down-press)
			(displayln "user pressed down"))

	 (define/public (down-release)
			(displayln "user released down"))

	 (define/public (stop)
			(displayln "stopped"))))

(define printer
  (new printer%))

(define win
  (new frame%
       [label "Solumns Input Test"]
       [width 600]
       [height 600]))


(define game-view
  (new solumns-panel%
       [parent win]))

(send game-view controller-is printer)

(new button%
     [parent game-view]
     [label "Start"]
     [callback (lambda (me evt)
		 (send printer start))])

(new button%
     [parent game-view]
     [label "Stop"]
     [callback (lambda (me evt)
		 (send printer stop))])

(send win show #t)
