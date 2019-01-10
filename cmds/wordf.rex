/* word -- Read from the input (STDIN). */
call trace 'off'
arg wordnum
multiwords=0
if pos('-',wordnum)>0 then do
  multiwords=1
  parse var wordnum digit '-' .
  if datatype(digit,'W') then wordnum=digit
  else                        wordnum=1
end
else if \datatype(wordnum,'W') then wordnum=1

signal on notready name programEnd
do forever
  parse pull input
  say parseline(input, wordnum, multiwords)
end
exit

parseline: procedure
parse arg input, idx, showmany
if showmany then return subword(input, idx)
return word(input, idx)

programEnd:
exit 0
