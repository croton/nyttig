/* mergevaluef -- Pipe STDIN as values into a specified template */
parse arg template
SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
do forever
  parse pull data
  if data='' then iterate
  say merge(template, data)
end
exit

help:
  say 'mergevaluef - Pipe STDIN as values into a specified template'
  say 'usage: mergevaluef template'
  return

programEnd:
  exit 0

::requires 'UtilRoutines.rex'
