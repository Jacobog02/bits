# Annotate SNPs
Simple workflow for adding rsIDs to a set of SNPs based on hg19 coordinates

Working directory: `/data/aryee/caleb/sankaran/hg19_annotate`

## Download SNP bed files
Download `.bed` files from NCBI
```
# Bash commanes
for i in {1..22}; do wget "ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606_b150_GRCh37p13/BED/bed_chr_${i}.bed.gz"; done
```

## Annotate existing SNP file
Be care to merge based on the appropriate column and/or filtering in the `importDF` function

```
# R commands
library(readxl)
library(rtracklayer)
library(GenomicRanges)
library(data.table)
library(magrittr)

df <- data.frame(read_excel("SupplementalTable1.xlsx"))
gr <- makeGRangesFromDataFrame(df)

# Import PhyloP
phyloP_file <- "hg19.100way.phyloP100way.bw"
pp <- rtracklayer::import.bw(phyloP_file, which = gr, as = "NumericList")
pval <- sapply(pp, function(x) x[2])
df$Phylop_100way <- pval

# Import Bed files of RS IDs
# auto-remove start base pairs that don't exist in DF to keep reasonably sized

importDF <- function(i){
  dt <- data.frame(fread(paste0("zcat < ", "bed_chr_",as.character(i),".bed.gz")))
  return(dt[dt$V3 %in% df$start,])
}
allRSid <- lapply(1:22,importDF) %>% rbindlist() %>% as.data.frame()
colnames(allRSid) <- c("V1", "V2", "V3", "rsID", "V5", "V6")

mdf <- merge(df, allRSid[,c("V1", "V3", "rsID")], by.x = c("chr", "start"), by.y = c("V1", "V3"), all.x = TRUE)

```
