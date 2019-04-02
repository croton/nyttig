/* js30 - Generate app template for Javascript30 projects */
parse arg dayno descrip
if dayno='' then call help

modname='day'dayno
basedir=value('cjp',,'ENVIRONMENT')
call makeHtml basedir, modname, 'Day' dayno '-' descrip
call makeJs basedir, modname
call makeCss
exit

makeHtml: procedure
  parse arg basedir, modname, title
  dlim='#'
  ADDRESS CMD 'call merge' basedir'\snips\js30html.tmpl' dlim||modname||dlim||title '>>index.html'
  say 'Created index.html'
  return

makeCss: procedure
  outp=.Stream~new('style.css')
  outp~lineout('h1 {')
  outp~lineout('  font-family: Impact, Charcoal, sans-serif; font-size: 2em;')
  outp~lineout('}')
  outp~close
  say 'Created' outp
  return

makeJs: procedure
  parse arg basedir, modname
  outp=modname'.js'
  ADDRESS CMD 'call merge' basedir'\snips\js30js.tmpl' modname '>>'outp
  say 'Created' outp
  return

help:
  say 'js30 - Generate app template for Javascript30 projects'
  say 'usage: js30 dayno description'
  say 'example: js30 1 Drum Kit'
  exit
