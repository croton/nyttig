/* namex -- A filter for expanding a name into varying version. */
parse arg options

SIGNAL ON NOTREADY NAME programEnd
SIGNAL ON ERROR    NAME programEnd
do forever
  parse pull data
  if data='' then iterate
  say expandByOption(data, '-default' options)
end
exit

expandByOption: procedure
  parse arg phrase, options
  newphrase=''
  do w=1 to words(options)
    opt=word(options,w)
    newphrase=newphrase expand(phrase, opt)
  end w
  return strip(newphrase)

expand: procedure
  parse arg phrase, options
  select
    when options='-u1' then return upperfirst(phrase)
    when options='-c' then return casefirst(upperfirst(phrase), 0)
    when options='-u' then return space(phrase, 1, '_')
    when options='-d' then return space(phrase, 1, '-')
    otherwise return space(phrase, 0)
  end

upperfirst: procedure
  parse arg phrase
  newphrase=''
  do w=1 to words(phrase)
    newphrase=newphrase casefirst(word(phrase,w))
  end w
  return space(newphrase, 0)

casefirst: procedure
  parse arg c1 +1 rest, doUpper
  if doUpper=0 then return lower(c1)||rest
  return translate(c1)||rest

programEnd:
  exit 0
