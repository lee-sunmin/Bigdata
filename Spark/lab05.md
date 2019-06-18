
[myspark.conf]
~~~
spark.app.name = My Spark App
spark.master = yarn-client
spark.executor.memory = 400M
~~~

[console]
~~~
  100  jupyter notebook
  101  spark-submit --master yarn-client --name 'Count JPGd' CountJPGs.py /loudacre/weblogs/*
  102  spark-submit --properties-file myspark.conf CountJPGs.py /loudacre/weblogs/*
  103  vi myspark.conf
  104  spark-submit --properties-file myspark.conf CountJPGs.py /loudacre/weblogs/*
  105  sudo cp /usr/lib/spark/conf/log4j.properties.template /usr/lib/spark/conf/log4j.properties
  107  spark-submit --properties-file /usr/lib/spark/conf/log4j.properties CountJPGs.py /loudacre/weblogs/*
  108  sudo gedit /usr/lib/spark/conf/log4j.properties
  109  spark-submit --properties-file /usr/lib/spark/conf/log4j.properties CountJPGs.py /loudacre/weblogs/*
  110  sudo gedit /usr/lib/spark/conf/log4j.properties
  111  spark-submit --properties-file /usr/lib/spark/conf/log4j.properties CountJPGs.py /loudacre/weblogs/*
~~~

110 : modify client name  
108 : log4j.rootCateory=DEBUG  
110 : log4j.rootCateory=INFO


