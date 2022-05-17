;;;; einsum.asd

(asdf:defsystem #:einsum
  :description "Provides macro for using Einstein Summation Notation with arrays"
  :author "Bibek Panthi <bpanthi977@gmail.com>"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :components ((:file "package")
               (:file "einsum")))
