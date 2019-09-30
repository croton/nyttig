/* newpage - Create a new HTML page from a template */
parse arg filename options
if abbrev('-?', filename) then call help

w=wordpos('-bulma',options)
if w>0 then do; useBulma=1; options=delword(options,w,1); end; else useBulma=0

if useBulma then
  tmpl=value('cjp',,'ENVIRONMENT')||'\snips\html5-bulma.tmpl'
else
  tmpl=value('cjp',,'ENVIRONMENT')||'\snips\html5page.tmpl'
if \SysFileExists(tmpl) then do
  say 'No template found:' tmpl
  exit
end

fn=lower(filename)'.html'
ADDRESS CMD 'call merge' tmpl filename options '>>' fn
say 'Created new HTML page:' fn
exit

help: procedure
  say 'usage: newpage filename [-bulma] [options]'
  exit
