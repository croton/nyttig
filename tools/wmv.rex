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

H_OFFSET=7 -- a device-specific difference bw desktop width and position of right screen border
SCREEN_2_LEFT=1915 -- our current monitor 2 screen beginning pos x-axis
SCREEN_2_WIDTH=3847 -- our current monitor 2 screen width
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

moveWinByHV: procedure expose winMgr H_OFFSET SCREEN_2_LEFT SCREEN_2_WIDTH
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
  parse value winMgr~desktopWindow~Coordinates with screenX ',' screenY ',' screenWidth ',' screenHeight
  select
    when h='' then h=left
    -- Justify LEFT screen
    when h='L' then h=0-H_OFFSET
    when h='R' then h=alignRight(screenWidth, winWidth, H_OFFSET)
    when h='C' then h=alignCenterH(screenWidth, winWidth)
    -- Justify RIGHT screen
    when h='L2' then h=SCREEN_2_LEFT
    when h='R2' then h=alignRight(SCREEN_2_WIDTH, winWidth)
    when \datatype(h,'W') then h=left
    otherwise nop
  end
  select
    when v='' then v=top
    when v='T' then v=0
    when v='B' then v=alignBottom(screenHeight, winHeight)
    when v='C' then v=alignCenterV(screenHeight, winHeight)
    -- when v='BR' then v=1050-winHeight
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

moveWinByCoordinates: procedure expose winMgr H_OFFSET
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
  parse value winMgr~desktopWindow~Coordinates with screenX ',' screenY ',' screenWidth ',' screenHeight
  select
    when corner='NW' then do
      h=0-H_OFFSET;
      v=0
    end
    when corner='NC' then do
      h=alignCenterH(screenWidth, winWidth)
      v=0
    end
    when corner='NE' then do
      h=alignRight(screenWidth, winWidth, H_OFFSET)
      v=0
    end
    when corner='C' then do
      h=alignCenterH(screenWidth, winWidth)
      v=alignCenterV(screenHeight, winHeight)
    end
    when corner='SW' then do
      h=0-H_OFFSET
      v=alignBottom(screenHeight, winHeight)
    end
    when corner='SC' then do
      h=alignCenterH(screenWidth, winWidth)
      v=alignBottom(screenHeight, winHeight)
    end
    when corner='SE' then do
      h=alignRight(screenWidth, winWidth, H_OFFSET)
      v=alignBottom(screenHeight, winHeight)
    end
    /*
    when corner='NW2' then do; h=1280;              v=0; end
    when corner='NE2' then do; h=2947-winWidth;     v=0; end
    when corner='SW2' then do; h=1280;              v=1050-winHeight; end
    when corner='SE2' then do; h=2947-winWidth;     v=1050-winHeight; end
    */
    otherwise h=0-H_OFFSET; v=0
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

flushRight: procedure expose winMgr H_OFFSET
  use arg winObj
  parse value winMgr~desktopWindow~Coordinates with screenX ',' screenY ',' screenWidth ',' screenHeight
  parse value winObj~Coordinates with winL ',' winTop ',' winR ',' winBottom
  return screenWidth-(winR-winL)+H_OFFSET

flushBottom: procedure expose winMgr
  use arg winObj
  parse value winMgr~desktopWindow~Coordinates with screenX ',' screenY ',' screenWidth ',' screenHeight
  parse value winObj~Coordinates with winL ',' winTop ',' winR ',' winBottom
  taskbarHeight=34 -- subtract this from figure below to place above taskbar
  return screenHeight-(winBottom-winTop)

alignRight: procedure
  arg screenWidth, winWidth, offset
  if \datatype(offset,'W') then offset=0
  return screenWidth-winWidth+offset

alignCenterH: procedure
  arg screenWidth, winWidth
  return format((screenWidth-winWidth)/2,,0)-1

alignCenterV: procedure
  arg screenHeight, winHeight
  return format((screenHeight-winHeight)/2,,0)-1

alignBottom: procedure
  arg screenHeight, winHeight
  return screenHeight-winHeight

help:
  say 'winmv - Move a window on the desktop'
  say 'usage: winmv title [-h horizontal] [-v vertical] [-c placement]'
  say 'Special values for horizontal, vertical, corner:'
  say '  -h L | L2 | C | R | R2 | n = align horizontally'
  say '  -v T | C | B | n = align vertically'
  say '  -n digits = nudge horizontally by digits'
  say '  -nv digits = nudge vertically by digits'
  say '  -c NW | NC | NE | C | SW | SC | SE = placements'
  exit

::requires 'winSystm.cls'
