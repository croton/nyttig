/* rmsp -- A filter for switching a placeholder for a space. */
parse arg placeholder
if placeholder='' then placeholder='#'
ph=left(placeholder, 1)

SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
do forever
  parse pull data
  if data='' then iterate
  say translate(data, ' ', ph)
end
exit

programEnd:
exit 0
