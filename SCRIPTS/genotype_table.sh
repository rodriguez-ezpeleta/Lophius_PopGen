
M=4 #small caps
indir=/share/projects/GECKA/stacks_M4
poploc=/share/projects/GECKA/stacks_M4/ALL/BFP_no_med/ALL/popmap_ALL_NoMed
outdir=.

pops="$(cut -f 2 ${poploc} | sort | uniq)"

p="$(cut -f 2 ${poploc} | sort | uniq | wc -l)"

populations -P $indir -M $poploc -O $outdir -p ${p} -R 0.90 --plink



rename s/populations/R90/g *


plink --noweb --file  R90.plink --out R90.plink  --extract R90.txt --allow-no-sex --recode

echo "step inds  tags  snps " > population_stats.txt

# count missing data for inds and snps
plink --noweb --file  R90.plink --out R90.plink  --missing --allow-no-sex


inds="$(grep -v "#" R90.plink.ped | wc -l | cut -d " " -f 1)"
tags="$(grep -v "#"  R90.plink.map|cut -f 2| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
snps="$(cut -f 2 R90.plink.map|wc -l | cut -d " " -f 1)"
echo "catalog090 " $inds " " $tags "  " $snps  "   >> population_stats.txt

#remove inds with more than 0.25 missing data
plink --noweb --file R90.plink  --mind 0.25 --out R90.plink_mind75 --recode --allow-no-sex


#count missing data for inds and snps
plink --noweb --file  R90.plink_mind75 --out R90.plink_mind75  --missing --allow-no-sex


inds="$(grep -v "#" R90.plink_mind75.ped | wc -l | cut -d " " -f 1)"
tags="$(grep -v "#"  R90.plink_mind75.map|cut -f 2| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
snps="$(cut -f 2 R90.plink_mind75.map|wc -l | cut -d " " -f 1)"
echo "mind075 " $inds " " $tags "  " $snps  "  >> population_stats.txt


#remove snps with more than 0.05 missing data
plink --noweb --file R90.plink_mind75  --geno 0.05 --out R90.plink_mind75_geno05 --recode --allow-no-sex


#count missing data for inds and snps
plink --noweb --file  R90.plink_mind75_geno05 --out R90.plink_mind75_geno05  --missing --allow-no-sex


inds="$(grep -v "#" R90.plink_mind75_geno05.ped | wc -l | cut -d " " -f 1)"
tags="$(grep -v "#"  R90.plink_mind75_geno05.map|cut -f 2| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
snps="$(cut -f 2 R90.plink_mind75_geno05.map|wc -l | cut -d " " -f 1)"
echo "geno05 " $inds " " $tags "  " $snps  "  >> population_stats.txt

#remove snps with less than 0.05 maf data
plink --noweb --file  R90.plink_mind75_geno05 --maf 0.05 --out R90.plink_mind75_geno05_maf05 --recode


#count missing data for inds and snps
plink --noweb --file  R90.plink_mind75_geno05_maf05 --out R90.plink_mind75_geno05_maf05  --missing --allow-no-sex


inds="$(grep -v "#" R90.plink_mind75_geno05_maf05.ped | wc -l | cut -d " " -f 1)"
tags="$(grep -v "#"  R90.plink_mind75_geno05_maf05.map|cut -f 2| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
snps="$(cut -f 2 R90.plink_mind75_geno05_maf05.map|wc -l | cut -d " " -f 1)"
echo "maf05 " $inds " " $tags "  " $snps  "  >> population_stats.txt


rm -f SNPs.txt
rm -rf nbSNPsexcluded.txt


echo "pop" "HWEexcluded" > nbSNPsexcluded.txt

for p in $pops; do

        awk -v p="$p" '($1 == p)' R90.plink_mind75_geno05_maf05.ped > ${p}.ped
        
        cp R90.plink_mind75_geno05_maf05.map ${p}.map
        plink --noweb --file ${p} --hwe 0.05 --out ${p}_hwe05 --recode
        cat ${p}_hwe05.map  R90.plink_mind75_geno05_maf05.map | sort | uniq -u | sed 's/ \+/\t/g' | cut -f 2 > ${p}_excluded.txt
        exc="$(wc -l ${p}_excluded.txt | cut -d " " -f 1)"
        echo $p $exc >> nbSNPsexcluded.txt
        rm -rf ${p}.ped ${p}.map ${p}_hwe05.* 

done

#### ONLY ACTIVATE IF WE WANT TO FILTER BY HARDY WEINBERG 

#cat A_excluded.txt B_excluded.txt C_excluded.txt D_excluded.txt E_excluded.txt F1_excluded.txt | sort | uniq -d > SNPs_failMoreThanOnePop.txt

#remove snps not passing hwe 0.05 in more than one pop
#plink --noweb --file  R90.plink_mind75_geno05_maf05 --exclude SNPs_failMoreThanOnePop.txt --out R90.plink_mind75_geno05_maf05_hwe05 --recode


#count missing data for inds and snps
#plink --noweb --file  R90.plink_mind75_geno05_maf05_hwe05 --out R90.plink_mind75_geno05_maf05_hwe05  --missing --allow-no-sex


#inds="$(grep -v "#" R90.plink_mind75_geno05_maf05_hwe05.ped | wc -l | cut -d " " -f 1)"
#tags="$(grep -v "#"  R90.plink_mind75_geno05_maf05_hwe05.map|cut -f 2| cut -d "_" -f 1 | uniq|wc -l | cut -d " " -f 1)"
#snps="$(cut -f 2 R90.plink_mind75_geno05_maf05_hwe05.map|wc -l | cut -d " " -f 1)"
#echo "hwe05 " $inds " " $tags "  " $snps  "   >> population_stats.txt

########################## TILL HERE HW. 

cut -d " " -f 2 R90.plink_mind75_geno05_maf05.ped > s
cut -d " " -f 1 R90.plink_mind75_geno05_maf05.ped > p
paste s p > popmap_mind75
rm -rf s p


cut -f 2 R90.plink_mind75_geno05_maf05.map | sed -E s/"_"/"\t"/g >R90.plink_mind75_geno05_maf05.txt

populations -P $indir -M popmap_mind75 -O $outdir  --whitelist R90.plink_mind75_geno05_maf05.txt --genepop --structure --plink 

rename -f s/populations/R90_mind75_geno05_maf05/g *

populations -P $indir -M popmap_mind75 -O $outdir --write-single-snp --whitelist R90.plink_mind75_geno05_maf05.txt --genepop --structure --plink 

rename -f s/populations/R90_mind75_geno05_maf05_oneSNP/g *

shuf R90.plink_mind75_geno05_maf05.txt | head -2000 > R90_.plink_mind75_geno05_maf05_2k.txt 

populations -P $indir -M popmap_mind75 -O $outdir --write-single-snp --whitelist R90.plink_mind75_geno05_maf05_2k.txt --genepop --structure --plink 

rename -f s/populations/R90_mind75_geno05_maf05_2kSNPs/g *

