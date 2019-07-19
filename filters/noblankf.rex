/* noblankf -- A filter for removing blank lines */
parse arg options

SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
do forever
  parse pull data
  if data='' then iterate
  say data
end
exit

programEnd:
exit 0
