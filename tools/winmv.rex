/* winmv -- Move a window on the desktop.
   Created 04-22-2019
*/
parse arg options
if options='-?' then call help

w=wordpos('-h',options)
if w>0 then do; h=word(options,w+1); options=delword(options,w,2); end; else h=''
w=wordpos('-v',options)
if w>0 then do; v=word(options,w+1); options=delword(options,w,2); end; else v=''
title=options

winMgr=.WindowsManager~new
thiswin=winMgr~ForegroundWindow
if thiswin=.nil then say 'Sorry, unable to find foreground window!'
else do
  if title='' then title=thiswin~Title
  call moveWinByTitle title, h, v
end
exit

moveWinByTitle: procedure expose winMgr
  parse arg title, horizontal, vertical
  h=translate(horizontal)
  v=translate(vertical)
  winObj=winMgr~find(strip(title))
  if winObj=.nil then do
    say 'No such window entitled "'title'"'
    return
  end
  winCoords=winObj~Coordinates
  parse var winCoords left ',' top ',' right ',' bottom
  winWidth=right-left
  winHeight=bottom-top
  select
    when h='' then h=left
    when h='LL' then h=0
    when h='LR' then h=1280
    when h='RL' then h=1280-winWidth
    when h='RR' then h=2947-winWidth
    when \datatype(h,'W') then h=left
    otherwise nop
  end
  select
    when v='' then v=top
    when v='T' then v=0
    when v='B' then v=1050-winHeight
    when \datatype(v,'W') then v=top
    otherwise nop
  end
  if (h=left & v=top) then do
    call getWindowInfo winObj~Title, winCoords, winWidth, winHeight
  end
  else do
    say 'Move' winObj~Title 'at' winCoords 'to' h'x'v
    winObj~moveTo(h, v)
  end
  return

getWindowInfo: procedure expose winMgr
  parse arg title, coords, w, h
  say 'Window "'title'" ('w'x'h') location: (left,top,right,bottom)' coords
  say '  desktop:' winMgr~desktopWindow~Coordinates
  return

showFirst: procedure expose winMgr
  dk=winMgr~desktopWindow
  c1=dk~firstChild
  say 'First child window of desktop is' c1~Title 'at' c1~Coordinates
  return

help:
  say 'winmv - Move a window on the desktop'
  say 'usage: winmv title [-h horizontal] [-v vertical]'
  say 'Special values for horizontal, vertical:'
  say '  -h LL = flush left on left screen'
  say '  -h LR = flush left on right screen'
  say '  -h RL = flush right on left screen'
  say '  -h RR = flush right on right screen'
  say '  -v T = flush top'
  say '  -v B = flush bottom'
  exit

::requires 'winSystm.cls'
