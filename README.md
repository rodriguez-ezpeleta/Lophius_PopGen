# gecka

SCRIPTS

clean.sh -> from raw data to fastq.gz files to be used for assembly (demultiplexing, RAD-site checking, quality filtering)
assembly.sh -> ustacks - cstacks - sstacks - tsv2bam
genotype_tablesHWrape_mind*.sh -> from catalog to genotype files (missing less than .25 or .15 respectively)


GENOTYPE DATA

The first .str is composed by ALL individuals 
The second one by ALL individuals mapped to a reference genome of L.pis
The third one is the only LPIS real individuals without black or hybrids AND including MED
The fourth one is composed by only L.pis individuals in the Atlantic


--------------------------
OLD

popmaps

popmap_catalog -> all samples analyzed : 288
popmap_selected -> samples selected (8 removed for having a too low number of tags): 280

stats_files

tag-assembly.txt -> stats from cleaning and assembly process (including metadata for each sample)
population_stats -> number of tags and SNPs remaining after each filtering step

genotype_files
