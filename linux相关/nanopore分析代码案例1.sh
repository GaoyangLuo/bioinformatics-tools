#############################
#   一 Linux学习             #
#############################
mkdir 1218
#查看结果
ll
#切换到1218这个目录
cd 1218

#############################
#   二 Basecalling           #
#############################
cd ~
mkdir 2.basecalling
cd 2.basecalling
#拷贝数据到当前目录下
cp -r /ifs1/TestDatas/nanopore7/data/lambda/* ./
ll
#1 Basecalling
guppy_basecaller -i fast5_files/ -s fastq_files --config dna_r9.4.1_450bps_fast.cfg -r  -x cuda:all
#合并全部fastq并压缩
cat fastq_files/*.fastq | gzip >lambda.fastq.gz

#############################
#     三 barcode            #
#############################
cd ~
mkdir 3.barcode
cd 3.barcode
#basecalling同时拆分barcode
guppy_basecaller -i /ifs1/TestDatas/metagenomics/data/16S/fast5/ -s fastq --config dna_r9.4.1_450bps_hac.cfg -r  -x cuda:all --trim_barcodes --barcode_kits SQK-RBK004 --min_score 10

#basecalling与拆分barcode分布完成
#首先进行basecalling
guppy_basecaller -i /ifs1/TestDatas/metagenomics/data/16S/fast5/ -s fastq --config dna_r9.4.1_450bps_hac.cfg -r  -x cuda:all
#拆分barcode
guppy_barcoder -i  fastq -s barcode --trim_barcodes --barcode_kits SQK-RBK004 --min_score 10

#############################
#  四 纳米孔数据质控与过滤    #
#############################
#1 数据质控
#激活nanoplot环境
conda activate nanoplot

#方法一：NanoPlot质控
NanoPlot --fastq lambda.fastq.gz -o nanoplot
#方法二:对guppy生成的sequencing_summary.txt的绘图
NanoPlot --summary output/sequencing_summary.txt --loglength -o summary

#3 过滤数据
filtlong --min_length 500 --min_mean_q 90 lambda.fastq.gz |  gzip >clean.filtlong.fq.gz
#过滤完质控
NanoPlot --fastq clean.filtlong.fq.gz -o clean
conda deactivate

#4 tablet可视化
#minimap2比对
minimap2 -ax map-ont lambda_ref.fasta clean.filtlong.fq.gz >lambda.sam

#samtools处理
samtools sort -@ 4 -O bam -o lambda.sorted.bam lambda.sam
samtools index lambda.sorted.bam
samtools faidx lambda_ref.fasta

#将文件拷贝至windows下使用tablet可视化
lambda_ref.fasta lambda.fasta.fai lambda.sorted.bam lambda.sorted.bam.bai

#############################
#五 分析纳米孔宏基因组测序数据 #
#############################
#拷贝数据到当前目录下
cp -r /ifs1/TestDatas/nanopore8/data/fast5_files/ ./
#碱基识别
guppy_basecaller -i fast5_files/ -s output --config dna_r9.4.1_450bps_fast.cfg -r -x cuda:all
#合并数据
cat output/*.fastq >mocklog.fastq
#压缩数据
gzip mocklog.fastq

filtlong --min_length 500 --min_mean_q 90 mocklog.fastq.gz | gzip >mocklog.filtlong.fq.gz
#过滤完质控
NanoPlot --fastq mocklog.filtlong.fq.gz -o clean -t 12

#############################
#    六 练习建立索引          #######################建库#####################
#############################
#拷贝练习数据
cp -R /ifs1/TestDatas/nanopore8/index/ ./
#建立索引加前缀test
centrifuge-build --conversion-table gi_to_tid.dmp --taxonomy-tree nodes.dmp --name-table names.dmp test.fa test

#############################
#    七 Centrifuge微生物鉴定  #
#############################
#到gz是输入文件，-s是输出文件 12 是占用资源 2是日志，time是运行多长时间
#用 nohup sh centrfuge.sh & 运行，之后获得report.tsv 过程中可用le nohup.out查看，用top -u 用户名查看自己进程 
time centrifuge -x /ifs1/MetaDatabase/centrifuge_h+p+v_20200318/hpv -U mocklog.filtlong.fq.gz --report-file report.tsv -S result.tsv -p 12 2>centrifuge.log

#新冠病毒样品鉴定
centrifuge -x /ifs1/MetaDatabase/centrifuge_h+v_v2_20200327/hv2 -U SRR11178050.sra.fastq --report-file report.tsv -S result.tsv -p 12
#新命令
time centrifuge -x /ifs1/MetaDatabase/centrifuge_h+v_v2_20200327/hv2 -U /ifs1/TestDatas/nanopore7/data/ncov/ERR4208070.sra.fastq --report-file report.tsv -S result.tsv -p 12

#############################
#    八 筛选过滤结果         #
#############################
awk -F "\t" '{if ($3=="species" && $6 >5) print $1"\t"$6}' report.tsv >report-filter.txt

#############################
#    九 提取reads            #
#############################
TAXNAME="Pseudomonas fluorescens"
TAXID=`grep "$TAXNAME" report.tsv |cut -f 2`
awk -F '\t' -v var=$TAXID '{if ($3==var) print $1}' result.tsv |sort |uniq >id.list

#方法一：
seqtk subseq mocklog.filtlong.fq.gz id.list
#方法二：
seqkit grep -f id.list mocklog.filtlong.fq.gz
#############################
#    十 饱和度评估          #
#############################

#############比较难的部分#############
#10.1 随机抽样
mkdir sample;cd sample
READ=/ifs1/TestDatas/metagenomics/data/PRJEB36155/nanopore/ERR3994080.sra.fastq.gz
seqkit sample -p 0.1 $READ >sample_0.1.fastq
seqkit sample -p 0.3 $READ >sample_0.3.fastq
seqkit sample -p 0.5 $READ >sample_0.5.fastq
seqkit sample -p 0.7 $READ >sample_0.7.fastq

#10.2 填写sample_sheet并分析,复制到一个temp.list
1	sample_0.1.fastq		sample_0.1.result	sample_0.1.report
1	sample_0.3.fastq		sample_0.3.result	sample_0.3.report
1	sample_0.5.fastq		sample_0.5.result	sample_0.5.report
1	sample_0.7.fastq		sample_0.7.result	sample_0.7.report
1	/ifs1/TestDatas/metagenomics/data/PRJEB36155/nanopore/ERR3994080.sra.fastq.gz		sample_1.0.result	sample_1.0.report
#校验
awk '{print $1"\t"$2"\t\t"$3"\t"$4}' temp.list >sample_sheet.list
cat -T sample_sheet.list

centrifuge -x /ifs1/MetaDatabase/centrifuge_h+p+v_20200318/hpv --sample-sheet sample_sheet.list --min-hitlen 100 -p 12

#10.3 合并结果
awk -F "\t" '{if ($3=="species" && $6 >=5) print $1"\t"$6}' sample_0.1.report >0.1.txt
awk -F "\t" '{if ($3=="species" && $6 >=5) print $1"\t"$6}' sample_0.3.report >0.3.txt
awk -F "\t" '{if ($3=="species" && $6 >=5) print $1"\t"$6}' sample_0.5.report >0.5.txt
awk -F "\t" '{if ($3=="species" && $6 >=5) print $1"\t"$6}' sample_0.7.report >0.7.txt
awk -F "\t" '{if ($3=="species" && $6 >=5) print $1"\t"$6}' sample_1.0.report >1.0.txt 
merge_metaphlan_tables.py *.txt >merge.tsv

#############################
#   十一 去宿主              #
#############################
#数据路径
#/ifs1/TestDatas/metagenomics/data/PRJEB30781
mkdir clincal;cd clincal
#去除宿主
REF=/ifs1/MetaDatabase/human/GCF_000001405.39_GRCh38.p13_genomic.fna
READ=/ifs1/TestDatas/metagenomics/data/PRJEB30781/P10.fastq.gz
minimap2 -ax map-ont $REF $READ -Y -N 20 -t 12 >minimap2.sam
samtools fastq -f 4 minimap2.sam | gzip >P10.filter.fq.gz
#统计过滤前后数变化
seqkit stat /ifs1/TestDatas/metagenomics/data/PRJEB30781/P10.fastq.gz P10.filter.fq.gz


#############################
#   十一 临床微生物样本检测   #
#############################
time centrifuge -x /ifs1/MetaDatabase/centrifuge_h+p+v_20200318/hpv -U P10.filter.fq.gz --report-file report.tsv -S result.tsv -p 12 2>centrifuge.log

#############################
#    12 pivian可视化        #
#############################
centrifuge-kreport -x /ifs1/MetaDatabase/centrifuge_h+p+v_20200318/hpv result.tsv >report_kraken.tsv

#############################
#   13 megan可视化           #
#############################
awk -F "\t" '{ print $1"\t"$6}' result.tsv >megan.tsv

#鉴定新冠病毒
time centrifuge -x /ifs1/MetaDatabase/centrifuge_h+v_v2_20200327/hv2 -U /ifs1/TestDatas/nanopore7/data/ncov/ERR4208070.sra.fastq --report-file report.tsv -S result.tsv -p 12

#批量处理
#time centrifuge -x /ifs1/MetaDatabase/centrifuge_h+p+v_20200318/hpv -U mocklog.filtlong.fq.gz --report-file report.tsv -S result.tsv -p 12 2>centrifuge.log