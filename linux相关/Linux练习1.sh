pwd
date
cal
cd
ls
touch
cp 
mv
rm
less
cat
more
head
tail
mkdir
history
stat
file
du
df


# 1 基本脚本
pwd;
whoami
who
w
date
id
cal
cat /proc/cpuinfo
cat /proc/version
cat /proc/uptime
uname -a
df ./
clear
history
last

#切换目录
cd /ifs1;
cd /;ls
cd -
cd ~
cd -;ls
cd
cd ./
cd ../../

#查看帮助
man ls
info ls
ls --help
less --help
alias 'work=cd ~';work
pwd;cal;date
date
cal
id
history |head -10
#文件操作
touch test1.txt
cp test1.txt test2.txt
rm test2.txt
mv test1.txt test2.txt
chmod 755 test2.txt
ln -s ../../Data/K12.fna exam.fna
du exam.fna 
less exam.fna
less -S exam.fna
more exam.fna
cat exam.fna
head -10 exam.fna
tail -10 exam.fna
file exam.fna
stat exam.fna
wc exam.fna
cp exam.fna test.fna
gzip test.fna
gunzip test.fna.gz
tar -zcvf test.fna.tar.gz test.fna
tar -zxvf test.fna.tar.gz
grep ">" exam.fna |wc
touch 001.txt 002.txt 003.txt 004.txt 005.txt
rm -r *.txt

#文件夹操作
mkdir dir1
cp -R dir1 dir2
rmdir  dir2
mv dir1 dir2
cp exam.fna dir2
du dir2
tar -zcvf dir2.tar.gz dir2
rm -r dir2
tar -zxvf dir2.tar.gz

#2.11.2 vim的使用
vim a1.sh 
#i a u 切换为插入模式
#ESC切换为命令模式
如何退出 vim？ 
首先按 esc 键切换到命令模式 然后按“shift+：”冒号表示可以输入命令了,然后按 
q！不保存退出 
wq 保持退出或者 x 保存退 
w+文件名 另存为一个文件


#进程管理
top        #press "q" to exit
top -b  # press "Ctrl +C" to exit
top -c
top -u "yourname"
ps
ps -fx
kill -9 "process number"
passwd #change your password
sleep