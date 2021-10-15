#下载ubuntu 20.04镜像
https://ftp.sjtu.edu.cn/ubuntu-cd/20.04.1/ubuntu-20.04.1-desktop-amd64.iso

#制作USB启动盘
#下载使用rufus https://rufus.ie/
#或者ultraISO https://cn.ultraiso.net/

#挂载磁盘
#假设未挂载磁盘为/dev/sdb
fdisk -l
parted /dev/sdb
#交互界面 
mklabel gpt
quit
#格式化磁盘
mkfs.xfs -f /dev/sdb 
#挂载磁盘
mkdir /ifs1
mount /dev/sdb /ifs1
#修改fstab
echo "/dev/sdb /ifs1                       xfs     defaults,uquota        0 0" >>/etc/fstab

#创建root账户
sudo passwd root
输入当前用户密码：
输入root密码：
再次输入root密码：

#以下操作使用root账户完成
su -

#修改源
cp /etc/apt/sources.list /etc/apt/sources.list.bak
sed -i 's#cn.archive.ubuntu.com#mirrors.aliyun.com#g' /etc/apt/sources.list
sudo apt-get update && sudo apt-get upgrade

#ssh登录
apt install openssh-server
ps -e |  grep ssh   #检查ssh server是否启动
sudo /etc/init.d/ssh start  #启动

#安装java
apt-get install openjdk-8-jdk
sudo add-apt-repository ppa:webupd8team/java
apt update
apt install -y oracle-java8-installer
apt install -y zlib1g zlib1g.dev
apt install -y libboost-dev

#安装R以及Rstudio
apt install -y r-base
https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.3.1093-amd64.deb
dpkg -i rstudio-1.3.1093-amd64.deb

#安装一些小工具
apt install -y git vim tree creen htop cmake lftp lrzsz

#apt安装生物软件
apt install -y bwa
apt install -y samtools 
apt install -y bcftools
apt install -y blast2
apt install -y bedtools
apt install -y seqtk
apt install -y minimap2
apt install -y bowtie2
apt install -y phylip
apt install -y clustalx
apt install -y canu
apt install -y kraken2
apt install -y hisat2
apt install -y stringtie
apt install -y jellyfish
apt install -y circos
apt install -y nanopolish
apt install -y nanook
apt install -y centrifuge
apt install -y rna-star
apt install -y freebayes
apt install -y cnvkit
apt install -y spades
apt install -y mothur
apt install -y muscle
apt install -y mafft
apt install -y iqtree
apt install -y sniffles
apt install -y last-align
apt install -y augustus
apt install -y bamtools 
apt install -y bedops
apt install -y delly

#安装浏览器
apt-get install -y chromium-browser

#安装微信
wget https://www.ubuntukylin.com/public/pdf/wine-wechat_1.0-windows2.8.6_all.deb
#Debian 系的操作系统可以执行这样的命令：
sudo dpkg --add-architecture i386
sudo apt update
#安装 wine 应用所需的依赖，也就是 wine：
sudo apt install wine-stable
#使用 dpkg 安装 wine 应用：
sudo dpkg -i wine-wechat_1.0-windows2.8.6_all.deb

#安装bioconda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  
sh Miniconda3-latest-Linux-x86_64.sh  
source ~/.bashrc

#添加软件源
conda config --add channels bioconda 
conda config --add channels conda-forge

