/* testutil -- test UtilRoutines library. */
parse arg pfx params
select
  when pfx='gso' then call testgso params
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

help: procedure
  say 'testutil -- A utility tool, version' 0.1
  say 'commands:'
  parse source . . srcfile .
  call showSourceOptions srcfile, 'when pfx'
  return

::requires 'UtilRoutines.rex'
