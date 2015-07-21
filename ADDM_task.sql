BEGIN
  -- Create an ADDM task.
  DBMS_ADVISOR.create_task (
    advisor_name      => 'ADDM',
    task_name         => '26284_26471_AWR_SNAPSHOT',
    task_desc         => 'Advisor for snapshots 26284 to 26471.');

  -- Set the start and end snapshots.
  DBMS_ADVISOR.set_task_parameter (
    task_name => '26284_26471_AWR_SNAPSHOT',
    parameter => 'START_SNAPSHOT',
    value     => 26284);

  DBMS_ADVISOR.set_task_parameter (
    task_name => '26284_26471_AWR_SNAPSHOT',
    parameter => 'END_SNAPSHOT',
    value     => 26471);

  -- Execute the task.
  DBMS_ADVISOR.execute_task(task_name => '26284_26471_AWR_SNAPSHOT');
END;

SELECT DBMS_ADVISOR.get_task_report('26284_26471_AWR_SNAPSHOT') AS report
FROM   dual;
