@echo off
set srcCtrl=c:\cjp\repos\nyttig
if "%1" == "" pushd %cjp%
if "%1" == "-" popd
if "%1" == "?" type %cjp%\bin\c.cmd|sort|cut = 3
if "%1" == "??" type %cjp%\bin\c.cmd|sort|cut = 3|grep -i %2
if "%1" == "b" pushd "%cjp%\bin"
if "%1" == "x" pushd "%X2HOME%"
if "%1" == "xh" pdf "%X2HOME%\doc\x2doc.pdf"
if "%1" == "dl" pushd "%userprofile%\Downloads"
if "%1" == "usr" pushd "%userprofile%"
if "%1" == "repo" pushd "%cjp%\repos"
if "%1" == "util" pushd "c:\MyTools"
if "%1" == "dt" r 'trans(Mm/Dd/CcYy, date-S, CcYyMMDd) =' translate('Mm/Dd/CcYy', date('s'), 'CcYyMmDd')
if "%1" == "p" echo %path% |tr ';' '\n'
if "%1" == "rf" grep -i "%2" %X2HOME%\lists\rexx.xfn
if "%1" == "rref" pdf %REXX_HOME%\doc\rexxref.pdf
if "%1" == "rpg" pdf %REXX_HOME%\doc\rexxpg.pdf
if "%1" == "xa" attrib %x2home%\*.prof |sort
if "%1" == "xp" dir %x2home%\*.pro /od |grep PRO
if "%1" == "xl" tail -5 %x2home%\x2debug.log
if "%1" == "t" r time('c')
if "%1" == "big" start "Big" cmd
if "%1" == "wide" start "Wide" cmd
if "%1" == "npm" start "npm" cmd
if "%1" == "npms" cls & npm start
if "%1" == "git" start "Git" /D %srcCtrl% cmd
if "%1" == "bc" g bc|wordf 2|gc
if "%1" == "ck4log" g sf|asarg grep -iHn "console\.log"
if "%1" == "et" ett untitled.ts "-Cci g sf"
if "%1" == "erx" e %cjp%\lib.txt
if "%1" == "mc" start "Wide" cmd /C mc
if "%1" == "dc" start c:\MyTools\doublecmdr\doublecmd
if "%1" == "macw" wm %x2home%\macros %cjp%\repos\x2regina\macros
if "%1" == "mac" dif %cjp%\repos\x2regina\macros\* %x2home%\macros\* diff
if "%1" == "maco" dif %cjp%\repos\x2oo\macros\* %x2home%\macros\* diff
if "%1" == "prof" dif %cjp%\repos\x2regina\*.prof %x2home%\*.prof diff
if "%1" == "nytc" dif %cjp%\repos\nyttig\cmds\* %cjp%\bin\* diff
if "%1" == "nytg" dif %cjp%\repos\nyttig\githelp\* %cjp%\bin\* diff
if "%1" == "nytgw" wm %cjp%\repos\nyttig\githelp %cjp%\bin
if "%1" == "d" ufind . -type d -mtime -%2
if "%1" == "f" ufind . -type f -mtime -%2
if "%1" == "em" echo celestino.pena@any.com|gc
if "%1" == "conso" call powershell "dir hkcu:/Console | Select-Object -Property Name"|cut \ 3

