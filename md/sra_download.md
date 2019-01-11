# Downloading SRA files

_Caleb Lareau_, *11 January 2019*

There are two main ways that I've found to achieve fast data retrieval from SRA via Aspera. 

## First way

The SRA maintains an FTP server that hosts most, but not all, of their data. You can 
do a direct download of the .sra file from this FTP server using aspera:

```
ASPERA=/apps/lab/aryee/aspera-connect-3.5.6/
SRR_ID="SRR6806716"

$ASPERA/bin/ascp -i $ASPERA/etc/asperaweb_id_dsa.openssh -T -k 2 -l 400M anonftp@ftp.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/SRR/${SRR_ID:0:6}/${SRR_ID}/${SRR_ID}.sra .
bsub -q normal fastq-dump --split-files --gzip ${SRR_ID}.sra
```

## Second way

I've run into instances where we cannot easily get SRA files from the FTP server (they are missing). 
Consulting with the help desk informed me that `prefetch` may be a more stable route, but the command
requires some tinkering to get large data downloaded via aspera. This is how to do it:

```
SRR_ID="SRR6806716"
prefetch $SRR_ID --max-size 50G -a "/apps/lab/aryee/aspera-connect-3.5.6/bin/ascp|/apps/lab/aryee/aspera-connect-3.5.6/etc/asperaweb_id_dsa.openssh"
```

Note: the `prefetch` route will try to place files in a default local directory that you can 
[change by following these steps](https://www.biostars.org/p/175096/).

<br><br>