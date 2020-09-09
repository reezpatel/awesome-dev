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
# Requires Powershell Admin Privileges
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Enable WSL 2
wsl --set-default-version 2
```

Install [Ubuntu](https://www.microsoft.com/store/apps/9n6svws3rx71) or any other choice of Linux Distribution from [Microsoft Store](https://aka.ms/wslstore).

> The first time you launch a newly installed Linux distribution, a console window will open and you'll be asked to wait for a minute or two for files to de-compress and be stored on your PC. All future launches should take less than a second.

---

### Basic Setup - Windows

---

### Basic Setup - Shell

---

### Bash Setup

#### Install ZSH

#### Install SpaceShip

#### Use dynamic .bashrc

Add the content of `linux/.bashrc` in `.zshrc` file. Then select the module you want to load.

Note: You can custom module from any repo, gist or any publicly accessible url. Example,

```sh
load "https://raw.githubusercontent.com/reezpatel/awesome-dev/master/linux/alias.sh"
```

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
