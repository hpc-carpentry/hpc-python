---
layout: page
title: Discussion
permalink: /discuss/
---

This lesson is heavily skewed towards teaching basic Python syntax and analysis
pipelines using [Snakemake](http://snakemake.readthedocs.io/en/stable/). Of
course this raises a couple questions - given the limited teaching time for
these courses, why teach Snakemake over other Python concepts or tools? Why
teach Python at all for high-performance computing tasks?

## Why not other Python topics?

For a workshop on general data analysis or basic coding in Python, we recommend
checking out one of Software Carpentry's other workshops that focus on
[Numpy](http://swcarpentry.github.io/python-novice-inflammation/) or
[Pandas](http://swcarpentry.github.io/python-novice-gapminder/) instead.

The goal of this workshop is to teach Python in the context of high-performance
computing. Of course, Python is not a fast language. Any code written in an
interpreted language like Python will generally run [hundreds of times slower](
http://benchmarksgame.alioth.debian.org/u64q/compare.php?lang=python3&lang2=gpp)
than a compiled language like C++, Fortran, or even Java. Though it's possible
to improve Python's performance with tools like PyPy, Cython, etc. the level of
knowledge required to use these tools effectively is far beyond what can be
taught in a one-day workshop. Python isn't the right tool for the job if
fast/parallel computing is required. Instructors looking to teach heavy-duty
performance and/or parallelization related topics should check out our [Chapel
lesson](https://hpc-carpentry.github.io/hpc-chapel/) instead.

So why teach Python at all?

In most scientific fields, there is a major need for automation. Workflows
where the same computation needs to repeated for thousands of input files are
commonplace. This is especially true for fields like bioinformatics, where
researchers need to run dozens of pre-existing programs to process a piece of
data, and then repeat this process for dozens, if not hundreds (or thousands)
of input files. Running these types of high-throughput workflows is a
significant amount of work, made even more complex by the scripting required to
use an HPC cluster's scheduler effectively.

Python is a great scripting language, and used in a combination with a workflow
management tool like Snakemake, it is very simple to script the execution of
these types of high-throughput/complex workflows. The goal of this workshop is
to teach students how to automate their work with Python, and make their
workflows reproducible. Importantly, this also covers how to use Snakemake to
automate submission of jobs to an HPC scheduler in a reasonable manner (no
runaway submission of tens of thousands of jobs, encountering an error safely
stops the workflow without losing work, logfiles and output are handled
appropriately, etc.).

## Why not other workflow/pipeline tools?

There are lots of other pipeline/workflow management tools out there (in fact,
this lesson was adapted from Software Carpentry's [GNU Make lesson](
http://swcarpentry.github.io/make-novice/)). Why teach Snakemake instead of
these other tools?

* It's free, open-source, and installs in about 5 seconds flat via `pip`.

* Snakemake works cross-platform (Windows, MacOS, Linux) and is compatible with
  all HPC schedulers. More importantly, the same workflow will work and scale
  appropriately regardless of whether it's on a laptop or cluster *without
  modification*.

* Snakemake uses pure Python syntax. There is no tool specific-language to
  learn like in GNU Make, NextFlow, WDL, etc.. Even if students end up not
  liking Snakemake, you've still taught them how to program in Python at the
  end of the day.

* Anything that you can do in Python, you can do with Snakemake (since you can
  pretty much execute arbitrary Python code anywhere).

* Snakemake was written to be as similar to GNU Make as possible. Users already
  familiar with Make will find Snakemake quite easy to use.

* It's easy. You can teach Snakemake in an afternoon.
