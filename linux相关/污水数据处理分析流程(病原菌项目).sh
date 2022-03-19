污水数据处理分析流程(病原菌项目)

#从accession中提取.fastq文件
# ctrl+z暂停并放置后台
# bg命令将放置后台的job继续开始
export PATH=$PATH:/share/software/sratoolkit/sratoolkit-2.9.6/bin && \
nohup fastq-dump --split-3 * \
-O /data2/gaoyang_tmp/wastewater/influent/2019_NC_Global_monitoring_urban_sewage/data_extraction_fastq

# 对所有数据进行数据质控

# 选取同一污水厂的测序数据进行拼接


# 对同一污水厂的数据进行binning

#阶段1-生成cleanreads

#!/bin/bash
#PBS -N cleanreads
#PBS -l nodes=c006:ppn=32

workdir=/lomi_data/lomi_external/wwtp_global_2014jun-2015jul/workdir
cd $workdir

threads=32
name='test'

mkdir -p ${name}/read_QC && cd $_

##get rawdata
ln -s /lomi_data/lomi_external/wwtp_global_2014jun-2015jul/metagenome_illumina/0_extra_fq/test1/* .

##QC
#covert format

for i in *fq
do
python /share/pipelines/tools/CONVERT_FastQFastA_to_FastQStd.py -s $i -c N
done

#paired-end QC

for i in *_1.fq
do
BASE=${i%%_*}
reads_1=${BASE}_1.fq
reads_2=${BASE}_2.fq
/lomi_home/gaoyang/meta_MAG_workdir/influent_treat/QC_material/paired-end.sh $reads_1 $reads_2
done

##assess QC results

mkdir ../clean_reads && cd $_
mv ../read_QC/*clean*fq .

export PATH=$PATH:/share/software/miniconda/miniconda3-latest/envs/fastqc-0.11.8/bin

for i in *1.fq
do
BASE=${i%%_*}
mkdir ${BASE}_post-QC_report
reads_1=${BASE}_clean_1.fq
reads_2=${BASE}_clean_2.fq
fastqc -q -t $threads -o ${BASE}_post-QC_report -f fastq $reads_1 $reads_2 
done
