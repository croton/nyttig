/* wmd -- Launch a command window of a specified size. */
parse arg options
if options='-?' then call help

w=wordpos('-r',options)
if w>0 then do; rows=word(options,w+1); options=delword(options,w,2); end; else rows=30

w=wordpos('-c',options)
if w>0 then do; cols=word(options,w+1); options=delword(options,w,2); end; else cols=110

w=wordpos('-t',options)
if w>0 then do; title=word(options,w+1); options=delword(options,w,2); end; else title=''

w=wordpos('-fg',options)
if w>0 then do; fg=word(options,w+1); options=delword(options,w,2); end; else fg=''

ADDRESS CMD 'start cmd /K' winsetup(rows, cols, title, fg)
exit

winsetup: procedure
  parse arg rows, cols, title, color
  if \datatype(rows,'W') then rows=30
  if \datatype(cols,'W') then cols=110
  xcmd='mode con cols='cols 'lines='rows
  if title<>'' then xcmd=xcmd '& title' title
  if color<>'' then xcmd=xcmd '& color F'translateColor(color)
  return '"'xcmd'"'

translateColor: procedure expose COLORNAMES
  arg name
  colorpos=wordpos(name, 'BLACK BLUE GREEN AQUA RED PURPLE YELLOW . GRAY')
  if colorpos=0 then return 0
  return colorpos-1

help:
  say 'wmd - Launch a command window of a specified size.'
  say '      (default = 110 x 30)'
  say 'usage: wmd [-r rows] [-c cols] [-t title] [-fg fgColor]'
  say 'colors: black blue green aqua red purple yellow gray'
  exit
