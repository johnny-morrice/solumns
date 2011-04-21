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
;
(require ffi/unsafe)

(provide unsafe-eliminator)

(define eliminator-path
  (let [(local-lib "lib/elimination")]
    (if (file-exists? (string-append local-lib ".so"))
      local-lib
      (build-path (find-system-path 'run-file) "../lib/elimination"))))

; The shared object providing the elimination-step function
(define eliminator-lib
  (ffi-lib eliminator-path))

; The elimination-step function
(define (unsafe-eliminator width height)
  (get-ffi-obj "elimination_step"
	       eliminator-lib
	       (_fun _uint8
		     _uint8
		     (r : (_vector io (_vector io _uint8 height) width))
		     (g : (_vector io (_vector io _uint8 height) width))
		     ->
		     _void
		     ->
		     (values r g))))
