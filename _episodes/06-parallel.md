---
title: "Introduction to parallel computing"
teaching: 15
exercises: 15
questions:
- "How do I run code in parallel?"
objectives:
- "Understand how to run parallel code with `multiprocessing`."
keypoints:
- "`Pool.map()` will perform an operation in parallel."
---

The primary goal of these lesson materials is to accelerate your workflows
by executing them in a massively parallel (and reproducible!) manner.
Of course, what does this actually mean?

The basic concept of parallel computing is simple to understand:
we divide our job in tasks that can be executed at the same time,
so that we finish the job in a fraction of the time
that it would have taken if the tasks are executed one by one.
There are a lot of different ways of parallelizing things however -
we need to cover these concepts before running our workflows in parallel.

Let's start with an analogy:
suppose that we want to paint the four walls in a room. This is our problem.
We can divide our problem in 4 different tasks: paint each of the walls.
In principle, our 4 tasks are independent from each other
in the sense that we don’t need to finish one to start another.
However, this does not mean that the tasks can be executed simultaneously or in
parallel.
It all depends on the amount of resources that we have for the tasks.

### Concurrent vs. parallel execution

If there is only one painter, they could work for a while in one wall,
then start painting another one, then work for a little bit in the third one,
and so on.
**The tasks are being executed concurrently but not in parallel.**
Only one task is being performed at a time.
If we have 2 or more painters for the job,
then the tasks can be performed in parallel.

In our analogy, the painters represent CPU cores in your computer.
The number of CPU cores available determines
the maximum number of tasks that can be performed in parallel.
The number of concurrent tasks that can be started at the same time,
however, is unlimited.

### Synchronous vs. asynchronous execution

Now imagine that all workers have to obtain their paint form a central
dispenser located at the middle of the room.
If each worker is using a different colour, then they can work asynchronously.
However, if they use the same colour,
and two of them run out of paint at the same time,
then they have to synchronise to use the dispenser &mdash;
one should wait while the other is being serviced.

In our analogy, the paint dispenser represents access to the memory in your
computer.
Depending on how a program is written, access to data in memory can be
synchronous or asynchronous.

### Distributed vs. shared memory

Finally, imagine that we have 4 paint dispensers, one for each worker.
In this scenario, each worker can complete its task totally on their own.
They don’t even have to be in the same room,
they could be painting walls of different rooms in the house,
on different houses in the city, and different cities in the country.
In many cases, however, we need a communication system in place.
Suppose that worker A, needs a colour that is only available in the dispenser
of worker B &mdash;
worker A should request the paint to worker B,
and worker B should respond by sending the required colour.

Think of the memory distributed on each node/computer of a cluster as the
different dispensers for your workers.
A *fine-grained* parallel program needs lots of communication/synchronisation
between tasks,
in contrast with a *course-grained* one that barely communicates at all.
An embarrassingly/massively parallel problem is one where all tasks can be
executed completely independent from each other (no communications required).

### Processes vs. threads

Our example painters have two arms, and could potentially paint with both arms
at the same time.
Technically, the work being done by each arm is the work of a single painter.

In this example, each painter would be a process (an individual instance of a
program).
The painters' arms represent a "thread" of a program.
Threads are separate points of execution within a single program,
and can be executed either synchronously or asynchronously.

---

## How does parallelization work in practice?

These concepts translate into several different types of parallel computing,
each good at certain types of tasks:

### Asynchronous programming

Often times, certain computations involve a lot of waiting.
Perhaps you sent some information to a webserver on the internet and are
waiting back on a response.
In this case, if you needed to make lots of requests over the internet,
your program would spend ages just waiting to hear back.
In this scenario, it would be very advantageous to fire off a bunch of requests
to the internet, and then instead of waiting on each one,
check back periodically to see if the request has completed before processing
each request individually.

This is an example of asynchronous programming.
One thread executes many tasks at the same time,
periodically checking on each one,
and only taking an action once some external task has completed.
Asynchronous programming is very important when programming for the web,
where lots of waiting around happens.
To do this in Python, you'd typically want to use something like the
[asyncio](https://docs.python.org/3/library/asyncio.html) module.
It's not very useful for scientific programming, because only one core/thread
is typically doing any work &mdash;
a normal program that doesn't run in parallel at all would be just as fast!

### Shared memory programming

Shared memory programming means using the resources on a single computer,
and having multiple threads or processes work together on a single copy of a
dataset in memory.
This is the most common form of parallel programming and is relatively easy to
do.
We will cover basic shared-memory programming in Python using the
`multiprocess` / `multiprocessing` packages in this lesson.

### Distributed memory programming

Shared memory programming, although very useful, has one major limitation:
we can only use the number of CPU cores present on a single computer.
If we want to increase speed any more, we need a better computer.
Big computers cost lots and lots of money.
Wouldn't it be more efficient to just use a lot of smaller,
cheap computers instead?

This is the rationale behind distributed memory programming &mdash;
a task is farmed out to a large number of computers,
each of which tackle an individual portion of a problem.
Results are communicated back and forth between compute nodes.

This is most advantageous when a dataset is too large to fit into a computer's
memory (depending on the hardware you have access to this can be anything from
several dozen gigabytes, to several terabytes).
Frameworks like [MPI](https://www.open-mpi.org/),
[Hadoop](http://hadoop.apache.org/), and [Spark](https://spark.apache.org/)
see widespread use for these types of problems
(and are not covered in this lesson).

### Serial farming

In many cases, we'll need to repeat the same computation multiple times.
Maybe we need to run the same set of steps on 10 different samples.
There doesn't need to be any communication at all,
and each task is completely independent of the others.

In this scenario, why bother with all of these fancy parallel programming
techniques, let's just start the same program 10 times on 10 different datasets
on 10 different computers.
The work is still happening in parallel, and we didn't need to change anything
about our program to achieve this.
As an extra benefit, this works the same for every program, regardless of what
it does or what language it was written in.

This technique is known as serial farming, and is the primary focus of this
lesson.
We will learn to use [Snakemake](http://snakemake.readthedocs.io/en/stable/) to
coordinate the parallel launch of dozens, if not hundreds or thousands of
independent tasks.

-------------------------------------------------

## Parallelization in Python

Python does not thread very well.
Specifically, Python has a very nasty drawback known as a Global Interpreter
Lock (GIL).
The GIL ensures that only one compute thread can run at a time.
This makes multithreaded processing very difficult.
Instead, the best way to go about doing things is to use multiple independent
processes to perform the computations.
This method skips the GIL,
as each individual process has it's own GIL that does not block the others.
This is typically done using the `multiprocessing` module.

Before we start, we will need the number of CPU cores in our computer.
To get the number of cores in our computer, we can use the `psutil` module.
We are using `psutil` instead of `multiprocessing` because `psutil` counts
cores instead of threads.
Long story short, cores are the actual computation units,
threads allow additional multitasking using the cores you have.
For heavy compute jobs, you are generally interested in cores.

```
import psutil
# logical=True counts threads, but we are interested in cores
psutil.cpu_count(logical=False)
```
{: .language-python}
```
8
```
{: .output}

Using this number, we can create a pool of worker processes with which to
parallelize our jobs:

```
from multiprocessing import Pool
pool = Pool(psutil.cpu_count(logical=False))
```
{: .language-python}

The `pool` object gives us a set of parallel workers we can
use to parallelize our calculations.
In particular, there is a map function
(with identical syntax to the `map()` function used earlier),
that runs a workflow in parallel.

Let's try `map()` out with a test function that just runs sleep.

```
import time

def sleeping(arg):
    time.sleep(0.1)

%timeit list(map(sleeping, range(24)))
```
{: .language-python}
```
1 loop, best of 3: 2.4 s per loop
```
{: .output}

Now let's try it in parallel:

```
%timeit pool.map(sleeping, range(24))
```
{: .language-python}

If you are using a Jupyter notebook, this will fail:

```
# more errors omitted
AttributeError: Can't get attribute 'sleeping' on <module '__main__'>
AttributeError: Can't get attribute 'sleeping' on <module '__main__'>
```
{: .error}

> ## Differences between Jupyter notebooks versus and the Python interpreters
>
> The last command may have succeeded if you are running in a Python or IPython
> shell. This is due to a difference in the way Jupyter executes user-defined
> functions):
>
> ```
> 1 loop, best of 3: 302 ms per loop
> ```
> {: .output}
>
> Jupyter notebooks define user functions under a special Python module called
> `__main__`.
> This does not work with `multiprocessing`.
> However these issues are not limited to Jupyter notebooks &mdash;
> a similar error will occur if you use a lambda function instead:
>
> ```
> pool.map(lambda x: time.sleep(0.1), range(24))
> ```
> {: .language-python}
> ```
> ---------------------------------------------------------------------------
> PicklingError                             Traceback (most recent call last)
> <ipython-input-10-df8237b4b421> in <module>()
> ----> 1 pool.map(lambda x: time.sleep(0.1), range(24))
>
> # more errors omitted
> ```
> {: .error}
{: .callout}

The `multiprocessing` module has a major limitation:
it only accepts certain functions, and in certain situations.
For instance any class methods, lambdas, or functions defined in `__main__`
wont' work.
This is due to the way Python "pickles" (read: serialises) data
and sends it to the worker processes.
"Pickling" simply can't handle a lot of different types of Python objects.

Fortunately, there is a fork of the `multiprocessing` module called
`multiprocess` that works just fine (`pip install --user multiprocess`).
`multiprocess` uses `dill` instead of `pickle` to serialise Python objects
(read: send your data and functions to the Python workers),
and does not suffer the same issues.
Usage is identical:

```
# shut down the old workers
pool.close()

from multiprocess import Pool
pool = Pool(8)
%timeit pool.map(lambda x: time.sleep(0.1), range(24))
pool.close()
```
{: .language-python}
```
1 loop, best of 3: 309 ms per loop
```
{: .output}

This is a general purpose parallelization recipe that you can use for your
Python projects.

```
# make sure to always use multiprocess
from multiprocess import Pool
# start your parallel workers at the beginning of your script
pool = Pool(number_of_cores)

# execute a computation(s) in parallel
result = pool.map(your_function, something_to_iterate_over)
result2 = pool.map(another_function, more_stuff_to_iterate_over)

# turn off your parallel workers at the end of your script
pool.close()
```
{: .language-python}

Parallel workers (with their own copy of everything) are created, data are sent
to these workers, and then results are combined back together again.
There is also an optional `chunksize` argument (for `pool.map()`) that lets you
control how big each chunk of data is before it's sent off to each worker.
A larger chunk size means that less time is spent shuttling data to and from
workers, and will be more useful if you have a large number of very fast
computations to perform.
When each iteration takes a very long time to run, you will want to use a
smaller chunk size.
