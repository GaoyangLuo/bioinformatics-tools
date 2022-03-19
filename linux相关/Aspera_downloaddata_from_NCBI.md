# 用Aspera工具快速下载NCBI的数据

## 介绍

## 下载安装
首先在[https://www.ibm.com/aspera/connect/](IBM Aspera Connect)中下载对应版本的文件。

```sh
# 下载安装包
wget https://d3gcli72yxqn2z.cloudfront.net/connect_latest/v4/bin/ibm-aspera-connect-3.11.2.63-linux-g2.12-64.tar.gz

# 解压
# 得到 ibm-aspera-connect-3.11.2.63-linux-g2.12-64.sh 这个文件
tar -xzvf ibm-aspera-connect-3.11.2.63-linux-g2.12-64.tar.gz
# 安装后，回到home目录，能够看到.aspera这个隐藏文件
sh ibm-aspera-connect-3.11.2.63-linux-g2.12-64.sh
# 回到home，查看
cd ~;ll


```