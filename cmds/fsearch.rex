/* Simple file search */
parse arg fspec
if fspec='' then call help

rc=SysFileTree(fspec,'files.','FS')  -- DO = dir Only
if files.0=0 then do
  say 'No files found with filespec' fspec
  exit
end
do i=1 to files.0
  say i '->' files.i
end i
exit

help:
  say 'fsearch - simple file search'
  say 'usage: fsearch filespec'
  exit
