@connect /

set linesize 121
set echo on
drop table t;

clear screen
create table t
as select decode( mod(rownum,2), 0, 'N', 'Y' ) flag1,
          decode( mod(rownum,2), 0, 'Y', 'N' ) flag2, a.*
  --from big_table.big_table a
from stage a
 where rownum <= 50000
/
create index t_idx on t(flag1,flag2);
begin
	dbms_stats.gather_table_stats
	( user, 'T', 
	  method_opt=>'for all indexed columns size 254' );
end;
/
select num_rows, num_rows/2, num_rows/2/2 from user_tables where table_name = 'T';
pause

clear screen
set autotrace traceonly explain
select * from t where flag1='N';
pause
clear screen
select * from t where flag2='N';
pause
clear screen
select * from t where flag1='N' and flag2='N';
pause
clear screen
@trace
select /*+ dynamic_sampling(t 3) */ * from t where flag1='N' and flag2='N';
set autotrace off
pause
@tk "sys=no"
