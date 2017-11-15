set echo on
set linesize 121

clear screen
variable x varchar2(20)
variable n number
exec :x := '01-jan-2005'
exec :n := 5
select to_date(:x,'dd-mon-yyyy')+level-1
  from dual
connect by level <= :n 
/
pause
clear screen
with data(r) as
(select 1 r from dual
 union all
 select r+1 from data where r+1 <= 5)
select to_date(:x,'dd-mon-yyyy')+r-1
  from data
/
pause
clear screen
set pause off
