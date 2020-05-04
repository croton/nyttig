/* xs - Show X2 profile shortcuts */
parse arg profiles
if profiles='' then do; say 'xs profile-list'; exit; end

profcount=words(profiles)
xh=value('X2HOME',,'ENVIRONMENT')
do w=1 to profcount
  profn=xh'\'word(profiles,w)||'.prof'
  if SysFileExists(profn) then files.w=profn
end w
files.0=profcount

do i=1 to files.0
  call SysFileSearch 'keyword', files.i, 'found.', 'N'
  do j=1 to found.0
    parse var found.j . '=' trigger
    say strip(trigger)
  end j
end i
exit
