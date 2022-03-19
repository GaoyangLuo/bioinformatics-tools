#!/bin/bash

workdir=/lomi_home/gaoyang/microplastic_test/dashariver/metagenome_illunina/metaphlan_result
cd $workdir

ln -s /lomi_home/gaoyang/microplastic_test/dashariver/metagenome_illunina/work/clean_reads/* .

rm PW*

source ~/miniconda/bin/activate metaphlan_env

for i in *_1.fq
do
base=${i%%_clean*}
reads_1=${base}_clean_1.fq
reads_2=${base}_clean_2.fq
bash /share/pipelines/tools/SEQMODIFY_FASTQ_combine_end_files.sh $reads_1 $reads_2 ${base}_clean_merge.fq
done

for i in *merge.fq
do
base=${i%%_clean*}
metaphlan --input_type fastq --nproc 20 --unknown_estimation --bowtie2db /lomi_home/gaoyang/db/bowtie2 --bowtie2out ${base}_metagenome.bowtie2.bz2 --add_viruses ${base}_clean_merge.fq -o ${base}_clean_merge_clean_profile_metaphlan3.txt

mkdir merge && mv *merge* merge
mkdir mpa_result && mv *.txt mpa_result
mkdir bowtie2out && mv *.bz2 bowtie2out
