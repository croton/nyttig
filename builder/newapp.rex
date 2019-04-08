/* newapp -- Set up a new app directory.
   Created 03-07-2019
*/
parse arg maindir children
if maindir='' then call help

call makedirs maindir, children
exit

makedirs: procedure
  parse arg parent, subdirs
  ok=SysMkDir(parent)
  if ok=0 then do
    'cd' parent
    do w=1 to words(subdirs)
      sdir=word(subdirs,w)
      ok=SysMkDir(sdir)
      if ok<>0 then say 'Unable to create' sdir
    end w
    'dir'
  end
  return

help:
  say 'newapp - Set up a new app directory.'
  say 'usage: newapp'
  exit
