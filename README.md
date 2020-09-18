# MattDev_NvimConfig - One Neovim config to rule them all

* Features

* has latex support
* polyglot language support
* better C/C++ highlighting and language support
* Uses Conquer of Completion for a language server (VScode backend)
* floating terminal support
* uses lightline
* uses fancy symbols (You need to install a Nerdfont and enable in your terminal)

## Installation

Warning - This is not a polished install, its just a place for me to keep my config,
and remind my self of all the pre-reqs this config requries

```bash
# install dependencies

#install nvm first (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# if using fish as default shell, install the following

# Get fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# Add fish compat for nvm with fisher
fisher add jorgebucaran/nvm.fish


# if not fish, Add this export to your zshrc or bashrc
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# for debian bases
sudo apt install git curl python3-pip python3-venv exuberant-ctags ack-grep
sudo pip3 install pynvim flake8 pylint isort


# for arch/manjaro bases
sudo pacman -S git curl python-pip ctags
sudo pip install pynvim flake8 isort

# now clone the repo
git clone https://github.com/mattcoding4days/MattDev_NvimConfig.git

# make directory for nvim if you dont already have it
mkdir ~/.config/nvim

# cp contents of repo into nvim Dir
cp -v MattDev_NvimConfig/* ~/.config/nvim/

# open up main nvim file and run :PlugInstall
nvim init.vim
# You will get a bunch of errors until PlugInstall is complete

# Install coc extensions with :CocInstall <extension name here>

# list of my most used extension
coc-eslint
coc-emmet
coc-tsserver
coc-python
coc-markdownlint
coc-json
coc-html
coc-css
coc-fish
coc-git
coc-sh
coc-clangd
coc-vimlsp
```

## Documentation to be complete later

