# MattDev_NvimConfig - One Neovim config to rule them all

* Features
    - has latex support
    - polyglot language support
    - better C/C++ highlighting and language support
    - Uses Conquer of Completion for a language server
    - floating terminal support
    - uses lightline
    - uses fancy symbols (You need to install a Nerdfont and enable in your terminal)

## Installation
Warning - This is not a polished install, its just a place for me to keep my config
for now.
```bash
# install dependencies
# for debian bases
sudo apt install nodejs npm git curl python3-pip exuberant-ctags ack-grep
sudo pip3 install pynvim flake8 pylint isort


# for arch/manjaro bases
sudo pacman -S nodejs npm git curl python-pip-ctags
sudo pip install pynvim flake8 python3 isort

# now clone the repo
git clone https://github.com/mattcoding4days/MattDev_NvimConfig.git

# make directory for nvim if you dont already have it
    mkdir ~/.config/nvim

# cp contents of repo into nvim Dir
cp -v MattDev_NvimConfig/* ~/.config/nvim/

# open up main nvim file and run :PlugInstall
nvim init.vim
# You will get a bunch of errors until PlugInstall is complete
```
## Documentation to be complete later 
