
##paried-ends reads QC

module load miniconda3/latest
##trim off end N/Xs
source activate bioperl

perl /share/software/ngsqctookit/ngsqctoolkit-2.3.3/Trimming/AmbiguityFiltering.pl -i $1 -irev $2 -t5 -t3 -n 75
mv $1_trimmed out_1_EndNsTrimmed_1.fastq
mv $2_trimmed out_1_EndNsTrimmed_2.fastq

conda deactivate

#!/bin/bash
##trim off low quality end bases 
## change the -qf format
source activate flexbar-3.5.0

flexbar -r out_1_EndNsTrimmed_1.fastq -p out_1_EndNsTrimmed_2.fastq -qf sanger -qt 30 -q WIN -u 0 -m 75 -n 64 -t out_2_QualTrimmedWIN
flexbar -r out_2_QualTrimmedWIN_1.fastq -p out_2_QualTrimmedWIN_2.fastq -qf sanger -qt 30 -q TAIL -m 75 -n 64 -t out_3_QualTrimmedTAIL
    
##adaptor removal
flexbar -r out_3_QualTrimmedTAIL_1.fastq -p out_3_QualTrimmedTAIL_2.fastq -m 75 -a /lomi_home/gaoyang/meta_MAG_workdir/pipeline/QC_material/adapter1.fasta -a2 /lomi_home/gaoyang/meta_MAG_workdir/pipeline/QC_material/adapter2.fasta -ao 1 -at RTAIL -n 64 -t out_4_AdapterTrimmedRTAIL
flexbar -r out_4_AdapterTrimmedRTAIL_1.fastq -p out_4_AdapterTrimmedRTAIL_2.fastq -m 75 -a /lomi_home/gaoyang/meta_MAG_workdir/pipeline/QC_material/adapter1.fasta -a2 /lomi_home/gaoyang/meta_MAG_workdir/pipeline/QC_material/adapter2.fasta -ao 1 -at RIGHT -n 64 -t out_5_AdapterTrimmedRIGHT    

##trim off low quality end bases  
## change the -qf format
flexbar -r out_5_AdapterTrimmedRIGHT_1.fastq -p out_5_AdapterTrimmedRIGHT_2.fastq -qf sanger -qt 30 -q TAIL -m 75 -n 64 -t out_6_QualTrimmedTAIL

##adaptor filteringngs_adapteradapter1.fasta
flexbar -r out_6_QualTrimmedTAIL_1.fastq -p out_6_QualTrimmedTAIL_2.fastq -b /lomi_home/gaoyang/meta_MAG_workdir/pipeline/QC_material/ngs_adapter.fasta -be 0.1 -bt ANY -bu -n 64 -t out_7_AdapterFiltered

conda deactivate

##quality filtering,
    
source activate skewer
skewer -f sanger -Q 30 -x AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -y AGATCGGAAGAGCGTCGTGTAGGGAAAGA -l 75 -t 64 -o out_8_QualFiltered out_7_AdapterFiltered_barcode_unassigned_1.fastq out_7_AdapterFiltered_barcode_unassigned_2.fastq

conda deactivate
    


##read renaming
source activate seqtk
BASE=${1%%_*}
seqtk rename out_8_QualFiltered-trimmed-pair1.fastq `echo ${BASE}` > ${BASE}_clean_1.fq
seqtk rename out_8_QualFiltered-trimmed-pair2.fastq `echo ${BASE}` > ${BASE}_clean_2.fq
conda deactivate

#mv out_8_QualFiltered-trimmed-pair1.fastq $1_clean_1.fq
#mv out_8_QualFiltered-trimmed-pair2.fastq $2_clean_2.fq

#mv   $EXAMPLE_clean_?.fq ../

#source activate idba-ud
#fq2fa --merge --filter ../$EXAMPLE_clean_1.fq ../$EXAMPLE_clean_2.fq ../$EXAMPLE_clean.fa

rm -rf out*
