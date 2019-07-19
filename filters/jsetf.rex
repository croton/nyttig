/* jset -- A filter for creating json data sets. */
parse arg attributes
if attributes='' then do
  say 'Usage: jsetf attribute-name-list'
  exit
end

SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
do forever
  parse pull data
  if data='' then iterate
  say makerecord(data, attributes)
end
exit

makerecord: procedure
  parse arg values, attribs
  obj='{'
  lim=words(attribs)
  do w=1 to lim
    field=word(attribs,w)
    if w=lim then obj=obj field": '"subword(values, w)"'"
    else          obj=obj field": '"word(values, w)"',"
  end w
  return obj '},'

programEnd:
exit 0
