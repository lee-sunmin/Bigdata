~~~
#  Stream the web log files at a rate of 20 lines per second
python streamtest.py localhost 1234 20 $DEVDATA/weblogs/*

# [2] means using two thread
spark-submit --master 'local[2]' StreamingLogs.py localhost 1234
~~~

<streamtest.py>
~~~ Python
import sys
import time
import socket

if __name__ == "__main__":
  if len(sys.argv) < 4:
    print >> sys.stderr, "Usage: streamtest.py <host> <port> <lines-per-second> <files>"
    exit(-1)

  host = sys.argv[1]
  port = int(sys.argv[2])
  sleeptime = 1/float(sys.argv[3])
  filelist = sys.argv[4:]
  
  serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  serversocket.bind((host,port))
  serversocket.listen(1)

  while(1):
    print "Waiting for connection on",host,":",port
    (clientsocket,address) = serversocket.accept()
    print "Connection from",address
    for filename in filelist: 
      print "Sending",filename
      for line in open(filename): 
        print line
        clientsocket.send(line)
        time.sleep(sleeptime)
~~~

<StreamingLogs.py>
~~~ Python
import sys
from pyspark import SparkContext
from pyspark.streaming import StreamingContext

# Given an RDD of KB requests, print out the count of elements
def printRDDcount(rdd): print "Number of KB requests: "+str(rdd.count())

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print >> sys.stderr, "Usage: StreamingLogs.py <hostname> <port>"
        sys.exit(-1)

    # get hostname and port of data source from application arguments
    hostname = sys.argv[1]
    port = int(sys.argv[2])

    # Create a new SparkContext
    sc = SparkContext()

    # Set log level to ERROR to avoid distracting extra output
    sc.setLogLevel("ERROR")

    # TODO
    ssc = StreamingContext(sc,2)
    mystream = ssc.socketTextStream(hostname, port)
    userreqs = mystream \
    .filter(lambda line: "KBDOC" in line)

    userreqs.pprint()

    userreqs.saveAsTextFiles("/loudacre/streamlog/kblogs")

    ssc.start()
    ssc.awaitTermination()

~~~
