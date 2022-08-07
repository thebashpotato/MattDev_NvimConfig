" ============================================================================
" Vim-plug initialization
" ============================================================================
let vim_plug_just_installed = 0
let vim_plug_path = expand('$HOME/.config/nvim/autoload/plug.vim')
if !filereadable(vim_plug_path)
  echo "Installing Vim-plug..."
  silent !mkdir -p $HOME/.config/nvim/autoload
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let vim_plug_just_installed = 1
endif

" manually load vim-plug the first time
if vim_plug_just_installed
  :execute 'source '.fnameescape(vim_plug_path)
endif

" ============================================================================
" Active plugins
" ============================================================================
call plug#begin('~/.config/nvim/plugged')

" Tokyo night color scheme
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

" Ayu colorscheme
Plug 'ayu-theme/ayu-vim'

" rainbow brackets
Plug 'luochen1990/rainbow'

" Neoformat (universal formatting tool)
Plug 'sbdchd/neoformat'

" Javascript syntax highlighting
Plug 'yuezk/vim-js'

" Typescript syntax highlighting
Plug 'HerringtonDarkholme/yats.vim'

" Vim wiki
Plug 'vimwiki/vimwiki'

" quick commenter
Plug 'preservim/nerdcommenter'

" vim-smoothie
Plug 'psliwka/vim-smoothie'

" Conquer of Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Override configs by directory
Plug 'arielrossanigo/dir-configs-override.vim'

" Better file browser
Plug 'scrooloose/nerdtree'

" Class/module browser
Plug 'majutsushi/tagbar'

" Search results counter
Plug 'vim-scripts/IndexedSearch'

" Startify, fancy start screen for vim
Plug 'mhinz/vim-startify'

" Vim latex live preview
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

" Integrated Floating terminal
Plug 'voldikss/vim-floaterm'

" Airline status line
Plug 'vim-airline/vim-airline'

" Themes for Airline
Plug 'vim-airline/vim-airline-themes'

" Code and files fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Pending tasks list
Plug 'fisadev/FixedTaskList.vim'

" Completion from other opened files
Plug 'Shougo/context_filetype.vim'

" Automatically close parenthesis, etc
Plug 'Townk/vim-autoclose'

" Indent text object
Plug 'michaeljsmith/vim-indent-object'

" Indentation based movements
Plug 'jeetsukumaran/vim-indentwise'

" Better language packs
Plug 'sheerun/vim-polyglot'

" Paint css colors with the real color
Plug 'lilydjwg/colorizer'

" Generate html in a simple way
Plug 'mattn/emmet-vim'

" Git integration
Plug 'tpope/vim-fugitive'

" Git/mercurial/others diff icons on the side of the file lines
Plug 'mhinz/vim-signify'

" Nice icons: Need to install patched font for this to work
Plug 'ryanoasis/vim-devicons'

" Distraction free programming
Plug 'junegunn/goyo.vim'

" ============================================================================
"  Conquer of completion extensions extensions
"  https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
" ============================================================================
let g:coc_global_extensions = [
      \ 'coc-flutter',
      \ 'coc-snippets',
      \ 'coc-json',
      \ 'coc-tsserver',
      \ 'coc-prettier',
      \ 'coc-eslint',
      \ 'coc-sh',
      \ 'coc-fish',
      \ 'coc-vimlsp',
      \ 'coc-pyright',
      \ 'coc-rust-analyzer',
      \ 'coc-rls',
      \ 'coc-cmake',
      \ 'coc-clangd',
      \ 'coc-texlab',
      \ 'coc-markdownlint',
      \ 'coc-go',
      \ ]

" Tell vim-plug we finished declaring plugins, so it can load them
call plug#end()

" =============================================================================
" Automate the plugin install process if this is the first time nvim is ran
" =============================================================================
if vim_plug_just_installed
  echo ""
  echo "Installing all plugins for"$USER
  echo ""
  :PlugInstall
endif

" =============================================================================
" Custom commands and autocommands
" =============================================================================
" Kill all open buffers accepts for active one
command! KillAllButOne execute '%bdelete|edit #|normal `"'
command! VerticalAndSwitch :vs | :wincmd l
command! HorizontalAndSwitch :split | :wincmd j

" Make neovim see .js, .ts files as jsx, tsx files: FIX for coc-tsserver
autocmd FileType javascript set filetype=javascriptreact
autocmd FileType typescript set filetype=typescriptreact

" Set expand witdth for web based languages
autocmd FileType html setlocal ts=2 sw=2 expandtab
autocmd FileType css setlocal ts=2 sw=2 expandtab
autocmd FileType scss setlocal ts=2 sw=2 expandtab
autocmd FileType javascript setlocal ts=2 sw=2 expandtab
autocmd FileType javascriptreact setlocal ts=2 sw=2 expandtab
autocmd FileType typescript setlocal ts=2 sw=2 expandtab
autocmd FileType typescriptreact setlocal ts=2 sw=2 expandtab
autocmd FileType dart setlocal ts=2 sw=2 expandtab
autocmd FileType json setlocal ts=2 sw=2 expandtab

" Set expand width for Low level languages
autocmd FileType c setlocal ts=2 sw=2 expandtab
autocmd FileType h setlocal ts=2 sw=2 expandtab
autocmd FileType cpp setlocal ts=2 sw=2 expandtab
autocmd FileType hpp setlocal ts=2 sw=2 expandtab
autocmd FileType rust setlocal ts=4 sw=4 expandtab
autocmd FileType go setlocal ts=4 sw=4 expandtab

" Set expand width for scripting languages
autocmd FileType sh setlocal ts=2 sw=2 expandtab
autocmd FileType zsh setlocal ts=2 sw=2 expandtab
autocmd FileType fish setlocal ts=2 sw=2 expandtab
autocmd FileType vim setlocal ts=2 sw=2 expandtab
autocmd FileType bash setlocal ts=2 sw=2 expandtab
autocmd FileType lisp setlocal ts=2 sw=2 expandtab
autocmd FileType pl setlocal ts=2 sw=2 expandtab
autocmd FileType py setlocal ts=4 sw=4 expandtab

" Set expand width to 2 for markdown
autocmd FileType md setlocal ts=2 sw=2 expandtab
autocmd FileType markdown setlocal ts=2 sw=2 expandtab

" Run xrdb whenever Xdefaults or Xresources are updated.
autocmd BufWritePost *Xresources,*Xdefaults !xrdb %

" Comile any latex document into pdf form
autocmd BufWritePost answers.tex !pdflatex answers.tex

" Compile markdown notes to pdf
autocmd BufWritePost notes.md !pandoc -s -o notes.pdf notes.md

" =============================================================================
" Code folding:
" https://www.linux.com/training-tutorials/vim-tips-folding-fun/#:~:text=Open%20it%20in%20Vim%2C%20and,and%20the%20next%20two%20lines.
" =============================================================================
augroup weblang_folding
  au!
  au FileType javascript setlocal foldmethod=marker
  au FileType typescript setlocal foldmethod=marker
  au FileType html setlocal foldmethod=marker
  au FileType css setlocal foldmethod=marker
  au FileType scss setlocal foldmethod=marker
augroup END

augroup scriptlang_folding
  au!
  au FileType sh setlocal foldmethod=marker
  au FileType bash setlocal foldmethod=marker
  au FileType fish setlocal foldmethod=marker
  au FileType python setlocal foldmethod=marker
  au FileType perl setlocal foldmethod=marker
augroup END

augroup systemslang_folding
  au!
  au FileType cpp setlocal foldmethod=marker
  au FileType hpp setlocal foldmethod=marker
  au FileType c setlocal foldmethod=marker
  au FileType h setlocal foldmethod=marker
  au FileType rust setlocal foldmethod=marker
augroup END

" =============================================================================
" General Neovim settings and key mappings
" =============================================================================
" remap default leader key to comma
let mapleader = ";"

" mksession wrapper for use with vsm: https://github.com/mattcoding4days/vsm
if isdirectory(expand($VIM_SESSIONS))
  nnoremap mk :mksession $VIM_SESSIONS/
  nnoremap mo :mksession! $VIM_SESSIONS/
else
  nnoremap mk :echo "VIM_SESSIONS directory does not exist, get vim session manager at https://github.com/mattcoding4days/vsm"<CR>
  nnoremap mo :echo "VIM_SESSIONS directory does not exist, get vim session manager at https://github.com/mattcoding4days/vsm"<CR>
endif

" Reload nvim config
nnoremap <leader>vr :source $MYVIMRC<CR>

" Open init.vim in current buffer
nnoremap <leader>vc :e $MYVIMRC<CR>

" Open custom.vim in current buffer
nnoremap <leader>vx :e $HOME/.config/nvim/custom.vim<CR>

" Exit insert mode " 
inoremap jk <ESC>

" write and quit, no save
nnoremap <leader>wq :wq<CR>

" quit, no save
nnoremap <leader>q :q<CR>

" quit, abandon
nnoremap <leader>qq :q!<CR>

" buffer delete, only to be used on tabs
nnoremap <leader>bd :bdelete<CR>

" write current buffer
nnoremap <leader>w :w<CR>

" write all buffers
nnoremap <leader>wa :wa<CR>

" quit all
nnoremap <leader>qa :qa<CR>

" Split horizontally
nnoremap bb :HorizontalAndSwitch<CR>

" Split vertically
nnoremap vv :VerticalAndSwitch<CR>

" code folding
nnoremap <leader>fo :foldopen<CR>
nnoremap <leader>fc :foldclose<CR>

" Remap keys to move between splits easier
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" tab navigation mappings
map tt :tabnew
map <M-l> :tabn<CR>
imap <M-l> <ESC>:tabn<CR>
map <M-h> :tabp<CR>
imap <M-h> <ESC>:tabp<CR>

"" Make vim scroll faster
set ttyfast
set mouse=a
set lazyredraw
" Set numbers
set nu
set nowrap
set relativenumber
set encoding=UTF-8
" set tabline to not display full path
set guitablabel=%t

" tabs and spaces handling
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Global Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy "+yy

" Global Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" remove ugly vertical lines on window division
"set fillchars+=vert:\

" autocompletion of files and commands behaves like shell
" (complete only the common part, list the options that match)
set wildmode=list:longest

" save as sudo, must configure ask pass helper
ca w!! w !sudo tee "%"

" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=3

" clear search results
nnoremap <silent> // :noh<CR>

" clear empty spaces at the end of lines on save of python files
autocmd BufWritePre *.py :%s/\s\+$//e

" fix problems with uncommon shells (fish, xonsh) and plugins running commands
set shell=$SHELL

" Ability to add python breakpoints
" (I use ipdb, but you can change it to whatever tool you use for debugging)
au FileType python map <silent> <leader>b Oimport ipdb; ipdb.set_trace()<esc>

" =============================================================================
" Set colorscheme and Color rendering workarounds
" =============================================================================
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif
set background=dark
syntax enable

" Configure color scheme dark, or light
let ayucolor="dark"
let g:tokyonight_style = "night"
let g:tokyonight_italic_functions = 1
let g:tokyonight_sidebars = [ "qf", "vista_kind", "terminal", "packer" ]

" Change the "hint" color to the "orange" color, and make the "error" color bright red
let g:tokyonight_colors = {
  \ 'hint': 'orange',
  \ 'error': '#ff0000'
\ }

" use 256 colors when possible
if (&term =~? 'mlterm\|xterm\|xterm-256\|screen-256') || has('nvim')
  let &t_Co = 256
  colorscheme tokyonight
else
  colorscheme ayu
endif

" =============================================================================
" Include custom configurations and plugin configurations
" =============================================================================
if filereadable(expand("~/.config/nvim/custom.vim"))
  source ~/.config/nvim/custom.vim
endif
