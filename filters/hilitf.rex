/* hilite -- A filter for highlighting matches to a search string. */
parse arg searchfor

SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
if searchfor='' then do forever
  parse pull data
  if data='' then iterate
  say data
end
else do forever
  parse pull data
  if data='' then iterate
  if pos(searchfor, data)>0 then say '***' data
  else say data
end
exit

programEnd:
exit 0
