---
title: "Scaling a pipeline across a cluster"
teaching: 30
exercises: 15
questions:
- "How do I run my workflow on an HPC system?"
objectives:
- "Understand the Snakemake cluster job submission workflow."
keypoints:
- "Snakemake generates and submits its own batch scripts for your scheduler."
- "`localrules` defines rules that are executed on the Snakemake head node."
- "`$PATH` must be passed to Snakemake rules."
- "`nohup <command> &` prevents `<command>` from exiting when you log off."
---

Right now we have a reasonably effective pipeline that scales nicely on our
local computer.
However, for the sake of this course, we'll pretend that our workflow actually
takes significant computational resources and needs to be run on a cluster.

> ## HPC cluster architecture
>
> Most HPC clusters are run using a scheduler.
> The scheduler is a piece of software that handles which compute jobs are run
> on which compute nodes and where.
> It allows a set of users to share a shared computing system as efficiently as
> possible.
> In order to use it, users typically must write their commands to be run into
> a shell script and then "submit" it to the scheduler.
>
> A good analogy would be a university's room booking system.
> No one gets to use a room without going through the booking system.
> The booking system decides which rooms people get based on their requirements
> (# of students, time allotted, etc.).
{: .callout}

Normally, moving a workflow to be run by a cluster scheduler requires a lot of
work.
Batch scripts need to be written, and you'll need to monitor and babysit the
status of each of your jobs.
This is especially difficult if one batch job depends on the output from
another.
Even moving from one cluster to another (especially ones using a different
scheduler) requires a large investment of time and effort &mdash; all the batch
scripts from before need to be rewritten.

Snakemake does all of this for you.
All details of running the pipeline through the cluster scheduler are handled
by Snakemake &mdash; this includes writing batch scripts, submitting, and
monitoring jobs.
In this scenario, the role of the scheduler is limited to ensuring each
Snakemake rule is executed with the resources it needs.

We'll explore how to port our example Snakemake pipeline.
Our current Snakefile is shown below:

```
# our zipf analysis pipeline
DATS = glob_wildcards('books/{book}.txt').book

rule all:
    input:
        'zipf_analysis.tar.gz'

# delete everything so we can re-run things
rule clean:
    shell:
        '''
        rm -rf results dats plots
        rm -f results.txt zipf_analysis.tar.gz
        '''

# count words in one of our "books"
rule count_words:
    input:
        wc='wordcount.py',
        book='books/{file}.txt'
    output: 'dats/{file}.dat'
    threads: 4
    shell:
        '''
        python {input.wc} {input.book} {output}
        '''

# create a plot for each book
rule make_plot:
    input:
        plotcount='plotcount.py',
        book='dats/{file}.dat'
    output: 'plots/{file}.png'
    resources: gpu=1
    shell:  'python {input.plotcount} {input.book} {output}'

# generate summary table
rule zipf_test:
    input:
        zipf='zipf_test.py',
        books=expand('dats/{book}.dat', book=DATS)
    output: 'results.txt'
    shell:  'python {input.zipf} {input.books} > {output}'

# create an archive with all of our results
rule make_archive:
    input:
        expand('plots/{book}.png', book=DATS),
        expand('dats/{book}.dat', book=DATS),
        'results.txt'
    output: 'zipf_analysis.tar.gz'
    shell: 'tar -czvf {output} {input}'
```
{: .language-make}

To run Snakemake on a cluster, we need to create a profile to tell snakemake
how to submit jobs to our cluster.
We can then submit jobs with this profile using the `--profile` argument
followed by the name of our profile.
In this configuration,
Snakemake runs on the cluster head node and submits jobs.
Each cluster job executes a single rule and then exits.
Snakemake detects the creation of output files,
and submits new jobs (rules) once their dependencies are created.

## Transferring our workflow

Let's port our workflow to Compute Canada's Graham cluster as an example (you
will probably be using a different cluster, adapt these instructions to your
cluster).
The first step will be to transfer our files to the cluster and log on via SSH.
Snakemake has a powerful archiving utility that we can use to bundle up our
workflow and transfer it.


```
$ snakemake clean
$ tar -czvf pipeline.tar.gz .
# transfer the pipeline via scp
$ scp pipeline.tar.gz yourUsername@graham.computecanada.ca:
# log on to the cluster
$ ssh -X yourUsername@graham.computecanada.ca
```
{: .language-bash}

> ## `snakemake --archive` and Conda deployment
>
> Snakemake has a built-in method to archive all input files
> and scripts under version control: `snakemake --archive`.
> What's more, it also installs any required dependencies if they can be
> installed using Anaconda's `conda` package manager.
> You can use this feature for this tutorial
> (I've already added all of the files to version control for you),
> but if you want to use this feature in your own work,
> you should familiarise yourself with a version control tool like Git.
>
> For more information on how to use this feature, see
> [http://snakemake.readthedocs.io/en/stable/snakefiles/deployment.html](
> http://snakemake.readthedocs.io/en/stable/snakefiles/deployment.html)
{: .callout}

At this point we've archived our entire pipeline, sent it to the cluster, and
logged on. Let's create a folder for our pipeline and unpack it there.

```
$ mkdir pipeline
$ mv pipeline.tar.gz pipeline
$ cd pipeline
$ tar -xvzf pipeline.tar.gz
```
{: .language-bash}

If Snakemake and Python are not already installed on your cluster,
you can install them using the following commands:

```
$ wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
$ bash Miniconda3-latest-Linux-x86_64.sh -b
$ echo 'export PATH=~/miniconda3/bin:~/.local/bin:$PATH' >> ~/.bashrc
$ source ~/.bashrc
$ conda install -y matplotlib numpy graphviz
$ pip install --user snakemake
```
{: .language-bash}

Assuming you've transferred your files and everything is set to go,
the command `snakemake -n` should work without errors.

## Creating a cluster profile

Snakemake uses a YAML-formatted configuration file to retrieve cluster
submission parameters; we will use the SLURM scheduler for an example.
When we use the '--profile slurm' argument, snakemake looks for a directory
with the name of our profile (slurm) containing a 'config.yaml' file such as
the one below.

```
cluster: "sbatch --time={resources.time_min} --mem={resources.mem_mb}
          -c {resources.cpus} -o slurm/logs/{rule}_{wildcards}
          -e slurm/logs/{rule}_{wildcards}"
jobs: 25
default-resources: [cpus=1, mem_mb=1000, time_min=5]
resources: [cpus=100, mem_mb=1000000]
```
{: .source}

This file has several components.
`cluster` and the arguments that follow tell snakemake how to submit jobs to
the cluster.
Here we've used SLURM's `sbatch` command and arguments for setting time limits
and resources with snakemake wildcards defining the requested values.
We've also specified where to save SLURM logs and what to call them; note that
this folder must already exist.
Values for any command line argument to snakemake can be defined in our
profile, although a value is required (e.g. the `--use-conda` argument could be
included in our profile with `use-conda: true`).
`jobs` specifies the maximum number of jobs that will be submitted at one time.
We also specified the `default-resources` that will be requested for each job,
while `resources` defines the resource limits.
With these parameters, snakemake will use no more than 100 cpus and 100000 MB
(100 GB) at a time between all currently submitted jobs.
While it does not come into play here, a generally sensible default is slightly
above the maximum number of jobs you are allowed to have submitted at a time.

The defaults won't always be perfect, however &mdash; chances are some rules
may need to run with non-default amounts of memory or time limits.
We are using the `count_words` rule as an example of this.
To request non-default resources for a job, we can modify the rule in our
snakefile to include a `resources` section like this:

```
# count words in one of our "books"
rule count_words:
    input:
        wc='wordcount.py',
        book='books/{file}.txt'
    output: 'dats/{file}.dat'
    threads: 4
    resources: cpus=4, mem_mb=8000, time_min=20
    shell:
        '''
        python {input.wc} {input.book} {output}
        '''
```
{: .language-make}

## Local rule execution

Some Snakemake rules perform trivial tasks where job submission might be
overkill (i.e. less than 1 minute worth of compute time).
It would be a better idea to have these rules execute locally
(i.e. where the `snakemake` command is run)
instead of as a job.
Let's define `all`, `clean`, and `make_archive` as localrules near the top of
our `Snakefile`.

```
localrules: all, clean, make_archive
```
{: .language-make}

## Running our workflow on the cluster

OK, time for the moment we've all been waiting for &mdash; let's run our
workflow on the cluster with the profile we've created. Use this command:

```
$ snakemake --profile slurm"
```
{: .language-bash}

While things execute, you may wish to SSH to the cluster in another window so
you can watch the pipeline's progress with `watch squeue -u $(whoami)`.


> ## Notes on `$PATH`
>
> As with any cluster jobs, jobs started by Snakemake need to have the commands
> they are running on `$PATH`.
> For some schedulers (SLURM), no modifications are necessary &mdash; variables
> are passed to the jobs by default.
> Other schedulers (SGE) need to have this enabled through a command line flag
> when submitting jobs (`-V` for SGE).
> If this is possible, just run the `module load` commands you need ahead of
> the job and run Snakemake as normal.
>
> If this is not possible, you have several options:
>
> * You can edit your `.bashrc` file to modify `$PATH` for all jobs and
>   sessions you start on a cluster.
> * Inserting `shell.prefix('some command')` in a Snakefile means that all
>   rules run will be prefixed by `some_command`. You can use this to modify
>   `$PATH`, e.g., `shell.prefix('PATH=/extra/directory:$PATH ')`.
> * You can modify rules directly to run the appropriate `module load` commands
>   beforehand. This is not recommended, only if because it is more work than
>   the other options available.
{: .callout}

> ## Submitting a workflow with nohup
>
> `nohup some_command &` runs a command in the background and lets it keep
> running if you log off.
> Try running the pipeline in cluster mode using `nohup` (run `snakemake clean`
> beforehand).
> Where does the Snakemake log go to?
> Why might this technique be useful?
> Can we also submit the `snakemake --profile slurm` pipeline as a job?
> Where does the Snakemake command run in each scenario?
>
> You can kill the running Snakemake process with `killall snakemake`.
> Notice that if you try to run Snakemake again, it says the directory is
> locked.
> You can unlock the directory with `snakemake --unlock`.
{: .challenge}
