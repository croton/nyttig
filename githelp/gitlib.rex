::requires 'UtilRoutines.rex'

::routine version public
  return '0.17'

::routine getBranch public
  currBranch=''
  branches=cmdout('git branch')
  loop item over branches
    if left(item,1)='*' then currBranch=word(item, 2)
  end
  return currBranch

-- Get all branches except for current
::routine getAvailableBranches PUBLIC
  availableBranches=.array~new
  branches=cmdOut('git branch')
  loop item over branches
    if left(item,1)<>'*' then availableBranches~append(strip(item))
  end
  return availableBranches

::routine editBranch PUBLIC
  parse arg method, remote branchName
  if abbrev('PUSH', translate(method)) then gcmd='git push'
  else                                      gcmd='git pull'
  if remote='' then remote='origin'
  if branchName='' then branchName=getBranch()
  call prompt gcmd remote branchName
  return

/* Return a stem of local branch names, with current branch
   stored at the index, CURRENT.
*/
::routine getBranches public
  ctr=0
  branches.0=ctr
  branchnames=cmdOut('git branch')
  loop item over branchnames
    if left(item,1)='*' then branches.CURRENT=word(item, 2)
    else do
      ctr=ctr+1
      branches.ctr=strip(item)
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
  say 'Switch to which branch? (current='branches.CURRENT')'
  if filter='' then ok=applyCmd2Choice('git checkout', branches.)
  else do
    ctr=0
    do i=1 to branches.0
      if pos(filter, branches.i)=0 then iterate
      ctr=ctr+1
      selbranch.ctr=branches.i
    end i
    if ctr=0 then ok=-1
    else do
      selbranch.0=ctr
      ok=applyCmd2Choice('git checkout', selbranch.)
    end
  end
  return ok

::routine changeBranch public
  parse arg branchname
  if branchname='' then return -1
  gcmd='git checkout' branchname
  ADDRESS CMD gcmd
  return rc

::routine cleanBranches PUBLIC
  branches2del=arrfilter(cmdOut('git branch --merged master',1), 'master')
  if branches2del~items=0 then do
    say 'No disposible branches exist; all have unmerged changes.'
    return
  end
  say 'Select an already-merged branch to remove:'
  branch=pickAItem(branches2del)
  if branch<>'' then call prompt 'git branch -d' strip(branch)
  return

::routine branchUpstream PUBLIC
  parse arg remoteBranch
  if remoteBranch='' then do
    brn=getBranch()
    gcmd='git branch --set-upstream-to=origin/'brn
  end
  else gcmd='git branch --set-upstream-to=origin/'remoteBranch
  say gcmd
  return

::routine rebaseBranch PUBLIC
  parse arg targetBranch
  sourceBranch='master'
  currBranch=getBranch()
  if targetBranch='' then do
    say 'Choose a branch to be rebased (curr='currBranch'):'
    targetBranch=pickAItem(getAvailableBranches())
    if targetBranch='master' | targetBranch='' then return
  end
  call prompt 'git rebase' currBranch targetBranch
  return

::routine mergeBranch PUBLIC
  parse arg targetBranch
  if targetBranch='' then do
    say 'Choose a branch to be merged (curr='getBranch()'):'
    targetBranch=pickAItem(getAvailableBranches())
    if targetBranch='' then return
  end
  call prompt 'git merge' targetBranch
  return

/* View the change history for a given file */
::routine logByFile PUBLIC
  parse arg filespec fromDate patch
  if abbrev('-?', filespec) then do
    say 'logByFile filespec [fromDate] [patch]'
    say '  fromDate = [yyyyMmDd | days]'
    return
  end
  fn=pickFile(filespec)
  if fn='' then return
  if fromDate='' | fromDate='.' then
    gcmd='git log --pretty=format:"%h %aD: %s" --follow'
  else
    gcmd='git log --pretty=format:"%h %aD: %s"' translateLogArgs('-d' fromDate) '--follow'
  if patch='' then gcmd=gcmd fn
  else             gcmd=gcmd '-p' fn
  call runcmd gcmd
  return

/* Show logs according to date and/or author */
::routine logByDateAuthor PUBLIC
  parse arg params
  gcmd='git log'
  if params='-?' then do
    say 'logCustom [log-options][-d date-expr][-a author]'
    say '  date-expr = [yyyyMmDd | days]'
    return
  end
  logFormat='--pretty=format:"%h %aD %s"'
  if params='' | datatype(params,'W') then
    call runcmd gcmd logFormat '-n' getnum(params,10)
  else do
    logOptions=translateLogArgs(params)
    if pos('--author', logOptions)>0 then logFormat='--pretty=format:"%h %ar [%an] %s"'
    call runcmd gcmd logFormat logOptions
  end
  return

::routine showLastLogs PUBLIC
  arg count
  defaultCount=10
  gcmd='git show --name-only --oneline'
  ADDRESS CMD gcmd
  if datatype(count,'W') then do
    if count<2 then count=2
    else if count>10 then count=defaultCount
    do i=1 to count-1
      ADDRESS CMD gcmd 'HEAD~'i
    end i
  end
  return

-- View a file at a given revision
::routine viewfile public
  parse arg fspec rev
  fn=pickFile(fspec)
  if fn='' then do
    say 'No file specified'
    return ''
  end
  if rev='' then do
    sha=selectRevision()
    if sha<>'' then rev=word(sha,1)
  end
  fnt=translate(fn, '/', '\')
  if rev='' then gcmd='git show' fnt
  else           gcmd='git show' hd(rev)':'fnt
  call prompt gcmd
  return gcmd

/* Compare a currently changed file or one from a given commit */
::routine diffByFile PUBLIC
  parse arg sha, useGUI
  if useGUI='' then useGUI=0
  else              useGUI=1
  if sha='' then files.=queryChangedfiles()
  else do
    refSha=hd(sha)
    results=cmdOut('git show --abbrev-commit --name-only --pretty=""' refSha)
    ctr=0
    loop item over results
      ctr=ctr+1
      files.ctr=strip(translate(item, '\', '/'))
    end
    files.0=ctr
  end
  select
    when files.0=0 then do
      say 'No files to diff' sha
      return
    end
    when files.0=1 then fnum=1
    otherwise
      say 'Diff which file?'
      fnum=pickIndex(files.)
  end
  if fnum='' then do
    say 'Selection cancelled'
    return
  end
  if useGUI then gcmd='git difftool'
  else           gcmd='git diff'
  if sha='' then params=files.fnum
  else           params=refSha 'HEAD --' files.fnum
  call runcmd gcmd params, 1
  return

::routine compareAdjacentCommits public
  parse arg fspec rev
  fn=pickFile(fspec)
  gcmd=''
  if fn='' then say 'No file specified'
  else do
    headOffset=toNum(rev)
    if rev='' then gcmd='git diff HEAD~1 HEAD --' fn
    else           gcmd='git diff' hd('~'headOffset+1) hd('~'headOffset) '--' fn
    call prompt gcmd
  end
  return gcmd

/* Prompt user with a selection of file revisions to compare */
::routine compareCommits public
  parse arg fspec useTool
  fn=pickFile(fspec)
  if fn='' then do
    say 'No file specified'
    return ''
  end
  else do
    gcmd='git log --pretty=format:"%h %s" -n 10 --follow' fn
    output=cmdOut(gcmd)
    if output~items>0 then do
      parse value pickAIndexes(output) with idx1 idx2
      if \(datatype(idx1,'W') & datatype(idx2,'W')) then say 'Comparison cancelled'
      else do
        if useTool='' then
          gcmd='git diff' word(output[idx1],1) word(output[idx2],1) '--' fn
        else
          gcmd='git difftool' word(output[idx1],1) word(output[idx2],1) '--' fn
        say 'Compare commits for' fn
        say ' ' subword(output[idx1],2)
        say ' ' subword(output[idx2],2)
        call prompt gcmd
      end
    end
    else say 'No log history:' gcmd
  end
  return gcmd

::routine commit PUBLIC
  parse arg inclAll, message
  if message='' then do
    say 'Cannot commit with empty message!'
    return
  end
  if inclAll then gcmd='git commit -m "'message'" -a'
  else            gcmd='git commit -m "'message'"'
  call prompt gcmd
  return

::routine rollbackfile PUBLIC
  parse arg fspec rev
  gcmd='git checkout'
  fn=pickFile(fspec)
  if fn='' then do
    say 'No file specified'
    return
  end
  if rev='' then do
    sha=selectRevision()
    if sha='' then do
      say 'Selection cancelled'
      return
    end
    else gcmd=gcmd word(sha,1)
  end
  else gcmd=gcmd rev
  call prompt gcmd '--' fn
  return

::routine viewtag PUBLIC
  parse arg tagname
  if tagname='' then tagname=selectTag()
  if tagname='' then return
  'git show' tagname
  return

::routine pushtag PUBLIC
  parse arg tagname
  if tagname='' then tagname=selectTag()
  if tagname='' then return
  call prompt 'git push origin' tagname
  return

::routine maketag PUBLIC
  parse arg tagname message, doPush
  if tagname='' then do
    say 'maketag tagname'
    return
  end
  if message='' then gcmd='git tag -a' tagname '-m "Version' tagname'"'
  else               gcmd='git tag -a' tagname '-m "'message'"'
  call prompt gcmd
  if doPush=1 then call prompt 'git push origin' tagname
  say 'Current tags'; 'git tag'
  return

::routine cloneProject public
  parse arg name
  gcmd='git clone https://github.com/croton/'name'.git'
  call prompt gcmd
  return gcmd

::routine checkoutRemote public
  parse arg name
  say 'Fetching ...'
  'git fetch origin'
  gcmd='git branch -r'
  branches=cmdout(gcmd)
  if branches~items>0 then branches~delete(branches~first) -- ignore HEAD
  choice=pickAItem(branches)
  if choice='' then say 'No branch selected'
  else do
    parse var choice prefix '/' branchname
    call prompt 'git checkout' branchname
  end
  return gcmd

::routine addUntracked public
  arg doPrompt
  untracked=cmdOut('git ls-files . --exclude-standard --others')
  if untracked~items=0 then say 'There are NO untracked files'
  else call applyCmd2AEach 'git add', untracked, (doPrompt=1)
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
  call applyCmd2Each gcmd, changed.
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

::routine showStatus PUBLIC
  parse arg options
  say 'Changes on branch' getBranch()
  'git status -s' options
  return

/* Run git show with convenience shortcuts for HEAD spec */
::routine showByHead PUBLIC
  parse arg option, sha verbose
  gcmd='git show' option hd(sha)
  if sha='-?' then say 'showByHead git-show-option [sha] [verbose]'
  else do
    if verbose<>'' then say gcmd
    ADDRESS CMD gcmd
  end
  return

/* Show changed files from git status, with some filtering */
::routine showChanged PUBLIC
  parse arg sha
  if sha='' then do
    files.=queryChangedfiles()
    do i=1 to files.0
      say files.i
    end i
  end
  else do
    refSha=hd(sha)
    gcmd='git show --abbrev-commit --name-only --pretty=oneline' refSha
    ADDRESS CMD gcmd '|RXQUEUE'
    parse pull comment
    say comment
    do while queued()>0
      parse pull . 'src/' entry
      if entry='' then iterate
      say strip(translate(entry, '\', '/'))
    end
  end
  return

/* Provide convenient substitutions for git log options */
::routine translateLogArgs public
  parse arg options
  w=wordpos('-d',options)
  if w>0 then do; since=word(options,w+1); options=delword(options,w,2); end; else since=''
  w=wordpos('-a',options)
  if w>0 then do; author=word(options,w+1); options=delword(options,w,2); end; else author=''
  if since<>'' then do
    datestr='yesterday'
    if datatype(since, 'W') then do
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
  arg numval, maxval
  if \datatype(maxval,'W') then maxval=20
  if datatype(numval,'W') & numval<=maxval then return numval
  return 1

::routine selectRevision
  commits=cmdOut('git log --pretty=format:"%h %s" -n 15')
  if commits~items=0 then return ''
  else choice=pickAItem(commits)
  if choice='' then return ''
  return word(choice,1)

::routine selectTag
  tags=cmdOut('git tag')
  if tags~items=0 then return ''
  return pickAItem(tags)

