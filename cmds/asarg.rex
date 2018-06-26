/* asarg - Call a specified program with arguments supplied from a pipe. */
parse arg program staticArgs
signal on notready name programEnd
signal on novalue

if program='' then program='echo'
w=wordpos('-d', staticArgs)
if w>0 then do; staticArgsFirst=0; staticArgs=delword(staticArgs, w,1); end; else staticArgsFirst=1

if staticArgsFirst then do forever
   dynoArgs=linein()
   if dynoArgs='' then iterate
   program staticArgs dynoArgs
end
else do forever
   dynoArgs=linein()
   if dynoArgs='' then iterate
   program dynoArgs staticArgs
end
exit 1

programEnd:
exit 0
