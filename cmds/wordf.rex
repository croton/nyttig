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
else if wordnum='$' then wordnum=0 -- pick the LAST word
else if \datatype(wordnum,'W') then wordnum=1

signal on notready name programEnd
do forever
  parse pull input
  if input='' then iterate
  say parseline(input, wordnum, multiwords)
end
exit

parseline: procedure
parse arg input, idx, showmany
if showmany then return subword(input, idx)
else if idx=0 then return word(input, words(input))
return word(input, idx)

programEnd:
exit 0
