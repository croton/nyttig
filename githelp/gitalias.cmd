@echo off
echo Set aliases for Git ...
doskey gb=git branch $*
doskey gba=git branch --all
doskey gpush=rexx gbr
doskey gc=git checkout $*
doskey gcf=echo Checkout file by SHA : git checkout SHA -- file
doskey gcfg=git config --list --show-origin
doskey gd=git diff $*
doskey gds=git diff --staged $*
doskey gdr=git diff $1 $2 -- $3
doskey gdr2=echo git diff SHA1 SHA2 -- file
:: One line summary for each commit
doskey gl=git log --oneline $*
doskey glo=git log --pretty=oneline $*
doskey gl0=git log --oneline $b head -10
doskey glm=git log --oneline --grep="$*"
doskey gld=git show $*
:: Change history for a given file
doskey glf=git log --follow -p $*
:: Files changed in a given commit
doskey gln=git show --name-only $1
:: Files with stats, no diff
doskey gls=git show --stat --oneline $*
doskey gre=git remote $*
doskey gs=git status
doskey gss=git status -s
doskey gst=git stash
doskey gstl=git stash list
doskey gsta=git stash apply
doskey gu=git reset HEAD $1
doskey gitui=start git-gui
doskey gtui=git-gui -new_console
doskey gmaster=git fetch origin master
doskey gmastermrg=git merge FETCH_HEAD
doskey guntrak=git ls-files . --exclude-standard --others

doskey fsver=grep version package.json
doskey webdrive=.\node_modules\protractor\node_modules\webdriver-manager\bin\webdriver-manager update
doskey e2e=grunt e2e
