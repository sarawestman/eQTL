#!/bin/bash

#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 24:00:00
#SBATCH --mem 60GB
#SBATCH --mail-type FAIL
#SBATCH --mail-user=sara.westman@umu.se
#SBATCH --account u2015011

awk ' BEGIN { first = 1; last = 6806718} { for (i = first; i < last; i++) { printf("%s ", $i) } print $last }' /mnt/picea/projects/aspseq/nstreet/swasp/Sara/GWAS_ML/data/SNPs/SNPmat_for_fastJT/raw_data/SwAsp_SNPmat_vcf.tsv > /mnt/picea/projects/aspseq/nstreet/swasp/Sara/GWAS_ML/data/SNPs/SNPmat_for_fastJT/raw_data/SwAsp_SNPmat.tsv