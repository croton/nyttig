/* newtab -- A filter for generating Bulma CSS tabs */
parse arg options

if .STDIN~chars then do
  tabnames=.array~new
  call pipe options
end
else call help
exit

pipe: procedure expose tabnames
  parse arg options
  SIGNAL ON NOTREADY NAME programEnd
  SIGNAL ON ERROR    NAME programEnd
  do forever
    parse pull data
    if data='' then iterate
    else tabnames~append(data)
  end
  return

help:
  say 'newtab - A filter for generating Bulma CSS tabs'
  say 'usage: newtab'
  return

beginText: procedure
  parse arg input
  say '<div class="tabs">'
  say '  <ul>'
  return

endText: procedure
  parse arg input
  say '  </ul>'
  say '</div>'
  return

tabcontent: procedure
  parse arg tabname
  say '<div id="'tabname'" class="tabcontent">'
  say '  <h3 class="is-size-3">'tabname'</h3>'
  say '</div>'
  return

programEnd:
  indent=copies(' ',4)
  call beginText
  loop item over tabnames
    say indent||'<li class="tablinks" data-target="'item'"><a>'item'</a></li>'
  end
  call endText
  loop item over tabnames
    call tabcontent item
  end
  exit 0
