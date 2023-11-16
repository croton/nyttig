/* cssClassf -- A filter collecting class names from a CSS file */
arg options
SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
classnames=.set~new
if options='?' then do
  say 'usage: cssclassf [options]'
  say 'options: CSS (default)|JSX|HTML'
  exit
end

if abbrev('CSS', options) then do forever
  -- filter a CSS file
  parse pull data
  if data='' then iterate
  names=filterCss(data)
  if names<>'' then call register classnames, names
end
else if abbrev('JSX', options) then do forever
  parse pull data
  if data='' then iterate
  names=filterJsx(data)
  if names<>'' then do
    classnames~put(names)
    -- say names
  end
end
else do forever
  -- Filter an HTML file
  parse pull data
  if data='' then iterate
  names=filterHtml(data)
  if names<>'' then call registerHtml classnames, names
  -- say names
end
exit

filterCss: procedure
  parse arg statement
  if pos('{', statement)=0 then return ''
  parse var statement selectors '{' .
  namelist=strip(selectors)
  if left(namelist,1)='@' then return ''
  return namelist

filterHtml: procedure
  parse arg statement
  marker=' class="'
  if pos(marker, statement)=0 then return ''
  namelist=''
  do until statement=''
    parse var statement (marker) names '"' statement
    namelist=namelist names
  end
  return strip(namelist)

filterJsx: procedure
  parse arg statement
  marker1=' className="'
  marker2=' className={'
  namelist=''
  if pos(marker1, statement)>0 then do
    st1=statement
    do until st1=''
      parse var st1 (marker1) names '"' st1
      namelist=namelist names
    end
    return strip(namelist)
  end
  if pos(marker2, statement)>0 then do
    do until statement=''
      parse var statement (marker2) names '>' statement
      namelist=namelist names
    end
    return strip(namelist)
  end
  return ''

register: procedure
  use arg collection, itemlist
  do w=1 to words(itemlist)
    selector=word(itemlist,w)
    if left(selector,1)='.' then collection~put(substr(selector,2))
  end w
  return

registerHtml: procedure
  use arg collection, itemlist
  do w=1 to words(itemlist)
    collection~put(word(itemlist,w))
  end w
  return

programEnd:
-- say 'Unique items:' classnames~items
do name over classnames; say name; end
exit 0
