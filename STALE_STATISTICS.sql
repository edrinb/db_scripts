select table_name, last_analyzed, stale_stats  
from dba_tab_statistics where stale_stats = 'YES' and owner = 'CBS_OWNER'

select index_name, table_name, last_analyzed, stale_stats 
from dba_ind_statistics where table_owner = 'CBS_OWNER' and stale_stats = 'YES'
