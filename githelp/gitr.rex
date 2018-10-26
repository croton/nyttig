/* gcmd -- Interactive shell for git shortcuts. */
call trace 'off'
SIGNAL ON NOTREADY NAME programEnd
CURRBRANCH=getBranch()
VISITEDBRANCH=.Set~of(CURRBRANCH)
LASTCMD=''
call help

ctr=0
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
    when gcmd='b' then call switchBranch params
    when gcmd='br' then call showVisitedBranches
    when gcmd='m' then call switchBranch 'master'
    when gcmd='rx' then interpret 'say' params
    otherwise
      call runcmd gcmd params
      call updateBranch  -- Update branch in case it was modified
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
    say "Today's visited branches:"
    call showVisitedBranches
  end
  return

runLastCmd: procedure expose CURRBRANCH
  parse arg options
  if LASTCMD='' then say 'No previous command available'
  else do
    if askYN('Run' LASTCMD'?') then ADDRESS CMD LASTCMD
    call updateBranch
  end
  return

switchBranch: procedure expose CURRBRANCH VISITEDBRANCH
  parse arg branchname
  if branchname='' then
    rcode=pickBranch()
  else
    rcode=changeBranch(branchname)
  if rcode=0 then call updateBranch
  else say 'Problem changing branch:' rcode
  return

showVisitedBranches: procedure expose VISITEDBRANCH
  say "Today's visited branches:"
  ctr=0
  loop item over VISITEDBRANCH
    ctr=ctr+1
    say ctr item
  end
  return

help: procedure
  say 'gitr -- An interactive git shell, version' 0.11
  say 'Type EXIT to leave.'
  say 'commands:'
  parse source . . srcfile .
  call showSourceOptions srcfile, 'when gcmd'
  return

programEnd:
  say 'The program has ended. Thank you.'
  exit 0

::requires 'UtilRoutines.rex'
::requires 'gitlib.rex'
