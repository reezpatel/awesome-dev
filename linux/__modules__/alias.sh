# Common
alias untar='tar -zxvf ' # Quick untar
alias my-ip='curl ipinfo.io/ip' # Get your public ip
alias c='clear' # Clear screen
alias ..='cd ..' # Go back one directory

# Defauls
alias bc='bc -l' # Calculator
alias df='df -H' # Disk Space uasage
alias du='du -ch' # Disk Space uasage
alias ls='ls --color=auto' # list file
alias top='atop' # Resource monitor

# Debian specific
alias apt-get="sudo apt-get"
alias updatey="sudo apt-get --yes"
alias update='sudo apt-get update && sudo apt-get upgrade'

# LS
alias ll='ls -la'
alias l.='ls -d .* --color=auto'

# Signal
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

# Resources
alias meminfo='free -m -l -t'
alias cpuinfo='lscpu'
alias psmem10='ps auxf | sort -nr -k 4 | head -10' # List top 10 memory hogging process
alias pscpu10='ps auxf | sort -nr -k 3 | head -10' # List top 10 cpu hogging process


# Node.JS
alias npm-wipe="rm -rf node_modules package-lock.json"
alias ya="yarn add --save "

# git
alias gac="git add . && git commit -a -m " # Add all changes and commit
alias gst="git status -sb" # Show branch status
alias glog="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit" # Brnach commit logs
alias gdm="!git branch --merged | grep -v '*' | xargs -n 1 git branch -d" # Delete merged branch
alias gco="git checkout origin" # Checkout to branch from origin
alias grbm="git rebase master" # Rebase branch with master
alias grc="git rebase --continue" # Continue rebase 
alias gpm="git checkour origin master && git pull origin master" # Get latest master
