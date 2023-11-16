/* wmd -- Launch a command window of a specified size. */
parse arg options
if options='?' then call help

w=wordpos('-r',options)
if w>0 then do; rows=word(options,w+1); options=delword(options,w,2); end; else rows=30

w=wordpos('-c',options)
if w>0 then do; cols=word(options,w+1); options=delword(options,w,2); end; else cols=110

w=wordpos('-t',options)
if w>0 then do; title=word(options,w+1); options=delword(options,w,2); end; else title=''

w=wordpos('-fg',options)
if w>0 then do; fg=word(options,w+1); options=delword(options,w,2); end; else fg=''

w=wordpos('-bg',options)
if w>0 then do; bg=word(options,w+1); options=delword(options,w,2); end; else bg=''

w=wordpos('-d',options)
if w>0 then do; dir=word(options,w+1); options=delword(options,w,2); end; else dir=''

w=wordpos('-p',options)
if w>0 then do
  placement=subword(options, w+1)
  options=''
end
else placement=''

startOpt=setStartOptions(title, dir) winsetup(rows, cols, fg, bg, placement)
ADDRESS CMD 'echo' startOpt
ADDRESS CMD startOpt
exit

winsetup: procedure
  parse arg rows, cols, fg, bg, placement
  if \datatype(rows,'W') then rows=30
  if \datatype(cols,'W') then cols=110
  xcmd='mode con cols='cols 'lines='rows
  if bg='' then bg='F'; else bg=translateColor(bg)
  if fg<>'' then xcmd=xcmd '& color' bg||translateColor(fg)
  if placement<>'' then xcmd=xcmd '&' placeCmd(placement)
  return '"'xcmd'"'

translateColor: procedure expose COLORNAMES
  arg name
  colorpos=wordpos(name, 'BLACK BLUE GREEN AQUA RED PURPLE YELLOW . GRAY')
  if colorpos=0 then return 0
  return colorpos-1

setStartOptions: procedure
  parse arg title, dir
  xcmd='start'
  dirpath=directory(dir)
  if title<>'' then xcmd=xcmd '"'title'"'
  if dirpath<>'' then xcmd=xcmd '/D' dirpath
  return xcmd 'cmd /K'

placeCmd: procedure
  arg x y offx offy .
  xpos=0; ypos=0
  if x<>'' then xpos=x
  if y<>'' then ypos=y
  if x='' then return 'wmv -v' ypos
  else if y='' then return 'wmv -h' xpos
  if offx<>'' then do
    say 'Set window x offset to' offx columns2pixels(offx)
    xpos=columns2pixels(offx)
  end
  if offy<>'' then do
   say 'Set window y offset to' offy rows2pixels(offy)
   ypos=rows2pixels(offy)
  end
  return 'wmv -h' xpos '-v' ypos

columns2pixels: procedure
  arg cols
  if \datatype(cols,'W') then cols=100
  return format(cols*8.14545,,0)

rows2pixels: procedure
  parse arg rows
  if \datatype(rows,'W') then rows=50
  return format(rows*17.3,,0)

help:
  say 'wmd - Launch a command window of a specified size and options.'
  say '      (default = 110 x 30)'
  say 'usage: wmd [-r rows] [-c cols] [-t title] [-fg color] [-bg color] [-d directory] [-p x y]'
  say 'colors: black blue green aqua red purple yellow gray'
  exit
