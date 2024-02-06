#!/bin/bash -l

#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 12:00:00
#SBATCH -A u2015011

set -eu

module load bioinfo-tools plink

plink --vcf /mnt/picea/projects/aspseq/nstreet/swasp/gwas/data/SwAsp_AfterBatchRemoval_Het.MAF.HWE.recode.vcf.gz --recode A tab -out /mnt/picea/projects/aspseq/nstreet/swasp/Sara/GWAS_ML/data/SNPs/SwAsp_AfterBatchRemoval_Het.MAF.HWE.recode.vcf.SNPmat