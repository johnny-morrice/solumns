#lang racket

(provide dropper
	 dropper?
	 dropper-x
	 dropper-y
	 dropper-col
	 set-dropper-x!
	 set-dropper-y!
	 set-dropper-col!)


; Struct representing the dropping column
(struct dropper (x y col) #:mutable)
