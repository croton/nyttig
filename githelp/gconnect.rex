/* gconnect -- utility tool */
parse arg pfx params
select
  when pfx='name' then call setname
  when pfx='ping' then call ping params
  when pfx='ssh' then call ssh
  when pfx='clone' then call clone
  when pfx='cfg' then call showCfg
  when pfx='key' then call createKey
  otherwise call help
end
exit

setname: procedure
  say 'Current name and email:'
  'git config --global user.name'
  'git config --global user.email'
  if askYN('Set new name and email') then do
    'git config --global user.name "Cel Pena"'
    'git config --global user.email celestino.pena@gmail.com'
  end
  return

ping: procedure
  parse arg repo
  -- call runcmd 'git ls-remote' repo 'git@github:croton/'repo'.git'
  call runcmd 'git ls-remote' repo 'https://github.com/croton/'repo'.git'
  return

showCfg: procedure
  'git config --list'
  curruser=value('USERNAME',,'ENVIRONMENT')
  gitcfg=value('USERPROFILE',,'ENVIRONMENT')||'\.gitconfig'
  say '*** Git config for user' curruser '-' gitcfg '***'; pull .
  'type' gitcfg
  return

ssh: procedure expose repo
  sshKey='c:\cjp\ssh\id_rsa'
  sshAdd='c:\MyTools\Git\usr\bin\ssh-add'
  say 'Start ssh agent ...'
  'start-ssh-agent'
  say 'Add ssh key ... (Press ENTER)'
  pull .
  call runcmd 'call' sshAdd sshKey
  return

clone: procedure expose repo
  call runcmd 'git clone' repo
  return

/* Make git ssh key */
createKey: procedure
  usermail=cmdTop("git config user.email")
  if askYN('Create SSH key for' usermail) then
    'c:\mytools\Git\usr\bin\ssh-keygen -t rsa -b 2048 -C "'usermail'"'
  return

help: procedure
  say 'gconnect -- A utility tool, version' 0.2
  say 'commands:'
  parse source . . srcfile .
  call showSourceOptions srcfile, 'when pfx'
  return

::requires 'UtilRoutines.rex'
