DECLARE 

taskname varchar2(30) := 'SQLACCESS4897017';
task_desc varchar2(256) := 'SQL Access Advisor';
task_or_template varchar2(30) := 'SQLACCESS_EMTASK';
task_id number := 0;
num_found number;
sts_name varchar2(256) := 'SQLACCESS4897017_sts';
sts_cursor dbms_sqltune.sqlset_cursor;

BEGIN
/* Create Task */
dbms_advisor.create_task(DBMS_ADVISOR.SQLACCESS_ADVISOR,task_id,taskname,task_desc,task_or_template);
/* Reset Task */
dbms_advisor.reset_task(taskname);
/* Delete Previous STS Workload Task Link */
select count(*) into num_found from user_advisor_sqla_wk_map where task_name = taskname and workload_name = sts_name;
IF num_found > 0 THEN
dbms_advisor.delete_sqlwkld_ref(taskname,sts_name,1);
END IF;
/* Delete Previous STS */
select count(*) into num_found from user_advisor_sqlw_sum where workload_name = sts_name;
IF num_found > 0 THEN
dbms_sqltune.delete_sqlset(sts_name);
END IF;
/* Create STS */
dbms_sqltune.create_sqlset(sts_name, 'Obtain workload from cursor cache');
/* Select all statements in the cursor cache. */
OPEN sts_cursor FOR
SELECT VALUE(P)
FROM TABLE(dbms_sqltune.select_cursor_cache) P;
/* Load the statements into STS. */
dbms_sqltune.load_sqlset(sts_name, sts_cursor);
CLOSE sts_cursor;
/* Link STS Workload to Task */
dbms_advisor.add_sqlwkld_ref(taskname,sts_name,1);
/* Set STS Workload Parameters */
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
dbms_advisor.set_task_parameter(taskname,'INVALID_SQLSTRING_LIST','"@!"');
/* Set Task Parameters */
dbms_advisor.set_task_parameter(taskname,'ANALYSIS_SCOPE','ALL');
dbms_advisor.set_task_parameter(taskname,'RANKING_MEASURE','PRIORITY,OPTIMIZER_COST');
dbms_advisor.set_task_parameter(taskname,'DEF_PARTITION_TABLESPACE',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_task_parameter(taskname,'TIME_LIMIT',10000);
dbms_advisor.set_task_parameter(taskname,'MODE','COMPREHENSIVE');
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
/* Execute Task */
dbms_advisor.execute_task(taskname);
END;
