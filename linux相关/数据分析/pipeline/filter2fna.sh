#!/bin/bash
#PBS -N fnaGnr_NPG
#PBS -l nodes=c004:ppn=32
workdir=/lomi_home/gaoyang/microplastic_test/bioplastic_PRJEB15404/metagenome_illumina
cd $workdir

threads=32

source /lomi_home/gaoyang/miniconda/bin/activate base

mkdir -p ./fna2KGnr && cd $_
ln -s ../2_assembly/*.fa .

#filter 2k
for i in *.fa
do
seqmagick convert --min-length 2000 ${i} ${i%%.fa}_2K.fa
done


#prodigal_fna
for file in *_2K.fa
do
prodigal -c -m -p meta -i ${file} -a ${file%%.fa}_protein.faa -d ${file%%.fa}.fna
done

rm *contigs.fa
mkdir ../2_assembly_fna && mv *.fna ../2_assembly_fna/
mkdir ../2_assembly/2K_filter && mv ./*.fa ../2_assembly/2K_filter && mkdir ../2_assembly/faa && mv ./*.faa ../2_assembly/faa

conda deactivate 



