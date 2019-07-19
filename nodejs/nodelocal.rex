/* nodelocal -- Customize local NodeJS installation. */
parse arg srcdir .
if srcdir='' | srcdir='-?' then call help

if \askYN('Redirect npm prefix and cache to "'srcdir'"') then do
  say 'Ok, now exiting.'
  exit
end
'mkdir' srcdir
if rc<>0 then do
 say 'Directory' srcdir 'already exists?'
end
else do
  'mkdir' srcdir'\npm'
  'mkdir' srcdir'\cache'
  'tree' srcdir '/A'
  call prompt 'npm config set prefix' srcdir'\npm'
  call prompt 'npm config set cache' srcdir'\cache --global'
  say 'Add to path:' srcdir'\npm'
end

-- Associate JS files with nodeJS (needs Admin privilege)
nodeCmd=cmdTop('npm config list|grep exe')
if nodeCmd='' then say 'Could not locate nodeJS executable!'
else do
  fullpath=word(nodeCmd, words(nodeCmd))
  call prompt '@ftype JSFile='fullpath '"%1" %*'
  'ftype JSFile'
end

-- Override defaults for npm init
if askYN('Override defaults for npm init?') then do
  call runcmd 'npm config set init.author.name "CJPena"'
  call runcmd 'npm config set init.author.email "celestino.pena@gmail.com"'
  call runcmd 'npm config set init.license "MIT"'
  call runcmd 'npm config set init.version "0.0.1"'
end

-- Set verbosity of debugging .. silent, error, warn, http, info, verbose, and silly
-- npm config set loglevel @
exit

help:
  say 'nodelocal - Customize local NodeJS installation.'
  say 'usage: nodelocal srcdir'
  exit

::requires 'UtilRoutines.rex'
