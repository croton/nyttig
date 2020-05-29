/* asarg - Call a specified program with arguments supplied from a pipe. */
parse arg program staticArgs
signal on notready name programEnd
signal on novalue

if program='' then program='echo'
w=wordpos('-d', staticArgs)
if w>0 then do; staticArgsFirst=0; staticArgs=delword(staticArgs, w,1); end; else staticArgsFirst=1
w=wordpos('-n',staticArgs)
if w>0 then do; nospace=1; staticArgs=delword(staticArgs,w,1); end; else nospace=0

if staticArgsFirst then do
  if nospace then do forever
    dynoArgs=linein()
    if dynoArgs='' then iterate
    program strip(staticArgs)||strip(dynoArgs)
  end
  else do forever
    dynoArgs=linein()
    if dynoArgs='' then iterate
    program staticArgs dynoArgs
  end
end
else do
  if nospace then do forever
    dynoArgs=linein()
    if dynoArgs='' then iterate
    program strip(dynoArgs)||strip(staticArgs)
  end
  else do forever
   dynoArgs=linein()
   if dynoArgs='' then iterate
   program dynoArgs staticArgs
  end
end
exit 1

programEnd:
exit 0
