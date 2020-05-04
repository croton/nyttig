/* modf -- A filter for cropping or replacing */
parse arg delim +1 before (delim) after (delim) options
if .STDIN~chars then call pipe before, after, options
else call help
exit

pipe: procedure
  parse arg before, after, options
  SIGNAL ON NOTREADY NAME programEnd
  SIGNAL ON ERROR    NAME programEnd
  do forever
    parse pull data
    if data='' then iterate
    if before='' & after='' then say data
    else if pos(before, data)=0 then iterate
    else do
      parse var data leading (before) between (after) trailing
      if abbrev('CROP', translate(options)) then say between
      else say changestr(before, data, after)
    end
  end
  return

help:
  say 'modf - A filter for cropping or replacing'
  say 'usage: modf /before/after/options'
  say '  default option = (c)rop'
  return

programEnd:
  exit 0
