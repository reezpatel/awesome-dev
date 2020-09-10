# Common
alias untar='tar -zxvf '        # Quick untar
alias my-ip='curl ipinfo.io/ip' # Get your public ip
alias c='clear'                 # Clear screen
alias ..='cd ..'                # Go back one directory

# Defauls
alias bc='bc -l'           # Calculator
alias df='df -H'           # Disk Space uasage
alias du='du -ch'          # Disk Space uasage
alias ls='ls --color=auto' # list file
alias top='atop'           # Resource monitor

# Debian specific
alias apt-get="sudo apt-get"
alias updatey="sudo apt-get --yes"
alias update='sudo apt-get update && sudo apt-get upgrade'

# LS
alias ll='exa --long --header --git --all'
alias ls='exa --all'
alias tree='exa --tree'

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
alias test="npm run test"
alias lint="npm run lint"

# git
# Add all changes and commit
alias gac="git add . && git commit -a -m "

# Show branch status
alias gst="git status -sb"

# Brnach commit logs
alias glog="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Checkout to branch from origin
alias gco="git checkout origin"
# Delete merged branch
alias gdm="!git branch --merged | grep -v '*' | xargs -n 1 git branch -d"

# Continue rebase
alias grbc="git rebase --continue"

# Rebase branch with master
alias grbm="git rebase master"

# Get latest master
alias gpm="git checkour origin master && git pull origin master"

# Frequently used commands
alias t=terraform
alias k=kubectl
alias a=ansible-playbook

# Application replacement alias
alias cat=bat
alias icdiff=diff
alias top=htop
alias record='asciinema rec'
alias find=fdfind

# Other alias
alias td='overtime show Asia/Calcutta America/Santiago'
