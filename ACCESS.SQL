SELECT a.object,
       a.type,
       a.sid,
       b.serial#,
       b.username,
       b.osuser,
       b.program
FROM   v$access a,
       v$session b
WHERE  a.sid    = b.sid
AND    a.owner  = 'CBS_OWNER'
--AND    a.object = DECODE(UPPER('&2'), 'ALL', a.object, UPPER('&2'))
ORDER BY a.object;
