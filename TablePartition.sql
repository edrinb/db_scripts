select tbl1.*, 'ALTER TABLE '||OBJECT_NAME||' DROP PARTITION '||TBL1.PARTITION_NAME||';' DROP_PARTITION,
'CREATE TABLE '||OBJECT_NAME||'_'||TO_CHAR(tbl1.HIGH_VALUE_PARTITION, 'YYYYMM')||' PARALLEL (DEGREE 8) COMPRESS NOLOGGING TABLESPACE CDR_ARCHIVE_'||TO_CHAR(tbl1.HIGH_VALUE_PARTITION, 'YYYYMM')||' AS SELECT * FROM '||OBJECT_NAME||' PARTITION ('||TBL1.PARTITION_NAME||');' CREATE_TABLE
from
(WITH 
xml_tab as (
SELECT DBMS_XMLGEN.GETXMLTYPE('SELECT TABLE_NAME, PARTITION_NAME, HIGH_VALUE FROM DBA_TAB_PARTITIONS DTP WHERE TABLE_OWNER=''IMPORTER2'' AND HIGH_VALUE_LENGTH = 83') AS xml
FROM   dual)
SELECT 
extractValue(xs.object_value, '/ROW/TABLE_NAME') OBJECT_NAME,
extractValue(xs.object_value, '/ROW/PARTITION_NAME') PARTITION_NAME,
trunc(to_date(substr(extractValue(xs.object_value, '/ROW/HIGH_VALUE'), 11, 10), 'YYYY-MM-DD')-1, 'Month') HIGH_VALUE_PARTITION
FROM xml_tab x, TABLE(XMLSEQUENCE(EXTRACT(x.xml, '/ROWSET/ROW'))) xs
ORDER BY 1, 3)tbl1
where tbl1.high_value_partition = '01-Feb-2014' --Vendosim muajin qe do eksportohet ne trajten 'DD-Mon-YYYY' 
and OBJECT_NAME in ('CDR_DATA','CDR_DATA_COMP','MTR','RC','RECHARGE_HISTORY','TRTECHARGABLEEVENTS')
--and not exists (select 1 from dba_tables dt where dt.OWNER = 'IMPORTER2' and dt.TABLE_NAME = tbl1.OBJECT_NAME||'_'||TO_CHAR(tbl1.HIGH_VALUE_PARTITION, 'YYYYMM'))
order by 3, 1


create table cdr_table_partitions as 
select tbl1.*, 'ALTER TABLE '||TABLE_OWNER||'.'||OBJECT_NAME||' DROP PARTITION '||TBL1.PARTITION_NAME||';' DROP_PARTITION,
'CREATE TABLE '||TABLE_OWNER||'.'||OBJECT_NAME||'_'||TO_CHAR(tbl1.HIGH_VALUE_PARTITION, 'YYYYMM')||' PARALLEL (DEGREE 8) COMPRESS NOLOGGING TABLESPACE CDR_ARCHIVE_'||TO_CHAR(tbl1.HIGH_VALUE_PARTITION, 'YYYYMM')||' AS SELECT * FROM '||TABLE_OWNER||'.'||OBJECT_NAME||' PARTITION ('||TBL1.PARTITION_NAME||');' CREATE_TABLE
from
(WITH 
xml_tab as (
SELECT DBMS_XMLGEN.GETXMLTYPE('SELECT TABLE_NAME, TABLE_OWNER, PARTITION_NAME, HIGH_VALUE FROM DBA_TAB_PARTITIONS DTP WHERE TABLE_OWNER=''CDR'' AND HIGH_VALUE_LENGTH = 83') AS xml
FROM   dual)
SELECT 
extractValue(xs.object_value, '/ROW/TABLE_NAME') OBJECT_NAME,
extractValue(xs.object_value, '/ROW/TABLE_OWNER') TABLE_OWNER,
extractValue(xs.object_value, '/ROW/PARTITION_NAME') PARTITION_NAME,
trunc(to_date(substr(extractValue(xs.object_value, '/ROW/HIGH_VALUE'), 11, 10), 'YYYY-MM-DD')-1, 'Month') HIGH_VALUE_PARTITION
FROM xml_tab x, TABLE(XMLSEQUENCE(EXTRACT(x.xml, '/ROWSET/ROW'))) xs
ORDER BY 1, 3)tbl1
--where tbl1.high_value_partition <= '01-Nov-2012' --Vendosim muajin qe do eksportohet ne trajten 'DD-Mon-YYYY' 
--and OBJECT_NAME in ('CDR_DATA','CDR_DATA_COMP','MTR','RC','RECHARGE_HISTORY','TRTECHARGABLEEVENTS')
--and not exists (select 1 from dba_tables dt where dt.OWNER = 'CDR' and dt.TABLE_NAME = tbl1.OBJECT_NAME||'_'||TO_CHAR(tbl1.HIGH_VALUE_PARTITION, 'YYYYMM'))
union
select tbl1.*, 'ALTER TABLE '||TABLE_OWNER||'.'||OBJECT_NAME||' DROP PARTITION '||TBL1.PARTITION_NAME||';' DROP_PARTITION,
'CREATE TABLE '||TABLE_OWNER||'.'||OBJECT_NAME||'_'||TO_CHAR(tbl1.HIGH_VALUE_PARTITION, 'YYYYMM')||' PARALLEL (DEGREE 8) COMPRESS NOLOGGING TABLESPACE CDR_ARCHIVE_'||TO_CHAR(tbl1.HIGH_VALUE_PARTITION, 'YYYYMM')||' AS SELECT * FROM '||TABLE_OWNER||'.'||OBJECT_NAME||' PARTITION ('||TBL1.PARTITION_NAME||');' CREATE_TABLE
from
(WITH 
xml_tab as (
SELECT DBMS_XMLGEN.GETXMLTYPE('SELECT TABLE_NAME, TABLE_OWNER, PARTITION_NAME, HIGH_VALUE FROM DBA_TAB_PARTITIONS DTP WHERE TABLE_OWNER=''CDR'' AND HIGH_VALUE_LENGTH <> 83') AS xml
FROM   dual)
SELECT 
extractValue(xs.object_value, '/ROW/TABLE_NAME') OBJECT_NAME,
extractValue(xs.object_value, '/ROW/TABLE_OWNER') TABLE_OWNER,
extractValue(xs.object_value, '/ROW/PARTITION_NAME') PARTITION_NAME,
(SELECT TRUNC(TD.FULLDATECODE-1, 'Month') FROM CDR.TIME_DIM TD WHERE TD.TIMEKEY = replace(extractValue(xs.object_value, '/ROW/HIGH_VALUE'),'''', '')) HIGH_VALUE_PARTITION
FROM xml_tab x, TABLE(XMLSEQUENCE(EXTRACT(x.xml, '/ROWSET/ROW'))) xs
ORDER BY 1, 3)tbl1
--where tbl1.high_value_partition <= '01-Nov-2012' --Vendosim muajin qe do eksportohet ne trajten 'DD-Mon-YYYY' 
--and OBJECT_NAME in ('CDR_DATA','CDR_DATA_COMP','MTR','RC','RECHARGE_HISTORY','TRTECHARGABLEEVENTS')
--and not exists (select 1 from dba_tables dt where dt.OWNER = 'CDR' and dt.TABLE_NAME = tbl1.OBJECT_NAME||'_'||TO_CHAR(tbl1.HIGH_VALUE_PARTITION, 'YYYYMM'))
order by 4, 1


