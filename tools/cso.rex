/* cso - view information about the configured console windows */
parse arg pfx params
select
  when pfx='-?' then call help
  when pfx='s' then call queryConsoleNames 1
  when pfx='q' then call queryConsoleNames
  when pfx='c' then call showConsoleColors
  when pfx='cp' then call copycolors params
  when pfx='d' then call diffcolors2 params
  otherwise call showConsoleNames
end
exit

help:
  say 'cso - Manage consoles'
  say "usage: consoles [options]"
  say 'options'
  say '  -? = help'
  say '  s = start a console'
  say '  q = query a console'
  say '  c = query console colors'
  say 'default = show names of all console profiles'
  /*
  say '  a name = show all properties of a given console'
  say '  d src target = diff colors from src and target profiles'
  say '  cp src target = copy colors from src profile to target'
  */
  exit

showConsoleNames: procedure
  r = .WindowsRegistry~new
  if r~open(r~Current_User, 'Console')=0 then return
  if r~List(,keys.)=0 then do
    say 'Available Consoles:'
    do i over keys.
      say ' ' keys.i
    end i
  end
  return

queryConsoleNames: procedure
  arg doLoad
  r = .WindowsRegistry~new
  if r~open(r~Current_User, 'Console')=0 then return
  if r~List(,keys.)=0 then do
    choices=.array~new
    do i over keys.
      choices~append(keys.i)
    end i
    choice=pickAItem(choices)
    if doLoad=1 then do
      'start "'choice'" cmd'
    end
    else do
      if r~open(r~Current_User, 'Console\'choice)<>0 then do
        say 'Attributes of Console\'choice':'
        q.=r~query
        if r~ListValues(,vals.)=0 then do i=1 to q.values
          say ' ' vals.i.name '=' vals.i.data -- '('vals.i.type')'
        end
      end -- open selected console
    end -- show specific console attributes
  end -- query consoles
  return

showConsoleColors: procedure
  r = .WindowsRegistry~new
  if r~open(r~Current_User, 'Console')=0 then return
  if r~List(,keys.)=0 then do
    choices=.array~new
    do i over keys.
      choices~append(keys.i)
    end i
    choice=pickAItem(choices)
  end
  if r~open(r~Current_User, 'Console\'choice)<>0 then do
    say 'Colors of Console\'choice':'
    q.=r~query
    if r~ListValues(,vals.)=0 then do i=1 to q.values
      if pos('COLORTABLE', translate(vals.i.name))=0 then iterate
      say ' ' substr(vals.i.name,11) d2rgb(vals.i.data) vals.i.data
    end
  end
  return

-- Convert a color integer into RGB component values
d2rgb: procedure
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

showall: procedure
  parse arg name
  call prompt 'powershell Get-Item "HKCU:\Console\'name'"'
  return

copycolors: procedure
  parse arg prof1 prof2
  say 'Copying colors from profile' prof1 'to' prof2
  say 'call powershell Get-Item "HKCU:\Console\'prof1'" |grep -i colortable |sort|colorfilter' prof2
  return

diffcolors: procedure
  parse arg prof1 prof2
  say 'Comparing colors from profile' prof1 'to' prof2
  say 'call powershell Get-Item "HKCU:\Console\'prof1'" |grep -i colortable |sort|colorfilter' prof2 '-d'
  return

diffcolors2: procedure
  parse arg prof1 prof2
  say 'Comparing colors from profile' prof1 'to' prof2
  say 'call powershell Get-Item "HKCU:\Console\'prof1'" |colorfilter' prof2 '-d'
  r = .WindowsRegistry~new
  if r~open(r~Current_User, 'Console')=0 then return
  if r~List(,keys.)=0 then do
    consoles=.array~new
    do i over keys.
      consoles~append(keys.i)
    end i
    choices=pickAIndexes(consoles)
    say '>' choices
    do w=1 to words(choices)
      key=word(choices,w)
      say '>>' consoles[key]
    end w
  end
  /*
  if r~open(r~Current_User, 'Console\'choice)<>0 then do
    say 'Colors of Console\'choice':'
    q.=r~query
    if r~ListValues(,vals.)=0 then do i=1 to q.values
      if pos('COLORTABLE', translate(vals.i.name))=0 then iterate
      say compareColor vals.i.name, vals.i.data
    end
  end
  */
  return

compareColor: procedure
  parse arg name, value
  -- if cval=tval then return ctable 'same'
  -- else              return ctable 'Src='left(strip(cval),18) 'Target='tval
  return 'ok'

::requires 'winsystm.cls'
::requires 'UtilRoutines.rex'
