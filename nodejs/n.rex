/* n -- Alias utility for npm */
parse arg pfx cmds
select
  when pfx='v' then call versions
  when pfx='cfg' then 'npm config list' cmds
  when pfx='def' then 'npm config ls -l'
  when pfx='i' then say 'npm install' cmds
  when pfx='is' then say 'npm install' cmds '--save'
  when pfx='isd' then call ncmd 'echo npm install' cmds '--save-dev'
  when pfx='l' then 'npm ls --depth=0' cmds
  when pfx='s' then say 'npm search' cmds
  when pfx='u' then say 'npm uninstall' cmds
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

ncmd: procedure
  parse arg xcmd
  say xcmd
  ADDRESS CMD xcmd
  return

help: procedure
  say 'n - Alias utility for NPM'
  say 'usage: n shortcut parameters'
  say 'shortcuts:'
  parse source . . srcfile .
  ADDRESS CMD 'grep -i "when pfx"' srcfile '|RXQUEUE'
  do while queued()>0
    parse pull . '=' entry . action
    if entry='' then iterate
    say ' ' left(entry, 12, '.') action
  end
  return
