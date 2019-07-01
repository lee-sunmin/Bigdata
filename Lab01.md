

* 3개의 노드 (virtual 환경) 생성
3개 모두 ip를 다르게 하기 위하여 bridge 로 설정해야 한다!  
그리고 설치 시에 network on!  
~~*네트워크 설정 제대로 안했다가 삽질함*~~


#### 참고 웹 사이트  
https://victorydntmd.tistory.com/212?category=704005

### check ip 
hostname -I

### Check linux version
~~~ 
[sunmin@localhost ~]$ cat /etc/*release*
CentOS Linux release 7.6.1810 (Core) 
Derived from Red Hat Enterprise Linux 7.6 (Source)
NAME="CentOS Linux"
VERSION="7 (Core)"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="7"
PRETTY_NAME="CentOS Linux 7 (Core)"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:centos:centos:7"
HOME_URL="https://www.centos.org/"
BUG_REPORT_URL="https://bugs.centos.org/"

CENTOS_MANTISBT_PROJECT="CentOS-7"
CENTOS_MANTISBT_PROJECT_VERSION="7"
REDHAT_SUPPORT_PRODUCT="centos"
REDHAT_SUPPORT_PRODUCT_VERSION="7"

CentOS Linux release 7.6.1810 (Core) 
CentOS Linux release 7.6.1810 (Core) 
cpe:/o:centos:centos:7
~~~

### Check linux bit
~~~
[sunmin@localhost ~]$ getconf LONG_BIT
64
~~~

## 초기 셋팅
### SSH Server setting
~~~
# SSH 서버가 실행되고 있는지 확인
[sunmin@localhost ~]$ ps -ef | grep sshd
root       7178      1  0 06:58 ?        00:00:00 /usr/sbin/sshd -D
sunmin    66861  66766  0 07:28 pts/0    00:00:00 grep --color=auto sshd
# SSH 서비스를 자동 실행 상태로 변경하는 명령어
# 서버가 실행되면 sshd 서비스가 자동으로 실행
[sunmin@localhost ~]$ systemctl enable sshd.service
~~~

### 방화벽 정지
~~~
[sunmin@localhost ~]$ systemctl stop firewalld.service
[sunmin@localhost ~]$ systemctl disable firewalld.service
Removed symlink /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed symlink /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
~~~
*확인*
~~~
[sunmin@localhost ~]$ sudo iptables -nL

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for sunmin: 
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination    
~~~

## Account setting

### Change account password
~~~
[sunmin@localhost ~]$ sudo passwd sunmin
[sudo] password for sunmin: 
Changing password for user sunmin.
New password: 
Retype new password: 
passwd: all authentication tokens updated successfully.
~~~

### remove account (필요시에만 사용)
~~~
[sunmin@localhost ~]$ sudo userdel -r training
~~~
*** user / user group 부분 다시봐야함 ***


### Check disk volume
~~~
df -Th
~~~

*현재 모든 디스크의 파티션 설정 현황*
~~~
[sunmin@localhost ~]$ sudo fdisk -l
[sudo] password for sunmin: 

Disk /dev/sda: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000d2e68

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048     2099199     1048576   83  Linux
/dev/sda2         2099200    41943039    19921920   8e  Linux LVM

Disk /dev/mapper/centos-root: 18.2 GB, 18249416704 bytes, 35643392 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/centos-swap: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
~~~

#### update yum, install wget
~~~
sudo yum update
sudo yum install -y wget
~~~


### Update parameter
https://aws.amazon.com/ko/premiumsupport/knowledge-center/ec2-password-login/
~~~
sudo vi /etc/ssh/sshd_config
#Change "PasswordAuthentication -> yes"
~~~

### Restart SSH Service
~~~
# linux command
[hadoop@localhost ~]$ sudo service sshd restart
Redirecting to /bin/systemctl restart sshd.service
~~~


### Hosts Setting
~~~
# Setting host name
# m1은 변경하고자 하는 이름
[hadoop@localhost ~]$ hostnamectl set-hostname m1
[hadoop@localhost ~]$ hostname
m1

# n1, n2 에서도 동일한 작업 진행
~~~

