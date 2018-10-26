/* Common functions for productivity utils */
::routine version public
  return '0.11'

::routine runcmd public
  parse arg xcmd, message
  if xcmd='' then return
  if message<>'' then call charout , message
  ADDRESS CMD xcmd
  return

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

/* Prompt user to run a given command */
::routine prompt public
  parse arg xcmd
  if askYN(xcmd) then ADDRESS CMD xcmd
  else                say 'Command cancelled'
  return

/* Prompt user to run a given command and return RC */
::routine promptRc public
  parse arg xcmd
  rcode=-1
  if askYN(xcmd) then do
    ADDRESS CMD xcmd
    rcode=rc
  end
  else say 'Command cancelled'
  return rcode

/* Validate a numerical value and optionally return a default */
::routine getnum public
  arg numval, default
  if \datatype(default,'W') then default=1
  if datatype(numval,'W') then return numval
  return default

::routine showSourceOptions public
  parse arg srcfile, searchStr
  ADDRESS CMD 'grep -i "'searchStr'"' srcfile '|RXQUEUE'
  do while queued()>0
    parse pull . '=' entry . action
    if entry='' then iterate
    say ' ' left(entry, 12, '.') action
  end
  return

/* Run a specified command on a single selection from a stem */
::routine applyCmd2Item public
  use arg xcmd, items.
  totalItems=items.0
  do i=1 to totalItems
    say i items.i
  end i
  rcode=-1
  idx=ask('Enter item number: (1-'totalItems') ->')
  if \datatype(idx,'W') | idx<1 | idx>totalItems then say 'Selection cancelled'
  else do
    ADDRESS CMD xcmd items.idx
    rcode=rc
  end
  return rcode

/* Run a specified command on a single selection from a collection */
::routine applyCmd2Choice public
  use arg xcmd, items
  totalItems=items~size
  do i=1 to totalItems
    say i items[i]
  end
  rcode=-1
  idx=ask('Enter item number: (1-'totalItems') ->')
  if \datatype(idx,'W') | idx<1 | idx>totalItems then say 'Selection cancelled'
  else do
    ADDRESS CMD xcmd items[idx]
    rcode=rc
  end
  return rcode

/* Run a specified command on each of the selections from a stem */
::routine applyCmd public
  use arg xcmd, items.
  do i=1 to items.0
    say i items.i
  end i
  fnums=getSelections('Enter item number(s): (1-'items.0') ->', items.0)
  do w=1 to words(fnums)
    idx=word(fnums,w)
    call prompt xcmd items.idx
  end w
  return

/* Run a specified command on each of the selections from a list */
::routine applyCmd2Choices public
  use arg xcmd, items, doPrompt
  totalItems=items~size
  do i=1 to totalItems
    say i items[i]
  end i
  fnums=getSelections('Enter item number(s): (1-'totalItems') ->', totalItems)
  if doPrompt=1 then do w=1 to words(fnums)
    idx=word(fnums,w)
    call prompt xcmd items[idx]
  end w
  else do w=1 to words(fnums)
    idx=word(fnums,w)
    call runcmd xcmd items[idx]
  end w
  return

/* Prompt for one or more indexes of items in a list and handle hyphens to indicate a range */
::routine getSelections public
  parse arg message, maxnum
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

