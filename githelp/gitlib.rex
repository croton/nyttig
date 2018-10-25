::routine version public
  return '0.1'

::routine getBranch public
  currBranch=''
  ADDRESS CMD 'git branch |RXQUEUE'
  do while queued()>0
    parse pull entry
    if left(entry,1)='*' then currBranch=word(entry, 2)
  end
  return currBranch

/* Return a stem of local branch names, with current branch
   stored at the index, CURRENT.
*/
::routine getBranches public
  gcmd='git branch'
  branches.0=0
  ADDRESS CMD gcmd '|RXQUEUE'
  ctr=0
  do while queued()>0
    parse pull entry
    if left(entry,1)='*' then do
      parse var entry . entry
      branches.CURRENT=entry
    end
    else do
      ctr=ctr+1
      branches.ctr=strip(entry)
    end
  end
  branches.0=ctr
  return branches.

/* Prompt to roll back changes among files currently modified */
::routine applyCmd2ChangedFiles public
  parse arg gcmd, promptMessage
  changed.=queryChangedfiles()
  if changed.0=0 then do
    say 'No changed files present!'
    return
  end
  if promptMessage='' then say 'Apply "'gcmd'" to which file(s)?'
  else                     say promptMessage
  call applyCmd gcmd, changed.
  return

/* Run a git command and return a stem containing a list of file names */
::routine queryChangedfiles public
  gcmd='git status -s -uno'
  ADDRESS CMD gcmd '|RXQUEUE'
  ctr=0
  do while queued()>0
    parse pull . entry
    if entry='' then iterate
    ctr=ctr+1
    files.ctr=strip(translate(entry, '\', '/'))
  end
  files.0=ctr
  return files.

/* Provide convenient substitutions for git log options */
::routine translateLogArgs public
  parse arg options
  w=wordpos('-d',options)
  if w>0 then do; since=word(options,w+1); options=delword(options,w,2); end; else since=''
  w=wordpos('-a',options)
  if w>0 then do; author=word(options,w+1); options=delword(options,w,2); end; else author=''
  if since<>'' then do
    datestr='yesterday'
    if verify(since, '0123456789')=0 then do
      if length(since)=8 then datestr=translate('Mm/Dd/CcYy', since, 'CcYyMmDd')
      else if length(since)<=3 then datestr=since 'days'
    end
    options=options '--since="'datestr'"'
  end
  if author<>'' then options=options '--author="'author'"'
  return strip(options)

/* Provide shortcut where "~n" will expand to "HEAD~n" */
::routine hd public
  parse arg input
  select
    when pos('~', input)=0 then rval=input
    when input='~'         then rval='HEAD'
    otherwise rval='HEAD~'toNum(substr(input,2))
  end
  return rval

/* Constrain numerical values to a smaller range */
::routine toNum public
  arg numval
  do i=1 to 9
    if abbrev(numval,i) then return i
  end i
  return 1

