SELECT DBMS_SQLTUNE.report_sql_monitor(
  sql_id       => 'g3rmr9c0kpazt',
  type         => 'HTML',
  report_level => 'ALL') AS report
FROM dual;


BEGIN
  DBMS_SQLTUNE.DROP_SQLSET(
    sqlset_name => 'SQLSET20140207');
END;

BEGIN
  DBMS_SQLTUNE.CREATE_SQLSET(
    sqlset_name => 'SQLSET20140207',
    description => 'SQL Tuning Set for loading plan into SQL Plan Baseline');
END;

DECLARE
  cur sys_refcursor;
BEGIN
  OPEN cur FOR
    SELECT VALUE(P)
    FROM TABLE(
       dbms_sqltune.select_workload_repository(begin_snap=>14721, end_snap=>14825,basic_filter=>'sql_id = ''2q94zb7djr2xn''',attribute_list=>'ALL')
              ) p;
     DBMS_SQLTUNE.LOAD_SQLSET( sqlset_name=> 'SQLSET20140207', populate_cursor=>cur);
  CLOSE cur;
END;

SELECT
  first_load_time          ,
  executions as execs              ,
  parsing_schema_name      ,
  elapsed_time  / 1000000 as elapsed_time_secs  ,
  cpu_time / 1000000 as cpu_time_secs           ,
  buffer_gets              ,
  disk_reads               ,
  direct_writes            ,
  rows_processed           ,
  fetches                  ,
  optimizer_cost           ,
  sql_plan                ,
  plan_hash_value          ,
  sql_id                   ,
  sql_text
   FROM TABLE(DBMS_SQLTUNE.SELECT_SQLSET(sqlset_name => 'SQLSET20140207'))
   
DECLARE
my_plans pls_integer;
BEGIN
  my_plans := DBMS_SPM.LOAD_PLANS_FROM_SQLSET(
    sqlset_name => 'SQLSET20140207', 
    basic_filter=>'plan_hash_value = ''617797893'''
    );
END;

DECLARE
    report clob;
BEGIN
    report := DBMS_SPM.EVOLVE_SQL_PLAN_BASELINE(
                  sql_handle => 'SYS_SQL_c16fc94d027e9de9');
    DBMS_OUTPUT.PUT_LINE(report);
END;

