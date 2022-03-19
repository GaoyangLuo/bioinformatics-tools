# CMG 2021 Bioinformatics Tutorial
——
Wellcome for reading this tutorial provided by gaoyang, the initiator of CMG. This tutorial includes the most popular bioinfomatics tools that can help you successfully doing the downstream analysis. Hope you enjoy it.
## Introduction
```py
#!/bin/bash
'''
# 本分析流程由CMG提供
# 此流程为CMG内部文件
# 作者：Gao-yang LUO
# 团队成员：Gaoyang Luo
# 本分析流程由康门团队书写并测试
- title:    CMG 2021 Bioinformatics Tutorial
- version:  1.0.0 
- author:   gaoyang
- contact:  lgyjsnj@163.com
- date:     9/2021
- department: Harbin Institute of Technology (Shenzheng)
- subject: COMPREHENSIVE ANALYSIS WORKFLOW & NOTEBOOK
- This work-flow is provided by COMMENbT_Group 
  (Computational Microbiome and Environmental BioTechnology Group)

'''
```
---

## Software Installing
Install Miniconda
```sh
# Download the latest miniconda2
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
# Run
bash miniconda.sh -b -p ~/miniconda
# Delete
rm miniconda.sh
```
- Tips：如何开启conda base环境，可以使用 `conda config --set auto_activate_base false`关闭。
- 手动添加conda为环境变量： `export PATH="~/miniconda/bin:$PATH"`，然后 `source ~/.bashrc`。
- 升级conda及相关程序 `conda update conda`
- 进入conda环境 `conda activate base`
- 退出conda环境 `conda deactivate`
- 更新conda：`conda update -n base -c defaults cond`
- 查看conda环境：`conda env list`
- 对换进怎删改查：`cd ~/.conda`，然后修改environment.txt中的路径

**Optional update**

```sh
$ conda activate base
$ conda update --all
$ conda --version
conda 4.8.4
$ conda config --show channels
channels:
  - conda-forge
  - bioconda
  - defaults
$ conda config --show-sources
==> /home/gcb2020/.condarc <==
channels:
  - conda-forge
  - bioconda
  - defaults
$ conda info
```
### add channels
```sh
#add mirrow-channels
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/linux-64
```
- 查看途径 `conda config --show channels`, `conda config --get channels`
- 移除路径 `conda config --remove channels`

---

### Installing QIIME 2 by Conda
Install work-flow
```sh
# Make a diretory and entering in
$ mkdir -p 2021.8 && cd 2021.8
# Download the latest qiime2
$ wget https://data.qiime2.org/distro/core/qiime2-2021.8-py38-linux-conda.yml
$ conda env create -n qiime2-2021.8 --file qiime2-2021.8-py38-linux-conda.yml
# OPTIONAL CLEANUP
$ rm qiime2-2021.8-py38-linux-conda.yml
# Activate qiime2 environment
$ conda activate qiime2-2021.8
```

**Deactivate working environment** \
When not using Qiime2, please close the working envrionment `$ conda deactivate`.

**Update qiime2** \
If you want to update qiime2, please firstly delete the former version.
Removing order：`$ conda env remove -n qiime2-2021.8`

QIIME2的分析流程总览
 ![zzz](https://docs.qiime2.org/2021.8/_images/overview.png)
 
### Installing software with Conda
Installing python and creat an environment
```sh
# Create a python3.5 environment
$ conda create -n py35 python=3.5 -y
# Activate python3.5 environment
$ conda activate py35
# Checcking python verison
$ python -V
# Exit the python envrionment
$ conda deactivate
```

Install relevent software
```sh
# Serach the packages you need
# if not existed, please use "conda create env -n [your_def_name] package_name"
$ conda search fastqc && \
$ conda search trimmomatic && \
$ conda search samtools && \
```
Looing up the latest conda version
`$ conda search samtools | tail -n1`
Looking up the conda environment** 
`$ conda env list` or`$ conda info --envs`
Creat and delete an environment
`$ conda create --name=myenv [package name]` or 
`$ conda create -n myenv [package name]`
`$ conda env remove --name=myenv` 

---

## The whole work-flow
![RNAseqworkflow](https://github.com/GaoyangLuo/image_storages/blob/main/RNAseqWorkflow.png?raw=true)

---

## QC1(FASTQC)
**From "Data extraction" to "FastQC again".**
### Data extraction
Download data from public database
```sh
# Download data from NCBI
$ export PATH=$PATH:/share/software/sratoolkit/sratoolkit-2.9.6/bin
$ cd [working_dir] && \
mkdir activate_sludge && \
cp run_* ./activate_sludge
$ cd activate_sludge
```
Then batch download:
```sh
num=$(sort 1-2.txt)
for name in $num
do
echo $name
prefetch ${name} >>1 log.txt 2>>&1 
done
echo "All the download of sra are complicated "  
```
or use the 'ez_sra_dl.sh' to download
```sh
#!/bin/bash

########################################
# The easy way to download batch       #
# sra data from NCBI using sratoolkit  #
# order of 'prefetch --option-f *.txt' #
########################################

myfile="./1-2.txt"
if [! -d "$myfile"]; Then
echo "{$myfile} is not existed"
echo "Please copy the sra.txt to the working directory"
fi


num=$(cat 1-2.txt)
for name in $num
do
echo $name && \
echo "Then downloading $name ..."
prefetch ${name} >>1 log.txt 2>>&1
echo "$name is comlished" 
done
echo "All the download of sra are complished "
echo "The total process took "
```

Put all sra in a same diretory and use sratoolkit to handle it >> .fastq
```sh
# Make owner unable to rewrite the raw data
$ chmod u-w *
# Change mod
$ chmod +x ./*
# Transform sra into .fq
# use --split-3 option, if the paired-end reads are not properly arranged (e.g. some reads has lack of mate pair)
$ export PATH=$PATH:/share/software/sratoolkit/sratoolkit-2.9.6/bin
$ nohup fastq-dump --split-3 * \
-O /data2/gaoyang_tmp/wastewater/influent/2019_NC_Global_monitoring_urban_sewage/data_extraction_fastq
# now you can also replace fastq-dump with fasterq-dump which is much faster 
# and efficient for large datasets
# by default it will use 6 threads (-e option)
$ fasterq-dump -S SRR8296149
# gzip *.fastq
$ cd ~/fq_control
$ gzip *.fastq
```
Using `-p` when using `-t` to display more information:
```sh
$ fasterq-dump SRR341578 -t /dev/shm -p
    lookup :|-------------------------------------------------- 100.00%
    merge  : 13255208
    join   :|-------------------------------------------------- 100.00%
    concat :|-------------------------------------------------- 100.00%
    spots read      : 7,549,706
    reads read      : 15,099,412
    reads written   : 15,099,412
```
sratoolkit has been installed in server of hitsz
`$ export PATH=$PATH:/home/shuhong/software/sratoolkit.2.11.1/bin`


### FastQC
Now we are going to use FastQC to summarize the data from conda environment.
First, you should activate fastqc which has been installed in the former steps.
```sh
$ cd ~/2021.8/exp_mps_metagenome/fq_control
$ fastqc -h
$ fastqc ./* -o ~/2021.8/exp_mps_metagenome/fq_control
$ cd ~/2021.8/exp_mps_metagenome/fq_control
$ ls -d *fastqc.zip*
```
You should see output that looks like this:
```sh
$ fastqc ./* -o ~/2021.8/exp_mps_metagenome/fq_control
  Started analysis of ERR4801153.fastq
  Approx 5% complete for ERR4801153.fastq
  Approx 10% complete for ERR4801153.fastq
  ·
  ·
  ·
  Approx 95% complete for ERR4801153.fastq
  Analysis complete for ERR4801153.fastq
```

### Trimmomatic
The first thing we’ll need are the adapters to trim off.
```sh
# Check trimmomatic
$ trimmomatic -h
# Download Illumina adaptor information
$ git clone https://github.com/timflutre/trimmomatic.git && \
mv adaptors ~/software && \
cd ~/2021.8/exp_mps_metagenome/fq_extra && \
cp ~/software/adaptors/TruSeq2-PE ./
```


Now run Trimmomatic
```sh
# extract basename and remove the suffix
# Pair End
# _1=forward, _2=reverse
$ for filename in *_1.fastq.gz
do

base=$(basename $filename _1.fastq.gz)
echo $base

trimmomatic PE -thread 9 \
     ${base}_1.fastq.gz ${base}_2.fastq.gz \
     ${base}_1.qc.fq.gz ${base}_u1 \
     ${base}_2.qc.fq.gz ${base}_u2 \
     ILLUMINACLIP:TruSeq3-PE.fa:2:40:15 \
     LEADING:2 TRAILING:2 \
     SLIDINGWINDOW:4:20 \
     MINLEN:25
done

# Single End
$ for filename in *.fastq.gz
do

base=$(basename $filename .fastq.gz)
echo $base

trimmomatic SE -thread 9 \
    ${base}.fastq \
    ${base}.qc.fq ${base}_u \
    ILLUMINACLIP:TruSeq3-SE.fa:2:40:15 \
    LEADING:2 \
    TRAILING:2 \
    SLIDINGWINDOW:4:20 \
    MINLEN:25
done
```

### FastQC again
Run the FastQC again on the trimmed files:
```sh
# Everytime to get started with 'activated' and ended by 'deactivated'
$ cd [working_dir]
$ fastqc *_1.qc.fq
$ fastqc *_2.qc.fq
```

### MultiQC
```sh
# Under [working_dir_trimmed]
$ conda activate py3
$ conda install multiqc
$ multiqc *
```

### K-mer filtering
**khmer** can make de novo assemblies faster, and sometimes better.khmer can also identify (and fix) problems with shotgun data.
usage: abundance-dist-single.py [--version] [--info] [-h] [-k KSIZE] [-U UNIQUE_KMERS] [--fp-rate FP_RATE] [-M MAX_MEMORY_USAGE] [--small-count] [-T THREADS] [-z] [-b] [-s] [--savegraph filename] [-f] [-q] input_sequence_filename output_histogram_filename
```sh
$ conda activate py
# See the original samples and find awful lot of unique k-mers (abundace=1)
$ abundance-dist-single.py -M 1e9 -k 21 SRR1976948_1.fastq.gz SRR1976948_1.fastq.gz.dist
# To see the results after do the Trimmomatic
$ abundance-dist-single.py -M 1e9 -k 21 SRR1976948_1.qc.fq.gz SRR1976948_1.qc.fq.gz.dist
```




---
## QC2 (Kneaddata)
You can refer more information to [Kneaddate](https://github.com/biobakery/biobakery/wiki/kneaddata#bowtie2)

Install kneaddata
```sh
$ conda install -c biobakery kneaddata
```


## QC3 (BBduk)

```sh
bbduk.sh in=reads.fq out=clean.fq \
ref=adapters.fa ktrim=r k=23 \
mink=11 hdist=1 tpe tbo
```




## Assembly
### Megahit
```sh
$ conda install megahit
$ magehit --help
$ cd [workdir] \  # Use data treated after khmer


```
### MetaSpades

## Polish
Polish step for Illumina sequence assembly. We use **Pilon**, a tool that is specified for next-generation polishing and **NextPolish**, a tool that can either singly be used for the next or Nanopore sequencing or used for 2+3 generation polish.

## Binning
Using MetaBAT2

## Alignment
### Bowtie 2
`bowtie2` can include trimming steps and outputs a set of alignments in SAM format.You can acquire more details by referring to [bowtie2_MANUAL](https://github.com/BenLangmead/bowtie2/blob/master/MANUAL.markdown)
```sh
  Read:      GACTGGGCGATCTCGACTTCG
             |||||  |||||||||| |||
  Reference: GACTG--CGATCTCGACATCG
```
By default, bowtie 2 performs End-to-end alignment which is also called an "untrimmed" or "unclipped" alignment. In this mode, we can trim reads before or not trimm it.
The other, local alignment, in this mode, bowtie 2 might "trim" or "clip" some reads to maximizes the alignment score.
```sh
# check Bowtie 2 directory
$ bowtie2 -h
$ bowtie2-build -h
$ bowtie2-inspect -h
# Build bowtie-index
$ cd ./myindex
$ bowtie2-build [ref1.fa],[ref2.fa] prefix_name=yourname
# Example
'nohup bowtie-build GENOME1.fa,GENOME2.fa GENOME.fa &'
# Align Reads.fa to GENOME.fa
$ bowtie -f -a -m 20 -v 1 \
--al Reads_aligned --threads 9 \
--un Reads_unaligned --norc GENOME.fa Reads.fa Reads.bwt > log.txt 2>&1

```
Usage:
`bowtie2 [options]* -x <bt2-idx> {-1 <m1> -2 <m2> | -U <r>} [-S <sam>]`
`-f` : In the format of .fasta
`-u` : Align the first *** reads
`-p` : Use how many threads to go
`-a` : Reserve all the alignment result
`-m` : The maximum times of alignment to reference data
`-v` : The allowed maximum mismatched number [0~2]
`--al <path>` : Reads that can be mapped to the reference
`--un <path>` : Reads that can not be mapped to the reference
`<m1>` : Files with #1 mates, paired with files in m2.
`<m2>` : Files with #2 mates, paired with files in m1.
## SAMtools
接Bowtie2进行接下来的分析。



## Minimap2

```sh
# General installation
$ curl -L https://github.com/lh3/minimap2/releases/download/v2.22/minimap2-2.22_x64-linux.tar.bz2 | \
tar -jxvf ./minimap2-2.22_x64-linux/minimap2
# Conda installation
$ conda install minimap2
# Genereal usage
# Short reads alignment
# minimap2 can perform interleaved alignment by mixing single- and paired-end reads
$ minimap2 -a ref.fa query.fq > alignment.sam
$ minimap2 -ax sr ref.fa reads_se.fq > aln.sam           # single-end alignment
$ minimap2 -ax sr ref.fa read1.fq read2.fq > aln.sam     # paired-end alignment
$ minimap2 -ax sr ref.fa reads-interleaved.fq > aln.sam  # paired-end alignment
# Full genome/assembly alignment
minimap2 -ax asm5 ref.fa asm.fa > aln.sam       # assembly to assembly/ref alignment
# Demo
$ minimap2 -d ref.mmi ref.fa                    # indexing
$ for filename in *.fastq.gz                    # single-end
  do

  base=$(basename $filename .fastq.gz)
  echo $base

  minimap2 -ax sr \
           ref.mmi \
           {$base}.fastq.gz > \
           {$base}_alignment_se.sam
  done

$ for filename in *.fastq.gz                    # paried-end
  do

  base=$(basename $filename .fastq.gz)
  echo $base 

  minimap2 -ax sr \
           ref.mmi \
           {$base}_1.fastq.gz {$base}_2.fastq.gz > \
           {$base}_alignment_pe.sam
  done
```

## #(optional) bioBactery 3
### #Kneaddata
`$ conda install -c channel_name package_name`
First, using Kneaddata to perform quality control on metagenomic data.






## Taxonomy-Kaiju
```sh
### 转换kaiju_table到biom格式
$ python kaiju_table_to_OTO_table.py
```

### #Visualization by QIIME2
Put the outcomes from bioBactery 3 into QIIME 2, you should firstly transfer the format that QIIME 2 prefers.
```sh
# qiime2使用，先转换成biom格式
# 界门纲目科属种间是以|分隔的，要替换成;
# 还有就是要去除属以上的级别，只保留种就可以了，qiime2会自动合并，否则导入不识别。
$ cp output_data/metaphlan/merged/metaphlan_taxonomic_profiles.tsv .
# qiime2认的表头有点死，改成它认的
$ cat meta.txt | cut -f 1 | sed  's/|/;/g' | less > tax_temp.txt
$ cat meta.txt | cut -f 1 | paste -  tax_temp.txt > tax_temp2.txt
$ echo "Feature ID\tTaxon" > tax.txt
$ sed -i '1d' tax_temp2.txt
$ cat tax_temp2.txt >> tax.txt
# 格式转换
$ biom convert -i meta.txt \
-o metaphlan.biom  --to-hdf5 --table-type="OTU table"
# 导入特征表
$ qiime tools import --input-path metaphlan.biom \
  --type 'FeatureTable[Frequency]' --input-format BIOMV210Format \
  --output-path zfg_table.qza
$ qiime tools import --input-path tax.txt \
  --type 'FeatureData[Taxonomy]' --input-format TSVTaxonomyFormat \
  --output-path zfg_tax.qza
# Barplot
$ qiime taxa barplot \
  --i-table zfg_table.qza \
  --i-taxonomy zfg_tax.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization taxa-bar-plots.qzv
# Taxa
$ qiime taxa collapse \
  --i-table zfg_table.qza \
  --i-taxonomy zfg_tax.qza \
  --p-level 6 \
  --o-collapsed-table table-l6.qza
# Diversity
# qiime diversity alpha --help
$ for a in ace shannon simpson \
           chao1 geni_index dominance \
           fisher_alpha
  do
  qiime diversity alpha \
  --i-table table.qza \
  --p-metric $a \
  --o-alpha-diversity ${a}.qza 
  qiime diversity alpha-group-significance \
  --i-alpha-diversity ${a}.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization alpha/${a}_group.qzv
done

# qiime diversity beta --help 
$ for b in braycurtis jaccard 
  do
  qiime diversity beta \
  --i-table table-l6.qza \
  --p-metric $b \
  --o-distance-matrix ${b}.qza 
# qiime diversity adonis \
# --i-distance-matrix ${b}.qza \
# --m-metadata-file sample-metadata.tsv \
# --p-formula 
# --o-visualization ${b}_adonis.qza
$ qiime diversity beta-group-significance \
  --i-distance-matrix ${b}.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column Group \
  --o-visualization alpha/${b}_group.qzv
 
$ qiime diversity pcoa \
  --i-distance-matrix ${b}.qza \
  --o-pcoa ${b}_pcoa.qza
 
$ qiime emperor plot \
  --i-pcoa ${b}_pcoa.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization ${b}.qzv
 
done
```


# Pathogen Analysis
## Centrifuge
- taxonomy tree: typically **nodes.dmp** from the NCBI taxonomy dump. Links taxonomy IDs to their parents
- names file: typically **names.dmp** from the NCBI taxonomy dump. Links taxonomy IDs to their scientific name
- a tab-separated sequence ID to taxonomy ID mapping
Usage：
```sh
centrifuge [options]* -x <centrifuge-idx> \
{-1 <m1> -2 <m2> | -U <r> | --sra-acc <SRA accession number>} \
[--report-file <report file name> \
-S <classification output file name>]
```

```sh
# 从NCBI的 taxonomy/ 下载最新的分类序列
centrifuge-download -o taxonomy taxonomy
centrifuge-download -o library -m -d "archaea,bacteria,viral" refseq > seqid2taxid.map
```

## MegaPath
Workflow of MegaPath:

![MegaPath](https://media.springernature.com/full/springer-static/image/art%3A10.1186%2Fs12864-020-06875-6/MediaObjects/12864_2020_6875_Fig1_HTML.png?as=webp)








# Environment Resistome Risk Evaluation
From metacmp...
```py
#!/usr/bin/python3

def getopts(argv):
    opts = {}  # Empty dictionary to store key-value pairs.
    while argv:  # While there are arguments left to parse...
        if argv[0][0] == '-' and argv[0][1] != 'h':  # Found a "-name value" pair.
            opts[argv[0]] = argv[1]  # Add key and value to the dictionary.
        argv = argv[1:]  # Reduce the argument list by copying it starting from index 1.
    return opts

def intersection(list1, list2):
    return list(set(list1) & set(list2))

if __name__ == '__main__':
    from sys import argv
    from sys import exit
    import os
    import subprocess
    import sys
    from Bio import SeqIO
    import pandas as pd
    import math

    myargs = getopts(argv)
    if '-h' in myargs or len(myargs) == 0:  # Example usage. --help
        print('\nUsage: ./metacmp.py -c filename1.fa -g filename2.fa [-t 64] \n')
        print('\t-c: Specify FASTA file containing assembled contigs (resulted from IDBA-UD).')
        print('\t-g: Specify FASTA file containing predicted genes (derived from prodigal).')
        print('\t-t: Specify the number of threads will be used in executing blast (default: 64).')
        print('\t-v: Printing important values in calculation On/Off [1: On (default), 0: Off]')
        print()
        exit()

    if not '-t' in myargs:
        myargs['-t'] = '64'
	
    if not '-v' in myargs:
        myargs['-v'] = '1'

    sample_name = myargs['-c'].split('.')[0]

    print("check file path: ")
    print(os.path.dirname(os.path.abspath(__file__)))

    acc_name = sample_name + "_ACLAME.txt"
    if not os.path.exists(os.getcwd()+"/"+acc_name):
        print('Running blastn on ACLAME')
        subprocess.call(["blastn", "-db", os.path.dirname(os.path.abspath(__file__))+"/BlastDB/aclame", "-query", myargs['-c'], \
                         "-out", acc_name, "-outfmt", "6", \
                         "-num_threads", myargs['-t'], "-evalue", "1e-10"])
    else:
        print('Skipping: Blast output is already exist for ACLAME')

    card_name = sample_name + "_CARD.txt"
    if not os.path.exists(os.getcwd()+"/"+card_name):
        print('Running blastx on CARD')
        subprocess.call(["blastx", "-db", os.path.dirname(os.path.abspath(__file__))+"/BlastDB/CARD_PROT", "-query", myargs['-g'], \
                         "-out", card_name, "-outfmt", "6", \
                         "-num_threads", myargs['-t'], "-evalue", "1e-10"])
    else:
        print('Skipping: Blast output is already exist for CARD')

    patric_name = sample_name + "_PATRIC.txt"
    if not os.path.exists(os.getcwd()+"/"+patric_name):
        print('Running blastn on PATRIC')
        subprocess.call(["blastn", "-db", os.path.dirname(os.path.abspath(__file__))+"/BlastDB/PATRIC", "-query", myargs['-c'], \
                         "-out", patric_name, "-outfmt", "6", \
                         "-num_threads", myargs['-t'], "-evalue", "1e-10"])
    else:
        print('Skipping: Blast output is already exist for PATRIC')

    print('Reading files..')

    #Open Fasta file
    records = list(SeqIO.parse(myargs['-c'], "fasta"))
    nContigs = len(records)
    #print(records[0].id)
    #print(records[0])

    # blast output column name
    # ## Fields: 
    #0: query acc.ver
    #1: subject acc.ver
    #2: % identity
    #3: alignment length
    #4: mismatches
    #5: gap opens
    #6: q. start
    #7: q. end
    #8: s. start
    #9: s. end
    #10: evalue
    #11: bit score

    print('Computing resistome risk score..')
 
    # Open blast output for ACLAME
    if not os.path.getsize(os.getcwd()+"/"+acc_name) > 0:
        #file is empty
        print('Warning: '+ acc_name+ ' is empty.')
        MGE_contigs = []
    else:
        ac = pd.read_csv(acc_name, sep='\t', header=None)
        ac.columns = ['id', 'sub_id', 'identity', 'alignLen', 'mismat', 'gapOpens', 'qStart', 'qEnd', 'sStart', 'sEnd', 'eval', 'bit']
        # filter out contigs identity under 60
        ac_iden60 = ac[ac.identity > 60]

        # filter out contigs having less than 90% coverage of the reference
        if not os.path.exists(os.path.dirname(os.path.abspath(__file__))+"/Len_aclame.txt"):
            print('Len_aclame.txt file does not exists.')
            sys.exit()
        else:
            acleng = pd.read_csv(os.path.dirname(os.path.abspath(__file__))+"/Len_aclame.txt", sep='\t', header=None)
            acleng.columns = ['sub_id', 'ref_gene_leng']
            ac_merged = pd.merge(ac_iden60, acleng, how = 'left', on = 'sub_id')
            ac_filtered = ac_merged[ac_merged.alignLen > (ac_merged.ref_gene_leng * 0.9)]

            # Note: 'ac_filtered' data frame contains name and position of MGEs in contigs
            MGE_contigs = ac_filtered.id.unique()

    # Open blast output for PATRIC
    if not os.path.getsize(os.getcwd()+"/"+patric_name) > 0:
        #file is empty
        print('Warning: '+ patric_name+ ' is empty.')
        PAT_contigs = []
    else:
        pa = pd.read_csv(patric_name, sep='\t', header=None)
        pa.columns = ['id', 'sub_id', 'identity', 'alignLen', 'mismat', 'gapOpens', 'qStart', 'qEnd', 'sStart', 'sEnd', 'eval', 'bit']
        # filter out contigs identity under 60
        pa_iden60 = pa[pa.identity > 60]

        # filter out contigs alignment length under 150
        pa_alen = pa_iden60[pa_iden60.alignLen > 150]

        # Note: 'pa_alen' data frame contains name and position of Pathogens in contigs
        PAT_contigs = pa_alen.id.unique()

    # Open blast output for CARD
    if not os.path.getsize(os.getcwd()+"/"+ card_name) > 0:
        #file is empty
        print('Warning: '+ card_name+ ' is empty.')
        CARD_contigs = []
    else:
        ca = pd.read_csv(card_name, sep='\t', header=None)
        ca.columns = ['id', 'sub_id', 'identity', 'alignLen', 'mismat', 'gapOpens', 'qStart', 'qEnd', 'sStart', 'sEnd', 'eval', 'bit']
        # filter out contigs identity under 60
        ca_iden60 = ca[ca.identity > 60]

        # filter out contigs alignment length under 25
        ca_alen = ca_iden60[ca_iden60.alignLen > 25]

        # Note: 'ca_alen' data frame contains name and position of Antibiotic Resistence Genes in contigs
        CARD_genes = ca_alen.id.unique()
        ARG_contigs = []
        for gene in ca_alen.id:
            contig_name = gene.split("_")
            ARG_contigs.append("_".join(contig_name[:-1]))
        ARG = set(ARG_contigs)

        # computing risk score
        ARG_MGE = intersection(ARG_contigs, MGE_contigs)
        ARG_MGE_PAT = intersection(ARG_MGE, PAT_contigs)
        nARG = len(ARG)
        nARG_MGE = len(ARG_MGE)
        nARG_MGE_PAT = len(ARG_MGE_PAT)

        fARG = float(nARG)/nContigs
        fARG_MGE = float(nARG_MGE)/nContigs
        fARG_MGE_PAT = float(nARG_MGE_PAT)/nContigs

        distance = math.sqrt((0.01 - fARG)**2 + (0.01 - fARG_MGE)**2 + (0.01 - fARG_MGE_PAT)**2)

        score = 1.0 / ( (2 + math.log10(distance))**2 )

		# other stat

        nMGE = len(MGE_contigs)
        nPAT = len(PAT_contigs)
        fMGE = float(nMGE)/nContigs
        fPAT = float(nPAT)/nContigs

        print("Resistome risk score: " + str(score))

        if myargs['-v'] == '1':
            print("nContigs, nARG, nMGE, nPAT, nARG&MGE, nARG&MGE&PAT, nARG/nContigs, nMGE/nContigs, nPAT/nContigs, nARG&MGE/nContigs, nARG&MGE&PAT/nContigs, Risk Score\n")
            print(nContigs, nARG, nMGE, nPAT, nARG_MGE, nARG_MGE_PAT, fARG, fMGE, fPAT, fARG_MGE, fARG_MGE_PAT, score)


    # #contigs containing ARG, MGE, and PAT
    # print("ARG_contigs")
    # print(ARG_contigs)
    # print("MGE_contigs")
    # print(MGE_contigs)
    # print("PAT_contigs")
    # print(PAT_contigs)
```

**笔记**
```py
import sys
import os
name=os.path.dirname(sys.argv[0]) # name为文件所在路径
print(sys.argv[0]) # 打印文件所在路径（包含文件名）
print(name) # 打印文件所在路径（不包括文件名）


print(sys.argv[0]) # 打印当前程序路径
print(sys.argv[1]) # 打印第一个参数
print(sys.argv[2]) # 打印第二个参数

# 'if not + try' 的用法
import os
import sys
import numpy as np
if not os.path.exists(os.path.join(os.getcwd(),'data','house_tiny.csv')): # join函数可以表示地址
  print("**file is not existed...")
  try:
    print("try these codes...")
  except error:
    print("failed...")
  else:
    print("successful...")
    if not os.path.exists(os.path.join(os.getcwd(), dirname, filename))：
else:
  print("Skipping to the next step...")

# 使用glob.glob提取文件名
import pandas as pd
import glob
'''
# files = glob.glob("./*.tsv")
# files = files.replace
# print(files)
'''
for name in glob.glob("./*.tsv"):
    file = name.replace(".\\", "")
    print (file)
```

# 移动文件
```sh
#cleanreads
for i in *
do
if [ -d ${i} ]; then
mkdir -p /lomi_data/lomi_external/wwtp_ie_Global_AMR_metagenomics_urban_sewage_2016jan-2016feb/metagenome_illumina/1_clean/${i}
fi
done

#!/bin/bash
#PBS -N scp_clean
#PBS -l nodes=c005:ppn=2
workdir=/lomi_home/gaoyang/meta_MAG_workdir/as_China
cd $workdir

for i in *
do
if [ -d ${i} ]; then
cp -r ${i}/clean_reads/* /lomi_data/lomi_external/wwtp_ie_Global_AMR_metagenomics_urban_sewage_2016jan-2016feb/metagenome_illumina/1_clean/${i}
fi
done

#assembly
for i in x.*
do
if [ -d ${i} ]; then
mkdir -p /lomi_data/lomi_external/wwtp_ie_Global_AMR_metagenomics_urban_sewage_2016jan-2016feb/metagenome_illumina/2_assembly_binning/${i}
fi
done

#!/bin/bash
#PBS -N cp_assembly
#PBS -l nodes=c005:ppn=2
for i in *
do
if [ -d ${i} ]; then
cp -r ${i}/assembly/Results/* /lomi_data/lomi_external/wwtp_ie_Global_AMR_metagenomics_urban_sewage_2016jan-2016feb/metagenome_illumina/2_assembly_binning/${i}
fi
done

```