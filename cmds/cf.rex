/* cf -- Show changed files within given number of days
   Created 06-28-2018
*/
parse arg options
if options='-?' then call help

folder=parseOption('-f', options)
if folder='' then folder='.'
days=parseOption('-d', options)
if \datatype(days,'W') then days=1
currdir=optionExists('-c', options)
if currdir then depth='-maxdepth 1'
else            depth=''

say 'Changed files in' folder 'in last' days 'day(s):'
xcmd='ufind' folder '-type f -mtime -'days depth
ADDRESS CMD xcmd
exit

/* Get value of a given switch within a string.
   Ex. parseOption('-dir', '-dir \myfolder -otherSwitch 1') -- returns '\myfolder'
*/
parseOption: procedure
  parse arg switch, options
  w=wordpos(switch,options)
  -- When switch exists return next word
  if w>0 then return word(options,w+1)
  else        return ''

parseOption2: procedure
  parse arg switch, options
  w=wordpos(switch,options)
  -- When switch exists return words till next switch
  if w>0 then do
    parse value subword(options,w+1) with val ' -' .
    return val
  end
  else return ''

optionExists: procedure
  parse arg switch, options
  return wordpos(switch,options)>0

help:
say 'cf - Show changed files in a folder within given number of days'
say 'usage: cf [-f folder] [-d days] [-c]'
say '  -c = search current folder only'
exit
