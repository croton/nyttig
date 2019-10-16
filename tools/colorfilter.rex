/* colorfilter -- Read from the input (STDIN). */
parse arg target opt .
call trace 'off'
signal on notready name programEnd
select
  when target='' then do forever
    parse pull input
    if input='' then iterate
    parse value parseRegistryColorValues(input) with name value
    say substr(name,11) d2rgb(value) word(input, words(input))
  end
  when opt='' then do forever
    parse pull input
    say copyProfileColors(input,target)
  end
  otherwise
    do forever
      parse pull input
      say diffProfileColors(input,target)
    end
end
exit

/* Parse output from registry query
   ex. ColorTable01           : 8405248
*/
parseRegistryColorValues: procedure
  parse arg colortable . val
  return colortable val

d2rgb: procedure
  arg decval
  if \datatype(decval,'W') then return ''
  bluedivisor=2**16
  greendivisor=2**8
  greenq=0
  greenqi=0
  blueq=decval%bluedivisor    -- int division
  blueqi=decval//bluedivisor  -- remainder
  if blueqi>0 then do
    greenq=blueqi%greendivisor
    greenqi=blueqi//greendivisor
  end
  return left('R='greenqi,6) left('G='greenq,6) left('B='blueq,6)

/* Copy colors from source profile to target profile */
copyProfileColors: procedure
  parse arg ctable . cval, target
  if ctable='' then return ''
  if right(ctable,2)='00' then return ''

  pscmd='powershell -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile'
  colorcmd='Set-ItemProperty -Path "HKCU:\Console\'target'" -Name' ctable '-Value' cval
  ADDRESS CMD pscmd colorcmd
  return colorcmd

diffProfileColors: procedure
  parse arg ctable . cval, target
  if ctable='' then return ''
  pscmd='powershell -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile'
  ADDRESS CMD pscmd 'Get-ItemProperty -Path "HKCU:\Console\'target'" -Name' ctable '|grep -i ColorTable |RXQUEUE'
  if queued()>0 then parse pull ttable . tval
  if cval=tval then return ctable 'same'
  else              return ctable 'Src='left(strip(cval),18) 'Target='tval

copyProfileColors2: procedure
  parse arg ctable . cval, src, target
  if ctable='' then return ''
  if right(ctable,2)='00' then return ''

  pscmd='powershell -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile'
  ADDRESS CMD pscmd 'Get-ItemProperty -Path "HKCU:\Console\'target'" -Name' ctable

  return '> Set-ItemProperty -Path "HKCU:\Console\'target'" -Name' ctable '-Value' cval

programEnd:
exit 0