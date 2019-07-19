/* Simple file search */
parse arg fspec target
if fspec='' then call help

rc=SysFileTree(fspec,'files.','FSO')
if files.0=0 then do
  say 'No files found with filespec' fspec
  exit
end

if target='' then do i=1 to files.0
  say i files.i
end i
else do i=1 to files.0
  call SysFileSearch target, files.i, 'found.', 'N'
  do j=1 to found.0
    say filespec('N', files.i)':' found.j
  end j
end i
exit

help:
  say 'fsearch - simple file search'
  say 'usage: fsearch filespec [searchString]'
  exit
