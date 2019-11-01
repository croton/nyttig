/* newpage - Create a new HTML page from a template */
parse arg filename options
if abbrev('-?', filename) then call help

type=translate(options)
select
  when wordpos('-BU', type) then tmpl=value('cjp',,'ENVIRONMENT')||'\snips\html5-bulma.tmpl'
  when wordpos('-BO', type) then tmpl=value('cjp',,'ENVIRONMENT')||'\snips\html5-boostrap.tmpl'
  otherwise tmpl=value('cjp',,'ENVIRONMENT')||'\snips\html5page.tmpl'
end

if \SysFileExists(tmpl) then do
  say 'No template found:' tmpl
  exit
end

fn=lower(filename)'.html'
ADDRESS CMD 'call merge' tmpl filename '>>' fn
say 'Created new HTML page:' fn
exit

help: procedure
  say 'usage: newpage filename [-bu | -bo]'
  say '  -bu = use bulma'
  say '  -bo = use bootstrap'
  exit
