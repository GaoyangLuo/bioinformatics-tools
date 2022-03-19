#!/bin/bash
#PBS -N QC_assembly_K-Swed
#PBS -l nodes=c006:ppn=16

# mkdir raw_data && cd $_
# move rawdata to a independent director
'''
while read i
do
cp /lomi_home/gaoyang/Result-X101SC19092528_Z02_J014_B1_3_20201214/01.CleanData/${i}/${i}_*.gz .
done < all_name.list
'''

workdir=/lomi_home/gaoyang/meta_MAG_workdir/as
cd $workdir

threads=16
name='x.bj'

# vi ${name}.list && \
mv *.list ${name}.list && \
echo "${name}.q1" > ${name}.list && \
echo "${name}.q2" >> ${name}.list && \
echo "${name}.q3" >> ${name}.list

# get rawdata
mkdir -p ${name}/read_QC && cd $_
while read i
do
ln -s /lomi_home/gaoyang/Result-X101SC19092528_Z02_J014_B1_3_20201214/01.CleanData/$*/${i}/${i}_*.gz .
done < ${name}.list





