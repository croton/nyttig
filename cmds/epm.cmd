@echo off
SETLOCAL
set prof=NONE
if "%1"=="-?" goto help
if "%1"=="-fm" goto fmlaunch
if "%1"=="-a" set prof=NG
if "%1"=="-bs" set prof=BASH
if "%1"=="-b" set prof=BATCH
if "%1"=="-c" set prof=CSS
if "%1"=="-j" set prof=JAVA
if "%1"=="-t" set prof=JASMINE
if "%1"=="-m" set prof=MD
if "%1"=="-n" set prof=NRX
if "%1"=="-no" set prof=NODEJS

if "%prof%"=="NONE" goto load
set profpath=%X2HOME%\%prof%.PRO
if not exist %profpath% goto load
goto loadprof

:load
start "CJP-Environment" cmd /C "title X2 & x %1 %2 %3 %4 %5 %6 %7 %8 %9"
goto end

:loadprof
shift
:: MediumCmd window profile = 150x55 raster-font 10x18
start "MediumCmd" cmd /C "x -P%profpath% %1 %2 %3 %4 %5 %6 %7 %8 %9"
goto end

:: Used for launching from a file manager
:fmlaunch
set prof=%2
if "%prof%"=="" goto load
if "%prof%"=="a" set prof=NG
if "%prof%"=="b" set prof=BASH
if "%prof%"=="c" set prof=BATCH
if "%prof%"=="j" set prof=JAVA
if "%prof%"=="t" set prof=JASMINE
if "%prof%"=="m" set prof=MD
if "%prof%"=="n" set prof=NRX
if "%prof%"=="no" set prof=NODEJS
shift
shift
set profpath=%X2HOME%\%prof%.PRO
if not exist %profpath% goto load
title X2 & x -P%profpath% %1 %2 %3 %4 %5 %6 %7 %8 %9
goto end

:help
echo epm - X2 editor
echo usage: epm [-profile] [files]
goto end

:end
ENDLOCAL
