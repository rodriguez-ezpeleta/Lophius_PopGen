#!/bin/bash

p=$1 # add name of folder containing sample information file (pool5 f.e)

clean=/share/projects/GECKA/clean/$p # change to where your folder containing information file is

temp=(`grep -v "#" $clean/$p.txt  |wc`) # .txt file in folder should contain information on sample name (1st col), barcode (2nd col) and path to R1(3rd col and R2 (4th column)
n=(`expr $temp - 1`)

read1=(`grep $p path_gecka.txt |cut -f 3`)
read2=(`grep $p path_gecka.txt |cut -f 4`)

##################################################################33

names=(`cut -f 1 $clean/$p.txt`)

cut -f 2 $clean/$p.txt > $clean/b
cut -f 1 $clean/$p.txt > $clean/n
paste $clean/b $clean/n > $clean/barcodes.txt
rm -rf $clean/b $clean/n

process_radtags -i gzfastq -1 $read1 -2 $read2 -o $clean/ -e sbfI -b $clean/barcodes.txt -c -q -r -s 20

echo "sample retainedReads" >  $clean/sample_reads.txt

for i in `seq 0 $n`; do

    rm -rf ${names[i]}.rem.1.fq.gz
    rm -rf ${names[i]}.rem.2.fq.gz

    echo -n ${names[i]} >> $clean/sample_reads.txt

    echo -n " " >> $clean/sample_reads.txt
    c="$(zgrep -c ^@ $clean/${names[i]}.1.fq.gz)"
    echo -n $c >> $clean/sample_reads.txt

   clone_filter -1 $clean/${names[i]}.1.fq.gz -2 $clean/${names[i]}.2.fq.gz -o $clean -i gzfastq

    c="$(zgrep -c ^@ $clean/${names[i]}.1.1.fq.gz)"
    echo -n " " >> $clean/sample_reads.txt
    echo $c >> $clean/sample_reads.txt
    mv -f $clean/${names[i]}.1.1.fq.gz $clean/${names[i]}.1.fq.gz
    mv -f $clean/${names[i]}.2.2.fq.gz $clean/${names[i]}.2.fq.gz

done



