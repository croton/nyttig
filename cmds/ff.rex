/* File search */
parse arg fspec options
w=wordpos('-f',options)
if w>0 then do; fullpath=1; options=delword(options,w,1); end; else fullpath=0
w=wordpos('-h',options)
if w>0 then do; showfileinfo=0; options=delword(options,w,1); end; else showfileinfo=1
target=strip(options)

if fspec='' then call help

rc=SysFileTree(fspec,'files.','FSO')
if files.0=0 then do
  say 'No files found with filespec' fspec
  exit
end

if target='' then do
 if fullpath then do i=1 to files.0
    say files.i
  end i
 else do i=1 to files.0
    say filespec('n', files.i)
  end i
end
else do i=1 to files.0
  call SysFileSearch target, files.i, 'found.', 'N'
  if showfileinfo then do j=1 to found.0
    say filespec('N', files.i)':' found.j
  end j
  else do j=1 to found.0
    say subword(found.j, 2)
  end j
end i
exit

help:
  say 'ff - file search'
  say 'usage: ff filespec [options][searchString]'
  say 'options:'
  say '  -f = show full path for each file name'
  say '  -h = hide file name and line number info for search string matches'
  exit
