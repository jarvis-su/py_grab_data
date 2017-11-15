create or replace view session_roles (
ROLE
) as
select u.name
from x$kzsro,user$ u
where kzsrorol!=userenv('SCHEMAID') and kzsrorol!=1 and u.user#=kzsrorol

/
