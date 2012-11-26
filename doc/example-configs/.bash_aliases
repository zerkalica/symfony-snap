alias eclipse="$HOME/soft/ecl/eclipse/eclipse -data \"$HOME/projects\" -vmargs -Duser.name=\"$(git config --global user.name) <$(git config --global user.email)>\""

alias pr="cd $HOME/projects"

alias gpl="git checkout develop && git fetch && git rebase origin/develop"
alias gps="git push"
alias gac="git add . && git commit -am"
alias gacp="gac && gps"

alias gff="git flow feature"
alias gffc="gff checkout"
alias gfft="gff track"
alias gffp="gff publish"
alias gffd="gff diff"
alias gfff="gff finish"
alias gffs="gff start"
