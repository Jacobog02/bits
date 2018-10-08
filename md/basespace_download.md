# Download data from basespace

## Find data and download it

The simple way

```
bs dataset list | grep XXX
#bsub -q big bs dataset download --id=ds.e9ac5c93c4da4e9291ef73227ac2d149 --extension=bam -o Exp118s1

```

## Shortcut

Given a datset id, download the bam and untar it

```
dlbsds() {
    # Download basespace dataset and pull out the bam
    x=$RANDOM
    bs dataset download "--id=$1" --extension=bam -o $x
    tar xvzf "${x}.tar.gz"
    rm "${x}.tar.gz"
    rm *"${1}.json"
}
```