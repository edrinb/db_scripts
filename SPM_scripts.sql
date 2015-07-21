select DBMS_SQLTUNE.REPORT_SQL_MONITOR(type=>'HTML', report_level=>'ALL',sql_id=>'2q94zb7djr2xn') as report
FROM dual;

select ss.snap_id, ss.instance_number node, begin_interval_time, sql_id, plan_hash_value,
nvl(executions_delta,0) execs,
(elapsed_time_delta/decode(nvl(executions_delta,0),0,1,executions_delta))/1000000 avg_etime,
(buffer_gets_delta/decode(nvl(buffer_gets_delta,0),0,1,executions_delta)) avg_lio
from DBA_HIST_SQLSTAT S, DBA_HIST_SNAPSHOT SS
where ss.snap_id = S.snap_id
and s.sql_id = '5a6r31yq1fqzq'
and ss.instance_number = S.instance_number
and executions_delta > 0
order by 1, 2, 3


--1j57hmf8ap184, a2x41wk6qz7f2, b0yuxjm2702zy, fgvcr04vqumx7, 0qz7bn9ycg6b2, 5a6r31yq1fqzq

select * from dba_hist_sqltext where sql_text like '%group by tipi%' and sql_text not like '%pivot%'


select * from v$sql where sql_id = '4gjprumcfyj9w'


select * from dba_hist_sqlstat where sql_id = '2q94zb7djr2xn'


select * from v$sql where sql_id = '4gd6b1r53yt88'

select * from h$pseudo_cursor where sql_id='4gd6b1r53yt88';

select * from v$open_cursor o where o.sql_id = '4gd6b1r53yt88'
and exists (select 1 from v$session s where s.SID = o.sid and s.STATUS = 'ACTIVE' and s.type = 'USER')

SELECT * FROM table(DBMS_XPLAN.DISPLAY_CURSOR('4gjprumcfyj9w',0));

