/* xs - Show X2 profile shortcuts */
parse arg profiles
if profiles='' then say 'xs profile-list'
else do
  xh=value('X2HOME',,'ENVIRONMENT')
  plist=''
  do w=1 to words(profiles)
    plist=plist xh'\'word(profiles,w)||'.prof'
  end w
  ADDRESS CMD '@type' strip(plist) '2>nul |grep -ie "expand_keyword"|cut = 2|sort'
end
exit
