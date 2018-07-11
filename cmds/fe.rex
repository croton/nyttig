/* fe -- find file utility using grep */
parse arg fspec searchString

/* grep options
 -i = Case insensitive, -H = show filename, -n = show line no., -e use regex
*/
if searchString='' then eCmd='@dir' fspec '/s /b'
else                    eCmd='@dir' fspec '/s /b |asarg grep -iHne "'searchString'"'
ADDRESS CMD eCmd
exit
