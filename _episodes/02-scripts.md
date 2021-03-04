---
title: "Scripts and imports"
teaching: 15
exercises: 15
questions:
- "What is a Python program?"
objectives:
- "Explain what constitutes a Python program."
- "Import Python modules."
keypoints:
- "To run a Python program, use `python3 program_name.py`."
---

Everything we've learned so far is pretty cool.
But if we want to run a set of commands more than once?
How do we write a program in Python?

Python programs are simply a set of Python commands saved in a file.
No compiling required!
To demonstrate this, let's write our first program!
Enter the following text in a text editor and save it under any name you like
(Python files are typically given the extension `.py`).

```
print('it works!!!')
```
{: .language-python}

We can now run this program in several ways.
If we were to open up a terminal in the folder where we had saved our program,
we could run the command `python3 our-script-name.py` to run it.

```
it works!!!
```
{: .output}

> ## What's the point of print()?
>
> We saw earlier that there was no difference between printing something with
> `print()` and just entering a command on the command line.
> But is this really the case?
> Is there a difference after all?
>
> Try executing the following code:
>
> ```
> print('this involves print')
> 'this does not'
> ```
> {: .language-python}
> What gets printed if you execute this as a script?
> What gets printed if you execute things line by line?
> Using this information, what's the point of `print()`?
{: .challenge}

## `import`-ing things

IPython has a neat trick to run command line commands without exiting IPython.
Any command that begins with `!` gets run on your computer's command line, and
not the IPython terminal.

We can use this fact to run the command `python3 our-script-name.py`.
I've called my script `test.py` as an example.

```
!python3 test.py
```
{: .language-python}
```
it works!!!
```
{: .output}

What if we wanted to pass additional information to Python?
For example, what if we want Python to print whatever we type back at us?
To do this, we'll need to use a bit of extra functionality:
the `sys` package.

Python includes a lot of extra features in the form of packages,
but not all of them get loaded by default.
To access a package, we need to `import` it.

```
import sys
```
{: .language-python}

You'll notice that there's no output.
Only one thing is changed:
We can now use the bonuses provided by the `sys` package.
For now, all we will use is `sys.argv`.
`sys.argv` is a special variable
that stores any additional arguments we provide on the command-line
after `python3 our-script-name.py`.
Let's make a new script called `command-args.py` to try this out.

```
import sys
print('we typed: ', sys.argv)
```
{: .language-python}

We can then execute this program with:
```
!python3 test.py word1 word2 3
```
{: .language-python}
```
we typed: ['test.py', 'word1', 'word2', '3']
```
{: .output}

You'll notice that `sys.argv` looks different from other data types we've seen
so far. `sys.argv` is a list (more about this in the next session).
