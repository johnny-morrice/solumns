#lang racket

; This file contains some helpful functions which are used in a couple of places here

(provide/contract
  [round-exact (-> real?
		   (and/c integer? exact?))])

; Takes a number, rounds it to nearest exact integer
(define (round-exact n)
  (inexact->exact (round n)))
