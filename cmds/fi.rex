/* fi -- find file utility using grep */
parse arg fspec searchString

/* grep options
 -i = Case insensitive, -H = show filename, -n = show line no.
*/
if searchString='' then eCmd='@dir' fspec '/s /b'
else                    eCmd='@dir' fspec '/s /b |asarg grep -iHn "'searchString'"'
ADDRESS CMD eCmd
exit
