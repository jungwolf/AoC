-- going with this one for now
-- only drops current users objects
-- only tested for tables...

create or replace procedure drop_object_if_exists(p_object_name varchar2, p_object_type varchar2) as
  num_exists number;
begin
  select count(*) into num_exists
  from user_objects a
  where a.object_name = p_object_name
    and a.object_type = p_object_type;

  if num_exists > 0 then
    execute immediate 'drop '||p_object_type||' '||p_object_name;
  end if;
end;
/
