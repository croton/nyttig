/* modf -- A filter for ... */
parse arg options
parse arg delim +1 before (delim) after (delim) options

SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
do forever
  parse pull data
  if data='' then iterate
  if before='' & after='' then say data
  else do
    if pos(before, data)>0 then say data
  end
end
exit

programEnd:
exit 0
