/* ffi -- find file utility using accumulated grep commands */
parse arg fspec searchString

if searchString='' then do
  eCmd='@dir' fspec '/s /b'
  ADDRESS CMD eCmd
end
else do
  -- Each word in search string will comprise a separate grep filter
  eCmd='@dir' fspec '/s /b |asarg' searchCmd(fspec) '"'word(searchString, 1)'"'
  do w=2 to words(searchString)
    eCmd=eCmd'|grep -i "'word(searchString,w)'"'
  end w
  noCommentsNoFullpath=eCmd'|grep -v "@"|repf'
  say noCommentsNoFullpath
  ADDRESS CMD noCommentsNoFullpath
end
exit

/* Determine options to grep by the specified filespec */
searchCmd: procedure
  parse arg fspec
  select
    when pos('*', fspec)>0 then options='-inH'
    when pos('?', fspec)>0 then options='-inH'
    otherwise options='-in'
  end
  return 'grep' options
