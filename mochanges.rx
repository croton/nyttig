/* mochanges - show the changed files in the last month. */
arg refdate

if refdate='' then call getChangesCurrentMonth
else               call getChangesSince refdate

exit

getChangesCurrentMonth: procedure
  parse value date() with dayno monthname .
  say centre(' Changed files during' translate(monthname)||' ',40,'*')
  'cf .' dayno
  return

getChangesSince: procedure
  arg standardDate
  -- Subtract today from given date
  dayno=abs(getDateDiff(standardDate))
  say centre(' Changed files since' date('Normal', standardDate, 'S')||' ',40,'*')
  'cf .' dayno
  return

getDateDiff: procedure
  arg standardDate1, standardDate2
  -- Use today if date 2 is omitted
  if standardDate2='' then return date('Base', standardDate1, 'S')-date('Base')
  return date('Base', standardDate1, 'S')-date('Base', standardDate2, 'S')

