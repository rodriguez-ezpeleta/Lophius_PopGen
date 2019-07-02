
echo "Names	RetainedReads	Tags	HeTags	Alleles	SNPs" > ustacks_stats.txt

for f in *alleles*; do 
	echo -n ${f%.alleles.tsv.gz} >> ustacks_stats.txt
        echo -n "	"  >> ustacks_stats.txt
        use="$( zgrep -c 'primary\|secondary' ${f%.alleles.tsv.gz}.tags.tsv.gz)"
        echo -n $use >> ustacks_stats.txt
        echo -n "	"  >> ustacks_stats.txt
        tag="$(zgrep -c consensus ${f%.alleles.tsv.gz}.tags.tsv.gz)"
        echo -n $tag >> ustacks_stats.txt
        echo -n "	"  >> ustacks_stats.txt
        utag="$(zgrep -v "#"  $f |cut -f2| uniq |wc -l)"
        echo -n $utag >> ustacks_stats.txt
        echo -n "       "  >> ustacks_stats.txt
	all="$(zcat $f | wc -l)"
        echo -n $all >> ustacks_stats.txt
        echo -n "	" >> ustacks_stats.txt
	snp="$(zcat ${f%.alleles.tsv.gz}.snps.tsv.gz | grep -c 'E')"
	echo $snp  >> ustacks_stats.txt
done


	
