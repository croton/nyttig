/* idate - a filter to insert date and/or time */
arg dateformat
select
  when dateformat='MDY' then today=translate('Mm-Dd-CcYy', date('s'),'CcYyMmDd')
  when dateformat='SDY' then today=translate('Mm/Dd/CcYy', date('s'),'CcYyMmDd')
  when dateformat='DMY' then today=right(changestr(' ', date(),'-'),11,'0')
  otherwise today=translate('CcYy-Mm-Dd', date('s'),'CcYyMmDd')
end

SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
do forever
  parse pull data
  if data='' then iterate
  else say insertDateTime(data, today, time('c'))
end
exit

insertDateTime: procedure
  parse arg text, datevalue, timevalue
  newtext=changestr('?d', text, datevalue)
  return changestr('?t', newtext, timevalue)

programEnd:
exit 0
