/* consolerpt - Generate a console colors page */
parse arg consolename
if consolename='' then do
  say 'usage: consolerpt consolename'
  exit
end

pageTemplate=value('cjp',,'ENVIRONMENT')'\snips\console-color.tmpl'
output='colors-'lower(consolename)'.html'

/* first version
  'cso p' consolename '|mergevaluef .box-?4 {background-color: rgb(?1,?2,?3);} |pipeinf' pageTemplate '|mergetemplatef' consolename '>' output
*/

'cso p' consolename '|rgbnamef|pipeinf' pageTemplate '|mergetemplatef' consolename '>' output
say 'Saved color report to' output
exit
