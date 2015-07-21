create or replace package utils is
  --
  -- emartife.wordpress.com
  --
  function deflate(src in varchar2) return raw;
  function deflate(src in varchar2, quality in number) return raw;
  function inflate(src in raw) return varchar2;
  function unwrap(p_owner in varchar2, p_name in varchar2, p_type in varchar2) return clob;
end;
 
create or replace package body utils is
  --
  -- emartife.wordpress.com
  --
  function deflate(src in varchar2) return raw is
  begin
    return deflate(src, 6);
  end;
 
  function deflate(src in varchar2, quality in number) return raw as language java
    name 'utils_compress.Deflate(java.lang.String, int) return byte[]';
 
  function inflate(src in raw) return varchar2 as language java
    name 'utils_compress.Inflate(byte[]) return java.lang.String';
 
  function unwrap(p_owner in varchar2, p_name in varchar2, p_type in varchar2) return clob is
    --
    -- emartife.wordpress.com
    --
    cursor c_source is
      select text
      from all_source
      where owner = p_owner and name = p_name and type = p_type
      order by line;
    v_source clob;
    v_raw raw(32767);
    v_raw_tmp raw(32767);
    v_output clob;
 
    v_len number;
    v_offset number := 1;
    v_chunk_len number := 10080;
    v_enc_str varchar2(32767);  
    v_buffer raw(32767);
    v_inf raw(32767);
  begin
 
    -- Guardamos en un CLOB todas las líneas de código
    for reg in c_source loop
      v_source := v_source || rtrim(reg.text);
    end loop;
 
    -- Eliminamos las primeras 20 líneas
    -- PACKAGE BODY xxxx wrapped
    -- a000000
    -- 1
    -- abcd
    -- abcd
    -- abcd
    -- ...
    v_source := rtrim(substr(v_source, instr(v_source, chr(10), 1, 20) + 1), chr(10));
 
    -- Convertimos el CLOB a RAW y hacemos decode en base64. Está hecho en un bucle porque si se hace el decode
    -- de todo el código wrapped y éste es muy largo da error, así se evita
    v_len := dbms_lob.getlength(v_source);
    while v_offset < v_len loop
      if (v_len - v_offset) < 10080 then
        v_chunk_len := (v_len-v_offset);
      end if;
      v_enc_str := dbms_lob.substr(v_source, v_chunk_len, v_offset);
      v_raw_tmp := utl_raw.cast_to_raw(v_enc_str);
      v_buffer := utl_encode.base64_decode(v_raw_tmp);
      v_inf := v_inf || v_buffer;
      v_offset := v_offset + v_chunk_len;
    end loop;
 
    -- Eliminamos los primeros 40 carácteres
    v_inf:= substr(v_inf, 41);
 
    -- El mejor secreto está aquí !!!!!
    v_raw :=  utl_raw.translate(v_inf,
                                '000102030405060708090A0B0C0D0E0F' ||
                                '101112131415161718191A1B1C1D1E1F' ||
                                '202122232425262728292A2B2C2D2E2F' ||
                                '303132333435363738393A3B3C3D3E3F' ||
                                '404142434445464748494A4B4C4D4E4F' ||
                                '505152535455565758595A5B5C5D5E5F' ||
                                '606162636465666768696A6B6C6D6E6F' ||
                                '707172737475767778797A7B7C7D7E7F' ||
                                '808182838485868788898A8B8C8D8E8F' ||
                                '909192939495969798999A9B9C9D9E9F' ||
                                'A0A1A2A3A4A5A6A7A8A9AAABACADAEAF' ||
                                'B0B1B2B3B4B5B6B7B8B9BABBBCBDBEBF' ||
                                'C0C1C2C3C4C5C6C7C8C9CACBCCCDCECF' ||
                                'D0D1D2D3D4D5D6D7D8D9DADBDCDDDEDF' ||
                                'E0E1E2E3E4E5E6E7E8E9EAEBECEDEEEF' ||
                                'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF',
                                '3D6585B318DBE287F152AB634BB5A05F' ||
                                '7D687B9B24C228678ADEA4261E03EB17' ||
                                '6F343E7A3FD2A96A0FE935561FB14D10' ||
                                '78D975F6BC4104816106F9ADD6D5297E' ||
                                '869E79E505BA84CC6E278EB05DA8F39F' ||
                                'D0A271B858DD2C38994C480755E4538C' ||
                                '46B62DA5AF322240DC50C3A1258B9C16' ||
                                '605CCFFD0C981CD4376D3C3A30E86C31' ||
                                '47F533DA43C8E35E1994ECE6A39514E0' ||
                                '9D64FA5915C52FCABB0BDFF297BF0A76' ||
                                'B449445A1DF0009621807F1A82394FC1' ||
                                'A7D70DD1D8FF139370EE5BEFBE09B977' ||
                                '72E7B254B72AC7739066200E51EDF87C' ||
                                '8F2EF412C62B83CDACCB3BC44EC06936' ||
                                '6202AE88FCAA4208A64557D39ABDE123' ||
                                '8D924A1189746B91FBFEC901EA1BF7CE'
                               );
    -- Descomprimir el resultado. En v_output tendremos el código fuente para lo que queramos
    v_output :=  inflate(v_raw);
    return v_output;
  end;
end;
