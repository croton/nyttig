/* epm -- Load X2 editor */
parse arg params
parse value parseSwitch(params) with option filenames
select
  when params='-?' then call help
  when option='c' then call load filenames, 'CSS'
  when option='e'  then call load filenames, 'ES6'
  when option='g'  then call load filenames, 'GULP'
  when option='h'  then call load filenames, 'JHC'
  when option='m' then call load filenames, 'MD'
  when option='mo' then call load filenames, 'MOCHA'
  when option='n' then call load filenames, 'NODEJS'
  when option='p'  then call load filenames, 'PHP'
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

load: procedure
  parse arg filenames, profile
  winprof=value('winprof',,'ENVIRONMENT')
  if winprof='' then winprof='CmdLine'
  xcmd='start "'winprof'" cmd /C "title X2 & x' strip(filenames)'"'
  /* xcmd='x' filenames */
  if profile='' then ADDRESS CMD xcmd
  else do
    profilepath=value('X2HOME',,'ENVIRONMENT')||'\'profile'.PRO'
    if SysFileExists(profilepath) then xcmd='start "'winprof'" cmd /C "x -P'profilepath strip(filenames)'"'
    /* xcmd='x -P'profilepath filenames */
    ADDRESS CMD xcmd
  end
  return

help:
  say 'epm - X2 editor'
  say 'usage: epm [-profile] [files]'
  say 'profiles:'
  parse source . . srcfile .
  ADDRESS CMD 'grep -i "when option"' srcfile '|RXQUEUE'
  do while queued()>0
    parse pull . '=' entry . action
    if entry='' then iterate
    say ' ' left(entry, 12, '.') word(action, words(action))
  end
  exit
