set echo on
set linesize 121

clear screen
create or replace function f( x in varchar2 ) return number
as
begin	
	dbms_application_info.set_client_info(userenv('client_info')+1 );
	return length(x);
end;
/
pause

variable cpu number

clear screen
exec :cpu := dbms_utility.get_cpu_time; dbms_application_info.set_client_info(0);
set autotrace traceonly statistics;
select owner, f(owner) from stage;
set autotrace off
select dbms_utility.get_cpu_time-:cpu cpu_hsecs, userenv('client_info') from dual;
pause



clear screen
exec :cpu := dbms_utility.get_cpu_time; dbms_application_info.set_client_info(0);
set autotrace traceonly statistics;
select owner, (select f(owner) from dual) f from stage;
set autotrace off
select dbms_utility.get_cpu_time-:cpu cpu_hsecs, userenv('client_info') from dual;
pause


clear screen
exec :cpu := dbms_utility.get_cpu_time; dbms_application_info.set_client_info(0);
set autotrace traceonly statistics;
select owner, (select f(owner) from dual) f 
  from (select owner, rownum r from stage order by owner);
set autotrace off
select dbms_utility.get_cpu_time-:cpu cpu_hsecs, userenv('client_info') from dual;
pause


clear screen
create or replace function f( x in varchar2 ) return number
DETERMINISTIC
as
begin	
	dbms_application_info.set_client_info(userenv('client_info')+1 );
	return length(x);
end;
/
pause

clear screen
exec :cpu := dbms_utility.get_cpu_time; dbms_application_info.set_client_info(0);
set autotrace traceonly statistics;
select owner, f(owner) from stage;
set autotrace off
select dbms_utility.get_cpu_time-:cpu cpu_hsecs, userenv('client_info') from dual;
pause



clear screen
create or replace function f( x in varchar2 ) return number
RESULT_CACHE
as
begin	
	dbms_application_info.set_client_info(userenv('client_info')+1 );
	return length(x);
end;
/
pause

clear screen
exec :cpu := dbms_utility.get_cpu_time; dbms_application_info.set_client_info(0);
set autotrace traceonly statistics;
select owner, f(owner) from stage;
set autotrace off
select dbms_utility.get_cpu_time-:cpu cpu_hsecs, userenv('client_info') from dual;
pause

clear screen
exec :cpu := dbms_utility.get_cpu_time; dbms_application_info.set_client_info(0);
set autotrace traceonly statistics;
select owner, f(owner) from stage;
set autotrace off
select dbms_utility.get_cpu_time-:cpu cpu_hsecs, userenv('client_info') from dual;
pause

clear screen
exec :cpu := dbms_utility.get_cpu_time; dbms_application_info.set_client_info(0);
set autotrace traceonly statistics;
select owner, (select f(owner) from dual) from stage;
set autotrace off
select dbms_utility.get_cpu_time-:cpu cpu_hsecs, userenv('client_info') from dual;
pause
