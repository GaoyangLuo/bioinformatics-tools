#############################
#  一、软件安装            #
#############################
#安装纳米孔数据分析软件
#1安装guppy，需要官网购买仪器注册用户下载
#CPU版本：
wget https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy-cpu_4.2.2_linux64.tar.gz
#GPU版本：
wget https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy_4.2.2_linux64.tar.gz
tar -zxvf ont-guppy_4.2.2_linux64.tar.gz

#2 安装nanoplot
conda create -n nanoplot -y nanoplot

#3安装filtlong
git clone https://github.com/rrwick/Filtlong.gitcd Filtlong
make -j

4、安装bioconda
#下载biconda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  
#安装
sh Miniconda3-latest-Linux-x86_64.sh  
source ~/.bashrc
#添加软件源
conda config --add channels bioconda 
conda config --add channels conda-forge

#5 基因组拼接软件
conda install -y minimap2 flye miniasm canu  
conda install -y spades

#6 拼接结果统计
conda install -y quast
conda install -y busco

#7拼接结果纠错
#medaka网址：https://github.com/nanoporetech/medaka
conda create -y -n medaka -c conda-forge -c bioconda medaka

#pilon网址：https://github.com/broadinstitute/pilon/
wget https://github.com/broadinstitute/pilon/releases/download/v1.23/pilon-1.23.jar

#rocon网址：https://github.com/isovic/racon
git clone --recursive https://github.com/lbcb-sci/racon.git racon
cd racon
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make

#8 基因序列分析
conda install -y prodigal glimmer augustus trf

#9安装 busco
#软件官网：https://gitlab.com/ezlab/busco
#数据库下载：https://www.orthodb.org/?page=filelist
#数据库下载：https://busco-data.ezlab.org/v4/data/lineages/
git clone https://gitlab.com/ezlab/busco.git
python3 setup.py install
#建议使用bioconda安装
conda create -n busco busco

#配置数据库
mkdir -p ~/database/BUSCO/
cd ~/database/BUSCO/
# 下载
wget -c https://busco-data.ezlab.org/v4/data/lineages/mammalia_odb10.2020-09-10.tar.gz
# 解压文件
tar -xzvf embryophyta_odb9.tar.gz

#修改配置文件
export BUSCO_CONFIG_FILE="/path/to/myconfig.ini"

#10 安装eggnog-mapper
#软件安装：
git clone https://github.com/jhcepas/eggnog-mapper.git
#下载数据库，比较慢
download_eggnog_data.py -y

#############################
#  二、数据下载             #
#############################

#1 安装sratools
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.10.8/sratoolkit.2.10.8-centos_linux64.tar.gz
tar -zxvf sratoolkit.2.10.8-centos_linux64.tar.gz 

#2 安装aspera
wget https://download.asperasoft.com/download/sw/connect/3.9.9/ibm-aspera-connect-3.9.9.177872-linux-g2.12-64.tar.gz
tar -zxvf ibm-aspera-connect-3.9.9.177872-linux-g2.12-64.tar.gz
sh ibm-aspera-connect-3.9.9.177872-linux-g2.12-64.sh

#3 下载数据
#链接地址
#https://www.ncbi.nlm.nih.gov/bioproject/PRJNA422511

#下载illumina数据
prefetch SRR8482586 -O ./ -o illumina.sra
fastq-dump --split-files --gzip illumina.sra
#下载pacbio数据
prefetch SRR8494912 -O ./ -o pacbio.sra
fasterq-dump pacbio.sra
#下载nanopore数据
prefetch SRR8494939 -O ./ -o nanopore.sra
fasterq-dump nonopore.sra
gzip nanopore.fastq

#4 基因组下载
#Klebsiella pneumoniae MGH78578
#基因组： NC_009648.1 
https://www.ncbi.nlm.nih.gov/nuccore/NC_009648.1/
#质粒： NC_009649.1
https://www.ncbi.nlm.nih.gov/nuccore/NC_009649

#############################
#  三、数据处理              #
#############################
#1 basecalling
guppy_basecaller -i fast5/ -s fastq/ --config dna_r9.4.1_450bps_hac.cfg -r  -x cuda:all --trim_barcodes --barcode_kits SQK-RBK004 --min_score 60

#2 数据质控过滤
#激活nanoplot环境
conda activate nanoplot
#NanoPlot质控
NanoPlot --fastq MGH78578/nanopore.fastq.gz -o nanoplot

#3 过滤数据
filtlong --min_length 1000 --min_mean_q 90 MGH78578/nanopore.fastq.gz |  gzip >clean.filtlong.fq.gz

#4 过滤完质控
NanoPlot --fastq clean.filtlong.fq.gz -o clean
conda deactivate

 
#############################
#  四、基因组拼接             #
#############################
flye --nano-raw  ../2.qc/clean.filtlong.fq.gz  -g 5.4m -o result -t 24 
nohup sh flye.sh &

     
#############################
#  五、拼接结果统计及评估     #
#############################
#seqkit统计fasta文件
seqkit stat assembly.fasta
#分别统计每一条序列长度
seqkit fx2tab assembly.fasta |awk '{print $1"\t"length($2)}'

#quast
/ifs1/Software/biosoft/quast-5.0.2/quast.py -r co92.fna canu.fa miniasm.fa wtdbg2.cns.fa smartdenovo.fa -o quast

#busco
mkdir busco
cd busco
#激活虚拟环境
conda activate busco
#列出数据库
busco --list-datasets
busco -i assembly.fasta -o busco_result -m geno -l bacteria_odb10 -c 20 --offline 


#############################
#  六、拼接结果优化           #
#############################
#medaka
#进入虚拟环境运行
conda activate medaka
#运行软件
medaka_consensus -i clean.filtlong.fq.gz -d assembly.fasta -o medaka_result -m r941_min_high_g360 -v medaka.vcf -t 24 >medaka.log

#pilon
#对拼接结果建立索引
mkdir pilon
ln -s ../medaka/medaka_result/consensus.fasta medaka.fasta
bwa index medaka.fasta

#illumina比对排序建索引
READ1=illumina.sra_1.fastq.gz
READ2=illumina.sra_2.fastq.gz
bwa mem -t 4 -R '@RG\tID:foo\tSM:bar:\tPL:ILLUMINA' medaka.fasta $READ1 $READ2 >illumina.sam
samtools sort -@ 4 -O bam -o illumina.sorted.bam illumina.sam
samtools index illumina.sorted.bam
#利用pilon进行纠错
java -Xmx32G -jar /ifs1/Software/biosoft/pilon/pilon-1.23.jar --genome medaka.fasta --fix all --changes --frags illumina.sorted.bam --output pilon --outdir pilon_result --threads 24 --vcf 2> pilon.log

#racon
mkdir racon
#连接原始拼接结果
DRAFT=../pilon/pilon_result/pilon.fasta
READ=/ifs1/TestDatas/nanopore7/data/MGH78578/clean.filtlong.fq.gz

#minimap2比对
minimap2 -t 4 ${DRAFT} ${READ} > round_1.paf
#racon进行纠错
racon -t 4 ${READ} round_1.paf ${DRAFT} > racon_round1.fasta

#第二轮纠错    
minimap2 -t 4 racon_round1.fasta ${READ} > round_2.paf
racon -t 4 ${READ} round_2.paf racon_round1.fasta> racon_round2.fasta

#第三轮纠错
minimap2 -t 4 racon_round2.fasta ${READ}  > round_3.paf
racon -t 4 ${READ}  round_3.paf racon_round2.fasta> racon_round3.fasta

#将最终结果修改为样品名
mv racon_round3.fasta MGH78578.fasta

#############################
#  七、序列分析             #
#############################
#1 基因预测
#原核生物基因预测 
mkdir gene
cd gene
prodigal -a MGH78578.pep -d MGH78578.cds -f gff -g 11 -o MGH78578.gff -p single -s MGH78578.stat -i ../MGH78578.fasta >prodigal.log 

#基因功能注释
/ifs1/Software/biosoft/eggnog-mapper/emapper.py -i MGH78578.pep --output annotation -m diamond

#3 核糖体RNA预测
mkdir ncrna
cd ncrna
perl /ifs1/Software/biosoft/rnammer-1.2/rnammer -S bac -m tsu,lsu,ssu  -gff MGH78578_rrna.gff -f MGH78578_rrna.frn ../MGH78578.fasta 

#4 转运RNA
/ifs1/Software/miniconda3/bin/tRNAscan-SE  -B  -o tRNAScan.out -f tRNAScan.out.structure -m stat.list ../MGH78578.fasta

#5 串联重复序列分析 
trf ../MGH78578.fasta  2 7 7 80 10 50 500 -f -d -m

#6 RepeatMasker
mkdir repeat 
/ifs1/Software/bin/RepeatMasker -pa 2 -q  -html -gff -dir repeat MGH78578.fasta 
```