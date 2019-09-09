/* difr -- Diff a given filespec against the repository. */
parse arg proj fspec
if proj='' then call help
basedir='C:\Users\ACER\cjp-repos'

select
  when proj='g' then repo=basedir'\gfx'
  when proj='n' then repo=basedir'\nyttig'
  when proj='s' then repo=basedir'\snippy'
  when proj='xo' then repo=basedir'\x2oo'
  otherwise           repo=basedir'\x2regina'
end

if fspec='' then do
  'dir' repo '/w'
  return
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
  say 'usage: difr project filespec'
  say 'projects: (g)fx (n)yttig (s)nippy xo x2regina'
  exit

::requires 'UtilRoutines.rex'
