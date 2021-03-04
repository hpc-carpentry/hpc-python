---
title: "Numpy arrays and lists"
teaching: 15
exercises: 15
questions:
- "How do we store large amounts of data?"
objectives:
- "Learn to use lists and Numpy arrays,
  and explain the difference between each."
keypoints:
- "Lists store a sequence of elements."
- "Numpy allows vector maths in Python."
---

At the end of the last lesson, we noticed that `sys.argv` gave us a new data
structure: a list.
A list is a set of objects enclosed by a set of square brackets (`[]`).

```
example = [1, 2, 4, 5]
example
```
{: .language-python}
```
[1, 2, 4, 5]
```
{: .output}

Note that a list can hold any type of item, even other lists!

```
example = [1, True, None, ["word", 123], "test"]
example
```
{: .language-python}
```
[1, True, None, ['word', 123], 'test']
```
{: .output}

We can get different pieces of a list via indexing.
We add a set of square brackets after the list in question along with the index
of the values we want.
Note that in Python, all indices start from 0 &mdash; the first element is
actually the 0th element (this is different from languages like R or MATLAB).
The best way to think about array indices is that they are the number of
offsets from the first position &mdash; the first element does not require an
offset to get to.

{% include figure.html url="" max-width="50%"
   file="https://imgs.xkcd.com/comics/donald_knuth.png"
   alt="Arrays start at 0"
   caption="<i>Source:</i> <a href='https://xkcd.com/163/'>xkcd #163</a>" %}

A few examples of this in action:

```
# first element
example[0]
# second element
example[1]
# fetch the list inside the list
example[3]
```
{: .language-python}
```
1
True
['word', 123]
```
{: .output}

Note that we can index a range using the colon (`:`) operator.
A colon by itself means fetch everything.

```
example[:]
```
{: .language-python}
```
[1, True, None, ['word', 123], 'test']
```
{: .output}

A colon on the right side of an index means everything after the specified
index.

```
example[2:]
```
{: .language-python}
```
[None, ['word', 123], 'test']
```
{: .output}

A colon on the left side of an index means everything before, but not
including, the index.

```
example[:2]
```
{: .language-python}
```
[1, True]
```
{: .output}

And if we use a negative index, it means get elements from the end,
going backwards.

```
# last element
example[-1]
# everything except the last two elements
example[:-2]
```
{: .language-python}
```
'test'
[1, True, None]
```
{: .output}

Note that we can use the index multiple times to retrieve information from
nested objects.

```
example[3][0]
```
{: .language-python}
```
'word'
```
{: .output}

If we index out of range, it is an error:

```
example[5]
```
{: .language-python}
```
---------------------------------------------------------------------------
IndexError                                Traceback (most recent call last)
<ipython-input-12-98429cb6526b> in <module>()
----> 1 example[5]

IndexError: list index out of range
```
{: .error}

We can also add two lists together to create a larger list.

```
[45, 2] + [3]
```
{: .language-python}
```
[45, 2, 3]
```
{: .output}

## Lists as objects

Like other objects in Python, lists have a unique behaviour that can catch a
lot of people off guard. What happens when we run the following code?

```
list1 = [1, 2, 3, 4]
list2 = list1
list2 += [5, 6, 7]
print('List 2 is: ', list2)
print('List 1 is: ', list1)
```
{: .language-python}
```
List 2 is:  [1, 2, 3, 4, 5, 6, 7]
List 1 is:  [1, 2, 3, 4, 5, 6, 7]
```
{: .output}

Modifying `list2` actually modified `list1` as well.
In Python, lists are objects.
Objects are not copied when we assign them to a new value (like in R).
This is an important optimisation, as we won't accidentally fill up all of our
computer's memory by renaming a variable a couple of times.
When we ran `list2 = list1`, it just created a new name for `list1`.
`list1` still points at the same underlying object.

We can verify this with the `id()` function.
`id()` prints an objects unique identifier.
Two objects will not have the same ID unless they are the same object.

```
id(list1)
id(list2)
```
{: .language-python}
```
140319556870408
140319556870408
```
{: .output}

In order to create `list2` as a unique copy of `list1`.
We have to use the `.copy()` method.

```
list1 = [1, 2, 3, 4]
list2 = list1.copy()
list2 += [5, 6, 7]
print('List 2 is: ', list2)
print('List 1 is: ', list1)
id(list2)
id(list1)
```
{: .language-python}
```
List 2 is:  [1, 2, 3, 4, 5, 6, 7]
List 1 is:  [1, 2, 3, 4]
140319554648072
140319554461896
```
{: .output}

`.copy()` is a method.
Methods are special functions associated with an object and define what it can
do.
They always follow the syntax `object.method(arg1, arg2)` and have predefined
number of arguments mostly with default values. We may also specify a subset of
arguments, e.g. `object.method(arg1, arg4=some_value)`.

Other frequently used methods of lists include `.append()`:

```
list1.append(77)
```
{: .language-python}
```
[1, 2, 3, 4, 77]
```
{: .output}

```
# this adds a one-element list
list1.append([88])
```
{: .language-python}
```
[1, 2, 3, 4, 77, [88]]
```
{: .output}

And `.extend()` (combines two lists, instead of adding the second list as an
element):

```
list1.extend([99, 88, 101])
```
{: .language-python}
```
[1, 2, 3, 4, 77, [88], 99, 88, 101]
```
{: .output}

And of course, `.remove()` and `.clear()` (both do exactly what you think they
should do):

```
list1.remove([88])
print(list1)
list1.clear()
print(list1)
```
{: .language-python}
```
[1, 2, 3, 4, 77, 99, 88, 101]
[]
```
{: .output}

> ## Dynamic resizing of lists
>
> Python's lists are an extremely optimised data structure.
> Unlike R's vectors, there is no time penalty to continuously adding elements
> to list.
> You never need to pre-allocate a list at a certain size for performance
> reasons.
{: .callout}

## Iterating through lists

We'll very frequently want to iterate over lists and perform an operation with
every element.
We do this using a for loop.

A for loop generally looks like the following:

```
for variable in things_to_iterate_over:
    do_stuff_with(variable)
```
{: .language-python}

An example of an actually functioning for loop is shown below:

```
for i in range(10):
    print(i)
```
{: .language-python}
```
0
1
2
3
4
5
6
7
8
9
```
{: .output}

In this case we are iterating over the values provided by `range()`.
`range()` is a special generator function we can use to provide
a sequence of numbers.

We can also iterate over a list, or any collection of elements:

```
for element in ['a', True, None]:
    print(type(element))
```
{: .language-python}
```
<class 'str'>
<class 'bool'>
<class 'NoneType'>
```
{: .output}

## Vectorised operations with Numpy

Numpy is a numerical library designed to make working with numbers
easier than it would otherwise be.

For example, say we had a list of a thousand numbers.
There's no way to do vector maths without iterating through all the
elements!

```
vals = list(range(1000))

new_vals = vals.copy()
print(new_vals[:5])
for idx in range(1000):
    new_vals[idx] += 10

print(new_vals[:5])
```
{: .language-python}
```
[0, 1, 2, 3, 4]
[10, 11, 12, 13, 14]
```
{: .output}

That was a lot of work.
Numpy lets us do vector maths like in R, saving us a lot of effort.
The most basic function is `np.array()` which creates a numerical
array from a list.
A numpy array is a collection of numbers that can have any number of
dimensions.
In this case, there is only one dimension, since we created the array from a
list.

```
import numpy as np

new_vals = np.array(vals)
new_vals += 10
new_vals[:5]
```
{: .language-python}
```
array([10, 11, 12, 13, 14])
```
{: .output}

One very nice thing about Numpy is that it's much more performant than ordinary
Python lists.
A nice trick we can use with IPython to measure execution times is the
`%timeit` magic function.
Anything following the `%timeit` gets measured for speed.
Adding `%%` to the `timeit` command instead of `%` means that `timeit` is run
on the entire cell, not just a single line. Note that `%%timeit` must be on the
first line of an IPython/Jupyter cell for it to work, whereas the `%timeit`
command can be used anywhere.

Using Python's lists:

```
%%timeit
for idx in range(1000):
    vals[idx] + 10
```
{: .language-python}
```
10000 loops, best of 3: 165 µs per loop
```
{: .output}

Using numpy:

```
%timeit new_vals + 10
```
{: .language-python}
```
The slowest run took 22.13 times longer than the fastest.
This could mean that an intermediate result is being cached.
1000000 loops, best of 3: 1.63 µs per loop
```
{: .output}

Numpy was about 100x faster, though `%timeit` did mention that Numpy could be
cheating a bit.
Even in Numpy's worst case scenario however, it still ran 5x faster than using
Python's basic lists.

## Working with multiple dimensions

Sometimes, you'll encounter a dataset with multiple dimensions and will need to
be able to retrieve elements from it as such.

```
arr2d = np.arange(0, 40)  # sequence of numbers from 0 to 39
arr2d = arr2d.reshape([5, 8])  # reshape so it has 5 rows and 8 columns
arr2d
```
{: .language-python}
```
array([[ 0,  1,  2,  3,  4,  5,  6,  7],
       [ 8,  9, 10, 11, 12, 13, 14, 15],
       [16, 17, 18, 19, 20, 21, 22, 23],
       [24, 25, 26, 27, 28, 29, 30, 31],
       [32, 33, 34, 35, 36, 37, 38, 39]])
```
{: .output}

In this case, we must index using multiple indices, separated by a comma.

To grab the first element, we would use `[0, 0]`

```
arr2d[0, 0]
```
{: .language-python}
```
0
```
{: .output}

The first index, corresponds to rows, the second corresponds to columns,
and the third to the next dimension...

```
arr2d[0, :]
arr2d[:, 0]
```
{: .language-python}
```
array([0, 1, 2, 3, 4, 5, 6, 7])
array([ 0,  8, 16, 24, 32])
```
{: .output}

> ## Practising indexing
>
> Retrieve everything defined in the range of
> rows 4-5 and columns 1-4.
{: .challenge}
