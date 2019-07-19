/* modf -- A filter for ... */
parse arg options
parse arg delim +1 before (delim) after (delim) options

SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
do forever
  parse pull data
  if data='' then iterate
  if before='' & after='' then say data
  else if pos(before, data)=0 then iterate
  else do
    parse var data leading (before) between (after) trailing
    say between
    -- say changestr(before, data, after)
  end
end
exit

programEnd:
exit 0
