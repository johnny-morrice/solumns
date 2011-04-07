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

(provide controller-class/c
	 controller/c)

; A controller responds to user and other input
(define-syntax-rule (controller-contract contract) 
  (contract [up-press (->m any)]
	    [down-press (->m any)]
	    [down-release (->m any)]
	    [left-press (->m any)]
	    [right-press (->m any)]
	    [start (->m any)]
	    [stop (->m any)]))

; Recognise a controller class
(define controller-class/c
  (controller-contract class/c))

; Recognise a controller object
(define controller/c
  (controller-contract object/c))
