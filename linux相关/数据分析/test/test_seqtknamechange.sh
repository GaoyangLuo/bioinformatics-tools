#!/bin/bash

# Using seqtk to change names
module load miniconda3/latest
source activate seqtk

for i in *.fastq
do
BASE=${i%%_*}
echo ${BASE}
seqtk rename ${BASE}_clean_1.fastq `echo ${BASE}` > ${BASE}_clean_1_test.fastq
done

conda deactivate
