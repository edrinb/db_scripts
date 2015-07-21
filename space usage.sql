set echo on
set termout on
set serveroutput on size 1000000
set trimspool on

spool space_usage.log

declare
  unf number;
  unfb number;
  fs1 number;
  fs1b number;
  fs2 number;
  fs2b number;
  fs3 number;
  fs3b number;
  fs4 number;
  fs4b number;
  full number;
  fullb number;
begin
  dbms_space.space_usage('CBS_OWNER','CDR_UNBILLED_XC_BILLABLE','INDEX',unf,unfb,fs1,fs1b,fs2,fs2b,fs3,fs3b,fs4,fs4b,full,fullb);
  dbms_output.put_line('Total number of blocks that are unformatted: '||unf);
  dbms_output.put_line('Number of blocks that has at least 0 to 25% free space: '||fs1);
  dbms_output.put_line('Number of blocks that has at least 25 to 50% free space: '||fs2);
  dbms_output.put_line('Number of blocks that has at least 50 to 75% free space: '||fs3);
  dbms_output.put_line('Number of blocks that has at least 75 to 100% free space: '||fs4);
  dbms_output.put_line('Total number of blocks that are full in the segment: '||full);
end;
/
spool off
