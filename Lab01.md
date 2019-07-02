# Cloudera 5.15.x


#### 참고 웹 사이트  
https://victorydntmd.tistory.com/212?category=704005
https://www.cloudera.com/documentation/enterprise/5-15-x/topics/configure_cm_repo.html

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

# Update 시에  Cannot find a valid baseurl for repo: base/7/x86_64 라는 에러 발생하면
sudo dhclient

sudo yum install -y wget
~~~


## Cloudera

### Download the cloudera-manager.repo file for your OS version to the /etc/yum.repos.d/ directory 
~~~
[sunmin@localhost ~]$ sudo wget https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/cloudera-manager.repo -P /etc/yum.repos.d/

--2019-07-02 19:50:19--  https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/cloudera-manager.repo
Resolving archive.cloudera.com (archive.cloudera.com)... 151.101.88.167
Connecting to archive.cloudera.com (archive.cloudera.com)|151.101.88.167|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 290 [binary/octet-stream]
Saving to: ‘/etc/yum.repos.d/cloudera-manager.repo’

100%[======================================>] 290         --.-K/s   in 0s      

2019-07-02 19:50:20 (31.5 MB/s) - ‘/etc/yum.repos.d/cloudera-manager.repo’ saved [290/290]
~~~

~~~
[sunmin@localhost ~]$ sudo vi /etc/yum.repos.d/cloudera-manager.repo
#modify baseurl => https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5.15.0/
# url is 'Location' in Cloudera Manager Version and Download Information
~~~

### Import the repository signing GPG key
~~*version 선택 기준?*~~
~~~
[sunmin@localhost ~]$ sudo rpm --import https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/RPM-GPG-KEY-cloudera
~~~


### Installing the JDK Using Cloudera Manager
*The JDK must be installed at /usr/java/jdk-version.*

~~~
# 5.15.x 기준
[sunmin@localhost ~]$ sudo yum install oracle-j2sdk1.7
~~~

### Install the Cloudera Manager Server Packages
~~~
[sunmin@localhost ~]$ sudo yum install cloudera-manager-daemons cloudera-manager-server
[sunmin@localhost ~]$ sudo yum install cloudera-manager-daemons cloudera-manager-agent
~~~

### Installing MariaDB Server
~~~
[sunmin@localhost ~]$ sudo yum install mariadb-server
[sunmin@localhost lib]$ sudo systemctl enable mariadb
Created symlink from /etc/systemd/system/multi-user.target.wants/mariadb.service to /usr/lib/systemd/system/mariadb.service.
[sunmin@localhost ~]$ sudo systemctl start mariadb

[sunmin@localhost ~]$ sudo /usr/bin/mysql_secure_installation
Y>Y>N>Y>Y
~~~

*예외 처리*
~~~
systemctl status mariadb

# mariadb 삭제
[sunmin@localhost system]$  yum list installed mariadb\*
[sunmin@localhost system]$ sudo yum remove -y mariadb-libs.x86_64 
~~~

### Installing the MySQL JDBC Driver for MariaDB
~~~
[sunmin@localhost ~]$ sudo wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.46.tar.gz
[sunmin@localhost ~]$ tar zxvf mysql-connector-java-5.1.46.tar.gz

[sunmin@localhost ~]$ sudo mkdir -p /usr/share/java/
[sudo] password for sunmin: 
[sunmin@localhost ~]$ cd mysql-connector-java-5.1.46
[sunmin@localhost mysql-connector-java-5.1.46]$ sudo cp mysql-connector-java-5.1.46-bin.jar /usr/share/java/mysql-connector-java.jar
~~~


### Creating Databases for Cloudera Software
~~~
[sunmin@localhost ~]$ mysql -u root -p

MariaDB [(none)]> create database scm default character set utf8 default collate utf8_general_ci;
MariaDB [(none)]> grant all on scm.* to 'scm'@'%' identified by 'password';

MariaDB [(none)]> create database amon default character set utf8 default collate utf8_general_ci;
MariaDB [(none)]> grant all on amon.* to 'amon'@'%' identified by 'password';

MariaDB [(none)]> create database rman default character set utf8 default collate utf8_general_ci;
MariaDB [(none)]> grant all on rman.* to 'rman'@'%' identified by 'password';

MariaDB [(none)]> create database hue default character set utf8 default collate utf8_general_ci;
MariaDB [(none)]> grant all on hue.* to 'hue'@'%' identified by 'password';

MariaDB [(none)]> create database metastore default character set utf8 default collate utf8_general_ci;
MariaDB [(none)]> grant all on metastore.* to 'metastore'@'%' identified by 'password';

MariaDB [(none)]> create database sentry default character set utf8 default collate utf8_general_ci;
MariaDB [(none)]> grant all on sentry.* to 'sentry'@'%' identified by 'password';

MariaDB [(none)]> create database nav default character set utf8 default collate utf8_general_ci;
MariaDB [(none)]> grant all on nav.* to 'nav'@'%' identified by 'password';

MariaDB [(none)]> create database navms default character set utf8 default collate utf8_general_ci;
MariaDB [(none)]> grant all on navms.* to 'navms'@'%' identified by 'password';

MariaDB [(none)]> create database oozie default character set utf8 default collate utf8_general_ci;
MariaDB [(none)]> grant all on oozie.* to 'oozie'@'%' identified by 'password';
~~~

~~~
MariaDB [(none)]> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| amon               |
| hue                |
| metastore          |
| mysql              |
| nav                |
| navms              |
| oozie              |
| performance_schema |
| rman               |
| scm                |
| sentry             |
+--------------------+
~~~

### Preparing the Cloudera Manager Server Database
~~~
[sunmin@localhost ~]$ sudo /usr/share/cmf/schema/scm_prepare_database.sh mysql scm scm
Enter SCM password: 
JAVA_HOME=/usr/lib/jvm/jre-openjdk
Verifying that we can write to /etc/cloudera-scm-server
Creating SCM configuration file in /etc/cloudera-scm-server
Executing:  /usr/lib/jvm/jre-openjdk/bin/java -cp /usr/share/java/mysql-connector-java.jar:/usr/share/java/oracle-connector-java.jar:/usr/share/java/postgresql-connector-java.jar:/usr/share/cmf/schema/../lib/* com.cloudera.enterprise.dbutil.DbCommandExecutor /etc/cloudera-scm-server/db.properties com.cloudera.cmf.db.
[                          main] DbCommandExecutor              INFO  Successfully connected to database.
All done, your SCM database is configured correctly!

# If it exists, remove the embedded PostgreSQL properties file:
sudo rm /etc/cloudera-scm-server/db.mgmt.properties
~~~

### Start Cloudera Manager Server
~~~
[sunmin@localhost ~]$ sudo systemctl start cloudera-scm-server

web : http://localhost:7180 접속
~~~

### cloudera 화면 확인
<img width="869" alt="web" src="https://user-images.githubusercontent.com/17976251/60519474-966fcd80-9d1e-11e9-8fde-cdd59c1055a7.png">

---

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







etc.
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile


