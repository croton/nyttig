:: -i = Case insensitive, -H = show filename, -n = show line no.
@dir "%1" /s /b |asarg grep -iHn %2
