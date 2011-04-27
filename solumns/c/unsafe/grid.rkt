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

; This API may look a bit convoluted, bit the hope is
; that by not boxing C pointers into Racket vectors
; that memory errors can be avoided

(provide unsafe-eliminate
	 unsafe-new-matrix
	 unsafe-free-matrix
	 unsafe-get-column
	 unsafe-read-colour
	 unsafe-write-colour)

(define eliminator-path
  (let [(local-lib "lib/solumns/elimination")]
    (if (or (file-exists? (string-append local-lib ".so"))
	    (file-exists? (string-append local-lib ".dll")))
      local-lib
      (build-path (path-only (find-system-path 'run-file)) ".." local-lib))))

; The shared object providing the elimination-step function
(define eliminator-lib
  (ffi-lib eliminator-path))

; The elimination-step function
(define unsafe-eliminate
  (get-ffi-obj "elimination_step"
	       eliminator-lib
	       (_fun _uint8
		     _uint8
		     _pointer
		     -> _pointer)))

; Free a cmatrix, given its width
(define unsafe-free-matrix
  (get-ffi-obj "free_matrix"
	       eliminator-lib
	       (_fun _uint8
		     _pointer
		     -> _void)))

; Create a new matrix given width and height
(define unsafe-new-matrix
  (get-ffi-obj "new_matrix"
	       eliminator-lib
	       (_fun _uint8
		     _uint8
		     -> _pointer)))

; Write a colour to a column
(define (unsafe-write-colour col y val)
    (ptr-set! col _uint8 y val))

; Get a colour from a column
(define (unsafe-read-colour col y)
    (ptr-ref col _uint8 y))

; Get a column from the matrix
(define (unsafe-get-column matrix x)
  (ptr-ref matrix _pointer x))
