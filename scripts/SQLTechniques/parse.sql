set linesize 121

clear screen
variable txt varchar2(25)
exec :txt := 'a,bb,ccc,d,e,f';
pause

with data
as
(
select substr (txt,
               instr (txt, ',', 1, level  ) + 1,
               instr (txt, ',', 1, level+1) - instr (txt, ',', 1, level) -1 )
         as token
  from (select ','||:txt||',' txt from dual)
connect by level <= length(:txt)-length(replace(:txt,',',''))+1
)
select * from data;
pause
clear screen
set autotrace on
/
set autotrace off
