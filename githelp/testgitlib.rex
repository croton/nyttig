/* testgitlib -- Test functions provided in gitlib.rex */
SIGNAL ON SYNTAX
VISITEDBRANCH=.Set~new
ctr=0
do forever
  ctr=ctr+1
  call charout , showprompt()
  parse linein gcmd params
  select
    when translate(gcmd)='EXIT' then do
      say 'Leaving test git lib ...'
      exit 0
    end
    when gcmd='help' then call help
    when gcmd='br' then call showVisitedBranches
    when gcmd='bn' then call addBranch params
    when gcmd='bb' then call branchSwitch cmds
    when gcmd='choice' then call testChoice cmds
    when gcmd='rx' then interpret 'say' params
    otherwise call runcmd gcmd params
  end
end
exit

testChoice: procedure
  parse arg stuff
  call applyCmd2Choice 'echo You picked this fish:', .array~of('golden trout','arctic char','black nosed dace','johnny darter')
  return

showprompt: procedure
  parse arg prefix
  return '...'strip(right(directory(), 25)) '>> '

addBranch: procedure expose VISITEDBRANCH
  parse arg newbranch
  if newbranch<>'' then VISITEDBRANCH~put(newbranch)
  return

showVisitedBranches: procedure expose VISITEDBRANCH
  ctr=0
  loop item over VISITEDBRANCH
    ctr=ctr+1
    say ctr 'branch' item
  end
  return

syntax:
  say 'There has been a syntax anomaly. Please look into it at once.'
  return

help: procedure
  say 'testgitlib -- Test functions in gitlib.rex, version' 0.1
  say 'Type EXIT to leave.'
  say 'commands:'
  parse source . . srcfile .
  call showSourceOptions srcfile, 'when gcmd'
  return

programEnd:
  say 'The program has ended. Thank you.'
  exit 0

::requires 'gitlib.rex'
::requires 'UtilRoutines.rex'
