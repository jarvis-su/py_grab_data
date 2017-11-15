set echo on
set linesize 121
clear screen
delete from plan_table;
explain plan for
select * from (select * from scott.emp order by sal desc) where rownum <= 10;
pause
clear screen
select * from table(dbms_xplan.display);
pause


clear screen
delete from plan_table;
explain plan for
select * from scott.emp order by sal desc;
pause

clear screen
select * from table(dbms_xplan.display);
pause

clear screen
@mystat "sorts (disk)"
set autotrace traceonly statistics
select * 
  from (select * 
          from big_table.big_table
         order by object_id) where rownum <= 10;
set autotrace off
@mystat2
pause


clear screen
@mystat "sorts (disk)"
declare
   cursor c is 
      select * from big_table.big_table order by object_id;
   l_rec big_table.big_table%rowtype;
begin
   open c;
   for i in 1 .. 10
   loop
       fetch c into l_rec;
   end loop;
   close c;
end;
/
@mystat2
pause


clear screen
create index bt_idx on big_table.big_table(object_id) ;
@trace
pause

clear screen
set autotrace traceonly statistics
@trace
select * 
  from (select * 
          from big_table.big_table
         order by object_id) where rownum <= 10;
set autotrace off
pause
clear screen
declare
   cursor c is 
      select * from big_table.big_table order by object_id;
   l_rec big_table.big_table%rowtype;
begin
   open c;
   for i in 1 .. 10
   loop
       fetch c into l_rec;
   end loop;
   close c;
end;
/
pause
select * from dual;
@tk "sys=no"

drop index bt_idx; 
