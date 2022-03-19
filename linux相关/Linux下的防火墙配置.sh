#Linux下的防火墙配置

#文件位置
/etc/sysconfig/iptables

#允许所有本机向外的访问
iptables -A OUTPUT -j ACCEPT


#二、修改远程登录用户限制

#1.设置白名单
vim /ect/host.allow // 
sshd:ALL #增加如下内容 #不限制用户登录 
sshd:192.168.1.,192.168.0.:allow // #允许1.0和0.0网段内的所有用户登录

#2.设置黑名单
#只限制192.168.0.1登录，其他全部放行
#实现
vim /etc/hosts.deny // 
sshd: 192.168.0.1 #增加如下内容

#特殊：如果两个文件中都是 ：“sshd: ALL” 
#由于先去匹配hosts.allow，所以全部允许。

#3.修改/etc/hosts.allow文件
#
# hosts.allow This file describes the names of the hosts which are
# allowed to use the local INET services, as decided
# by the ‘/usr/sbin/tcpd’ server.
#
sshd:210.13.218.*:allow #allowk可以完全省略
sshd:222.77.15.*:allow #allowk可以完全省略