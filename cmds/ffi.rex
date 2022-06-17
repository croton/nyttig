/* ffi -- find file utility using accumulated grep commands */
parse arg fspec searchString

w=wordpos('-xdirs', searchString)
if w>0 then do; excludeDir=subword(searchString,w+1); searchString=delword(searchString,w); end; else excludeDir=''

omitFoldersCmd=''
do w=1 to words(excludeDir)
  omitFoldersCmd=omitFoldersCmd '|grep -v "'word(excludeDir,w)'"'
end w

if searchString='' then do
  eCmd='@dir' fspec '/s /b' omitFoldersCmd '|repf'
  say eCmd
  ADDRESS CMD eCmd
end
else do
  -- Each word in search string will comprise a separate grep filter
  eCmd='@dir' fspec '/s /b' omitFoldersCmd '|asarg' searchCmd(fspec) '"'word(searchString, 1)'"'
  do w=2 to words(searchString)
    eCmd=eCmd'|grep -i "'word(searchString,w)'"'
  end w
  eCmd=eCmd '|repf'
  say eCmd
  ADDRESS CMD eCmd
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
