/* ConsoleLib provides methods to query and change console attributes */
::requires 'winsystm.cls'
::requires 'UtilRoutines.rex'

::class ConsoleLib public

::method init
  expose sysreg colorDefaults.
  use arg a, b
  parse value syswinver() with winsys winver -- Get system and version
  FileControl='\control'
  FileNewKey='\testuser'
  if winsys='WindowsNT' then do
    FileControl = FileControl'.reg'
    FileNewKey = FileNewKey'.reg'
  end
  sysreg=.WindowsRegistry~new   -- create a new registry object
  colorDefaults.THISTLE=14204888
  colorDefaults.MISTYROSE=14804223
  colorDefaults.BLACK=16777215

::method getConsoles
  expose sysreg
  consolenames=.array~new
  if sysreg~open(sysreg~Current_User, 'Console')=0 then return consolenames
  if sysreg~List(,keys.)=0 then do idx over keys.
    if pos('SystemRoot', keys.idx)>0 then iterate
    consolenames~append(keys.idx)
  end idx
  sysreg~Close  -- close the key
  return consolenames

-- Get a collection of colors defined by a given console
::method getConsoleColors
  expose sysreg
  parse arg consolename, useRGB
  inRGB=abbrev('RGB', useRGB)
  -- colors=.array~new
  colors=.directory~new
  if sysreg~open(sysreg~Current_User, 'Console\'consolename)=0 then return
  q.=sysreg~query
  if sysreg~ListValues(,vals.)=0 then do idx=1 to q.values
    if pos('COLORTABLE', translate(vals.idx.name))=0 then iterate
    index=substr(vals.idx.name,11)
    if inRGB then
      -- colors~put(self~d2rgb(vals.idx.data), index*1+1)
      colors~put(self~d2rgb(vals.idx.data), index)
    else
      -- colors~put(vals.idx.data, index*1+1)
      colors~put(vals.idx.data, index)
  end idx
  sysreg~Close
  return colors

::method getDefaultConsoleColors
  expose sysreg
  arg useRGB
  inRGB=abbrev('RGB', useRGB)
  colors=.directory~new
  if sysreg~open(sysreg~Current_User, 'Console')<>0 then do
    q.=sysreg~query
    if sysreg~ListValues(,vals.)=0 then do idx=1 to q.values
      if pos('COLORTABLE', translate(vals.idx.name))=0 then iterate
      index=substr(vals.idx.name,11)
      if inRGB then
        colors~put(self~d2rgb(vals.idx.data), index)
      else
        colors~put(vals.idx.data, index)
    end idx
    sysreg~Close
  end -- open selected console
  return colors

-- Get a collection of colors defined by a given console including those of the parent, or default console
::method getConsolePalette
  expose sysreg
  parse arg consolename, useRGB
  inRGB=abbrev('RGB', useRGB)
  parentColors=self~getDefaultConsoleColors(useRGB)
  colors=self~getConsoleColors(consolename, useRGB)
  if colors~items=0 then do
    say 'Console' consolename 'defines NO new colors'
    return parentColors
  end
  paletteKeys=parentColors~allIndexes~sort
  loop key over paletteKeys
    childColor=colors~at(key)
    if childColor<>.nil then do
      -- say 'Using child color' childColor 'for index' key
      parentColors~put(childColor, key)
    end
  end
  return parentColors

::method getColor
  expose sysreg
  parse arg consolename, colorIndex, useRGB
  if consolename='' then return ''
  inRGB=abbrev('RGB', useRGB)
  key='Console\'consolename
  field=self~colorKey(colorIndex)
  if sysreg~open(sysreg~Current_User,key)=0 then return ''
  st. = sysreg~getvalue(,field)
  if inRGB then return self~d2rgb(st.data)
  return st.data

::method colorKey
  arg index
  if \datatype(index,'W') then index=2
  else if index<1 then index=2
  else if index>16 then index=15
  return 'ColorTable'right(index,2,'0')

::method colorDefault
  expose colorDefaults.
  arg inValue
  if \datatype(inValue,'W') then colorValue=colorDefaults.THISTLE
  else if inValue<0 | inValue>colorDefaults.BLACK then colorValue=colorDefaults.MISTYROSE
  else colorValue=inValue
  return colorValue

::method setColor
  expose sysreg
  parse arg consolename, colorIndex, colorValue
  if consolename='' then return 0
  key='Console\'consolename
  field=self~colorKey(colorIndex)
  if sysreg~open(sysreg~Current_User,key)=0 then return 0
  st. = sysreg~getvalue(,field)
  if colorValue<>'' then do
    newcolor=self~colorDefault(colorValue)
    sysreg~setvalue(,field,newcolor,'NUMBER')
    say key field st.data '=>' newcolor
  end
  sysreg~close
  return 1

::method setColorRGB
  expose sysreg
  parse arg consolename, colorIndex, colorValue
  if consolename='' then return 0
  key='Console\'consolename
  field=self~colorKey(colorIndex)
  if sysreg~open(sysreg~Current_User,key)=0 then return 0
  st. = sysreg~getvalue(,field)
  if colorValue<>'' then do
    parse var colorValue R ',' G ',' B
    newcolor=self~rgb2hex(R, G, B)
    sysreg~setvalue(,field,newcolor,'NUMBER')
    say key field st.data '=>' newcolor
  end
  sysreg~close
  return 1

::method listConsoleColors
  expose sysreg
  parse arg consolename
  if consolename='' then key='Console'
  else                   key='Console\'consolename
  if sysreg~open(sysreg~Current_User, key)=0 then do
    say 'Unable to query attributes of' consolename
    return
  end
  q.=sysreg~query
  if sysreg~ListValues(,vals.)=0 then do idx=1 to q.values
    if pos('COLORTABLE', translate(vals.idx.name))=0 then iterate
    say self~d2rgb(vals.idx.data) substr(vals.idx.name,11) vals.idx.data vals.idx.name
  end idx
  sysreg~Close
  return

::method listConsoleAttributes
  expose sysreg
  parse arg consolename
  if consolename='' then key='Console'
  else                   key='Console\'consolename
  if sysreg~open(sysreg~Current_User, key)=0 then do
    say 'Unable to query attributes of' consolename
    return
  end
  q.=sysreg~query
  if sysreg~ListValues(,vals.)=0 then do idx=1 to q.values
    say ' ' vals.idx.name '=' vals.idx.data -- '('vals.i.type')'
  end idx
  sysreg~Close
  return

-- Convert a color integer into RGB component values
::method d2rgb
  arg decval
  if \datatype(decval,'W') then return ''
  bluedivisor=2**16
  greendivisor=2**8
  greenq=0
  redq=0
  blueq=decval%bluedivisor    -- int division
  blueqi=decval//bluedivisor  -- remainder
  if blueqi>0 then do
    greenq=blueqi%greendivisor
    redq=blueqi//greendivisor
  end
  -- left('R='redq,6) left('G='greenq,6) left('B='blueq,6)
  return redq greenq blueq

::method rgb2hex
  arg red, green, blue
  bluefactor=2**16
  greenfactor=2**8
  if \datatype(red,'W') | red<0 | red>255 then red=0
  if \datatype(green,'W') | green<0 | green>255 then green=0
  if \datatype(blue,'W') | blue<0 | blue>255 then blue=0
  return red+(green*greenfactor)+(blue*bluefactor)

::method string
  return 'A ConsoleLib'
