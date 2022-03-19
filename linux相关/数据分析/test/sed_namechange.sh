#!/bin/bash

for i in */clean_reads/*_1.fastq
do
sed -i "s/_1.fastq//g" $i
sed -i "s/_2.fastq//g" ${i/_1.fastq/}_2.fastq
done
