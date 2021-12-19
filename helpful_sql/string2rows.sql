-- generate rows from string using delimiter
-- if null delimiter (default), outputs each character on its own line
-- delimiters can be multicharacter

-- uses a user defined type
-- notice it can only handle inputs up to 4000 characters.
create or replace type varchar2_tbl as table of varchar2(4000);
/

create or replace function string2rows (p_string varchar2, p_delimiter varchar2 default null) return varchar2_tbl as
  l_vtab varchar2_tbl := varchar2_tbl();
  l_delimiter_length number;
  l_delimiter_position number;
begin

  l_vtab.extend;

  if p_string is null then
    return l_vtab;
  end if;

  if p_delimiter is null then
    l_vtab(1):=substr(p_string,1,1);
    if length(p_string) > 1 then
      l_vtab := l_vtab multiset union all string2rows(substr(p_string,2),p_delimiter);
    end if;
  else
    l_delimiter_length:=length(p_delimiter); -- null if d is null
    l_delimiter_position:= instr(p_string,p_delimiter); -- null if d is null, 0 if d isn't in p
    if l_delimiter_position = 0 then
      l_vtab(1):=p_string;
    else
      l_vtab(1):=substr(p_string,1,l_delimiter_position-1);
      l_vtab := l_vtab multiset union all string2rows(substr(p_string,l_delimiter_position+l_delimiter_length),p_delimiter);
    end if;
  end if;
  return l_vtab;
  
end;
/
