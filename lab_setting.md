connect_to_elephant.sh

in elephant

~/training_materials/admin/scripts$ CM_config_hosts.sh - setting private ip
cat /etc/hosts - 설정 확인
exit

connect_to_*.sh 한번씩 들어가 보며 host name 변경 여부 확인 :)

------------------------------------------------------------------------------

connect_to_lion.sh
java -version : 1.7.0_67 ( 버전 뭘로 설치할지 생각 )
chkconfig | grep mysqld
sudo service mysqld status

** 1개 CM (2NN) - 제일 많이 작업 해야 함
mysql 설치 등, 서버 띄우고 나머지 배포

2개 NN (Master Service)
3개 DN/NM/Impala 

mysql-setup.sql
~~~
CREATE DATABASE cmserver DEFAULT CHARACTER SET utf8;
# GRANT ALL - 모든 권한
# HOST 이름 구체적으로 써도 되고, 모든 호스트는 % 로 표기
GRANT ALL on cmserver.* TO 'cmserveruser'@'%' IDENTIFIED BY 'password';

CREATE DATABASE metastore DEFAULT CHARACTER SET utf8;
GRANT ALL on metastore.* TO 'hiveuser'@'%' IDENTIFIED BY 'password';

CREATE DATABASE amon DEFAULT CHARACTER SET utf8;
GRANT ALL on amon.* TO 'amonuser'@'%' IDENTIFIED BY 'password';

CREATE DATABASE rman DEFAULT CHARACTER SET utf8;
GRANT ALL on rman.* TO 'rmanuser'@'%' IDENTIFIED BY 'password';

CREATE DATABASE oozie DEFAULT CHARACTER SET utf8;
GRANT ALL on oozie.* TO 'oozieuser'@'%' IDENTIFIED BY 'password';

CREATE DATABASE hue DEFAULT CHARACTER SET utf8;
GRANT ALL on hue.* TO 'hueuser'@'%' IDENTIFIED BY 'password';
~~~

mysql -u root < mysql-setup.sql
mysql -u root

~~~ mysql
# 정상 결과 확인
show databases;
~~~

# 비밀번호 등 설정
sudo /usr/bin/mysql_secure_installation

cd /etc/yum.repos.d/
training@lion:/etc/yum.repos.d$ cat cloudera-cm5.repo 
[cloudera-cm5.9.0-local]
name=cloudera-cm5.9.0-local
# cloudera 배포 주소가 적혀 있을 것임 - version 6~
# version 5.x 설치 위해서는 여기 위치 바꿔야 함 : 6 version은 아님 :)
# 결론 : baseurl 수정
baseurl=file:///home/training/software/cloudera-cm5
enabled=1
gpgcheck=0



# base url 따라가서 x86_64파일 확인
# 시험에서는 이렇게 하지 않으나, 인터넷이 안되는 환경에서는 이렇게 진행함
training@lion:~$ cd software/
training@lion:~/software$ cd cloudera-cm5/
training@lion:~/software/cloudera-cm5$ cd RPMS/
training@lion:~/software/cloudera-cm5/RPMS$ ls
x86_64
training@lion:~/software/cloudera-cm5/RPMS$ ls
x86_64
training@lion:~/software/cloudera-cm5/RPMS$ cd
training@lion:~$ sudo yum install -y cloudera-manager-daemon cloudera-manager-server

# 자동으로 .. 하지 않기 위해 off (?)
sudo chkconfig cloudera-scm-server off

mysql -u root -p

~~~ mysql
show databases;
use cmserver;
show tables;
~~~

# create DB table, config file
training@lion:/usr/share/cmf/schema$ cat scm_prepare_database.sh 
# 2 parameter (db name, , username, pass)
training@lion:/usr/share/cmf/schema$ sudo ./scm_prepare_database.sh mysql cmserver cmserveruser password

< CM : cloudera manager 설치 > 끝


< CDH 설치 > 
CM version에 맞게 설치 유도하기 때문에 비교적 괜찮음

CDH 배포는 browser 위에서 돌아야 하기 때문에 
외부망과 접속 안 되는 경우를 위한 python program이 있음

~~~
# 현재는 외부망과 접속하기 위한 python program 떠있음 - 시험 환경에서는 필요 없음
training@lion:~$ curl lion:8000
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2 Final//EN"><html>
<title>Directory listing for /</title>
<body>
<h2>Directory listing for /</h2>
<hr>
<ul>
<li><a href="CDH-5.9.0-1.cdh5.9.0.p0.23-el6.parcel">CDH-5.9.0-1.cdh5.9.0.p0.23-el6.parcel</a>
<li><a href="CDH-5.9.0-1.cdh5.9.0.p0.23-el6.parcel.sha">CDH-5.9.0-1.cdh5.9.0.p0.23-el6.parcel.sha</a>
<li><a href="CDH-5.9.0-1.cdh5.9.0.p0.23-el6.parcel.sha1">CDH-5.9.0-1.cdh5.9.0.p0.23-el6.parcel.sha1</a>
<li><a href="manifest.json">manifest.json</a>
</ul>
<hr>
</body>
</html>
training@lion:~$ curl lion:8050
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2 Final//EN"><html>
<title>Directory listing for /</title>
<body>
<h2>Directory listing for /</h2>
<hr>
<ul>
<li><a href="repodata/">repodata/</a>
<li><a href="RPMS/">RPMS/</a>
</ul>
<hr>
</body>
</html>
~~~


----------------------------------------------

# new terminal open

[training@localhost ~]$ cd bin
[training@localhost bin]$ ls
CM_config_local_hosts_file.sh  connect_to_lion.sh    start_SOCKS5_proxy.sh
connect_to_elephant.sh         connect_to_monkey.sh
connect_to_horse.sh            connect_to_tiger.sh
# 이거 안하면 lion:7180 에서 proxy error 발생
[training@localhost bin]$ ./start_SOCKS5_proxy.sh 


--------------------------------------------

# back to lion terminal
# server start !!
training@lion:~$ sudo service cloudera-scm-server start

# 서버 떠있는거 확인 가능
training@lion:~$ ps wax | grep [c]loudera-scm-server
30795 ?        Ssl    1:18 /usr/java/jdk1.7.0_67/bin/java -cp .:lib/*:/usr/share/java/mysql-connector-java.jar:/usr/share/java/oracle-connector-java.jar -server -Dlog4j.configuration=file:/etc/cloudera-scm-server/log4j.properties -Dfile.encoding=UTF-8 -Dcmf.root.logger=INFO,LOGFILE -Dcmf.log.dir=/var/log/cloudera-scm-server -Dcmf.log.file=cloudera-scm-server.log -Dcmf.jetty.threshhold=WARN -Dcmf.schema.dir=/usr/share/cmf/schema -Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Dpython.home=/usr/share/cmf/python -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+HeapDumpOnOutOfMemoryError -Xmx2G -XX:MaxPermSize=256m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp -XX:OnOutOfMemoryError=kill -9 %p com.cloudera.server.cmf.Main

#log.dir=/var/log/cloudera-scm-server
# change to root 
training@lion:/var/log$ sudo -i
[root@lion ~]# cd /var/log/cloudera-scm-server/
# using cat, confirm the logs
[root@lion cloudera-scm-server]# 


<browser>

http://lion:7180
admin/admin


시험에서는 .. ㅠ

# 8000에 cdh  배포판 설치 되어 있음
more options click 
전체 (-)
(+) http://lion:8000

# Select the specific release of the Cloudera Manager Agent you want to install on your hosts.
# click Custom Repository
http://lion:8050

*
 tip.
 linux
 centos만 centos-user
 key/pair 시험날 제공
 
 각각의 node에 key/pair로 들어가는건 쉽지만,
 옆으로 가는건 약간의 조작 필요
 
 recomm : 조작하기 위해서 각각에 password를 넣어줌
 centos에 password yes로 하고, 비밀번호 설정완료 해야 함 - 5개에 다
 
 이후에는 user password로 접근
*

test에서는 key를 가지고 갑니다 ~ 시험날에는 user password로 하는게 쉬워요

You may connect via password or public-key authentication for the user selected above.
select - All hosts accept same private key 
browse - .ssh > id_rsa

Cluster Setup
시험- Hive,Hue,Impala,Oozie
or
test - Custom : Hds, yarn

# 참고 site
https://www.cloudera.com/documentation/enterprise/5-15-x/topics/cli_deploy_cdh_6.html

Clouera Management Service - all lion(only)
여기서는 elephant가 Namenode
2nd tiger
Balancer horse
DataNode except lion (시험때는 d1,d2,d3만 선택해도 됨)

yarn
RM - horse
JobHistory - monkey
NodeManager - Same As DataNode

Database Setup
여기에 db host 이름 넣어줘야 함
시험 당일에는 CM(lion):hostname 



----------------------------------------------











