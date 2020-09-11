/* cso - view information about the configured console windows */
parse arg pfx params
select
  when pfx='-?' then call help
  when pfx='s' then call launchConsole params
  when pfx='q' then call queryConsole params
  when pfx='c' then call queryConsoleColors params
  when pfx='p' then call showPalette params
  when pfx='r' then call colorReport params
  when pfx='copy' then call copyColors params
  when pfx='change' then call changeColorRGB params
  when pfx='x' then call changeColor params
  otherwise call showConsoleNames
end
exit

help:
  say 'cso - Manage consoles'
  say "usage: cso [options]"
  say 'options'
  say '  -? = help'
  say '  s = start a console'
  say '  q = query a console'
  say '  c = query console colors'
  say '  p = query console color palette'
  say '  r = generate HTML color summary for console'
  say '  copy source target = copy console colors'
  say '  change name index RGBvalues = change a console color'
  say 'default = show names of all console profiles'
  exit

showConsoleNames: procedure
  cl=.ConsoleLib~new
  cnames=cl~getConsoles
  loop item over cnames
    say item
  end
  return

launchConsole: procedure
  parse arg consolename
  if consolename='' then do
    cl=.ConsoleLib~new
    consolename=pickAItem(cl~getConsoles)
    if consolename='' then return
  end
  'start "'consolename'" cmd'
  return

queryConsole: procedure
  parse arg consolename
  cl=.ConsoleLib~new
  if consolename='' then do
    consolename=pickAItem(cl~getConsoles)
    if consolename='' then return
  end
  cl~listConsoleAttributes(consolename)
  return

queryConsoleColors: procedure
  parse arg consolename
  cl=.ConsoleLib~new
  if consolename='' then do
    consolename=pickAItem(cl~getConsoles)
    if consolename='' then return
  end
  cl~listConsoleColors(consolename)
  return

changeColor: procedure
  parse arg consolename colorIndex colorValue
  -- 1=black, 16=white, index 2 indicates color after black
  cl=.ConsoleLib~new
  if consolename='' then do
    consolename=pickAItem(cl~getConsoles)
    if consolename='' then return
  end
  if askYN('Change' consolename 'color field' colorIndex 'to' colorValue'?') then
    cl~setColor(consolename, colorIndex, colorValue)
  return

changeColorRGB: procedure
  parse arg consolename colorIndex colorValue
  -- 1=black, 16=white, index 2 indicates color after black
  cl=.ConsoleLib~new
  if consolename='' then do
    consolename=pickAItem(cl~getConsoles)
    if consolename='' then return
  end
  if askYN('Change' consolename 'color field' colorIndex 'to' colorValue'?') then
    cl~setColorRGB(consolename, colorIndex, colorValue)
  return

showPalette: procedure
  parse arg consolename colorFormat .
  cl=.ConsoleLib~new
  if consolename='' then do
    consolename=pickAItem(cl~getConsoles)
    if consolename='' then return
  end
  cz=cl~getConsolePalette(consolename, colorFormat)
  keys=cz~allIndexes~sort
  loop item over keys
    say cz~at(item) item
  end
  -- cl~listConsoleColors
  return

colorReport: procedure
  parse arg consolename .
  cl=.ConsoleLib~new
  if consolename='' then do
    consolename=pickAItem(cl~getConsoles)
    if consolename='' then return
  end
  cz=cl~getConsolePalette(consolename, 'RGB')
  tmpl='.box-?4 {background-color: rgb(?1,?2,?3);}'
  loop key over cz~allIndexes~sort
    say merge(tmpl, cz~at(key) key)
  end
  return

copyColors: procedure
  parse arg source target .
  if source='' | target='' then return
  say 'Copy' source 'to' target
  cl=.ConsoleLib~new
  cl~listConsoleColors(source)
  '@pause'
  cl~listConsoleColors(target)
  sourceColors=cl~getConsoleColors(source,0)
  iter=sourceColors~supplier
  ctr=0
  do while iter~available
    say source iter~index iter~item
    say '  to' target':' cl~getColor(target, iter~index,0)
    iter~next
    ctr=ctr+1
  end
  return

mergeTemplate: procedure
  use arg rgbColors, tmpl
  if tmpl=.nil then tmpl='r:?1 g:?2 b:?3'
  ctr=0
  loop item over rgbColors
    ctr=ctr+1
    say merge(tmpl, item ctr)
  end
  return rgbColors~items

::requires 'winsystm.cls'
::requires 'ConsoleLib.cls'
