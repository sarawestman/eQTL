# PREP SNP data (i.e. remove unnecessary columns)

## Take a look at the data 
cut -f1-7 SwAsp_AfterBatchRemoval_Het.MAF.HWE.recode.vcf.SNPmat.raw

## Check nr of columns 
awk '{print NF}' SwAsp_AfterBatchRemoval_Het.MAF.HWE.recode.vcf.SNPmat.raw | sort -nu | tail -n 1 # 6806723

## Check that you have selected the right columns for removal
cut -f1-7 SwAsp_AfterBatchRemoval_Het.MAF.HWE.recode.vcf.SNPmat.raw | awk '{$1=$3=$4=$5=$6=""; print $0}'

## Make the final SNP matrix by removing unnecessary columns
awk '{$1=$3=$4=$5=$6=""; print $0}' SwAsp_AfterBatchRemoval_Het.MAF.HWE.recode.vcf.SNPmat.raw  > SwAsp_SNPmat_vcf.tsv

## Check that the final data is OK 
awk '{ print $1, $2, $3 }' SwAsp_SNPmat_vcf.tsv

awk '{print NF}' SwAsp_SNPmat_vcf.tsv | sort -nu | tail -n 1 #6806723 - 6806718 = 5 columns removed 

awk '{ print $1, $2, $3 }' SwAsp_SNPmat_vcf.tsv | wc -l # 100 rows (inc. colnames)


