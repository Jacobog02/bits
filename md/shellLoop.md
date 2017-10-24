## Shell loop

Quick code chunk for looping over the contents of a file line-by-line
by reading it in and replacing the new line with a space.

Subsequently runs a shell script for each element.

```
#!/bin/bash

NAMES=$(cat $1 |tr "\n" " ")

for NAME in $NAMES
do
echo $NAME
bsub -q normal sh split.sh $NAME
done
```

<br><br>
