#lang racket

; Test that all the colour mappings are valid.

(require "../../solumns/gui/colour-mapping.rkt"
	 rackunit)

(test-case "All colour names are valid."
	   (for [(n (in-hash-keys colour-table))]
		(to-colour n)))
