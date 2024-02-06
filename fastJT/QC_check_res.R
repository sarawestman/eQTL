# Load data
eQTL_fastJT_sig_res <- readRDS("~/Sara/eQTL/res/fastJT/pre_res/eQTL_fastJT_sig_res.rds")

# Calculate nr of columns (some are for some reason missing the snp names)
sig_genes_coln_list <- lapply(eQTL_fastJT_sig_res, function(x){
  data.frame(Nr_of_col = ncol(x))
})
sig_genes_coln_df <- do.call(rbind.data.frame, sig_genes_coln_list) 

# Redo the genes with missing snp column 
sig_genes_coln2 <- sig_genes_coln_df %>% filter(Nr_of_col == 2)
sig_genes_coln2 <- data.frame(Genes = rownames(sig_genes_coln2))

# Save file 
write_tsv(sig_genes_coln2, file.path("~/Sara/eQTL/res/fastJT/pre_res/genes_fastJT_redo.tsv"))

# Categorize the snps based on chr position 
fastJT_sig <- readRDS("~/eQTL_fastJT_sig_res.rds")
fastJT_sig2 <- lapply(names(fastJT_sig), function(i){
  fastJT_sig[[i]] %>% mutate(Gene = i) %>% dplyr::rename("pval" = i)
})

fastJT_sig_df <- bind_rows(fastJT_sig2)


fastJT_sig_df_info <- fastJT_sig_df %>% mutate(chr = str_extract(snp, "[^chr_]+"),
                                               gene_chr = sub(".*Potra2n(-?[0-9.]+).*", "\\1", Gene),
                                               type = ifelse(str_detect(Gene, "s"), "scaffold", "chr"),
                                               eQTL_type = ifelse(chr == gene_chr, "cis", "trans"),
                                               eQTL_type = ifelse(type == "scaffold", "scaffold", eQTL_type)) 


fastJT_sig_df_info %>% dplyr::filter(eQTL_type != "scaffold") %>% dplyr::select(c(Gene, eQTL_type)) %>% distinct() %>% group_by(Gene) %>% count(Gene) %>% group_by(n) %>% count(n) # 1 = either cis or trans, 2 = both cis and trans 
