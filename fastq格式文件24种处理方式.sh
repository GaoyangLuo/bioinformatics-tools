#1 获取fastq文件
mkdir fastq
#下载illumina数据
prefetch SRR8651554 -O ./ -o illumina.sra
#下载nanopore数据
prefetch SRR8494939 -O ./ -o nanopore.sra

#2 将sra转为为fastq
fastq-dump --split-files --gzip illumina.sra
fasterq-dump nonopore.sra
gzip nanopore.fastq

#3 压缩与解压缩
#解压缩
gunzip reads_1.fastq.gz
gzip -d  reads_2.fastq.gz
#压缩
gzip reads_1.fastq
gzip reads_2.fastq

#4 fastq文件统计
seqkit stats reads_1.fastq.gz reads_2.fastq.gz

#5 统计fastq文件每条序列ATCG四种碱基组成以及质量值分布
seqtk comp reads_1.fastq.gz reads_2.fastq.gz

#6 ATCG以及质量值分布
seqtk fqchk reads_1.fastq.gz
seqtk fqchk reads_2.fastq.gz

#7 交叉合并pairend文件
seqtk mergepe reads_1.fastq.gz reads_2.fastq.gz >merge.fastq

#8 过滤短的序列
#过滤小于150bp序列，并压缩输出 
seqkit seq -m 150 nanopore.fastq.gz | gzip -  >filter_150.fq.gz
#保留小于150bp序列
seqkit seq -M 150 nanopore.fastq.gz

#8 转换为列表格式
seqkit fx2tab nanopore.fastq.gz

#9分别统计每一条序列长度
seqkit fx2tab nanopore.fastq.gz |awk -F "\t" '{print length($2) }'

#10 质量值转换
#将illumina 1.8转换为1.5
seqkit convert --to Illumina-1.5+ reads_1.fastq.gz |head -4
#将illumina 1.5转换为1.8，什么都不加就是转换为1.8
seqkit convert  reads_illmina1.5.gz

#11 排序，按照长度
seqkit sort -l -r nanopore.fastq.gz

#12 #seqkit抽样，按照百分比
seqkit sample -p 0.1 reads_1.fastq.gz

#13 seqkit抽样，按照条数
seqkit sample -n 1000 reads_1.fastq.gz 

#14 拆分数据
seqkit split2 -1 reads_1.fastq.gz -2 reads_2.fastq.gz -p 2 -f

#15 转换为fasta
#seqkit工具
seqkit fq2fa nanopore.fastq.gz >nanopore.fasta

#16 只输出20行ID
seqkit seq -n -i nanopore.fastq.gz |head -20 >id.list

#17 提取序列
seqkit grep -f id.list nanopore.fastq.gz

#18 截取头尾
seqtk trimfq -b 15 -e 15 -Q reads_1.fastq.gz

#19 修改reads ID
seqkit replace -p "SRR8494939\.sra" -r 'reads'  nanopore.fastq.gz 

#20 长度分布直方图
seqkit watch -L -f ReadLen hairpin.fa

#21 平均质量直方图
seqkit watch -p 500 -O qhist.pdf -f MeanQual nanopore.fastq.gz 

#22 选取固定范围
seqkit range -r 200:300 nanopore.fastq.gz

#23 移除重名序列
seqkit rmdup -n nanopore.fastq.gz  -o clean.fa.gz

#24 将小于Q20的替换为小写字母
seqtk seq -q 20 reads_1.fastq.gz
