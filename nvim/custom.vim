" ============================================================================
" Plugins settings and mappings
" Edit them as you wish.
" ============================================================================

" ============================================================================
" VimWiki
" ============================================================================
" Set path to hold all wiki information, and prefer markdown syntax over wiki
" syntax
let g:vimwiki_list = [{'path': '~/.config/vimwiki',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

" ============================================================================
" Startify 
" ============================================================================
let g:startify_custom_header_quotes = [
    \ [' Linux gives us the power we need to', '      crush those who oppose us'],
    \ [' https://github.com/mattcoding4days/MattDev_NvimConfig '],
    \ [' Arch isnt that hard to install'],
    \ [' Linux for human beings'],
    \ [' Compile your binaries.. check your version dependencies'],
    \ [' Steve the Super Villain', '  https://www.youtube.com/watch?v=8LsxmQV8AXk']
    \ ]

"let g:startify_ascii = [
      "\ '        ____                                  _____      ',
      "\ '    .+-|____|-.---------------------------.--|_____|-+.   ',
      "\ '   /   |     |  ".        S O N Y        ."  |  _  |   \  ',
      "\ '  / ___| /|\ |___ \                     / ___| /_\ |___ \ ',
      "\ ' / |      |      | ;  __           _   ; | _         _ | ;',
      "\ ' | | <---   ---> | | |__|         |_:> | ||_|       (_)| |',
      "\ ' | |___   |   ___| ;SELECT       START ; |___       ___| ;',
      "\ ' |\    | \|/ |    /  _     ___      _   \    | (X) |    /|',
      "\ ' | \   |_____|  .","   ", |___|  ,"   ", ".  |_____|  ." |',
      "\ ' |  "-.______.-" /       \ANALOG/       \  "-._____.-"   |',
      "\ ' |               |       |------|       |                |',
      "\ ' |              /\       /      \       /\               |',
      "\ ' \             /  ".___."        ".___."  \              /',
      "\ '  \           /                            \            /',
      "\ '   \_________/                              \__________/  ',
"\]

let g:startify_ascii = [
      \ '                                        ▝▘            ',
      \ '██▃▅▇█▆▖  ▗▟████▙▖   ▄████▄   ██▄  ▄██  ██  ▗▟█▆▄▄▆█▙▖',
      \ '██▛▔ ▝██  ██▄▄▄▄██  ██▛▔▔▜██  ▝██  ██▘  ██  ██▛▜██▛▜██',
      \ '██    ██  ██▀▀▀▀▀▘  ██▖  ▗██   ▜█▙▟█▛   ██  ██  ██  ██',
      \ '██    ██  ▜█▙▄▄▄▟▊  ▀██▙▟██▀   ▝████▘   ██  ██  ██  ██',
      \ '▀▀    ▀▀   ▝▀▀▀▀▀     ▀▀▀▀       ▀▀     ▀▀  ▀▀  ▀▀  ▀▀',
      \]

"let g:startify_ascii = [
      "\ ' ,---,---,---,---,---,---,---,---,---,---,---,---,---,-------, ',
      "\ ' | ~ | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0 | [ | ] | <-    | ',
      "\ ' |--- -,- -,- -,- -,- -,- -,- -,- -,- -,- -,- -,- -,- -,-----| ',
      "\ ' | ->| | " | , | . | P | Y | F | G | C | R | L | / | = |  \  | ',
      "\ ' |----- ,--,-- ,-- ,-- ,-- ,-- ,-- ,-- ,-- ,-- ,-- ,-- ------| ',
      "\ ' | Caps | A | O | E | U | I | D | H | T | N | S | - |  Enter | ',
      "\ ' |------ -,- -,- -,- -,- -,- -,- -,- -,- -,- -,- -,- --------| ',
      "\ ' |        | ; | Q | J | K | X | B | M | W | V | Z |          | ',
      "\ ' |------,- ,-- --, --- --- --- --- --- --- -,- --- ,--,------| ',
      "\ ' | ctrl |  | alt |                          | alt  |  | ctrl | ',
      "\ '  ------    ----- -------------------------- ------    ------  ', ]

let g:startify_custom_header =
      \ 'startify#center(g:startify_ascii)'

let g:startify_custom_footer =
      \ 'startify#center(startify#fortune#boxed())'

let g:startify_session_sort = 1
let g:startify_fortune_use_unicode = 1
let g:startify_change_to_vcs_root = 1
let g:startify_update_oldfiles = 1
let g:startify_use_env = 1

autocmd User Startified setlocal cursorline

" ============================================================================
" Typescript syntax highlighting
" ============================================================================
" This plugin has a custom indenter, sometimes it fails, disable it here
let g:typescript_indent_disable = 1

" ============================================================================
" Neoformat shortcut
" ============================================================================
nnoremap <leader>f :<C-u>Neoformat<CR>

" ============================================================================
" Latex preview
" ============================================================================
let g:livepreview_previewer = '$READER'
let g:livepreview_use_biber = 1
nmap <leader>lp :LLPStartPreview<CR>

" ============================================================================
" Tagbar
" ============================================================================
" toggle tagbar display
nmap <leader>tb :TagbarToggle<CR>
" autofocus on tagbar open
let g:tagbar_autofocus = 1

" ============================================================================
" Tasklist
" ============================================================================
" show pending tasks list
map <leader>tl :TaskList<CR>

" ============================================================================
" NERDTree
" ============================================================================
" toggle nerdtree display
nmap <leader>nn :NERDTreeToggle<CR>
" open nerdtree with the current file selected
nmap <leader>nf :NERDTreeFind<CR>
" don;t show these file types
let NERDTreeIgnore = ['\.pyc$', '\.pyo$']

" ============================================================================
" Neomake
" ============================================================================
" Run linter on write
autocmd! BufWritePost * Neomake
" Check code as python3 by default
let g:neomake_python_python_maker = neomake#makers#ft#python#python()
let g:neomake_python_flake8_maker = neomake#makers#ft#python#flake8()
let g:neomake_python_python_maker.exe = 'python3 -m py_compile'
let g:neomake_python_flake8_maker.exe = 'python3 -m flake8'
" Disable error messages inside the buffer, next to the problematic line
let g:neomake_virtualtext_current_error = 1

" ============================================================================
" Fzf
" ============================================================================
" file finder mapping
nmap <leader>ff :Files<CR>
" tags (symbols) in current file finder mapping
nmap <leader>ct :BTag<CR>
" tags (symbols) in all files finder mapping
nmap <leader>at :Tags<CR>
" general code finder in current file mapping
nmap <leader>fz :BLines<CR>
" general code finder in all files mapping
nmap <leader>af :Lines<CR>
" commands finder mapping
nmap <leader>co :Commands<CR>

" ============================================================================
" Git Blame - Displays git blame information on the current line
" ============================================================================
" start blamer on neovim open
let g:blamer_enabled = 1
" the delay for showing blame information, setting too low will result in
" performance issues
let g:blamer_delay = 1000
highlight Blamer guifg=LightBlue


" ============================================================================
" Git Signify - Displays git diff icons in the gutter
" ============================================================================
" this first setting decides in which order try to guess your current vcs
" UPDATE it to reflect your preferences, it will speed up opening files
let g:signify_vcs_list = [ 'git' ]
" mappings to jump to changed blocks
nmap <leader>sn <plug>(signify-next-hunk)
nmap <leader>sp <plug>(signify-prev-hunk)

" ============================================================================
" Git Signify
" ============================================================================

" nicer colors
highlight DiffAdd           cterm=bold ctermbg=none ctermfg=119
highlight DiffDelete        cterm=bold ctermbg=none ctermfg=167
highlight DiffChange        cterm=bold ctermbg=none ctermfg=227
highlight SignifySignAdd    cterm=bold ctermbg=237  ctermfg=119
highlight SignifySignDelete cterm=bold ctermbg=237  ctermfg=167
highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227

" ============================================================================
" Autoclose
" ============================================================================
" Fix to let ESC work as espected with Autoclose plugin
" (without this, when showing an autocompletion window, ESC won't leave insert mode)
let g:AutoClosePumvisible = {"ENTER": "\<C-Y>", "ESC": "\<ESC>"}
let g:AutoClosePairs = "() {} [] ' ` \" "

" ============================================================================
" Goyo mappings 
" ============================================================================
nmap <leader>dd :Goyo 100x60<CR>

" ============================================================================
" Rainbow brackets
" ============================================================================
" init rainbow brackets
"set to 0 if you want to enable it later via :RainbowToggle
let g:rainbow_active = 1

" ============================================================================
" Emmet mappings < this might be deprecated soon >
" ============================================================================
let g:user_emmet_mode='a'  " enable all functions in all modes
let g:user_emmet_leader_key='<C-S>'

" ============================================================================
" Devicon 
" ============================================================================
" loading the plugin
let g:webdevicons_enable = 1

" ============================================================================
" Airline
" ============================================================================
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_theme='gruvbox'

" ============================================================================
" Floaterm
" ============================================================================
let g:floaterm_position      = 'center'
let g:floaterm_wintype       = 'floating'
let g:floaterm_height        = 0.8
let g:floaterm_width         = 0.8

" custom mappings for my personal tools in normal mode only A = Alt key
" Launch ipython in Floaterm
nnoremap <leader>pp :FloatermNew ipython<CR>

" Launch the ranger terminal file manager in Floaterm
nnoremap <leader>rr :FloatermNew ranger<CR>

" double tap 's', it makes it load faster
nnoremap <leader>ss :FloatermNew sefr<CR>

" Toggle an instance of Floaterm
nnoremap <leader>tt :FloatermToggle<CR>

" kill isntance of FloatermNew if you have too many
nnoremap <leader>kk :FloatermKill<CR>

" ============================================================================
" Conquer of Compiletion
" ----------------------
" This configuration is directly from the Coc github.
" Any coc extension specific configuration should go under
" this banner.
" ============================================================================
" Use autocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" Fancy markdown syntax
let g:markdown_fenced_languages = ['css', 'js=javascript']

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
"nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>fr  <Plug>(coc-format-selected)
nmap <leader>fr  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{StatusDiagnostic()}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Auto command for python projects
autocmd FileType python let b:coc_root_patterns = ['.git', '.env']

" Auto command for correct comment highlighting in Json files
autocmd FileType json syntax match Comment +\/\/.\+$+
" status line function
function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, 'E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif
  return join(msgs, ' ') . ' ' . get(g:, 'coc_status', '')
endfunction

" Disable node version warning
let g:coc_disable_startup_warning = 1

" Vim script coc extension: Fancy markdown syntax
let g:markdown_fenced_languages = [
      \ 'vim',
      \ 'help'
      \]
