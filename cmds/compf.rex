/* compf -- A filter that reformats output from COMP command. */
arg options
okOnly=0
diffOnly=0
findOnly=0
select
  when options='' then nop
  when options='-?' then call help
  when wordpos('OK', options)>0 then okOnly=1
  when abbrev(options, 'D') then diffOnly=1
  when abbrev(options, 'F') then findOnly=1
  otherwise nop
end
-- say 'Options ok' okOnly 'diff' diffOnly

signal on notready name programEnd
stack=''
if okOnly then do forever
  parse pull input
  if input='' then iterate
  if abbrev(input, 'Comparing') then stack=input
  else do
    if wordpos('OK', input)>0 then say stack input
    stack=''
  end
end
else if diffOnly then do forever
  parse pull input
  if input='' then iterate
  if abbrev(input, 'Comparing') then stack=input
  else do
    if wordpos('different', input)>0 then say stack input
    if wordpos('error', input)>0 then say stack input
    stack=''
  end
end
else if findOnly then do forever
  parse pull input
  if pos('find', input)>0 then say input
end
else do forever
  parse pull input
  if input='' then iterate
  if abbrev(input, 'Comparing') then stack=input
  else do
    say stack input
    stack=''
  end
end
exit

help: procedure
  say 'Filter output of COMP command'
  say 'usage: compf [ok][diff]'
  exit

programEnd:
exit 0
