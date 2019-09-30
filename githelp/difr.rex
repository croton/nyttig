/* difr -- Diff a given filespec against the repository. */
parse arg fspec proj
if abbrev('-?', fspec) then call help
basedir=value('userprofile',,'ENVIRONMENT')||'\crepo'

select
  when proj='g' then repo=basedir'\gfx'
  when proj='n' then repo=basedir'\nyttig'
  when proj='s' then repo=basedir'\snippy'
  when proj='xo' then repo=basedir'\x2oo'
  otherwise           repo=basedir'\x2regina'
end

fname=filespec('n', fspec)
rc=SysFileTree(repo'\'fname,'files.','FSO')
if files.0=0 then do
  say 'No file found:' repo'\'fname
end
else do
  say 'Compare' files.1
  say '       ' fspec
  ADDRESS CMD 'diff' files.1 fspec
  if rc=0 then say 'Ok'
  else         call callOptions files.1, fspec
end
exit

callOptions: procedure
  parse arg fnRepo, fnLocal
  choice=pickAIndex(.array~of('Copy to Remote', 'Copy to Local', 'Compare'))
  select
    when choice=1 then call prompt 'COPY' fnLocal fnRepo
    when choice=2 then call prompt 'COPY' fnRepo '.'
    when choice=3 then 'wm' fnRepo fnLocal '/dl Repo /dr Local'
    otherwise say 'Ok' choice
  end
  return

help:
  say 'difr - Diff a given filespec against the repository.'
  say 'usage: difr filespec project'
  say 'projects: (g)fx (n)yttig (s)nippy xo x2regina=default'
  exit

::requires 'UtilRoutines.rex'
