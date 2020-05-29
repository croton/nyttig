/* drepo -- Diff a repo. */
parse arg choice
if choice='-?' then call help

basedir=value('userprofile',,'ENVIRONMENT')
homedir=basedir'\cjp'
repodir=basedir'\crepo'
repos=.array~of('gfx', 'nyttig', 'gitx', 'filters', 'snippy', 'x2regina', 'x2prof', 'x2m', 'x2o', 'laratools')

if choice='' then do
  say 'Select a repository:'
  choice=pickAItem(repos)
end
select
  when choice='gfx' then call uiDiff choice, homedir'\bin\gfx'
  when choice='nyttig' then call uiDiff 'nyttig\cmds', homedir'\bin'
  when choice='gitx' then call uiDiff 'nyttig\githelp', homedir'\bin'
  when choice='filters' then call uiDiff 'nyttig\filters', homedir'\bin', '*f.rex'
  when choice='snippy' then call uiDiff choice, homedir'\snips'
  when choice='x2regina' then call uiDiff choice, homedir'\x2'
  when choice='x2prof' then call uiDiff 'x2regina', homedir'\x2', '*.prof'
  when choice='x2m' then call uiDiff 'x2oo\macros', homedir'\x2\macros'
  when choice='x2o' then call uiDiff 'x2oo\other', homedir'\x2\macros'
  when choice='laratools' then call uiDiff choice, homedir'\bin\lara'
  otherwise call getStatus
end
exit

uiDiff: procedure expose repodir
  parse arg repoName, localDir, filespec
  if filespec='' then filespec='*'
  say 'Compare' repodir'\'repoName localDir 'files='filespec
  'wm' repodir'\'repoName localDir '/dl Repo /dr Local /e /s /f' filespec
  return

getStatus: procedure expose repodir
  say '*** Checking Status of each repo'
  projects=cmdOut('dir' repodir '/a:d /b')
  loop rdir over projects
    if \SysFileExists(repodir'\'rdir) then iterate
    say rdir '...'
    'cd' repodir'\'rdir
    'git status -s'
  end
  return

help:
  say 'drepo - Diff a repository'
  say 'usage: drepo [name]'
  say '  gfx nyttig snippy x2regina x2oo'
  exit

::requires 'UtilRoutines.rex'
