BEGIN 
  dbms_sqltune.create_sqlset(sqlset_name => 'SQLTST_20130702', 
                             description =>'Test SQL Tuning Set', sqlset_owner =>'LMDBPROD'); 
END; 
begin DBMS_SCHEDULER.CREATE_JOB(job_name => 'CREATE_STS_TueJul2_204818_610', 
                                job_type => 'PLSQL_BLOCK', 
                                job_action => 'DECLARE bf VARCHAR2(75); BEGIN bf := q''#UPPER(PARSING_SCHEMA_NAME) = ''LMDBPROD'' AND ELAPSED_TIME >= 1000000.0 #''; dbms_sqltune.capture_cursor_cache_sqlset( sqlset_name=>''SQLTST_20130702'', time_limit=>''86400'', repeat_interval=>''600'', basic_filter=>bf, sqlset_owner=>''LMDBPROD''); END;', 
enabled => TRUE); end;

-----
DECLARE 
bf VARCHAR2(75); 
BEGIN bf := q'#UPPER(PARSING_SCHEMA_NAME) = 'LMDBPROD' AND ELAPSED_TIME >= 1000000.0 #'; 
dbms_sqltune.capture_cursor_cache_sqlset( sqlset_name=>'SQLTST_20130702', time_limit=>'86400', repeat_interval=>'600', basic_filter=>bf, sqlset_owner=>'LMDBPROD'); END;
