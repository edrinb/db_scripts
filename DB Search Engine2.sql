DECLARE
  match_count integer;
  v_search_string varchar2(4000) := '105816';
BEGIN  
  FOR t IN (SELECT owner,
                   table_name, 
                   column_name 
              FROM all_tab_columns
             WHERE owner = 'PRODDTA' and data_type in ('NUMBER' /*'CHAR', 'VARCHAR2', 'NCHAR', 'NVARCHAR2', 
                                 'CLOB', 'NCLOB'*/) ) 
  LOOP   
    BEGIN
      EXECUTE IMMEDIATE    
        'SELECT COUNT(*) FROM '||t.owner || '.' || t.table_name||
        ' WHERE trim('||t.column_name||') like ''%'||v_search_string||'%'''   
         INTO match_count;  
      IF match_count > 0 THEN 
        dbms_output.put_line( t.owner || '.' || t.table_name ||' '||t.column_name||' '||match_count );
      END IF; 
    EXCEPTION
      WHEN others THEN
        dbms_output.put_line( 'Error encountered trying to read ' ||
                              t.column_name || ' from ' || 
                              t.owner || '.' || t.table_name );
    END;
  END LOOP;
END;
