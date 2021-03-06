DECLARE 

taskname varchar2(30) := 'SQLACCESS8691038';
task_desc varchar2(256) := 'SQL Access Advisor';
task_or_template varchar2(30) := 'SQLACCESS_OLTP';
task_id number := 0;
num_found number;
sts_name varchar2(256) := 'SQLACCESS8691038_sts';
sts_cursor dbms_sqltune.sqlset_cursor;

BEGIN
dbms_advisor.reset_task(taskname);
select count(*) into num_found from user_advisor_sqla_wk_map where task_name = taskname and workload_name = sts_name;
IF num_found > 0 THEN
dbms_advisor.delete_sqlwkld_ref(taskname,sts_name,1);
END IF;
select count(*) into num_found from user_advisor_sqlw_sum where workload_name = sts_name;
IF num_found > 0 THEN
dbms_sqltune.delete_sqlset(sts_name);
END IF;
dbms_sqltune.create_sqlset(sts_name, 'Obtain workload from cursor cache');
OPEN sts_cursor FOR
SELECT VALUE(P)
FROM TABLE(dbms_sqltune.select_cursor_cache) P;
dbms_sqltune.load_sqlset(sts_name, sts_cursor);
CLOSE sts_cursor;
dbms_advisor.add_sqlwkld_ref(taskname,sts_name,1);
dbms_advisor.set_task_parameter(taskname,'VALID_ACTION_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'VALID_MODULE_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'SQL_LIMIT',DBMS_ADVISOR.ADVISOR_UNLIMITED);
dbms_advisor.set_task_parameter(taskname,'VALID_USERNAME_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'VALID_TABLE_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'INVALID_TABLE_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'INVALID_ACTION_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'INVALID_USERNAME_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'INVALID_MODULE_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'VALID_SQLSTRING_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'INVALID_SQLSTRING_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'ANALYSIS_SCOPE','ALL');
dbms_advisor.set_task_parameter(taskname,'RANKING_MEASURE','PRIORITY,OPTIMIZER_COST');
dbms_advisor.set_task_parameter(taskname,'DEF_PARTITION_TABLESPACE',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'TIME_LIMIT',10000);
dbms_advisor.set_task_parameter(taskname,'MODE','LIMITED');
dbms_advisor.set_task_parameter(taskname,'STORAGE_CHANGE',DBMS_ADVISOR.ADVISOR_UNLIMITED);
dbms_advisor.set_task_parameter(taskname,'DML_VOLATILITY','TRUE');
dbms_advisor.set_task_parameter(taskname,'WORKLOAD_SCOPE','PARTIAL');
dbms_advisor.set_task_parameter(taskname,'DEF_INDEX_TABLESPACE',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'DEF_INDEX_OWNER',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'DEF_MVIEW_TABLESPACE',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'DEF_MVIEW_OWNER',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'DEF_MVLOG_TABLESPACE',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'CREATION_COST','TRUE');
dbms_advisor.set_task_parameter(taskname,'JOURNALING','4');
dbms_advisor.set_task_parameter(taskname,'DAYS_TO_EXPIRE','30');
dbms_advisor.execute_task(taskname);
