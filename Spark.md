## Intro

map reduce program 의 단점 : 코딩이 복잡하다
그래서 hive가 나왔음 단점 : 느리다

map reduce의 장점 중 하나는 큰 데이터도 처리 할 수 있음

mapreduce 3 가지  
1] map - 데이터 분산, 각 mapper들이 자기 데이터 읽어 온 다음에 그 데이터만 가지고 처리(각각 분리된 데이터르 를 가지고 연산, key-value)  
2] shuffle sort - 전체 key를 같은 곳으로 모아지게 한 다음에(key 로 sorting)  
3] reduce -  같은 key가진애끼리 쪼개서 처리  
=> 위와 같은 map reduce 과정이 여러번 진행되며 처리함  

hdfs에서는 block단위로 저장(128mb)

local disk에서 local sort -> local disk에 쓰고 gloal sort 진행 -> local disk에 저장 - 셔플 sort  
hdfs 에서 분산되어 있는 데이터를 한 block씩 읽음 - mapper

reducer들이 읽는다 -> reducer들이 hdfs에 다시 저장


(hdfs) => mapper => (local disk) => reducer => (hdfs)

단점은 disk read/write가 많네요! 

### Hive tez VS Spark

hive tez는 map/reduce 쓰지만 약간 개선하자
apache spark는 처음부터 map/reduce 말고 다른 방식을 하자! 

### Spark

*RDD
실제로는 분산되어 있지만, 프로그래밍 할 때는 한 곳에서 작동하는 것처럼 작업 하게 될 것

1] Transformation
RDD A -> RDD B ( RDD들은 Immutable 하다. 기존 RDD 그대로 두고 새로운 RDD 생성하는것 ) :
이유는 분산병렬 시스템이기 때문

2] Actions
결과 값이 나오는 연산자들

.. 나머지 내용은 책에 정리했음



### Apache Spark Streaming - Processing Multiple Batches

Slice : collection of batches
State : 
Windows : 

Time Slicing
DStream.slice(fromTime, toTime)
StreamingContext.remember(duration) 을 써줘야 함 ~ 데이터 버리지 말고 갖고있어!
=> state 유지 위해 뒤에서 계속 작업 해 줘야 함

ssc.checkpoint("checkpoints") < Set checkpoint directory(HDFS)
=> infinite lineages 방지 위해 사용
=> persist 와는 개념이 다름, lineage를 delete

updateStateByKey(lambda newCounts, state : updateCount ..

Sliding Window Operaions
reduceByKeyAndWindow(fn,Seconds(12),Seconds(4))
2번째 인자 : 한번 찍는 창의 범위(창의 길이)
3번째 인자 : 사진 찍는 간격(창의 간격)

reduceByKeyAndWindow(lambda v1,v2: v1+v2,5*60,30)
5분어치 데이터 30초마다 찍기











