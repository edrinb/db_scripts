SELECT d.tablespace_name "Tablespace",
       ROUND(d.usedsz/1024/1024,0) "Size MB",
       ROUND(d.maxsz/1024/1024,0) "Max Size MB",
       ROUND((d.usedsz-f.freesz)/1024/1024,0) "Used MB",
       ROUND(100*(d.usedsz-f.freesz)/d.usedsz,2) "Used %",
       ROUND(100*((usedsz - f.freesz))/d.maxsz,2) "Used % "
  FROM (SELECT tablespace_name, SUM(DECODE(maxbytes,0,bytes,maxbytes)) maxsz, SUM(bytes) usedsz
          FROM dba_data_files
         GROUP BY tablespace_name) d,
       (SELECT tablespace_name, SUM(bytes) freesz
          FROM dba_free_space
         GROUP BY tablespace_name) f
 WHERE d.tablespace_name = f.tablespace_name (+)
 ORDER BY 5 DESC
