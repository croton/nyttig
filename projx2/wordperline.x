/* wordperline.x - break each sentence of the document into multiple lines
   where each line has just one word
*/
more2go=breakline()
do while more2go
  more2go=breakline()
end
'MSG Current file broken into one word per line!'
exit

/* Break current line at end of each word. */
breakline: procedure
  'EXTRACT /CURLINE/'
  do while words(CURLINE.1)>1
    'NEXT_WORD'
    'SPLIT'
    'DOWN'
    'CURSOR COL1'
    'EXTRACT /CURLINE/'
  end
  'DOWN'
  -- return true if more lines left in file
  return rc=0

