M=2 #small caps
poploc=/share/projects/GECKA/popmaps/popmap_selected
indir=/share/projects/GECKA/stacks_M${M}
outdir=./

pops="$(cut -f 2 ${poploc} | sort | uniq)"

p="$(cut -f 2 ${poploc} | sort | uniq | wc -l)"

populations -P $indir -M $poploc -O $outdir -p ${p} -R 0.90 --plink

rename s/populations/R90/g *

cut -f 2 R90.plink.map | awk -F _ '$2 < 100' > R90_100bp.txt
#cut -f 2 R90.plink.map | sed -e s/"_"/"\t"/g | awk  '$2 < 100' > R90_100bp.txt

plink --noweb --file  R90.plink --out R90_100bp.plink  --extract R90_100bp.txt --allow-no-sex --recode

echo "step inds inds100bp tags tags100bp snps snps100bp" > population_stats.txt

# count missing data for inds and snps
plink --noweb --file  R90.plink --out R90.plink  --missing --allow-no-sex
plink --noweb --file  R90_100bp.plink --out R90_100bp.plink  --missing --allow-no-sex

inds="$(grep -v "#" R90.plink.ped | wc -l | cut -d " " -f 1)"
inds100="$(wc -l R90_100bp.plink.ped | cut -d " " -f 1)"
tags="$(grep -v "#"  R90.plink.map|cut -f 2| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
tags100="$(cut -f 2 R90_100bp.plink.map| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
snps="$(cut -f 2 R90.plink.map|wc -l | cut -d " " -f 1)"
snps100="$(wc -l R90_100bp.plink.map| cut -d " " -f 1)"
echo "catalog090 " $inds " " $inds100 "" $tags " " $tags100 " " $snps  " " $snps100  >> population_stats.txt

#remove inds with more than 0.25 missing data
plink --noweb --file R90.plink  --mind 0.25 --out R90.plink_mind75 --recode --allow-no-sex
plink --noweb --file R90_100bp.plink  --mind 0.25 --out R90_100bp.plink_mind75 --recode --allow-no-sex

#count missing data for inds and snps
plink --noweb --file  R90.plink_mind75 --out R90.plink_mind75  --missing --allow-no-sex
plink --noweb --file  R90_100bp.plink_mind75 --out R90_100bp.plink_mind75  --missing --allow-no-sex

inds="$(grep -v "#" R90.plink_mind75.ped | wc -l | cut -d " " -f 1)"
inds100="$(wc -l R90_100bp.plink_mind75.ped | cut -d " " -f 1)"
tags="$(grep -v "#"  R90.plink_mind75.map|cut -f 2| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
tags100="$(cut -f 2 R90_100bp.plink_mind75.map| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
snps="$(cut -f 2 R90.plink_mind75.map|wc -l | cut -d " " -f 1)"
snps100="$(wc -l R90_100bp.plink_mind75.map| cut -d " " -f 1)"
echo "mind075 " $inds " " $inds100 "" $tags " " $tags100 " " $snps  " " $snps100  >> population_stats.txt


#remove snps with more than 0.05 missing data
plink --noweb --file R90.plink_mind75  --geno 0.05 --out R90.plink_mind75_geno05 --recode --allow-no-sex
plink --noweb --file R90_100bp.plink_mind75  --geno 0.05 --out R90_100bp.plink_mind75_geno05 --recode --allow-no-sex

#count missing data for inds and snps
plink --noweb --file  R90.plink_mind75_geno05 --out R90.plink_mind75_geno05  --missing --allow-no-sex
plink --noweb --file  R90_100bp.plink_mind75_geno05 --out R90_100bp.plink_mind75_geno05  --missing --allow-no-sex

inds="$(grep -v "#" R90.plink_mind75_geno05.ped | wc -l | cut -d " " -f 1)"
inds100="$(wc -l R90_100bp.plink_mind75_geno05.ped | cut -d " " -f 1)"
tags="$(grep -v "#"  R90.plink_mind75_geno05.map|cut -f 2| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
tags100="$(cut -f 2 R90_100bp.plink_mind75_geno05.map| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
snps="$(cut -f 2 R90.plink_mind75_geno05.map|wc -l | cut -d " " -f 1)"
snps100="$(wc -l R90_100bp.plink_mind75_geno05.map| cut -d " " -f 1)"
echo "geno05 " $inds " " $inds100 "" $tags " " $tags100 " " $snps  " " $snps100  >> population_stats.txt

#remove snps with less than 0.05 maf data
plink --noweb --file  R90.plink_mind75_geno05 --maf 0.05 --out R90.plink_mind75_geno05_maf05 --recode
plink --noweb --file  R90_100bp.plink_mind75_geno05 --maf 0.05 --out R90_100bp.plink_mind75_geno05_maf05 --recode

#count missing data for inds and snps
plink --noweb --file  R90.plink_mind75_geno05_maf05 --out R90.plink_mind75_geno05_maf05  --missing --allow-no-sex
plink --noweb --file  R90_100bp.plink_mind75_geno05_maf05 --out R90_100bp.plink_mind75_geno05_maf05  --missing --allow-no-sex

inds="$(grep -v "#" R90.plink_mind75_geno05_maf05.ped | wc -l | cut -d " " -f 1)"
inds100="$(wc -l R90_100bp.plink_mind75_geno05_maf05.ped | cut -d " " -f 1)"
tags="$(grep -v "#"  R90.plink_mind75_geno05_maf05.map|cut -f 2| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
tags100="$(cut -f 2 R90_100bp.plink_mind75_geno05_maf05.map| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
snps="$(cut -f 2 R90.plink_mind75_geno05_maf05.map|wc -l | cut -d " " -f 1)"
snps100="$(wc -l R90_100bp.plink_mind75_geno05_maf05.map| cut -d " " -f 1)"
echo "maf05 " $inds " " $inds100 "" $tags " " $tags100 " " $snps  " " $snps100  >> population_stats.txt


rm -f SNPs.txt
rm -rf nbSNPsexcluded.txt

echo "pop" "HWEexcluded" "HWEexcluded-100bp" > nbSNPsexcluded.txt

for p in $pops; do

        awk -v p="$p" '($1 == p)' R90.plink_mind75_geno05_maf05.ped > ${p}.ped
        awk -v p="$p" '($1 == p)' R90_100bp.plink_mind75_geno05_maf05.ped > ${p}_100bp.ped
        cp R90.plink_mind75_geno05_maf05.map ${p}.map
        cp R90_100bp.plink_mind75_geno05_maf05.map ${p}_100bp.map
        plink --noweb --file ${p} --hwe 0.05 --out ${p}_hwe05 --recode  
        plink --noweb --file ${p}_100bp --hwe 0.05 --out ${p}_100bp_hwe05 --recode  
        cat ${p}_hwe05.map  R90.plink_mind75_geno05_maf05.map | sort | uniq -u | sed 's/ \+/\t/g' | cut -f 2 > ${p}_excluded.txt
        cat ${p}_100bp_hwe05.map  R90_100bp.plink_mind75_geno05_maf05.map | sort | uniq -u | sed 's/ \+/\t/g' | cut -f 2 > ${p}_100bp_excluded.txt
        exc="$(wc -l ${p}_excluded.txt | cut -d " " -f 1)"
        exc100="$(wc -l ${p}_100bp_excluded.txt | cut -d " " -f 1)"
        echo $p $exc $exc100 >> nbSNPsexcluded.txt
        rm -rf ${p}.ped ${p}.map ${p}_hwe05.* ${p}_100bp.ped ${p}_100bp.map ${p}_100bp_hwe05.*

done

cut -d " " -f 2 R90.plink_mind75_geno05_maf05.ped > s
cut -d " " -f 1 R90.plink_mind75_geno05_maf05.ped > p
paste s p > popmap_mind75
rm -rf s p

cut -d " " -f 2 R90_100bp.plink_mind75_geno05_maf05.ped > s
cut -d " " -f 1 R90_100bp.plink_mind75_geno05_maf05.ped > p
paste s p > popmap_100bp_mind75
rm -rf s p

cut -f 2 R90.plink_mind75_geno05_maf05.map | sed -E s/"_"/"\t"/g >R90.plink_mind75_geno05_maf05.txt
cut -f 2 R90_100bp.plink_mind75_geno05_maf05.map | sed -E s/"_"/"\t"/g > R90_100bp.plink_mind75_geno05_maf05.txt

populations -P $indir -M popmap_100bp_mind75 -O $outdir  --whitelist R90_100bp.plink_mind75_geno05_maf05.txt --genepop --structure --plink 

rename s/populations//g *

plink --noweb --file  SNPs_100bp --out SNPs_100bp  --missing --allow-no-sex
tr -s ' ' < SNPs_100bp.imiss | cut -d " " -f 7 | sort -g | tail -n 10
tr -s ' ' < SNPs_100bp.lmiss | cut -d " " -f 6 | sort -g | tail -n 10

populations -P $indir -M $poploc -O $outdir  --write-single-snp --whitelist  SNPs_mind75_geno05_maf05_100bp.txt --genepop --structure --plink  

rename s/populations/SNPs_100bp_oneSNP/g *

shuf SNPs_mind75_geno05_maf05_100bp.txt | head -2000 > SNPs_mind75_geno05_maf05_100bp_2k.txt

populations -P $indir -M $poploc -O $outdir  --write-single-snp --whitelist  SNPs_mind75_geno05_maf05_100bp_2k.txt --genepop --structure --plink  

rename s/populations/SNPs_100bp_oneSNP_2k/g *