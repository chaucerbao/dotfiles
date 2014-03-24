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
Bundle 'scrooloose/nerdtree'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Raimondi/delimitMate'
Bundle 'tpope/vim-surround'
Bundle 'scrooloose/nerdcommenter'
Bundle 'junegunn/vim-easy-align'
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
set ignorecase smartcase hlsearch

" Indentation
set tabstop=2 shiftwidth=2
set autoindent shiftround

" Autocomplete
set wildmenu wildmode=longest:full,full
set wildignore=*.jpg,*.gif,*.png,*.swf,*.gz,*.swp,*/node_modules,.git/*,.svn/*,.DS_Store,Thumbs.db

" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" File type dependent settings
autocmd FileType php,cf,html,css,scss,javascript set foldmethod=indent nofoldenable autoindent
autocmd FileType ruby set foldmethod=syntax nofoldenable

" Tags
set tags=./tags;/

" Mappings
let mapleader=","
nmap <Leader>cd :cd %:p:h<CR>:pwd<CR>
nmap <Leader>/ :nohlsearch<CR>
nmap ; :

" Paste toggle
set pastetoggle=<F2>

" Tabs
nmap tn :tabnew<CR>
nmap tl :tabnext<CR>
nmap th :tabprevious<CR>
nmap tm :tabmove<Space>
nmap td :tabclose!<CR>

" Split window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Navigate by displayed lines when wrapped
nmap j gj
nmap k gk

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

" NERDTree mappings
nmap <Leader>t :NERDTreeToggle<CR>

" Pad comments with a space
let NERDSpaceDelims=1

" EasyMotion mappings
let g:EasyMotion_startofline=0
map s <Plug>(easymotion-s)
map <Leader>h <Plug>(easymotion-linebackward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>l <Plug>(easymotion-lineforward)

" EasyAlign mappings
vmap <Enter> <Plug>(EasyAlign)

" Smart tab completion for Emmet
function! s:smart_tab_completion()
	let line = getline('.')
	let to_cursor = strpart(line, 0, col('.') - 1)
	let previous_character = matchstr(to_cursor, '[^ \t">]$')

	if (strlen(previous_character) > 0)
		return "\<Plug>(emmet-expand-abbr)"
	endif

	return "\<Tab>"
endfunction
imap <expr><Tab> <SID>smart_tab_completion()
let g:user_emmet_mode='i'

" JsBeautify mappings
autocmd FileType javascript nmap <buffer> <Leader>b :call JsBeautify()<CR>
autocmd FileType html nmap <buffer> <Leader>b :call HtmlBeautify()<CR>
autocmd FileType scss,css nmap <buffer> <Leader>b :call CSSBeautify()<CR>

autocmd FileType javascript vmap <buffer> <Leader>b :call RangeJsBeautify()<CR>
autocmd FileType html vmap <buffer> <Leader>b :call RangeHtmlBeautify()<CR>
autocmd FileType scss,css vmap <buffer> <Leader>b :call RangeCSSBeautify()<CR>
