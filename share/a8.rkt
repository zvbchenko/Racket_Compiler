#lang racket

(require
 racket/set
 racket/format
 "a8-charlie.rkt"
 "a8-bosco.rkt"
 "a8-anton.rkt"
 "a8-graph-lib.rkt"
 "a8-compiler-lib.rkt"
 "a7.rkt"
 )

(provide
;  a-normalize
 select-instructions
 expose-allocation-pointer
 uncover-locals
 undead-analysis
 conflict-analysis
 pre-assign-frame-variables
 assign-frames
 assign-registers
 assign-frame-variables
 discard-call-live
 replace-locations
 implement-fvars
 expose-basic-blocks
 flatten-program
 patch-instructions
 implement-mops
 generate-x64)
