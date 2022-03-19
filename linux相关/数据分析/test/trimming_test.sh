#!/bin/bash
for filename in *_1.fastq
do

BASE=$(basename $filename _1.fastq)

reads_1=${BASE}_1.fastq
reads_2=${BASE}_2.fastq

echo ${reads_1}
echo ${reads_2}

/lomi_home/gaoyang/meta_MAG_workdir/pipeline/QC_material/paired-end.sh $reads_1 $reads_2
done
