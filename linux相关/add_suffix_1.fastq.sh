#!/bin/bash

# add_suffix_1.fastq

for name in *.fq1
do
mv ${name}  ${name%%_*}_1.fastq
mv ${name%%_*}_350.fq2 ${name%%_*}_2.fastq
done
