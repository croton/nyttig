/* newtablef -- A filter for generating HTML tables */
parse arg options

if .STDIN~chars then do
  collection=.array~new
  call pipe options
end
else do
  if options='' then call help
  else call parseoption options
end

exit

pipe: procedure expose collection
  parse arg options
  SIGNAL ON NOTREADY NAME programEnd
  SIGNAL ON ERROR    NAME programEnd
  do forever
    parse pull data
    if data='' then iterate
    else collection~append(data)
  end
  return

help:
  say 'newtablef - A filter/utility for generating HTML tables'
  say 'usage: newtablef column-names'
  return

parseoption: procedure
  parse arg columnNames
  collection=.array~new
  do w=1 to words(columnNames)
    collection~append(word(columnNames,w))
  end w
  call maketable collection
  return

maketable: procedure
  use arg colnames
  indent=copies(' ',4)
  say '<table class="table">'
  say '  <thead class="thead-light"><tr>'
  loop item over colnames
    say indent||'<th>'item'</th>'
  end
  say '  </tr></thead>'
  say '  <tbody>'
  say '  <tr>'
  loop item over colnames
    say indent||'<td>'item'</td>'
  end
  say '  </tr>'
  say '  </tbody>'
  say '</table>'
  return

programEnd:
  indent=copies(' ',4)
  say '<table class="table">'
  say '  <thead class="thead-light"><tr>'
  loop item over collection
    say indent||'<th>'item'</th>'
  end
  say '  </tr></thead>'
  say '  <tbody><tr>'
  loop item over collection
    say indent||'<td>'item'</td>'
  end
  say '  </tr></tbody>'
  say '</table>'
  exit 0
