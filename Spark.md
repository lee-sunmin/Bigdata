map reduce program 의 단점 : 코딩이 복잡하다

그래서 hive가 나왔음 단점 : 느려요. 

map reduce의 장점 중 하나는 큰 데이터도 처리 할 수 있음.

mapreduce 3 가지

map - 데이터 분산, 각 mapper들이 자기 데이터 읽어 온 다음에 그 데이터만 가지고 처리(각각 분리된 데이터르 를 가지고 연산, key-value)

셔플 sort - 전체 key를 같은 곳으로 모아지게 한 다음에(key 로 sorting)

reduce -  같은 key가진애끼리 쪼개서 처리

=> 위와 같은 map reduce 과정이 여러번 진행되며 처리함


hdfs에서는 block단위로 저장(128mb)

reader들이 떠서 분산으로 데이터 처리 - ??

hdfs 에서 읽어옴, 분산되어 있는 데이터를 한  block씩 읽어옴 - mapper

local disk에서 local sort -> local disk에 쓰고 gloal sort 진행 -> local disk에 저장 - 셔플 sort

reducer들이 읽는다 -> reducer들이 hdfs에 다시 저장



(hdfs) => mapper => (local disk) => reducer => (hdfs)

단점은 disk read/write가 많네요.!! 

hive 테즈는 map/reduce 쓰지만 약간 개선하자

처음부터 map/reduce 말고 다른 방식을 하자! apache spark

테즈는 open soruce 지만, spark는 특정 회사에 의존을 해야 하기 때문에 클라우데라는 테즈로 가기로 했음.

kafka =>처리엔진 spark =>저장공간 HDFS, ..
snow flaker?s?

### Spark

RDD
실제로는 분산되어 있지만, 프로그래밍 할 때는 한 곳에서 작동하는 것처럼 작업 하게 될 것

1) Transformation

RDD A -> RDD B ( RDD들은 Immutable 하다. 기존 RDD 그대로 두고 새로운 RDD 생성하는것 ) : 이유는 분산병렬 시스템이기 때문

2) Actions

결과 값이 나오는 연산자들

.. 






