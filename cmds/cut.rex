/* cut - Parse input from a pipe by a delimiter. */
parse arg delim fieldnum .
if delim='-?' then call help

-- trace 'r'
multiwords=(right(fieldnum, 1)='-')
fieldnum=validateFieldnum(fieldnum)
signal on notready name programEnd
signal on novalue
do forever
  -- line=linein()
  parse pull line
  data=parseDelim(line, delim, fieldnum, multiwords)
  if data<>'' then say strip(data)
end
exit 1

validateFieldnum: procedure
  parse arg fnum
  if pos('-',fnum)>0 then do
    parse var fnum digit '-' .
    if datatype(digit,'W') then fnum=digit
    else                        fnum=1
  end
  else if \datatype(fnum,'W') then fnum=1
  return fnum

parseDelim: procedure
  parse arg line, delim, fieldnum, multiwords
  if delim='' then field=word(line, fieldnum)
  else do fieldnum
    parse var line field (delim) line
  end
  if multiwords then return field||delim||line
  else               return field

help:
 say 'cut - Parse input by a delimiter.'
 say '      If none specified space is used.'
 say 'usage: cut [delim][field-num]'
 exit 0

programEnd:
exit 0
