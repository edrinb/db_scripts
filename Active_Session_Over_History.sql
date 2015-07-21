select count(distinct session_id||session_serial#), to_char(sample_time, 'dd/mm/yyyy hh24') 
from dba_hist_active_sess_history
group by to_char(sample_time, 'dd/mm/yyyy hh24') 
