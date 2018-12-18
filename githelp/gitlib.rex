::requires 'UtilRoutines.rex'

::routine version public
  return '0.13'

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

::routine pickBranch public
  parse arg filter
  branches.=getBranches()
  if branches.0=0 then do
    say 'Switch branch? There is only one, current:' branches.CURRENT
    return -1
  end
  currbranch=branches.CURRENT
  if filter<>'' then do
    ctr=0
    do i=1 to branches.0
      if pos(filter, branches.i)=0 then iterate
      ctr=ctr+1
      selbranch.ctr=branches.i
    end i
    if ctr>0 then do
      selbranch.0=ctr
      branches.=selbranch.
    end
  end
  say 'Switch to which branch? (current='currbranch')'
  return applyCmd2Item('git checkout', branches.)

::routine changeBranch public
  parse arg branchname
  if branchname='' then return -1
  gcmd='git checkout' branchname
  ADDRESS CMD gcmd
  return rc

/* Prompt user with a selection of file revisions to compare */
::routine compareCommits public
  parse arg fspec useTool
  fn=pickFile(fspec)
  if fn='' then say 'No file specified'
  else do
    gcmd='git log --pretty=format:"%h %s" -n 10 --follow' fn
    output=cmdOut(gcmd)
    if output~items>0 then do
      parse value pickIndexes(output) with idx1 idx2
      if \(datatype(idx1,'W') & datatype(idx2,'W')) then say 'Comparison cancelled'
      else do
        if useTool='' then
          gcmd='git diff' word(output[idx1], 1) word(output[idx2],1) '--' fn
        else
          gcmd='git difftool' word(output[idx1], 1) word(output[idx2],1) '--' fn
        call prompt gcmd
      end
    end
    else say 'No log history:' gcmd
  end
  return

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
  parse arg input, prefix
  if prefix='' then prefix='~'
  select
    when pos(prefix, input)=0 then rval=input
    when input=prefix         then rval='HEAD'
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

