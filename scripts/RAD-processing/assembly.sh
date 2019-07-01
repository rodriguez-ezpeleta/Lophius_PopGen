# change for each project
clean=/share/projects/GECKA/clean # folder where clean files R1 and R2 are located
M=4 # M parameter; to change if needed
n=6 # n parameter; to change if needed
out=/share/projects/GECKA/stacks_M${M} # path to output directory

##########

## ustacks

mkdir  $out

files=(`ls ${clean}/*1.fq.gz |rev| cut -d "/" -f 1 | rev`)
nb=(`ls ${clean}/*1.fq.gz |rev| cut -d "/" -f 1 | rev|wc`)
s=(`expr $nb - 1`)

id=1

for i in `seq 0 $s`; do

    ustacks -f $clean/${files[i]} -o $out -i $id -M $M --disable-gapped -p 8
    let "id+=1"

done

rename s/"\.1"/""/g *

## cstacks

cstacks -P $out -M ../popmaps/popmap_catalog -n $n -p 8 --disable-gapped

## sstacks

sstacks -P $out -M ../popmaps/popmap_catalog -p 8 --disable-gapped

rename s/"\.1"/""/g *

##tsv 

tsv2bam -P $out -M ../popmaps/popmap_catalog --pe-reads-dir $clean -t 8

## gstacks

gstacks -P $out -M ../popmaps/popmap_selected -t 8
