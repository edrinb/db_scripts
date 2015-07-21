select
  d.bs_key, d.backup_type, d.controlfile_included, d.incremental_level, d.pieces,
  to_char(d.start_time, 'yyyy-mm-dd hh24:mi:ss') start_time,
  to_char(d.completion_time, 'yyyy-mm-dd hh24:mi:ss') completion_time,
  d.elapsed_seconds, d.device_type, d.compressed, (d.output_bytes/1024/1024) output_mbytes, s.input_file_scan_only
from V$BACKUP_SET_DETAILS d
  join V$BACKUP_SET s on s.set_stamp = d.set_stamp and s.set_count = d.set_count
order by d.start_time;

select
  --d.bs_key, d.backup_type, d.controlfile_included, d.incremental_level, d.pieces,
  min(to_char(d.start_time, 'yyyy-mm-dd hh24:mi:ss')) start_time,
  max(to_char(d.completion_time, 'yyyy-mm-dd hh24:mi:ss')) completion_time,
  sum(d.output_bytes/1024/1024)output_mbytes
from V$BACKUP_SET_DETAILS d
  join V$BACKUP_SET s on s.set_stamp = d.set_stamp and s.set_count = d.set_count
order by d.start_time;

select * from v$block_change_tracking

select * from V$BACKUP_ASYNC_IO
select * from V$BACKUP_SEt
select * from V$BACKUP_SYNC_IO

SELECT   LONG_WAITS/IO_COUNT, FILENAME
FROM     V$BACKUP_ASYNC_IO
WHERE    LONG_WAITS/IO_COUNT > 0
ORDER BY LONG_WAITS/IO_COUNT DESC;
