#lang racket

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

(require "../pause-status.rkt"
	 "shuffler.rkt")

(provide pauser-controller%)

; Controller that doesn't run when it's paused.
(define/contract pauser-controller%
		 (class/c (init-field [pause-status (is-a?/c pause-status%)]))
		 (class shuffler-controller%
			(super-new)

			(init-field pause-status)

			(override step left-press right-press up-press down-press down-release)

			(define (unless-paused f)
			  (unless (send pause-status paused?)
			    (f)))

			(define (left-press)
			  (unless-paused
			    (lambda ()
			      (super left-press))))

			(define (right-press)
			  (unless-paused
			    (lambda ()
			      (super right-press))))

			(define (up-press)
			  (unless-paused
			    (lambda ()
			      (super up-press))))

			(define (down-press)
			  (unless-paused
			    (lambda ()
			      (super down-press))))

			(define (down-release)
			  (unless-paused
			    (lambda ()
			      (super down-release))))

			(define (step)
			  (unless-paused
			    (lambda ()
			      (super step))))))
