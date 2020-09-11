/* csopalette -- A filter to generate a color scheme for a given console */
parse arg configfile consolename options
if configfile='?' | consolename='' then do
  say 'usage: csopalette configfile consolename'
  exit
end

inp=.stream~new(configfile)
collection=inp~arrayin
inp~close
call updateColors collection, consolename
exit

updateColors: procedure
  use arg colorsettings, consolename
  if consolename='' then return
  cl=.ConsoleLib~new
  loop item over colorsettings
    parse var item red green blue index .
    cl~setColorRGB(consolename, index, space(red green blue,1,','))
  end
  cl~listConsoleColors(consolename)
  return

::requires 'ConsoleLib.cls'
