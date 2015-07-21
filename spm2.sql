DECLARE
  l_sql_tune_task_id  VARCHAR2(100);
BEGIN
  l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
                          begin_snap  => 24767,
                          end_snap    => 24976,
                          sql_id      => '2q94zb7djr2xn',
                          scope       => DBMS_SQLTUNE.scope_comprehensive,
                          time_limit  => 300,
                          task_name   => '2q94zb7djr2xn',
                          description => 'Tuning task for statement 2q94zb7djr2xn2 in AWR.');
  DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;


begin
  dbms_sqltune.accept_sql_profile(task_name => 'dts4pgvmtfrys',
            replace => TRUE);
end;


begin
    --DBMS_SQLTUNE.reset_tuning_task(task_name => '4gjprumcfyj9w');
    DBMS_SQLTUNE.execute_tuning_task(task_name => '2q94zb7djr2xn');
    --DBMS_SQLTUNE.drop_tuning_task (task_name => '2q94zb7djr2xn');
end;

SELECT task_name, status FROM dba_advisor_log where task_name = '2q94zb7djr2xn_AWR_tuning_task'
SELECT DBMS_SQLTUNE.report_tuning_task('2q94zb7djr2xn') AS recommendations FROM dual;

begin
dbms_sqltune.accept_sql_profile(task_name => '2q94zb7djr2xn',
            task_owner => 'LMDBPROD', replace => TRUE);
end;

begin dbms_sqltune.create_sql_plan_baseline(task_name =>
            '2q94zb7djr2xn', owner_name => 'LMDBPROD', plan_hash_value =>
            1311086720);
end;
