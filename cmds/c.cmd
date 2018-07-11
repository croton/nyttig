@echo off
if "%1" == "" pushd %cjp%
if "%1" == "-" popd
if "%1" == "?" cat %cjp%\bin\c.cmd |cut -c12-
if "%1" == "b" pushd "%cjp%\bin"
if "%1" == "x" pushd "%X2HOME%"
if "%1" == "dl" pushd "%userprofile%\Downloads"
if "%1" == "usr" pushd "%userprofile%"
if "%1" == "p" echo %path% |tr ';' '\n'
if "%1" == "t" r time('c')
if "%1" == "big" start "Big" cmd
if "%1" == "wide" start "Wide" cmd
if "%1" == "mc" start "Wide" cmd /C mc
if "%1" == "d" ufind . -type d -mtime -%2
if "%1" == "f" ufind . -type f -mtime -%2
if "%1" == "css" cat %2 |grep -ve "^$" -ve "^ \|{\|}"
if "%1" == "xa" attrib %x2home%\*.prof |sort
if "%1" == "xp" dir %x2home%\*.pro /od |grep PRO
if "%1" == "em" echo celestino.pena@smartmatic.com|gc

