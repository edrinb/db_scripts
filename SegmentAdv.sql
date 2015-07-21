SELECT *  FROM TABLE (DBMS_SPACE.asa_recommendations ('FALSE', 'FALSE', 'FALSE'))

--CDR_UNBILLED_XC_SBSCR_N_TRNS 26097640281

alter index CDR_UNBILLED_PK rebuild online parallel 8
