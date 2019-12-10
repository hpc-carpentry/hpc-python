files/snakemake-lesson.tar.gz: files/snakemake-lesson/*py
	@rm -vf $@ && cd files && tar czf $@ snakemake-lesson/*py snakemake-lesson/books/* snakemake-lesson/matplotlibrc snakemake-lesson/cluster.json snakemake-lesson/.Snakefile

files/snakemake-lesson.zip: files/snakemake-lesson/*py
	@rm -vf $@ && cd files && zip $@ -i snakemake-lesson/*py -i snakemake-lesson/books/* -i snakemake-lesson/matplotlibrc -i snakemake-lesson/cluster.json -i snakemake-lesson/.Snakefile

## prep-release     : compress contents of snakemake-lesson for release
prep-release: files/snakemake-lesson.zip files/snakemake-lesson.tar.gz
