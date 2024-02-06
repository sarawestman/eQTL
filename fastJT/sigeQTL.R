library(tidyverse)

# Load file names
my_files <- list.files("/proj/XXXXXX/chemotypes/res", pattern = "_fastJT.tsv.gz", full.names = TRUE)

# Filter data based on fdr < 0.05
res_sig <- lapply(my_files, function(i){
  dat <- read.delim(i) %>% dplyr::filter(fdr < 0.05)
})
names(res_sig) <- str_remove(basename(my_files), "_fastJT.tsv.gz")

# Remove empty elements in list 
res_sig_final <- res_sig[lapply(res_sig,nrow)>0]

# Save data 
saveRDS(res_sig_final, file = "/proj/XXXXXX/chemotypes/res/eQTL_fastJT_sig_res.rds")

