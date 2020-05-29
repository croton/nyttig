/* epm -- Load X2 editor */
parse arg params
w=wordpos('-t',params)
if w>0 then do; windowTitle=word(params,w+1); params=delword(params,w,2); end; else windowTitle=''

parse value parseSwitch(params) with option filenames
select
  when params='-?' then call help
  when option='c'  then call load filenames, 'CSS'
  when option='e'  then call load filenames, 'ES6'
  when option='g'  then call load filenames, 'GULP'
  when option='h'  then call load filenames, 'JHC'
  when option='m'  then call load filenames, 'MD'
  when option='je' then call load filenames, 'JEST'
  when option='n'  then call load filenames, 'NODEJS'
  when option='p'  then call load filenames, 'PHP'
  when option='r'  then call load filenames, 'REACTJS'
  otherwise call load filenames
end
exit

/* Separate any switch from the rest of filename parameters and return
   two values separated by a space - option and filenames.
*/
parseSwitch: procedure
  parse arg input
  filenames=''
  option='none'
  do i=1 to words(input)
    w=word(input, i)
    if left(w,1)='-' then do
      if option='none' then
        parse var w +1 option
    end
    else filenames=filenames w
  end i
  return option filenames

load: procedure expose windowTitle
  parse arg filenames, profile
  winprof=value('winprof',,'ENVIRONMENT')
  if winprof='' then winprof='CmdLine'
  if windowTitle='' then windowTitle='X2'
  xcmd='start "'winprof'" cmd /C "title' windowTitle '& x' strip(filenames)'"'
  /* xcmd='x' filenames */
  if profile='' then ADDRESS CMD xcmd
  else do
    profilepath=value('X2HOME',,'ENVIRONMENT')||'\'profile'.PRO'
    if SysFileExists(profilepath) then
      xcmd='start "'winprof'" cmd /C "title' windowTitle '& x -P'profilepath strip(filenames)'"'
    /* xcmd='x -P'profilepath filenames */
    ADDRESS CMD xcmd
  end
  return

help: procedure
  say 'epm - X2 editor'
  say 'usage: epm [-t window_title][-profile] [files]'
  say 'profiles:'
  parse source . . srcfile .
  call SysFileSearch 'when option', srcfile, 'found.', 'N'
  do j=1 to found.0
    parse value found.j with . '=' entry . action
    if entry='' then iterate
    say ' ' left(entry, 12, '.') word(action, words(action))
  end j
  exit
