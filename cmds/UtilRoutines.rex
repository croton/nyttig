/* Common functions for productivity utils */
::routine version public
  return '0.14'

::routine runcmd public
  parse arg xcmd, verbose
  if xcmd='' then return
  showCmd=abbrev('1', verbose)
  if showCmd then say 'Run "'xcmd'"'
  ADDRESS CMD xcmd
  return

/* Prompt user to run a given command */
::routine prompt public
  parse arg xcmd
  if askYN(xcmd) then ADDRESS CMD xcmd
  else                say 'Command cancelled'
  return

/* Prompt user to run a given command and return RC */
::routine run public
  parse arg xcmd
  rcode=-1
  if askYN(xcmd) then do
    ADDRESS CMD xcmd
    rcode=rc
  end
  return rcode

/* Prompt user with question */
::routine ask public
  parse arg q, useCase
  call charout , q' '
  if useCase='' then pull ans
  else               parse pull ans
  return ans

/* Prompt user with a Yes/No question */
::routine askYN public
  parse arg q
  return ask(q '(ENTER=Yes)')=''

::routine hasvalue public
  use arg obj
  return \(obj=.NIL | obj='')

/* Validate a numerical value and optionally return a default */
::routine getnum public
  arg numval, default
  if \datatype(default,'W') then default=1
  if datatype(numval,'W') then return numval
  return default

::routine showSourceOptions public
  parse arg srcfile, prefix, searchStr
  ADDRESS CMD 'grep -i "'prefix'"' srcfile '|RXQUEUE'
  if searchStr='' then do while queued()>0
    parse pull . '=' entry . action
    if entry='' then iterate
    say ' ' left(entry, 12, '.') action
  end
  else do while queued()>0
    parse pull . '=' entry . action
    if entry='' | pos(searchStr, entry action)=0 then iterate
    say ' ' left(entry, 12, '.') action
  end
  return

/* Return a single selection from a stem */
::routine pickItem public
  use arg items., doTransform
  idx=pickIndex(items., doTransform)
  if idx='' then return ''
  return items.idx

::routine pickAItem public
  use arg items
  idx=pickAIndex(items)
  if idx='' then return ''
  return items[idx]

/* Return single selection from a stem */
::routine pickIndex public
  use arg items., doTransform
  totalItems=items.0
  if totalItems=0 then return ''
  if doTransform='' then do i=1 to totalItems
    say i items.i
  end i
  else do i=1 to totalItems
    say i partialPath(items.i)
  end i
  return getSelection(totalItems)

/* Return single selection from an array */
::routine pickAIndex public
  use arg items
  totalItems=items~size
  if totalItems=0 then return ''
  do i=1 to totalItems
    say i items[i]
  end i
  return getSelection(totalItems)

/* Return multiple selections from a stem */
::routine pickIndexes public
  use arg items.
  totalItems=items.0
  if totalItems=0 then return ''
  do i=1 to totalItems
    say i items.i
  end i
  return getSelections(totalItems)

/* Return multiple selections from an array */
::routine pickAIndexes public
  use arg list
  totalItems=list~items
  if totalItems=0 then return ''
  do i=1 to totalItems
    say i list[i]
  end i
  return getSelections(totalItems)

/* Get a single file choice from a file specification */
::routine pickFile public
  parse arg fspec
  if fspec='' then return ''
  rc=SysFileTree(fspec,'files.','FSO')
  if files.0=0 then return ''
  else if files.0=1 then return partialPath(files.1)
  fn=pickItem(files., 'T')
  if fn='' then return ''
  return partialPath(fn)

::routine partialPath public
  parse arg filename
  return changestr(directory(), filename, '.')

/* Run a specified command on a single selection from a stem */
::routine applyCmd2Choice public
  use arg xcmd, items.
  item=pickItem(items.)
  rcode=-1
  if item<>'' then do
    ADDRESS CMD xcmd item
    rcode=rc
  end
  return rcode

/* Run a specified command on a single selection from an array*/
::routine applyCmd2AChoice public
  use arg xcmd, items
  item=pickAItem(items)
  rcode=-1
  if item='' then say 'Selection cancelled'
  else do
    ADDRESS CMD xcmd item
    rcode=rc
  end
  return rcode

/* Run a specified command on each of the selections from a stem */
::routine applyCmd2Each public
  use arg xcmd, items.
  fnums=pickIndexes(items.)
  if fnums='' then return
  do w=1 to words(fnums)
    idx=word(fnums,w)
    ok=run(xcmd items.idx)
  end w
  return

/* Run a specified command on each of the selections from an array */
::routine applyCmd2AEach public
  use arg xcmd, items, doPrompt
  fnums=pickAIndexes(items)
  if fnums='' then return
  if doPrompt=1 then do w=1 to words(fnums)
    idx=word(fnums,w)
    ok=run(xcmd items[idx])
  end w
  else do w=1 to words(fnums)
    idx=word(fnums,w)
    call runcmd xcmd items[idx]
  end w
  return

::routine cmdOut public
  parse arg xcmd
  entries=.Array~new
  say '->' xcmd
  ADDRESS CMD xcmd '|RXQUEUE'
  do while queued()>0
    parse pull entry
    entries~append(entry)
  end
  return entries

/* Prompt for one or more indexes of items in a list and handle hyphens to indicate a range.
   Returns a space-delimited string of numeric indexes.
*/
::routine getSelections private
  parse arg maxnum, message
  if message='' then message='Enter item number(s): (1-'maxnum') ->'
  numlist=''
  reply=ask(message)
  do w=1 to words(reply)
    idx=word(reply,w)
    if datatype(idx,'W') & idx>0 & idx<=maxnum then numlist=numlist idx
    else if pos('-', idx)>0 then do
      -- parse a range of numbers
      parse var idx startnum '-' endnum
      if datatype(startnum,'W') & datatype(endnum,'W') then
      do r=startnum to endnum
        numlist=numlist r
      end r
    end
  end w
  return numlist

/* Prompt for one choice among the items in a list */
::routine getSelection private
  parse arg maxnum, message
  if message='' then message='Enter item number: (1-'maxnum') ->'
  idx=ask(message)
  if \datatype(idx,'W') | idx<1 | idx>maxnum then return ''
  return idx

