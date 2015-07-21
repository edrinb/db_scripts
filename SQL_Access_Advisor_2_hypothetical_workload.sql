DECLARE 

taskname varchar2(30) := 'SQLACCESS2723890';
task_desc varchar2(256) := 'SQL Access Advisor';
task_or_template varchar2(30) := 'SQLACCESS_EMTASK';
task_id number := 0;
wkld_name varchar2(30) := 'SQLACCESS2723890_wkld';
saved_rows number := 0;
failed_rows number := 0;
num_found number;
hypo_schema varchar2(512);

BEGIN
/* Create Task */
dbms_advisor.create_task(DBMS_ADVISOR.SQLACCESS_ADVISOR,task_id,taskname,task_desc,task_or_template);
/* Reset Task */
dbms_advisor.reset_task(taskname);
/* Delete Previous Workload Task Link */
select count(*) into num_found from user_advisor_sqla_wk_map where task_name = taskname and workload_name = wkld_name;
IF num_found > 0 THEN
dbms_advisor.delete_sqlwkld_ref(taskname,wkld_name);
END IF;
/* Delete Previous Workload */
select count(*) into num_found from user_advisor_sqlw_sum where workload_name = wkld_name;
IF num_found > 0 THEN
dbms_advisor.delete_sqlwkld(wkld_name);
END IF;
/* Create Workload */
dbms_advisor.create_sqlwkld(wkld_name,null);
/* Link Workload to Task */
dbms_advisor.add_sqlwkld_ref(taskname,wkld_name);
/* Set Workload Parameters */
dbms_advisor.set_sqlwkld_parameter(wkld_name,'VALID_ACTION_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_sqlwkld_parameter(wkld_name,'VALID_MODULE_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_sqlwkld_parameter(wkld_name,'SQL_LIMIT',DBMS_ADVISOR.ADVISOR_UNLIMITED);
dbms_advisor.set_sqlwkld_parameter(wkld_name,'VALID_USERNAME_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_sqlwkld_parameter(wkld_name,'INVALID_TABLE_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_sqlwkld_parameter(wkld_name,'ORDER_LIST','PRIORITY,OPTIMIZER_COST');
dbms_advisor.set_sqlwkld_parameter(wkld_name,'INVALID_ACTION_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_sqlwkld_parameter(wkld_name,'INVALID_USERNAME_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_sqlwkld_parameter(wkld_name,'INVALID_MODULE_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_sqlwkld_parameter(wkld_name,'VALID_SQLSTRING_LIST',DBMS_ADVISOR.ADVISOR_UNUSED);
dbms_advisor.set_sqlwkld_parameter(wkld_name,'INVALID_SQLSTRING_LIST','"@!"');
dbms_advisor.set_sqlwkld_parameter(wkld_name,'JOURNALING','4');
dbms_advisor.set_sqlwkld_parameter(wkld_name,'DAYS_TO_EXPIRE','30');
hypo_schema := 'LMDBPROD';
dbms_advisor.set_sqlwkld_parameter(wkld_name,'VALID_TABLE_LIST',hypo_schema);
dbms_advisor.import_sqlwkld_schema(wkld_name,'REPLACE',2,saved_rows,failed_rows);
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
