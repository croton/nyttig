/* Simple file search */
parse arg fspec target
if abbrev('?', fspec) then call help

w=wordpos('-r',target)
if w>0 then do; deepSearch=1; target=delword(target,w,1); end; else deepSearch=0

if deepSearch then rc=SysFileTree(fspec,'files.','FSO')
else               rc=SysFileTree(fspec,'files.','FO')
if files.0=0 then do
  say 'No files found with filespec' fspec
  exit
end

if target='' then do i=1 to files.0
  say i files.i
end i
else do
  searchFor=strip(target)
  say 'Search' files.0 'files for "'searchFor'"'
  do i=1 to files.0
    call SysFileSearch searchFor, files.i, 'found.', 'N'
    do j=1 to found.0
      say filespec('N', files.i)':' found.j
    end j
  end i
end
exit

help:
  say 'fsearch - simple file search'
  say 'usage: fsearch filespec [searchString] [-r]'
  say '  -r = recursive search'
  exit
