connect /
set linesize 100
set echo on

drop table organized;
drop table disorganized;


clear screen
create table organized
as
select x.*
  from (select * from stage order by object_name) x
/ 
create table disorganized
as
select x.*
  from (select * from stage order by dbms_random.random) x
/ 
pause
clear screen
create index organized_idx on organized(object_name);
create index disorganized_idx on disorganized(object_name);
pause
clear screen
begin
dbms_stats.gather_table_stats
( user, 'ORGANIZED', 
  estimate_percent => 100, 
  method_opt=>'for all indexed columns size 254' 
);
dbms_stats.gather_table_stats
( user, 'DISORGANIZED', 
  estimate_percent => 100, 
  method_opt=>'for all indexed columns size 254' 
);
end;
/
pause


clear screen
select table_name, blocks, num_rows, 0.05*num_rows, 0.10*num_rows from user_tables 
where table_name like '%ORGANIZED' order by 1;
select table_name, index_name, clustering_factor from user_indexes 
where table_name like '%ORGANIZED' order by 1;
pause

clear screen
exec dbms_monitor.session_trace_enable
select /*+ index( organized organized_idx) */ 
  count(subobject_name) 
  from organized;
select /*+ index( disorganized disorganized_idx) */ 
  count(subobject_name) 
  from disorganized;
pause
@tk "sys=no"

column PLAN_TABLE_OUTPUT format a120 truncate
set autotrace traceonly explain
clear screen
select * from organized where object_name like 'X%';
pause

clear screen
select * from disorganized where object_name like 'X%';
pause


clear screen
select * from organized where object_name like 'A%';
pause

clear screen
select * from disorganized where object_name like 'A%';
pause
set autotrace off


set autotrace traceonly statistics
clear screen
set arraysize 10
select * from organized where object_name like 'X%';
pause
clear screen
select * from disorganized where object_name like 'X%';
pause

set autotrace traceonly statistics
clear screen
set arraysize 100
select * from organized where object_name like 'X%';
pause
clear screen
select * from disorganized where object_name like 'X%';
pause


set autotrace off
set arraysize 15
