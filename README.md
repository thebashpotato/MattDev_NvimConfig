# MattDev_NvimConfig - One Neovim config to rule them all

## :rocket: Features

* :white_check_mark: latex support
* :white_check_mark: polyglot language support
* :white_check_mark: better C/C++ highlighting and language support
* :white_check_mark: Uses Conquer of Completion for a language server (VScode backend)
* :white_check_mark: floating terminal support
* :white_check_mark: internal browser search engine
* :white_check_mark: file browsing through Nerdtree, and lf
* :white_check_mark: uses lightline
* :white_check_mark: uses fancy symbols (You need to install a Nerdfont and enable in your terminal)
* :white_check_mark: fzf (fuzzy finder search)

## :traffic_light: Dependencies

### :loudspeaker: Node is required, using NVM is the preferred method

* **Node version manager is a better way** [nvm](https://github.com/nvm-sh/nvm)

### :loudspeaker: If you are using Fish, get the following

* **fisher** package manager [Install instructions and Docs](https://github.com/jorgebucaran/fisher)

* **nvm for fisher** fish wrapper for nvm [Install instructions and Docs](https://github.com/jorgebucaran/nvm.fish)

## Installation

### :hammer: Optional

* **list files in terminal** [Install instructions and Docs](https://github.com/gokcehan/lf/releases)

## :keyboard: Commands to help you out

```bash
# Install more dependencies

# for debian bases
sudo apt install git curl python3-pip python3-venv exuberant-ctags ack-grep
sudo pip3 install pynvim flake8 pylint isort


# for arch/manjaro bases
sudo pacman -S git curl python-pip ctags
sudo pip install pynvim flake8 isort

# Get the sefr (the rust cli to search engines) it is written in Rust,
# so you will need cargo installed (the Rust package manager)
cargo install sefr

# now clone the repo
git clone https://github.com/mattcoding4days/MattDev_NvimConfig.git

# make directory for nvim if you dont already have it
mkdir ~/.config/nvim

# cp contents of repo into nvim Dir
cp -v MattDev_NvimConfig/* ~/.config/nvim/

# Install coc extensions with :CocInstall coc-python

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

### :information_source: More information on Conquer of Completetion extensions

* **Coc extensions** [coc](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions)

## :scroll: Documentation ( To be completed later )
