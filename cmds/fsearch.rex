/* Simple file search */
parse arg fspec
rc=SysFileTree(fspec,'files.','FS')  -- DO = dir Only
if files.0=0 then do
  say 'No files found with filespec' fspec
  exit
end
do i=1 to files.0
  say i '->' files.i
end i
exit
