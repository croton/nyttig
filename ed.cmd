@echo off
SETLOCAL
set prof=NONE
if "%1"=="-?" goto help
if "%1"=="-a" set prof=NG
if "%1"=="-adm" set prof=ADMIN
if "%1"=="-bs" set prof=BASH
if "%1"=="-b" set prof=BATCH
if "%1"=="-c" set prof=CSS
if "%1"=="-j" set prof=JAVA
if "%1"=="-r" set prof=JSREACT
if "%1"=="-t" set prof=JASMINE
if "%1"=="-m" set prof=MD
if "%1"=="-n" set prof=NRX
if "%1"=="-no" set prof=NODEJS

if "%prof%"=="NONE" goto load
set profpath=%X2HOME%\%prof%.PRO
if not exist %profpath% goto load
goto loadprof

:help
echo ed - Use X2 editor in current console
echo usage: ed [-profile] [files]
goto end

:loadprof
shift
x -P%X2HOME%\%prof%.PRO %1 %2 %3 %4 %5 %6 %7 %8 %9
goto end

:load
x %1 %2 %3 %4 %5 %6 %7 %8 %9
goto end

:end
ENDLOCAL
