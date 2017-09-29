/* concolors -- Sample the current console colors.
   Created 06-07-2017
*/
arg bg
if bg='-?' then call help
else if bg='' then bg='F'

/*
0 = Black       8 = Gray
1 = Blue        9 = Light Blue
2 = Green       A = Light Green
3 = Aqua        B = Light Aqua
4 = Red         C = Light Red
5 = Purple      D = Light Purple
6 = Yellow      E = Light Yellow
7 = White       F = Bright White
*/
colornames='Black Blue Green Aqua Red Purple Yellow White Gray Light-Blue Light-Green Light-Aqua Light-Red Light-Purple Light-Yellow Bright-White'
colors='0123456789ABCDEF'
do c=1 to length(colors)
  fg=substr(colors,c,1)
  'call color' bg||fg
  say 'BG:' bg 'FG:' fg word(colornames,c) '>> Try a command (X=Exit) ->'
  parse pull mycmd
  input=translate(mycmd)
  if input='X' then leave c
  else if input='' then iterate
  ADDRESS SYSTEM mycmd
  '@pause'
end c

exit

help:
say 'concolors - Sample the current console colors'
say 'usage: concolors bgcolor'
say '  bgcolor = single digit in [0123456789ABCDEF]'
exit
