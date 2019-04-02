/* uimod -- Create a skeleton structure for a UI component.
   Created 09-20-2017
*/
parse arg fullname '-' +0 options
if fullname='' then call help

tmplfolder=parseOption(options, '-t')

call rxfuncadd 'sysloadfuncs', 'regutil', 'sysloadfuncs'
call sysloadfuncs
call makeComponent fullname, tmplfolder

exit

/* ------------------------------- Functions -------------------------------- */
parseOption: procedure
  parse arg params, option
  w=wordpos(option, params)
  if w>0 then val=strip(word(params,w+1))
  else        val=''
  return val

makeComponent: procedure
  parse arg fullname, tmplfolder
  if stream(tmplfolder,'c','query exists')='' then tf=''
  else                                             tf=tmplfolder'\'
  -- Generate names to be inserted into templates
  call makenames fullname
  do while queued()>0
    parse pull key entry
    names.key=entry
  end
  viewpath='.'
  parentFolder='payments'
  -- Create a folder for the view with 'dashed name'
  call sysmkdir names.CML
  if RESULT=0 then do
    viewpath='.\'names.CML
    say 'Created directory for view:' names.CML '->' viewpath
  end
  else say 'Directory'names.CML 'NOT created!'
  -- Generate source files from templates
  tmplates.1='cfgcomp.tmpl'
  tmplates.1.outfile='component_'names.UND'.json'
  tmplates.1.params=names.UND names.DSH

  tmplates.2='cfgtab.tmpl'
  tmplates.2.outfile='tab_'names.UND'.json'
  tmplates.2.params='#'names.UND'#'names.FUL -- place delim for multi-word params

  tmplates.3='comp.tmpl'
  tmplates.3.outfile=names.CML'Component.js'
  tmplates.3.params=names.CML names.UPP parentFolder

  tmplates.4='compSpec.tmpl'
  tmplates.4.outfile=names.CML'ComponentSpec.js'
  tmplates.4.params=names.CML names.DSH names.UPP

  tmplates.5='html.tmpl'
  tmplates.5.outfile=names.CML'Component.tpl.html'
  tmplates.5.params=names.CML names.DSH

  tmplates.6='service.tmpl'
  tmplates.6.outfile=names.UPP'Service.js'
  tmplates.6.params=names.UPP names.CML

  tmplates.7='serviceSpec.tmpl'
  tmplates.7.outfile=names.UPP'ServiceSpec.js'
  tmplates.7.params=names.UPP names.CML

  tmplates.8='compPerm.tmpl'
  tmplates.8.outfile=names.UPP'ComponentEntitlements.js'
  tmplates.8.params=names.UPP names.UND

  tmplates.9='css.tmpl'
  tmplates.9.outfile=names.CML'Component.css'
  tmplates.9.params=names.DSH
  tmplates.0=9
  do i=1 to tmplates.0
    call mergeTemplate tf||tmplates.i, viewpath, tmplates.i.outfile, tmplates.i.params
  end i
  say 'Generated' tmplates.0 'templates'
  call copyToProjectFolders names.CML, parentFolder
  return

mergeTemplate: procedure
  parse arg template, destpath, filename, params
  ADDRESS SYSTEM 'dir' destpath '2>&1>nul |RXQUEUE'
  if queued()>0 then pull erc
  if RC<>0 then do
    call sysmkdir destpath
    if RESULT=0 then say 'Created directory for template output:' destpath
    else             say 'Directory for template output' destpath 'NOT created!'
  end
  if stream(template,'c','query exists')='' then
    say 'No template found at' template
  else
    ADDRESS SYSTEM 'merge' template params '>' destpath'\'filename
  return RC

-- Test version of template merge function
mergeTemplateStdout: procedure
  parse arg template, destpath, filename, params
  RC=1
  if stream(template,'c','query exists')='' then
    say 'No template found at' template
  else do
    say 'merge' template params
    ADDRESS SYSTEM 'merge' template params
  end
  return RC

makenames: procedure
  parse arg fullname
  spacedcaps=''
  do w=1 to words(fullname)
    spacedcaps=spacedcaps capfirst(word(fullname,w))
  end w
  camelcase=produceName(fullname)
  queue 'CML' camelcase
  queue 'UPP' capfirst(camelcase)
  queue 'DSH' space(fullname,1,'-')
  queue 'UND' space(fullname,1,'_')
  queue 'FUL' strip(spacedcaps)
  return

-- Create a camel-case word from 2 or more words
produceName: procedure
  parse arg fullname
  newname=''
  text=strip(fullname)
  do w=1 to words(text)
    if w=1 then newname=newname||word(text,w)
    else        newname=newname||capfirst(word(text,w))
  end w
  return strip(newname)

-- Capitalize first letter of a given string
capfirst: procedure
  parse arg c1 +1 rest
  return translate(c1)||rest

makeProjectDirs: procedure
  parse arg fn
  do while lines(fn)<>0
    pdir=linein(fn)
    'mkdir' pdir
    if rc<>0 then say 'Problem creating directory "'pdir"'"
  end
  call lineout fn -- close the file
  return

/* Set up directories to match that of the target project */
copyToProjectFolders: procedure
  parse arg modulename, componentHome
  dirs.1=modulename'\source\config\configs\AAAA4151-kohls\solutionBuilder\components'
  dirs.2=modulename'\source\config\configs\AAAA4151-kohls\solutionBuilder\tabs'
  dirs.3=modulename'\source\js\app\components\'componentHome'\'modulename
  dirs.0=3
  allOk=1
  do i=1 to dirs.0
    'mkdir' dirs.i
    if RC<>0 then do
      allOk=0
      say 'Unable to create directory' dirs.i
    end
  end i
  if allOk then do
    say 'Copying files into project structure ...'
    'copy' modulename'\comp*.json' dirs.1
    'copy' modulename'\tab*.json' dirs.2
    'copy' modulename'\*.js' dirs.3
    'copy' modulename'\*.html' dirs.3
    'copy' modulename'\*.css' dirs.3
  end
  else say 'Unable to create project structure; files will be created in same folder:' modulename
  return

help:
  say 'uimod - Create a skeleton structure for a UI component'
  say 'Usage: uimod fullname [options]'
  say 'Options:'
  say '  -t = specify a directory for the templates'
  exit
