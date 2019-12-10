# This is a "hidden" version of the final Snakefile if students want/need 
# to run the instructor's copy.

# our zipf analysis pipeline
DATS = glob_wildcards('books/{book}.txt').book

localrules: all, clean, make_archive

rule all:
    input:
        'zipf_analysis.tar.gz'

# delete everything so we can re-run things
# deletes a little extra for purposes of lesson prep
rule clean:
    shell:  
        '''
        rm -rf results dats plots __pycache__
        rm -f results.txt zipf_analysis.tar.gz *.out *.log *.pyc
        '''

# count words in one of our "books"
rule count_words:
    input:  
        wc='wordcount.py',
        book='books/{file}.txt'
    output: 'dats/{file}.dat'
    threads: 4
    log: 'dats/{file}.log'
    shell:
        '''
        echo "Running {input.wc} with {threads} cores on {input.book}." &> {log} &&
            python {input.wc} {input.book} {output} &>> {log}
        '''

# create a plot for each book
rule make_plot:
    input:
        plotcount='plotcount.py',
        book='dats/{file}.dat'
    output: 'plots/{file}.png'
    resources: gpu=1
    shell: 'python {input.plotcount} {input.book} {output}'

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

