/* g -- Alias utility for git */
parse arg pfx cmds
select
  when pfx='b' then 'git branch' cmds
  when pfx='ba' then 'git branch -all'
  when pfx='bb' then call switch2branch
  when pfx='cfg' then 'git config --list --show-origin'
  when pfx='ck' then 'git checkout' cmds
  when pfx='com' then call gcommit cmds
  when pfx='df' then 'git diff' cmds
  when pfx='dfs' then 'git diff --staged' cmds
  when pfx='dft' then 'git difftool' cmds
  when pfx='l' then 'git log --oneline' cmds
  when pfx='la' then 'git log --author="'cmds'"'
  when pfx='ld' then 'git log --since="'cmds'"'
  when pfx='lf' then call fileHistory cmds
  when pfx='ll' then 'git log --oneline -n 10' cmds
  when pfx='ls' then 'git log --oneline --grep="'cmds'"'
  when pfx='master' then 'git fetch origin master'
  when pfx='mastermrg' then 'git merge FETCH_HEAD'
  when pfx='pop' then 'git stash pop'
  when pfx='pu' then call push2branch
  when pfx='s' then 'git status' cmds
  when pfx='so' then 'git show --name-only' cmds
  when pfx='sos' then 'git show --stat --oneline' cmds
  when pfx='st' then 'git stash save'
  when pfx='stl' then 'git stash list'
  when pfx='ui' then 'start git-gui'
  when pfx='xstage' then 'git reset HEAD' cmds
  when pfx='xtrak' then 'git ls-files . --exclude-standard --others'
  otherwise call help
end
exit

/* Prompt to issue a commit */
gcommit: procedure
  parse arg message
  if message='' then do
    say 'Cannot commit with empty message!'
    return
  end
  gcmd='git commit -m "'message'" -a'
  if askYN(gcmd) then gcmd
  else                say 'Commit cancelled'
  return

switch2branch: procedure expose branches.
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

push2branch: procedure expose branches.
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
fileHistory: procedure
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

help: procedure
  say 'g - Alias utility for Git'
  say 'usage: g shortcut parameters'
  say 'shortcuts:'
  parse source . . srcfile .
  ADDRESS CMD 'grep -i "when "' srcfile '|RXQUEUE'
  do while queued()>0
    parse pull . '=' entry . action
    if entry='' then iterate
    say ' ' left(entry, 12, '.') action
  end
  return
