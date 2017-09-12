---
layout: lesson
root: .
---
Python is probably the most versatile language in existence. However one of its most useful features is its ability to tie things together and automate the execution of other programs.

This tutorial focuses on using Python in HPC environments to automate data analysis pipelines with 
[Snakemake](http://snakemake.readthedocs.io/en/stable/). 
We’ll start with the basics and cover everything you need to get started. 
Some elements of writing performance-oriented code will be covered, 
but it is not the main focus. 
There is no prerequisite knowlege for this tutorial, 
although having some prior experience with the command-line or an HPC cluster will be very helpful.

## What is Snakemake?

Snakemake is a “pipelining tool”. 
It replaces the role of the researcher in running an analysis. 
A researcher specifies their workflow’s tasks in a special file (called “Snakefile”) and runs Snakemake. 
Snakemake then handles the specifics of running the researchers’ tasks as efficiently as possible.
This has several key advantages over just running things ourselves:

* Our work is reproducible. Snakemake will run our analysis the same way every time. We can demonstrate that repeating the workflow returns the same result.

* Snakemake runs our tasks in parallel and has a built-in scheduler designed to maximize throughput. When we run a workflow, we can be confident that our work is getting done as fast as possible.

* Snakemake automatically takes into account updates to our starting data and code. If we make a change, Snakemake will only re-run the analysis affected files and downstream output. By the same token, if a workflow fails halfway through, it will pick up from where things left off.

* Workflows are portable - the same pipeline can be used on any system, anywhere. Snakemake handles all of the intricacies of running jobs (no need to write scripts for a cluster scheduler, Snakemake does that for you!). The same pipeline can be run on a Windows laptop or a HPC Linux cluster with no modification.

Long story short, Snakemake makes our analyses scalable, reproducible, and more efficient in general. 
For a detailed discussion on why Snakemake was chosen over competing tools (and other Python topics), 
see this lesson's <a href="{{ page.root }}/discuss/">discussion</a> page.

> ## Setup
>
> You will want to have Python 3 and your favorite Python editor preinstalled and ready to go. 
> If you don’t know where to get things or what to install, 
> just install Anaconda (the Python 3 version) from [https://www.continuum.io/downloads](https://www.continuum.io/downloads). 
> Anaconda is an extremely comprehensive Python distribution that comes with all of the bells and whistles ready to go.
> 
> To install snakemake, please run the following in a command-line terminal:
> `pip install --user snakemake`
>
> The files used in this lesson can be downloaded [here](files/snakemake-lesson.tar.gz).
{: .prereq}
