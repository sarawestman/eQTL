#######################################################################
# runfastJT 
#######################################################################
# Package names
suppressPackageStartupMessages({
  library(fastJT)
  library(vroom)
  library(tidyverse)
  library(utils)
})

# Extract arguments 
args <- commandArgs(trailingOnly = TRUE)

################################################           
# Set parameters 
################################################
# Direct the arguments
my_gene <- args[1]

out_dir <- "/proj/naiss2023-2-17/chemotypes/res"
pheno_snp_file <- "/proj/naiss2023-2-17/chemotypes/data/SwAsp_SNP_gene_expression.RData"
file_name <- paste0(my_gene, "_fastJT")

################################################           
# Check assumptions before proceeding 
################################################
if (length(args) != 1) {
  stop("Gene name must be supplied", call.=FALSE)
} 

if(!dir.exists(out_dir)){
  stop(paste("Output directory does not exist:", out_dir))
} else{
  message("Arguments provided")
  message(paste("\tOutput directory:", out_dir))
  message(paste("\tPhenotype and SNP data:", pheno_snp_file))
  message(paste("\tFile prefix:", file_name))
  message(paste("\tGene:", my_gene))
}

################################################           
# Load and prep data
################################################
# Load
load(pheno_snp_file)

# Subset gene column 
pheno_dat <- pheno_dat %>% dplyr::select(all_of(my_gene)) %>% as.matrix()

################################################           
# Run fastJT
################################################
fastJT_res <- fastJT(Y = pheno_dat, X = geno_feature, outTopN = NA) %>% pvalues()

# Adjust for multiple testing and filter pvalue < 0.05
fastJT_res_fdr <- lapply(colnames(fastJT_res), function(x){
  my_res <- fastJT_res %>% as.data.frame() %>% dplyr::select(all_of(x))
  my_res %>% mutate(fdr = p.adjust(.data[[x]], method = "fdr")) %>% 
    dplyr::filter(.data[[x]] < 0.05) %>% rownames_to_column(., var = "snp")
})
names(fastJT_res_fdr) <- colnames(fastJT_res)

################################################           
# Save data 
################################################
write_tsv(fastJT_res_fdr[[1]], file = gzfile(file.path(out_dir, paste0(file_name, ".tsv.gz"))))

#######################################################################
# Save session info
#######################################################################
writeLines(capture.output(sessionInfo()), con = file.path(out_dir, paste("sessionInfo",Sys.Date() ,".txt", sep="")))
message("Done")
