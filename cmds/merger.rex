/* merger -- merge a template with dynamic values */
parse arg fin values -- template and values
if values='' then do
  say 'Usage: merger template values'
  exit 1
end

-- Open and check the files
do while lines(fin)<>0
  line=linein(fin)
  if line='' then iterate
  say merge(line, values)
end
call lineout fin -- close the file
exit

/* -----------------------------------------------------------------------------
   Tokens may be parsed by space or by delimiter, which, if present must
   be specified as first character of value list and be either '#' or '~'.
   Example:
     a b c   -- parsed by space, 1=a, 2=b, 3=c
     ~a~b c  -- parsed by delim, 1=a, 2=b c
   -----------------------------------------------------------------------------
*/
merge: procedure
  parse arg template, tokens, ph
  if ph='' then ph='?'
  if pos(ph, template)=0 then return template
  line=template
  delim=left(tokens, 1)
  if delim='#' | delim='~' then do
    w=0
    tokens=substr(tokens, 2)
    do until tokens=''
      parse var tokens val (delim) tokens
      if val='' then iterate
      w=w+1
      line=changestr(ph||w, line, val)
    end
  end
  else do w=1 to words(tokens)
    line=changestr(ph||w, line, word(tokens, w))
  end w
  if pos('?d', line)>0 then line=changestr('?d', line, datestamp())
  return line

datestamp: procedure
  return translate('CcYy-Mm-Dd', date('s'), 'CcYyMmDd')