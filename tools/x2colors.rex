/* x2colors - Query the color definitions of an X2 profile */
parse arg pfx colorfile
cz=.ColorZone~new(colorfile)
select
  when pfx='?' then call help
  when pfx='c' then do
    colors.=cz~getPalette
    do i=1 to colors.0
      say i colors.i
    end i
  end
  when pfx='u' then cz~findZonesByColor()
  when pfx='z' then do
    czones=cz~getZones
    do index over czones
      say left(index, 15) czones~at(index)
    end
  end
  otherwise call showColors cz~getColorfile
end
exit

showColors: procedure
  parse arg colorfile
  inp=.stream~new(colorfile)
  do while inp~lines>0
    line=inp~linein
    if pos('=', line)=0 then iterate
    parse var line . zone '=' fg 'on' bg
    say zone '=' fg'/'bg
  end
  inp~close
  return

help: procedure
  say 'x2colors - Query the color definitions of an X2 profile'
  say 'usage: x2colors options'
  say '  default = show colors'
  say '  c = show colors in palette'
  say '  u = show unused colors in profile'
  say '  z = show colors per editor zone'
  return

::class ColorZone public
::method init
  expose colorfile zones palette.
  parse arg colorfile
  palette.1='Black'
  palette.2='Blue'
  palette.3='Green'
  palette.4='Cyan'
  palette.5='Red'
  palette.6='Magenta'
  palette.7='Brown'
  palette.8='Light Grey'
  palette.9='Dark Grey'
  palette.10='Light Blue'
  palette.11='Light Green'
  palette.12='Light Cyan'
  palette.13='Light Red'
  palette.14='Light Magenta'
  palette.15='Yellow'
  palette.16='White'
  palette.0=16
  zones=.directory~new
  if \SysFileExists(colorfile) then do
    say 'No such color file:' colorfile 'Trying default ...'
    colorfile=value('X2HOME',,'ENVIRONMENT')||'\colors.prof'
    if \SysFileExists(colorfile) then return
  end
  inp=.stream~new(colorfile)
  do while inp~lines>0
    line=inp~linein
    if pos('=', line)=0 then iterate
    parse var line . zone '=' fg 'on' bg
    zones~put(fg'/'bg, strip(zone))
  end
  inp~close

::method getColorfile
  expose colorfile
  return colorfile

::method getPalette
  expose palette.
  return palette.

::method getZones
  expose zones
  return zones

::method findZonesByColor
  expose zones palette.
  arg useDetail
  do i=1 to palette.0
    palette.i.ACTIVE=0
    palette.i.zones=.array~new
    do index over zones
      if wordpos(palette.i, zones~at(index))>0 then do
        palette.i.ACTIVE=1
        palette.i.zones~append(index)
        -- say index 'uses' palette.i
      end
    end
    if palette.i.ACTIVE then do
      say palette.i 'is USED in' palette.i.zones~items 'zones'
      if useDetail=1 then loop item over palette.i.zones
        say ' ' item
      end
    end
    else say palette.i 'is UNUSED'
  end i
  return
