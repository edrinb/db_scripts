DECLARE
  l_sql_tune_task_id  VARCHAR2(100);
BEGIN
  l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
                          begin_snap  => 13898,
                          end_snap    => 14106,
                          sql_id      => '2q94zb7djr2xn',
                          scope       => DBMS_SQLTUNE.scope_comprehensive,
                          time_limit  => 60,
                          task_name   => '2q94zb7djr2xn_AWR_tuning_task',
                          description => 'Tuning task for statement 19v5guvsgcd1v in AWR.');
  DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;


begin
    DBMS_SQLTUNE.execute_tuning_task(task_name => '2q94zb7djr2xn_AWR_tuning_task');
    --DBMS_SQLTUNE.drop_tuning_task (task_name => '2q94zb7djr2xn_AWR_tuning_task');
end;

SELECT task_name, status FROM dba_advisor_log where task_name = '2q94zb7djr2xn_AWR_tuning_task'
SELECT DBMS_SQLTUNE.report_tuning_task('2q94zb7djr2xn_AWR_tuning_task') AS recommendations FROM dual;
