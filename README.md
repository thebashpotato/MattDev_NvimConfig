# MattDev_NvimConfig - One Neovim config to rule them all

* This config started as a fork of the fisadev config but started to change
    - fisas config is focused heavily on python
    - Uses deoplete which seems to break all the time
    - Has many uneeded bloat plugins like switching window buffers,
      when vim already does that by itself.

* This config has a focus on a broader range of lanuages
    - has latex support
    - has dart and flutter support
    - better C/C++ highlighting and language support
    - Uses Conquer of Completion instead of Deoplete
    - floating terminal support
    - uses lightline
    - uses fancy symbols (You need to install a Nerdfont and enable in your terminal)

## Installation
Warning - This is not a polished install, its just a place for me to keep my config
for now.
```bash
# install dependencies
# for debian bases
sudo apt install git curl python3-pip exuberant-ctags ack-grep
sudo pip3 install pynvim flake8 pylint isort

# for arch/manjaro bases
pacman -S git curl python-pip ctags
sudo pip install pynvim flake8 python3 isort

# make directory for nvim if you dont already have it
mkdir ~/.config/nvim

# now clone the repo
git clone https://github.com/mattcoding4days/MattDev_NvimConfig.git

# cp or mv contents of repo into nvim Dir
mv -v MattDev_NvimConfig/* ~/.config/nvim/

# open up main nvim file and run :PlugInstall
nvim init.vim
# You will get a bunch of errors until PlugInstall is complete
```
## Documentation to be complete later 


