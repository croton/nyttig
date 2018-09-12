/* g -- Alias utility for git */
parse arg pfx cmds
select
  when pfx='b' then 'git branch' cmds
  when pfx='ba' then 'git branch --all'
  when pfx='bu' then call branchUpstream cmds
  when pfx='bb' then call branchSwitch
  when pfx='cfg' then 'git config --list --show-origin'
  when pfx='ck' then 'git checkout' cmds
  when pfx='cm' then call commit 0, cmds
  when pfx='cma' then call commit 1, cmds
  when pfx='df' then 'git diff' cmds
  when pfx='dh' then call diffByVersion cmds
  when pfx='dd' then call diffByFile cmds
  when pfx='ddt' then call diffByFile cmds '-gui'
  when pfx='dfs' then 'git diff --staged' cmds
  when pfx='dft' then 'git difftool' cmds
  when pfx='l' then 'git log --oneline -n' getnum(cmds,10)
  when pfx='la' then 'git log --author="'cmds'"'
  when pfx='ld' then 'git log --since="'cmds'"'
  when pfx='lf' then call logByFile cmds
  when pfx='ll' then call logCustom cmds
  when pfx='ls' then 'git log --oneline --grep="'cmds'"'
  when pfx='master' then 'git fetch origin master'
  when pfx='mastermrg' then 'git merge FETCH_HEAD'
  when pfx='pop' then 'git stash pop'
  when pfx='pu' then call branchEdit
  when pfx='s' then 'git status -uno' cmds
  when pfx='ss' then 'git status -s -uno'
  when pfx='sf' then call showChanged
  when pfx='so' then call showByHead '--name-only', cmds
  when pfx='sos' then call showByHead '--stat --oneline', cmds
  when pfx='st' then 'git stash save'
  when pfx='stl' then 'git stash list'
  when pfx='ui' then 'start git-gui'
  when pfx='xstage' then 'git reset HEAD' cmds
  when pfx='xtrak' then 'git ls-files . --exclude-standard --others'
  otherwise call help
end
exit

/* Prompt to issue a commit */
commit: procedure
  parse arg inclAll, message
  if message='' then do
    say 'Cannot commit with empty message!'
    return
  end
  if inclAll then gcmd='git commit -m "'message'" -a'
  else            gcmd='git commit -m "'message'"'
  call prompt gcmd
  return

branchSwitch: procedure expose branches.
  call initbranches
  if branches.0=0 then do
    say 'Switch branch? There is only one, current:' branches.CURRENT
    return
  end
  say 'Switch to which branch? (current='branches.CURRENT')'
  do i=1 to branches.0
    say i branches.i
  end i
  bnum=ask('Enter branch number: (1-'branches.0') ->')
  if \datatype(bnum,'W') | bnum<1 | bnum>branches.0 then say 'Selection cancelled'
  else ADDRESS CMD 'git checkout' branches.bnum
  return

/* Set the upstream tracking information for a branch */
branchUpstream: procedure
  parse arg remoteBranch
  if remoteBranch='' then do
    call initbranches
    gcmd='git branch --set-upstream-to=origin/'branches.CURRENT
  end
  else gcmd='git branch --set-upstream-to=origin/'remoteBranch
  call prompt gcmd
  return

branchEdit: procedure expose branches.
  call initbranches
  call prompt 'git push origin' branches.CURRENT
  return

initbranches: procedure expose branches.
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
  return

/* View the change history for a given file */
logByFile: procedure
  parse arg filename fromDate patch
  if filename='' then do
    say 'Missing filename [fromDate] [patch]'
    exit
  end
  if fromDate='' | fromDate='.' then
    gcmd='git log --pretty=format:"%h %aD: %s" --follow'
  else
    gcmd='git log --pretty=format:"%h %aD: %s" --since="'fromDate'" --follow'
  if patch='' then gcmd=gcmd filename
  else             gcmd=gcmd '-p' filename
  say gcmd
  ADDRESS CMD gcmd
  return

/* Compare versions of a commit or a single file */
diffByVersion: procedure
  parse arg v1 v2 filename
  if v1='' then do
    say 'Missing parameters: commit1 commit2 [filename]'
    return
  end
  if filename='' then
    gcmd='git diff' hd(v1) hd(v2)
  else
    gcmd='git diff' hd(v1) hd(v2) '--' filename
  call prompt gcmd
  return

/* Compare a currently changed file (shows up with git status) */
diffByFile: procedure
  parse arg sha
  w=wordpos('-gui',sha)
  if w>0 then do; useGUI=1; sha=delword(sha,w,1); end; else useGUI=0
  files.0=0
  ctr=0
  refSha=''
  if sha='' then do
    gcmd='git status -s -uno'
    ADDRESS CMD gcmd '|RXQUEUE'
    do while queued()>0
      parse pull . entry
      if entry='' then iterate
      ctr=ctr+1
      files.ctr=strip(translate(entry, '\', '/'))
    end
  end
  else do
    refSha=hd(sha)
    gcmd='git show --abbrev-commit --name-only --pretty=oneline' refSha
    ADDRESS CMD gcmd '|RXQUEUE'
    pull . -- ignore first line
    do while queued()>0
      parse pull . 'src/' entry
      if entry='' then iterate
      ctr=ctr+1
      files.ctr=strip(translate(entry, '\', '/'))
    end
  end
  files.0=ctr
  say 'Diff which file?'
  say gcmd
  do i=1 to files.0
    say i files.i
  end i
  bnum=ask('Enter file number: (1-'files.0') ->')
  if \datatype(bnum,'W') | bnum<1 | bnum>files.0 then say 'Selection cancelled'
  else do
    if useGUI then gcmd='git difftool'
    else           gcmd='git diff'
    if sha='' then params=files.bnum
    else           params=refSha 'HEAD --' files.bnum
    call prompt gcmd params
  end
  return

/* Show changed files from git status, with some filtering */
showChanged: procedure
  gcmd='git status -s -uno'
  ADDRESS CMD gcmd '|RXQUEUE'
  do while queued()>0
    parse pull . entry
    if entry='' then iterate
    say strip(translate(entry, '\', '/'))
  end
  return

/* Run git show with convenience shortcuts for HEAD spec */
showByHead: procedure
  parse arg option, sha verbose
  gcmd='git show' option hd(sha)
  if verbose<>'' then say gcmd
  ADDRESS CMD gcmd
  return

/* Show log in custom format */
logCustom: procedure
  parse arg params
  gcmd='git log --pretty=format:"%h %aD %s"'
  if params='' then gcmd=gcmd '-n 10'
  else              gcmd=gcmd translateLogArgs(params)
  if askYN(gcmd) then do
    ADDRESS CMD gcmd '|RXQUEUE'
    do while queued()>0
      parse pull entry
      say delword(entry,7,1) -- remove timezone
    end
  end
  else say 'Command cancelled'
  return

/* Provide convenient substitutions for git log options */
translateLogArgs: procedure
  parse arg options
  w=wordpos('-s',options)
  if w>0 then do; since=word(options,w+1); options=delword(options,w,2); end; else since=''
  w=wordpos('-a',options)
  if w>0 then do; author=word(options,w+1); options=delword(options,w,2); end; else author=''
  if since<>'' then options=options '--since="'since'"'
  if author<>'' then options=options '--author="'author'"'
  return strip(options)

/* Prompt user with question */
ask: procedure
  parse arg q, useCase
  call charout , q' '
  if useCase='' then pull ans
  else               parse pull ans
  return ans

/* Prompt user with a Yes/No question */
askYN: procedure
  parse arg q
  return ask(q '(ENTER=Yes)')=''

/* Prompt user to run a given command */
prompt: procedure
  parse arg gcmd
  if askYN(gcmd) then ADDRESS CMD gcmd
  else                say 'Command cancelled'
  return

/* Validate a numerical value and optionally return a default */
getnum: procedure
  arg numval, default
  if \datatype(default,'W') then default=1
  if datatype(numval,'W') then return numval
  return default

/* Provide shortcut where "~n" will expand to "HEAD~n" */
hd: procedure
  parse arg input
  select
    when pos('~', input)=0 then rval=input
    when input='~'         then rval='HEAD'
    otherwise rval='HEAD~'toNum(substr(input,2))
  end
  return rval

/* Constrain numerical values to a smaller range */
toNum: procedure
  arg numval
  do i=1 to 9
    if abbrev(numval,i) then return i
  end i
  return 1

help: procedure
  say 'g - Alias utility for Git'
  say 'usage: g shortcut parameters'
  say 'shortcuts:'
  parse source . . srcfile .
  ADDRESS CMD 'grep -i "when pfx"' srcfile '|RXQUEUE'
  do while queued()>0
    parse pull . '=' entry . action
    if entry='' then iterate
    say ' ' left(entry, 12, '.') action
  end
  return
