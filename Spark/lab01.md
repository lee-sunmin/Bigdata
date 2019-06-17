~~~python

sc
myrdd=sc.textFile("file:/home/training/training_materials/data/frostroad.txt")
myrdd.count()
myrdd.collect()
logfiles="/loudacre/weblogs/*"
logsRDD = sc.textFile(logfiles)
jpglogRDD=logsRDD.filter(lambda line: ".jpg" in line)
jpglogsRDD.take(10)
jpglogRDD.take(10)
sc.textFile(logfiles).filter(lambda line: ".jpg" in line).count()
logsRDD.map(lambda line: line.split(' ')).take(5)
ipsRDD = logsRDD.map(lambda line: line.split(' ')[0])
ipsRDD.take(5)
for ip in ipsRDD.take(1): print ip
for ip in ipsRDD.take(10): print ip
ipsRDD.saveAsTextFile("/loudacre/iplist")
~~~

~~~
    1  hdfs dfs -mkdir /loudacre
    2  hdfs dfs -ls
    3  hdfs dfs -put ~/training_materials/data/weblogs/ /loudacre/
    4  hdfs dfs -cat /loudacre/iplist* | more
    5  hdfs dfs -cat /loudacre/iplist/* | more
    6  hdfs dfs -cat /loudacre/iplist/*
    7  hdfs dfs -ls /loudacre/iplist
    8  hdfs dfs -ls /loudacre/iplist/part-00181
~~~
