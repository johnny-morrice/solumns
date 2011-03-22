#lang racket/gui

(require "../../solumns/gui/frame.rkt")

(define printer%
  (class object%
	 (super-new)

	 (define/public (start)
			(displayln "started"))

	 (define/public (refresh)
			(displayln "refreshed"))

	 (define/public (left)
			(displayln "user pressed left"))

	 (define/public (right)
			(displayln "user pressed right"))

	 (define/public (up)
			(displayln "user pressed up"))

	 (define/public (down)
			(displayln "user pressed down"))

	 (define/public (stop)
			(displayln "stopped"))))

(define printer
  (new printer%))


(define win
  (new solumns-frame%
       [label "Solumns Test Frame"]
       [controller printer]))

(new button%
     [parent win]
     [label "Start"]
     [callback (lambda (me evt)
		 (send printer start))])

(new button%
     [parent win]
     [label "Stop"]
     [callback (lambda (me evt)
		 (send printer stop))])

(send win show #t)
