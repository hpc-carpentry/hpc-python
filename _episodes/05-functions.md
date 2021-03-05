---
title: "Functions and Conditions"
teaching: 15
exercises: 15
questions:
- "How do I write functions?"
objectives:
- "Be able to write our own functions and use basic functional programming
  constructs like `map()` and `filter()`."
keypoints:
- "`map()` applies a function to every object in a data structure."
- "`filter()` returns only the data objects for which some condition is true."
---

Of course, at some point, we are going to want to define our own functions
rather than just use the ones provided by Python and its various modules.

The general syntax for defining a function is as follows:

```
def function(arg1):
    # do stuff with arg1
    return answer
```
{: .language-python}

So, an example function that adds two numbers together might look a little like
this:

```
def adder(x, y):
    return x + y

adder(1, 2)
```
{: .language-python}
```
3
```
{: .output}

We can also add a default argument
(say if we wanted y to be equal to 10 unless we otherwise specified),
by using an equals sign and a default value in our function definition:

```
def adder(x, y=10):
    return x + y

adder(5)
```
{: .language-python}
```
15
```
{: .output}

> ## Practice defining functions
>
> Define a function that converts from temperatures in Fahrenheit
> to temperatures in Kelvin, and another function that converts
> back again.
> 
> The general formula for the conversion from Fahrenheit to Kelvin is:
> 
> `kelvin = (fahr - 32) * 5 / 9 + 273.15`
{: .challenge}

## Conditional statements

We may also need to have our functions do specific things in some conditions,
but not in others.
This relies upon comparisons between items:

In python, comparison is done using the `==` operator:

```
True == True
True == False
'words' == 'words'
```
{: .language-python}
```
True
False
True
```
{: .output}

`not` indicates the opposite of True or False, and `!=` means not equal to.

```
not True == False
True != False
```
{: .language-python}
```
True
True
```
{: .output}

As with other programming languages, we can make the usual comparisons with the
`>` and `<` operators.
Adding an equals sign (`>=`, `<=`) indicates less than or equal to or greater
than or equal to.

```
5 < 10
5 > 10
-4 >= -4
1 <= 2
```
{: .language-python}
```
True
False
True
True
```
{: .output}

These statements can be combined with the `if` statement to produce code that
executes at various times.

```
number = 5
if number <= 10:
    print('number was less than 10')
```
{: .language-python}
```
number was less than 10
```
{: .output}

If the `if` statement is not equal to `True`,
the statement does not execute:

```
number = 11
if number <= 10:
    print('number was less than 10')
```
{: .language-python}

However, we can add code to execute when the `if` condition is not met by
adding an `else` statement.

```
number = 11
if number <= 10:
    print('number was less than 10')
else:
    print('number was greater than 10')
```
{: .language-python}
```
number was greater than 10
```
{: .output}

And if we want to check an additional statement,
we can use the `elif` keyword (else-if):

```
number = 10
if number < 10:
    print('number was less than 10')
elif number == 10:
    print('number was equal to 10')
else:
    print('number was greater than 10')
```
{: .language-python}

One final note, to check if a value is equal to `None` in Python
we must use `is None` and `is not None`.
Normal `==` operators will not work.

```
None is None
5 is not None
```
{: .language-python}
```
True
True
```
{: .output}

Additionally, we can check if one value is in another set of values with the
`in` operator:

```
5 in [4, 5, 6]
43 in [4, 5, 6]
```
{: .language-python}
```
True
False
```
{: .output}

## map(), filter(), and anonymous (lambda) functions

Python has good support for functional programming,
and has its own equivalents for map/reduce-style functionality.
To "map" a function means to apply it to a set of elements.
To "reduce" means to collapse a set of values to a single value.
Finally, "filtering" means returning only a set of elements where a certain
value is true.

Let's explore what that means with our own functions.
The syntax of map/reduce/filter is identical:

```
map(function, thing_to_iterate_over, next_thing_to_iterate_over)
```
{: .language-python}

Let's apply this to a few test cases using map.
Note that when selecting which function we are going to "map" with,

```
import math
values = [0, 1, 2, 3, 4, 5, 6]
map(math.sin, values)
```
{: .language-python}
```
<map object at 0x7f31c246cba8>
```
{: .output}

To retrieve the actual values,
we typically need to make the resulting output a list.

```
list(map(math.sin, values))
```
{: .language-python}
```
[0.0,
 0.8414709848078965,
 0.9092974268256817,
 0.1411200080598672,
 -0.7568024953079282,
 -0.9589242746631385,
 -0.27941549819892586]
```
{: .output}

`filter()` applies a similar operation,
but instead of applying a function to every piece,
it only returns points where a function returns true.

```
def less_than_3(val):
    return val < 3

list(filter(less_than_3, values))
```
{: .language-python}
```
[0, 1, 2]
```
{: .output}

That was very inconvenient.
We had to define an entire function just to only use it once.
The solution for this is to write a one-time use function that has no name.
Such functions are called either anonymous functions or lamdba functions
(both mean the same thing).

To define a lambda function in python, the general syntax is as follows:

```
lambda x: x + 54
``` 
{: .language-python}

In this case, `lambda x:` indicates we are defining a lambda function with a
single argument, `x`.
Everything following the `:` is our function.
Whatever value this evaluates to is automatically returned.
So `lambda x: x + 54` equates to:

```
def some_func(x):
    return x + 54
```
{: .language-python}

Rewriting our filter statement to use a lambda function:

```
list(filter(lambda x: x < 3, values))
```
{: .language-python}
```
[0, 1, 2]
```
{: .output}

And a side-by-side example that demonstrates the difference between `map()` and
`filter()`.

```
list(map(lambda x: x+100, [1,2,3,4,5]))
list(filter(lambda x: x<3, [1,2,3,4,5]))
```
{: .language-python}
```
[101, 102, 103, 104, 105]   # map()
[1, 2]   # filter()
```
{: .output}

> ## Using lambdas in practice
>
> Add `'-cheesecake'` to every word in the following list using `map()`.
> 
> `['new york', 'chocolate', 'new york', 'ketchup', 'mayo']`
> 
> Using `filter()`, remove the items which would be absolutely terrible to eat.
{: .challenge}

## map/filter style functionality with Numpy arrays

Although you *could* use a for-loop to apply a custom function to a numpy array
in a single go, there is a handy `np.vectorize()` function you can use to
convert your functions to a vectorised numpy equivalent. 
Note that this is purely for convenience &mdash; this uses a `for-loop`
internally.

```
import numpy as np
# create a function to perform cubes of a number
vector_cube = np.vectorize(lambda x: x ** 3)

vector_cube(np.array([1, 2, 3, 4, 5]))
```
{: .language-python}
```
array([  1,   8,  27,  64, 125])
```
{: .output}

To perform a similar option to `filter()`,
you can actually specify a conditional statement inside the `[]`
when indexing a Numpy array.

```
arr = np.array([1, 2, 3, 4, 5])
arr[arr >= 3]
```
{: .language-python}

> ## Removing np.nan values
>
> Remove all of the `np.nan` values from the following sequence
> using logical indexing.
>
> `np.array([np.nan, np.nan, 2, 3, 4, np.nan])`
{: .challenge}
