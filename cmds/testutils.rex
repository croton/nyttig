/* testutil -- test UtilRoutines library. */
parse arg pfx params

-- Initialize a stem to use with various tests
bugs.1='backswimmer'
bugs.2='giant water bug'
bugs.3='water strider'
bugs.4='water boatman'
bugs.5='leaf hopper'
bugs.6='cicada'
bugs.0=6

select
  when pfx='run' then call testrun params
  when pfx='gso' then call testgso params
  when pfx='ac' then call testac params
  when pfx='aca' then call testaca params
  when pfx='pi' then call testpi params
  when pfx='pia' then call testpia params
  when pfx='pf' then call testpf params
  when pfx='ev' then call testev params
  otherwise call help
end
exit

testrun: procedure
  parse arg fspec
  scmd='dir' fspec '/b'
  say; say 'Try 1, press ENTER'; pull .
  call runcmd scmd
  say; say 'Try 2, press ENTER'; pull .
  call runcmd scmd, ''
  say; say 'Try 3, press ENTER'; pull .
  call runcmd scmd, 1
  say; say 'Try 4, press ENTER'; pull .
  call runcmd scmd, 0
  say; say 'Try 5, press ENTER'; pull .
  call runcmd scmd, YES
  return

testgso: procedure
  parse arg srcfile searchStr
  call showSourceOptions srcfile, 'when pfx', searchStr
  return

testpf: procedure
  parse arg fspec
  myfile=pickFile(fspec)
  say 'pickFile' fspec '-> "'myfile'"'
  return

testpia: procedure
  parse arg wordlist
  mylist=.Array~new
  do w=1 to words(wordlist)
    mylist~append(word(wordlist,w))
  end w
  say 'We have list of' mylist~items 'options'
  choice=pickAItem(mylist)
  say 'pickAtem(mylist) -> "'choice'"'
  return

testpi: procedure expose bugs.
  parse arg doTransform
  if doTransform=0 then doTransform=''
  -- choice=pickItem(bugs.)
  -- say 'pickItem(bugs.) -> "'choice'"'
  choiceWithTransform=pickItem(bugs., doTransform)
  say 'pickItem(bugs, "'doTransform'") -> "'choiceWithTransform'"'
  return

testac: procedure expose bugs.
  parse arg input
  mycode=applyCmd2Choice('Echo you picked', bugs.)
  say '*** Return code:' mycode 'Now choose one or MORE'; say ''
  call applyCmd2Each 'echo You picked this bug:', bugs.
  return

testaca: procedure
  fish=.array~of('golden trout','arctic char','black nosed dace','johnny darter')
  -- bugs=.array~of('backswimmer','giant water bug','water strider','water boatman','leaf hopper','cicada')
  say 'Pick one from these fish:'
  call applyCmd2AChoice 'echo You picked this fish:', fish
  say 'Pick one OR MORE fish (WITH prompting):'
  call applyCmd2AEach 'echo You picked this fish:', fish, 1
  return

-- Possible usage: search a file for a spec; select one; copy to clipboard
testev: procedure expose bugs.
  parse arg xcmd
  ok=evalCmdWithChoice(xcmd, bugs.)
  say 'RC evalCmdWithChoice("'xcmd'") ->' ok
  return

evalCmdWithChoice: procedure
  use arg xcmd, items.
  ph='?'
  if pos(ph, xcmd)=0 then return applyCmd2Choice(xcmd, items.)
  item=pickItem(items.)
  rcode=-1
  if item<>'' then do
    ecmd=changestr(ph, xcmd, item)
    ADDRESS CMD 'echo' ecmd
    rcode=rc
  end
  return rcode

help: procedure
  say 'testutil -- A utility tool, version' 0.1
  say 'commands:'
  parse source . . srcfile .
  call showSourceOptions srcfile, 'when pfx'
  return

::requires 'UtilRoutines.rex'
