################################################           
# Load and prep data
################################################
suppressPackageStartupMessages({
  library(tidyverse)
})

out_dir <- "~/eQTL"
pheno <- "~/eQTL/GE_matrix_genotype_mean_eqtl_rc5.tsv.gz"
snpmat <- "~/eQTL/SwAsp_SNPmat_fastJT.rds"

# Load
pheno_dat <- read.delim(pheno, row.names = 1) %>% 
  t() %>% 
  as.data.frame() %>%   
  rownames_to_column("Genotype") %>% 
  mutate("Genotype" = str_remove(Genotype, "SWASP_"))
geno_feature <- readRDS(snpmat)

# Pheno/geno matching 
common_geno <- intersect(pheno_dat$Genotype, rownames(geno_feature))
pheno_dat <- pheno_dat[pheno_dat$Genotype %in% common_geno,]
geno_feature <- geno_feature[match(common_geno, rownames(geno_feature)),]
stopifnot(identical(rownames(geno_feature), as.character(pheno_dat$Genotype)))
pheno_dat <- column_to_rownames(pheno_dat, var = "Genotype")
pheno_dat <- pheno_dat[, sapply(pheno_dat, var) > 0] 

# Make array file for sbatch 
array_df <- data.frame(Gene = colnames(pheno_dat))
array_df$BatchNr <- rep(1:ceiling(nrow(array_df)/40), each = 40)[1:nrow(array_df)]
array_df <- array_df %>% group_by(BatchNr) %>% mutate(ArrayTaskID = rep_len(1:40, length.out = n()))

# Save output
write_tsv(array_df, file.path(out_dir, "Array4eQTL.tsv"))
save(pheno_dat,geno_feature, file = file.path(out_dir, "SwAsp_SNP_gene_expression.RData"))
