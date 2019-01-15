/* gcmd -- Interactive shell for git shortcuts. */
call trace 'off'
SIGNAL ON NOTREADY NAME programEnd
CURRBRANCH=getBranch()
VISITEDBRANCH=.Set~of(CURRBRANCH)
ALLCMDS=.Array~new
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
    when gcmd='help' then call help params
    when gcmd='.' then call runLastCmd
    when gcmd='..' then call runLastCmd 'PICK'
    when gcmd='b' then call switchBranch params
    when gcmd='br' then call showVisitedBranches
    when gcmd='cl' then call addCmd cloneProject(params)
    when gcmd='m' then call switchBranch 'master'
    when gcmd='lf' then call addCmd logfile(params)
    when gcmd='vf' then call addCmd viewfile(params)
    when gcmd='dh' then call addCmd compareCommits(params)
    when gcmd='dht' then call addCmd compareCommits(params 'difftool')
    when gcmd='dha' then call addCmd compareAdjacentCommits(params)
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
    call showVisitedBranches
  end
  return

/* Add a command to the command list. */
addCmd: procedure expose ALLCMDS
  parse arg gcmd
  if gcmd<>'' then ALLCMDS~append(gcmd)
  return

runLastCmd: procedure expose CURRBRANCH ALLCMDS
  parse arg pickFromList
  if pickFromList='' then lastcmd=ALLCMDS~lastItem
  else                    lastcmd=pickAItem(ALLCMDS)
  if hasvalue(lastcmd) then do
    call runcmd lastcmd
    if pos('branch', lastcmd)>0 then call updateBranch
    else say 'No branch update'
  end
  else say 'The command stack is empty or selection cancelled!'
  return

switchBranch: procedure expose CURRBRANCH VISITEDBRANCH
  parse arg branchname
  rcode=pickBranch(branchname)
  select
    when rcode=0 then call updateBranch
    when rcode<0 then say 'Selection cancelled'
    otherwise         say 'Problem changing branch:' rcode
  end
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
  say 'gitr -- An interactive git shell, version' 0.13
  say 'Type EXIT to leave.'
  parse arg filter
  parse source . . srcfile .
  if filter='' then say 'commands:'
  else              say 'commands containing "'filter'":'
  call showSourceOptions srcfile, 'when gcmd', filter
  return

programEnd:
  say 'The program has ended. Thank you.'
  exit 0

::requires 'UtilRoutines.rex'
::requires 'gitlib.rex'
