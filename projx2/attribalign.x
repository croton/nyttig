/* attribalign - Align HTML attributes */
arg stepno
if stepno='' then stepno=1

select
  when stepno=2 then call step2
  when stepno=3 then 'MACRO hiliteblock indent'
  otherwise call step1
end
exit

/* With cursor on first element attribute, break line at next attribute
   Ex. <tag a=1 b=2 c=3 /> becomes ...
       <tag a=1
            b=2
            c=3 />
*/
step1: procedure
  'EXTRACT /CURSOR/'
  origcol=CURSOR.2
  'FIND REPEAT'  -- '='
  'CURSOR +0 +1' -- move right
  'FIND REPEAT'
  'PREVIOUS_WORD'
  'SPLIT'
  'DOWN'
  'MACRO nav HOME'

  'EXTRACT /CURSOR/'
  mismatch=origcol-CURSOR.2
  if mismatch>0 then 'KEYIN' copies(' ',mismatch)

  'MSG new col='CURSOR.2 'orig='origcol 'row='CURSOR.1
  return

/* Break line at second attribute found on current line */
step2: procedure
  'FIND REPEAT'
  'FIND REPEAT'
  'PREVIOUS_WORD'
  'SPLIT'
  'DOWN'
  'MACRO nav HOME'
  'MSG Ok'
  return

