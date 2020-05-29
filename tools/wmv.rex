/* winmv -- Move a window on the desktop.
   Created 04-22-2019
*/
parse arg options
if options='-?' then call help

w=wordpos('-h',options)
if w>0 then do; h=word(options,w+1); options=delword(options,w,2); end; else h=''
w=wordpos('-v',options)
if w>0 then do; v=word(options,w+1); options=delword(options,w,2); end; else v=''
w=wordpos('-c',options)
if w>0 then do; coord=word(options,w+1); options=delword(options,w,2); end; else coord=''
w=wordpos('-n',options)
if w>0 then do; nudgeH=word(options,w+1); options=delword(options,w,2); end; else nudgeH=''
w=wordpos('-nv',options)
if w>0 then do; nudgeV=word(options,w+1); options=delword(options,w,2); end; else nudgeV=''
title=options

winMgr=.WindowsManager~new
thiswin=winMgr~ForegroundWindow
if thiswin=.nil then say 'Sorry, unable to find foreground window!'
else do
  if title='' then title=thiswin~Title
  if coord='' then do
    if (nudgeH='' & nudgeV='') then call moveWinByHV title, h, v
    else call nudgeWindow title, nudgeH, nudgeV
  end
  else do
    call moveWinByCoordinates title, coord
  end
end
exit

nudgeWindow: procedure expose winMgr
  -- trace 'r'
  parse arg title, horizontal, vertical
  winObj=winMgr~find(strip(title))
  if winObj=.nil then do
    say 'No such window entitled "'title'"'
    return
  end
  parse value winObj~Coordinates with left ',' top ',' right ',' bottom
  select
    when horizontal='' then h=0
    when \datatype(horizontal,'W') then h=1
    otherwise h=horizontal
  end
  select
    when vertical='' then v=0
    when \datatype(vertical,'W') then v=1
    otherwise v=vertical
  end
  say 'Nudge window by' h v
  winObj~moveTo(left+h, top+v)
  return

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
    -- Justify LEFT screen
    when h='L' then h=0
    when h='R' then h=flushRight(winObj)
    -- Justify RIGHT screen
    when h='LR' then h=1280
    when h='RR' then h=0 -- not yet implemented
    when \datatype(h,'W') then h=left
    otherwise nop
  end
  select
    when v='' then v=top
    when v='T' then v=0
    when v='B' then v=flushBottom(winObj)
    when v='BR' then v=1050-winHeight
    when \datatype(v,'W') then v=top
    otherwise nop
  end
  -- If there is no change just show info
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

flushRight: procedure expose winMgr
  use arg winObj
  parse value winMgr~desktopWindow~Coordinates with screenX ',' screenY ',' screenWidth ',' screenHeight
  parse value winObj~Coordinates with winL ',' winTop ',' winR ',' winBottom
  return screenWidth-(winR-winL)+5

flushBottom: procedure expose winMgr
  use arg winObj
  parse value winMgr~desktopWindow~Coordinates with screenX ',' screenY ',' screenWidth ',' screenHeight
  parse value winObj~Coordinates with winL ',' winTop ',' winR ',' winBottom
  taskbarHeight=34
  return screenHeight-(winBottom-winTop)-taskbarHeight

help:
  say 'winmv - Move a window on the desktop'
  say 'usage: winmv title [-h horizontal] [-v vertical] [-co corner]'
  say 'Special values for horizontal, vertical, corner:'
  say '  -h L = flush left on left screen'
  say '  -h R = flush right on left screen'
  say '  -h LR = flush left on right screen'
  say '  -h RR = flush right on right screen'
  say '  -v T = flush top'
  say '  -v B = flush bottom, left screen'
  say '  -v BR = flush bottom, right screen'
  say '  -n digits = nudge horizontally by digits'
  say '  -nv digits = nudge vertically by digits'
  say '  -c NW | NE | SW | SE = left screen corners'
  say '  -c NW2 | NE2 | SW2 | SE2 = right screen corners'
  exit

::requires 'winSystm.cls'
