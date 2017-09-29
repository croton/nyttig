/* Search for a given project file */
parse arg input

projdir='c:\Development\fs-ui\source\'
sections.='js\app\'                      -- default section
sectionConfig='-f'
sections.sectionConfig='config\'         -- a section

parse value parseOption(input) with fspec option
select
  when input='-?' then call help
  when fspec='' then call listfiles getmark(), sections.option
  otherwise          call listfiles fspec, sections.option
end

exit

/* Returns a single argument and the first of any hyphen-prefixed options */
parseOption: procedure
  parse arg params
  options=''
  val='*'
  do until params=''
    parse var params part params
    if left(part,1)='-' then options=options part
    else                     val=part
  end
  return val word(options,1)

getmark: procedure
  'EXTRACT /MARK/'
  'EXTRACT /FLSCREEN/'
  select
    when MARK.0=0 then return ''                                -- Nothing marked
    when (MARK.2>FLSCREEN.2 | MARK.3<FLSCREEN.1) then return '' -- Mark exists off screen
    when MARK.6=0 then return ''                                -- Mark exists in another file mark.1
    otherwise
      'EXTRACT /MARKTEXT/'
      return MARKTEXT.1
  end

listfiles: procedure expose projdir
  parse arg fspec, section
  if fspec='*' then 'MSG No filespec specified'
  else do
    if right(fspec,1)<>'*' then fspec=fspec'*'
    'MACRO cmdout projfiles.txt dir' projdir||section||fspec '/s /b'
  end
  return

help: procedure
  'MSG Usage: pjfind filespec [-f]'
  exit
