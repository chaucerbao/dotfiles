" Automatically load the plug-in manager
let pluginsInstalled=1
if empty(glob('~/.vim/autoload/plug.vim')) && executable('curl')
	let pluginsInstalled=0
	silent !curl --create-dirs -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Plug-ins
call plug#begin()

" Themes
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'

" File navigation
Plug 'justinmk/vim-dirvish'
Plug 'junegunn/fzf', { 'on': 'FZF', 'dir': '~/.fzf', 'do': './install --all' }

" Programming
Plug 'w0rp/ale'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'alvan/vim-closetag'
Plug 'jiangmiao/auto-pairs'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'sbdchd/neoformat'
Plug 'joereynolds/vim-minisnip'
Plug 'ludovicchabant/vim-gutentags'
Plug 'diepm/vim-rest-console', { 'for': 'rest' }

" Helpers
Plug 'tpope/vim-abolish', { 'on': ['S', '<Plug>Coerce'] }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(EasyAlign)' }
Plug 'chaucerbao/vim-clevertab'
Plug 'bronson/vim-visual-star-search'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-repeat'

" File-types
Plug 'Quramy/tsuquyomi', { 'for': ['javascript', 'typescript'] }
Plug 'sheerun/vim-polyglot'

if filereadable(expand('~/.vimrc.plugins')) | source ~/.vimrc.plugins | endif
call plug#end()

" Install plug-ins if needed
if pluginsInstalled == 0 | :PlugInstall | endif
unlet pluginsInstalled

" MatchIt plug-in
packadd! matchit

" General settings
set hidden lazyredraw spell splitbelow splitright noswapfile nowritebackup backspace=indent,eol,start list listchars=tab:»·,trail:· pastetoggle=<F2> tags=./tags;,tags
if has('mouse') && !has('nvim') | set mouse=a ttymouse=xterm2 | endif
if executable('rg') | let grepCommand='rg' | elseif executable('ag') | let grepCommand='ag' | endif
if exists('grepCommand') | let &grepprg=grepCommand.' --smart-case --vimgrep' | set grepformat=%f:%l:%c:%m | unlet grepCommand | endif

" User interface
set number nowrap scrolloff=1 laststatus=2

" Color scheme
colorscheme onedark

" Search and replace
set ignorecase smartcase incsearch hlsearch

" Indentation
set autoindent shiftround expandtab tabstop=2 shiftwidth=2

" Folding
set nofoldenable foldmethod=indent

" Autocompletion
set complete-=t,i
set completeopt=longest,menuone
set wildmenu wildmode=longest:full,full

" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Open QuickFix/Location List automatically
autocmd QuickFixCmdPost [^l]* cwindow
autocmd QuickFixCmdPost l* lwindow

" Mappings
let mapleader=' '
nnoremap <Leader>cd :lcd %:p:h<CR>:pwd<CR>
nnoremap <Leader>/ :nohlsearch<CR>
nnoremap <Leader>r :redraw!<CR>
nnoremap K i<CR><Esc>d^==kg_lD
nnoremap ; : | nnoremap : ; | vnoremap ; : | vnoremap : ;

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

" Buffer navigation
nnoremap <Leader>b :buffers<CR>:buffer<Space>

" Tab navigation
nnoremap <Leader><Tab> :$tabnew<CR>

" Split window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Insert mode navigation
inoremap <C-a> <Esc>I
inoremap <C-e> <Esc>A

" Buffer/Quickfix/Location list navigation
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [B :bfirst<CR>
nnoremap ]B :blast<CR>
nnoremap [q :cprevious<CR>zz
nnoremap ]q :cnext<CR>zz
nnoremap [Q :cfirst<CR>zz
nnoremap ]Q :clast<CR>zz
nnoremap [l :lprevious<CR>zz
nnoremap ]l :lnext<CR>zz
nnoremap [L :lfirst<CR>zz
nnoremap ]L :llast<CR>zz

" Helpers
if executable('curl')
	nnoremap <Leader>html :read !curl -sS https://raw.githubusercontent.com/h5bp/html5-boilerplate/master/dist/index.html<CR>
endif

" Lightline
let g:lightline={
	\'colorscheme': 'onedark',
	\'active': { 'left': [['mode', 'paste'], ['gitbranch', 'filename', 'readonly', 'modified']] },
	\'component': { 'lineinfo': '%3l:%-2v' },
	\'component_function': { 'gitbranch': 'fugitive#head' },
	\'separator': { 'left': '', 'right': '' },
	\'subseparator': { 'left': '', 'right': '' }
\}

" FZF Fuzzy Finder
nnoremap <Leader>f :FZF -m<CR>

" Close Tags
let g:closetag_filenames='*.html,*.jsx,*.tsx'

" Neoformat
noremap <Leader>gq :Neoformat<CR>
let g:neoformat_enabled_javascript=['prettiereslint', 'prettier']
let g:neoformat_enabled_css=['stylefmt', 'prettier']
let g:neoformat_enabled_scss=['stylefmt', 'prettier']

" Minisnip
let g:minisnip_trigger='<Nop>'

" Gutentags
let g:gutentags_cache_dir='/tmp/gutentags'

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

" CleverTab
inoremap <silent><Tab> <C-r>=CleverTab#Complete('start')<CR>
	\<C-r>=CleverTab#Complete('tab')<CR>
	\<C-r>=CleverTab#Complete('minisnip')<CR>
	\<C-r>=CleverTab#Complete('omni')<CR>
	\<C-r>=CleverTab#Complete('file')<CR>
	\<C-r>=CleverTab#Complete('keyword')<CR>
	\<C-r>=CleverTab#Complete('stop')<CR>
inoremap <silent><S-Tab> <C-r>=CleverTab#Complete('prev')<CR>

" Visual Star Search
nnoremap <Leader>* :silent execute 'grep "' . substitute(escape(expand('<cword>'), '\'), '\n', '\\n', 'g') . '"'<CR>:redraw!<CR>
vnoremap <Leader>* :<C-u>call VisualStarSearchSet('/')<CR>:silent execute 'grep "' . @/ . '"'<CR>:redraw!<CR>

" Sneak
map f <Plug>Sneak_f| map F <Plug>Sneak_F| sunmap f| sunmap F
map t <Plug>Sneak_t| map T <Plug>Sneak_T| sunmap t| sunmap T
map : <Plug>Sneak_;| sunmap :
let g:sneak#label=1
let g:sneak#s_next=1

" Tsuquyomi
let g:tsuquyomi_completion_detail=1
let g:tsuquyomi_disable_quickfix=1
let g:tsuquyomi_javascript_support=1
