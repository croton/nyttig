/* winmv -- Move a window on the desktop.
   Created 04-22-2019
*/
parse arg options
if options='-?' then call help

w=wordpos('-h',options)
if w>0 then do; h=word(options,w+1); options=delword(options,w,2); end; else h=''
w=wordpos('-v',options)
if w>0 then do; v=word(options,w+1); options=delword(options,w,2); end; else v=''
w=wordpos('-co',options)
if w>0 then do; coord=word(options,w+1); options=delword(options,w,2); end; else coord=''
title=options

winMgr=.WindowsManager~new
thiswin=winMgr~ForegroundWindow
if thiswin=.nil then say 'Sorry, unable to find foreground window!'
else do
  if title='' then title=thiswin~Title
  if coord='' then
    call moveWinByHV title, h, v
  else
    call moveWinByCoordinates title, coord
end
exit

moveWinByHV: procedure expose winMgr
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
    when v='B' then v=760-winHeight
    when v='BL' then v=760-winHeight
    when v='BR' then v=1050-winHeight
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

moveWinByCoordinates: procedure expose winMgr
  parse arg title, coordinates
  corner=translate(coordinates)
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
    when corner='NW' then do; h=0;              v=0; end
    when corner='NE' then do; h=1280-winWidth;  v=0; end
    when corner='SW' then do; h=0;              v=760-winHeight; end
    when corner='SE' then do; h=1280-winWidth;  v=760-winHeight; end
    when corner='NW2' then do; h=1280;          v=0; end
    when corner='NE2' then do; h=2947-winWidth; v=0; end
    when corner='SW2' then do; h=1280;          v=1050-winHeight; end
    when corner='SE2' then do; h=2947-winWidth; v=1050-winHeight; end
    otherwise h=0; v=0
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
  say 'usage: winmv title [-h horizontal] [-v vertical] [-co corner]'
  say 'Special values for horizontal, vertical, corner:'
  say '  -h LL = flush left on left screen'
  say '  -h LR = flush left on right screen'
  say '  -h RL = flush right on left screen'
  say '  -h RR = flush right on right screen'
  say '  -v T = flush top'
  say '  -v B = flush bottom, left screen'
  say '  -v BR = flush bottom, right screen'
  say '  -co NW | NE | SW | SE = left screen corners'
  say '  -co NW2 | NE2 | SW2 | SE2 = right screen corners'
  exit

::requires 'winSystm.cls'
