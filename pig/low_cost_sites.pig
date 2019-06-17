data = LOAD '/dualcore/ad_data[12]'
AS(
 campaign_id:chararray,
 date:chararray,
 time:chararray,
 keyword:chararray,
 display_site:chararray,
 placement:chararray,
 was_clicked:int,
 cpc:int);

 dcheck = FILTER data BY was_clicked == 1;

 dgroup = GROUP dcheck BY display_site;

 data2 = FOREACH dgroup GENERATE group AS display_size, SUM(dcheck.cpc) AS cost;

 dsort = ORDER data2 BY cost;

top_three = LIMIT dsort 3;

 DUMP top_three;
