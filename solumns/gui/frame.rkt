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

(require "logo-dir.rkt")

(provide solumns-frame%)

; The little solumns window icon
(define frame-icon
  (make-object bitmap% (build-path logo-dir "solumns-frame-icon.png")))

; Frame with solumns icon
(define solumns-frame%
  (class frame%
	 (super-new)

	 (send this set-icon frame-icon)))


