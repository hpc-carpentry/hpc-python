---
layout: lesson
root: .
---

Python is probably the most versatile language in existence. However one of its
most useful features is its ability to tie things together and automate the
execution of other programs.

This tutorial focuses on using Python in high-performance computing
environments to automate data analysis pipelines with
[Snakemake](http://snakemake.readthedocs.io/en/stable/) (for a detailed
discussion for why we are teaching Snakemake, see this lesson's <a href="{{
page.root }}/discuss/">discussion page</a>). We’ll start with the basics and
cover everything you need to get started. Some elements of writing
performance-oriented code will be covered, but it is not the main focus. There
is no prerequisite knowledge for this tutorial, although having some prior
experience with the command-line or a compute cluster will be very helpful.

At the end of this lesson, you will know how to:

* Write and run basic Python programs.

* Create a reproducible analysis pipeline in Python. 

* Run your pipeline on your computer or on a high-performance computing cluster
  and have it scale appropriately.


> ## Setup
>
> You will want to have Python 3 and your favorite Python editor preinstalled
> and ready to go. If you don’t know where to get things or what to install,
> just install Miniconda (the Python 3 version) from
> <https://docs.conda.io/en/latest/miniconda.html>.
> 
> To install snakemake, please run the following in a command-line terminal:
> `conda install snakemake`
>
> The files used in this lesson can be downloaded
> [here](files/snakemake-lesson.zip).
{: .prereq}
