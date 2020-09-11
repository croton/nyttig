/* mergetemplatef -- Pipe STDIN as templates for specified values */
parse arg values
SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
do forever
  parse pull data
  say merge(data, values)
end
exit

help:
  say 'mergetemplatef - Pipe STDIN as templates for specified values'
  say 'usage: mergetemplatef values'
  return

programEnd:
  exit 0

::requires 'UtilRoutines.rex'
