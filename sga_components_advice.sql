select * from v$sga_target_advice;

SELECT
   shared_pool_size_for_estimate  "Pool |Size(M):",
   shared_pool_size_factor        "Size|Factor",
   estd_lc_size                   "Est|LC(M)",
   estd_lc_memory_objects         "Est LC|Mem. Obj.",
   estd_lc_time_saved             "Est|Time|Saved|(sec)",
   estd_lc_time_saved_factor       "Est|Parse|Saved|Factor",
   estd_lc_memory_object_hits      "Est|Object Hits"
FROM
   v$shared_pool_advice;
   
   column c1   heading 'Cache Size (m)'        format 999,999,999,999
column c2   heading 'Buffers'               format 999,999,999
column c3   heading 'Estd Phys|Read Factor' format 999.90
column c4   heading 'Estd Phys| Reads'      format 999,999,999
 
select
   size_for_estimate         "Cache Size (m)",
   buffers_for_estimate       "Buffers",
   estd_physical_read_factor  "Estd Phys|Read Factor",
   estd_physical_reads        "Estd Phys| Reads"
from
   v$db_cache_advice
where
   name = 'DEFAULT'
and
   block_size  = (SELECT value FROM V$PARAMETER
                   WHERE name = 'db_block_size')
and
   advice_status = 'ON';
