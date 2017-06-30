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

" Display
Plug 'chriskempson/base16-vim'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" File navigation
Plug 'justinmk/vim-dirvish'
Plug 'junegunn/fzf', { 'on' : 'FZF', 'dir' : '~/.fzf', 'do' : 'yes \| ./install' }
Plug 'troydm/easytree.vim', { 'on' : 'EasyTreeToggle' }

" Programming
Plug 'w0rp/ale'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'marcweber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'ludovicchabant/vim-gutentags'
Plug 'diepm/vim-rest-console', { 'for' : 'rest' }

" Helpers
Plug 'tpope/vim-abolish', { 'on' : ['S', '<Plug>Coerce'] }
Plug 'mbbill/undotree', { 'on' : 'UndotreeToggle' }
Plug 'junegunn/vim-easy-align', { 'on' : '<Plug>(EasyAlign)' }
Plug 'bronson/vim-visual-star-search'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-repeat'

" File-types
Plug 'jelera/vim-javascript-syntax', { 'for' : 'javascript' }
Plug 'hail2u/vim-css3-syntax', { 'for' : ['css', 'scss', 'html'] }
Plug 'sheerun/vim-polyglot'

if filereadable(expand('~/.vimrc.plugins')) | source ~/.vimrc.plugins | endif
call plug#end()

" Install plug-ins if needed
if pluginsInstalled == 0 | :PlugInstall | endif
unlet pluginsInstalled

" MatchIt plug-in
packadd! matchit

" General settings
set lazyredraw spell splitbelow splitright noswapfile nowritebackup backspace=indent,eol,start list listchars=tab:»·,trail:· pastetoggle=<F2> tags=./tags;,tags
if has('mouse') && !has('nvim') | set mouse=a ttymouse=xterm2 | endif
if executable('rg') | let grepCommand='rg' | elseif executable('ag') | let grepCommand='ag' | endif
if exists('grepCommand') | let &grepprg=grepCommand.' --vimgrep' | set grepformat=%f:%l:%c:%m | unlet grepCommand | endif

" User interface
set number nowrap scrolloff=1 laststatus=2
if has('gui_running') | set lines=60 columns=120 guioptions-=T | endif

" Color scheme
colorscheme base16-default-dark

" Search and replace
set ignorecase smartcase incsearch hlsearch

" Indentation
set autoindent shiftround expandtab tabstop=2 shiftwidth=2

" Folding
set nofoldenable foldmethod=indent

" Autocomplete
set completeopt=longest,menuone
set wildmenu wildmode=longest:full,full

" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" File-type dependent settings
autocmd FileType php,python setlocal tabstop=4 shiftwidth=4

" Mappings
let mapleader=' '
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>
nnoremap <Leader>/ :nohlsearch<CR>
nnoremap <Leader>r :redraw!<CR>
nnoremap K i<CR><Esc>d^==kg_lD
inoremap <Tab> <C-x><C-o>
map ; : | noremap ;; ;

" Yank/paste using the system clipboard
nnoremap <Leader>y "*y | xnoremap <Leader>y "*y
nnoremap <Leader>p "*p | xnoremap <Leader>p "*p
nnoremap <Leader>P "*P | xnoremap <Leader>P "*P

" Change/delete to black hole register
nnoremap <Leader>c "_c | xnoremap <Leader>c "_c
nnoremap <Leader>d "_d | xnoremap <Leader>d "_d

" Navigate by displayed lines when wrapped
noremap j gj
noremap k gk

" Tab navigation
nnoremap <Leader><Tab> :$tabnew<CR>
nnoremap <Tab> <C-PageDown>
nnoremap <S-Tab> <C-PageUp>

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
nnoremap [B :bfirst<CR>
nnoremap ]B :blast<CR>
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>

" Helpers
if executable('curl')
	nnoremap <Leader>html :read !curl -sS https://raw.githubusercontent.com/h5bp/html5-boilerplate/master/dist/index.html<CR>
endif

" Airline
let g:airline_extensions=[]
let g:airline_powerline_fonts=1
let g:airline_theme='base16'

" FZF Fuzzy Finder
nnoremap <Leader>f :FZF -m<CR>

" EasyTree
nnoremap <Leader>t :EasyTreeToggle<CR>
let g:easytree_hijack_netrw=0

" Autoformat
noremap <Leader>gq :Autoformat<CR>

" SnipMate
imap <S-Tab> <Plug>snipMateNextOrTrigger

" REST Console
let g:vrc_curl_opts={
	\'--include': '',
	\'--location': '',
	\'--show-error': '',
	\'--silent': ''
\}

" Abolish
nmap cr <Plug>Coerce

" Undotree
nnoremap <Leader>u :UndotreeToggle<CR>

" EasyAlign
vmap <Enter> <Plug>(EasyAlign)

" Sneak
nmap f <Plug>Sneak_f| nmap F <Plug>Sneak_F| xmap f <Plug>Sneak_f| xmap F <Plug>Sneak_F| omap f <Plug>Sneak_f| omap F <Plug>Sneak_F
nmap t <Plug>Sneak_t| nmap T <Plug>Sneak_T| xmap t <Plug>Sneak_t| xmap T <Plug>Sneak_T| omap t <Plug>Sneak_t| omap T <Plug>Sneak_T
nmap s <Plug>(SneakStreak)| nmap S <Plug>(SneakStreakBackward)
highlight link SneakPluginTarget Identifier | highlight link SneakStreakTarget Identifier | highlight link SneakStreakMask Comment
let g:sneak#s_next=1
