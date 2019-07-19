/* jsondata -- Read from the input (STDIN). */
call trace 'off'
signal on notready name programEnd

ctr=0
record=''
do forever
  parse pull input
  if input='' then do
    record=closeRecord(record)
    iterate
  end
  record=addProp(record, input)
end
exit

closeRecord: procedure
  parse arg obj
  if obj<>'' then say '{' obj '}'
  return ''

addProp: procedure
  parse arg record, name value
  if value='' then value='a' name
  if record='' then return name": '"strip(value)"'"
  return record',' name": '"strip(value)"'"

programEnd:
  say record
  exit 0
