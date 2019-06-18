~~~Python

import sys
from pyspark import SparkContext

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print >> sys.stderr, "Usage: CountJPGs.py <logfile>"
        exit(-1)

    # Replace this line with your code:    
    sc = SparkContext()

    counts = sc.textFile(sys.argv[1]) \
    .filter(lambda line: ".jpg" in line).count()

    print(counts)

    sc.stop()
~~~


   95  vi CountJPGs.py  
   96  spark-submit CountJPGs.py /loudacre/weblogs/*  
   97  spark-submit --master yarn-client CountJPGs.py /loudacre/weblogs/*  
   -> Cluster
