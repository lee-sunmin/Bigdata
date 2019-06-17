### Intro

HDFS? 
범용 하드웨어로 구성된 클러스터에서 실행되고 스트리밍 방식의 데이터 접근 패턴으로 대용량 파일을 다룰 수 있도록 설계된 시스템  
HDFS 블록 크기의 기본 값은 128MB

Cluster? 같은 일을 할 수 있도록 여러개 Node들을 합쳐놓은 것  
Service? 다양한 부서  
Role?  
Role Group?  
Instance?  

Cluster 안에 Rack들로 구성

HDFS 의 Name Node/ Data Node/ 2Name Node 가 Role
        Role Group은 Data Node Group ,... - Group에 있는 애들은 같은 Config를 적용시킬 수 있음 -> 관리 용이

Name Node : 파일시스템 트리와 그 트리에 포함된 모든 파일과 디렉터리에 대한 메타데이터 유지  
            파일 시스템의 네임스페이스 관리  
            fsimage와 edits를 로컬 디스크에 영속적 저장  
            파일에 속한 모든 블록이 어느 데이터 노드에 있는지 파악  
            시스템이 시작할 때 모든 데이터노드로부터 받아서 재구성  

Data Node : 파일시스템의 실질적 일꾼  
            클라이언트나 네임노드의 요청이 있을 때 블록을 저장하고 탐색하며,  
            저장하고 있는 블록의 목록을 주기적으로 네임노드에 보고  
            
어플리케이션 : 맵리듀스, 스파크, 테즈 등
계산 : yarn
저장 : HDFS, HBase

===================================================

HDFS : 데이터 저장
YARN : 스케쥴링, 리소스 관리

Hadoop Component
Processing(Spark, MapReduce) / Resource(YARN) / Storage(HDFS)

Hadoop Cluster 
마스터 노드(Master nodes) - RM?? : 관리, 일 시킴
작업 노드(Slave nodes/Worker nodes) : 실제 업무

Name Node - fsimage, edits
실제 일은 client과 worker가 다 함.


MapReduce
분산 병렬 처리 방식 : 여러 개의 슬레이브 노드에 작업을 분산
MapReduce 3단계
1) Mapper 단계
hdfs 블록으로 나눠서 분산 처리, 가능한 데이터를 가지고 있는 노드에서 Task 실행

2) Shuffle과 Sort 단계
Mapper의 중간 결과 통합하고 정렬해서 reducer에게 전달

3) Reducer 단계
Mapper 중간 결과로 최종 결과 수행시켜 hdfs 에 저장

-> 모든 과정은 log로 남는다. 추적해서 속도 개선 등 할 수 있음


YARN
RM(ResourceManager)
NM(NodeManager)
AM(ApplicationMaster) per application

** yarn에서의 fault-tolerant 다시 보기 **
NM의 생사는 MN이 체크
AM이 reduce 등 체크
RM

HUE 추천 ~ :)

#### HUE 

Hadoop clients : user / server client로 2개가 있음
대표적인 client  : HUE

client는 API를 이용해서 HDFS, YARN/MapReduce 이용 가능

* server as hadoop clients
대표 예 : Oozie, Hive Server

HUE : Hadoop User Experience ?
모든걸 해볼 수 있는 tool

hive, impala, pig ,Metastore Manager(sqoop, .. schema 도 만들 수 있고 다양한 것 처리 가능),..
file browser(권한, 삭제 등 설정 가능)


#### Pig
어떤 플랫폼이든 다 잘 돈다
pig와 hive의 공통점 : 바로 돌지 못하고 MapReduce/Spark로 바껴서 수행(MR 안짜도 됨)

Impala와 hive의 공통점 : SQL처럼 사용
차이점 : 미세한 신텍스, 데이터 타입
impala는 중간과정 없고, 바로 hdfs에 가서 실행
hive가 만든 테이블 impala가 access 가능 -> metastore 공유


// 노트필기



pig - 다른걸로 대체 할 수 있어서 약간씩 죽어가고 있음

pipeline paradigm
위에서 했던 결과들이 하나의 relation이라는 결과로 만들어짐
A -> B -> C 순차적, 쉽게 접근할 수 있음

중간에 MR 코드로 바뀜

Use Case
ramdom data sampling
ETL 작업해서 data warehouse에 넣을 수 있음 (액기스 정보만)




#### pig

comments : -- or /* */
pig는 store 또는 덤프? 를 만나야 수행한다 -> hdfs에 저장
키워드는 대소문자 상관없지만, 그 외는 구분한다

operation 가능

*LOAD
default : text file, field 구분 \t
field 구분 설정 명령어는 USING pigStorage(',')

*tuples들의 모임 bags
ex) details:bag{(age:int, salary:double.zip:long)}

*output
dump나 store 만나야 진행
dump : screen
store : disk(hdfs)

* describe
show the structure of the data

* filter = sql의 where

* foreach/generate = sql의 select
ex) twofields = FOREACH allsales GENERATE amount, trans_id;
// 새로운 field 생성
ex) T = foreach allsales generate price * 0.07; // 추가적 생성도 가ㅡㄴㅇ

* distinct
완벽 일치하는 행에 대해서만 적용

* sort
order a bt b desc

* limit
order 먼저 하고 limit 쓰면 오름차순/내림차순 상위 몇개 추출 가능




#### Hive
: 하둡 기반의 데이터 웨어하우징 프레임워크
대량의 데이터를 관리하고 학습하기 위하여 개발되었음

facebook
dbms는 아니지만, standard SQL과 유사

수정 불가, 검색만 가능

왜 하이브 사용?
- 맵리듀스는 프로그램하기 어려움
- Hadoop의 대규모 데이터 처리 능력과 SQL 전문지식 활용 위해 개발


* Hive Components

- Hive Metastore : DB에 저장
Hive의 table - directory
Metastore - directory의 schema 정보
Schema, Location 정보 있음
1) 데이터 스키마
2) 데이터 정리의 개요
3) 데이터베이스 테이블 및 필드
4) 필드 유형


* managed or external
managed : table dropped -> hdfs data is deleted
external : table dropped -> only the table schema is deleted, data is not deleted

complex data types 도 사용 가능 (map, array,struct)

* hive file formats

hive table - single directory in HDFS
partitions are subdirectories : 속도

* Hive QL
sql 처럼 쓸 수 있으나, 똑같진 않다



#### Impala

SQL 처럼 똑같이 쓸 수 있는 랭귀지 가지고 사용
mapreduce로 바꾸지 않고 바로 수행 **** Impala demon
hive에 비해 10-50배 이상 빠르다

* Impala component
hive metastore 공유.

masterNode - Impala Catalog, Impala Statestore
* catalog *
- hive에서 만드는 경우, sqoop import, .. 는 모른다. (외부적 발생)
'invalidate metastore' 부르면 metastore에서 데이터 읽어와서 해결 가능

slaveNode - Impala Daemon

*
hadoop cluster에서 돌릴 수 있음 : hdfs나 hbase table 접근 가능


#### Oozie
workflow!

control Flow Nodes
action Nodes


sqoop으로 데이터 가져오고 - hive로 분석해서 report => oozie


#### Hadoop Security

authentication ; 인증
authorization ; 권한부여
encryption

* kerberos 135pg
세 파트가 서로 데이터 주고받음

1) KDC는 kerveros key 분산하고 확인, 여러개 있을 수 있음
2) client
3) server (*time stamp)

* Terminology
Realm: 실제 kerberos 서비스를 받는 영역 (도메인?)
principal : unique identity (id)
keytab file : 

* sentry 146pg
플러그인
최근에 빠지는 추세
role-base로 권한 부여 가능





















