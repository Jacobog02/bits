# Running NucleoATAC
e.g. on ImmGen data

### Activate virtual environment with install
```
[cl322@rgs13 NucleoATAC]$ pwd
/data/aryee/caleb/NucleoATAC/NucleoATAC
[cl322@rgs13 NucleoATAC]$ source venv/bin/activate
```

### Submit job to ErisOne with 4 cores

```
SAMPLE="LTHSC.34+.BM.rep1"
bsub -q big-multi -n 4 nucleoatac run --bed /data/aryee/caleb/ImmGen/ImmGen_1kbSlop_merged.bed --bam "/data/aryee/caleb/ImmGen/all_bams/${SAMPLE}.bam" --fasta /data/aryee/caleb/ImmGen/mm10.fa --out "/data/aryee/caleb/NucleoATAC/ImmGen/${SAMPLE}" --cores 4
```

Above, we have just one sample. Here's for (most) of the T cell differentiation:

```
SAMPLES="LTHSC.34-.BM.rep1 MMP3.48+.BM.rep1 MMP4.135+.BM.rep1 preT.DN2a.Th.rep1 T.DN4.Th.rep1 T.ISP.Th.rep1 T.DP.Th.rep1 T.4.Th.rep1 T.4.Nve.Sp.rep1 Treg.4.25hi.Sp.rep3 Treg.4.FP3+.Nrplo.Co.rep1 T.8.Th.rep1 T.8.Nve.Sp.rep2 NKT.Sp.rep3"
for SAMPLE in $SAMPLES
do
bsub -q big-multi -n 4 nucleoatac run --bed /data/aryee/caleb/ImmGen/ImmGen_1kbSlop_merged.bed --bam "/data/aryee/caleb/ImmGen/all_bams/${SAMPLE}.bam" --fasta /data/aryee/caleb/ImmGen/mm10.fa --out "/data/aryee/caleb/NucleoATAC/ImmGen/${SAMPLE}" --cores 4
sleep 5 
done
```

Where those samples were provided by Hide
