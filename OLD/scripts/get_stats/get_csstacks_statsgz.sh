

for f in *matches.tsv.gz ;  do echo -n ${f%.matches.tsv.gz} ; echo -n " " ; zcat $f | cut -f 3 |sort | uniq |wc -l ; done> cstacks_stats.txt
