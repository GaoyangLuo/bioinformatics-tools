#!/bin/bash
#PBS -N sourcetrack2
#PBS -l nodes=c001:ppn=32

workdir=/lomi_home/st_test/AUS
cd $workdir 

export PATH=$PATH:/lomi_home/gaoyang/miniconda/bin
source ~/.bashrc

conda activate st2

# check whether gibbs can work
sourcetracker2 gibbs --help

# make up a directory for result checking
mkdir sourcetracker_Results && cd $_

# quit st2 environment
conda deactivate



