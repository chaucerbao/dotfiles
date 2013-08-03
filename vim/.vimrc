" Vundle plug-in manager
set nocompatible
filetype off

set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'altercation/vim-colors-solarized'
Bundle 'kien/ctrlp.vim'
Bundle 'Raimondi/delimitMate'
Bundle 'tpope/vim-surround'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/syntastic'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'vim-scripts/HTML-AutoCloseTag'
Bundle 'maksimr/vim-jsbeautify'
Bundle 'kchmck/vim-coffee-script'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'honza/vim-snippets'
Bundle 'garbas/vim-snipmate'

filetype plugin indent on

" MatchIt plug-in
runtime macros/matchit.vim

" General settings
set noswapfile
set spell
set backspace=indent,eol,start

" User interface
set lines=40 columns=80
set scrolloff=1
set guioptions-=T
set nowrap
set number

" Color scheme
syntax enable
set background=dark
colorscheme solarized

" Search and replace
set ignorecase

" Indentation
set tabstop=2 shiftwidth=2
set autoindent

" Folding
autocmd BufRead,BufNewFile *.php,*.cf[cm],*.html,*.css,*.scss,*.js,*.coffee set foldmethod=indent nofoldenable

" Autocomplete
set wildmenu wildmode=longest:full,full
set wildignore=*.jpg,*.gif,*.png,*.swf,*.gz,*.swp,.git/*,.svn/*,.DS_Store,Thumbs.db

" Filetype associations for files with mixed types
autocmd BufRead,BufNewFile *.php set filetype=php.html
autocmd BufRead,BufNewFile *.cfm set filetype=cf.html

" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Mappings
let mapleader=","
nmap <Leader>cd :cd %:p:h<CR>:pwd<CR>
nmap <C-t> :tabnew<CR>
nmap <C-tab> :tabnext<CR>
nmap <C-S-tab> :tabprevious<CR>

" Cut, Copy, and Paste for Windows environments
if has('win32') || has('win64')
	vnoremap <C-x> "+x
	vnoremap <C-c> "+y
	map <C-v> "+gP
	cmap <C-v> <C-r>+
	exe 'inoremap <script> <C-v> <C-g>u' . paste#paste_cmd['i']
endif

" Don't let CtrlP manage the working directory
let g:ctrlp_working_path_mode=0

" CoffeeScript Settings
let coffee_compile_vert=1

" Pad comments with a space
let NERDSpaceDelims=1

" JsBeautify mappings
autocmd FileType javascript noremap <buffer> <Leader>b :call JsBeautify()<CR>
autocmd FileType html noremap <buffer> <Leader>b :call HtmlBeautify()<CR>
autocmd FileType scss,css noremap <buffer> <Leader>b :call CSSBeautify()<CR>
