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
  when pfx='gso' then call testgso params
  when pfx='ac' then call testac params
  when pfx='aca' then call testaca params
  when pfx='pi' then call testpi params
  when pfx='pia' then call testpia params
  when pfx='pf' then call testpf params
  otherwise call help
end
exit

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

help: procedure
  say 'testutil -- A utility tool, version' 0.1
  say 'commands:'
  parse source . . srcfile .
  call showSourceOptions srcfile, 'when pfx'
  return

::requires 'UtilRoutines.rex'
