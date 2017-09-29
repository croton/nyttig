/* gsh -- Read from the input (STDIN). */
call trace 'off'
signal on notready name programEnd
do forever
  call charout , prompt()
  parse pull input
  select
    when translate(input)='EXIT' then exit 0
    when abbrev(input, 'rx ') then interpret say subword(input, 2)
    when abbrev(input, 'rxe ') then interpret subword(input, 2)
    otherwise
      ADDRESS SYSTEM input
  end
end
exit

prompt: procedure
  return directory() '>> '

programEnd:
  exit 0
