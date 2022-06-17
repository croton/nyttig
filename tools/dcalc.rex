/* dcalc -- Date calculations
   See www.rexxla.org/rexxlang/mfc/datec.html
*/
arg option params
if abbrev('?', option) then call help

select
  when option='-A' then call addDate(params)
  when option='-D' then call getDaysFromToday(params)
  otherwise
    say 'Tomorrow is' getRelativeDate(1, 'W') getRelativeDate(1, 'S')
end
exit

addDate: procedure
  arg days, format
  if format='' then format='Normal'
  say days 'days from today:' getRelativeDate(days, format)
  return

-- Get difference in days from today and the specified date (in standard format YYYYMMDD)
getDaysFromToday: procedure
  arg standardDate, format
  if \datatype(standardDate,'W') || length(standardDate)<>8 then do
    say 'Please specify standard format, YYYYMMDD'
    return
  end
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
say '  -a = add days to today'
say '  -d = get difference in days'
exit
