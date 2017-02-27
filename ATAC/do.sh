#!/bin/bash
sample=$1

PICARD_DIR="/apps/source/picard-tools-1.84/picard-tools-1.84/"

echo "trim reads"
#parkour -o t -a ${sample}_R1_001.fastq.gz -b ${sample}_R2_001.fastq.gz trim 

bowtie2 -x /data/aryee/pub/genomes/bowtie2_index/hg19 -X 2000 -1 "t.${sample}_R1_001.trim.fastq.gz" -2 "t.${sample}_R2_001.trim.fastq.gz" -S "${sample}.bt2out.sam"

echo "Keep only mapped reads of which quality is more than 5 = unique mapping ..."
samtools view -bS ${sample}.bt2out.sam >  "${sample}.bam"	# keep only mapped reads

echo "Sorting/Indexing" 
samtools sort "${sample}.bam" -o "${sample}_s.bam"
samtools index "${sample}_s.bam"

echo "Keep only the mitochondrial reads"
samtools view -bS "${sample}_s.bam" chrM > "mito.${sample}.bam"

echo "Removing duplicates..."
java -Xmx16g -jar ${PICARD_DIR}/MarkDuplicates.jar INPUT="${sample}_s.bam" OUTPUT="${sample}.clean.bam" METRICS_FILE="${sample}.duplication.metrics.txt" REMOVE_DUPLICATES=true ASSUME_SORTED=true 
samtools index "${sample}.clean.bam"

echo "QC Plots"
java -Xmx16g -jar ${PICARD_DIR}/CollectInsertSizeMetrics.jar VALIDATION_STRINGENCY=SILENT I="${sample}.clean.bam" O="${sample}.insertsizes.log" H="${sample}.insertsizes.pdf"  W=1000
python pyMakeVplot.py -a "${sample}.clean.bam" -b hg19.tss.bed -e 2000 -p ends -v -u -o ${sample}
