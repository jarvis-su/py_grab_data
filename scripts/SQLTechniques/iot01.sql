@connect /
drop table iot;
drop table heap;
set echo on 
set linesize 121
clear screen
create table iot
( username         varchar2(30),
  document_name    varchar2(30),
  other_data       char(1000),
  constraint iot_pk primary key (username,document_name))
organization index
/
create table heap
( username         varchar2(30),
  document_name    varchar2(30),
  other_data       char(1000),
  constraint heap_pk primary key (username,document_name))
/
pause


clear screen
begin
    for i in 1 .. 100
    loop
        for x in ( select username from all_users )
        loop
            insert into heap
            (username,document_name,other_data) values
            ( x.username, x.username || '_' || i, 'x' );
 
            insert into iot
            (username,document_name,other_data) values
            ( x.username, x.username || '_' || i, 'x' );
        end loop;
    end loop;
    dbms_stats.gather_table_stats
    ( user, 'IOT', cascade=>true );
    dbms_stats.gather_table_stats
    ( user, 'HEAP', method_opt=>'for all indexed columns', cascade=>true );
    commit;
end;
/
pause

clear screen
@trace
pause
clear screen
declare
    l_rec   heap%rowtype;
    cursor heap_cursor(p_username in varchar2) is 
    select * from heap single_row where username = p_username;
    cursor  iot_cursor(p_username in varchar2) is 
    select * from  iot single_row where username = p_username;
begin
for i in 1 .. 10
loop
    for x in (select username from all_users) loop
        open heap_cursor(x.username);
        loop
            fetch heap_cursor into l_rec;
            exit when heap_cursor%notfound;
        end loop;
        close heap_cursor;
        open  iot_cursor(x.username);
        loop
            fetch  iot_cursor into l_rec;
            exit when  iot_cursor%notfound;
        end loop;
        close  iot_cursor;
    end loop;
end loop;
end;
/
pause
clear screen
declare
    type array is table of iot%rowtype;
    l_data array;
begin
for i in 1 .. 10
loop
    for x in (select username from all_users)
    loop
        select * bulk collect into l_data
          from heap bulk_collect
         where username = x.username;
        select * bulk collect into l_data
          from  iot bulk_collect
         where username = x.username;
    end loop;
end loop;
end;
/
pause
@tk "sys=no"
