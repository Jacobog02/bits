#!/bin/bash
SAMPLES="B10_S25 B2_S23 B8_S24 Bulk_1_S21 Bulk_2_S22 C11_S27 C9_S26 D2_S28 D6_S29 E4_S30 E8_S31 G10_S34 G3_S32 G5_S33 Sample_10_S9 Sample_11_S10 Sample_12_S11 Sample_13_S12 Sample_14_S13 Sample_15_S14 Sample_16_S15 Sample_17_S16 Sample_18_S17 Sample_19_S18 Sample_1_S1 Sample_20_S19 Sample_21_S20 Sample_2_S2 Sample_3_S3 Sample_4_S4 Sample_6_S5 Sample_7_S6 Sample_8_S7 Sample_9_S8"

for sample in $SAMPLES
do 
echo $sample
bsub -q normal sh do.sh $sample
sleep 1
done
