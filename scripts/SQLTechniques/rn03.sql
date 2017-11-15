set echo on
set linesize 121
clear screen
create index bt_idx on big_table.big_table(object_id) ;
pause
clear screen
@trace
set autotrace traceonly statistics
variable max number
variable min number
exec :min := 100; :max := 115;
pause
select * 
  from (select a.*, rownum rnum
          from (select /*+ FIRST_ROWS */ * from big_table.big_table order by object_id) a
         where rownum <= :Max) 
 where rnum >= :min;
set autotrace off
pause



clear screen
declare
   cursor c is 
      select * from big_table.big_table order by object_id;
   l_rec big_table.big_table%rowtype;
begin
   open c;
   for i in 1 .. 115
   loop
       fetch c into l_rec;
       if ( i < 100 )
       then
           null;
       else
        null; -- process it
       end if;
   end loop;
   close c;
end;
/
pause
drop index bt_idx;
@tk "sys=no"
