~~~sql
select a.id as id, a.type as type, a.status as status, a.amount as amount, a.amount-b.average as difference 
from account a join (select avg(amount) as average, type from account where status = 'Active' group by type) b
on a.type = b.type
where a.status = 'Active'
;
~~~
