---
title: "Common performance optimizations"
teaching: 15
exercises: 15
questions:
- "What are some easy ways of speeding up my code?"
objectives:
- "Be aware of common performance optimizations."
keypoints:
- "Use pre-existing libraries wherever you can."
- "Numba's JIT is an easy way to optimize."
---

We'll quickly cover a number of common performance optimizations in Python.
Most of these things deal with heavy-duty number crunching, 
and not all have examples.

## Use optimized libraries like Numpy wherever possible

Libraries like Numpy and Pandas are filled with lots of hyper-optimized C/C++/Fortran code.
Using these libraries will almost always be faster than using pure Python equivalents:

```python
%%timeit
array = np.arange(1000000)
array = array ** 2 
```
```
100 loops, best of 3: 4.62 ms per loop
```
{: .output}

```python
%%timeit
slow = range(1000000)
slow = list(map(lambda x: x ** 2, slow))
```

```
1 loop, best of 3: 589 ms per loop
```
{: .output}

## Hard-disk no-nos

Writing to the hard disk will always be slower than 
writing objects to memory. 
There are no exceptions.

Also, wherever possible, one big write to disk will always 
be faster than lots of little writes to disk.

## numba and JIT-compiled code

`numba` is a JIT compiler for Python.
A JIT compiler is a special type of compiler that compiles 
normally slow code from an interpreted language like Python
into ultra-fast machine code for your CPU right before it runs.

Using `numba` is rather easy - first we import it:

```python
from numba import jit
```

Then we place the `@jit` decorator above any functions we want to be compiled (I modified this bubble sort implementation from the [numba documentation](numba.pydata.org/numba-doc/0.12.2/tutorial_firststeps.html)):

```python
def bubblesort(Y):
	X = Y.copy()
    N = len(X)
    for end in range(N, 1, -1):
        for i in range(end - 1):
            cur = X[i]
            if cur > X[i + 1]:
                tmp = X[i]
                X[i] = X[i + 1]
                X[i + 1] = tmp
	return X


@jit
def bubblesort_jit(Y):
	X = Y.copy()
    N = len(X)
    for end in range(N, 1, -1):
        for i in range(end - 1):
            cur = X[i]
            if cur > X[i + 1]:
                tmp = X[i]
                X[i] = X[i + 1]
                X[i + 1] = tmp
	return X

randomized = np.arange(1000)
np.random.shuffle(randomized)
```

Now lets see the performance difference between the two versions:

```python
%timeit bubblesort(randomized)
```

```
1 loop, best of 3: 313 ms per loop
```
{: .output}

```python
%timeit bubblesort_jit(randomized)
```
```
1000 loops, best of 3: 1.52 ms per loop
```
{: .output}

The `@jit` version was considerably faster.
Are there any drawbacks to using Numba?
Why not just use it all the time?

Numba is specifically good at array and math-heavy Python code. 
You won't see too much of a benefit when doing other types of operations.
For more info and troubleshooting information, 
check out the Numba documentation at [http://numba.pydata.org/numba-doc/latest/index.html](http://numba.pydata.org/numba-doc/latest/index.html)

