/* repf -- A filter that performs string replace on the input */
parse arg str2remove str2insert
if str2remove='' then str2remove=directory()
if str2insert='' then str2insert='.'

signal on notready name programEnd
do forever
  parse pull input
  say changestr(str2remove, input, str2insert)
end
exit

programEnd:
exit 0
