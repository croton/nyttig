/* newpen -- Create a new CodePen including HTML, CSS, JS */
parse arg name params
if name='' then call help

rc=sysMkDir(name)
'cd' name
basedir=value('cjp',,'ENVIRONMENT')
html=basedir'\snips\codepen-html.tmpl'
css=basedir'\snips\codepen-css.tmpl'
js=basedir'\snips\codepen-js.tmpl'

'merge' html name params '>>' name'.html'
'merge' css name params '>>' name'.css'
'merge' js name params '>>' name'.js'
say 'Created 3 templates!'
'dir' name'*'
exit

help:
  say 'newpen - Create a new CodePen'
  say 'usage: newpen name'
  exit
