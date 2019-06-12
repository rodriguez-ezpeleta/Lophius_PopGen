M=2 #small caps
poploc=/share/projects/GECKA/popmaps/popmap_selectedClean
indir=/share/projects/GECKA/stacks_M${M}
outdir=./

pops="$(cut -f 2 ${poploc} | sort | uniq)"

p="$(cut -f 2 ${poploc} | sort | uniq | wc -l)"

populations -P $indir -M $poploc -O $outdir -p ${p} -t 8 -r 0.80 -R 0.80 --plink

echo "step inds tags snps" > population_stats.txt

# count missing data for inds and snps
plink --noweb --file  populations.plink --out populations.plink  --missing --allow-no-sex
tr -s ' ' < populations.plink.imiss | cut -d " " -f 7 | sort -g | tail -n 10
tr -s ' ' < populations.plink.lmiss | cut -d " " -f 6 | sort -g | tail -n 10

tags="$(cut -f 2 populations.plink.map| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
snps="$(wc -l populations.plink.map| cut -d " " -f 1)"
echo "catalog080 "  $tags " " $snps  >> population_stats.txt

#remove inds with more than 0.25 missing data
plink --noweb --file populations.plink  --mind 0.25 --out populations.plink_mind75 --recode --allow-no-sex

#count missing data for inds and snps
plink --noweb --file  populations.plink_mind75 --out populations.plink_mind75  --missing --allow-no-sex
tr -s ' ' < populations.plink_mind75.imiss | cut -d " " -f 7 | sort -g | tail -n 10
tr -s ' ' < populations.plink_mind75.lmiss | cut -d " " -f 6 | sort -g | tail -n 10

tags="$(cut -f 2 populations.plink_mind75.map| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
snps="$(wc -l populations.plink_mind75.map| cut -d " " -f 1)"
echo "mind75 "  $tags " " $snps  >> population_stats.txt

#remove snps with more than 0.05 missing data
plink --noweb --file populations.plink_mind75  --geno 0.05 --out populations.plink_mind75_geno05 --recode --allow-no-sex

#count missing data for inds and snps
plink --noweb --file  populations.plink_mind75_geno05 --out populations.plink_mind75_geno05  --missing --allow-no-sex
tr -s ' ' < populations.plink_mind75_geno05.imiss | cut -d " " -f 7 | sort -g | tail -n 10
tr -s ' ' < populations.plink_mind75_geno05.lmiss | cut -d " " -f 6 | sort -g | tail -n 10

tags="$(cut -f 2 populations.plink_mind75_geno05.map| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
snps="$(wc -l populations.plink_mind75_geno05.map| cut -d " " -f 1)"
echo "geno05"  $tags " " $snps  >> population_stats.txt

#remove snps with less than 0.05 maf data
plink --noweb --file  populations.plink_mind75_geno05 --maf 0.05 --out populations.plink_mind75_geno05_maf05 --recode

#count missing data for inds and snps
plink --noweb --file  populations.plink_mind75_geno05_maf05 --out populations.plink_mind75_geno05_maf05  --missing --allow-no-sex
tr -s ' ' < populations.plink_mind75_geno05_maf05.imiss | cut -d " " -f 7 | sort -g | tail -n 10
tr -s ' ' < populations.plink_mind75_geno05_maf05.lmiss | cut -d " " -f 6 | sort -g | tail -n 10

tags="$(cut -f 2 populations.plink_mind75_geno05_maf05.map| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
snps="$(wc -l populations.plink_mind75_geno05_maf05.map| cut -d " " -f 1)"
echo "maf05"  $tags " " $snps  >> population_stats.txt


rm -f SNPs.txt
rm -rf nbSNPsexcluded.txt

for p in $pops; do

        grep $p populations.plink_mind75_geno05_maf05.ped > ${p}.ped
        cp populations.plink_mind75_geno05_maf05.map ${p}.map
        plink --noweb --file ${p} --hwe 0.05 --out ${p}_hwe05 --recode  
        exc="$(grep "markers to be excluded based" ${p}_hwe05.log | cut -d " " -f 1)"
        echo $p " " $exc >> nbSNPsexcluded.txt
        cat ${p}_hwe05.map  populations.plink_mind75_geno05_maf05.map | sort | uniq -u | sed 's/ \+/\t/g' | cut -f 2 > ${p}_excluded.txt
        rm -rf ${p}.ped ${p}.map ${p}_hwe05.*

done

# SNPs faling HWE in more than one pop

cat *_excluded.txt | sort | uniq -d > SNPs_failMoreThanOnePop.txt

#remove snps not passing hwe 0.05 in more than one pop
plink --noweb --file  populations.plink_mind75_geno05_maf05 --exclude SNPs_failMoreThanOnePop.txt --out populations.plink_mind75_geno05_maf05_hwe05 --recode

#count missing data for inds and snps
plink --noweb --file  populations.plink_mind75_geno05_maf05_hwe05 --out populations.plink_mind75_geno05_maf05_hwe05  --missing --allow-no-sex
tr -s ' ' < populations.plink_mind75_geno05_maf05_hwe05.imiss | cut -d " " -f 7 | sort -g | tail -n 10
tr -s ' ' < populations.plink_mind75_geno05_maf05_hwe05.lmiss | cut -d " " -f 6 | sort -g | tail -n 10

tags="$(cut -f 2 populations.plink_mind75_geno05_maf05_hwe05.map| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
snps="$(wc -l populations.plink_mind75_geno05_maf05_hwe05.map| cut -d " " -f 1)"
echo "hwe05"  $tags " " $snps  >> population_stats.txt

cut -f 2 populations.plink_mind75_geno05_maf05_hwe05.map | sed -e s/"_"/"\t"/g > SNPs_mind75_geno05_maf05_hwe05.txt

populations -P $indir -M $poploc -O $outdir  --whitelist  SNPs_mind75_geno05_maf05_hwe05.txt --genepop --structure --plink  

rename s/populations/perArea/g *

populations -P $indir -M $poploc -O $outdir --write-single-snp --whitelist  SNPs_mind75_geno05_maf05_hwe05.txt --genepop --structure --plink  

rename s/populations/perArea_oneSNP/g *

