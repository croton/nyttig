/* newcss - Create a new style sheet from a template */
parse arg filename options
if abbrev('-?', filename) then call help

tmpl=value('cjp',,'ENVIRONMENT')||'\snips\css.tmpl'
if \SysFileExists(tmpl) then do
  say 'No template found:' tmpl
  exit
end

fn=lower(filename)'.css'
ADDRESS CMD 'call merge' tmpl filename options '>>' fn
say 'Created new style sheet:' fn
exit

help: procedure
  say 'usage: newcss filename [options]'
  exit
