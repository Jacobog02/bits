# Handling mitochondrial reads

## Recommended way with both BAQ and BQ

```
#!/bin/bash

SRR_IDS=$(cat $1 |tr "\n" " ")

for SRR in $SRR_IDS
do
echo $SRR

#SRR=$1

# Align and send to BAM
STAR --genomeDir /data/aryee/pub/genomes/star/hg19_chr/ --readFilesIn "../fastq0/${SRR}_1.fastq.gz" --readFilesCommand zcat --outFileNamePrefix "${SRR}" --outStd SAM | samtools sort - -o "${SRR}.m.bam" && samtools index "${SRR}.m.bam"

# Recalibrate
samtools view -b "${SRR}.m.bam" chrM | samtools calmd -bAr - hg19.fasta > "${SRR}.mito.bam"
samtools view -b "${SRR}.m.bam" chrM > "mito_bq_bam/${SRR}.mito.bam" && samtools index "mito_bq_bam/${SRR}.mito.bam"

# Cleanup
rm ${SRR}Log*
rm ${SRR}SJ.out.tab
rm "${SRR}.m.bam"
rm "${SRR}.m.bam.bai"

# Move
mv "${SRR}.mito.bam" mito_baq_bam
samtools index "mito_baq_bam/${SRR}.mito.bam"
done

```

## Extract nuclear / mito reads -- OLD WAY
Given an input `.bam` file, 
split into two files 1) all nuclear reads 2) all mitochondrial reads.

```
#!/bin/bash

name=$1

samtools view -b "${name}.st.bam" chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX > "nuclearbam/${name}.proatac.bam"
samtools view -b "${name}.st.bam" chrM > "mitobam/${name}.mito.bam"

```

<br><br>
