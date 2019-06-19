
~~~
# streamtest.py - lab09와 동일
python streamtest.py localhost 1234 20 /home/training/training_materials/data/weblogs/*

spark-submit --master 'local[2]' stubs-python/StreamingLogsMB.py localhost 1234
~~~


<StreamingLogsMB.py>
~~~ Python
import sys
from pyspark import SparkContext
from pyspark.streaming import StreamingContext

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print >> sys.stderr, "Usage: StreamingLogsMB.py <hostname> <port>"
        sys.exit(-1)

    # get hostname and port of data source from application arguments
    hostname = sys.argv[1]
    port = int(sys.argv[2])

    # Create a new SparkContext
    sc = SparkContext()

    # Set log level to ERROR to avoid distracting extra output
    sc.setLogLevel("ERROR")

    # Create and configure a new Streaming Context 
    # with a 1 second batch duration
    ssc = StreamingContext(sc,1)

    # Create a DStream of log data from the server and port specified    
    logs = ssc.socketTextStream(hostname,port)

    # TODO
    ssc.checkpoint("logcheckpt")

    reqcountsByWindow = logs.countByWindow(5,2).pprint()

    ssc.start()
    ssc.awaitTermination()
~~~


## Bonus 

<StreamingLogsMB.py>
~~~ Python
import sys
from pyspark import SparkContext
from pyspark.streaming import StreamingContext

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print >> sys.stderr, "Usage: StreamingLogsMB.py <hostname> <port>"
        sys.exit(-1)

    # get hostname and port of data source from application arguments
    hostname = sys.argv[1]
    port = int(sys.argv[2])

    # Create a new SparkContext
    sc = SparkContext()

    # Set log level to ERROR to avoid distracting extra output
    sc.setLogLevel("ERROR")

    # Create and configure a new Streaming Context 
    # with a 1 second batch duration
    ssc = StreamingContext(sc,1)

    # Create a DStream of log data from the server and port specified    
    logs = ssc.socketTextStream(hostname,port)

    # TODO
    ssc.checkpoint("logcheckpt")

    reqcountsByWindow = logs.countByWindow(5,2).pprint()

    countreq = logs \
    .map(lambda line: (line.split(' ')[2],1)) \
    .reduceByKey(lambda v1,v2:v1+v2)

    def updateCount(newCounts, state):
        if state == None: return sum(newCounts)
        else: return state+sum(newCounts)

    ## update count
    countDS = countreq \
    .updateStateByKey(lambda newCounts, state: \
    updateCount(newCounts, state))

    ## DS -> RDD sort by count
    countRDD = countDS \
    .map(lambda (k,v):(v,k)) \
    .transform(lambda rdd: rdd.sortByKey(False)).pprint()


    ssc.start()
    ssc.awaitTermination()
~~~
