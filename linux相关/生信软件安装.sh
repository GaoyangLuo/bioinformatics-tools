#软件官网
http://bioconda.github.io/
#软件搜索
https://anaconda.org/bioconda/repo

#一、安装bioconda

#1下载biconda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  
#2安装
sh Miniconda3-latest-Linux-x86_64.sh  
source ~/.bashrc
#3添加软件源
conda config --add channels bioconda 
conda config --add channels conda-forge

#安装软件(bwa，samtools，bcftools软件为例)
#搜索软件    
conda search bwa    
#安装软件    
conda install -y samtools=1.9 bcftools=1.9    
#查看已安装软件  
conda list  
#升级软件  
conda update bwa  
#移除软件  
conda remove bwa 

#练习
conda install -y blast seqkit  fastqc multiqc  trimmomatic
conda install -y fastp

#二、虚拟环境
#1 安装不同版本软件
#查看虚拟环境
conda env list
#安装指定版本软件blast 2.7.1，samtools 1.7
conda create -n test 
#激活虚拟环境
conda activate test
#安装软件
conda install -c bioconda blast=2.7.1 samtools=1.7
#退出虚拟环境
conda deactivate

#2 创建python 2.7环境
conda create -n py27 python=2.7 -y
#查看现有虚拟环境
conda env list
#激活python2.7环境
conda activate py27
#查看python版本
python -V

#安装纳米孔数据分析软件
#MinKnow



#1安装guppy，需要官网购买仪器注册用户下载
#CPU版本：
wget https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy-cpu_4.2.2_linux64.tar.gz
#GPU版本：
wget https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy_4.2.2_linux64.tar.gz
tar -zxvf ont-guppy_4.2.2_linux64.tar.gz

#2 安装nanoplot
conda create -n nanoplot -y nanoplot

#3安装filtlong
git clone https://github.com/rrwick/Filtlong.git 
cd Filtlong
make -j

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
conda install -y prodigal glimmer augustus trf eggnog-mapper

#9安装 busco


#10 安装eggnog-mapper

#虚拟环境
conda env list
#nanoplot
conda create -n nanoplot
conda activate nanoplot
conda install -y nanoplot
conda deactivate

#sratools
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.10.8/sratoolkit.2.10.8-centos_linux64.tar.gz
tar -zxvf sratoolkit.2.10.8-centos_linux64.tar.gz 

#安装aspera
wget https://download.asperasoft.com/download/sw/connect/3.9.9/ibm-aspera-connect-3.9.9.177872-linux-g2.12-64.tar.gz
tar -zxvf ibm-aspera-connect-3.9.9.177872-linux-g2.12-64.tar.gz
sh ibm-aspera-connect-3.9.9.177872-linux-g2.12-64.sh

#安装filtlong
git clone https://github.com/rrwick/Filtlong.git
cd Filtlong
make -j

#安装centrifuge
#下载解压缩软件
wget ftp://ftp.ccb.jhu.edu/pub/infphilo/centrifuge/downloads/centrifuge-1.0.3-beta-Linux_x86_64.zip
unzip centrifuge-1.0.3-beta-Linux_x86_64.zip 
#安装blast+
wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.*+-x64-linux.tar.gz

#数据库下载
human and virus" (h+v) index：
https://storage.googleapis.com/sars-cov-2/centrifuge_h%2Bv_v2_20200327.tar.gz

human, prokaryotes and virus" (h+p+v) index：
https://storage.googleapis.com/sars-cov-2/centrifuge_h%2Bp%2Bv_20200318.tar.gz


#1下载数据
#链接地址
#https://www.ncbi.nlm.nih.gov/sra?linkname=bioproject_sra_all&from_uid=508395

#下载数据
prefetch ERR3994080 -O ./ 
#将sra转换为fastq格式
fasterq-dump ERR3994080.sra -o nanopore.fastq
#压缩
gzip nanopore.fastq
