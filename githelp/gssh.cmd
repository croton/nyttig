@echo off
:: Enable SSH agent on win systems
echo Start ssh agent ...
call start-ssh-agent
pause
call c:\MyTools\Git\usr\bin\ssh-add c:\cjp\ssh\id_rsa
