/* g -- Alias utility for git */
parse arg pfx cmds
select
  when pfx='b' then 'git branch' cmds
  when pfx='ba' then 'git branch --all'
  when pfx='bb' then call branchSwitch
  when pfx='cfg' then 'git config --list --show-origin'
  when pfx='ck' then 'git checkout' cmds
  when pfx='cm' then call commit 0, cmds
  when pfx='cma' then call commit 1, cmds
  when pfx='df' then 'git diff' cmds
  when pfx='dh' then call diffByVersion cmds
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
  when pfx='s' then 'git status' cmds
  when pfx='ss' then 'git status -s'
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
  if askYN(gcmd) then gcmd
  else                say 'Commit cancelled'
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

branchEdit: procedure expose branches.
  call initbranches
  gcmd='git push origin' branches.CURRENT
  if askYN(gcmd) then ADDRESS CMD gcmd
  else                say 'Command cancelled'
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

/* Compare versions of a file */
diffByVersion: procedure
  parse arg filename v1 v2
  gcmd='git diff' hd(v1) hd(v2) '--' filename
  say 'Run' gcmd
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
  arg count verbose .
  gcmd='git log --pretty=format:"%h %aD %s"'
  if datatype(count,'W') then gcmd=gcmd '-n' count
  if verbose<>'' then say gcmd
  ADDRESS CMD gcmd '|RXQUEUE'
  do while queued()>0
    parse pull entry
    say delword(entry,7,1) -- remove timezone
  end
  return

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
