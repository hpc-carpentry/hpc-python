---
title: "Storing data with dicts"
teaching: 15
exercises: 15
questions:
- "How do I store structured data?"
objectives:
- "Be able to store data using Python's dict objects."
keypoints:
- "Dicts provide key-value storage of information."
---

Dictionaries (also called dicts) are another key data structure we'll need to
use to write a pipeline. In particular, dicts allow efficient key-value storage
of any type of data.

To create a dict, we use syntax like the following.

```
example = {}
type(example)
```
{: .language-python}
```
dict
```
{: .output}

We can then store values in our dict using indexing.
The index is referred to as the "key",
and the stored data is referred to as the "value".

```
example['key'] = 'value'
example['key']
```
{: .language-python}
```
'value'
```
{: .output}

In addition, keys can be stored using any type of value.
Let's add several more values to demonstrate this.

```
example[1] = 2
example[4] = False
example['test'] = 5
example[7] = 'myvalue'
```
{: .language-python}

To retrieve all keys in the dictionary, we can use the `.keys()`method.
Note how we used the `list()` function to turn our resulting output into a
list.

```
list(example.keys())
```
{: .language-python}
```
['key', 1, 4, 'test', 7]
```
{: .output}

Likewise, we can retrieve all the values at once, using `.values()`

```
list(example.values())
```
{: .language-python}
```
['value', 2, False, 5, 'myvalue']
```
{: .output}

> ## Dictionary order
>
> Note that the order of keys and values in a dictionary should not be relied
> upon. We'll create dictionary another way to demonstrate this:
>
> ```
> unordered = {'a': 1,
>              'b': 2,
>              'c': 3,
>              'd': 4}
> ```
> {: .language-python}
> ```
> {'a': 1, 'b': 2, 'c': 3, 'd': 4}
> ```
> {: .output}
>
> Depending on your version of Python, the dictionary will either be in order,
> or out of order. If you are on Python 3.6+ dictionaries are ordered.
>
> Iterate through and print the dictionary's keys in both forward and reverse
> order.
>
> (To iterate through the dict in a specific order, you will need to sort the
> keys using the `sorted()` function.)
{: .callout}
