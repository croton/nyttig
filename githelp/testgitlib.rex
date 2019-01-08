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
    when gcmd='dh' then call testDiffHistory params
    when gcmd='choice' then call testChoice params
    when gcmd='cmdout' then call testCmdOut params
    when gcmd='rx' then interpret 'say' params
    otherwise call runcmd gcmd params
  end
end
exit

testChoice: procedure expose VISITEDBRANCH
  parse arg stuff
  if VISITEDBRANCH~items>0 then do
    say 'Pick one from these visited branches:'
    call applyCmd2AChoice 'echo You picked this branch (among those already visited):', VISITEDBRANCH~makeArray
  end
  else do
    say 'No branches visited? Ok use another, sample, list:'
    ornaments=.Array~of('foto', 'grinch', 'house with Magi', 'green metallic ball', 'Cody mini tree', 'red metallic pear')
    call applyCmd2AChoice 'echo Your selected Xmas ornament is:', ornaments
  end
  return

testHead: procedure
  parse arg params
  say 'Input' params 'expands to' hd(params)
  say 'Input' params '(using "-" as prefix) expands to' hd(params, '-')
  return

testDiffHistory: procedure
  parse arg fspec
  fn=pickFile(fspec)
  if fn='' then say 'No file specified'
  else do
    output=cmdOut('git log --pretty=format:"%h %s" -n 5 --follow' fn)
    resultCount=output~items
    if resultCount>0 then do
      ans=pickAIndexes(output)
      if ans='' then return
      parse var ans idx1 idx2
      say 'Compare these commits:' word(output[idx1], 1) word(output[idx2],1)
    end
    else say 'No results'
  end
  return

testCmdOut: procedure
  parse arg gcmd
  output=cmdOut(gcmd)
  say 'Results:' output~items
  do i=1 to output~items
    say i '=' output[i]
  end i
/*
  loop item over output
    say '->' item
  end
*/
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
  say sourceline(SIGL)
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
