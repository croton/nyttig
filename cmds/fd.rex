/* fd - find files by date */
parse arg options
if abbrev('?', options, 1) then do
  say 'fd - find and sort files by date'
  say 'usage: fd [-d directory] [-x extension] [-dy daysAgo] [-v]'
  exit
end
/*
if folder='' then folder='.'
say 'Find files in folder' folder 'using spec' filespec 'changed' daysAgo 'ago'
*/

w=wordpos('-d',options)
if w>0 then do; dir=word(options,w+1); options=delword(options,w,2); end; else dir='.'
w=wordpos('-x',options)
if w>0 then do; xt=word(options,w+1); options=delword(options,w,2); end; else xt=''
w=wordpos('-dy',options)
if w>0 then do; daysAgo=word(options,w+1); options=delword(options,w,2); end; else daysAgo=1
if \datatype(daysAgo,'W') then daysAgo=1
w=wordpos('-v',options)
if w>0 then do; help=1; options=delword(options,w,1); end; else help=0

if xt='' then filter=''
else          filter='-Include' xt

pscmd='Get-ChildItem -Path' dir '-Recurse' filter,
  '|where {-not $_.PsIsContainer -and $_.LastWriteTime -gt (Get-Date).AddDays(-'daysAgo') }',
  '|Sort-Object LastWriteTime -Descending',
  '|Select-Object -Property FullName, LastWriteTime, Length'
call runps pscmd, help
exit

runps: procedure
  parse arg cmds, dohelp
  if dohelp then say 'PS>' cmds
  'call powershell "'cmds'"'
  return
