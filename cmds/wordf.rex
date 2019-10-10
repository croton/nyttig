/* wordf -- Read selected word(s) from the input (STDIN). */
call trace 'off'
arg wordnum
if .STDIN~chars then call pipe wordnum
else do
  say 'wordf - Read selected word(s) from input'
  say 'usage: wordf wordnum'
  say '  wordnum may be one of ...'
  say '    a digit'
  say '    a digit range, ex. 2-4'
  say '    a $, meaning select last word'
end
exit

pipe: procedure
  arg wordnum
  wordend=0
  if pos('-',wordnum)>0 then do
    parse var wordnum digit '-' digitend .
    if datatype(digit,'W') then wordnum=digit
    else                        wordnum=1
    if datatype(digitend,'W') then wordend=digitend
    else                           wordend=1000 -- symbol for all remaining words
  end
  else if wordnum='$' then wordnum=0 -- pick the LAST word
  else if \datatype(wordnum,'W') then wordnum=1

  signal on notready name programEnd
  do forever
    parse pull input
    if input='' then iterate
    say parseline(input, wordnum, wordend)
  end
  return

parseline: procedure
parse arg input, idx, wordend
if wordend>idx then do
  if wordend=1000 then return subword(input, idx)
  else return subword(input, idx, (wordend-idx)+1)
end
else if idx=0 then return word(input, words(input))
return word(input, idx)

programEnd:
exit 0
