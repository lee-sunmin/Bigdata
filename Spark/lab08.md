~~~ Python
sqlContext
webpageDF = sqlContext \
.read.load("/loudacre/webpage")
webpageDF.printSchema()
webpageDF.show(5)
assocFilesDF = \
webpageDF.select(webpageDF.web_page_num, \
webpageDF.associated_files)
assocFilesDF.printSchema()
assocFilesDF.show(5)
aFilesRDD = assocFilesDF.map(lambda row: \
(row.web_page_num, row.associated_files))
aFilesRDD2 = aFilesRDD \
.flatMapValues( \
lambda filestring:filestring.split(','))
aFilesRDD2.take(2)
aFileDF = sqlContext. \
createDataFrame(aFilesRDD2, assocFilesDF.schema)
aFileDF.printSchema()
finalDF = aFileDF. \
withColumnRenamed('associated_files', \
'associated_file')
finalDF.printSchema()
finalDF.show(5)
finalDF.write. \
mode("overwrite"). ]
finalDF.write. \
mode("overwrite"). \
save("/loudacre/webpage_files")

~~~
