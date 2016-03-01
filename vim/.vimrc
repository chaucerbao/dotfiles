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

" Display
Plug 'chriskempson/base16-vim'
Plug 'bling/vim-airline'

" File navigation
Plug 'tpope/vim-vinegar'
Plug 'junegunn/fzf', { 'on' : 'FZF', 'dir' : '~/.fzf', 'do' : 'yes \| ./install' }
Plug 'troydm/easytree.vim', { 'on' : 'EasyTreeToggle' }

" Programming
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'Chiel92/vim-autoformat'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

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
Plug 'cakebaker/scss-syntax.vim', { 'for' : 'scss' }
Plug 'sheerun/vim-polyglot'

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
if executable('ag') | set grepprg=ag\ --vimgrep\ $* grepformat=%f:%l:%c:%m | endif

" User interface
set number nowrap scrolloff=1 laststatus=2
if has('gui_running') | set lines=60 columns=120 guioptions-=T | endif

" Color scheme
set background=dark
colorscheme base16-tomorrow

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

" Yank/paste using the system clipboard
nnoremap <Leader>y "*y | xnoremap <Leader>y "*y
nnoremap <Leader>p "*p | xnoremap <Leader>p "*p
nnoremap <Leader>P "*P | xnoremap <Leader>P "*P

" Delete to black hole register
nnoremap <Leader>d "_d | xnoremap <Leader>d "_d

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

" FZF Fuzzy Finder
nnoremap <Leader>f :FZF -m<CR>

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

" EasyAlign
vmap <Enter> <Plug>(EasyAlign)

" Sneak
nmap f <Plug>Sneak_f| nmap F <Plug>Sneak_F| xmap f <Plug>Sneak_f| xmap F <Plug>Sneak_F| omap f <Plug>Sneak_f| omap F <Plug>Sneak_F
nmap t <Plug>Sneak_t| nmap T <Plug>Sneak_T| xmap t <Plug>Sneak_t| xmap T <Plug>Sneak_T| omap t <Plug>Sneak_t| omap T <Plug>Sneak_T
nmap s <Plug>(SneakStreak)| nmap S <Plug>(SneakStreakBackward)
highlight link SneakPluginTarget Identifier | highlight link SneakStreakTarget Identifier | highlight link SneakStreakMask Comment
let g:sneak#s_next=1

" File-type options
let g:jsx_ext_required=0
