### 1

*where status='Active' 가 2회 들어가는게 맞나?*  
~~~sql
select a.id as id, a.type as type, a.status as status, a.amount as amount, a.amount-b.average as difference 
from account a join (select avg(amount) as average, type from account where status = 'Active' group by type) b
on a.type = b.type
where a.status = 'Active'
;
~~~

### 2

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
![2](https://user-images.githubusercontent.com/17976251/60730159-6f640680-9f7f-11e9-877e-9c6eb5179044.jpg)


### 3
~~~ 
create external table solution(id string, fname string, lname string, hphone string);


select b.id as id , b.fname as fname, b.lname as lname, regexp_replace(b.hphone,'[ )(-]','') as hphone
from account a join customer b
on a.custid=b.id
where a.amount < 0
;
~~~


### 4

~~~
create external table employee1 
( 
cust_id int, 
lname string, 
fname string, 
address string, 
city string, 
state string, 
zip_cd string 
) 
row format delimited 
fields terminated by '\t' 
location '/user/training/problem4/data/employee1/.' 
~~~

~~~
create external table employee1 
( 
cust_id int, 
lname string, 
fname string, 
address string, 
city string, 
state string, 
zip_cd string 
) 
row format delimited 
fields terminated by '\t' 
location '/user/training/problem4/data/employee1/.' 


~~~

* employee1

10000000	Olga	Booker	Ap #643-2741 Proin Street	Gresham	OR	42593-0000
10000001	Raja	Spence	P.O. Box 765, 7700 Eros Rd.	Duluth	MN	67110-0000
10000002	Meredith	Schwartz	3414 At Road	San Antonio	TX	35713-0000
10000003	Thor	Lloyd	2703 Amet, Road	Rock Springs	WY	73861-0000
10000004	Arden	Mooney	Ap #888-1187 Aliquam Road	Rockville	MD	82478-0000
10000005	Kenneth	Lucas	Ap #637-8746 Feugiat Av.	Boston	MA	84047-0000

* employee2

10010000,656,HULL,WARREN,7593 Pede. Rd.,Kansas City,MO,55725
10010001,142,HAYES,KASPER,425-3365 Feugiat Rd.,Springfield,MO,27927
10010002,417,BARRETT,SYBILL,Ap #367-7227 Eu Street,Hartford,CT,83690
10010003,925,VALDEZ,THOR,"212-6890 Risus, St.",Springfield,MO
10010004,832,BALLARD,WYNNE,748-4292 Vel Road,Hillsboro,OR,53903
10010005,536,GLASS,ZOE,Ap #565-7061 Massa. Rd.,Bear,DE,83658

~~~
create table solution as
select res.cust_id, res.fname, res.lname, res.address, res.city, res.state, res.zip_cd
from
(
select cust_id, fname, lname, address, city, state, substr(zip_cd,0,5) zip_cd
from employee1
where state = 'CA'

union all

select cust_id, initcap(fname) fname, initcap(lname) lname, address, city, state, zip_cd
from employee2
where state = 'CA'
) res
;

~~~

~~~
insert OVERWRITE DIRECTORY '/user/training/problem4/solution/'
SELECT * FROM solution
;
~~~

### 5

* customer

<img width="1060" alt="customer" src="https://user-images.githubusercontent.com/17976251/61221063-9fb35e00-a752-11e9-9edd-1f2cf8b76dd7.png">

* employee

<img width="1050" alt="employee" src="https://user-images.githubusercontent.com/17976251/61221066-a17d2180-a752-11e9-8eb5-b8c1ea345c03.png">

* Point : fields 사이에 '\t' delimiter
~~~
select concat_ws('\t', cus.fname, cus.lname, cus.city, cus.state)
from customer cus
where city='Palo Alto'
and state = 'CA'

union all

select concat_ws('\t', emp.fname, emp.lname, emp.city, emp.state)
from employee emp
where city='Palo Alto'
and state = 'CA'
;
~~~

실행
~~~
hive --database problem5 -f solution.sql
~~~

### 6

~~~
create table solution as
select id,fname,lname,address,city,state,zip,substr(birthday,0,5) birthday
from employee
~~~

### 7

~~~
select concat_ws(' ',res.fname,res.lname)
from
(
select fname,lname
from employee
where city = 'Seattle'
order by fname, lname
) res
;
~~~

실행
~~~
hive --database problem7 -f solution.sql
~~~

* 데이터  
<img width="1054" alt="employee" src="https://user-images.githubusercontent.com/17976251/61224397-777b2d80-a759-11e9-931b-b813d3633691.png">

* 결과  
<img width="190" alt="result" src="https://user-images.githubusercontent.com/17976251/61224420-83ff8600-a759-11e9-895f-7f4c7a2fd055.png">


### 8

sqoop export \
--connect jdbc:mysql://localhost/problem8 \
--username cloudera \
--password cloudera \
--table solution \
--fields-terminated-by '\t' \
--export-dir /user/training/problem8/data/customer/.


### 9

~~~
# concat 사용하니까 id의 type이 자동으로 string이 되었음.
create table solution as
select concat('A',id) id, fname, lname, address, city, state, zip, birthday from customer
;

select * from solution limit 5;
~~~


* data  
<img width="1051" alt="data" src="https://user-images.githubusercontent.com/17976251/61292052-2deb1b00-a80b-11e9-9092-c9ab78382a2d.png">

* result  
<img width="1065" alt="result" src="https://user-images.githubusercontent.com/17976251/61292058-304d7500-a80b-11e9-9f04-0410db8cdb39.png">


### 10

~~~
create view solution as
select c.id id, c.fname fname, c.lname lname, c.city city, c.state state, b.charge charge, substr(b.tstamp,0,10) billdata
from billing b, customer c
where b.id = c.id
;
~~~  

* result  
<img width="1049" alt="result" src="https://user-images.githubusercontent.com/17976251/61293226-2d07b880-a80e-11e9-8486-3f102f75f4d3.png">

### 11
a.
~~~
select o.prod_id, count(*) cnt from order_details o, products p
where o.prod_id = p.prod_id
and p.brand = 'Dualcore'
group by o.prod_id
order by cnt desc
limit 3;
~~~
* result  
<img width="1053" alt="result" src="https://user-images.githubusercontent.com/17976251/61295354-d8b30780-a812-11e9-8438-1c8c85d6342b.png">


b.
~~~
select to_date(o.order_date) date, sum(p.price) revenue, sum(p.price-p.cost) profit
from orders o, order_details d, products p
where o.order_id = d.order_id
and d.prod_id = p.prod_id
and p.brand = 'Dualcore'
group by to_date(o.order_date);
~~~


c.
~~~
select o.order_id order_id, sum(p.price) revenue
from orders o, order_details d, products p
where o.order_id = d.order_id
and d.prod_id = p.prod_id
group by o.order_id
order by revenue desc
limit 10;
~~~
* result  
<img width="872" alt="c_result" src="https://user-images.githubusercontent.com/17976251/61302735-40704f00-a821-11e9-8bd2-eb84b681dd32.png">






