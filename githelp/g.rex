/* g -- Alias utility for git */
parse arg pfx options
select
  when pfx='a' then call applyCmd2ChangedFiles 'git add', 'Stage which file(s)?'
  when pfx='ax' then call addUntracked options
  when pfx='b' then 'git branch' options
  when pfx='bc' then say getBranch()
  when pfx='bb' then call pickBranch options
  when pfx='bd' then 'git branch --sort=-committerdate -v|head -'getnum(options,10)
  when pfx='bn' then call prompt 'git checkout -b' options
  when pfx='bu' then call branchUpstream options
  when pfx='cfg' then 'git config --list --show-origin'
  when pfx='ck' then 'git checkout' options
  when pfx='cm' then call commit 0, options
  when pfx='cma' then call commit 1, options
  when pfx='df' then 'git diff' options
  when pfx='dft' then 'git difftool' options
  when pfx='dfts' then 'git difftool --staged' options
  when pfx='dfs' then 'git diff --staged' options
  when pfx='dd' then call diffByFile options
  when pfx='ddt' then call diffByFile options, 'GUI'
  when pfx='du' then 'git diff --name-only|asarg echo git add'
  when pfx='dh' then call diffByVersion options
  when pfx='f' then 'git fetch origin'
  when pfx='l' then 'git log --oneline -n' getnum(options,10)
  when pfx='ll' then call logCustom options
  when pfx='lf' then call logByFile options
  when pfx='ls' then 'git log --oneline --grep="'options'"'
  when pfx='m' then call prompt 'git checkout master'
  when pfx='mg' then call mergeRequest
  when pfx='pu' then call editBranch 'PUSH', options
  when pfx='pl' then call editBranch 'PULL', options
  when pfx='r' then call applyCmd2ChangedFiles 'git checkout', 'Roll back changes to which file(s)?'
  when pfx='reset' then call prompt 'git reset HEAD' options
  when pfx='rf' then call rollbackfile options
  when pfx='rpo' then 'git remote prune origin'
  when pfx='s' then 'git status -uno' options '|grep -ve "\.\."'
  when pfx='ss' then 'git status -s' options
  when pfx='sf' then call showChanged options
  when pfx='so' then call showByHead '--name-only', options
  when pfx='sos' then call showByHead '--stat --oneline', options
  when pfx='st' then 'git stash save'
  when pfx='stp' then 'git stash pop'
  when pfx='stl' then 'git stash list'
  when pfx='ui' then 'start git-gui'
  when pfx='vf' then call viewfile options
  when pfx='xt' then 'git ls-files . --exclude-standard --others'
  when pfx='-?' then call help options
  otherwise call help
end
exit

help: procedure
  say 'g - Alias utility for Git, version' 0.0.2
  say 'usage: g shortcut parameters'
  say 'shortcuts:'
  parse arg filter
  parse source . . srcfile .
  if filter='' then say 'commands:'
  else              say 'commands containing "'filter'":'
  call showSourceOptions srcfile, 'when pfx', filter
  return

/*  gitlib
diffByVersion options
logCustom options
mergeRequest

compareAdjacentCommits
compareCommits
queryChangedfiles
translateLogArgs
cloneProject
checkoutRemote
*/
::requires 'gitlib.rex'
