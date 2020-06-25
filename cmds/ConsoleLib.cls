/* ConsoleLib provides methods to query and change console attributes */
::requires 'winsystm.cls'
::requires 'UtilRoutines.rex'

::class ConsoleLib public

::method init
  expose regeditor r
  use arg a, b
  parse value syswinver() with winsys winver -- Get system and version
  if winver<>4 then regeditor='REGEDT32'
  else              regeditor='REGEDIT'
  FileControl='\control'
  FileNewKey='\testuser'
  if winsys='WindowsNT' then do
    FileControl = FileControl'.reg'
    FileNewKey = FileNewKey'.reg'
  end
  r=.WindowsRegistry~new   -- create a new registry object

::method getConsoles
  expose r
  consolenames=.array~new
  if r~open(r~Current_User, 'Console')=0 then return consolenames
  if r~List(,keys.)=0 then do idx over keys.
    if pos('SystemRoot', keys.idx)>0 then iterate
    consolenames~append(keys.idx)
  end idx
  r~Close  -- close the key
  return consolenames

-- Get a collection of colors defined by a given console
::method getConsoleColors
  expose r
  parse arg consolename
  colors=.array~new
  if r~open(r~Current_User, 'Console\'consolename)<>0 then do
    q.=r~query
    if r~ListValues(,vals.)=0 then do idx=1 to q.values
      if pos('COLORTABLE', translate(vals.idx.name))=0 then iterate
      index=substr(vals.idx.name,11)
      colors~put(vals.idx.data, index*1+1)
    end idx
    r~Close
  end -- open selected console
  return colors

::method getDefaultConsoleColors
  expose r
  colors=.array~new
  if r~open(r~Current_User, 'Console')<>0 then do
    q.=r~query
    if r~ListValues(,vals.)=0 then do i=1 to q.values
      if pos('COLORTABLE', translate(vals.i.name))=0 then iterate
      index=substr(vals.i.name,11)
      colors~put(vals.i.data, index*1+1)
    end
    r~Close
  end -- open selected console
  return colors

-- Get a collection of colors defined by a given console including those of the parent, or default console
::method getConsolePalette
  expose r
  parse arg consolename
  parentColors=self~getDefaultConsoleColors
  colors=self~getConsoleColors(consolename)
  if colors~items=0 then do
    say 'Console' consolename 'defines NO new colors'
    return parentColors
  end
  palette=parentColors~makeArray
  iter=palette~supplier
  do while iter~available
    childColor=colors~at(iter~index)
    if childColor<>.nil then do
      -- say 'Using child color' childColor 'for index' iter~index
      palette~put(childColor, iter~index)
    end
    iter~next
  end
  return palette

::method listConsoleColors
  expose r
  parse arg consolename
  if r~open(r~Current_User, 'Console\'consolename)=0 then do
    say 'Unable to query attributes of' consolename
    return
  end
  say 'Colors for Console\'consolename':'
  q.=r~query
  if r~ListValues(,vals.)=0 then do idx=1 to q.values
    if pos('COLORTABLE', translate(vals.idx.name))=0 then iterate
    say ' ' substr(vals.idx.name,11) self~d2rgb(vals.idx.data) vals.idx.data vals.idx.name
  end idx
  r~Close
  return

::method listConsoleAttributes
  expose r
  parse arg consolename
  if r~open(r~Current_User, 'Console\'consolename)=0 then do
    say 'Unable to query attributes of' consolename
    return
  end
  say 'Attributes of Console\'consolename':'
  q.=r~query
  if r~ListValues(,vals.)=0 then do idx=1 to q.values
    say ' ' vals.idx.name '=' vals.idx.data -- '('vals.i.type')'
  end idx
  r~Close
  return

-- Convert a color integer into RGB component values
::method d2rgb
  arg decval
  if \datatype(decval,'W') then return ''
  bluedivisor=2**16
  greendivisor=2**8
  greenq=0
  greenqi=0
  blueq=decval%bluedivisor    -- int division
  blueqi=decval//bluedivisor  -- remainder
  if blueqi>0 then do
    greenq=blueqi%greendivisor
    greenqi=blueqi//greendivisor
  end
  return left('R='greenqi,6) left('G='greenq,6) left('B='blueq,6)

::method string
  return 'A ConsoleLib'
