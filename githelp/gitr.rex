/* gcmd -- Interactive shell for git shortcuts. */
call trace 'off'
signal on notready name programEnd
ctr=0
CURRBRANCH=getBranch()
VISITEDBRANCH=.Set~new
do forever
  ctr=ctr+1
  call charout , showprompt()
  parse linein gcmd params
  select
    when translate(gcmd)='EXIT' then do
      say 'Leaving git shell ...'
      exit 0
    end
    when gcmd='help' then call help
    when gcmd='.' then call runLastCmd
    when gcmd='b' then call changeBranch params
    when gcmd='br' then call showVisitedBranches
    when gcmd='m' then call changeBranch 'master'
    when gcmd='rx' then interpret 'say' params
    otherwise call runcmd gcmd params
  end
end
exit

showprompt: procedure expose CURRBRANCH
  parse arg prefix
  return CURRBRANCH '>> '

updateBranch: procedure expose CURRBRANCH VISITEDBRANCH
  lastBranch=getBranch()
  if CURRBRANCH<>lastBranch then do
    CURRBRANCH=lastBranch
    VISITEDBRANCH~put(lastBranch)
  end
  return

/* Pass a command to the external environment */
runcmd: procedure expose CURRBRANCH VISITEDBRANCH
  parse arg gcmd params
  if gcmd='' then return
  -- say 'Running' gcmd params
  ADDRESS CMD gcmd params
  .environment['LASTCMD']=gcmd params
  -- Update branch in case it was modified
  call updateBranch
  return

runLastCmd: procedure expose CURRBRANCH
  parse arg options
  lastone=.environment['LASTCMD']
  if lastone=.NIL then say 'No previous command available'
  else do
    if askYN('Run' lastone'?') then ADDRESS CMD lastone
    -- Update branch in case it was modified
    call updateBranch
    -- CURRBRANCH=getBranch()
  end
  return

changeBranch: procedure expose CURRBRANCH VISITEDBRANCH
  parse arg branchname
  gcmd='git checkout' branchname
  ADDRESS CMD gcmd
  rcode=rc
  call updateBranch
  -- CURRBRANCH=getBranch()
  return rcode

getBranch: procedure
  currBranch=''
  ADDRESS CMD 'git branch |RXQUEUE'
  do while queued()>0
    parse pull entry
    if left(entry,1)='*' then currBranch=word(entry, 2)
  end
  return currBranch

showVisitedBranches: procedure expose VISITEDBRANCH
  ctr=0
  loop item over VISITEDBRANCH
    ctr=ctr+1
    say ctr item
  end
  return

help: procedure
  say 'gitr -- An interactive git shell, version' 0.1
  say 'Type EXIT to leave.'
  say 'commands:'
  parse source . . srcfile .
  call showSourceOptions srcfile, 'when gcmd'
  return

programEnd:
  say 'The program has ended. Thank you.'
  exit 0

::requires 'UtilRoutines.rex'
