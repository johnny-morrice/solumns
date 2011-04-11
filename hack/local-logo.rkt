#lang racket

; This is a hack.  Before compile time, we copy one of the possible files in this location into logo-dir.rkt.

(provide logo-path)

(define logo-path "data/logo.png")
