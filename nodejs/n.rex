/* n -- Alias utility for npm */
parse arg pfx cmds
select
  when pfx='v' then call versions
  when pfx='cfg' then 'npm config list' cmds
  when pfx='def' then 'npm config ls -l'
  when pfx='i' then call prompt 'npm install' cmds
  when pfx='is' then call prompt 'npm install' cmds '--save'
  when pfx='isd' then call prompt 'npm install' cmds '--save-dev'
  when pfx='l' then 'npm ls --depth=0' cmds
  when pfx='s' then 'npm search' cmds
  when pfx='u' then call prompt 'npm uninstall' cmds
  when pfx='up' then call nodeUpdate
  otherwise call help
end
exit

versions: procedure
  call doCmd 'Node: ', 'node -v'
  call doCmd 'NPM: ', 'npm -v'
  return

doCmd: procedure
  parse arg message, xcmd
  call charout , message
  ADDRESS CMD xcmd
  return

nodeUpdate: procedure
  'pws' "Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force"
  call prompt 'npm install --global --production npm-windows-upgrade@4.1.1'
  call prompt 'npm-windows-upgrade'
  return

help: procedure
  say 'n - Alias utility for NPM'
  say 'usage: n shortcut parameters'
  say 'shortcuts:'
  parse arg filter
  parse source . . srcfile .
  call showSourceOptions srcfile, 'when pfx', filter
  return

::requires 'UtilRoutines.rex'
