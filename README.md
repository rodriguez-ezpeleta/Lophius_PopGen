# gecka

popmaps

popmap_catalog -> all samples analyzed : 288
popmap_selected -> samples selected (8 removed for having a too low number of tags): 280

scripts

clean.sh -> from raw data to fastq.gz files to be used for assembly (demultiplexing, RAD-site checking, quality filtering)
assembly.sh -> ustacks - cstacks - sstacks - tsv2bam
genotypeTables.sh -> from catalog to genotype files

stats_files

tag-assembly.txt -> stats from cleaning and assembly process (including metadata for each sample)
population_stats -> number of tags and SNPs remaining after each filtering step

genotype_files
