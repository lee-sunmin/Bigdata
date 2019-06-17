빅데이터 : 하둡으로 처리하는 데이터
하둡 : 데이터 분산 , 병렬 처리

데이터 수집

19.05.20

빅데이터 수집
Flume - Sqoop - Kafka - Streamset

###sqoop ?
데이터베이스와 hdfs 간에 주고받을 수 있는 툴 <import, export>
특정 row, column 만 가지고 오는 것 가능
다양한 format 지원 가능 (text , ...)

압축도 가능한데, 상황에 따라서 잘 선택해야 한다.

반대로 hdfs -> sql 가능

*** sqoop 자체가 map reduce
default가 4대

1) db에 접근해서 테이블의 디테일 조사
2) sqoop이 job 만들어서 hdp cluster에 던져준다
3) job이 db와 작업

하나의 테이블 - 하나의 디렉토리
테이블 필드들의 집합 - 파일
파티션 - 디렉토리 안의 서브디렉토리

<특징>
1.
** sqoop으로 데이터 가지고 오면 그냥 파일이기 때문에, 분석을 위해 스키마 정의해 주어야 한다.
** sqoop의 hive table option! -> 스키마 만들어 주는 것 까지 해준다.
2.
업데이트 됐을 때, 특정 증가분에 대해서만 가져올 수 있음

#### sqoop - Import
sqoop은 hadoop MapReduce job을 사용

[옵션]
target-dir : 저장할 특정 디렉토리 설정 가능

import - 하나의 싱글테이블 / 데이터 간 구분 디폴트는 ','로 저장됨
(옵션 : fields-terminated-by)

#### sqoop - Export
db로 데이터 넣음

export-dir : 해당 경로에 있는 file insert 해라


sqoop - 우지 - hive 조합 많이 사용

### flume ?
데이터 수집에 있어서 가장 대중적으로 사용

kafka는 producer/consumer가 분리
flume은 producer - source
        consumer - sink
        둘 사이가 연결되어 있음(channel)

flume장점 : 코딩 비교적 덜함


flume vs kafka
* agent
ㅁ-------------------------ㅁ
(source)   -channel-     (sink)

* multi agent
sink가 다른 agent의 source가 될 수 있음
문제 : 선처리가 막히면 후처리가 대기상태에 빠짐
해결 : 중간에 큰 Messaging system 만듦 (kafka)
       topic...............?
       
       
flume 의 중요 키워드 contextual routing
event - headers + body
headers는 key/value 쌍

channel : transactional (all or nothing) - error나면 roll back
다양한 sources 와 sink에 지원

memory channel : ram, 메모리 날라가면 재전송
file channel : local
jdbc channel : acid 특성 지원


sink : java process

[complex flow]
multi-hop flows

복잡한 ? 분기 ? 상황에서는 kafka 쓰는게 좋음
적은 숫자일 때는 flume 이 좋음..


multi-agent flow : 확장 가능

source, sink, channel에 특정 이름, 타입 등을 지정해서 configuration 만들 수 있음
configuration : 각각의 속성 저장
* 중요 * 
configuration 2개
flume자체 config(flume이 어떻게 떠야 하는지 특성), agent에 대한 config(source, sink, channel)

예) hdp - name node인걸 알 수 있게 하는게 name node configuration(?)




#### Flume - source

flume은 type에 대해서 property가 변경된다.
source는 1개 이상의 channel 사용 가능( 2개 이상은 multi ...)

* channel selector 44p


#### Flume - sinks
nosql이랑 붙여 쓸 수 있음


#### Flume - Interceptors
event에 있는 내용들 수정 가능
channel로 들어가기 전에 내용 수정

channel에 쓰기전에 intercept를 이용해서 내용 추가도 가능
contextual routing을 이용 할 수 있게 함. **********








==============================================================================================================
lab
다양한 곳에서 데이터 주고받기 때문에 messaging system 많이 씀 -> kafka
kafka를 이용해서 messaging 단순화

kafka는 뭐냐?
자체는 messaging, "distrubuted commit log"

..나이파이? + 카프카....
앞에 커넥터같은 모듈 개발해서 붙이면 됨.............


kafka의 장점
1. scalable - multiple nodes 에 좋음
2. faul-tolerant
3. very fast - 초당 수십만개 전송 가능
4. flexible - 생산자/소비자가 **decoupled** , batch

kafka는 producer, consumer가 서로 분리되어 있다. 중간에 broker를 통해서.
message를 크게 하고 싶은 broker를 늘림(?)

partition 안에 여러 데이터 저장되어 있고, - topic
message는 topic을 가지고 만들어짐

offset : 특정 시점 저장?

70p
토픽은 partition 될 수 있음

messaging  system은 topic 만 맞으면 알아서 consumer가 잘 가져갈 수 있음
partition 내에서 순서가 지켜져야한다 - offset

message 크기 max 1MB 정도면 좋다. (limit은 없다)

schema도 여러가지 지원하지만 json, xml 이 보통 쓰인다, 압축도 지원 
Avro?????????? 호환성이 좋아서 많이 사용

메시지는 읽던 말던 남아있음 *********************
(여러 사람이 각자 offset 가지고 있어서 볼 수 있음)


< topics >

주제에 해당되는 애들이 들어있음 multi-subscribe 가능 
여러개 partition에 나눠서 들어감 : 왜? 깨지면 안되니까 replication(복수로) 하는겨
topic에 있는 순서가 offset , 순서는 바뀌지 않음

kafka는 자체적으로 안정적인 것 가능
topic replication
acks 
0 :  ack 안받아도 간다 - 가장 속도가 빠름
1 : leader가 ack 받으면 간다
-1 : 모든 isr을 받으면 간다(복제본 생성) - 가장 안정적


<consumers>
데이터 많이 처리하고 싶으면 consumer group 많이

guarantees
보낸 순서대로 추가한다.
replication factor가 3이면 3-1 server가 fail될 때 까지 돌 수 있음

kafka 단점
data transformation 기능이 없음
보안에 아직은 약간 취약

kafka - messaging system
1) queueing - 
2) publish/subscribe - record is bradcase to all consumers

처리량 높이는 방법
각각의 파티션들이 소비자 그룹에 맞게 추가 (4-4)

많은 수의 소비자그룹 만들어서 확장 가능

storage system은 disk에 써서 

< kafka - stream processing >
real time으로 데이터 처리

kafka는 zookeeper의 도움을 받아 처리한다.
zookeeper : 분산 어플리케이션에 도움줌?
kafka depends on apache zookeeper service for coordination
네임노드에서 쓰는 zookeeper와 같은 zookeeper



====================================
05/21

왜 Flume이랑 Kafka를 비교하는거지???????????????????????

Flume 장점
코딩없이 비교적 쉽게 가능
수집단계에서 데이터 처리 및 가공 구현 가능

단점
메시지 복제 기능 제공 x
kafka와 비교하여 대량 메시지 환경에서 고 성능의 높은 처리량 보증 x

Kafka 장점
다중 시스템 연계에 대한 유연성, 안정성
Fault-Tolerance

단점
코딩 필요
Hadoop 데이터 수정 불가(?)

Tool

Streamsets
Easy to build pipeline
원하는 destination을 drag&drop으로 배치




Flafka = Flume + Kafka
Kafka - messaging system


Application에서 데이터 받음
ㅣ
Flume Agent
ㅣ
Kafka Cluster
ㅣ
Consumer

Kafka의 con인것처럼 flume 사용



source는 만드는애 sink는 가져가는애

channel, source, sink로 kafka를 사용할 때, property가 다 다름 (116p)


<StreamSets>
데이터 수집을 위한 오픈소스 통합 IDE
kafka, ..등 지원

pipeline구성
Origin에서 1개 이상의 전처리를 거쳐서 Dest로 갈 수 있음

Pipeline(Origin to Kafka) 생성

<Elasticsearch>
실시간 분산형 RESTful 검색 및 분석 엔진
검색엔진, 데이터수집, visualization

수집 - logstash
저장 - elasticsearch
시각화 - kibana
= ELK stack

logstash : 데이터 처리 파이프라인
input - datasource설정
fileter-데이터 처리 과정
dnflrk

kibana : 히스토그램, 선 그래프, 원형 차트 등의 기본적 요소로 구성




Flume 실습 중..interceptor 사용 이유
원하는 곳으로 보내기 위해 사용한 것









==============================================================================================================
scale up vs scale out




