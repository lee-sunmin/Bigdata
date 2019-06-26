

* 3개의 노드 (virtual 환경) 생성
3개 모두 ip를 다르게 하기 위하여 bridge 로 설정해야 한다!  
그리고 설치 시에 network on!  
~~*네트워크 설정 제대로 안했다가 삽질함*~~


### check ip 
hostname -I

인터넷 연결도 확인

### Check linux version
~~~ 
[root@localhost network-scripts]# cat /etc/*release*
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
[root@localhost network-scripts]# getconf LONG_BIT
64
~~~

#### update yum, install wget
~~~
sudo yum update
sudo yum install -y wget
~~~

### Check disk volume
~~~
df -Th
~~~




