select to_char(s.begin_interval_time, 'YYYY/MM/DD') AS DATE_OF, round(sum(h.space_used_delta)/1024/1024, 3) AS DAY_GROWTH,
       round((sum(sum(h.space_used_delta)) OVER (ORDER BY to_char(s.begin_interval_time, 'YYYY/MM/DD') ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))/1024/1024, 3) CUMMULATIVE_GROWTH,
       round(free_space.schema_free_space - TOTAL_GROWTH.total_growth + (sum(sum(h.space_used_delta)) OVER (ORDER BY to_char(s.begin_interval_time, 'YYYY/MM/DD') ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))/1024/1024, 3) ACTUAL_SIZE
from dba_hist_seg_stat h,
     DBA_HIST_SNAPSHOT s,
     dba_objects d,
     ( select sum(s.BYTES)/1024/1024  schema_free_space from dba_segments s
       where s.owner = 'CBS_OWNER'
       --and s.tablespace_name = 'CUST_CDR_UNBILLED_IDX'
     )free_space,
     (select sum (h1.space_used_delta)/1024/1024 total_growth
      from dba_hist_seg_stat h1, dba_objects d1, DBA_HIST_SNAPSHOT s1
      where h1.snap_id = s1.snap_id
      and d1.OBJECT_ID = h1.obj#
     -- and d1.OBJECT_NAME in (select distinct segment_name from dba_segments where tablespace_name = 'CUST_CDR_UNBILLED_IDX' )
      and h1.space_used_delta > 0
      and d1.OWNER = 'CBS_OWNER'
     )TOTAL_GROWTH
where h.snap_id = s.snap_id
and d.OBJECT_ID = h.obj#
and h.space_used_delta > 0
and d.OWNER = 'CBS_OWNER'
--and d.OBJECT_NAME in (select distinct segment_name from dba_segments where tablespace_name = 'CUST_CDR_UNBILLED_IDX')
GROUP BY to_char(s.begin_interval_time, 'YYYY/MM/DD'), free_space.schema_free_space, TOTAL_GROWTH.total_growth
ORDER BY to_char(s.begin_interval_time, 'YYYY/MM/DD')
