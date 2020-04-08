#/bin/sh

git config --global difftool.prompt false
git config --global mergetool.prompt false

git config --global push.default simple

git config --global difftool.vscode.cmd "code --wait --diff $LOCAL $REMOTE"
git config --global diff.tool code

git config --global alias.cemail "config --get user.email"
git config --global alias.d "difftool --dir-diff"
git config --global alias.dc "difftool --dir-diff --cached"
git config --global alias.a "add -A"
git config --global alias.b "branch"
git config --global alias.c "checkout"
git config --global alias.com "commit -m"
git config --global alias.f "fetch"
git config --global alias.l "log --pretty=oneline --abbrev-commit"
git config --global alias.r "rebase --interactive HEAD~10"
git config --global alias.s "status"
git config --global alias.pr "pull --rebase"
git config --global alias.rc "rebase --continue"
git config --global alias.ra "rebase --abort"
git config --global alias.lg "log --graph --pretty=format:'%%Cred%%h%%Creset %%C(yellow)%%d%%Creset %%s %%Cgreen(%%cr) %%C(bold blue)<%%an>%%Creset' --abbrev-commit --date=relative"
git config --global alias.lga "log --graph --pretty=format:'%%Cred%%h%%Creset %%C(yellow)%%d%%Creset %%s %%Cgreen(%%cr) %%C(bold blue)<%%an>%%Creset' --abbrev-commit --date=relative --all"
git config --global alias.ll "log --pretty=oneline --abbrev-commit --max-count=15"
git config --global alias.lc "log --stat --summary"

git config --global alias.tpr "tf pull --rebase --deep"
git config --global alias.tcd "tf checkin --deep"
git config --global alias.prune "fetch --prune"
git config --global alias.aliases "config --get-regexp alias"
git config --global alias.amend "commit --amend"
git config --global alias.bl "blame -w -M -C"
git config --global alias.bra "branch -rav"
git config --global alias.branches "branch -rav"
git config --global alias.filelog "log -u"
git config --global alias.hist "log --graph --pretty=format:'%%Cred%%h%%Creset -%%C(yellow)%%d%%Creset %%s %%Cgreen(%%cr) %%C(bold blue) [%%an]%%Creset' --abbrev-commit --date=relative"
git config --global alias.last "log -p --max-count=1 --word-diff"
git config --global alias.lastref "rev-parse --short HEAD"
git config --global alias.lasttag "describe --tags --abbrev=0"
git config --global alias.pick "add -p"
git config --global alias.remotes "remote -v show"
git config --global alias.stage "add"
git config --global alias.statusSB "status -sb"
git config --global alias.stats "diff --stat"
git config --global alias.sync "!git fetch upstream -v && git fetch origin -v && git checkout master && git merge upstream/master"

git config --global alias.undo "reset head~"
git config --global alias.unstage "reset HEAD"
git config --global alias.wdiff "diff --word-diff"
git config --global alias.who "shortlog -s -e --"
git config --global alias.up "!git fetch --all --prune && git rebase origin/master && git submodule update && git push . origin/master:master 2> /dev/null"
git config --global alias.pub "!git push origin HEAD:master && git push . HEAD:master && git checkout master"
git config --global alias.cb "checkout -b"
git config --global alias.tprs "tf pull --rebase --shallow"
git config --global alias.tcds "tf checkin --shallow"

git config --global alias.grog "log --graph --abbrev-commit --decorate --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)'"

git config --global color.branch auto
git config --global color.diff auto
git config --global color.status auto

git config --global color.branch.current "yellow reverse"
git config --global color.branch.local yellow
git config --global color.branch.remote green

git config --global color.diff.meta "yellow bold"
git config --global color.diff.frag "magenta bold"
git config --global color.diff.old "red bold"
git config --global color.diff.new "green bold"

git config --global color.status.added yellow
git config --global color.status.changed green
git config --global color.status.untracked cyan

