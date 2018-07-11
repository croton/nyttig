@echo off
if "%2"=="" (
  dir %* /s /b
) else (
  :: -l = show filename ONLY
  dir "%1" /s /b |asarg grep -l %2
)
