select * from (
SELECT s.sid, s.serial#, p.pid, p.spid, s.username, s.program,
       i.block_changes
FROM v$session s, v$sess_io i, v$process p
WHERE s.sid = i.sid
and s.paddr=p.addr
ORDER BY 7 desc
)
where rownum < 11;

SELECT dhso.object_name, dhso.obj#,
sum(db_block_changes_delta)
FROM dba_hist_seg_stat dhss,
dba_hist_seg_stat_obj dhso,
dba_hist_snapshot dhs
WHERE dhs.snap_id = dhss.snap_id
AND dhs.instance_number = dhss.instance_number
AND dhss.obj# = dhso.obj#
AND dhss.dataobj# = dhso.dataobj#
AND begin_interval_time BETWEEN to_date('16/11/2013 00:00:00','dd/mm/yyyy hh24:mi:ss') and to_date('16/11/2013 04:00:00','dd/mm/yyyy hh24:mi:ss')
GROUP BY dhso.object_name, dhso.obj#
order by sum(db_block_changes_delta) desc;

SELECT distinct dbms_lob.substr(sql_text,4000,1),
FROM dba_hist_sqlstat dhss,
dba_hist_snapshot dhs,
dba_hist_sqltext dhst
WHERE upper(dhst.sql_text) LIKE '%WINDOW%'
AND dhss.snap_id=dhs.snap_id
AND dhss.instance_Number=dhs.instance_number
AND dhss.sql_id = dhst.sql_id and rownum<2;
