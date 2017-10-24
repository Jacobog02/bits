## Extract nuclear / mito reads
Given an input `.bam` file, 
split into two files 1) all nuclear reads 2) all mitochondrial reads.

```
#!/bin/bash

name=$1

samtools view -b "${name}.st.bam" chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX > "nuclearbam/${name}.proatac.bam"
samtools view -b "${name}.st.bam" chrM > "mitobam/${name}.mito.bam"

```

<br><br>
