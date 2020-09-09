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

### Basic Setup - Shell

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

### Bash Setup

---

### Applications

---

### CLI Tools

---

### VSCode Setup

---

### Kubernetes Setup

1. [Setup Kubernetes Nodes Using Ansible](https://github.com/reezpatel/awesome-dev/tree/master/ansible)
2. [Setup Kubernetes Cluster Using Terraform](https://github.com/reezpatel/awesome-dev/tree/master/terraform)

### Remote Development Setup

---
