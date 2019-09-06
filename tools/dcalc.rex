/* dcalc -- Date calculations
   See also www.rexxla.org/rexxlang/mfc/datec.html
*/
arg option params
if option='-?' then call help

select
  when option='-A' then call addDate(params)
  when option='-D' then call getDaysFromToday(params)
  otherwise
    say 'Tomorrow is' getRelativeDate(1, 'S')
end

exit

addDate: procedure
  arg days, format
  if format='' then format='Normal'
  say days 'days from today:' getRelativeDate(days, format)
  return

getDaysFromToday: procedure
  arg standardDate, format
  -- subtract today from given date
  say 'Date' standardDate '('date('Normal', standardDate, 'S')') is' getDateDiff(standardDate) 'days from today'
  return

getDateDiff: procedure
  arg standardDate1, standardDate2
  -- Use today if date 2 is omitted
  if standardDate2='' then return date('Base', standardDate1, 'S')-date('Base')
  return date('Base', standardDate1, 'S')-date('Base', standardDate2, 'S')

getRelativeDate: procedure
  arg days, format
  newday=date('Base')+days
  return date(format, newday, 'Base')

help:
say 'dcalc - Date calculation tool'
say 'usage: dcalc option args'
exit
