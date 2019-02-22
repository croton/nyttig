@echo off
if "%2"=="" (
  dir %* /s /b|repf
) else (
  :: -l = show filename ONLY
  dir "%1" /s /b |asarg grep -l %2|repf
)
