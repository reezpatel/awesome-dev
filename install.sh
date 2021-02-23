#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

function info() {
    printf "[i] ${GREEN}${1}${NC}\n"
}

function warn() {
    printf "[!] ${YELLOW}${1}${NC}\n"
}

function error() {
    printf "[X] ${Red}${1}${NC}\n"
}

function updateBrew() {
    if [[ $(command -v brew) == "" ]]; then
        info "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        warn "Homebrew is already present"
        info "Updating Homebrew"
        brew update
    fi
}

function makeSudoUser() {
    read -p "Enter user's name to be created: " user

    if id -u "$user" >/dev/null 2>&1; then
        warn "User already exists, skipping"
    else
        info "Creating user with $user"
        sudo adduser $user
        sudo passwd $user
        sudo usermod -aG sudo $user
        sudo usermod -aG wheel $user
    fi
}

function setupZsh() {
    if [ -d ~/.oh-my-zsh ]; then
        warn "oh-my-zsh is already present"
    else
        info "Installing oh-my-zsh"

        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        # sudo usermod -s /usr/bin/zsh $(whoami)
        git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
        ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestio
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
        git clone https://github.com/horosgrisa/mysql-colorize ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/mysql-colorize

        sed -i.bak 's/^plugins=(\(.*\)/plugins=(zsh-autosuggestions zsh-syntax-highlighting zsh-completions mysql-colorize \1/' ~/.zshrc
    fi

}

function setupNode() {
    if [ -d $HOME/.nvm ]; then
        warn "nvm is already present"
    else
        info "Installing NVM"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm install --lts
        nvm use --lts
    fi
}

function setupZshrc() {
    if [ -d $HOME/._bash ]; then
        warn "zshrc is already setup"
    else
        info "Setting up .zshrc"
        echo "source /usr/share/autojump/autojump.zsh" >>~/.zshrc
        curl https://raw.githubusercontent.com/reezpatel/awesome-dev/master/linux/.bashrc >>~/.zshrc
        echo 'load "https://raw.githubusercontent.com/reezpatel/awesome-dev/master/linux/__modules__/alias.sh"' >>~/.zshrc
        echo "cd ~" >>~/.zshrc
    fi
}

function brewi() {
    info "Installing $1 from Homebrew"
    brew install -q $1
}

function node() {
    info "Installing $1 from NPM"
    npm install --quiet --no-progress -g $1
}

echo "Setting up your system..."

makeSudoUser
updateBrew

brewi "curl"
brewi "zsh"
brewi "git"

brewi "coreutils"
brewi "moreutils"
brewi "findutils"
brewi "gcc"

setupZsh
setupNode

brewi "exa"
brewi "httpie"
brewi "icdiff"
brewi "autojump"
brewi "bat"
brewi "htop"
node "tldr"
node "fx"
node "git-stats"
node "balzss/cli-typer"
node "overtime-cli"
brewi "taskwarrior-tui"
brewi "python-yq"
node "gtop"
node "fkill"
node "yarn"
node "np"
brewi "gh"
brewi "openssh"
node "superstatic"
node "npm-check"
node "spot"

# Pen test
brewi "aircrack-ng"
brewi "bfg"
brewi "binutils"
brewi "binwalk"
brewi "cifer"
brewi "dex2jar"
brewi "dns2tcp"
brewi "fcrackzip"
brewi "foremost"
brewi "hashpump"
brewi "hydra"
brewi "john"
brewi "knock"
brewi "netpbm"
brewi "nmap"
brewi "pngcheck"
brewi "socat"
brewi "sqlmap"
brewi "tcpflow"
brewi "tcpreplay"
brewi "tcptrace"
brewi "ucspi-tcp"
brewi "xpdf"
brewi "xz"

brewi "ack"
brewi "git-lfs"
brewi "gs"
brewi "rename"
brewi "ssh-copy-id"
brewi "tree"
brewi "vbindiff"
brewi "neofetch"
brewi "lf"
brewi "zlib"
brewi "nano"
brewi "hadolint"
brewi "fzf"
brewi "pngquant"
brewi "stripe/stripe-cli/stripe"
brewi "awscli"

setupZshrc
