/* ffi -- find file utility using accumulated grep commands */
parse arg fspec searchString

if searchString='' then do
  eCmd='@dir' fspec '/s /b'
  ADDRESS CMD eCmd
end
else do
  -- each word in search string will comprise a separate grep filter
  eCmd='@dir' fspec '/s /b |asarg grep -iHn "'word(searchString, 1)'"'
  do w=2 to words(searchString)
    eCmd=eCmd'|grep -i "'word(searchString,w)'"'
  end w
  noCommentsNoFullpath=eCmd'|grep -v "@brief"|repf'
  say noCommentsNoFullpath
  ADDRESS CMD noCommentsNoFullpath
end
exit
