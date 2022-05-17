# einsum

`einsum` macro provides [Einstein Summation Notation](https://en.wikipedia.org/wiki/Einstein_notation) to coveniently work with multi-dimensional arrays in Common Lisp.

# Examples
## Transpose
```lisp
(defun transpose (matrix)
  (destructuring-bind (m n) (array-dimensions matrix)
	(let ((new-matrix (make-array (list n m))))
	  (loop for i from 0 below m do
	(loop for j from 0 below n do
	  (setf (aref new-matrix j i)
		(aref matrix i j))))
	  new-matrix)))

(transpose M)
```
Equivalent einsum expression
```lisp
  (einsum (ij :to ji) (ij M))
```

## Outer Product
```lisp
 (defun incf-outer-product (place vec-a vec-b)
	"Add the outer product of `vec-a' and `vec-b' into `place'"
	(let ((n (array-dimension place 0))
	  (m (array-dimension place 1)))
	  (assert (= n (length vec-a)))
	  (assert (= m (length vec-b)))
	  (loop for i from 0 below n do
	(loop for j from 0 below m do
	  (incf (aref place i j)
		(* (aref vec-a i)
		   (aref vec-b j)))))
	  place))

  ;; M^i_j += U^i V_j
  (let ((M (make-array '(2 3) :initial-contents '((1 2 3) (4 5 6)))))
	(incf-outer-product M U V))
```

Equivalent einsum expression:

```lisp
 (let ((M (make-array '(2 3) :initial-contents '((1 2 3) (4 5 6)))))
	(einsum (ij :to ij) :into M
		(+ (ij M) (* (i U) (j V)))))
```

This einsum expression is macro-expanded into equivalent lisp code:

```lisp
(LET ((#:|I-max730| (ARRAY-DIMENSION U 0)) (#:|J-max731| (ARRAY-DIMENSION V 0)))
  (ASSERT (= (ARRAY-DIMENSION U 0) (ARRAY-DIMENSION M 0)))
  (ASSERT (= (ARRAY-DIMENSION V 0) (ARRAY-DIMENSION M 1)))
  (LET ()
	(LOOP FOR #:I732 FROM 0 BELOW #:|I-max730|
		  DO (LOOP FOR #:J733 FROM 0 BELOW #:|J-max731|
				   FOR #:|const-expr-734| = (+ (AREF M #:I732 #:J733)
											   (* (AREF U #:I732)
												  (AREF V #:J733)))
				   DO (SETF (AREF M #:I732 #:J733) #:|const-expr-734|)))
	M))
```

## Transpose then dot
```lisp
(defun matrix-T-dot-vector (matrix vector)
  "Multiply transpose of `matrix' with `vector'"
  (destructuring-bind (m n) (array-dimensions matrix)
	(assert (= m (length vector)))
	(let ((result (make-array n)))
	  (loop for j from 0 below n do
	(setf (aref result j)
		  (loop for i from 0 below m
			summing (* (aref matrix i j)
					   (aref vector i)))))
	  result)))

(matrix-T-dot-vector M U)
```

Equivalent einsum expression:
```lisp
(einsum (ij :to j)
	(ij M) (i U))
```

See [this page](https://bpanthi.com.np/programming/einstein.html) for more details on how `einsum` works.
## License

MIT License
