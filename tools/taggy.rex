/* taggy - Helps you build tag structures */
parse arg tags
if abbrev('-?', tags) then call help

do w=1 to words(tags)
  idx=(w-1)*2
  sp=copies(' ', idx)
  parse value word(tags,w) with tag '.' class
  push tag
  say sp'<'tag 'class="'class'">'
end w
do while queued()>0
  parse pull name
  sp=copies(' ', idx)
  say sp'</'name'>'
  idx=idx-2
end
exit

help: procedure
  say 'usage: taggy tag.class'
  exit
