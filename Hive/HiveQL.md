*where status='Active' 가 2회 들어가는게 맞나?*  
~~~sql
select a.id as id, a.type as type, a.status as status, a.amount as amount, a.amount-b.average as difference 
from account a join (select avg(amount) as average, type from account where status = 'Active' group by type) b
on a.type = b.type
where a.status = 'Active'
;
~~~


~~~
create database problem2;

use problem2;

hive> create external table solution(id INT, fname STRING, lname STRING, address STRING, city STRING, state STRING,
    > zip STRING, birthday STRING, hireday STRING)
    > row format SERDE 'parquet.hive.serde.ParquetHiveSerDe'
    > STORED AS 
    >     INPUTFORMAT "parquet.hive.DeprecatedParquetInputFormat"
    >     OUTPUTFORMAT "parquet.hive.DeprecatedParquetOutputFormat"
    >     LOCATION '/user/training/problem2/data/employee';
~~~

