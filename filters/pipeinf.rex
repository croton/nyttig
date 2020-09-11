/* pipein -- A filter that pipes STDIN into a given file */
parse arg filename
PLACEHOLDER='?replace?'
if abbrev('-?', filename) then do
  say 'usage: pipeinf filename'
  exit
end

SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
info=.array~new
do forever
  parse pull data
  if data='' then iterate
  info~append(data)
end
exit

XprogramEnd:
  inp=.stream~new(filename)
  do while inp~lines>0
    data=inp~linein
    if word(data,1)=PLACEHOLDER then loop item over info
      say item
    end
    else say data
  end
  inp~close
  exit 0

programEnd:
  inp=.stream~new(filename)
  do while inp~lines>0
    data=inp~linein
    if word(data,1)=PLACEHOLDER then do
      parse var data . tmpl
      loop item over info
        say merge(tmpl, item)
      end
    end
    else say data
  end
  inp~close
  exit 0

::requires 'UtilRoutines.rex'
