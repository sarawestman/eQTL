suppressPackageStartupMessages({
  library(vroom)
  library(tidyverse)
  library(tibble)
})

out_dir <- "/mnt/picea/projects/aspseq/nstreet/swasp/Sara/GWAS_ML/data/SNPs/SNPmat_for_fastJT"
old <- Sys.time()
my_Features <- vroom("/mnt/picea/projects/aspseq/nstreet/swasp/Sara/GWAS_ML/data/SNPs/SNPmat_for_fastJT/SwAsp_SNPmat.tsv", delim = " ")
my_Features <- column_to_rownames(my_Features, var = "IID")
my_Features <- as.matrix(my_Features)
print(my_Features[1:10,1:10])
new <- Sys.time() - old 
print(paste0("Total read and prep time: ", new))

saveRDS(my_Features, file = file.path(out_dir, "SwAsp_SNPmat_fastJT.rds"))