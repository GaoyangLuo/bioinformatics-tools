export PATH="/root/binning/software/BWA/bwa-0.7.17:$PATH"
export PATH="/root/binning/software/samtools/samtools-1.13:$PATH"
export PATH="/root/binning/software/metabat2/metabat:$PATH"
export PATH="/root/software/miniconda3/bin:$PATH"

#創建自己工作目錄
cd /data/binning
mkdir 自己工作目錄ID
cd 自己工作目錄ID
mkdir clean_data
ln -fs /root/binning/clean_data/* /data/binning/Stu01/clean_data/.
mkdir workspace
cd workspace
#bwa index
bwa index -a is ../clean_data/final_Scaftigs.fasta -p index
#bwa mem
bwa mem -t 10 -a index ../clean_data/S.clean_R1.fastq.gz ../clean_data/S.clean_R2.fastq.gz > S_final.sam
bwa mem -t 10 -a index ../clean_data/B.clean_R1.fastq.gz ../clean_data/B.clean_R2.fastq.gz > B_final.sam
# 格式转换：SAM > BAM
time samtools view -@ 16 -b -S S_final.sam -o S_final.bam
time samtools view -@ 16 -b -S B_final.sam -o B_final.bam
rm S_final.sam B_final.sam
#BAM排序
samtools sort -@ 16 -l 9 -O BAM S_final.bam -o S_final.sorted.bam
samtools sort -@ 16 -l 9 -O BAM B_final.bam -o B_final.sorted.bam
#計算Contig深度
time jgi_summarize_bam_contig_depths --outputDepth final.depth.txt *final.sorted.bam
# metabat2
mkdir bins
metabat2 -i ../clean_data/final_Scaftigs.fasta -o bins/metabat2 --numThreads 15 --unbinned -a final.depth.txt --sensitive
#checkm
#conda activate binning
#conda activate /root/software/miniconda3/envs/binning
source /root/software/miniconda3/etc/profile.d/conda.sh
conda activate binning
checkm lineage_wf -t 12 -x fa --nt --tab_table -f metabat.lineage_wf.txt bins check_temp_out
# good bins
python3 /root/binning/software/filter_bins_by_checkM.py -d bins -o good_bins -i metabat.lineage_wf.txt -x ".fa" -c 50 -n 20 -s 0
# gtdbtk 物种分类注释
source activate gtdbtk-1.3.0
gtdbtk classify_wf
# checkm数据库位置(自设数据库)
/root/binning/software/checkm/checkm_data_2015_01_16

