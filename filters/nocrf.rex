/* nocrf -- A filter for removing CR, or line breaks. */
parse arg options

SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
do forever
  parse pull data
  if data='' then iterate
  -- call charout , strip(data, 'L')
  call charout , data||' '
end
exit

programEnd:
exit 0
