/* consoles - view information about the configured console windows */
parse arg pfx params
select
  when pfx='-?' then call help
  when pfx='a' then call showall params
  when pfx='p' then call pickone params
  when pfx='c' then call showcolors params
  when pfx='cp' then call copycolors params
  when pfx='d' then call diffcolors params
  otherwise
    'call powershell "dir hkcu:/Console | Select-Object -Property Name"'
end
exit

help:
  say 'consoles - Look up colors for a given console'
  say "usage: consoles [options]"
  say 'options'
  say '  -? = help'
  say '  a name = show all properties of a given console'
  say '  c name = show color properties of a given console'
  say '  d src target = diff colors from src and target profiles'
  say '  cp src target = copy colors from src profile to target'
  say '  p = pick a console profile'
  say 'default = show names of all console profiles'
  exit

showall: procedure
  parse arg name
  'call powershell Get-Item "HKCU:\Console\'name'"'
  return

pickone: procedure
  parse arg options
  profiles=.array~new
  ADDRESS CMD 'call powershell "dir hkcu:/Console | Select-Object -Property Name"|RXQUEUE'
  do while queued()>0
    parse pull entry
    lastdelim=lastpos('\', entry)
    if entry='' | lastdelim=0 then iterate
    profiles~append(substr(entry, lastdelim+1))
  end
  choice=pickAItem(profiles)
  say 'Selected profile:' choice
  return

showcolors: procedure
  parse arg name
  say 'call powershell Get-Item "HKCU:\Console\'name'" |grep -i colortable |sort|colorfilter'
  'call powershell Get-Item "HKCU:\Console\'name'" |grep -i colortable |sort|colorfilter'
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

::requires 'UtilRoutines.rex'
