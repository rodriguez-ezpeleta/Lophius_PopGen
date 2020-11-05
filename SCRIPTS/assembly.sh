
clean=/share/projects/GECKA/clean # folder where clean files R1 and R2 are located
M=4 # M parameter; to change if needed
n=6 # n parameter; to change if needed
out=/share/projects/GECKA/stacks_M${M} # path to output directory

##########

## ustacks

#mkdir  $out

files=(`ls ${clean}/*1.fq.gz |rev| cut -d "/" -f 1 | rev`)
nb=(`ls ${clean}/*1.fq.gz |rev| cut -d "/" -f 1 | rev|wc`)
s=(`expr $nb - 1`)

id=1

for i in `seq 0 $s`; do

    ustacks -f $clean/${files[i]} -o $out -i $id -M $M --disable-gapped -p 8
    let "id+=1"

done


 

echo "Names RetainedReads Tags HeTags Alleles SNPs" > ustacks_stats.txt

for f in *alleles*; do
	echo -n ${f%.alleles.tsv.gz} >> ustacks_stats.txt
        echo -n " "  >> ustacks_stats.txt
        use="$( zgrep -c 'primary\|secondary' ${f%.alleles.tsv.gz}.tags.tsv.gz)"
        echo -n $use >> ustacks_stats.txt
        echo -n " "  >> ustacks_stats.txt
        tag="$(zgrep -c consensus ${f%.alleles.tsv.gz}.tags.tsv.gz)"
        echo -n $tag >> ustacks_stats.txt
        echo -n " "  >> ustacks_stats.txt
        utag="$(zgrep -v "#"  $f |cut -f2| uniq |wc -l)"
        echo -n $utag >> ustacks_stats.txt
        echo -n " "  >> ustacks_stats.txt
	all="$(zcat $f | wc -l)"
        echo -n $all >> ustacks_stats.txt
        echo -n " " >> ustacks_stats.txt
	snp="$(zcat ${f%.alleles.tsv.gz}.snps.tsv.gz | grep -c 'E')"
	echo $snp  >> ustacks_stats.txt
done 
 




rename s/"\.1"/""/g *



## cstacks

cstacks -P $out -M ../popmaps/popmapPreCstacks -n $n -p 8 --disable-gapped


####corrido hasta aqui
## sstacks

sstacks -P $out -M ../popmaps/popmapPreCstacks -p 8 --disable-gapped

rename s/"\.1"/""/g *

##tsv 

tsv2bam -P $out -M ../popmaps/popmapPreCstacks --pe-reads-dir $clean -t 8

## gstacks

gstacks -P $out -M ../popmaps/popmapPreCstacks -t 8 --ignore-pe-reads
