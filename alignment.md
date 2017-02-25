# Align multiple single-end reads to bowtie mm10 reference genome and produce bam files:
```
SAMPLES="SRR185879 SRR185880"

for SAMPLE in $SAMPLES
do
bowtie2 -x /data/aryee/pub/genomes/mm10/bt2/mm10 -U "${SAMPLE}_1.fastq.gz" | samtools view -bS - > "${SAMPLE}.bam"
done
```

## Note: You can't just `bsub` the alignement with bowtie as some of the arguments will be parsed; stick this puppy in a shell script.

## Note: Path for mm9 bowtie reference genome is `/data/aryee/pub/genomes/bowtie2_index_mm9/mm9`
