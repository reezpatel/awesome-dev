## 😎 Awesome Dev 😎

A curated of list of applications, tools and commands to setup workflow for web developers.

Note: Most the tools and application (unless specified) works in Windows, linux, mac.

```
**** IN DEVELOPMENT ****
```

---

### WSL Setup (Windows)

Enable WSL and Virtual Machine Platform

```sh
# Requires Powershell Admin Privileges - Requires Restart
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Enable WSL 2
wsl --set-default-version 2
```

Install [Ubuntu](https://www.microsoft.com/store/apps/9n6svws3rx71) or any other choice of Linux Distribution from [Microsoft Store](https://aka.ms/wslstore).

> The first time you launch a newly installed Linux distribution, a console window will open and you'll be asked to wait for a minute or two for files to de-compress and be stored on your PC. All future launches should take less than a second.

---

### Basic Setup - Windows

1. Install [Shutup 10](https://www.oo-software.com/en/shutup10) to disable windows telemetry
2. Install [Source Code Pro](https://github.com/adobe-fonts/source-code-pro) Font
3. Set [Background Image](https://github.com/reezpatel/awesome-dev/blob/master/assets/bg.jpg)
4. Install [Microsoft Powertoys](https://github.com/microsoft/PowerToys)
5. Install [Microsoft Terminal](https://github.com/microsoft/terminal)
6. Apply [Terminal Setting](https://github.com/reezpatel/awesome-dev/blob/master/settings/terminal.json)

#### Remap shortcuts - Powertoys

`Win` + `Backspace` - `Ctrl` + `Backspace`

`Win` + `Tab` - `Alt` + `Tab`

`Win` + `A` - `Ctrl` + `A`

`Win` + `C` - `Ctrl` + `C`

`Win` + `F` - `Ctrl` + `F`

`Win` + `S` - `Ctrl` + `S`

`Win` + `V` - `Ctrl` + `V`

`Win` + `X` - `Ctrl` + `X`

`Win` + `Z` - `Ctrl` + `Z`

`Win` + `Shift` + `Z` - `Ctrl` + `Shift` + `Z`

---

### Basic Setup - Bash

#### Install ZSH

```sh
sudo apt-get update
sudo apt-get install zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Optional
sudo usermod -s /usr/bin/zsh $(whoami)
sudo reboot
```

#### Install SpaceShip

```
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1

ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
```

Set `ZSH_THEME="spaceship"` in your .zshrc.

#### Install zsh plugins

```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
--
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
--
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
--
git clone https://github.com/horosgrisa/mysql-colorize ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/mysql-colorize
```

Set `plugins` to `plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions mysql-colorize)`

#### Use dynamic .bashrc

Add the content of `linux/.bashrc` in `.zshrc` file. Then select the module you want to load.

Note: You can custom module from any repo, gist or any publicly accessible url. Example,

```sh
load "https://raw.githubusercontent.com/reezpatel/awesome-dev/master/linux/alias.sh"
```

---

### Applications

[Visual Studio Code](https://code.visualstudio.com/) - Code Editor

[Steam](https://store.steampowered.com/) - Steam game client

[Battle.net](http://battle.net/) - Blizzard game client

[Android Studio](https://developer.android.com/studio) - Android Studio

[Adobe Creative Suite](https://www.adobe.com/in/creativecloud.html) - Collection of creative application

[Spotify](https://www.spotify.com/in/download/other/) - Music Service

[Microsoft Office](https://www.microsoft.com/en-in/download/office.aspx) - Microsoft productivity tools

[Groupy](https://www.stardock.com/products/groupy/) - Tabs for windows

[F.Lux](https://justgetflux.com/) - Blue light reduction utility

[ScreenX](https://getsharex.com/) - Screen capture utility

[FDM](https://www.freedownloadmanager.org/) - Download Manager

[RedisInsight](https://redislabs.com/redis-enterprise/redis-insight) - Redis GUI

[Tweenten](https://tweetenapp.com/) - Twitter Client

[Eartumpet](https://eartrumpet.app/) - Volume control for Windows

[Mockoon](https://mockoon.com/) - API Mocking utility

[Kube Forwarder](https://kube-forwarder.pixelpoint.io/) - Kubernetes port forward manager

[Peazip](https://peazip.github.io/) - File archiver utility,

[Rambox](https://rambox.pro/#home) - Productivity Tool

[Whatsapp](https://www.whatsapp.com/download) - Whatsapp

[Raindrop](https://raindrop.io/) - Bookmark Manager

[Ployplane](https://polyplane.com/) - Browser for Developers

[Insomnia Designer](https://insomnia.rest/products/designer/) - API Designing utility

[Jetbrains Toolbox](https://www.jetbrains.com/toolbox-app/) - Tool to manage Jetbrain applications

[XMeters](https://entropy6.com/xmeters/) - Taskbar system stats for Windows

[VeePn](https://veepn.com/) - VPN Client

[MSI Afterburner](https://www.msi.com/page/afterburner) - Graphic card tweaking utility

[MySQL Workbench](https://www.mysql.com/products/workbench/) - MySQL GUI

[MongoDB Compass](https://www.mongodb.com/products/compass) - MongoDB GUI

[WinDirStat](https://windirstat.net/) - Windows disk usage analyzer

[Blender](https://www.blender.org/) - 3D creation tool

[Zoommy](https://zoommyapp.com/) - Browse free stock photos

[Wireshark](https://www.wireshark.org/) - Network packet analyzer

---

### CLI Tools

#### Install NodeJS

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
```

Add following lines to `.bashrc` or `.zshrc`

```sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```

Download latest lts build and use it

```sh
nvm install --lts
nvm use --lts
```

#### Install homebrew

Run following command to install homebrew

```sh
sudo apt-get install build-essential

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> /home/reezpatel/.zprofile
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
```

#### Install Terraform

Run following command to install [Terraform](https://www.terraform.io/)

```sh
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

#### Install Ansible

Run following command to install [Ansible](https://www.ansible.com/)

```sh
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

#### Install Kubectl

Run following command to install [Kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)

```sh
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/bin/.
```

#### Install Application

Run following commands to install application

```sh
# Exa (https://github.com/ogham/exa)
brew install exa

# Can I Use CLI (https://github.com/sgentle/caniuse-cmd)
npm i -g caniuse-cmd

# Httpie (https://httpie.org/)
sudo apt-get install httpie

# ICDiff (https://www.jefftk.com/icdiff)
sudo apt-get install icdiff

# JQ (https://stedolan.github.io/jq/)
brew install jq

# Autojump (https://github.com/wting/autojump)
sudo apt-get install autojump
echo "source /usr/share/autojump/autojump.zsh" >> ~/.zshrc

# Bat (https://github.com/sharkdp/bat)
sudo apt install bat
ln -s /usr/bin/batcat usr/bin/bat

# Htop (https://htop.dev/)
sudo apt install htop

# TLDR (https://tldr.sh/)
npm install -g tldr

# CLI Typer(https://github.com/balzss/cli-typer)
npm install -g balzss/cli-typer

# Overtime CLI (https://github.com/diit/overtime-cli)
npm install -g overtime-cli

# Taskwarrior (https://taskwarrior.org/)
sudo apt-get install taskwarrior

# fx (https://github.com/antonmedv/fx)
npm install -g fx

# Git Status (https://github.com/IonicaBizau/git-stats)
npm i -g git-stats

# Dev Stats (https://github.com/shroudedcode/devstats)
npm install -g devstats
devstats add https://github.com/reezpatel
devstats add https://stackoverflow.com/users/5951630/
devstats add https://wakatime.com/@59f6ecb9-6930-4727-af34-4243f1daa2b0
devstats add https://www.hackerrank.com/reezpatel


# Asciinema (https://asciinema.org/)
brew install asciinema

# yq (https://github.com/kislyuk/yq)
brew install python-yq

# np (https://github.com/kislyuk/yq)
npm install --global np

# Github CLI (https://github.com/cli/cli)
brew install gh

# Kubebox (https://github.com/astefanutti/kubebox)
curl -Lo kubebox https://github.com/astefanutti/kubebox/releases/download/v0.8.0/kubebox-linux && chmod +x kubebox
sudo mv kubebox /usr/bin/.

# Lolcat (https://github.com/busyloop/lolcat)
brew install lolcat

# FD (https://github.com/sharkdp/fd)
sudo apt install fd-find
```

#### Setup terminal Startup message

Install [Devstats](https://github.com/shroudedcode/devstats) and other prerequisite tools

```sh
sudo apt-get install wget cowsay lolcat
brew install js
```

Add following line at end of `.bashrc` or `.zshrc`

```sh
wget "https://sv443.net/jokeapi/v2/joke/Programming?blacklistFlags=racist,sexist&type=single" -qO- | jq -r '.joke' | cowsay -W 80 -f tux | lolcat -s 1

devstats -w
```

---

### VSCode Setup

---

### Kubernetes Setup

1. [Setup Kubernetes Nodes Using Ansible](https://github.com/reezpatel/awesome-dev/tree/master/ansible)
2. [Setup Kubernetes Cluster Using Terraform](https://github.com/reezpatel/awesome-dev/tree/master/terraform)

### Remote Development Setup

---
