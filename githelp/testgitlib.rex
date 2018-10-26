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
    when gcmd='hd' then call testHead params
    when gcmd='choice' then call testChoice params
    when gcmd='rx' then interpret 'say' params
    otherwise call runcmd gcmd params
  end
end
exit

testChoice: procedure expose VISITEDBRANCH
  parse arg stuff
  fish=.array~of('golden trout','arctic char','black nosed dace','johnny darter')
  bugs=.array~of('backswimmer','giant water bug','water strider','water boatman','leaf hopper','cicada')
  say 'Pick one from these fish:'
  call applyCmd2Choice 'echo You picked this fish:', fish
  say 'Pick from these bugs:'
  call applyCmd2Choices 'echo You picked this bug', bugs
  say 'Pick from these bugs (WITH prompting):'
  call applyCmd2Choices 'echo You picked these bugs?', bugs, 1
  if VISITEDBRANCH~items>0 then do
    say 'Pick one from these visited branches:'
    call applyCmd2Choice 'echo You picked this branch (among those already visited):', VISITEDBRANCH~makeArray
  end
  return

testHead: procedure
  parse arg params
  say 'Input' params 'expands to' hd(params)
  say 'Input' params '(using "-" as prefix) expands to' hd(params, '-')
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
    say ctr item
  end
  return

syntax:
  say 'There has been a syntax anomaly originated from line' SIGL'.'
  say 'Please look into it at once.'
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
