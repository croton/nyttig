/* drepo -- Diff a repo. */
parse arg choice
if choice='-?' then call help

basedir=value('userprofile',,'ENVIRONMENT')
homedir=basedir'\cjp'
repodir=basedir'\cjp-repos'
repos=.array~of('gfx', 'nyttig', 'gitx', 'snippy', 'x2regina', 'x2oo')

if choice='' then do
  say 'Select a repository:'
  choice=pickAItem(repos)
end
select
  when choice='gfx' then call uiDiff choice, homedir'\bin\gfx'
  when choice='nyttig' then call uiDiff 'nyttig\cmds', homedir'\bin'
  when choice='gitx' then call uiDiff 'nyttig\githelp', homedir'\bin'
  when choice='snippy' then call uiDiff choice, homedir'\snips'
  when choice='x2regina' then call uiDiff choice, homedir'\x2'
  when choice='x2oo' then call uiDiff choice, homedir'\x2'
  otherwise call getStatus
end
exit

uiDiff: procedure expose repodir
  parse arg repoName, localDir
  say 'Compare' repodir'\'repoName localDir
  'wm' repodir'\'repoName localDir '/dl Repo /dr Local /e /s /f *'
  return

getStatus: procedure expose repodir repos
  say '*** Checking Status of each repo'
  loop rdir over repos
    if \SysFileExists(repodir'\'rdir) then iterate
    say rdir '...'
    'cd' repodir'\'rdir
    'git status -s'
  end
  return

help:
  say 'drepo - Diff a repository'
  say 'usage: drepo [name]'
  say '  gfx nyttig, snippy, x2regina, x2oo'
  exit

::requires 'UtilRoutines.rex'
