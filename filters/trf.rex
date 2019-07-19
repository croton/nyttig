/* trf -- A filter for translating characters. */
parse arg existing new
if new='' then new=' '

SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
do forever
  parse pull data
  if data='' then iterate
  say translate(data, new, existing)
end
exit

programEnd:
exit 0
