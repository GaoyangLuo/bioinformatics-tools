# 常用命令

# 复制命令 显示过程和速度
rsync -av --progress
scp -r wastewater gaoyang@10.16.36.172:/data2/gaoyang_tmp
临时：scp -r TWTP_Turk gaoyang@10.16.36.172:/lomi_home/gaoyang/gaoyang_tmp/wastewater/influent/2019_NC_Global_monitoring_urban_sewage/till_assembled
移动：mv *.e* *.o* ./error && mv *.list ./All_list
# 挂载与取消挂载
mount /dev/sdb /home/shuhong/tmp
umount /dev/sdb1 
umount /home/shuhong/tmp

# 暂停放置后台运行ctrl + z >> bg
nohup order -[options]
ctrl + z
bg
jobs

# 查看各个盘的存储情况
df -h

# 查看python版本
whereis python

# awk命令详解
## 格式化输出
awk -F, '{printf("%-2s %s\n", $1,$2)}' log.txt
awk -F "/t" -v var=$TAXID '{if ($2==var) print $1"/t"$2}' log.txt > log1.txt
example：
    df -h|awk '{printf"%-12s %10s\n",$1,$2}'
%-2s "-"符号代表输出左对齐，否则右对齐
%d 十进制有符号整数 
%u 十进制无符号整数 
%f 浮点数 
%s 字符串 
%c 单个字符 
%p 指针的值 
%e 指数形式的浮点数 
%x, %X 无符号以十六进制表示的整数 
%0 无符号以八进制表示的整数 
%g 自动选择合适的表示法 
\n 换行 
\f 清屏并换页 
\r 回车 
\t Tab符 
\xhh 表示一个ASCII码用16进表示,其中hh是1到2个16进制数 

# 压缩命令 tar，zip，gzip
tar (可以保留原文件,可以压缩文件夹)
　　　　-c: 建立压缩档案
　　　　-r：向压缩归档文件末尾追加文件

　　　　-x：解压
　　　　-z：是否需用用gzip压缩；

　　　　-t：查看内容

　　　　-v：显示所有过程
　　　　-f: 使用档案名字，切记，这个参数是最后一个参数，后面只能接档案名，-f是必须的

　　　　压缩文件：tar -cvf abc.tar *.txt
　　　　解压文件：tar -xvf abc.tar
　　　　解压到指定的文件夹：tar -zxvf java.tar.gz -C /usr/java

　　zip (可以保留原文件,可以压缩文件夹)
　　　　-r 递归处理，将指定目录下的所有文件和子目录一并处理。
　　　　-v 显示指令执行过程或显示版本信息
　　　　-q 不显示指令执行过程。

　　　　压缩文件：zip -r abc.zip *.txt
　　　　解压文件：unzip -r abc.tar

　　gzip (不能保存原文件,不能压缩文件夹)
　　　　压缩文件：

　　　　　　1. tar -cvf abc.tar *.txt 　　 　得到abc.tar
　　　　　　2. gzip abc.tar 　　　　　　  得到abc.tar.gz
　　　　解压文件:
　　　　　　gunzip abc.tar.gz 　　　　     得到abc.tar

# chmod
chmod ugo [rwxrwxrwx]
r=4
w=2
x=1
u=users, g=groups, o=others
+:增加权限
-：减少权限

# Trimmomatic
PE/SE
    设定对Paired-End或Single-End的reads进行处理，其输入和输出参数稍有不一样。
-threads
    设置多线程运行数
-phred33
    设置碱基的质量格式，可选pred64
ILLUMINACLIP:TruSeq3-PE.fa:2:30:10
    切除adapter序列。参数后面分别接adapter序列的fasta文件：允许的最大mismatch数：palindrome模式下匹配碱基数阈值：simple模式下的匹配碱基数阈值。
LEADING:3
    切除首端碱基质量小于3的碱基
TRAILING:3
    切除尾端碱基质量小于3的碱基
SLIDINGWINDOW:4:15
    从5'端开始进行滑动，当滑动位点周围一段序列(window)的平均碱基低于阈值，则从该处进行切除。Windows的size是4个碱基，其平均碱基
质量小于15，则切除。
MINLEN:50
    最小的reads长度
CROP:<length>
    保留reads到指定的长度
HEADCROP:<length>
    在reads的首端切除指定的长度
TOPHRED33
    将碱基质量转换为pred33格式
TOPHRED64
    将碱基质量转换为pred64格式
'

# sed
格式命令
sed [options] 'command' file(s)
sed [options] -f scriptfile file(s)
sed -i 's/原字符串/新字符串/' /home/1.txt  # 直接对文本进行操作（修改文件名）
sed命令
'
a\ 在当前行下面插入文本。
i\ 在当前行上面插入文本。
c\ 把选定的行改为新的文本。
d 删除，删除选择的行。
D 删除模板块的第一行。
's 替换指定字符'
h 拷贝模板块的内容到内存中的缓冲区。
H 追加模板块的内容到内存中的缓冲区。
g 获得内存缓冲区的内容，并替代当前模板块中的文本。
G 获得内存缓冲区的内容，并追加到当前模板块文本的后面。
l 列表不能打印字符的清单。
n 读取下一个输入行，用下一个命令处理新的行而不是用第一个命令。
N 追加下一个输入行到模板块后面并在二者间嵌入一个新行，改变当前行号码。
p 打印模板块的行。
P(大写) 打印模板块的第一行。
q 退出Sed。
b lable 分支到脚本中带有标记的地方，如果分支不存在则分支到脚本的末尾。
r file 从file中读行。
t label if分支，从最后一行开始，条件一旦满足或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾。
T label 错误分支，从最后一行开始，一旦发生错误或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾。
w file 写并追加模板块到file末尾。  
W file 写并追加模板块的第一行到file末尾。  
! 表示后面的命令对所有没有被选定的行发生作用。  
= 打印当前行号码。  
# 把注释扩展到下一个换行符以前。
'
sed替换标记
'
'g 表示行内全面替换。'  
p 表示打印行。  
w 表示把行写入一个文件。  
x 表示互换模板块中的文本和缓冲区中的文本。  
y 表示把一个字符翻译为另外的字符（但是不用于正则表达式）
\1 子串匹配标记
& 已匹配字符串标记
'
sed元字符
'
^ 匹配行开始，如：/^sed/匹配所有以sed开头的行。
$ 匹配行结束，如：/sed$/匹配所有以sed结尾的行。
. 匹配一个非换行符的任意字符，如：/s.d/匹配s后接一个任意字符，最后是d。
* 匹配0个或多个字符，如：/*sed/匹配所有模板是一个或多个空格后紧跟sed的行。
[] 匹配一个指定范围内的字符，如/[ss]ed/匹配sed和Sed。  
[^] 匹配一个不在指定范围内的字符，如：/[^A-RT-Z]ed/匹配不包含A-R和T-Z的一个字母开头，紧跟ed的行。
\(..\) 匹配子串，保存匹配的字符，如s/\(love\)able/\1rs，loveable被替换成lovers。
& 保存搜索字符用来替换其他字符，如s/love/**&**/，love这成**love**。
\< 匹配单词的开始，如:/\<love/匹配包含以love开头的单词的行。
\> 匹配单词的结束，如/love\>/匹配包含以love结尾的单词的行。
x\{m\} 重复字符x，m次，如：/0\{5\}/匹配包含5个0的行。
x\{m,\} 重复字符x，至少m次，如：/0\{5,\}/匹配至少有5个0的行。
x\{m,n\} 重复字符x，至少m次，不多于n次，如：/0\{5,10\}/匹配5~10个0的行。
'

# pip
从github中下载并直接安装包
pip install git+

# ln
`ln [options] source dist`
-s 软链接soft

# cat
cat file1 file2 > file3 # 将1，2合并成3
cat filename # 显示整个文件
cat -T filename # 将/tab显示为^|
cat -n file # 加上行号

# ``
``与$()效果相同，用作命令替换。先完成反引号里的命令，然后将其结果替换出来，重新组成命令行

# ${}
变量替换

# ||
双竖线‘||’，用双竖线‘||’分割的多条命令，执行的时候遵循如下规则，如果前一条命令为真，则后面的命令不会执行，如果前一条命令为假，则继续执行后面的命令。

# if [ - ]
Linux_shell条件判断if中的-a到-z的意思

[ -a FILE ]  如果 FILE 存在则为真。  
[ -b FILE ]  如果 FILE 存在且是一个块特殊文件则为真。  
[ -c FILE ]  如果 FILE 存在且是一个字特殊文件则为真。  
[ -d FILE ]  如果 FILE 存在且是一个目录则为真。  
[ -e FILE ]  如果 FILE 存在则为真。  
[ -f FILE ]  如果 FILE 存在且是一个普通文件则为真。  
[ -g FILE ] 如果 FILE 存在且已经设置了SGID则为真。 [ -h FILE ]  如果 FILE 存在且是一个符号连接则为真。  
[ -k FILE ]  如果 FILE 存在且已经设置了粘制位则为真。  
[ -p FILE ]  如果 FILE 存在且是一个名字管道(F如果O)则为真。  
[ -r FILE ]  如果 FILE 存在且是可读的则为真。  
[ -s FILE ]  如果 FILE 存在且大小不为0则为真。  
[ -t FD ]  如果文件描述符 FD 打开且指向一个终端则为真。  
[ -u FILE ]  如果 FILE 存在且设置了SUID (set user ID)则为真。  
[ -w FILE ]  如果 FILE 如果 FILE 存在且是可写的则为真。  
[ -x FILE ]  如果 FILE 存在且是可执行的则为真。  
[ -O FILE ]  如果 FILE 存在且属有效用户ID则为真。  
[ -G FILE ]  如果 FILE 存在且属有效用户组则为真。  
[ -L FILE ]  如果 FILE 存在且是一个符号连接则为真。  
[ -N FILE ]  如果 FILE 存在 and has been mod如果ied since it was last read则为真。  
[ -S FILE ]  如果 FILE 存在且是一个套接字则为真。  
[ FILE1 -nt FILE2 ]  如果 FILE1 has been changed more recently than FILE2, or 如果 FILE1 exists and FILE2 does not则为真。  
[ FILE1 -ot FILE2 ]  如果 FILE1 比 FILE2 要老, 或者 FILE2 存在且 FILE1 不存在则为真。  
[ FILE1 -ef FILE2 ]  如果 FILE1 和 FILE2 指向相同的设备和节点号则为真。  
[ -o OPTIONNAME ]  如果 shell选项 “OPTIONNAME” 开启则为真。  
[ -z STRING ]  “STRING” 的长度为零则为真。  
[ -n STRING ] or [ STRING ]  “STRING” 的长度为非零 non-zero则为真。  
[ STRING1 == STRING2 ]  如果2个字符串相同。 “=” may be used instead of “==” for strict POSIX compliance则为真。  
[ STRING1 != STRING2 ]  如果字符串不相等则为真。 
[ STRING1 < STRING2 ]  如果 “STRING1” sorts before “STRING2” lexicographically in the current locale则为真。  
[ STRING1 > STRING2 ]  如果 “STRING1” sorts after “STRING2” lexicographically in the current locale则为真。  
[ ARG1 OP ARG2 ] “OP” is one of -eq, -ne, -lt, -le, -gt or -ge. These arithmetic binary operators return true if “ARG1” is equal to, not equal to, less than, less than or equal to, greater than, or greater than or equal to “ARG2”, respectively. “ARG1” and “ARG2” are integers.
bash中如何实现条件判断

-条件测试类型

-整数测试
-字符测试
-文件测试

条件测试的表达式

[ expression ] 括号两端必须要有空格

[[ expression ]] 括号两端必须要有空格

test expression

组合测试条件：

-a　　: and

-o　　: or

!　　 : not

整数比较

-eq 测试两个整数是否相等
-ne 测试两个整数是否不等
-gt 测试一个数是否大于另一个数
-lt 测试一个数是否小于另一个数
-ge 大于或等于
-le 小于或等于

命令间的逻辑关系, 逻辑与：&& , 逻辑或：||

 
字符串比较

== 等于 两边要有空格
!= 不等
> 大于
< 小于

文件测试

-z string 测试指定字符是否为空，空着真，非空为假
-n string 测试指定字符串是否为不空，空为假 非空为真
-e FILE 测试文件是否存在
-f file 测试文件是否为普通文件
-d file 测试指定路径是否为目录
-r file 测试文件对当前用户是否可读
-w file 测试文件对当前用户是否可写
-x file 测试文件对当前用户是都可执行
-z 是否为空 为空则为真
-a 是否不空


if语法

单分支if语句
if 判断条件；then
statement1
statement2
.......
fi

双分支的if语句：

if 判断条件；then
statement1
statement2
.....
else
statement3
statement4
fi

注意：

if语句进行判断是否为空
[ "$name" = "" ]
等同于
[ ! "$name" ]
[ -z "$name" ]
使用if语句的时候进行判断如果是进行数值类的判断，建议使用let(())进行判断，对于字符串等使用test[ ] or [[ ]] 进行判断
(())中变量是可以不使用$来引用的
 for example：表述数字范围的时候 可以使用if可以是使用case

 if [ $x -gt 90 -o $x -lt 100 ]

case $x in
100)
9[0-9])

这个语句的意思是如果$name为空，那么X=X成立折执行下面的结果；

if [ "X$name" != "x" ]

写脚本的时候很多时候需要用到回传命令，$?如果上一个命令执行成功，回传值为0，否则为1~255之间的任何一个，0为真，非0为假。

条件测试的写法

1、执行一个命令的结果
if grep -q "rm" fs.sh;then

2、传回一个命令执行结果的相反值
if ！grep -q "rm" fs.sh;then

3、使用复合命令（（算式））
if ((a>b));then

4、使用bash关键字 [[判断式]]
if [[ str > xyz ]];then

5、使用内置命令：test 判断式
if test "str" \> "xyz";then

6、使用内置命令：[判断式] 类似test
if [ "str" \> "xyz" ];then

7、使用-a -o进行逻辑组合
[ -r filename -a -x filename ]

8、命令&&命令
if grep -q "rm" fn.sh && [ $a -lt 100 ];then

9、命令||命令
if grep -q "rm" fn.sh || [ $a -lt 100 ];then

# %%_*和##*_
%删掉第一个_及其右边的内容
%%删掉最后一个_及其左边的内容
\# 为删掉第一个_及左边的内容
\#\#删掉最后一个_及其左边的内容

# qsub
杀死命令qdel

# argparser
顺序 
import argparse
1.parser = argparse.ArgumentParser() # 创建一个解析对象
2.parser.add_argument # add_argument()指定程序可以接受的命令行选项
3.arg = parser.parse_arg() # 进行解析







