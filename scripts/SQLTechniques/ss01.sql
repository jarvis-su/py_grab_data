set echo on
set linesize 121

clear screen
set autotrace on statistics
set pause on
select *
  from (
select a.owner, count(b.owner)
  from big_table.big_table_owners a left join big_table.big_table b
    on (a.owner = b.owner and b.object_type = 'TABLE' )
 group by a.owner
 order by a.owner
       )
 where rownum <= 2
/
pause

set termout off
set pause off
select a.*, 
       (select count(*)
          from big_table.big_table b
         where b.owner = a.owner and b.object_type = 'TABLE' ) cnt
  from (
select a.owner
  from big_table.big_table_owners a
 order by a.owner
       ) a
 where rownum <= 2
/
pause
set pause on
set termout on
clear screen
select a.*, 
       (select count(*)
          from big_table.big_table b
         where b.owner = a.owner and b.object_type = 'TABLE' ) cnt
  from (
select a.owner
  from big_table.big_table_owners a
 order by a.owner
       ) a
 where rownum <= 2
/
pause

set termout off
set pause off
select a.*, 
       (select count(*)
          from big_table.big_table b
         where b.owner = a.owner and b.object_type = 'TABLE' ) cnt,
       (select min(created)
          from big_table.big_table b
         where b.owner = a.owner and b.object_type = 'TABLE' ) min_created,
       (select max(created)
          from big_table.big_table b
         where b.owner = a.owner and b.object_type = 'TABLE' ) max_created
  from (
select a.owner
  from big_table.big_table_owners a
 order by a.owner
       ) a
 where rownum <= 2
/
set pause on
set termout on
clear screen
select a.*, 
       (select count(*)
          from big_table.big_table b
         where b.owner = a.owner and b.object_type = 'TABLE' ) cnt,
       (select min(created)
          from big_table.big_table b
         where b.owner = a.owner and b.object_type = 'TABLE' ) min_created,
       (select max(created)
          from big_table.big_table b
         where b.owner = a.owner and b.object_type = 'TABLE' ) max_created
  from (
select a.owner
  from big_table.big_table_owners a
 order by a.owner
       ) a
 where rownum <= 2
/
pause


set termout off
set pause off
select owner,
       to_number(substr(data,1,10)) cnt,
       to_date(substr(data,11,14),'yyyymmddhh24miss') min_created,
       to_date(substr(data,25),'yyyymmddhh24miss') max_created
  from (
select owner, 
       (select to_char( count(*), 'fm0000000000') ||
               to_char( min(created),'yyyymmddhh24miss') || 
               to_char( max(created),'yyyymmddhh24miss') 
          from big_table.big_table b
         where b.owner = a.owner and b.object_type = 'TABLE' ) data
  from (
select a.owner
  from big_table.big_table_owners a
 order by a.owner
       ) a
 where rownum <= 2
       )
/
set pause on
set termout on
clear screen
select owner,
       to_number(substr(data,1,10)) cnt,
       to_date(substr(data,11,14),'yyyymmddhh24miss') min_created,
       to_date(substr(data,25),'yyyymmddhh24miss') max_created
  from (
select owner, 
       (select to_char( count(*), 'fm0000000000') ||
               to_char( min(created),'yyyymmddhh24miss') || 
               to_char( max(created),'yyyymmddhh24miss') 
          from big_table.big_table b
         where b.owner = a.owner and b.object_type = 'TABLE' ) data
  from (
select a.owner
  from big_table.big_table_owners a
 order by a.owner
       ) a
 where rownum <= 2
       )
/
pause


clear screen
create or replace type myType as object 
( cnt number, min_created date, max_created date )
/
set termout off
set pause off
select owner, a.data.cnt, a.data.min_created, a.data.max_created
  from (
select owner, 
       (select myType( count(*), min(created), max(created) ) 
          from big_table.big_table b
         where b.owner = a.owner and b.object_type = 'TABLE' ) data
  from (
select a.owner
  from big_table.big_table_owners a
 order by a.owner
       ) a
 where rownum <= 2
       ) a
/
set pause on
set termout on
set autotrace off
select owner, a.data.cnt, a.data.min_created, a.data.max_created
  from (
select owner, 
       (select myType( count(*), min(created), max(created) ) 
          from big_table.big_table b
         where b.owner = a.owner and b.object_type = 'TABLE' ) data
  from (
select a.owner
  from big_table.big_table_owners a
 order by a.owner
       ) a
 where rownum <= 2
       ) a
/
set autotrace on statistics
/
pause

set autotrace off
set pause off
