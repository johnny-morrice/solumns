#lang racket 

(require "../grid.rkt"
	 "brute-force.rkt"
	 srfi/1)

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

; This is too easy!  Much easier than brute-force!
; But this file shall be kept for the purposes of tinkering.

(provide acyclic-brute-force% remove-known)

; Return a list of candidates, those we don't know!
(define (remove-known memory candidates)
  (filter (lambda (cnd)
	    (not (ormap (lambda (rot)
			  (member rot memory))
			(three-cycle (car cnd)))))
	  candidates))

; A brute-force algorithm that detects and prevents cycles of columns.
(define acyclic-brute-force%
  (class brute-force%
	 (super-new)

	 (override candidates next-evil-candidate)

	 (field [memory '()])

	 ; Remove cycles from the top of the candidates list
	 (define (candidates gr)
	   (remove-known memory (super candidates gr)))

	 ; Add the chosen candidate to the memory.
	 ; Ensure the memory is not longer than 10.
	 (define (next-evil-candidate cnds)
	   (printf "memory:\n")
	   (for-each (lambda (mem)
		       (printf "  ~a\n" mem))
		     memory)
	   (let* [(cnd (super next-evil-candidate cnds))
		  (new-memory (cons (car cnd) memory))
		  (memory-length (expt (get-field colours this) 2))
		  (chopped-memory
		    (if (> (length new-memory) memory-length)
		      (take new-memory memory-length)
		      new-memory))]
	     (printf "chosen: ~a\n\n" (car cnd))
	     (set! memory chopped-memory)
	     cnd))))
