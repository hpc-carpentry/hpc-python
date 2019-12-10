files/snakemake-lesson.tar.gz: files/snakemake-lesson/*py
	@rm -vf $@ && cd files && tar vczf ../$@ snakemake-lesson/*py snakemake-lesson/books/* snakemake-lesson/matplotlibrc snakemake-lesson/cluster.json snakemake-lesson/.Snakefile

files/snakemake-lesson.zip: files/snakemake-lesson/*py
	@rm -vf $@ && cd files && zip ../$@ snakemake-lesson/*py snakemake-lesson/books/* snakemake-lesson/matplotlibrc snakemake-lesson/cluster.json snakemake-lesson/.Snakefile

## prep-release     : compress contents of snakemake-lesson for release
prep-release: files/snakemake-lesson.zip files/snakemake-lesson.tar.gz
