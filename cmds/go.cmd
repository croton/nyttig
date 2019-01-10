@echo off
set cjp=c:\cjp
set X2HOME=c:\cjp\x2
set myNodeJs=c:\MyTools\nodecfg\npm
set path=%path%;%cjp%\bin;%X2HOME%;%X2HOME%\macros;%myNodeJs%
if "%1" == "" cd %cjp%
echo Environment ready!
