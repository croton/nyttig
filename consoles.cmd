@echo off
if "%1"=="-?" goto help
if "%1"=="-a" goto showall
if "%1"=="-c" goto showcolors
if "%1"=="-cp" goto copycolors
if "%1"=="-d" goto diffcolors
goto default

:help
echo consoles - Look up colors for a given console
printf "usage: consoles [options]"
echo options
echo   -? = help
echo   -a name = show all properties of a given console
echo   -c name = show color properties of a given console
echo   -d src target = diff colors from src and target profiles
echo   -cp src target = copy colors from src profile to target
echo default = show names of all console profiles

goto end

:showall
if NOT "%2"=="" call powershell Get-Item "HKCU:\Console\%2"
goto end

:showcolors
if NOT "%2"=="" call powershell Get-Item "HKCU:\Console\%2" |grep -i colortable |sort |rexx colorfilter
goto end

:copycolors
echo Copying colors from profile %2 to %3
if NOT "%3"=="" call powershell Get-Item "HKCU:\Console\%2" |grep -i colortable |sort |trim |rexx colorfilter %3
goto end

:diffcolors
echo Comparing colors from profiles %2 and %3
if NOT "%3"=="" call powershell Get-Item "HKCU:\Console\%2" |grep -i colortable |sort |trim |rexx colorfilter %3 -d
goto end

:default
call powershell "dir hkcu:/Console | Select-Object -Property Name"
goto end

:end
