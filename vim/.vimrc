set nocompatible

" Automatically load the plug-in manager
let pluginsInstalled=1
if empty(glob('~/.vim/autoload/plug.vim')) && executable('curl')
	let pluginsInstalled=0
	silent !curl --create-dirs -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Plug-ins
call plug#begin()

" Vim behavior
Plug 'editorconfig/editorconfig-vim'
Plug 'ConradIrwin/vim-bracketed-paste'

" Display
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'Yggdroot/indentLine'

" File navigation
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-vinegar'
Plug 'troydm/easytree.vim', { 'on' : 'EasyTreeToggle' }

" Programming
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Helpers
Plug 'tpope/vim-abolish', { 'on' : ['S', '<Plug>Coerce'] }
Plug 'mbbill/undotree', { 'on' : 'UndotreeToggle' }
Plug 'justinmk/vim-sneak', { 'on' : ['<Plug>(SneakStreak)', '<Plug>(SneakStreakBackward)'] }
Plug 'junegunn/vim-easy-align', { 'on' : '<Plug>(EasyAlign)' }
Plug 'tpope/vim-repeat'

" File-types
Plug 'jelera/vim-javascript-syntax', { 'for' : 'javascript' }
Plug 'pangloss/vim-javascript', { 'for' : 'javascript' }
Plug 'kchmck/vim-coffee-script', { 'for' : 'coffee' }
Plug 'hail2u/vim-css3-syntax', { 'for' : ['css', 'scss', 'html'] }
Plug 'cakebaker/scss-syntax.vim', { 'for' : 'scss' }
Plug 'groenewege/vim-less', { 'for' : 'less' }
Plug 'wavded/vim-stylus', { 'for' : 'stylus' }

if filereadable(expand('~/.vimrc.plugins')) | source ~/.vimrc.plugins | endif
call plug#end()

" Install plug-ins if needed
if pluginsInstalled == 0 | :PlugInstall | endif
unlet pluginsInstalled

" MatchIt plug-in
runtime macros/matchit.vim

" General settings
set lazyredraw spell splitbelow splitright nowritebackup noswapfile backspace=indent,eol,start tags=./tags;/ pastetoggle=<F2>
if has('mouse') | set mouse=a ttymouse=xterm2 | endif

" User interface
set number nowrap scrolloff=1 laststatus=2
let &colorcolumn='81,'.join(range(121, 375), ',')
if has('gui_running') | set lines=60 columns=120 guioptions-=T | endif

" Color scheme
set background=dark
colorscheme solarized

" Search and replace
set ignorecase smartcase incsearch hlsearch

" Indentation
set autoindent shiftround expandtab tabstop=2 shiftwidth=2

" Folding
set nofoldenable foldmethod=indent

" Autocomplete
set wildmenu wildmode=longest:full,full wildignore+=*.jpg,*.gif,*.png,*.ico,.git/,.vagrant/,.sass-cache/

" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" File-type dependent settings
autocmd FileType javascript call JavaScriptFold()
autocmd FileType php,python setlocal tabstop=4 shiftwidth=4

" Mappings
let mapleader=','
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>
nnoremap <Leader>/ :nohlsearch<CR>
nnoremap <Leader>r :redraw!<CR>
map ; : | noremap ;; ;

" Yank into the clipboard
nnoremap <Leader>y "*y
xnoremap <Leader>y "*y

" Tabs
nnoremap <Leader>t :tabnew<CR>

" Navigate by displayed lines when wrapped
noremap j gj
noremap k gk

" Split window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Insert mode navigation
inoremap <C-a> <ESC>I
inoremap <C-e> <ESC>A

" File list navigation
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [c :cprevious<CR>
nnoremap ]c :cnext<CR>

" Helpers
if executable('curl')
	nnoremap <Leader>html :read !curl -sS https://raw.githubusercontent.com/h5bp/html5-boilerplate/master/dist/index.html<CR>
endif

" Airline
let g:airline_powerline_fonts=1

" IndentLine
let g:indentLine_char='│'

" CtrlP
let g:ctrlp_working_path_mode=0
let g:ctrlp_switch_buffer='et'
let g:ctrlp_tabpage_position='al'
if executable('grep') | let filter=' | grep -Evi "\.jpg$|\.gif$|\.png$|\.ico$|\.git/|\.vagrant/|\.sass-cache/"' | else | let filter='' | endif
if executable('ag')
	set grepprg=ag\ --vimgrep\ $* grepformat=%f:%l:%c:%m
	let g:ctrlp_user_command='ag --nocolor --hidden -lg "" %s' . filter
elseif executable('find')
	let g:ctrlp_user_command='find %s -type f' . filter
endif

" EasyTree
nnoremap <Leader>T :EasyTreeToggle<CR>
let g:easytree_hijack_netrw=0

" Autoformat
nnoremap <Leader>gq :Autoformat<CR>

" UltiSnips
let g:UltiSnipsJumpForwardTrigger='<Tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'

" Abolish
nmap cr <Plug>Coerce

" Undotree
nnoremap <Leader>u :UndotreeToggle<CR>

" Sneak
nmap s <Plug>(SneakStreak)
nmap S <Plug>(SneakStreakBackward)
highlight link SneakPluginTarget Special
highlight link SneakStreakTarget Special
highlight link SneakStreakMask Comment

" EasyAlign
vmap <Enter> <Plug>(EasyAlign)
