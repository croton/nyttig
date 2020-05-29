/* indentf -- A filter for showing lines of a given indent level */
parse arg options .
SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
if \datatype(options,'W') then levels=0
else                           levels=min(10,options)
do forever
  parse pull data
  if data='' then iterate
  if levels=leadblanks(data) then say data
end
exit

help:
  say 'indentf - A filter for showing lines of a given indent level'
  say 'usage: indentf level'
  return

leadblanks:
  parse arg str
  return max(verify(str, ' ')-1,0)

programEnd:
  exit 0
