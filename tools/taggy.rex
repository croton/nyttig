/* taggy - Helps you build tag structures */
parse arg tags
if abbrev('-?', tags) then call help

w=wordpos('-n',tags)
if w>0 then do; nested=1; tags=delword(tags,w,1); end; else nested=0

if nested then do
  do w=1 to words(tags)
    idx=(w-1)*2
    sp=copies(' ', idx)
    parse value word(tags,w) with tag '.' class
    if tag='' then tag='div'
    push tag
    say sp'<'tag 'class="'class'">'
  end w
  do while queued()>0
    parse pull name
    sp=copies(' ', idx)
    say sp'</'name'>'
    idx=idx-2
  end
end
else do w=1 to words(tags)
  parse value word(tags,w) with tag '.' class
  if tag='' then tag='div'
  say '<'tag 'class="'class'">'
  say '</'tag'>'
end w
exit

help: procedure
  say 'usage: taggy tag.class'
  exit
