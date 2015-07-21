select to_char(s.begin_interval_time, 'YYYY/MM/DD') AS DATE_OF, round(sum(h.space_used_delta)/1024/1024, 3) AS DAY_GROWTH,
       round((sum(sum(h.space_used_delta)) OVER (ORDER BY to_char(s.begin_interval_time, 'YYYY/MM/DD') ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))/1024/1024, 3) CUMMULATIVE_GROWTH,
       round(free_space.schema_free_space - TOTAL_GROWTH.total_growth + (sum(sum(h.space_used_delta)) OVER (ORDER BY to_char(s.begin_interval_time, 'YYYY/MM/DD') ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))/1024/1024, 3) ACTUAL_SIZE
from dba_hist_seg_stat h,
     DBA_HIST_SNAPSHOT s,
     dba_objects d,
     ( select sum(s.BYTES)/1024/1024  schema_free_space from dba_segments s
       --where s.owner = 'CBS_OWNER'
       --and s.tablespace_name = 'CUST_CDR_UNBILLED_IDX'
     )free_space,
     (select sum (h1.space_used_delta)/1024/1024 total_growth
      from dba_hist_seg_stat h1, dba_objects d1, DBA_HIST_SNAPSHOT s1
      where h1.snap_id = s1.snap_id
      and d1.OBJECT_ID = h1.obj#
     -- and d1.OBJECT_NAME in (select distinct segment_name from dba_segments where tablespace_name = 'CUST_CDR_UNBILLED_IDX' )
      and h1.space_used_delta > 0
      --and d1.OWNER = 'CBS_OWNER'
     )TOTAL_GROWTH
where h.snap_id = s.snap_id
and d.OBJECT_ID = h.obj#
and h.space_used_delta > 0
--and d.OWNER = 'CBS_OWNER'
--and d.OBJECT_NAME in (select distinct segment_name from dba_segments where tablespace_name = 'CUST_CDR_UNBILLED_IDX')
GROUP BY to_char(s.begin_interval_time, 'YYYY/MM/DD'), free_space.schema_free_space, TOTAL_GROWTH.total_growth
ORDER BY to_char(s.begin_interval_time, 'YYYY/MM/DD');


SELECT d.tablespace_name "Tablespace",
       ROUND(d.usedsz/1024/1024,0) "Size MB",
       ROUND(d.maxsz/1024/1024,0) "Max Size MB",
       ROUND((d.usedsz-f.freesz)/1024/1024,0) "Used MB",
       ROUND(100*(d.usedsz-f.freesz)/d.usedsz,2) "Used %",
       ROUND(100*((usedsz - f.freesz))/d.maxsz,2) "Used % "
  FROM (SELECT tablespace_name, SUM(DECODE(maxbytes,0,bytes,maxbytes)) maxsz, SUM(bytes) usedsz
          FROM dba_data_files
         GROUP BY tablespace_name) d,
       (SELECT tablespace_name, SUM(bytes) freesz
          FROM dba_free_space
         GROUP BY tablespace_name) f
 WHERE d.tablespace_name = f.tablespace_name (+)
 ORDER BY 5 DESC;
 
select nvl(owner, 'TOTALI'), sum(bytes)/(1024*1024) "Size MB" from dba_segments
group by cube(owner)
order by OWNER;

 
select trunc(to_date(rtime, 'mm/dd/yyyy hh24:mi:ss')) "Date", sum(growth.delta)*32/1024 "Growth MB"
from
(select tablespace_id, rtime, tablespace_size, 
tablespace_size - nvl(lag(tablespace_size) over (partition by tablespace_id order by rtime), tablespace_size) delta
from dba_hist_tbspc_space_usage
where to_char(to_date(rtime, 'mm/dd/yyyy hh24:mi:ss'), 'hh24') = '00'
order by tablespace_id, snap_id)growth
group by trunc(to_date(rtime, 'mm/dd/yyyy hh24:mi:ss'))
order by 1;


