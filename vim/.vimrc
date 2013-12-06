" Vundle plug-in manager
set nocompatible
filetype off

set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'altercation/vim-colors-solarized'
Bundle 'bling/vim-airline'
Bundle 'editorconfig/editorconfig-vim'
Bundle 'kien/ctrlp.vim'
Bundle 'troydm/easytree.vim'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Raimondi/delimitMate'
Bundle 'tpope/vim-surround'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/syntastic'
Bundle 'mattn/emmet-vim'
Bundle 'maksimr/vim-jsbeautify'

filetype plugin indent on

" MatchIt plug-in
runtime macros/matchit.vim

" General settings
set noswapfile
set spell
set backspace=indent,eol,start
set splitbelow splitright

" User interface
set scrolloff=1
set laststatus=2
set nowrap
set number
if has("gui_running")
	set lines=40 columns=80
	set guioptions-=T
endif

" Color scheme
syntax enable
set background=dark
colorscheme solarized

" Search and replace
set ignorecase

" Indentation
set tabstop=2 shiftwidth=2
set autoindent

" Autocomplete
set wildmenu wildmode=longest:full,full
set wildignore=*.jpg,*.gif,*.png,*.swf,*.gz,*.swp,.git/*,.svn/*,.DS_Store,Thumbs.db

" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" File type dependent settings
autocmd FileType php,cf,html,css,scss,javascript set foldmethod=indent nofoldenable autoindent
autocmd FileType ruby set foldmethod=syntax nofoldenable

" Mappings
let mapleader=","
nmap <Leader>cd :cd %:p:h<CR>:pwd<CR>

" Tabs
nmap <C-t> :tabnew<CR>
nmap <C-tab> :tabnext<CR>
nmap <C-S-tab> :tabprevious<CR>

" Split window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Navigate by displayed lines when wrapped
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

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

" EasyTree mappings and settings
nmap <Leader>t :EasyTree<CR>
let g:easytree_width_auto_fit=1

" Pad comments with a space
let NERDSpaceDelims=1

" Smart tab completion for Emmet
function! s:smart_tab_completion()
	let line = getline('.')
	let to_cursor = strpart(line, 0, col('.') - 1)
	let previous_character = matchstr(to_cursor, '[^ \t">]$')

	if (strlen(previous_character) > 0)
		return "\<plug>(EmmetExpandAbbr)"
	endif

	return "\<tab>"
endfunction
imap <expr><tab> <sid>smart_tab_completion()
let g:user_emmet_mode='i'

" JsBeautify mappings
autocmd FileType javascript noremap <buffer> <Leader>b :call JsBeautify()<CR>
autocmd FileType html noremap <buffer> <Leader>b :call HtmlBeautify()<CR>
autocmd FileType scss,css noremap <buffer> <Leader>b :call CSSBeautify()<CR>
